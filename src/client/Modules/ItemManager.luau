local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local BlockPlacerService = require(StarterPlayer.StarterPlayerScripts.Client.Services.BlockPlacerService)
local ToolService = require(StarterPlayer.StarterPlayerScripts.Client.Services.ToolService)
local ItemEquip = require(script.Parent.ItemEquip)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local ItemManager = {}

function ItemManager.SelectItem(itemId, slotIndex)
	local itemType = ItemLibrary.itemDefinitions[itemId].type

	-- UnEquip existing
	BlockPlacerService.Unselect()
	ToolService.Unselect()
	if itemType == "block" or itemType == "sapling" then
		BlockPlacerService.SelectBlock(itemId, slotIndex)
	elseif itemType == "tool" then
		ToolService.SelectTool(itemId, slotIndex)
		print("Equip tool")
	else
		-- nothing
		ItemEquip.UnEquip()
		print("Equip nothing")
	end
end

return ItemManager
