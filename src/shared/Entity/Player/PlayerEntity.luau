local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LivingEntity = require(ReplicatedStorage.Shared.Entity.LivingEntity)

export type PlayerEntity = LivingEntity.LivingEntity & {
	orientation: Vector3,
}

local PlayerEntity = setmetatable({}, LivingEntity)
PlayerEntity.__index = PlayerEntity

function PlayerEntity.new(player: Player, pos: Vector3): PlayerEntity
	local self = setmetatable(LivingEntity.new(pos, player) :: any, PlayerEntity) :: PlayerEntity
	self.size = Vector3.new(2, 4, 1)
	self.orientation = Vector3.new(0, 0, 0)
	self.position = Vector3.new(0, 0, 0)
	self.model = (player.Character or player.CharacterAdded:Wait()):FindFirstChild("CollisionPart")

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
			if i:HasTag("Entity") then
			end
		end
	end
end

return PlayerEntity
