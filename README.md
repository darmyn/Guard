# Guard
 A lightweight anti-cheat framework.


### Basic Usage:

 ```Lua

local Players = game:GetService("Players")

local Guard = require(script.Guard)
Guard:Start()

function PlayerAdded(player)
	
	local guard = Guard.new(player)
	guard.buffSpeed = 1 -- how long between each cycle
	guard.buffSize = guard:SecondsToBuffSize(30) -- the buffer size will be 15 in this example, because 15 index/value pairs every 2 seconds is equivilant to 30 seconds worth of data.
	
	local cycleBind = guard:Bind("onCycle", function()
		local character = player.Character
		local humanoid = character:WaitForChild("Humanoid")
		guard:Write({
			Health = humanoid.Health
		})
	end)
	-- binds are automatically unbinded when the player leaves, without the use of connections.
	
	local scanBind = guard:Bind("onScan", function()
		local cHead, cNeck = guard:Read()
		print(cHead, cNeck)
		-- this is where you run algorithms to determin if players are cheating.
	end)
	
end

Players.PlayerAdded:Connect(PlayerAdded)

 ```

 ### WIKI/API

 [Click to view the WIKI](https://github.com/darmyn/Guard/wiki)
