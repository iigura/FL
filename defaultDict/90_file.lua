--[[ 90_file.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

Dict.file={}
Dict.file.AddWords=MakeAddWords(Dict.file)

Dict.file.AddWords {
	{	name="close",
		code=function()
			local fileElement=Pop()
			if type(fileElement)~="table" and type(fileElement.Data)~="userdata" then
				error("@:SYSTEM ERROR file.close")
			end
			fileElement.Data:close()
		end
	},
	{	name="read",
		code=function()
			local fhElement=Pop()
			local s=fhElement.Data:read()
			if s==nil then
				Push(false)
			else
				Push(s)
			end
		end
	},
	{	name=".",
		code=function()
			Pop() -- drop
			io.write("(file object)")
		end
	},
}

