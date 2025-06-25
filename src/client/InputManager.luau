local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local BlockPlacer = require(script.Parent.BlockPlacer)
local InventoryClient = require(script.Parent.InventoryClient)
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
			InventoryClient.SlotPressed(hoveredSlot)
		else
			BlockPlacer.Place()
		end
	end
end)

return InputManager
