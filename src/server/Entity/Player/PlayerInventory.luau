local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Inventory = require(ReplicatedStorage.Shared.Inventory.Inventory)
local ItemStack = require(ReplicatedStorage.Shared.Item.ItemStack)
local packets = require(ReplicatedStorage.Shared.network)

export type PlayerInventory = {
	main: { ItemStack.ItemStack },
	selectedSlot: number,
	player: Player,
	playerEntity: any,

	getSelectedSlot: (self: PlayerInventory) -> number,
	setSelectedSlot: (self: PlayerInventory, slot: number) -> (),
	getSelectedStack: (self: PlayerInventory) -> ItemStack.ItemStack,
	setSelectedStack: (self: PlayerInventory, stack: ItemStack.ItemStack) -> (),
	getMainStacks: (self: PlayerInventory) -> { ItemStack.ItemStack },
	getEmptySlot: (self: PlayerInventory) -> number,
	getStack: (self: PlayerInventory, slot: number) -> ItemStack.ItemStack,
	setStack: (self: PlayerInventory, slot: number?, stack: ItemStack.ItemStack) -> (),
	insertStack: (self: PlayerInventory, stack: ItemStack.ItemStack, slot: number?) -> boolean,
	addStack: (self: PlayerInventory, stack: ItemStack.ItemStack, slot: number?) -> number,
	splitStack: (self: PlayerInventory, slot: number, amount: number) -> ItemStack.ItemStack,
	getOccupiedSlotWithRoomForStack: (self: PlayerInventory, stack: ItemStack.ItemStack) -> number,
	swapSlots: (self: PlayerInventory, from: number, to: number) -> (),
	removeStack: (self: PlayerInventory, slot: number?, amount: number?) -> ItemStack.ItemStack,
	sendToClient: (self: PlayerInventory) -> (),
}

local PlayerInventory = setmetatable({}, Inventory)
PlayerInventory.__index = PlayerInventory

function PlayerInventory.new(player: Player, playerEntity, inventory): PlayerInventory
	local self = setmetatable(Inventory.new() :: any, PlayerInventory) :: PlayerInventory
	self.player = player
	self.playerEntity = playerEntity
	self.main = inventory

	self:sendToClient()

	return self
end

function PlayerInventory.getSelectedSlot(self: PlayerInventory): number
	return self.selectedSlot
end

function PlayerInventory.setSelectedSlot(self: PlayerInventory, slot: number): ()
	self.selectedSlot = slot
end

function PlayerInventory.getSelectedStack(self: PlayerInventory): ()
	return self.main[self:getSelectedSlot()]
end

function PlayerInventory.setSelectedStack(self: PlayerInventory, stack: ItemStack.ItemStack)
	self.main[self:getSelectedSlot()] = stack
end

function PlayerInventory.getMainStacks(self: PlayerInventory): { ItemStack.ItemStack }
	return self.main
end

function PlayerInventory.getEmptySlot(self: PlayerInventory): number
	for i, stack in ipairs(self.main) do
		if stack:isEmpty() then
			return i
		end
	end

	return -1
end

function PlayerInventory.getStack(self: PlayerInventory, slot: number): ItemStack.ItemStack
	local main = self.getMainStacks(self)
	if slot <= #main then
		return main[slot]
	else
		warn(`Stack doesn't exist at slot {tostring(slot)} for player {self.player.Name}`)
		return ItemStack.empty()
	end
end

function PlayerInventory.setStack(self: PlayerInventory, slot: number?, stack: ItemStack.ItemStack)
	if not slot then
		slot = self.selectedSlot
	end
	local main = self.getMainStacks(self)
	if slot <= #main then
		main[slot] = stack
	end

	self:sendToClient()
end

function PlayerInventory.insertStack(self: PlayerInventory, stack: ItemStack.ItemStack, slot: number?): boolean
	if not slot then
		self:insertStack(stack, -1)
	end
	if stack:isEmpty() then
		return false
	else
		local i: number
		repeat
			i = stack:getCount()
			if slot == -1 then
				local count = self:addStack(stack)
				stack:setCount(count)
			else
				stack:setCount(self:addStack(stack, slot))
			end
		until stack:isEmpty() or stack:getCount() >= i

		return stack:getCount() < i
	end
end

function PlayerInventory.addStack(self: PlayerInventory, stack: ItemStack.ItemStack, slot: number?): number
	if slot then
		local i = stack:getCount()
		local itemStack: ItemStack.ItemStack = self:getStack(slot)
		if itemStack:isEmpty() then
			self:setStack(slot, stack:copyWithCount(0))
			itemStack = self:getStack(slot)
		end

		local j: number = itemStack:getMaxCount() - itemStack:getCount()
		local k: number = math.min(i, j)
		if k == 0 then
			return i
		else
			i -= k
			itemStack:increment(k)
			self:setStack(slot, itemStack)
			return i
		end
	else
		local i = self:getOccupiedSlotWithRoomForStack(stack)
		if i == -1 then
			i = self:getEmptySlot()
		end

		return i == -1 and stack:getCount() or self:addStack(stack, i)
	end
end

function PlayerInventory.splitStack(self: PlayerInventory, slot: number, amount: number): ItemStack.ItemStack
	local main = self:getMainStacks()

	if slot > 0 and slot <= #main and not main[slot]:isEmpty() and amount > 0 then
		local s: ItemStack.ItemStack = main[slot]:split(amount)
		if main[slot]:getCount() == 0 then
			main[slot] = ItemStack.empty()
		end
		self:setStack(slot, main[slot])
		return s
	else
		local s = ItemStack.empty()
		self:setStack(slot, main[slot])
		return s
	end
end

function PlayerInventory.getOccupiedSlotWithRoomForStack(self: PlayerInventory, stack: ItemStack.ItemStack)
	local selectedSlot = self:getSelectedSlot()
	if selectedSlot and canStackAddMore(self:getSelectedStack(), stack) then
		return selectedSlot
	else
		for i, v in ipairs(self:getMainStacks()) do
			if canStackAddMore(self:getStack(i), stack) then
				return i
			end
		end

		return -1
	end
end

function canStackAddMore(existingStack: ItemStack.ItemStack, stack: ItemStack.ItemStack): boolean
	return not existingStack:isEmpty()
		and ItemStack.areItemsEqual(existingStack, stack)
		and existingStack:isStackable()
		and existingStack:getCount() < existingStack:getMaxCount()
end

function PlayerInventory.swapSlots(self: PlayerInventory, from: number, to: number): ()
	local main = self:getMainStacks()
	if main[from]:isOf(main[to]:getItem()) then
		local left = self:addStack(main[from], to)
		main[from]:setCount(left)
		self:sendToClient()
	else
		local holder = table.clone(main[to])
		self:setStack(to, main[from])
		self:setStack(from, holder)
	end
end

function PlayerInventory.removeStack(self: PlayerInventory, slot: number?, amount: number?): ItemStack.ItemStack
	if not slot then
		slot = self:getSelectedSlot()
		if not slot then
			return ItemStack.empty()
		end
	end

	local main = self:getMainStacks()
	if slot <= #main then
		if not amount then
			local itemStack = main[slot]
			self:setStack(slot, ItemStack.empty())
			return itemStack
		end
		return self:splitStack(slot :: number, amount)
	else
		return ItemStack.empty() --SHOULD NEVER REACH AS OF RIGHT NOW
	end
end

function PlayerInventory.sendToClient(self: PlayerInventory): ()
	local main = self.getMainStacks(self)
	local serialized = {}

	for i, stack in main do
		serialized[i] = {
			count = stack:getCount(),
			itemInfo = {
				id = stack:getItem() or "nothing",
			},
		}
	end

	packets.InventorySync.sendTo(serialized, self.player)
end

return PlayerInventory
