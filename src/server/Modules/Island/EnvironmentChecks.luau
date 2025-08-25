local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)
local ItemStack = require(ReplicatedStorage.Shared.Item.ItemStack)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local IslandRenderer = require(ServerScriptService.Server.Modules.IslandRenderer)
local InventoryServer = require(ServerScriptService.Server.Services.InventoryServer)
local QuestService = require(ServerScriptService.Server.Services.QuestService)
local BlockCoord = require(ReplicatedStorage.Shared.Utils.BlockCoord)
local IslandData = require(script.Parent.IslandData)
local EnvironmentChecks = {}

function EnvironmentChecks.CheckGrass(player: Player, pos: Vector3)
	local island = IslandData.Get(player)

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

function EnvironmentChecks.CheckBlockAbove(
	player: Player,
	pos: string,
	PlaceFallingBlockFn: (Player, Vector3, string, any) -> (),
	EntityService
)
	local island = IslandData.Get(player)
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
				InventoryServer.insertStack(player, ItemStack.new(drop, amount))
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
			PlaceFallingBlockFn(player, checkPos, id, EntityService)
			task.wait(0.05)
			EnvironmentChecks.CheckBlockAbove(player, checkPosStr, PlaceFallingBlockFn)
		end
	end
end

function EnvironmentChecks.CheckDirt(player: Player, pos: string)
	local island = IslandData.Get(player)
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

return EnvironmentChecks
