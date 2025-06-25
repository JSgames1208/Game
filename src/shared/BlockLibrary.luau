local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockLibrary = {}

local BLOCK_SIZE = 4

local blockDefinitions = {
	grass = {},
	dirt = {},
	stone = {},
}

function BlockLibrary.CreateBlockPart(blockId: string)
	local def = blockDefinitions[blockId]
	if not def then
		error("Unknown blockId: " .. tostring(blockId))
	end

	local part = ReplicatedStorage.Assets.Blocks:FindFirstChild(blockId):Clone()
	return part
end

return BlockLibrary
