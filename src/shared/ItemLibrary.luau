local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemLibrary = {}

ItemLibrary.itemDefinitions = {
	["nothing"] = {
		type = "nothing",
		id = "nothing",
		maxStack = nil,
	},
	["dirt"] = {
		type = "block",
		id = "dirt",
		maxStack = 64,
		hp = 5,
	},
	["grass"] = {
		type = "block",
		id = "grass",
		maxStack = 64,
		hp = 5,
	},
	["stone"] = {
		type = "block",
		id = "stone",
		maxStack = 64,
		hp = 10,
	},
	["bedrock"] = {
		type = "block",
		id = "bedrock",
		maxStack = 64,
		hp = math.huge,
	},
	["sand"] = {
		type = "block",
		id = "sand",
		maxStack = 64,
		hp = 5,
	},
	["log"] = {
		type = "block",
		id = "log",
		maxStack = 64,
		hp = 5,
	},
	["pine tree sapling"] = {
		type = "block",
		id = "pine tree sapling",
		maxStack = 64,
		hp = 1,
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
		id = "wooden pickaxe",
		maxStack = 1,
	},
	["diamond pickaxe"] = {
		type = "tool",
		toolType = "pickaxe",
		strength = 5,
		id = "wooden pickaxe",
		maxStack = 1,
	},
	["obsidian pickaxe"] = {
		type = "tool",
		toolType = "pickaxe",
		strength = 10,
		id = "wooden pickaxe",
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
