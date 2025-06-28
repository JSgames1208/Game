local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local packets = require(ReplicatedStorage.Shared.network)
local IslandRenderer = require(script.Parent.IslandRenderer)
local DataStore = require(script.Parent.DataStore)
local InventoryManager = require(script.Parent.InventoryManager)

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

	print(gridPos)

	local key = getBlockKey(gridPos)
	island.IslandData.Blocks[key] = blockId

	IslandRenderer.SetBlock(island.IslandModel, gridPos + island.PlotPosition / 4, blockId)
end

function IslandManager.RemoveBlock(player: Player, pos: string)
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
			if island.IslandModel:FindFirstChild(pos):GetAttribute("hp") <= 0 then
				IslandRenderer.RemoveBlock(island.IslandModel, pos)
				island.IslandData.Blocks[pos] = nil
			end
		end
	end
end

packets.MineBlock.listen(function(data, player: Player)
	IslandManager.RemoveBlock(player, data.blockPosStr)
end)

function IslandManager.LoadIsland(player: Player)
	local plotIndex, plotPos = IslandManager.AssignPlotToPlayer(player)
	local islandData = DataStore.LoadPlayerData(player.UserId) or {}
	print(islandData)

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

return IslandManager
