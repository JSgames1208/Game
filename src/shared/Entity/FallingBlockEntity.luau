local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Entity = require(script.Parent.Entity)
local EntityTypes = require(script.Parent.EntityTypes)

type self = {
	blockId: string,
	type: string,
	placeBlockCallback: (Player, Vector3, string) -> (),
	model: Part | MeshPart,
}

local FallingBlockEntity = {}
FallingBlockEntity.__index = FallingBlockEntity

export type FallingBlockEntity = typeof(setmetatable({} :: self, FallingBlockEntity)) & Entity.Entity

function FallingBlockEntity.new(
	player: Player,
	pos: Vector3,
	blockId: string,
	placeBlockCallback: (Player, Vector3, string) -> ()
)
	local self = setmetatable(Entity.new(pos, player) :: FallingBlockEntity, FallingBlockEntity)
	self.blockId = blockId
	self.type = EntityTypes.fallingBlock
	self.placeBlockCallback = placeBlockCallback

	local part = ReplicatedStorage.Assets.Blocks:FindFirstChild(blockId):Clone()
	part.Position = self.position
	part.Anchored = true
	part.CanCollide = false
	part.Parent = workspace.Entities.FallingBlocks
	part.Size = part.Size * 0.99

	self.size = part.Size

	self.model = part
	return self
end

return FallingBlockEntity
