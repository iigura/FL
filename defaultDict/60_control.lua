--[[ 60_control.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

GetNextParamSlotAddress=function()
	return #NewWord.param+1
end

MarkHere=function()
	RS.Push(GetNextParamSlotAddress())
end

Dict.object.AddWords {
	-- [ ... branchWhenFalse jumpAbsAddr ... ]
	{	name="branchWhenFalse",
		code=function()
				if Pop()==false then
					IP.index=ReadIP()
				else
					IncIP()
				end
			 end
	},
	{	name="absoluteJump",
		code=function()
				IP.index=ReadIP()
			 end
	},
	{	name="if", immediate=true,
		code=function()
				if IsCompileMode()~=true then
					error("@:'if' should be use on the compile mode.")
				end
				Compile("branchWhenFalse")
				MarkHere()
				CompileEmptySlot()
			 end
	},
	{	name="else", immediate=true,
		code=function()
				if IsCompileMode()~=true then
					error("@:'else' should be use on the compile mode.")
				end
				-- make jump to else-part
				local p=RS.Pop()
				NewWord.param[p]=GetNextParamSlotAddress()+2
				-- +2 is for absolute jump to the end of else-part for true-part.
				Compile("absoluteJump")
				MarkHere()
				CompileEmptySlot()
			end
	},
	{	name="then", immediate=true,
		code=function()
				if IsCompileMode()~=true then
					error("@:'then' should be use on the compile mode.")
				end
				local p=RS.Pop()
				NewWord.param[p]=GetNextParamSlotAddress()
			 end
	},
	-- while ... loop
	{	name="while", immediate=true,
		code=function()
				if IsCompileMode()~=true then
					error("@:'while' should be use on the compile mode.")
				end
				MarkHere()
				Compile("dup")
				Compile("branchWhenFalse")
				MarkHere()
				CompileEmptySlot()
			 end
	},
	{	name="loop", immediate=true,
		code=function()
				if IsCompileMode()~=true then
					error("@:'loop' should be use on the compile mode.")
				end
				local addrSlotToExit=RS.Pop()
				local jumpAddrToLoop=RS.Pop()
				Compile("absoluteJump")
				CompileValue(jumpAddrToLoop)
				NewWord.param[addrSlotToExit]=GetNextParamSlotAddress()
				Compile("drop")
			 end
	},
	-- foreach ... next
	{	name="foreach", immediate=true,
		code=function()
				if IsCompileMode()~=true then
					error("@:'foreach' should be use on the compile mode.")
				end
				Dict.object["{"].code()
				MarkHere()
				Compile("E+>")
				Compile("execute")
				Compile("dup")
				Compile("branchWhenFalse")
				MarkHere()
				CompileEmptySlot()
			 end
	},
	{	name="next", immediate=true,
		code=function()
				if IsCompileMode()~=true then
					error("@:'next' should be use on the compile mode.")
				end
				local addrSlotToExit=RS.Pop()
				local jumpAddrToLoop=RS.Pop()
				Compile("absoluteJump")
				CompileValue(jumpAddrToLoop)
				NewWord.param[addrSlotToExit]=GetNextParamSlotAddress()
				Compile("drop")	-- drop for the false value
				--Compile("E>")
				--Compile("drop") -- drop for the iterator
				Dict.object["}"].code()
			 end
	},
	{	name="break",immediate=true,
		code=function()
				if IsCompileMode()~=true then
					error("@:'break' should be use on the compile mode.")
				end
				Compile("E>")
				Compile("drop") -- drop for the iterator
				Compile("semis")
			end
	},
}

