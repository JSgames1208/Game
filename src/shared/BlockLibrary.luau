local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemLibrary = require(script.Parent.ItemLibrary)
local BlockLibrary = {}

BlockLibrary.blockDefinitions = {
	grass = { transparent = false },
	dirt = { transparent = false },
	stone = { transparent = false },
	sand = { transparent = false },
	log = { transparent = false },
	bedrock = { transparent = false },
	["pine tree sapling"] = { transparent = false },
	["pine tree"] = { transparent = false },
}

function BlockLibrary.CreateBlockPart(blockId: string)
	local def = BlockLibrary.blockDefinitions[blockId]
	if not def then
		error("Unknown blockId: " .. tostring(blockId))
	end
	local part = nil

	local type = ItemLibrary.itemDefinitions[blockId].type
	if type == "block" or type == "sapling" then
		part = ReplicatedStorage.Assets.Blocks:FindFirstChild(blockId):Clone()
	elseif type == "tree" then
		part = ReplicatedStorage.Assets.Trees:FindFirstChild(blockId):Clone()
	end
	return part
end

return BlockLibrary
