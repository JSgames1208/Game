local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemLibrary = {}

ItemLibrary.itemDefinitions = {
	["nothing"] = {
		type = "nothing",
		id = "nothing",
	},
	["dirt"] = {
		type = "block",
		drop = "grass",
		dropAmount = 1,
		id = "dirt",
		maxStack = 64,
		hp = 5,
	},
	["grass"] = {
		type = "block",
		drop = "grass",
		dropAmount = 1,
		id = "grass",
		maxStack = 64,
		hp = 5,
	},
	["stone"] = {
		type = "block",
		drop = "stone",
		dropAmount = 1,
		id = "stone",
		maxStack = 64,
		hp = 10,
	},
	["sand"] = {
		type = "block",
		drop = "sand",
		dropAmount = 1,
		id = "sand",
		maxStack = 64,
		hp = 5,
	},
	["bedrock"] = {
		type = "block",
		drop = "bedrock",
		dropAmount = 1,
		id = "bedrock",
		maxStack = 64,
		hp = math.huge,
	},
	["log"] = {
		type = "block",
		drop = "log",
		dropAmount = 1,
		id = "log",
		maxStack = 64,
		hp = 5,
	},
	["pine tree sapling"] = {
		type = "sapling",
		drop = "pine tree sapling",
		dropAmount = 1,
		id = "pine tree sapling",
		growTime = 5,
		maxStack = 64,
		hp = 5,
	},
	["pine tree"] = {
		type = "tree",
		drop = "log",
		dropAmount = 3,
		id = "pine tree",
		maxStack = 64,
		hp = 10,
	},
	["wooden pickaxe"] = {
		type = "tool",
		toolType = "pickaxe",
		strength = 2,
		id = "wooden pickaxe",
		maxStack = 1,
	},
	["golden pickaxe"] = {
		type = "tool",
		toolType = "pickaxe",
		strength = 3,
		id = "golden pickaxe",
		maxStack = 1,
	},
	["diamond pickaxe"] = {
		type = "tool",
		toolType = "pickaxe",
		strength = 5,
		id = "diamond pickaxe",
		maxStack = 1,
	},
	["obsidian pickaxe"] = {
		type = "tool",
		toolType = "pickaxe",
		strength = 10,
		id = "obsidian pickaxe",
		maxStack = 1,
	},
}

function ItemLibrary.CreateToolPart(itemId: string)
	local part = ReplicatedStorage:FindFirstChild("Assets"):FindFirstChild("Tools"):FindFirstChild(itemId)
	if part then
		return part:Clone()
	else
		return Instance.new("Part")
	end
end

return ItemLibrary
