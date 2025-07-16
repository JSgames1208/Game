local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local packets = require(ReplicatedStorage.Shared.network)
local RenderBlockToViewport = require(StarterPlayer.StarterPlayerScripts.Client.Modules.RenderItemIcon)
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local MainGui = PlayerGui:WaitForChild("MainGui")
local Hotbar: Frame = MainGui:WaitForChild("Hotbar") :: Frame

local InventoryFrame: Frame = MainGui:WaitForChild("Inventory") :: Frame
local OpenHotbar: Frame = InventoryFrame:WaitForChild("Hotbar") :: Frame
local MainInventory: Frame = InventoryFrame:WaitForChild("MainInventory") :: Frame

local InventoryHandler = {}

local inventory = {}

function InventoryHandler.GetInventory()
	return inventory
end

function InventoryHandler.PopulateHotbar(data)
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

function InventoryHandler.PopulateInventory(data)
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

function InventoryHandler.UpdateSlots(data)
	InventoryHandler.PopulateHotbar(data)
	InventoryHandler.PopulateInventory(data)
end

function InventoryHandler.Init()
	packets.InventorySync.listen(function(data)
		InventoryHandler.UpdateSlots(data)
	end)
end

return InventoryHandler
