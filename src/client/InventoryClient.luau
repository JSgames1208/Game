local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local ItemManager = require(script.Parent.ItemManager)
local RenderBlockToViewport = require(StarterPlayer.StarterPlayerScripts.Client.Utility.RenderItemIcon)
local packets = require(ReplicatedStorage.Shared.network)
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local visible = false

local slotTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local InventoryGui = PlayerGui:WaitForChild("InventoryGui")
local Hotbar: Frame = InventoryGui:WaitForChild("Hotbar") :: Frame

local InventoryFrame: Frame = InventoryGui:WaitForChild("Inventory") :: Frame
local OpenHotbar: Frame = InventoryFrame:WaitForChild("Hotbar") :: Frame
local MainInventory: Frame = InventoryFrame:WaitForChild("MainInventory") :: Frame

local inventory = table.create(9, nil)

local InventoryClient = {}

function InventoryClient.Start()
	return
end

for _, slot in Hotbar:GetChildren() do
	if slot:IsA("Frame") then
		slot.MouseEnter:Connect(function()
			TweenService:Create(slot, slotTweenInfo, { Size = UDim2.new(1.1, 0, 1.1, 0) }):Play()
		end)
		slot.MouseLeave:Connect(function()
			TweenService:Create(slot, slotTweenInfo, { Size = UDim2.new(1, 0, 1, 0) }):Play()
		end)
	end
end

function InventoryClient.PopulateHotbar(data)
	for i = 1, 9 do
		local newItem = data[i]
		inventory[i] = newItem

		local slot = nil
		for _, s in Hotbar:GetChildren() do
			if s:GetAttribute("SlotIndex") == i then
				slot = s
			end
		end
		if slot then
			local viewport = slot:FindFirstChild("IconViewport")
			local amount = slot:FindFirstChild("Amount")

			if newItem.count <= 0 then
				viewport:ClearAllChildren()
				amount.Text = ""
				continue
			end

			if viewport and newItem then
				RenderBlockToViewport(viewport, newItem.itemInfo.id)
				if
					ItemLibrary.itemDefinitions[newItem.itemInfo.id].type == "block"
					or ItemLibrary.itemDefinitions[newItem.itemInfo.id].type == "sapling"
				then
					amount.Text = newItem.count > 0 and tostring(newItem.count) or ""
				elseif
					ItemLibrary.itemDefinitions[newItem.itemInfo.id].type == "tool"
					or ItemLibrary.itemDefinitions[newItem.itemInfo.id].type == "nothing"
				then
					amount.Text = ""
				end
			elseif viewport then
				viewport:ClearAllChildren()
			end
		end
	end
end

function InventoryClient.UpdateSlots(data)
	InventoryClient.PopulateHotbar(data)
end

local selectedSlot = nil

function InventoryClient.SlotPressed(slotIndex: number)
	local slot = nil
	for _, s in Hotbar:GetChildren() do
		if s:GetAttribute("SlotIndex") == slotIndex then
			slot = s
		end
	end
	if slotIndex <= 9 then
		local UIStroke = slot:FindFirstChild("UIStroke")
		if not selectedSlot then
			selectedSlot = slot
			UIStroke.Enabled = true

			ItemManager.SelectItem(inventory[slotIndex].itemInfo.id, slotIndex)

			packets.SlotPressed.send({ slotIndex = slotIndex })
			return
		end
		selectedSlot:FindFirstChild("UIStroke").Enabled = false
		if selectedSlot ~= slot then
			UIStroke.Enabled = true
			selectedSlot = slot

			ItemManager.SelectItem(inventory[slotIndex].itemInfo.id, slotIndex)

			packets.SlotPressed.send({ slotIndex = slotIndex })
		else
			selectedSlot = nil
			ItemManager.SelectItem("nothing", 0)
			packets.SlotPressed.send({ slotIndex = 0 })
		end
	end
end

function InventoryClient.GetItem()
	if selectedSlot then
		return selectedSlot:GetAttribute("SlotIndex"), inventory[selectedSlot:GetAttribute("SlotIndex")]
	else
		return 0, { itemInfo = { id = "nothing" }, count = 0 }
	end
end

function InventoryClient.CloseInventory()
	if InventoryFrame.Visible then
		InventoryFrame.Visible = false
		Hotbar.Visible = true
	end
end

function InventoryClient.OpenInventory()
	if Hotbar.Visible then
		Hotbar.Visible = false
		InventoryFrame.Visible = true
	end
end

function InventoryClient.ToggleVisibility()
	if visible then
		InventoryClient.CloseInventory()
		visible = false
	else
		InventoryClient.OpenInventory()
		visible = true
		if selectedSlot then
			local slotIndex = selectedSlot:GetAttribute("SlotIndex")
			InventoryClient.SlotPressed(slotIndex)
		end
	end
end

--{{GETTERS}}--

function InventoryClient.IsInventoryOpen()
	return visible
end

packets.InventorySync.listen(function(data)
	InventoryClient.UpdateSlots(data)
end)

return InventoryClient
