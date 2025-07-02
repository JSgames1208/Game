local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local ModelLibrary = require(ReplicatedStorage.Shared.ModelLibrary)
local BlockCoord = require(ReplicatedStorage.Shared.Utility.BlockCoord)
local packets = require(ReplicatedStorage.Shared.network)
local IslandRenderer = require(script.Parent.IslandRenderer)
local DataStore = require(script.Parent.DataStore)
local InventoryManager = require(script.Parent.InventoryManager)
local TreeManager = require(script.Parent.TreeManager)

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
	IslandManager.TeleportToIsland(player)
end

function IslandManager.TeleportToIsland(player: Player)
	if PlayerIslands[player.UserId] then
		if PlayerIslands[player.UserId].PlotPosition then
			local character = player.Character or player.CharacterAdded:Wait()
			local rootPart = character:WaitForChild("HumanoidRootPart")
			rootPart.Position = PlayerIslands[player.UserId].PlotPosition + Vector3.new(0, 10, 0)
		end
	end
end

local function CheckGrass(player: Player, pos: Vector3)
	local island = PlayerIslands[player.UserId]

	local checkPos = Vector3.new(pos.X, pos.Y - 1, pos.Z)
	local checkPosStr = BlockCoord.GetName(checkPos)
	if island.IslandData.Blocks[checkPosStr] and island.IslandData.Blocks[checkPosStr].id == "grass" then
		island.IslandData.Blocks[checkPosStr].id = "dirt"
		IslandRenderer.RemoveBlock(island.IslandModel, checkPosStr)
		IslandRenderer.SetBlock(island.IslandModel, checkPos, "dirt")
	end
end

function IslandManager.PlaceBlock(player: Player, pos, blockId)
	local island = PlayerIslands[player.UserId]
	if not island then
		return
	end

	local gridPos = Vector3.new(
		math.floor(pos.X - island.PlotPosition.X / 4 + 0.5),
		math.floor(pos.Y - island.PlotPosition.Y / 4 + 0.5),
		math.floor(pos.Z - island.PlotPosition.Z / 4 + 0.5)
	)

	if
		not BlockLibrary.blockDefinitions[blockId].transparent
		and ItemLibrary.itemDefinitions[blockId].type ~= "sapling"
	then
		CheckGrass(player, gridPos)
	end

	local key = getBlockKey(gridPos)
	if ItemLibrary.itemDefinitions[blockId].type == "block" then
		island.IslandData.Blocks[key] = { id = blockId }
	elseif ItemLibrary.itemDefinitions[blockId].type == "sapling" then
		island.IslandData.Blocks[key] = { id = blockId, growTime = ItemLibrary.itemDefinitions[blockId].growTime }
		TreeManager.AddSapling(player, key, { id = blockId, growTime = ItemLibrary.itemDefinitions[blockId].growTime })
	end

	IslandRenderer.SetBlock(island.IslandModel, gridPos + island.PlotPosition / 4, blockId)
end

function IslandManager.PlaceModel(player: Player, pos: Vector3, modelId: string)
	local modelStructure = ModelLibrary[modelId]

	local island = PlayerIslands[player.UserId]
	if not island then
		return
	end

	local gridPos = Vector3.new(
		math.floor(pos.X - island.PlotPosition.X / 4 + 0.5),
		math.floor(pos.Y - island.PlotPosition.Y / 4 + 0.5),
		math.floor(pos.Z - island.PlotPosition.Z / 4 + 0.5)
	)

	local key = BlockCoord.GetName(gridPos)
	island.IslandData.Blocks[key] = { id = modelId, blocked = {} }
	for _, position in modelStructure.blocked do
		local addKey = BlockCoord.GetName(gridPos + position)
		island.IslandData.Blocks[addKey] = { parent = key }
		table.insert(island.IslandData.Blocks[key].blocked, addKey)
	end

	IslandRenderer.SetBlock(island.IslandModel, gridPos + island.PlotPosition / 4, modelId)
end

--[[local function CheckGrass(player: Player, pos: Vector3)
	local island = PlayerIslands[player.UserId]

	local checkPos = Vector3.new(pos.X, pos.Y - 1, pos.Z)
	local checkPosStr = BlockCoord.GetName(checkPos)
	if island.IslandData.Blocks[checkPosStr] and island.IslandData.Blocks[checkPosStr].id == "grass" then
		island.IslandData.Blocks[checkPosStr].id = "dirt"
		IslandRenderer.RemoveBlock(island.IslandModel, checkPosStr)
		IslandRenderer.SetBlock(island.IslandModel, checkPos, "dirt")
	end
end]]

local function CheckDirt(player: Player, pos: string)
	local island = PlayerIslands[player.UserId]
	local removedPos: Vector3 = BlockCoord.ParsePos(pos)

	local checkPos: Vector3 = Vector3.new(removedPos.X, removedPos.Y - 1, removedPos.Z)
	local checkPosStr: string = BlockCoord.GetName(checkPos)
	if island.IslandData.Blocks[checkPosStr] and island.IslandData.Blocks[checkPosStr].id == "dirt" then
		island.IslandData.Blocks[checkPosStr].id = "grass"
		IslandRenderer.RemoveBlock(island.IslandModel, checkPosStr)
		IslandRenderer.SetBlock(island.IslandModel, checkPos, "grass")
	end
end

function IslandManager.MineBlock(player: Player, pos: string)
	local island = PlayerIslands[player.UserId]
	print(island.IslandData.Blocks)
	local block = island.IslandData.Blocks[pos]
	if block then
		local toolId = InventoryManager.GetSelected(player)
		if ItemLibrary.itemDefinitions[toolId].type == "tool" then
			island.IslandModel:FindFirstChild(pos):SetAttribute(
				"hp",
				island.IslandModel:FindFirstChild(pos):GetAttribute("hp") - ItemLibrary.itemDefinitions[toolId].strength
			)
			packets.MineBlock.sendTo({ blockPosStr = pos }, player)
			if island.IslandModel:FindFirstChild(pos):GetAttribute("hp") <= 0 then
				IslandRenderer.RemoveBlock(island.IslandModel, pos)
				if island.IslandData.Blocks[pos].blocked then
					for _, blockedPos in island.IslandData.Blocks[pos].blocked do
						if island.IslandData.Blocks[blockedPos].parent == pos then
							island.IslandData.Blocks[blockedPos] = nil
						end
					end
				end
				island.IslandData.Blocks[pos] = nil
				CheckDirt(player, pos)
				InventoryManager.GiveItem(player, block.id, ItemLibrary.itemDefinitions[block.id].dropAmount)
			end
		end
	end
end

packets.MineBlock.listen(function(data, player: Player)
	IslandManager.MineBlock(player, data.blockPosStr)
end)

function IslandManager.LoadIsland(player: Player)
	local plotIndex, plotPos = IslandManager.AssignPlotToPlayer(player)
	local islandData = DataStore.LoadPlayerData(player.UserId) or {}

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
	DataStore.ReleasePlayerData(player.UserId)
	PlayerIslands[player.UserId].IslandModel:Destroy()
	IslandManager.ReleasePlot(player)
end

packets.PlaceBlock.listen(function(data, player)
	local pos = Vector3.new(data.x, data.y, data.z)
	local blockId = data.blockId
	if InventoryManager.IsAvailable(player, 1) then
		InventoryManager.RemoveItem(player, 1)
		IslandManager.PlaceBlock(player, pos, blockId)
	end
end)

TreeManager.SetOnSaplingGrownCallback(function(player: Player, posStr: string, _)
	local coord: Vector3 = BlockCoord.ParsePos(posStr)
	local island = PlayerIslands[player.UserId]
	if not island.IslandModel:FindFirstChild(posStr) then
		return
	end
	if island then
		IslandRenderer.RemoveBlock(island.IslandModel, posStr)
		IslandManager.PlaceModel(player, coord, "pine tree")
	end
end)

return IslandManager
