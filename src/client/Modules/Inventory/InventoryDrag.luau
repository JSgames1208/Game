local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local packets = require(ReplicatedStorage.Shared.network)
local InventoryHandler = require(script.Parent.InventoryHandler)

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local InventoryGui = PlayerGui:WaitForChild("InventoryGui")

local InventoryFrame: Frame = InventoryGui:WaitForChild("Inventory") :: Frame
local OpenHotbar: Frame = InventoryFrame:WaitForChild("Hotbar") :: Frame
local MainInventory: Frame = InventoryFrame:WaitForChild("MainInventory") :: Frame

local hoveredSlotIndex = nil
local hoveredSlot = nil
local dragging = false
local dragClone = nil
local dragOffset = Vector2.new()
local originalSlotIndex = nil
local originalSlot = nil

local InventoryDrag = {}

--private functions

local function processInputs()
	UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
		if gameProcessed then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			and hoveredSlot
			and InventoryHandler.GetInventory()[hoveredSlotIndex].itemInfo.id ~= "nothing"
		then
			dragging = true
			originalSlot = hoveredSlot
			originalSlotIndex = hoveredSlotIndex
			dragClone = originalSlot:Clone()
			dragClone.AnchorPoint = Vector2.new(0, 0)
			dragClone.Size = UDim2.new(0, originalSlot.AbsoluteSize.X, 0, originalSlot.AbsoluteSize.Y)
			dragClone.Position = UDim2.new(0, originalSlot.AbsolutePosition.X, 0, originalSlot.AbsolutePosition.Y)
			dragClone.Parent = InventoryGui
			dragClone.ZIndex = 1000
			dragClone.BackgroundTransparency = 0.7

			originalSlot.BackgroundTransparency = 1
			originalSlot.IconViewport.Visible = false
			originalSlot.Amount.Visible = false
			if originalSlot:FindFirstChild("TextLabel") then
				originalSlot.TextLabel.Visible = false
			end

			dragOffset = UserInputService:GetMouseLocation() - originalSlot.AbsolutePosition
		end
	end)

	UserInputService.InputEnded:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
			dragging = false
			if dragClone then
				dragClone:Destroy()
				dragClone = nil
			end

			if hoveredSlot and hoveredSlot ~= originalSlot then
				packets.SwapSlots.send({ from = originalSlotIndex, to = hoveredSlotIndex })
				originalSlot.Amount.Text = ""
			end
			task.wait()
			originalSlot.BackgroundTransparency = 0.6
			originalSlot.IconViewport.Visible = true
			originalSlot.Amount.Visible = true
			if originalSlot:FindFirstChild("TextLabel") then
				originalSlot.TextLabel.Visible = true
			end
			return
		end
	end)
end

local function setHoverState()
	for _, row in MainInventory:GetChildren() do
		if row:GetAttribute("RowIndex") then
			for _, slot in row:GetChildren() do
				if slot:GetAttribute("SlotIndex") and slot:IsA("Frame") then
					slot.MouseEnter:Connect(function()
						hoveredSlotIndex = slot:GetAttribute("SlotIndex") + 9 * row:GetAttribute("RowIndex")
						hoveredSlot = slot
					end)
					slot.MouseLeave:Connect(function()
						hoveredSlotIndex = nil
						hoveredSlot = nil
					end)
				end
			end
		end
	end

	for _, slot in OpenHotbar:GetChildren() do
		if slot:GetAttribute("SlotIndex") and slot:IsA("Frame") then
			slot.MouseEnter:Connect(function()
				hoveredSlotIndex = slot:GetAttribute("SlotIndex")
				hoveredSlot = slot
			end)
			slot.MouseLeave:Connect(function()
				hoveredSlotIndex = nil
				hoveredSlot = nil
			end)
		end
	end
end

local function updateDragPosition()
	RunService.RenderStepped:Connect(function()
		if dragging then
			local mousePos = UserInputService:GetMouseLocation()
			dragClone.Position = UDim2.fromOffset(mousePos.X - dragOffset.X, mousePos.Y - dragOffset.Y)
		end
	end)
end

--public funtions

function InventoryDrag.Init()
	InventoryDrag.Start()
end

function InventoryDrag.Start()
	processInputs()
	updateDragPosition()
	setHoverState()
end

return InventoryDrag
