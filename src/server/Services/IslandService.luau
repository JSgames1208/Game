local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local IslandData = require(ServerScriptService.Server.Modules.Island.IslandData)
local IslandInitializer = require(ServerScriptService.Server.Modules.Island.IslandInitializer)
local IslandPlacer = require(ServerScriptService.Server.Modules.Island.IslandPlacer)
local IslandRemover = require(ServerScriptService.Server.Modules.Island.IslandRemover)
local IslandRenderer = require(ServerScriptService.Server.Modules.IslandRenderer)
local InventoryServer = require(script.Parent.InventoryServer)
local DataStore = require(ServerScriptService.Server.Services.DataStore)
local BlockCoord = require(ReplicatedStorage.Shared.Utils.BlockCoord)
local packets = require(ReplicatedStorage.Shared.network)
local TreeService = require(script.Parent.TreeService)
local QuestService = require(ServerScriptService.Server.Services.QuestService)

local IslandService = {}

function IslandService.PlayerJoined(player: Player)
	IslandInitializer.PlayerJoined(player)
	TreeService.PlayerJoined(player)
end

packets.MineBlock.listen(function(data, player: Player)
	IslandRemover.MineBlock(player, data.blockPosStr, IslandPlacer.PlaceFallingBlock)
end)

function IslandService.PlayerLeaving(player: Player)
	TreeService.PlayerLeaving(player)

	DataStore.ReleasePlayerData(player.UserId)
	IslandInitializer.PlayerLeaving(player)
end

packets.PlaceBlock.listen(function(data, player)
	local pos = Vector3.new(data.x, data.y, data.z)
	local blockId = data.blockId
	if InventoryServer.IsAvailable(player, 1) then
		local placed = IslandPlacer.PlaceBlock(player, pos, blockId)
		if placed then
			local island = IslandData.Get(player)
			InventoryServer.RemoveItem(player, 1)
			local position: Vector3 = pos * 4 + island.PlotPosition
			packets.BlockPlaced.sendTo(position, player)
		end
	end
end)

TreeService.SetOnSaplingGrownCallback(function(player: Player, posStr: string, _)
	local coord: Vector3 = BlockCoord.ParsePos(posStr)
	local island = IslandData.Get(player)
	if not island.IslandModel:FindFirstChild(posStr) then
		return
	end
	if island then
		IslandRenderer.RemoveBlock(island.IslandModel, posStr)
		IslandPlacer.PlaceModel(player, coord, "pine tree", QuestService)
	end
end)

return IslandService
