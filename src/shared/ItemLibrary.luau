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
	["wooden pickaxe"] = {
		type = "tool",
		toolType = "pickaxe",
		strength = 2,
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
