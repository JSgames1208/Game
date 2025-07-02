local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local DataStore = require(ServerScriptService.Server.Modules.DataStore)
local TreeManager = {}

local saplings = {}

local growCallback = nil

function TreeManager.SetOnSaplingGrownCallback(callback)
	growCallback = callback
end

local delta = 0

RunService.Heartbeat:Connect(function(dt: number)
	delta += dt
	if delta > 0.1 then
		delta -= 0.1

		for userId, playerSaplings in saplings do
			for posStr, sapling in playerSaplings do
				sapling.growTime -= 0.1
				if sapling.growTime <= 0 then
					playerSaplings[posStr] = nil
					if growCallback then
						growCallback(Players:GetPlayerByUserId(userId), posStr, sapling)
					end
				end
			end
		end
	end
end)

function TreeManager.PlayerJoined(player: Player)
	saplings[player.UserId] = {}

	local data = DataStore.profiles[player.UserId]

	for posStr, block in data.Data.Blocks do
		if not block.itemInfo or not block.itemInfo.id then
			return
		end
		if ItemLibrary.itemDefinitions[block.itemInfo.id].type == "sapling" then
			saplings[player.UserId][posStr] = block
		end
	end
end

function TreeManager.AddSapling(player: Player, posStr: string, block)
	if ItemLibrary.itemDefinitions[block.id].type == "sapling" then
		saplings[player.UserId][posStr] = { id = block.id, growTime = ItemLibrary.itemDefinitions[block.id].growTime }
	end
end

return TreeManager
