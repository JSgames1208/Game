local ServerScriptService = game:GetService("ServerScriptService")
local PlayerInventory = require(script.Parent.PlayerInventory)
local Entity = require(ServerScriptService.Server.Entity.Entity)
local EntityStorage = require(ServerScriptService.Server.Entity.EntityStorage)
local LivingEntity = require(ServerScriptService.Server.Entity.LivingEntity)

export type PlayerEntity = LivingEntity.LivingEntity & {
	orientation: Vector3,
	inventory: PlayerInventory.PlayerInventory,

	getInventory: () -> PlayerInventory.PlayerInventory,
}

local PlayerEntity = setmetatable({}, LivingEntity)
PlayerEntity.__index = PlayerEntity

function PlayerEntity.new(player: Player, pos: Vector3, inventory: PlayerInventory.PlayerInventory): PlayerEntity
	local self = setmetatable(LivingEntity.new(pos, player) :: any, PlayerEntity) :: PlayerEntity
	self.player = player
	self.size = Vector3.new(4, 5, 4)
	self.orientation = Vector3.new(0, 0, 0)
	self.position = Vector3.new(0, 0, 0)
	self.model = (player.Character or player.CharacterAdded:Wait()):FindFirstChild("CollisionPart")
	self.inventory = PlayerInventory.new(player, self, inventory)

	return self
end

---@Override
function PlayerEntity.update(self: PlayerEntity, dt: number): ()
	if self.model then
		self.orientation = self.model.Orientation
		self.position = self.model.Position

		local list = workspace:GetPartBoundsInBox(
			CFrame.new(self.position)
				* CFrame.fromOrientation(self.orientation.X, self.orientation.Y, self.orientation.Z),
			self.size
		)

		for _, i in list do
			if i:HasTag("Entity") or i.Parent:HasTag("Entity") then
				local entity: Entity.Entity = EntityStorage.get(i:HasTag("Entity") and i or i.Parent)
				if entity then
					self:collideWithEntity(entity)
				end
			end
		end
	end
end

function PlayerEntity.getInventory(self: PlayerEntity): PlayerInventory.PlayerInventory
	return self.inventory
end

function PlayerEntity.collideWithEntity(self: PlayerEntity, entity: Entity.Entity)
	entity:onPlayerCollision(self.player)
end

return PlayerEntity
