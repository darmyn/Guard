--[[

	GUARD
	
	Guard is a framework for creating anti-cheats. Guard allows you to bind several processes to certain points
	in the guard cycle.
	
	WARNING: Guard is a base framework for an anti-cheat, you need to build the algorithms with the framework. Guard does not come
	pre-installed with any kind of exploit detection.
	
	- Darmyn AKA darmantinjr

]]


-- SERVICES --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- PRIVATE FUNCTIONS --

-- OBJECTS

local Bind = {}
Bind.__index = Bind

function Bind.new(bindBin, callback)

	local self = setmetatable({}, Bind)

	self.bindBin = bindBin
	self.callback = callback
	self.binded = true

	return self

end

function Bind:Fire()
	self.callback()
end

function Bind:Unbind()
	table.remove(self.bindBin.binds, self.callback)
	self.binded = false
	setmetatable(self, nil)
end

local BindBin = {}
BindBin.__index = BindBin

function BindBin.new()
	local self = setmetatable({}, BindBin)

	self.binds = {}

	return self
end

function BindBin:Fire()
	for _, bind in pairs(self.binds) do
		bind:Fire()
	end
end

function BindBin:Bind(callback)
	local bind = Bind.new(self, callback)
	table.insert(self.binds, bind)
	return bind
end

function BindBin:Unbind()
	for _, bind in pairs(self.binds) do
		if bind.connected then
			bind:Unbind()
		end
	end
	table.clear(self.binds)
end

local PlayerInfo = {}
PlayerInfo.__index = PlayerInfo

function PlayerInfo.new(player)

	local self = setmetatable({}, PlayerInfo)

	self.player = player
	self.character = player.Character or player.CharacterAdded:Wait()
	self.humanoid = self.character:WaitForChild("Humanoid")
	self.root = self.character:WaitForChild("HumanoidRootPart")

	self.alive = true

	self._connections = {}

	local deathConnection = self.humanoid.Died:Connect(function()
		self.alive = false
		self.player.CharacterAdded:Wait()
		self.character = player.Character
		self.humanoid = self.character:WaitForChild("Humanoid")
		self.root = self.character:WaitForChild("HumanoidRootPart")
		self.alive = true

	end)
	table.insert(self._connections, deathConnection)

	return self

end

function PlayerInfo:GetCFrame()
	return self.root.CFrame
end

function PlayerInfo:IsInGame()
	if self.player:IsDescendantOf(Players) then
		return true
	else
		return false
	end
end

local CBuff = {}
CBuff.__index = CBuff

function CBuff.new()

	local self = setmetatable({}, CBuff)

	self.buffer = {}
	self.bufferSize = 20
	self.lastBuffer = os.clock()

	return self

end

function CBuff:Write(new)
	if #self.buffer == self.bufferSize then
		table.remove(self.buffer, 1)
	elseif #self.buffer > self.bufferSize then
		local difference = self.buffer - self.bufferSize
		for i = 0, difference do
			table.remove(self.buffer, 1)
		end
	end

	table.insert(self.buffer, new)
end

function CBuff:Read()
	return self.buffer[#self.buffer], self.buffer[#self.buffer - 1]
end

local Guard = {
	guards = {};
}

local hearbeatConnection
local globalBindBins = {
		onCycle = BindBin.new();
		onScan = BindBin.new();
};

function Guard:Start()
	if not hearbeatConnection then
		hearbeatConnection = RunService.Heartbeat:Connect(function()
			for player, guard in pairs(self.guards) do
				guard:Scan()
			end
		end)
	end
end

function Guard:Stop()
	if hearbeatConnection then
		if hearbeatConnection.Connected then
			hearbeatConnection:Disconnect()
		end
		hearbeatConnection = nil
	end
end

function Guard.new(player)

	local self = {}

	-- private variables --
	local cBuff = CBuff.new()
	local playerInfo = PlayerInfo.new(player)
	local bindBins = {}
	bindBins["onCycle"] = BindBin.new()
	bindBins["onScan"] = BindBin.new()
	
	-- private functions --
	
	-- public values --

	self.buffSpeed = 1
	self.buffSize = 20

	-- public methods --

	function self:Destroy()
		for _, bindBin in pairs(bindBins) do
			bindBin:Unbind()
		end
		local index = table.find(Guard.guards, self)
		if index then
			table.remove(Guard.guards, index)
		end
		self = nil
	end

	function self:Scan()

		if (os.clock() - cBuff.lastBuffer) > self.buffSpeed then
			if playerInfo:IsInGame() then
				if playerInfo.alive then

					cBuff.bufferSize = self.buffSize
					cBuff:Write({
						CFrame = playerInfo:GetCFrame();
					})
					bindBins["onCycle"]:Fire()
					globalBindBins["onCycle"]:Fire()
					cBuff.lastBuffer = os.clock()

					if #cBuff.buffer > 2 then
						bindBins["onScan"]:Fire()
						globalBindBins["onScan"]:Fire()
					end
				end
			else
				self:Destroy()
			end
		end
	end	

	function self:Write(data)
		assert(typeof(data) == "table", string.format("Expected table, got %s.", typeof(data)))
		local cHead = cBuff:Read()
		for i, v in pairs(data) do
			cHead[i] = v
		end
	end

	function self:Read()
		return cBuff:Read()
	end

	function self:GetBuffer()
		return cBuff.buffer
	end

	function self:SecondsToBuffSize(seconds)
		return seconds / self.buffSpeed
	end

	function self:Bind(bindBin, callback)
		if bindBins[bindBin] then
			return bindBins[bindBin]:Bind(callback)
		end
	end
	
	table.insert(Guard.guards, self)
	return self

end

Guard:Start()

return Guard
