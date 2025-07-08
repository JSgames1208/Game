local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemLibrary = {}

ItemLibrary.itemDefinitions = {
	["nothing"] = {
		type = "nothing",
		id = "nothing",
	},
	["dirt"] = {
		type = "block",
		drops = { ["grass"] = 1 },
		id = "dirt",
		falling = false,
		maxStack = 64,
		hp = 5,
	},
	["grass"] = {
		type = "block",
		drops = { ["grass"] = 1 },
		id = "grass",
		falling = false,
		maxStack = 64,
		hp = 5,
	},
	["stone"] = {
		type = "block",
		drops = { ["stone"] = 1 },
		id = "stone",
		falling = false,
		maxStack = 64,
		hp = 10,
	},
	["sand"] = {
		type = "block",
		drops = { ["sand"] = 1 },
		id = "sand",
		falling = true,
		maxStack = 64,
		hp = 5,
	},
	["bedrock"] = {
		type = "block",
		drops = { ["bedrock"] = 1 },
		id = "bedrock",
		falling = false,
		maxStack = 64,
		hp = math.huge,
	},
	["log"] = {
		type = "block",
		drops = { ["log"] = 1 },
		id = "log",
		falling = false,
		maxStack = 64,
		hp = 5,
	},
	["pine tree sapling"] = {
		type = "sapling",
		drops = { ["pine tree sapling"] = 1 },
		id = "pine tree sapling",
		falling = false,
		growTime = 5,
		maxStack = 64,
		hp = 5,
	},
	["pine tree"] = {
		type = "tree",
		drops = { ["pine tree sapling"] = 1, ["log"] = 3 },
		id = "pine tree",
		falling = false,
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
