--[[
	FL.lua

	F/L by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

NewWordDict=nil	-- for "immediate" word.
NewWord={param={}}

kWordType="word"
kFileType="file"

IP={thread={},index=1}

dofile "stack.lua"
dofile "util.lua"

dofile "inner.lua"
dofile "outer.lua"

FL=function(inDictFilePath)
	local dictPath=inDictFilePath
	if dictPath==nil then dictPath="defaultDict.lua" end
	local execCmdForInit=dofile(dictPath)
	if execCmdForInit~=nil then
		OuterInterpreter(execCmdForInit)
	end
	print "--- F/L ver. 0.9 by Koji Iigura ---";
	while true do
		local prompt="F/L> "
		if IsInterpretMode()==false then prompt="F/L>> " end
		io.write(prompt)
		local line=io.read()
		if line==nil then break end
		if line~="" then
			OuterInterpreter(line)
			if Mode=="interpret" and ErrorOccured==false then
				print(" ok.")
			end
		end
	end
	print()
end

FL(arg[1])

