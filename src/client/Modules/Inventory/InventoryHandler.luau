local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local RenderBlockToViewport = require(StarterPlayer.StarterPlayerScripts.Client.Modules.RenderItemIcon)
local Hotbar = nil
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

return InventoryHandler
