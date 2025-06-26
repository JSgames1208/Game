local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local ItemEquip = {}

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid: Humanoid = character:WaitForChild("Humanoid")
local itemTool = Instance.new("Tool")
itemTool.Parent = character
itemTool.Name = "Item"
itemTool.CanBeDropped = false

function ItemEquip.Start()
	return
end

local block = nil
local equippedItem = nil

function ItemEquip.Equip(itemName: string)
	if itemName == equippedItem then
		return
	end
	if block then
		block:Destroy()
		block = nil
	end

	local itemDef = ItemLibrary.itemDefinitions[itemName]

	local itemType = itemDef.type
	if itemType == "block" then
		for _, c in itemTool:GetChildren() do
			c:Destroy()
		end
		block = BlockLibrary.CreateBlockPart(itemName)
		block.Name = "Handle"
		block.Parent = itemTool
		block.Size = block.Size / 4
		block.Anchored = false
		block.CanCollide = false
		for _, texture in block:GetChildren() do
			if texture:IsA("Texture") then
				texture.StudsPerTileU = texture.StudsPerTileU / 4
				texture.StudsPerTileV = texture.StudsPerTileV / 4
			end
		end
		humanoid:EquipTool(itemTool)
	end
end

function ItemEquip.UnEquip()
	humanoid:UnequipTools()
	if block then
		block:Destroy()
		block = nil
	end
	equippedItem = nil
end

return ItemEquip
