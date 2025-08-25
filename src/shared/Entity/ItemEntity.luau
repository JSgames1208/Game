local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local IslandData = require(ServerScriptService.Server.Modules.Island.IslandData)
local GetItemModel = require(ReplicatedStorage.Shared.Entity.Helpers.GetItemModel)
local ItemStack = require(ReplicatedStorage.Shared.Item.ItemStack)
local Entity = require(script.Parent.Entity)
local EntityTypes = require(script.Parent.EntityTypes)

export type ItemEntity = Entity.Entity & {
	itemAge: number,
	itemId: string,
	stack: ItemStack.ItemStack,

	_getStack: (self: ItemEntity) -> ItemStack.ItemStack,

	animate: (self: ItemEntity, dt: number) -> (),
}

local ItemEntity = setmetatable({}, Entity)
ItemEntity.__index = ItemEntity

--export type ItemEntity = typeof(setmetatable({} :: self, ItemEntity)) & Entity.Entity

function ItemEntity.new(player: Player, pos: Vector3, itemId: string): ItemEntity
	local self = setmetatable(Entity.new(pos, player) :: any, ItemEntity) :: ItemEntity

	self.itemAge = 0
	self.itemId = itemId
	self.type = EntityTypes.itemEntity
	self.stack = ItemStack.new(itemId, 1)

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
		part:RemoveTag("Block")
	end
	self.model = part

	self.size = self.model.ExtentsSize

	return self
end

function ItemEntity._getStack(self: ItemEntity): ItemStack.ItemStack
	return self.stack
end

---@Override
function ItemEntity.getGravity()
	return -196.2
end

---@Override
function ItemEntity.update(self: ItemEntity, dt: number)
	if self:_getStack():isEmpty() then
		self.shouldDestroy = true
	else
		self.itemAge += dt
		self:applyGravity(dt)
		self:move(dt)

		local overlap = workspace:GetPartBoundsInBox(CFrame.new(self.position), self.size)
		if next(overlap) then
			local islandData = IslandData.Get(self.player)
			if not islandData then
				return
			end
			for _, part in overlap do
				if part:HasTag("Block") then
					self.position = Vector3.new(self.position.X, (self.position.Y + 4) // 4 * 4, self.position.Z)
				end
			end
		end

		self:animate(dt)

		if self.itemAge :: number >= 300 then
			self.shouldDestroy = true
		end
	end
end

function ItemEntity.onPlayerCollision(self: ItemEntity, player: Entity.Entity)
	local itemStack = self:getStack()
	local item
end

function ItemEntity.animate(self: ItemEntity, dt: number)
	local position = Vector3.new(
		self.position.X,
		self.position.Y + 0.1 + ((math.sin(self.itemAge * 3) + 1) / 2) / 5.0 * 2,
		self.position.Z
	)

	self.model:PivotTo(CFrame.new(position) * CFrame.fromOrientation(0, -self.itemAge, 0))
end

return ItemEntity
