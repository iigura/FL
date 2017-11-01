--[[ 70_math.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

local makeOp=function(inOp,inFuncBody)
	return function()
				local a,b=Pop(),Pop()	-- dataStack=[ ... b,a ]
				if type(a)~="number" or type(b)~="number" then
					error("@: operator"..inOp.." needs numbers.")
				end
				inFuncBody(a,b)
			end
end

Dict.object.AddWords {
	{name="+", code=makeOp("+",function(a,b) Push(b+a) end) },
	{name="-", code=makeOp("-",function(a,b) Push(b-a) end) },
	{name="*", code=makeOp("*",function(a,b) Push(a*b) end) },
	{name="/", code=makeOp("/",function(a,b) Push(b/a) end) },
	{name="%", code=makeOp("%",function(a,b) Push(b%a) end) },
	{name="//", code=makeOp("//",function(a,b) Push(b//a) end) },
	{name=">", code=makeOp(">",function(a,b) Push(b>a) end) },
	{name="<", code=makeOp("<",function(a,b) Push(b<a) end) },
	{name=">=", code=makeOp(">=",function(a,b) Push(b>=a) end) },
	{name="<=", code=makeOp("<=",function(a,b) Push(b<=a) end) },

	{	name="=",
		code=function()
			local a,b=Pop(),Pop()
			Push(a==b)
		end
	},
}

