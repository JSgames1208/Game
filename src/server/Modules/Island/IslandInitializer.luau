local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local packets = require(ReplicatedStorage.Shared.network)
local IslandRenderer = require(ServerScriptService.Server.Modules.IslandRenderer)
local DataStore = require(ServerScriptService.Server.Services.DataStore)
local IslandData = require(script.Parent.IslandData)
local PlotSlots = {
	Vector3.new(0, 0, 0),
	Vector3.new(100, 0, 0),
	Vector3.new(-300, 0, 0),
	Vector3.new(0, 0, 300),
	Vector3.new(0, 0, -300),
	Vector3.new(300, 0, 300),
}

local OccupiedSlots = {} -- [plotIndex] = userId

local IslandInitializer = {}

function IslandInitializer.PlayerJoined(player: Player)
	IslandInitializer.LoadIsland(player)
	task.wait(1.5)
	IslandInitializer.TeleportToIsland(player)
end

function IslandInitializer.PlayerLeaving(player: Player)
	local playerIsland = IslandData.Get(player)
	if playerIsland then
		if playerIsland.IslandModel then
			playerIsland.IslandModel:Destroy()
		end
	end

	IslandInitializer.ReleasePlot(player)
end

function IslandInitializer.AssignPlotToPlayer(player: Player)
	for index, pos in ipairs(PlotSlots) do
		if not OccupiedSlots[index] then
			OccupiedSlots[index] = player.UserId
			return index, pos
		end
	end

	player:Kick("No available plots!")
	error("No available plots!")
end

function IslandInitializer.ReleasePlot(player: Player)
	local info = IslandData.Get(player)
	if info then
		OccupiedSlots[info.PlotIndex] = nil
		if info.IslandModel then
			info.IslandModel:Destroy()
		end
		IslandData.Remove(player)
	end
end

function IslandInitializer.LoadIsland(player: Player)
	local plotIndex, plotPos = IslandInitializer.AssignPlotToPlayer(player)
	local islandData = DataStore.profiles[player.UserId].Data

	local islandModel = IslandRenderer.RenderIsland(islandData, plotPos)
	islandModel.Name = player.UserId .. "_Island"
	islandModel.Parent = workspace.IslandsFolder

	local playerIsland = {
		PlotIndex = plotIndex,
		PlotPosition = plotPos,
		IslandData = islandData,
		IslandModel = islandModel,
	}

	IslandData.Set(player, playerIsland)

	local blocks = IslandData.Get(player).IslandData.Blocks

	for posStr, block in blocks do
		if block.parent then
			if blocks[block.parent] then
				if not (blocks[block.parent].blocked and table.find(blocks[block.parent].blocked, posStr)) then
					blocks[posStr] = nil
				end
			end
		end
	end

	task.delay(1, function()
		packets.AssignPlot.sendTo(plotPos, player)
	end)
end

function IslandInitializer.TeleportToIsland(player: Player)
	task.wait(0.5)
	if not player then
		return
	end
	local island = IslandData.Get(player)
	if island then
		if island.PlotPosition then
			local character = player.Character or player.CharacterAdded:Wait()
			character:PivotTo(CFrame.new(island.PlotPosition + Vector3.new(0, 10, 0)))
		end
	end
end

return IslandInitializer
