local Players = game:GetService("Players")
local InventorySlots = require(script.Parent.InventorySlots)
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local MainGui = PlayerGui:WaitForChild("MainGui")
local Hotbar: Frame = MainGui:WaitForChild("Hotbar") :: Frame

local InventoryFrame: Frame = MainGui:WaitForChild("Inventory") :: Frame
local CloseButton: TextButton = InventoryFrame:WaitForChild("CloseButton") :: TextButton

local visible = false

local InventoryUI = {}

function InventoryUI.OpenInventory()
	if Hotbar.Visible then
		Hotbar.Visible = false
		if MainGui:FindFirstChild("HealthBar") then
			MainGui:FindFirstChild("HealthBar").Visible = false
		end
		InventoryFrame.Visible = true
	end
end

function InventoryUI.CloseInventory()
	if InventoryFrame.Visible then
		InventoryFrame.Visible = false
		if MainGui:FindFirstChild("HealthBar") then
			MainGui:FindFirstChild("HealthBar").Visible = true
		end
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

CloseButton.MouseButton1Click:Connect(function()
	InventoryUI.ToggleVisibility()
end)

return InventoryUI
