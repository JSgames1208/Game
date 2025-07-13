local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local slotSizeTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local slotColorTweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local InventoryGui = PlayerGui:WaitForChild("InventoryGui")
local Hotbar: Frame = InventoryGui:WaitForChild("Hotbar") :: Frame

local InventoryFrame: Frame = InventoryGui:WaitForChild("Inventory") :: Frame
local OpenHotbar: Frame = InventoryFrame:WaitForChild("Hotbar") :: Frame
local MainInventory: Frame = InventoryFrame:WaitForChild("MainInventory") :: Frame

local InventoryTweens = {}

--private functions

local function setSizeTween(slot)
	if slot:IsA("Frame") and slot:GetAttribute("SlotIndex") then
		slot.MouseEnter:Connect(function()
			TweenService:Create(slot, slotSizeTweenInfo, { Size = UDim2.new(1.1, 0, 1.1, 0) }):Play()
		end)
		slot.MouseLeave:Connect(function()
			TweenService:Create(slot, slotSizeTweenInfo, { Size = UDim2.new(1, 0, 1, 0) }):Play()
		end)
	end
end

local function setColorTween(slot)
	if slot:IsA("Frame") and slot:GetAttribute("SlotIndex") then
		slot.MouseEnter:Connect(function()
			TweenService:Create(slot, slotColorTweenInfo, { BackgroundTransparency = 0.5 }):Play()
		end)
		slot.MouseLeave:Connect(function()
			TweenService:Create(slot, slotColorTweenInfo, { BackgroundTransparency = 0.6 }):Play()
		end)
	end
end

local function setTweens()
	for _, slot in Hotbar:GetChildren() do
		setSizeTween(slot)
		setColorTween(slot)
	end

	for _, slot in OpenHotbar:GetChildren() do
		setSizeTween(slot)
	end

	for _, row in MainInventory:GetChildren() do
		if row:IsA("Frame") and row:GetAttribute("RowIndex") then
			for _, slot in row:GetChildren() do
				setColorTween(slot)
			end
		end
	end
end

--public functions

function InventoryTweens.Init()
	setTweens()
end

return InventoryTweens
