local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemStack = require(ReplicatedStorage.Shared.Item.ItemStack)
type ItemStack = ItemStack.ItemStack
local Inventory = {}
Inventory.__index = Inventory

export type Inventory = {
	size: (self: Inventory) -> number,
	isEmpty: (self: Inventory) -> boolean,
	getStack: (self: Inventory, slot: number) -> ItemStack,
	removeStack: (self: Inventory, slot: number, amount: number) -> ItemStack,
	setStack: (self: Inventory, slot: number) -> (),
	getMaxCountPerStack: (self: Inventory) -> number,
	getMaxCount: (self: Inventory, stack: ItemStack) -> number,
	onOpen: (self: Inventory, playerEntity: any) -> (),
	onClose: (self: Inventory, playerEntity: any) -> (),
} & any

function Inventory.new(): Inventory
	local self = setmetatable({}, Inventory) :: Inventory
	return self
end

return Inventory
