--[[ 50_list.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

Dict.list={}
Dict.list.AddWords=MakeAddWords(Dict.list)

CheckTable=function(inValue)
	if type(inValue)~="table" then
		error("@: value should be a table.")
	end
end

List={}
List.Dup=function(inList)
	local ret={}
	for i,v in ipairs(inList) do
		if type(inList[i])=="table" then
			local t=List.Dup(inList[i])
			talbe.insert(ret,t)
		else
			table.insert(ret,inList[i])
		end
	end
	return ret
end
List.Print=function(inList)
	io.write("( ")
	local i,v
	for i,v in ipairs(inList) do
		if type(v)=="table" then
			List.Print(v)
		else
			io.write(v)
		end
		io.write(" ")
	end
	io.write(")")
end
List.Append=function(inDest,inSrc)
	local k,v
	local n=#inSrc
	local count=0
	for k,v in pairs(inSrc) do
		if count<n then
			table.insert(inDest,v)
			count=count+1
		else
			inDest[k]=v
		end
	end
end

beginNoNameBlock=function()
	RS.Push(Mode)
	RS.Push(NewWord);
	NewWord={param={}}
	SetCompileMode()
end

Dict.object.AddWords {
	{	name="(", immediate=true,
		code=function() beginNoNameBlock() end
	},
	{	name=")",immediate=true, 
		code=function()
			local list=NewWord.param
			NewWord=RS.Pop()
			Mode=RS.Pop()
			if IsCompileMode() then
				CompileValue(list)				
			else
				Push(list)
			end
		end
	},
	{	name="[", immediate=true,
		code=function() beginNoNameBlock() end
	},
	{	name="]", immediate=true,
		code=function()
			local newParam=NewWord.param
			table.insert(newParam,{Type=kWordType,Data="semis"})
			local noNameWord=NewWord
			noNameWord.name="NONAME_WORD_BLOCK"
			noNameWord.code=docol
			local nnwbElement={ Type=kWordType,Data=noNameWord }
			NewWord=RS.Pop()
			Mode=RS.Pop()
			if IsCompileMode() then
				Compile("lit")
				CompileValue(nnwbElement)				
			else
				Push(nnwbElement)
			end
		end
	},
	{	name="{", immediate=true,
		code=function() beginNoNameBlock() end
	},
	{	name="}",immediate=true, 
		code=function()
			Compile("semis")
			local noNameWord=NewWord
			noNameWord.name="NONAME_WORD_BLOCK"
			noNameWord.code=docol
			local nnwbElement={ Type=kWordType,Data=noNameWord }

			NewWord=RS.Pop()
			Mode=RS.Pop()
			if IsCompileMode() then
				CompileValue(nnwbElement)				
			else
				RS.Push(IP)
					InnerInterpreter({nnwbElement})
				IP=RS.Pop()
			end
		end
	},
}
Dict.list.AddWords {
	{	name="length",
		code=function()
			local t=Pop()
			Push(#t)
		end
	},
	{	name=">noname",
		code=function()
			local newParam=Pop()
			table.insert(newParam,{Type=kWordType,Data="semis"})
			Push(NewWord)
				NewWord={param=newParam}
				local noNameWord=NewWord
				noNameWord.name="NONAME_WORD_BLOCK"
				noNameWord.code=docol
				local nnwbElement={ Type=kWordType,Data=noNameWord }
			NewWord=Pop()
			Push(nnwbElement)
		end
	},
	{	name="car",
		code=function()
			local tos=ReadTOS()
			CheckTable(tos)
			Push(tos[1])		
		end
	},
	{	name="cdr",
		code=function()
			local tos=ReadTOS()
			local t=List.Dup(tos)
			t=table.remove(t,1)
			Push(t)
		end
	},
	{	name="pop",	-- ( l -- l n )
		code=function()
			local tos=ReadTOS()
			local car=table.remove(tos,1)
			Push(car)
		end
	},
	{	name="clone",
		code=function() Push(List.Dup(ReadTOS)) end
	},
	{	name="concat",
		code=function()
			local tos,t=Pop(),Pop()
			if type(tos)~="table" or type(t)~="table" then
				error("@: concat (l l -- l): needs 2 list.")
			end
			List.Append(t,tos)
			Push(t)
		end
	},
	{	name="insert",	-- ( n l -- l )
		code=function()
			local list,n=Pop(),Pop()
			table.insert(list,n)
			Push(list)
		end
	},
	{	name="remove",
		code=function()
			local t=Pop()
			table.remove(t)
		end
	},
	{	name=".",
		code=function()
			local tos=Pop()
			CheckTable(tos)
			if IsWord(tos) then
				print("(word: "..tos.Data..")")
			else
				List.Print(tos)
			end
		end
	},
}

