--[[ 10_object.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

kEnvMark="__F/L_ENV__"

Dict.object={}
Dict.object.Name="object_dictionary"
Dict.object.AddWords=MakeAddWords(Dict.object)

Exec=function(inLine)
	RS.Push(Line)
		RS.Push(ScanPos)
			OuterInterpreter(inLine)
		ScanPos=RS.Pop()
	Line=RS.Pop()
end

local makeLocalEnv=function()
	return { kEnvMark }
end

local isEnv=function(inTable)
	return type(inTable)=="table" and #inTable>=1 and inTable[1]==kEnvMark
end

local getEnv=function()
	local n=ES.NumOfElements()
	local stackBody=ES.GetBody()
	local env
	local isFound=false
	for i=n,1,-1 do
		if type(stackBody[i])=="table"
		  and #stackBody[i]>=1 and stackBody[i][1]==kEnvMark then
			env=stackBody[i]
			isFound=true
			break
		end
	end
	if isFound==false then
		error("@: can not found the environment (list).")
	end
	return env
end

local getEnvByVarName=function(inVarName)
	local n=ES.NumOfElements()
	local stackBody=ES.GetBody()
	local env
	local isFound=false
	for i=n,1,-1 do
		if type(stackBody[i])=="table"
		  and #stackBody[i]>=1 and stackBody[i][1]==kEnvMark
		  and stackBody[i][inVarName]~=nil then
			env=stackBody[i]
			isFound=true
			break
		end
	end
	if isFound==false then
		error("@: can not found the environment (list) for '"..inVarName.."'.")
	end
	return env
end

-- F/L core functions
docol=function()
	local currentWordElement=IP.thread[IP.index-1]
	local newThread
	if IsNoNameWordBlock(currentWordElement) then
		newThread=currentWordElement.Data.param
	else
		local dict,wordName=GetDict(ReadTOS(),currentWordElement)
		if dict==nil then
			Error_CanNotFindTheWord(currentWordElement.Data)
		end
 		newThread=dict[wordName].param
	end
	RS.Push(IP)
	IP={thread=newThread,index=1}
end

ReadIP=function() return IP.thread[IP.index] end
IncIP=function() IP.index=IP.index+1 end
CompileEmptySlot=function()
	table.insert(NewWord.param,"EMPTY_SLOT")
end

local hotStart=function()
	if IsCompileMode() then
		Dict[NewWord.name]=nil
		SetInterpretMode()
	end
	Line=""; ScanPos=1
	Empty(); RS.Empty(); ES.Empty()
	IP={thread={},index=1}
end

Dict.object.AddWords {
	{	name="HotStart",
		code=hotStart
	},
	{	name="lit",
		code=function()
			DS.Push(ReadIP())
			IncIP()
		end 
	},
	{	name="/*", immediate=true,
		code=function()
			Push(Mode)
			Push(NewWord)
			NewWord={param={}}
			SetCompileMode()
		end
	},
	{	name="*/", immediate=true,
		code=function()
			NewWord=Pop()
			Mode=Pop()
		end
	},
	{	name="_[", immediate=true,
		code=function()
			RS.Push(Mode)
			SetInterpretMode()
		end
	},
	{	name="]_", immediate=true,
		code=function()
			Mode=RS.Pop()
		end
	},
	{	name="compile",
		code=function()
			local wordName=Pop()
			if type(wordName)~="string" then
				error("@: compile needs a string parameter.")
			end
			local wordElement={Type=kWordType,Data=wordName}
			table.insert(NewWord.param,wordElement)
		end
	},
	{	name=">compile",
		code=function()
			local value=Pop()
			table.insert(NewWord.param,value)
		end
	},
	{	name="semis",
		code=function()
				IP=RS.Pop()
			 end
	},
	{	name=";", immediate=true,
		code=function()
			Compile("semis")
			SetInterpretMode()
		end
	},
	{	name="immediate",
		code=function()
			NewWordDict[NewWord.name].immediate=true
		end
	},
	{	name="writable",
		code=function()
			NewWordDict[NewWord.name].overwritable=true
		end
	},
	{	name="@word",
		code=function()
			local wordName=Pop()
			if type(wordName)~="string" then
				error("@: @word needs string parameter.")
			end
			local element={Type=kWordType,Data=wordName}
			Push(element)
		end
	},
	{	name="execute",
		code=function()
			RS.Push(IP)
				local wordElement=Pop()
				if IsWord(wordElement)==false
				  and IsNoNameWordBlock(wordElement)==false then
					error("@: execute needs a word element.")
				end
				InnerInterpreter({wordElement})
			IP=RS.Pop()
		end
	},
	{	name="do",
		code=function()
			local env=makeLocalEnv()
			ES.Push(env)
		end
	},
	{	name="end",
		code=function()
			local env
			repeat
				env=ES.Pop()
			until isEnv(env)
		end
	},
	{	name="!var",
		code=function() 
				local env=getEnv()
				local varName=Pop()
				if type(varName)~="string" then
					error("@: !var needs a string (local variable name).")
				end
				local value=Pop()
				env[varName]=value
			end
	},
	{	name="@var",
		code=function()
			local varName=Pop()
			if type(varName)~="string" then
				error("@: !var needs a string (local variable name).")
			end
			local env=getEnvByVarName(varName)
			if env[varName]==nil then
				error("@: @var can not find the local var '"..varName.."'.")
			end
			Push(env[varName])
		end
	},
	{	name="append", -- ( l n -- l )
		code=function()
				local list=Pop()
				local value=Pop()
				table.insert(list,value)
				Push(list)
			 end
	},
	{	name="true",
		code=function() Push(true) end
	},
	{	name="false",
		code=function() Push(false) end
	},
	{	name="type",
		code=function() Push(GetType(Pop())) end
	},
}

NewWordDict=Dict.object

