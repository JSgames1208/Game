local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockPlacer = require(script.Parent.BlockPlacer)
local ItemEquip = require(script.Parent.ItemEquip)
local ToolManager = require(script.Parent.ToolManager)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local ItemManager = {}

function ItemManager.SelectItem(itemId, slotIndex)
	local itemType = ItemLibrary.itemDefinitions[itemId].type

	-- UnEquip existing
	BlockPlacer.Unselect()
	ToolManager.Unselect()

	if itemType == "block" or itemType == "sapling" then
		BlockPlacer.SelectBlock(itemId, slotIndex)
	elseif itemType == "tool" then
		ToolManager.SelectTool(itemId, slotIndex)
	else
		-- nothing
		ItemEquip.UnEquip()
	end
end

return ItemManager
