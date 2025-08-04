local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local EntityService = require(ReplicatedStorage.Shared.Entity.EntityService)
local EnvironmentChecks = require(script.Parent.EnvironmentChecks)
local IslandRenderer = require(ServerScriptService.Server.Modules.IslandRenderer)
local InventoryServer = require(ServerScriptService.Server.Services.InventoryServer)
local QuestService = require(ServerScriptService.Server.Services.QuestService)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local packets = require(ReplicatedStorage.Shared.network)
local IslandData = require(script.Parent.IslandData)

local IslandRemover = {}

function IslandRemover.MineBlock(player: Player, pos: string, PlaceFallingBlockFn: (Player, Vector3, string, any) -> ())
	local island = IslandData.Get(player)
	local blocks = island.IslandData.Blocks
	local block = blocks[pos]
	if block then
		local toolId = InventoryServer.GetSelected(player)

		if not toolId then
			return
		end
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

				QuestService.HandleEvent(player, {
					type = "mine",
					id = block.id,
					amount = 1,
				})

				EnvironmentChecks.CheckBlockAbove(player, pos, PlaceFallingBlockFn, EntityService)

				EnvironmentChecks.CheckDirt(player, pos)
			end
		end
	end
end

return IslandRemover
