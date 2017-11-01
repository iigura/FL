--[[
	inner.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php

]]

-- the inner interpreter
InnerInterpreter=function(inThread)
	IP={thread=inThread, index=1}
	while IP.index<=#IP.thread do
		local element=IP.thread[IP.index]
		if element==nil then
			error("@: SYSTEM ERROR. no element in the thread.")
		end
		IP.index=IP.index+1
		if IsWord(element) then
			ExecElement(element)
		elseif IsNoNameWordBlock(element) then
			ExecNoNameWordBlock(element)
		else
			Push(element)
		end
	end
end

