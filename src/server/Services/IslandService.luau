local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local IslandRenderer = require(ServerScriptService.Server.Modules.IslandRenderer)
local InventoryServer = require(script.Parent.InventoryServer)
local DataStore = require(ServerScriptService.Server.Services.DataStore)
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)
local EntityService = require(ReplicatedStorage.Shared.Entity.EntityService)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local ModelLibrary = require(ReplicatedStorage.Shared.ModelLibrary)
local BlockHelpers = require(ReplicatedStorage.Shared.Modules.BlockHelpers)
local Collision = require(ReplicatedStorage.Shared.Physics.Collision)
local BlockCoord = require(ReplicatedStorage.Shared.Utils.BlockCoord)
local GridMath = require(ReplicatedStorage.Shared.Utils.Math.GridMath)
local packets = require(ReplicatedStorage.Shared.network)
local TreeService = require(script.Parent.TreeService)
local QuestService = require(ServerScriptService.Server.Services.QuestService)

local IslandService = {}

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

function IslandService.AssignPlotToPlayer(player: Player)
	for index, pos in ipairs(PlotSlots) do
		if not OccupiedSlots[index] then
			OccupiedSlots[index] = player.UserId
			return index, pos
		end
	end

	player:Kick("No available plots!")
	error("No available plots!")
end

function IslandService.ReleasePlot(player: Player)
	local info = PlayerIslands[player.UserId]
	if info then
		OccupiedSlots[info.PlotIndex] = nil
		if info.IslandModel then
			info.IslandModel:Destroy()
		end
		PlayerIslands[player.UserId] = nil
	end
end

function IslandService.PlayerJoined(player: Player)
	IslandService.LoadIsland(player)
	task.wait(1.5)
	IslandService.TeleportToIsland(player)

	TreeService.PlayerJoined(player)
end

function IslandService.LoadIsland(player: Player)
	local plotIndex, plotPos = IslandService.AssignPlotToPlayer(player)
	local islandData = DataStore.profiles[player.UserId].Data

	local islandModel = IslandRenderer.RenderIsland(islandData, plotPos)
	islandModel.Name = player.UserId .. "_Island"
	islandModel.Parent = workspace.IslandsFolder

	PlayerIslands[player.UserId] = {
		PlotIndex = plotIndex,
		PlotPosition = plotPos,
		IslandData = islandData,
		IslandModel = islandModel,
	}

	local blocks = PlayerIslands[player.UserId].IslandData.Blocks

	for posStr, block in blocks do
		if block.parent then
			if blocks[block.parent] then
				if not (blocks[block.parent].blocked and table.find(blocks[block.parent].blocked, posStr)) then
					blocks[posStr] = nil
				end
			end
		end
	end

	print(plotPos)

	packets.AssignPlot.sendTo(plotPos, player)
	--return islandModel
end

function IslandService.TeleportToIsland(player: Player)
	task.wait(0.5)
	if not player then
		return
	end
	if PlayerIslands[player.UserId] then
		if PlayerIslands[player.UserId].PlotPosition then
			local character = player.Character or player.CharacterAdded:Wait()
			--local rootPart = character:WaitForChild("HumanoidRootPart")
			--rootPart.Position = PlayerIslands[player.UserId].PlotPosition + Vector3.new(0, 10, 0)
			character:PivotTo(CFrame.new(PlayerIslands[player.UserId].PlotPosition + Vector3.new(0, 10, 0)))
		end
	end
end

local function CheckGrass(player: Player, pos: Vector3)
	local island = PlayerIslands[player.UserId]

	local blocks = island.IslandData.Blocks

	local checkPos = Vector3.new(pos.X, pos.Y - 1, pos.Z)
	local checkPosStr = BlockCoord.GetName(checkPos)
	if blocks[checkPosStr] and blocks[checkPosStr].id == "grass" then
		blocks[checkPosStr].id = "dirt"
		IslandRenderer.RemoveBlock(island.IslandModel, checkPosStr)
		local block = IslandRenderer.SetBlock(island.IslandModel, checkPos + island.PlotPosition / 4, "dirt")
		block.Name = BlockCoord.GetName(checkPos)
	end

	local posStr = BlockCoord.GetName(pos)
	if blocks[posStr] and blocks[posStr].id == "grass" then
		checkPos = Vector3.new(pos.X, pos.Y + 1, pos.Z)
		checkPosStr = BlockCoord.GetName(checkPos)
		if
			blocks[checkPosStr]
			and ItemLibrary.itemDefinitions[blocks[checkPosStr].id].type == "block"
			and not BlockLibrary.blockDefinitions[blocks[checkPosStr].id].transparent
		then
			blocks[posStr].id = "dirt"
			IslandRenderer.RemoveBlock(island.IslandModel, BlockCoord.GetName(pos))
			local block = IslandRenderer.SetBlock(island.IslandModel, pos + island.PlotPosition / 4, "dirt")
			block.Name = BlockCoord.GetName(pos)
		end
	end
end

function IslandService.PlaceFallingBlock(player: Player, gridPos: Vector3, blockId: string)
	EntityService.SpawnFallingBlock(
		player,
		PlayerIslands[player.UserId].PlotPosition + gridPos * 4,
		blockId,
		function(plr: Player, pos: Vector3, id: string)
			local gridpos = GridMath.posToGridPos(pos, PlayerIslands[player.UserId].PlotPosition)
			IslandService.PlaceBlock(plr, gridpos, id)
		end
	)
end

function IslandService.PlaceBlock(player: Player, pos, blockId)
	local island = PlayerIslands[player.UserId]
	if not island then
		return
	end

	local blocks = island.IslandData.Blocks

	local gridPos = pos --Vector3.new(math.floor(pos.X + 0.5), math.floor(pos.Y + 0.5), math.floor(pos.Z + 0.5))
	if
		not BlockLibrary.blockDefinitions[blockId].transparent
		and ItemLibrary.itemDefinitions[blockId].type ~= "sapling"
	then
		CheckGrass(player, gridPos)
	end

	local key = getBlockKey(gridPos)

	if blocks[key] and blocks[key].parent then
		return false
	end

	if ItemLibrary.itemDefinitions[blockId].type == "block" and ItemLibrary.itemDefinitions[blockId].falling then
		local blockBelowKey = getBlockKey(GridMath.gridPosUnder(gridPos))
		if not blocks[blockBelowKey] then
			-- raycast down a bit to see if there's any anchored baseplate or part
			local worldPos = gridPos * 4 + island.PlotPosition
			local result = Collision.sweepRay(
				BlockHelpers.GetBottomCorners(worldPos, Vector3.new(2, 2, 2) * 0.98),
				Vector3.new(0, -0.1, 0)
			)
			if not (result and result.Instance and result.Instance.Anchored) then
				IslandService.PlaceFallingBlock(player, gridPos, blockId)
				QuestService.HandleEvent(player, {
					type = "place",
					id = blockId,
					amount = 1,
				})
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
		CheckGrass(player, gridPos)
	end

	QuestService.HandleEvent(player, {
		type = "place",
		id = blockId,
		amount = 1,
	})
	return true
end

function IslandService.PlaceModel(player: Player, pos: Vector3, modelId: string)
	local modelStructure = ModelLibrary[modelId]

	local island = PlayerIslands[player.UserId]
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

local function CheckDirt(player: Player, pos: string)
	local island = PlayerIslands[player.UserId]
	local removedPos: Vector3 = BlockCoord.ParsePos(pos)
	local blocks = island.IslandData.Blocks

	local checkPos: Vector3 = Vector3.new(removedPos.X, removedPos.Y - 1, removedPos.Z)
	local checkPosStr: string = BlockCoord.GetName(checkPos)
	if blocks[checkPosStr] and blocks[checkPosStr].id == "dirt" then
		blocks[checkPosStr].id = "grass"
		IslandRenderer.RemoveBlock(island.IslandModel, checkPosStr)
		local block = IslandRenderer.SetBlock(island.IslandModel, checkPos + island.PlotPosition / 4, "grass")
		block.Name = checkPosStr
	end
end

local function CheckBlockAbove(player: Player, pos: string)
	local island = PlayerIslands[player.UserId]
	local removedPos: Vector3 = BlockCoord.ParsePos(pos)
	local blocks = island.IslandData.Blocks

	local checkPos: Vector3 = Vector3.new(removedPos.X, removedPos.Y + 1, removedPos.Z)
	local checkPosStr: string = BlockCoord.GetName(checkPos)
	if blocks[checkPosStr] then
		local id = blocks[checkPosStr].id
		local itemDef = ItemLibrary.itemDefinitions[id]
		local type: string = itemDef.type
		local falling: boolean = itemDef.falling
		if type == "tree" or type == "sapling" then
			for drop, amount in itemDef.drops do
				InventoryServer.GiveItem(player, drop, amount)
				QuestService.HandleEvent(player, {
					type = "collect",
					id = drop,
					amount = amount,
				})
			end
			IslandRenderer.RemoveBlock(island.IslandModel, checkPosStr)
			if blocks[checkPosStr].blocked then
				for _, posStr in blocks[checkPosStr].blocked do
					if blocks[posStr].parent == checkPosStr then
						blocks[posStr] = nil
					end
				end
			end
			blocks[checkPosStr] = nil
		elseif type == "block" and falling then
			IslandRenderer.RemoveBlock(island.IslandModel, checkPosStr)
			blocks[checkPosStr] = nil
			IslandService.PlaceFallingBlock(player, checkPos, id)
			task.wait(0.05)
			CheckBlockAbove(player, checkPosStr)
		end
	end
end

function IslandService.MineBlock(player: Player, pos: string)
	local island = PlayerIslands[player.UserId]
	local blocks = island.IslandData.Blocks
	local block = blocks[pos]
	if block then
		local toolId = InventoryServer.GetSelected(player)
		if ItemLibrary.itemDefinitions[toolId].type == "tool" then
			island.IslandModel:FindFirstChild(pos):SetAttribute(
				"hp",
				island.IslandModel:FindFirstChild(pos):GetAttribute("hp") - ItemLibrary.itemDefinitions[toolId].strength
			)
			packets.MineBlock.sendTo({ blockPosStr = pos }, player)
			if island.IslandModel:FindFirstChild(pos):GetAttribute("hp") <= 0 then
				IslandRenderer.RemoveBlock(island.IslandModel, pos)
				if blocks[pos].blocked then
					for _, blockedPos in blocks[pos].blocked do
						if blocks[blockedPos].parent == pos then
							blocks[blockedPos] = nil
						end
					end
				end
				blocks[pos] = nil

				for itemId, amount in ItemLibrary.itemDefinitions[block.id].drops do
					InventoryServer.GiveItem(player, itemId, amount)
					QuestService.HandleEvent(player, {
						type = "collect",
						id = itemId,
						amount = amount,
					})
				end
				--InventoryServer.GiveItem(player, block.id, ItemLibrary.itemDefinitions[block.id].dropAmount)
				QuestService.HandleEvent(player, {
					type = "mine",
					id = block.id,
					amount = 1,
				})

				CheckBlockAbove(player, pos)

				CheckDirt(player, pos)
			end
		end
	end
end

packets.MineBlock.listen(function(data, player: Player)
	IslandService.MineBlock(player, data.blockPosStr)
end)

function IslandService.PlayerLeaving(player: Player)
	TreeService.PlayerLeaving(player)

	DataStore.ReleasePlayerData(player.UserId)
	PlayerIslands[player.UserId].IslandModel:Destroy()
	IslandService.ReleasePlot(player)
end

packets.PlaceBlock.listen(function(data, player)
	local pos = Vector3.new(data.x, data.y, data.z)
	local blockId = data.blockId
	if InventoryServer.IsAvailable(player, 1) then
		local placed = IslandService.PlaceBlock(player, pos, blockId)
		if placed then
			local island = PlayerIslands[player.UserId]
			InventoryServer.RemoveItem(player, 1)
			local position: Vector3 = pos * 4 + island.PlotPosition
			packets.BlockPlaced.sendTo(position, player)
		end
	end
end)

TreeService.SetOnSaplingGrownCallback(function(player: Player, posStr: string, _)
	local coord: Vector3 = BlockCoord.ParsePos(posStr)
	local island = PlayerIslands[player.UserId]
	if not island.IslandModel:FindFirstChild(posStr) then
		return
	end
	if island then
		IslandRenderer.RemoveBlock(island.IslandModel, posStr)
		IslandService.PlaceModel(player, coord, "pine tree")
	end
end)

--public getters

function IslandService.Get(player: Player)
	return PlayerIslands[player.UserId]
end

return IslandService
