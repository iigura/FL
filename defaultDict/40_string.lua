--[[ 40_string.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

Dict.string={}
Dict.string.Name="string_dictionary"
Dict.string.AddWords=MakeAddWords(Dict.string)

Dict.string.AddWords {
	-- ex) "wordName" := word-body ;
	{	name=":=", 
		code=function()
			local s=Pop()
			if type(s)~="string" then
				error("@: word name should be a string.")
			end
			local dict,wordName=GetDictByName(s)
			if dict==nil then
				dict=Dict.object
				wordName=s
			end
			NewWord={code=docol, name=wordName, param={}}
			dict[wordName]=NewWord
			NewWordDict=dict
			SetCompileMode()
		end
	},
	-- ex: [ 3.14 ] >noname "PI" assign
	{	name="assign",
		code=function()
			local s=Pop()
			local noNameWordBlock=Pop()
			if IsNoNameWordBlock(noNameWordBlock)==false then
				error("@:assign needs 'wordName' and no-name-word-block.")
			end
			local dict,wordName=GetDictByName(s)
			if dict==nil then
				dict=Dict.object
			end
			local word=dict[wordName]
			if word==nil then
				dict[wordName]={}
				word=dict[wordName]
				word.name=wordName
				word.code=docol
				word.overwritable=true
			end
			if word.overwritable~=true then
				error("@:can not overwrite. the word '"..wordName.."' is protected.")
			end
			if  word.code~=docol then
				error("@:can not over write a core word.")
			end
			word.param=noNameWordBlock.Data.param
		end
	},
	{	name="eval",
		code=function()
			local s=Pop()
			RS.Push(Line)
				RS.Push(ScanPos)
					RS.Push(IP)
						OuterInterpreter(s)
					IP=RS.Pop()
				ScanPos=RS.Pop()
			Line=RS.Pop()
		end
	},
	{	name=">writable",
		code=function()
			local s=Pop()
			local dict,wordName=GetDictByName(s)
			if dict==nil then
				dict=Dict.object
			end
			if dict[wordName]==nil then
				error("@:can not find the word '"..wordName.."'.")
			end
			dict[wordName].overwritable=true
		end
	},
	{	name="protect",
		code=function()
			local s=Pop()
			local dict,wordName=GetDictByName(s)
			if dict==nil then
				dict=Dict.object
			end
			if dict[wordName]==nil then
				error("@:can not find the word '"..wordName.."'.")
			end
			dict[wordName].overwritable=nil
		end
	},

-- file
	{	name="fopen",
		code=function()
			local fname=Pop()
			local fh=io.open(fname,"r")
			if fh==nil then
				error("@:can not open file '"..fname.."'.")
			end
			Push {Type=kFileType,Data=fh}
		end
	},

	-- ex: "colon-defed-wordName" list
	{	name="list",
		code=function()
			local wordName=Pop()
			local param=Dict.object[wordName].param
			print("--- list of '"..wordName.."'---")
			for i,v in ipairs(param) do
				if IsWord(v) then
					print(i,v.Data)
				elseif type(v)=="table" then
					io.write(i); io.write("\t(list)")
					List.Print(v)
					print()
				else
					print(i,v,"("..type(v)..")")
				end
			end
		end
	},
}

