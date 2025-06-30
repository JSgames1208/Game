local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local BlockCoord = require(ReplicatedStorage.Shared.Utility.BlockCoord)

local BLOCK_SIZE = 4

local IslandRenderer = {}

function IslandRenderer.RenderIsland(islandData, origin)
	local model = Instance.new("Model")

	for posStr, blockId in pairs(islandData.Blocks) do
		if blockId ~= "air" then
			local relativePos = BlockCoord.ParsePos(posStr)
			local blockPart: Part = BlockLibrary.CreateBlockPart(blockId) :: Part
			blockPart:PivotTo(CFrame.new(origin + relativePos * BLOCK_SIZE))
			blockPart.Name = posStr
			blockPart.Parent = model
			blockPart:SetAttribute("maxhp", ItemLibrary.itemDefinitions[blockId].hp)
			blockPart:SetAttribute("hp", ItemLibrary.itemDefinitions[blockId].hp)
		end
	end

	return model
end

function IslandRenderer.SetBlock(islandModel, relativePos, blockId)
	local blockPart = BlockLibrary.CreateBlockPart(blockId)
	blockPart:PivotTo(CFrame.new(relativePos * BLOCK_SIZE))
	blockPart.Parent = islandModel
	blockPart.Name = BlockCoord.GetName(relativePos)
	blockPart:SetAttribute("maxhp", ItemLibrary.itemDefinitions[blockId].hp)
	blockPart:SetAttribute("hp", ItemLibrary.itemDefinitions[blockId].hp)
	return blockPart
end

function IslandRenderer.RemoveBlock(islandModel, posStr: string)
	local block = islandModel[posStr]
	if block then
		block:Destroy()
	end
end

return IslandRenderer
