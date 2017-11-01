--[[ defaultDict.lua by Koji Iigura, 2017.

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

Dict={}

MakeAddWords=function(inDict)
	return function(inWordList)
			local k,v
			for k,v in pairs(inWordList) do inDict[v.name]=v end
		   end
end

checkType=function(inVar,inTypeStr,inErrMsg)
	if type(inVar)~=inTypeStr then
		error("@:"..inErrMsg)
	end
end

local defaultCoreDictionaries={
	"10_object.lua",
	"20_stack.lua",
	"30_boolean.lua",
	"40_string.lua",
	"50_list.lua",
	"60_control.lua",
	"70_math.lua",
	"80_io.lua",
	"90_file.lua",

	"99_final.lua"
}
local k,v
for k,v in pairs(defaultCoreDictionaries) do
	dofile("defaultDict/"..v)
end

return [[ "init.fls" load ]]

