local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(ReplicatedStorage.Shared.network)
local IslandRenderer = require(script.Parent.IslandRenderer)
local IslandDataStore = require(script.Parent.IslandDataStore)

local IslandManager = {}

local PlotSlots = {
	Vector3.new(0, 0, 0),
	Vector3.new(300, 0, 0),
	Vector3.new(-300, 0, 0),
	Vector3.new(0, 0, 300),
	Vector3.new(0, 0, -300),
	Vector3.new(300, 0, 300),
}

local OccupiedSlots = {} -- [plotIndex] = userId
local PlayerIslands = {} -- [userId] = {PlotIndex, PlotPos, IslandData, IslandModel}

local function getBlockKey(vec)
	return string.format("%d,%d,%d", vec.X, vec.Y, vec.Z)
end

function IslandManager.AssignPlotToPlayer(player: Player)
	for index, pos in ipairs(PlotSlots) do
		if not OccupiedSlots[index] then
			OccupiedSlots[index] = player.UserId
			return index, pos
		end
	end

	player:Kick("No available plots!")
	error("No available plots!")
end

function IslandManager.ReleasePlot(player: Player)
	local info = PlayerIslands[player.UserId]
	if info then
		OccupiedSlots[info.PlotIndex] = nil
		if info.IslandModel then
			info.IslandModel:Destroy()
		end
		PlayerIslands[player.UserId] = nil
	end
end

function IslandManager.PlayerJoined(player: Player)
	IslandManager.LoadIsland(player)
end

function IslandManager.PlaceBlock(player: Player, pos, blockId)
	local island = PlayerIslands[player.UserId]
	if not island then
		return
	end

	local gridPos = Vector3.new(math.floor(pos.X + 0.5), math.floor(pos.Y + 0.5), math.floor(pos.Z + 0.5))

	local key = getBlockKey(gridPos)
	island.IslandData.Blocks[key] = blockId

	IslandRenderer.SetBlock(island.IslandModel, gridPos, blockId)
end

function IslandManager.LoadIsland(player: Player)
	local plotIndex, plotPos = IslandManager.AssignPlotToPlayer(player)
	local islandData = IslandDataStore.LoadPlayerData(player.UserId) or {}

	local islandModel = IslandRenderer.RenderIsland(islandData, plotPos)
	islandModel.Name = player.Name .. "_Island"
	islandModel.Parent = workspace.IslandsFolder

	PlayerIslands[player.UserId] = {
		PlotIndex = plotIndex,
		PlotPosition = plotPos,
		IslandData = islandData,
		IslandModel = islandModel,
	}

	return islandModel
end

function IslandManager.PlayerLeaving(player: Player)
	--IslandDataStore.SavePlayerData(player.UserId)
	IslandDataStore.ReleasePlayerData(player.UserId)
	PlayerIslands[player.UserId].IslandModel:Destroy()
	IslandManager.ReleasePlot(player)
end

packets.PlaceBlock.listen(function(data, player)
	local pos = Vector3.new(data.x, data.y, data.z)
	local blockId = data.blockId
	IslandManager.PlaceBlock(player, pos, blockId)
end)

return IslandManager
