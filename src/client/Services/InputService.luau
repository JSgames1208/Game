local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")
local DialogueUI = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Dialogue.DialogueUI)
local InventorySlots = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Inventory.InventorySlots)
local InventoryUI = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Inventory.InventoryUI)
local BlockPlacerService = require(StarterPlayer.StarterPlayerScripts.Client.Services.BlockPlacerService)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local ToolService = require(StarterPlayer.StarterPlayerScripts.Client.Services.ToolService)
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local MainGui = PlayerGui:WaitForChild("MainGui")
local Hotbar = MainGui:WaitForChild("Hotbar")

local DialogueGui = PlayerGui:WaitForChild("DialogueGui")
local DialogueFrame = DialogueGui:WaitForChild("DialogueFrame")

local InputService = {}

local hoveredSlot = nil

function InputService.Start()
	for _, slot in Hotbar:GetChildren() do
		if slot:IsA("Frame") then
			slot.MouseEnter:Connect(function()
				hoveredSlot = slot
			end)
			slot.MouseLeave:Connect(function()
				hoveredSlot = nil
			end)
		end
	end
end

function InputService.IsOnSlot()
	return hoveredSlot and true or false
end

UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
	if gameProcessed then
		return
	end
	if DialogueFrame.Visible then
		DialogueUI.MouseButton1Click()
		return
	end
	if InventoryUI.IsInventoryOpen() then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.E then
				InventoryUI.ToggleVisibility()
			end
		end
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if hoveredSlot then
			InventorySlots.SlotPressed(hoveredSlot:GetAttribute("SlotIndex"))
			ToolService.MouseDown = false
		else
			local _, currentItem = InventorySlots.GetItem()
			if currentItem then
				local id = currentItem.itemInfo.id
				if id then
					local type = ItemLibrary.itemDefinitions[id].type
					if type == "block" or type == "sapling" then
						BlockPlacerService.Place()
					elseif type == "tool" then
						ToolService.MouseDown = true
					end
				end
			end
		end
	end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.One then
			InventorySlots.SlotPressed(1)
		elseif input.KeyCode == Enum.KeyCode.Two then
			InventorySlots.SlotPressed(2)
		elseif input.KeyCode == Enum.KeyCode.Three then
			InventorySlots.SlotPressed(3)
		elseif input.KeyCode == Enum.KeyCode.Four then
			InventorySlots.SlotPressed(4)
		elseif input.KeyCode == Enum.KeyCode.Five then
			InventorySlots.SlotPressed(5)
		elseif input.KeyCode == Enum.KeyCode.Six then
			InventorySlots.SlotPressed(6)
		elseif input.KeyCode == Enum.KeyCode.Seven then
			InventorySlots.SlotPressed(7)
		elseif input.KeyCode == Enum.KeyCode.Eight then
			InventorySlots.SlotPressed(8)
		elseif input.KeyCode == Enum.KeyCode.Nine then
			InventorySlots.SlotPressed(9)
		elseif input.KeyCode == Enum.KeyCode.E then
			InventoryUI.ToggleVisibility()
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		ToolService.MouseDown = false
	end
end)

return InputService
