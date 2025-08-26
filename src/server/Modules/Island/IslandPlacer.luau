local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local EnvironmentChecks = require(script.Parent.EnvironmentChecks)
local IslandRenderer = require(ServerScriptService.Server.Modules.IslandRenderer)
local EntityService = require(ServerScriptService.Server.Services.EntityService)
local QuestService = require(ServerScriptService.Server.Services.QuestService)
local TreeService = require(ServerScriptService.Server.Services.TreeService)
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)
local IslandData = require(script.Parent.IslandData)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local ModelLibrary = require(ReplicatedStorage.Shared.ModelLibrary)
local BlockHelpers = require(ReplicatedStorage.Shared.Modules.BlockHelpers)
local Collision = require(ReplicatedStorage.Shared.Physics.Collision)
local BlockCoord = require(ReplicatedStorage.Shared.Utils.BlockCoord)
local GridMath = require(ReplicatedStorage.Shared.Utils.Math.GridMath)
local BlockKey = require(ReplicatedStorage.Shared.Utils.String.BlockKey)
local IslandPlacer = {}

function IslandPlacer.PlaceBlock(player: Player, pos, blockId)
	local island = IslandData.Get(player)
	if not island then
		return
	end

	local blocks = island.IslandData.Blocks

	local gridPos = pos --Vector3.new(math.floor(pos.X + 0.5), math.floor(pos.Y + 0.5), math.floor(pos.Z + 0.5))
	if
		not BlockLibrary.blockDefinitions[blockId].transparent
		and ItemLibrary.itemDefinitions[blockId].type ~= "sapling"
	then
		EnvironmentChecks.CheckGrass(player, gridPos)
	end

	local key = BlockKey(gridPos)

	if blocks[key] and blocks[key].parent then
		return false
	end

	if ItemLibrary.itemDefinitions[blockId].type == "block" and ItemLibrary.itemDefinitions[blockId].falling then
		local blockBelowKey = BlockKey(GridMath.gridPosUnder(gridPos))
		if not blocks[blockBelowKey] then
			-- raycast down a bit to see if there's any anchored baseplate or part
			local worldPos = gridPos * 4 + island.PlotPosition
			local result = Collision.sweepRay(
				BlockHelpers.GetBottomCorners(worldPos, Vector3.new(2, 2, 2) * 0.98),
				Vector3.new(0, -0.1, 0)
			)
			if not (result and result.Instance and result.Instance.Anchored) then
				IslandPlacer.PlaceFallingBlock(player, gridPos, blockId)
				return true
			end
		end
	end

	if ItemLibrary.itemDefinitions[blockId].type == "block" then
		blocks[key] = { id = blockId }
	elseif ItemLibrary.itemDefinitions[blockId].type == "sapling" then
		local checkPos: Vector3 = Vector3.new(pos.X, pos.Y - 1, pos.Z)
		local checkPosStr: string = BlockCoord.GetName(checkPos)
		if not blocks[checkPosStr] then
			return false
		end
		if blocks[checkPosStr].id == "grass" then
			blocks[key] = { id = blockId, growTime = ItemLibrary.itemDefinitions[blockId].growTime }
			TreeService.AddSapling(
				player,
				key,
				{ id = blockId, growTime = ItemLibrary.itemDefinitions[blockId].growTime }
			)
		else
			return false
		end
	end

	local block = IslandRenderer.SetBlock(island.IslandModel, gridPos + island.PlotPosition / 4, blockId)
	block.Name = BlockCoord.GetName(gridPos)

	if ItemLibrary.itemDefinitions[blockId].id == "grass" then
		EnvironmentChecks.CheckGrass(player, gridPos)
	end

	QuestService.HandleEvent(player, {
		type = "place",
		id = blockId,
		amount = 1,
	})
	return true
end

function IslandPlacer.PlaceFallingBlock(player: Player, gridPos: Vector3, blockId: string)
	EntityService.SpawnFallingBlock(
		player,
		IslandData.Get(player).PlotPosition + gridPos * 4,
		blockId,
		function(plr: Player, pos: Vector3, id: string)
			local gridpos = GridMath.posToGridPos(pos, IslandData.Get(player).PlotPosition)
			IslandPlacer.PlaceBlock(plr, gridpos, id)
		end
	)
end

function IslandPlacer.PlaceModel(player: Player, pos: Vector3, modelId: string, QuestService)
	local modelStructure = ModelLibrary[modelId]

	local island = IslandData.Get(player)
	if not island then
		return false
	end

	local gridPos = pos --Vector3.new(math.floor(pos.X + 0.5), math.floor(pos.Y + 0.5), math.floor(pos.Z + 0.5))

	local key = BlockCoord.GetName(gridPos)
	island.IslandData.Blocks[key] = { id = modelId, blocked = {} }
	for _, position in modelStructure.blocked do
		local addKey = BlockCoord.GetName(gridPos + position)
		island.IslandData.Blocks[addKey] = { parent = key }
		table.insert(island.IslandData.Blocks[key].blocked, addKey)
	end

	local block = IslandRenderer.SetBlock(island.IslandModel, gridPos + island.PlotPosition / 4, modelId)
	block.Name = BlockCoord.GetName(gridPos)

	QuestService.HandleEvent(player, {
		type = "place",
		id = modelId,
		amount = 1,
	})
	return true
end

return IslandPlacer
