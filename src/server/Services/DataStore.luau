local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Types = require(ReplicatedStorage.Shared.Types)
local ProfileService = require(ServerScriptService.ServerPackages.ProfileService)

local defaultBlocks = {}
for x = -2, 2 do
	for z = -2, 2 do
		defaultBlocks[tostring(x) .. ",0," .. tostring(z)] = { id = "dirt" }
		defaultBlocks[tostring(x) .. ",1," .. tostring(z)] = { id = "grass" }
	end
end
defaultBlocks["0,0,0"] = { id = "bedrock" }
defaultBlocks["-1,2,-1"] = { id = "pine tree", blocked = { "-1,3,-1" } }
defaultBlocks["-1,3,-1"] = { parent = "-1,2,-1" }

local function GetBaseInventory()
	local inventory = {}
	inventory[1] = { itemInfo = { id = "wooden pickaxe" }, count = 1 }
	inventory[2] = { itemInfo = { id = "golden pickaxe" }, count = 1 }
	inventory[3] = { itemInfo = { id = "diamond pickaxe" }, count = 1 }
	inventory[4] = { itemInfo = { id = "obsidian pickaxe" }, count = 1 }
	for i = 5, 9 do
		inventory[i] = { itemInfo = { id = "dirt" }, count = 1 }
	end
	for i = 10, 45 do
		inventory[i] = { itemInfo = { id = "nothing" }, count = 0 }
	end
	return inventory
end

local profileStore = ProfileService.GetProfileStore("PlayerIslands", {
	Blocks = {},
	Inventory = GetBaseInventory(),
	QuestInfo = {}, -- {questId: string, progress: {collect: {itemId: string = amount: number}?}}
	Currency = 0,
})

local DataStore = {}

DataStore.profiles = {} -- [userId] = profile

function DataStore.LoadPlayerData(player: Player)
	local userId = player.UserId

	local success, profile = pcall(function()
		return profileStore:LoadProfileAsync("Player_" .. userId)
	end)

	if not success then
		warn("Failed to load profile for userId:", userId)
		return nil
	end

	if profile then
		-- Always reconcile after load to fill missing fields
		profile:Reconcile()

		if not profile.Data.Blocks or next(profile.Data.Blocks) == nil then
			profile.Data.Blocks = table.clone(defaultBlocks)
		end

		profile.Data = profile.Data :: Types.ProfileData

		DataStore.profiles[userId] = profile

		-- Listen to release to cleanup cache
		profile:ListenToRelease(function()
			DataStore.profiles[userId] = nil
		end)
		--[[else
		-- Always reconcile after load to fill missing fields
		profile.Data = {
			Blocks = defaultBlocks,
			Progress = {},
			Inventory = GetBaseInventory(),
		}
		profile:Reconcile()

		DataStore.profiles[userId] = profile

		-- Listen to release to cleanup cache
		profile:ListenToRelease(function()
			DataStore.profiles[userId] = nil
		end)]]
	end

	return profile.Data
end

function DataStore.SavePlayerData(userId)
	local profile = DataStore.profiles[userId]
	if profile then
		local success, err = pcall(function()
			profile:Save()
		end)
		if not success then
			warn("Failed to save profile for userId:", userId, err)
		end
	end
end

function DataStore.ReleasePlayerData(userId)
	local profile = DataStore.profiles[userId]
	if profile then
		profile:Release()
		--profileStore:WipeProfileAsync("Player_" .. userId, false)
	end
end

return DataStore
