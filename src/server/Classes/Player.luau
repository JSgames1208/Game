local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local PassiveHeal = require(ServerScriptService.Server.Modules.Player.PassiveHeal)
local packets = require(ReplicatedStorage.Shared.network)
local Player = {}
Player.__index = Player

function Player.new(player: Player)
	local self = setmetatable({}, Player)

	self.player = player
	self.character = player.Character or player.CharacterAdded:Wait()
	self.maxHealth = 100
	self.health = 100

	return self
end

function Player:addHealth(amount: number)
	self.health = math.min(self.health + amount, self.maxHealth)

	packets.SetHealth.sendTo({ currentHP = self.health, maxHP = self.maxHealth }, self.player)
end

function Player:removeHealth(amount: number)
	self.health = math.max(self.health - amount, 0)
	if self.health <= 0 then
		self:die()
	end

	PassiveHeal.Interrupt(self.player)

	packets.SetHealth.sendTo({ currentHP = self.health, maxHP = self.maxHealth }, self.player)
end

function Player:die()
	packets.Die.sendTo({ reason = "You're soooo bad at this game bro." }, self.player)

	task.wait(5)

	self:respawn()
end

function Player:respawn()
	self.character:PivotTo(CFrame.new(Vector3.new(0, 10, 0)))
	self:addHealth(self.maxHealth)
end

return Player
