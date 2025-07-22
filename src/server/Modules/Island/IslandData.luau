local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)
local IslandData = {}

type Blocks = {
	[string]: {
		[string]: string,
	},
}

type Inventory = {
	{
		count: number,
		itemInfo: {
			[string]: string,
		},
	}
}

export type IslandData = {
	Blocks: Blocks,
	Currency: number,
	Inventory: Inventory,
	QuestInfo: Types.QuestInfo,
}

export type IslandModel = { Instance }

export type PlayerIsland = {
	PlotIndex: number,
	PlotPosition: Vector3,
	IslandData: IslandData,
	IslandModel: IslandModel,
}

export type Data = {
	[number]: PlayerIsland, -- [userId] = {PlotIndex, PlotPos, IslandData, IslandModel}
}

local PlayerIslands: Data = {} -- userId = islandData

function IslandData.Set(player: Player, data: PlayerIsland)
	PlayerIslands[player.UserId] = data
end

function IslandData.Get(player: Player)
	return PlayerIslands[player.UserId] or {}
end

function IslandData.Remove(player: Player)
	PlayerIslands[player.UserId] = nil
end

return IslandData
