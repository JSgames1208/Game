local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Entity = require(script.Parent.Entity)
local EntityTypes = require(script.Parent.EntityTypes)

export type FallingBlockEntity = Entity.Entity & {
	blockId: string,
	type: string,
	placeBlockCallback: (Player, Vector3, string) -> (),
	model: Part | MeshPart,
}

local FallingBlockEntity = setmetatable({}, Entity)
FallingBlockEntity.__index = FallingBlockEntity

--export type FallingBlockEntity = typeof(setmetatable({} :: self, FallingBlockEntity)) & Entity.Entity

function FallingBlockEntity.new(
	player: Player,
	pos: Vector3,
	blockId: string,
	placeBlockCallback: (Player, Vector3, string) -> ()
)
	local self = setmetatable(Entity.new(pos, player) :: any, FallingBlockEntity) :: FallingBlockEntity
	self.blockId = blockId
	self.type = EntityTypes.fallingBlock
	self.placeBlockCallback = placeBlockCallback

	local part = ReplicatedStorage.Assets.Blocks:FindFirstChild(blockId):Clone()
	part.Position = self.position
	part.Anchored = true
	part.CanCollide = false
	part.Parent = workspace.Entities.FallingBlocks

	self.size = Vector3.new(3.9, 3.9, 3.9)

	self.model = part
	return self
end

function FallingBlockEntity.Update(self: FallingBlockEntity, dt)
	Entity.Update(self, dt)

	if not self.isDestroyed then
		self.model:PivotTo(CFrame.new(self.position))
	end
end

return FallingBlockEntity
