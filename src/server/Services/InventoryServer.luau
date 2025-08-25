local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ItemStack = require(ReplicatedStorage.Shared.Item.ItemStack)
local DataStore = require(ServerScriptService.Server.Services.DataStore)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local packets = require(ReplicatedStorage.Shared.network)
local InventoryService = {}

export type Inventory = { ItemStack.ItemStack }

local Inventories: { Inventory } = {} -- [userId] = {...}
local SelectedSlots: { [number]: number } = {} -- [userId] = slotId

function InventoryService.Get(player: Player): Inventory
	return Inventories[player.UserId]
end

function InventoryService.GetSelected(player: Player)
	if InventoryService.Get(player)[SelectedSlots[player.UserId]] then
		return InventoryService.Get(player)[SelectedSlots[player.UserId]]:getItem()
	else
		return nil
	end
end

function InventoryService.SendToClient(player: Player)
	local inventory = InventoryService.Get(player)
	local serialized = {}

	for i, stack in inventory do
		serialized[i] = {
			count = stack:getCount(),
			itemInfo = {
				id = stack:getItem() or "nothing",
			},
		}
	end

	packets.InventorySync.sendTo(serialized, player)
end

function InventoryService.PlayerJoined(player: Player)
	local profile = DataStore.profiles[player.UserId]
	if not profile then
		return
	end
	local inventory = DataStore.profiles[player.UserId].Data.Inventory

	Inventories[player.UserId] = inventory

	InventoryService.SendToClient(player)
end

function InventoryService.IsAvailable(player: Player, amount: number)
	if not SelectedSlots[player.UserId] then
		return
	end
	local inventory = InventoryService.Get(player)
	local item = inventory[SelectedSlots[player.UserId]]
	if item and item.count >= amount then
		return true
	else
		return false
	end
end

function InventoryService.splitStack(player: Player, slot: number, amount: number): ItemStack.ItemStack
	local inventory = InventoryService.Get(player)

	if slot > 0 and slot <= #inventory and not inventory[slot]:isEmpty() and amount > 0 then
		local s: ItemStack.ItemStack = inventory[slot]:split(amount)
		if inventory[slot]:getCount() == 0 then
			inventory[slot] = ItemStack.empty()
		end
		InventoryService.setStack(player, slot, inventory[slot])
		return s
	else
		local s = ItemStack.empty()
		InventoryService.setStack(player, slot, inventory[slot])
		return s
	end
end

function InventoryService.removeStack(player: Player, slot: number?, amount: number?): ItemStack.ItemStack
	if not slot then
		slot = SelectedSlots[player.UserId]
		if not slot then
			return ItemStack.empty()
		end
	end

	local inventory = InventoryService.Get(player)
	if slot <= #inventory then
		if not amount then
			local itemStack = inventory[slot]
			inventory[slot] = ItemStack.empty()
			return itemStack
		end
		return InventoryService.splitStack(player, slot :: number, amount)
	else
		return ItemStack.empty()
	end
end

function InventoryService.getEmptySlot(player: Player): number
	local inventory = InventoryService.Get(player)
	for i, stack in ipairs(inventory) do
		if stack:isEmpty() then
			return i
		end
	end

	return -1
end

function InventoryService.setStack(player: Player, slot: number?, stack: ItemStack.ItemStack)
	print(stack)
	if not slot then
		slot = SelectedSlots[player.UserId]
	end
	local inventory = InventoryService.Get(player)
	if slot <= #inventory then
		inventory[slot] = stack
	end

	print(inventory)

	InventoryService.SendToClient(player)
end

function InventoryService.insertStack(player: Player, stack: ItemStack.ItemStack, slot: number?): boolean
	if not slot then
		InventoryService.insertStack(player, stack, -1)
	end
	if stack:isEmpty() then
		return false
	else
		local i: number
		repeat
			i = stack:getCount()
			if slot == -1 then
				local count = InventoryService.addStack(player, stack)
				stack:setCount(count)
			else
				stack:setCount(InventoryService.addStack(player, stack, slot))
			end
		until stack:isEmpty() or stack:getCount() >= i

		return stack:getCount() < i
	end
end

function InventoryService.addStack(player: Player, stack: ItemStack.ItemStack, slot: number?)
	if slot then
		local i = stack:getCount()
		local itemStack: ItemStack.ItemStack = InventoryService.getStack(player, slot)
		if itemStack:isEmpty() then
			InventoryService.setStack(player, slot, stack:copyWithCount(0))
			itemStack = InventoryService.getStack(player, slot)
		end

		local j: number = itemStack:getMaxCount() - itemStack:getCount()
		local k: number = math.min(i, j)
		if k == 0 then
			return i
		else
			i -= k
			itemStack:increment(k)
			InventoryService.setStack(player, slot, itemStack)
			return i
		end
	else
		local i = InventoryService.getOccupiedSlotWithRoomForStack(player, stack)
		if i == -1 then
			i = InventoryService.getEmptySlot(player)
		end

		return i == -1 and stack:getCount() or InventoryService.addStack(player, stack, i)
	end
end

function InventoryService.getOccupiedSlotWithRoomForStack(player: Player, stack: ItemStack.ItemStack)
	local selectedSlot = SelectedSlots[player.UserId]
	if selectedSlot and InventoryService.canStackAddMore(InventoryService.Get(player)[selectedSlot], stack) then
		return selectedSlot
	else
		for i, v in ipairs(InventoryService.Get(player)) do
			if InventoryService.canStackAddMore(InventoryService.Get(player)[i], stack) then
				return i
			end
		end

		return -1
	end
end

function InventoryService.canStackAddMore(existingStack: ItemStack.ItemStack, stack: ItemStack.ItemStack): boolean
	return not existingStack:isEmpty()
		and ItemStack.areItemsEqual(existingStack, stack)
		and existingStack:isStackable()
		and existingStack:getCount() < existingStack:getMaxCount()
end

function InventoryService.getStack(player: Player, slot: number): ItemStack.ItemStack
	if slot <= #InventoryService.Get(player) then
		return InventoryService.Get(player)[slot]
	else
		warn(`Stack doesn't exist at slot {tostring(slot)} for player {player.Name}`)
		return ItemStack.empty()
	end
end

function InventoryService.swapSlots(player: Player, from: number, to: number)
	local inventory = InventoryService.Get(player)
	if inventory[from]:isOf(inventory[to]:getItem()) then
		local left = InventoryService.addStack(player, inventory[from], to)
		inventory[from]:setCount(left)
	else
		local holder = table.clone(inventory[to])
		inventory[to] = inventory[from]
		inventory[from] = holder
	end

	print(inventory)

	InventoryService.SendToClient(player)
end

function InventoryService.PlayerLeaving(player: Player)
	Inventories[player.UserId] = nil
end

packets.SlotPressed.listen(function(data, player: Player)
	SelectedSlots[player.UserId] = data.slotIndex > 0 and data.slotIndex or nil
end)

packets.SwapSlots.listen(function(data: { from: number, to: number }, player: Player)
	InventoryService.swapSlots(player, data.from, data.to)
end)

return InventoryService
