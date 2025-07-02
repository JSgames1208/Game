local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local BlockCoord = require(ReplicatedStorage.Shared.Utility.BlockCoord)

local BLOCK_SIZE = 4

local IslandRenderer = {}

function IslandRenderer.RenderIsland(islandData, origin)
	local model = Instance.new("Model")

	for posStr, blockInfo in pairs(islandData.Blocks) do
		if not blockInfo.id then
			continue
		end
		local id = blockInfo.id
		if id ~= "nothing" then
			local relativePos = BlockCoord.ParsePos(posStr)
			local blockPart: Part = BlockLibrary.CreateBlockPart(id) :: Part
			blockPart:PivotTo(CFrame.new(origin + relativePos * BLOCK_SIZE))
			blockPart.Name = posStr
			blockPart.Parent = model
			print(id)
			blockPart:SetAttribute("maxhp", ItemLibrary.itemDefinitions[id].hp)
			blockPart:SetAttribute("hp", ItemLibrary.itemDefinitions[id].hp)
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
