local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local BlockCoord = require(ReplicatedStorage.Shared.Utils.BlockCoord)
local DataStore = require(script.Parent.DataStore)
local TreeService = {}

local saplings = {}

local growCallback = nil

function TreeService.SetOnSaplingGrownCallback(callback)
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
					local blocks = workspace.IslandsFolder:FindFirstChild(userId .. "_Island")
					if
						blocks:FindFirstChild(BlockCoord.GetName(BlockCoord.ParsePos(posStr) + Vector3.new(0, 1, 0)))
					then
						continue
					end
					playerSaplings[posStr] = nil
					if growCallback then
						growCallback(Players:GetPlayerByUserId(userId), posStr, sapling)
					end
				end
			end
		end
	end
end)

function TreeService.PlayerJoined(player: Player)
	saplings[player.UserId] = {}

	local profile = DataStore.profiles[player.UserId]
	for posStr, block in profile.Data.Blocks do
		if not block or not block.id then
			continue
		end
		if ItemLibrary.itemDefinitions[block.id].type == "sapling" then
			saplings[player.UserId][posStr] = block
		end
	end
end

function TreeService.PlayerLeaving(player: Player)
	local profile = DataStore.profiles[player.UserId]
	local blocks = profile.Data.Blocks
	if not saplings[player.UserId] then
		return
	end
	for posStr, sapling in saplings[player.UserId] do
		if blocks[posStr] then
			blocks[posStr] = sapling
		end
	end

	saplings[player.UserId] = nil
end

function TreeService.AddSapling(player: Player, posStr: string, block)
	if ItemLibrary.itemDefinitions[block.id].type == "sapling" then
		saplings[player.UserId][posStr] = { id = block.id, growTime = ItemLibrary.itemDefinitions[block.id].growTime }
	end
end

return TreeService
