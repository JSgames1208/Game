local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local IslandData = require(ServerScriptService.Server.Modules.Island.IslandData)
local InventoryServer = require(ServerScriptService.Server.Services.InventoryServer)
local GetItemModel = require(ReplicatedStorage.Shared.Entity.Helpers.GetItemModel)
local ItemStack = require(ReplicatedStorage.Shared.Item.ItemStack)
local Entity = require(script.Parent.Entity)
local EntityTypes = require(script.Parent.EntityTypes)

export type ItemEntity = Entity.Entity & {
	itemAge: number,
	itemId: string,
	stack: ItemStack.ItemStack,
	owner: number,

	getStack: (self: ItemEntity) -> ItemStack.ItemStack,

	animate: (self: ItemEntity, dt: number) -> (),
}

local ItemEntity = setmetatable({}, Entity)
ItemEntity.__index = ItemEntity

function ItemEntity.new(player: Player, pos: Vector3, itemId: string, amount: number?): ItemEntity
	local self = setmetatable(Entity.new(pos, player) :: any, ItemEntity) :: ItemEntity

	self.itemAge = 0
	self.itemId = itemId
	self.type = EntityTypes.itemEntity
	self.stack = ItemStack.new(itemId, amount or 1)

	self.owner = nil

	local part = GetItemModel(itemId)
	if part then
		part = part:Clone()
		if part:IsA("Model") then
			for _, d in part:GetDescendants() do
				if d:IsA("Part") or d:IsA("MeshPart") then
					d.CanCollide = false
				end
			end
		else
			part.CanCollide = false
		end
		part.Parent = workspace.Entities.ItemEntities
		if part:IsA("Model") then
			part:ScaleTo(0.25)
		else
			part.Size = part.Size / 4
		end
		for _, texture: Texture in part:GetChildren() do
			if texture:IsA("Texture") then
				texture.StudsPerTileU = 1
				texture.StudsPerTileV = 1
			end
		end
		part:PivotTo(CFrame.new(pos))
		for _, d in part:GetDescendants() do
			if d:HasTag("Block") then
				d:RemoveTag("Block")
			end
		end
		part:RemoveTag("Block")
	end
	self.model = part

	if self.model:IsA("Model") then
		_, self.size = self.model:GetBoundingBox()
	else
		self.size = self.model.Size
	end

	return self
end

function ItemEntity.getStack(self: ItemEntity): ItemStack.ItemStack
	return self.stack
end

---@Override
function ItemEntity.getGravity()
	return -196.2
end

---@Override
function ItemEntity.update(self: ItemEntity, dt: number)
	if self:getStack():isEmpty() then
		self:destroy()
		return
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

function ItemEntity.onPlayerCollision(self: ItemEntity, player: Player)
	local itemStack: ItemStack.ItemStack = self:getStack()
	local i = itemStack:getCount()
	if (self.owner == nil or self.owner == player.UserId) and InventoryServer.insertStack(player, itemStack) then
		if itemStack:isEmpty() then
			self:destroy()
			itemStack:setCount(i)
		end
	end
end

function ItemEntity.animate(self: ItemEntity, dt: number)
	local position = Vector3.new(
		self.position.X,
		self.position.Y + 0.3 + ((math.sin(self.itemAge * 3) + 1) / 2) / 5.0 * 2,
		self.position.Z
	)

	self.model:PivotTo(CFrame.new(position) * CFrame.fromOrientation(0, -self.itemAge, 0))
end

return ItemEntity
