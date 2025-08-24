local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetItemModel = require(ReplicatedStorage.Shared.Entity.Helpers.GetItemModel)
local Entity = require(script.Parent.Entity)
local EntityTypes = require(script.Parent.EntityTypes)

type self = {
	itemAge: number,
	itemId: string,

	Animate: (self: ItemEntity, dt: number) -> (),
}

local ItemEntity = {}
ItemEntity.__index = ItemEntity

export type ItemEntity = typeof(setmetatable({} :: self, ItemEntity)) & Entity.Entity

function ItemEntity.new(player: Player, pos: Vector3, itemId: string): ItemEntity
	local self = setmetatable(Entity.new(pos, player) :: any, ItemEntity) :: ItemEntity

	self.itemAge = 0
	self.itemId = itemId
	self.type = EntityTypes.itemEntity

	local part = GetItemModel(itemId)
	if part then
		part = part:Clone()
		if part.CanCollide ~= nil then
			part.CanCollide = false
		end
		part.Parent = workspace.Entities.ItemEntities
		part.Size = part.Size / 4
		for _, texture: Texture in part:GetChildren() do
			if texture:IsA("Texture") then
				texture.StudsPerTileU = 1
				texture.StudsPerTileV = 1
			end
		end
		part.Position = pos
	end
	self.model = part

	self.size = self.model.ExtentsSize

	return self
end

function ItemEntity.Update(self: ItemEntity, dt: number)
	self.itemAge += dt
	self:Move(dt)
	self:Animate(dt)
end

function ItemEntity.Animate(self: ItemEntity, dt: number)
	local position =
		Vector3.new(self.position.X, self.position.Y + 0.1 + math.sin(self.itemAge) / 5 * 4, self.position.Z)
	self.model.Position = position
end

return ItemEntity
