local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)

local BLOCK_SIZE = 4

local IslandRenderer = {}

-- Helper function
local function ParsePos(posStr)
	local x, y, z = posStr:match("(-?%d+),(-?%d+),(-?%d+)")
	return Vector3.new(tonumber(x), tonumber(y), tonumber(z))
end

function IslandRenderer.RenderIsland(islandData, origin)
	local model = Instance.new("Model")

	for posStr, blockId in pairs(islandData.Blocks) do
		if blockId ~= "air" then
			local relativePos = ParsePos(posStr)
			local blockPart = BlockLibrary.CreateBlockPart(blockId)
			blockPart.Position = origin + relativePos * BLOCK_SIZE
			blockPart.Parent = model
		end
	end

	return model
end

function IslandRenderer.SetBlock(islandModel, relativePos, blockId)
	local blockPart = BlockLibrary.CreateBlockPart(blockId)
	blockPart.Position = (relativePos * BLOCK_SIZE)
	blockPart.Parent = islandModel
	return blockPart
end

function IslandRenderer.RemoveBlock(islandModel, relativePos)
	for _, part in pairs(islandModel:GetChildren()) do
		local blockPos = (part.Position - islandModel.PrimaryPart.Position) / BLOCK_SIZE
		if blockPos:FuzzyEq(relativePos, 0.1) then
			part:Destroy()
			return true
		end
	end
	return false
end

return IslandRenderer
