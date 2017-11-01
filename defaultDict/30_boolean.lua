--[[ 30_boolean.lua by Koji Iiugra, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

Dict.boolean={}
Dict.boolean.AddWords=MakeAddWords(Dict.boolean)

local checkParam=function(inOpStr)
	local a,b=Pop(),Pop()
	local errMsg="'"..inOpStr.."' ( b b -- b ) needs two booleans."
	checkType(a,"boolean",errMsg)
	checkType(b,"boolean",errMsg)
	return a,b	-- top,second
end

Dict.boolean.AddWords {
	{	name="and",
		code=function()
			local a,b=checkParam("and")
			Push(a and b)
		end
	},
	{	name="or",
		code=function()
			local a,b=checkParam("or")
			Push(a or b)
		end
	},
	{	name="xor",
		code=function()
			local a,b=checkParam("xor")
			Push(a==not b)
		end
	},
	{	name="not",
		code=function()
			local t=Pop()
			if type(t)~="boolean" then
				error("@:SYSTEM ERROR at boolean 'not'.")
			end
			Push(not t)
		end
	},
	{	name=".",
		code=function()
			local t=Pop()
			local s
			if t then s="true" else s="false" end
			io.write(s)
		end
	},
}

