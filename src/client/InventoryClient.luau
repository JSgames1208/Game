local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local ItemManager = require(script.Parent.ItemManager)
local RenderBlockToViewport = require(StarterPlayer.StarterPlayerScripts.Client.Utility.RenderItemIcon)
local packets = require(ReplicatedStorage.Shared.network)
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local visible = false

local slotSizeTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local slotColorTweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local InventoryGui = PlayerGui:WaitForChild("InventoryGui")
local Hotbar: Frame = InventoryGui:WaitForChild("Hotbar") :: Frame

local InventoryFrame: Frame = InventoryGui:WaitForChild("Inventory") :: Frame
local OpenHotbar: Frame = InventoryFrame:WaitForChild("Hotbar") :: Frame
local MainInventory: Frame = InventoryFrame:WaitForChild("MainInventory") :: Frame

local inventory = table.create(45, nil)

local InventoryClient = {}

function InventoryClient.Start()
	return
end

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

function InventoryClient.PopulateInventory(data)
	for i = 1, 45 do
		local newItem = data[i]
		inventory[i] = newItem

		local row = (i - 1) // 9

		if row == 0 then
			for _, slot in OpenHotbar:GetChildren() do
				if slot:GetAttribute("SlotIndex") == i then
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
		else
			for _, frame in MainInventory:GetChildren() do
				if frame:GetAttribute("RowIndex") == row then
					local slotIndex = (i - 1) % 9 + 1

					for _, slot in frame:GetChildren() do
						if slot:GetAttribute("SlotIndex") == slotIndex then
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
			end
		end
	end
end

function InventoryClient.UpdateSlots(data)
	InventoryClient.PopulateHotbar(data)
	InventoryClient.PopulateInventory(data)
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

local lastSelectedSlot = nil

function InventoryClient.ToggleVisibility()
	if visible then
		InventoryClient.CloseInventory()
		visible = false
		if lastSelectedSlot then
			InventoryClient.SlotPressed(lastSelectedSlot)
		end
		lastSelectedSlot = nil
	else
		InventoryClient.OpenInventory()
		visible = true
		if selectedSlot then
			local slotIndex = selectedSlot:GetAttribute("SlotIndex")
			InventoryClient.SlotPressed(slotIndex)
			lastSelectedSlot = slotIndex
		end
	end
end

local hoveredSlotIndex = nil
local hoveredSlot = nil
local dragging = false
local dragClone = nil
local dragOffset = Vector2.new()
local originalSlotIndex = nil
local originalSlot = nil

UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
	if gameProcessed then
		return
	end
	if
		input.UserInputType == Enum.UserInputType.MouseButton1
		and hoveredSlot
		and inventory[hoveredSlotIndex].itemInfo.id ~= "nothing"
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

RunService.RenderStepped:Connect(function()
	if dragging then
		local mousePos = UserInputService:GetMouseLocation()
		dragClone.Position = UDim2.fromOffset(mousePos.X - dragOffset.X, mousePos.Y - dragOffset.Y)
	end
end)

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

--{{GETTERS}}--

function InventoryClient.IsInventoryOpen()
	return visible
end

packets.InventorySync.listen(function(data)
	InventoryClient.UpdateSlots(data)
end)

return InventoryClient
