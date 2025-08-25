local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local ItemStack = {}
ItemStack.__index = ItemStack

export type ItemStack = {
	item: string?,
	count: number,

	getCount: (self: ItemStack) -> number,
	setCount: (self: ItemStack, count: number) -> (),

	getMaxCount: (self: ItemStack) -> number,

	getItem: (self: ItemStack) -> string,

	size: (self: ItemStack) -> number,
	isEmpty: (self: ItemStack) -> boolean,

	split: (self: ItemStack, amount: number) -> ItemStack,

	isOf: (self: ItemStack) -> boolean,
	isStackable: (self: ItemStack) -> boolean,

	copy: (self: ItemStack) -> ItemStack,
	copyWithCount: (self: ItemStack, count: number) -> ItemStack,

	increment: (self: ItemStack, amount: number) -> (),
	decrement: (self: ItemStack, amount: number) -> (),
} & any

function ItemStack.new(itemId: string?, count: number?): ItemStack
	local self = setmetatable({}, ItemStack) :: ItemStack
	self.item = itemId or nil
	self.count = count or 0
	return self
end

--empty stack constructor
function ItemStack.empty()
	return ItemStack.new()
end

--stack methods
function ItemStack.getCount(self: ItemStack): number
	return self:size()
end

function ItemStack.setCount(self: ItemStack, count: number): ()
	self.count = count
end

function ItemStack.getMaxCount(self: ItemStack): number
	local maxCount = nil

	local item = self:getItem()
	if item then
		local itemDef = ItemLibrary.itemDefinitions[item]
		if itemDef then
			maxCount = itemDef.maxStack
		end
	end
	return maxCount or 1
end

function ItemStack.getItem(self: ItemStack): string
	return self.item
end

function ItemStack.size(self: ItemStack): number
	return self.count
end

function ItemStack.isEmpty(self: ItemStack): boolean
	return self:getCount() <= 0
end

function ItemStack.split(self: ItemStack, amount: number): ItemStack
	local i = math.min(amount, self:getCount())
	local itemStack = self:copyWithCount(i)
	self:decrement(i)
	return itemStack
end

function ItemStack.isOf(self: ItemStack, item: string): boolean
	return self:getItem() == item
end

function ItemStack.isStackable(self: ItemStack): boolean
	return self:getMaxCount() > 1
end

function ItemStack.copy(self: ItemStack): ItemStack
	if self:isEmpty() then
		return ItemStack.empty()
	else
		local itemStack = ItemStack.new(self:getItem(), self:getCount())
		return itemStack
	end
end

function ItemStack.copyWithCount(self: ItemStack, count: number): ItemStack
	if self:isEmpty() then
		return ItemStack.empty()
	else
		local itemStack: ItemStack = self:copy()
		itemStack:setCount(count)
		return itemStack
	end
end

function ItemStack.increment(self: ItemStack, amount: number): ()
	self:setCount(self:getCount() + amount)
end

function ItemStack.decrement(self: ItemStack, amount: number): ()
	self:increment(-amount)
end

--------------------------------------------------------------------------

function ItemStack.areItemsEqual(stack: ItemStack, otherStack: ItemStack)
	return stack:isOf(otherStack:getItem())
end

return ItemStack
