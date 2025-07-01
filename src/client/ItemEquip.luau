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

local item = nil
local equippedItem = nil

function ItemEquip.Equip(itemName: string)
	if itemName == equippedItem then
		return
	end
	equippedItem = itemName
	if item then
		print("Destroying")
		item:Destroy()
		item = nil
	end

	local itemDef = ItemLibrary.itemDefinitions[itemName]

	local itemType = itemDef.type
	if itemType == "block" or itemType == "sapling" then
		for _, c in itemTool:GetChildren() do
			c:Destroy()
		end
		item = BlockLibrary.CreateBlockPart(itemName)
		item.Name = "Handle"
		item.Parent = itemTool
		item.Size = item.Size / 4
		item.Anchored = false
		item.CanCollide = false
		for _, texture in item:GetChildren() do
			if texture:IsA("Texture") then
				texture.StudsPerTileU = texture.StudsPerTileU / 4
				texture.StudsPerTileV = texture.StudsPerTileV / 4
			end
		end
		humanoid:EquipTool(itemTool)
	elseif itemType == "tool" then
		-- treat it as a full tool model
		for _, c in itemTool:GetChildren() do
			c:Destroy()
		end

		item = ItemLibrary.CreateToolPart(itemName) -- should return a Tool with a Handle
		for _, c in item:GetChildren() do
			c.Parent = itemTool
		end
		humanoid:EquipTool(itemTool)
	end
end

function ItemEquip.UnEquip()
	humanoid:UnequipTools()
	if item then
		item:Destroy()
		item = nil
	end
	equippedItem = nil
end

return ItemEquip
