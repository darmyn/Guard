# Guard
 A lightweight anti-cheat framework.


### Basic Usage:

 ```Lua
local Players = game:GetService("Players")

local Guard = require(script.Guard)

function PlayerAdded(player)
	
	local character = player.Character or player.CharacterAdded:Wait()
	
	local guard = Guard.new(player)
	guard.buffSpeed = 1 -- how long between each cycle
	guard.buffSize = guard:SecondsToBuffSize(30) -- the buffer size will be 15 in this example, because 15 index/value pairs every 2 seconds is equivilant to 30 seconds worth of data.
	
	local scanBind = guard:Bind("onScan", function()
		local cHead, cNeck = guard:Read()
		local distanceTravelled = (cNeck.CFrame.Position - cHead.CFrame.Position).Magnitude
		if distanceTravelled > (character.Humanoid.WalkSpeed * guard.buffSpeed) + 2 then
			character.HumanoidRootPart.CFrame = cNeck.CFrame
			guard:Write({
				CFrame = cNeck.CFrame
			})
		end
	end)
	
end

Players.PlayerAdded:Connect(PlayerAdded)
 ```

 ### WIKI/API

 [Click to view the WIKI](https://github.com/darmyn/Guard/wiki)
