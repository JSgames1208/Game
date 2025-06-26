local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local BlockPlacer = require(script.Parent.BlockPlacer)
local RenderBlockToViewport = require(StarterPlayer.StarterPlayerScripts.Client.Utility.RenderBlockIcon)
local packets = require(ReplicatedStorage.Shared.network)
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local slotTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local InventoryGui = PlayerGui:WaitForChild("InventoryGui")
local HotBar = InventoryGui:WaitForChild("HotBar")

local inventory = table.create(9, nil)

local InventoryClient = {}

function InventoryClient.Start()
	return
end

for _, slot in HotBar:GetChildren() do
	if slot:IsA("Frame") then
		slot.MouseEnter:Connect(function()
			TweenService:Create(slot, slotTweenInfo, { Size = UDim2.new(1.1, 0, 1.1, 0) }):Play()
		end)
		slot.MouseLeave:Connect(function()
			TweenService:Create(slot, slotTweenInfo, { Size = UDim2.new(1, 0, 1, 0) }):Play()
		end)
	end
end

function InventoryClient.UpdateSlots(data)
	for i = 1, 9 do
		local newItem = data[i]
		inventory[i] = newItem

		local slot = nil
		for _, s in HotBar:GetChildren() do
			if s:GetAttribute("SlotIndex") == i then
				slot = s
			end
		end
		if slot then
			local viewport = slot:FindFirstChild("IconViewport")
			local amount = slot:FindFirstChild("Amount")
			if viewport and newItem then
				RenderBlockToViewport(viewport, newItem.id)
				amount.Text = newItem.count > 0 and tostring(newItem.count) or ""
			elseif viewport then
				viewport:ClearAllChildren()
			end
		end
	end
end

local selectedSlot = nil

function InventoryClient.SlotPressed(slot: Frame)
	local slotIndex = slot:GetAttribute("SlotIndex")
	if slotIndex <= 9 then
		local UIStroke = slot:FindFirstChild("UIStroke")
		if not selectedSlot then
			selectedSlot = slot
			UIStroke.Enabled = true
			BlockPlacer.SelectBlock(inventory[slotIndex].id, slotIndex)
			packets.SlotPressed.send({ slotIndex = slotIndex })
			return
		end
		selectedSlot:FindFirstChild("UIStroke").Enabled = false
		if selectedSlot ~= slot then
			UIStroke.Enabled = true
			selectedSlot = slot
			BlockPlacer.SelectBlock(inventory[slotIndex].id, slotIndex)
			packets.SlotPressed.send({ slotIndex = slotIndex })
		else
			selectedSlot = nil
			BlockPlacer.SelectBlock("nothing", slotIndex)
			packets.SlotPressed.send({ slotIndex = 0 })
		end
	end
end

packets.InventorySync.listen(function(data)
	InventoryClient.UpdateSlots(data)
end)

return InventoryClient
