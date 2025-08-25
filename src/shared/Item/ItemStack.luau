local ItemStack = {}
ItemStack.__index = ItemStack

export type ItemStack = {
	item: string?,
	count: number,

	getCount: (self: ItemStack) -> number,
	getItem: (self: ItemStack) -> string,

	size: (self: ItemStack) -> number,
	isEmpty: (self: ItemStack) -> boolean,
} & any

function ItemStack.new(itemId: string?, count: number?): ItemStack
	local self = setmetatable({}, ItemStack) :: ItemStack
	self.itemId = itemId or nil
	self.count = count or 0
	return self
end

function ItemStack.size(self: ItemStack): number
	return self.count
end

function ItemStack.isEmpty(self: ItemStack): boolean
	return self:getCount() <= 0
end

function ItemStack.getCount(self: ItemStack): number
	return self:size()
end

function ItemStack.getItem(self: ItemStack): string
	return self.item
end

return ItemStack
