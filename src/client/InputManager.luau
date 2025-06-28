local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local packets = require(ReplicatedStorage.Shared.network)
local BlockPlacer = require(script.Parent.BlockPlacer)
local InventoryClient = require(script.Parent.InventoryClient)
local ToolManager = require(script.Parent.ToolManager)
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local InventoryGui = PlayerGui:WaitForChild("InventoryGui")
local HotBar = InventoryGui:WaitForChild("HotBar")

local InputManager = {}

local hoveredSlot = nil

function InputManager.Start()
	for _, slot in HotBar:GetChildren() do
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

UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
	if gameProcessed then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if hoveredSlot then
			InventoryClient.SlotPressed(hoveredSlot:GetAttribute("SlotIndex"))
		else
			local currentSlot, currentItem = InventoryClient.GetItem()
			if currentItem then
				if ItemLibrary.itemDefinitions[currentItem.id].type == "block" then
					BlockPlacer.Place()
					--elseif ItemLibrary.itemDefinitions[currentItem.id].type == "tool" then
					--ToolManager.Use()
				end
			end
		end
	end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.One then
			InventoryClient.SlotPressed(1)
		elseif input.KeyCode == Enum.KeyCode.Two then
			InventoryClient.SlotPressed(2)
		elseif input.KeyCode == Enum.KeyCode.Three then
			InventoryClient.SlotPressed(3)
		elseif input.KeyCode == Enum.KeyCode.Four then
			InventoryClient.SlotPressed(4)
		elseif input.KeyCode == Enum.KeyCode.Five then
			InventoryClient.SlotPressed(5)
		elseif input.KeyCode == Enum.KeyCode.Six then
			InventoryClient.SlotPressed(6)
		elseif input.KeyCode == Enum.KeyCode.Seven then
			InventoryClient.SlotPressed(7)
		elseif input.KeyCode == Enum.KeyCode.Eight then
			InventoryClient.SlotPressed(8)
		elseif input.KeyCode == Enum.KeyCode.Nine then
			InventoryClient.SlotPressed(9)
		end
	end
end)

return InputManager
