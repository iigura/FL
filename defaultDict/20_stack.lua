--[[ defaultDict_stack.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

Dict.object.AddWords {
	{	name="drop",
		code=function()
				Pop()
			 end
	},
	{	name="dup",
		code=function() Push(ReadTOS()) end
	},
	{	name="swap",
		code=function()
			local a,b=Pop(),Pop()
			Push(a)
			Push(b)
		end
	},
	{	name="rot",
		code=function()
			-- ( x1 x2 x3 -- x2 x3 x1 )
			local x3,x2,x1=Pop(),Pop(),Pop()
			Push(x2)
			Push(x3)
			Push(x1)
		end
	},
	{	name="depth",
		code=function()
			Push(NumOfElements())
		end
	},
	{	name=">R",
		code=function()
			local t=Pop()
			RS.Push(t)
		end
	},
	{	name="R>",
		code=function()
			local t=RS.Pop()
			Push(t)
		end
	},
	{	name=">E",
		code=function()
			local t=Pop()
			ES.Push(t)
		end
	},
	{	name="E>",
		code=function()
			local t=ES.Pop()
			Push(t)
		end
	},
	{	name="E+>",
		code=function()
			Push(ES.ReadTOS())
		end
	},
}

