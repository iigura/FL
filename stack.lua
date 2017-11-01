--[[
	stack.lua by Koji Iigura, 2017.
	
	Global variables.
		DS : data stack.
		RS : return stack.
		ES : environment stack

	Copyright (c) 2017 Koji Iigura
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php
]]

local dataStack,returnStack,environmentStack={},{},{}
local makePush =function(t) return function(v) table.insert(t,v) end end
local makePop  =function(inTable,inStackName)
					return function()
							if #inTable<=0 then
								error("@: "..inStackName.." is empty.")
							else
								return table.remove(inTable)
							end
						   end
			  end
local makeEmpty=function(t)
					return function()
								local k,v
								for k,v in pairs(t) do t[k]=nil end
						   end
				end
local makeReadTOS=function(t)
					return function()
							return t[#t]
						   end
				   end
local makeNumOfElements=function(t)
							return function() return #t end
						end
local makeGetBody=function(t)
					return function() return t end
				  end
local makeStack=function(inStackBody,inStackName)
	return {
		Push=makePush(inStackBody),
		Pop=makePop(inStackBody,inStackName),
		Empty=makeEmpty(inStackBody),
		ReadTOS=makeReadTOS(inStackBody),
		NumOfElements=makeNumOfElements(inStackBody),
		GetBody=makeGetBody(inStackBody),
	}
end
DS=makeStack(dataStack,		  "DataStack")
RS=makeStack(returnStack,	  "ReturnStack")
ES=makeStack(environmentStack,"EnvironmentStack")

Push=DS.Push
Pop=DS.Pop
ReadTOS=DS.ReadTOS
NumOfElements=DS.NumOfElements
GetBody=DS.GetBody
Empty=DS.Empty

