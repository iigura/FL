--[[
	outer.lua by Koji Iigura, 2017.
	F/L outer interpreter

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

Mode="interpret"
ErrorOccured=false

local kCompile,kInterpret="compile","interpret"
SetCompileMode  =function() Mode=kCompile end
SetInterpretMode=function() Mode=kInterpret end
IsCompileMode  	=function() return Mode==kCompile end
IsInterpretMode	=function() return Mode==kInterpret end

local isStringData=function(inStr)
	local c=string.sub(inStr,1,1)
	return c=='"' or c=="'"
end

local getToken=function()
	local token
	token,ScanPos=string.match(Line,"^([ \t\n\r]*)()", ScanPos)
	local c=string.sub(Line,ScanPos,ScanPos)
	if c=="'" then
		token,ScanPos=string.match(Line,"('.-')()",ScanPos)
	elseif c=='"' then
		token,ScanPos=string.match(Line,'(".-")()',ScanPos)
	else
		token,ScanPos=string.match(Line,"^([^ \t\n\r]*)()",ScanPos)
	end
	if token==nil then
		print("ERROR: string is not closed.")
		return nil
	end
	if token=="" then return nil end
	local t=tonumber(token)
	if t~=nil then
		return t
	else
		return token
	end
end

local errorHandler=function(inErrMsg)
	local msg=string.match(inErrMsg,"@:(.*)$")
	if msg=="" or msg==nil then
		print(inErrMsg)
	else
		print("F/L ERROR:"..msg)
	end
	ErrorOccured=true
end

local action={};
action.interpret={
	number=Push,
	string=function(inStr)
		if isStringData(inStr) then
			Push(string.sub(inStr,2,#inStr-1)) -- remove quote.
		else
			local element={Type=kWordType,Data=inStr}
			InnerInterpreter({element})
		end
	end
}
action.compile  ={
	number=function(inValue)
		if inValue==nil then
			error("@: can not compile 'nil' value.")
		else
			CompileValue(inValue)
		end
	end,
	string=function(inStr)
		if isStringData(inStr) then
			CompileValue(string.sub(inStr,2,#inStr-1))
		else
			local dict,wordName=GetDictByName(inStr)
			local wordNameWithDict
			if dict==nil then
				dict=Dict.object
				wordName=inStr
				wordNameWithDict="object$"..wordName
			else
				wordNameWithDict=inStr
			end
			if isImmediate(dict,wordName) then
				local element={Type=kWordType,Data=wordNameWithDict}
				InnerInterpreter({element})
			else
				Compile(wordName)
			end
		end
	end
}
isImmediate=function(inDict,inWordName)
	return inDict[inWordName]~=nil
	   and type(inDict[inWordName])=="table"
	   and inDict[inWordName].immediate
end

Line=""
ScanPos=1

OuterInterpreter=function(inLine)
	ErrorOccured=false
	Line=inLine; ScanPos=1; local tokVal=getToken()
	while tokVal and ErrorOccured==false do
		xpcall(action[Mode][type(tokVal)],
			   errorHandler,tokVal
		)
		tokVal=getToken()
	end
end

