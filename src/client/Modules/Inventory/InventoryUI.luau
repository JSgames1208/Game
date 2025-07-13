local Players = game:GetService("Players")
local InventorySlots = require(script.Parent.InventorySlots)
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local InventoryGui = PlayerGui:WaitForChild("InventoryGui")
local Hotbar: Frame = InventoryGui:WaitForChild("Hotbar") :: Frame

local InventoryFrame: Frame = InventoryGui:WaitForChild("Inventory") :: Frame

local visible = false

local InventoryUI = {}

function InventoryUI.OpenInventory()
	if Hotbar.Visible then
		Hotbar.Visible = false
		InventoryFrame.Visible = true
	end
end

function InventoryUI.CloseInventory()
	if InventoryFrame.Visible then
		InventoryFrame.Visible = false
		Hotbar.Visible = true
	end
end

local lastSelectedSlot = nil

function InventoryUI.ToggleVisibility()
	if visible then
		InventoryUI.CloseInventory()
		visible = false
		if lastSelectedSlot then
			InventorySlots.SlotPressed(lastSelectedSlot)
		end
		lastSelectedSlot = nil
	else
		InventoryUI.OpenInventory()
		visible = true
		if InventorySlots.GetSelectedSlot() then
			local slotIndex = InventorySlots.GetSelectedSlot():GetAttribute("SlotIndex")
			InventorySlots.SlotPressed(slotIndex)
			lastSelectedSlot = slotIndex
		end
	end
end

function InventoryUI.IsInventoryOpen()
	return visible
end

function InventoryUI.Init() end

return InventoryUI
