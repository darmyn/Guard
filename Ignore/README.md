# Guard
 A lightweight anti-cheat framework.

[Roblox Module](https://web.roblox.com/library/6745363798/Guard)

[Click to view the WIKI](https://github.com/darmyn/Guard/wiki)


### Basic Usage:

 ```Lua
local Players = game:GetService("Players")

local Guard = require(script.Guard)

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
		-- cHead is the head of the circular buffer, meaning it is the most recent thread of data.
		-- cNeck is the index/value pair after cHead, meaning it is the second most recent thread of data.
	end)
	
end

Players.PlayerAdded:Connect(PlayerAdded)
 ```

