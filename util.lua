--[[
	 util.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

-- element={Type=kWordType,Data=wordName}
IsWord=function(inElement)
	return type(inElement)=="table"
	   and inElement.Type==kWordType
	   and type(inElement.Data)=="string"
end

IsNoNameWordBlock=function(inElement)
	return type(inElement)=="table" and inElement.Type==kWordType
		   and type(inElement.Data)=="table"
		   and type(inElement.Data.code)=="function"
end

GetType=function(inValueOrElement)
	if type(inValueOrElement)=="table"
	  and inValueOrElement.Type~=kWordType
	  and Dict[inValueOrElement.Type]~=nil then
		return inValueOrElement.Type
	elseif type(inValueOrElement)=="table" then
		return "list"
	else
		return type(inValueOrElement)
	end
end	

GetDict=function(inTOS,inElement)
	if inElement==nil or inElement.Data==nil then
		error("@: SYSTEM ERROR. invalid element at GetDict.")
	end

	local dict,wordName=GetDictByName(inElement.Data)
	if dict~=nil then
		return dict,wordName
	end

	wordName=inElement.Data
	local tosType=GetType(inTOS)
	dict=Dict[tosType]
	if dict==nil then
		dict=Dict.object
	end
	if dict[inElement.Data]==nil then
		dict=Dict.object
	end
	if dict[inElement.Data]==nil then
		return nil,nil
	else
		return dict,wordName
	end
end

GetDictByName=function(inWordNameSrc)
	local dictName,wordName=string.match(inWordNameSrc,"(.*)%$(.*)")
	if dictName~=nil and wordName=="" then
		error("@: '"..inWordNameSrc.."' has no word name.")
	end
	local dict
	if dictName==nil then
		dict=nil
		wordName=inWordNameSrc
	else
		dict=Dict[dictName]
	end
	return dict,wordName
end

Error_CanNotFindTheWord=function(inWordName)
	error("@: can not find the appropirate dictionary (word='"..inWordName.."').")
end

ExecElement=function(inElement)
	local dict,wordName=GetDict(ReadTOS(),inElement)
	if dict==nil then
		Error_CanNotFindTheWord(inElement.Data)
	end
	dict[wordName].code()
end

ExecNoNameWordBlock=function(inElement)
	inElement.Data.code()
end

Compile=function(inWordName)
	local element={Type=kWordType,Data=inWordName}
	table.insert(NewWord.param,element)
end

CompileValue=function(inValue)
	table.insert(NewWord.param,inValue)
end

