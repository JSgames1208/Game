local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Shared.Utils.Class)
local Entity = require(script.Parent.Entity)

local FallingBlockEntity = Class.Extend(Entity)

function FallingBlockEntity.new(
	player: Player,
	pos: Vector3,
	blockId: string,
	placeBlockCallback: (Player, Vector3, string) -> ()
)
	local self = setmetatable(Entity.new(pos, player), FallingBlockEntity)
	self.blockId = blockId
	self.type = "fallingBlock"
	self.placeBlockCallback = placeBlockCallback

	local part = ReplicatedStorage.Assets.Blocks:FindFirstChild(blockId):Clone()
	part.Position = self.position
	part.Anchored = true
	part.CanCollide = false
	part.Parent = workspace.Entities.FallingBlocks
	part.Size = part.Size * 0.99

	self.model = part
	return self
end

return FallingBlockEntity
