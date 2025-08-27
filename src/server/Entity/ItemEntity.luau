local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local EntityStorage = require(script.Parent.EntityStorage)
local EntityTypes = require(ReplicatedStorage.Shared.Entity.EntityTypes)
local IslandData = require(ServerScriptService.Server.Modules.Island.IslandData)
local GetItemModel = require(ReplicatedStorage.Shared.Entity.Helpers.GetItemModel)
local ItemStack = require(ReplicatedStorage.Shared.Item.ItemStack)
local Entity = require(ServerScriptService.Server.Entity.Entity)
local PlayerEntity = require(ServerScriptService.Server.Entity.Player.PlayerEntity)

local ITEM_DESPAWN_TIME: number = 300

export type ItemEntity = Entity.Entity & {
	itemAge: number,
	itemId: string,
	stack: ItemStack.ItemStack,
	owner: number,
	pickupDelay: number,
	playerEntity: PlayerEntity.PlayerEntity,

	lastMergeInterval: number,
	mergeCheckTimer: number,

	setDefaultPickupDelay: (self: ItemEntity) -> (),

	getStack: (self: ItemEntity) -> ItemStack.ItemStack,
	setStack: (self: ItemEntity, stack: ItemStack.ItemStack) -> (),

	tryMerge: (self: ItemEntity, itemEntity: ItemEntity) -> (),
	canMerge: (self: ItemEntity, stack1: ItemStack.ItemStack?, stack2: ItemStack.ItemStack?) -> boolean,

	animate: (self: ItemEntity, dt: number) -> (),
}

local ItemEntity = setmetatable({}, Entity)
ItemEntity.__index = ItemEntity

function ItemEntity.new(
	player: Player,
	playerEntity: PlayerEntity.PlayerEntity,
	pos: Vector3,
	itemId: string,
	amount: number?
): ItemEntity
	local self = setmetatable(Entity.new(pos, player) :: any, ItemEntity) :: ItemEntity

	self.itemAge = 0
	self.itemId = itemId
	self.type = EntityTypes.itemEntity
	self.stack = ItemStack.new(itemId, amount or 1)

	self.position = pos

	self.lastMergeInterval = 0
	self.mergeCheckTimer = 0

	self.velocity = Vector3.new(math.random(-4, 4), math.random(5, 20), math.random(-4, 4))
	self:setDefaultPickupDelay()

	self.owner = nil
	self.playerEntity = playerEntity

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

function ItemEntity.setDefaultPickupDelay(self: ItemEntity): ()
	self.pickupDelay = 0.5
end

function ItemEntity.getStack(self: ItemEntity): ItemStack.ItemStack
	return self.stack
end

function ItemEntity.setStack(self: ItemEntity, stack: ItemStack.ItemStack): ()
	self.stack = stack
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
		if self.pickupDelay :: number > 0 then
			self.pickupDelay = math.max(0, self.pickupDelay - dt)
		end
		self.itemAge += dt
		self:applyGravity(dt)

		self:move(dt)
		local f = 0.98
		if self:isOnGround() then
			f = 0.6
		end

		self:setVelocity(Vector3.new(self:getVelocity().X * f, self:getVelocity().Y * 0.98, self:getVelocity().Z * f))

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

		local moved: boolean = math.floor(self.lastX / 4) * 4 ~= math.floor(self:getX() / 4) * 4
			or math.floor(self.lastY / 4) * 4 ~= math.floor(self:getY() / 4) * 4
			or math.floor(self.lastZ / 4) * 4 ~= math.floor(self:getZ() / 4) * 4

		if moved then
			self.lastMergeInterval = 0.1
		else
			self.lastMergeInterval = 2
		end

		self.mergeCheckTimer += dt

		if self.mergeCheckTimer :: number >= self.lastMergeInterval then
			self:tryMerge()
			self.mergeCheckTimer = 0
		end

		if self.itemAge :: number >= ITEM_DESPAWN_TIME then
			self:destroy()
		end
	end
end

function ItemEntity.tryMerge(self: ItemEntity, itemEntity: ItemEntity?): ()
	if not itemEntity then
		if self:canMerge() then
			for _, entityModel in workspace.Entities.ItemEntities:GetChildren() do
				if entityModel:HasTag("Entity") then
					if (entityModel:GetPivot().Position - self.position).Magnitude < 3 then
						local entity = EntityStorage.get(entityModel)
						if entity and entity ~= self then
							if entity:canMerge() then
								self:tryMerge(entity)
								if self:isRemoved() then
									break
								end
							end
						end
					end
				end
			end
		end
	end

	if itemEntity then
		local stack: ItemStack.ItemStack = self:getStack()
		local stack2: ItemStack.ItemStack = itemEntity:getStack()

		if self.owner == itemEntity.owner and self:canMerge(stack, stack2) then
			if stack2:getCount() < stack:getCount() then
				mergeEntities(self, stack, itemEntity, stack2)
			else
				mergeEntities(itemEntity, stack2, self, stack)
			end
		end
	end
end

function ItemEntity.canMerge(self: ItemEntity, stack1: ItemStack.ItemStack?, stack2: ItemStack.ItemStack?): boolean
	if not (stack1 and stack2) then
		local stack: ItemStack.ItemStack = self:getStack()
		local itemAge: number = self.itemAge
		return itemAge < ITEM_DESPAWN_TIME and stack:getCount() < stack:getMaxCount()
	end

	if stack1 and stack2 then
		return if stack2:getCount() + stack1:getCount() > stack2:getMaxCount()
			then false
			else ItemStack.areItemsEqual(stack1, stack2)
	end

	return false
end

function mergeStacks(stack1: ItemStack.ItemStack, stack2: ItemStack.ItemStack, maxCount: number): ItemStack.ItemStack
	local i = math.min(math.min(stack1:getMaxCount(), maxCount) - stack1:getCount(), stack2:getCount())
	local itemStack = stack1:copyWithCount(stack1:getCount() + 1)
	stack2:decrement(i)
	return itemStack
end

function mergeIntoEntity(targetEntity: ItemEntity, stack1: ItemStack.ItemStack, stack2: ItemStack.ItemStack): ()
	local itemStack = mergeStacks(stack1, stack2, 64)
	targetEntity:setStack(itemStack)
end

function mergeEntities(
	targetEntity: ItemEntity,
	targetStack: ItemStack.ItemStack,
	sourceEntity: ItemEntity,
	sourceStack: ItemStack.ItemStack
)
	mergeIntoEntity(targetEntity, targetStack, sourceStack)
	targetEntity.pickupDelay = math.max(targetEntity.pickupDelay, sourceEntity.pickupDelay)
	targetEntity.itemAge = math.min(targetEntity.itemAge, sourceEntity.itemAge)
	if sourceStack:isEmpty() then
		sourceEntity:setRemoved()
		sourceEntity:destroy()
	end
end

function ItemEntity.onPlayerCollision(self: ItemEntity, player: Player)
	local itemStack: ItemStack.ItemStack = self:getStack()
	local i = itemStack:getCount()
	local pickupDelay: number = self.pickupDelay
	if
		pickupDelay <= 0
		and (self.owner == nil or self.owner == player.UserId)
		and self.playerEntity:getInventory():insertStack(itemStack)
	then
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
