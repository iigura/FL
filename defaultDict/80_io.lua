--[[ 80_io.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

Dict.object.AddWords {
	{	name=".",
		code=function()
				local t=Pop()
				io.write(" ")
				io.write(t)
			 end
	},
	{	name="cr",
		code=function() print() end
	}
}

