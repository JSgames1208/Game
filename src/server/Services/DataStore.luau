local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ItemStack = require(ReplicatedStorage.Shared.Item.ItemStack)
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
	inventory[1] = ItemStack.new("obsidian pickaxe", 1)
	for i = 2, 45 do
		inventory[i] = ItemStack.empty()
	end
	return inventory
end

local profileStore = ProfileService.GetProfileStore("PlayerIslands", {
	Blocks = {},
	Inventory = GetBaseInventory(),
	QuestInfo = {}, -- {questId: string, progress: {collect: {itemId: string = amount: number}?}}
	Currency = 0,
	PlayerInfo = {
		currentHP = 100,
		maxHP = 100,
	},
})

local TEST_MODE = true

local DataStore = {}

DataStore.profiles = {} -- [userId] = profile

function DataStore.LoadPlayerData(player: Player)
	local userId = player.UserId

	if TEST_MODE then
		warn("[TEST_MODE] Skipping data load for userId:", userId)
		local mockProfile = {
			Data = {
				Blocks = table.clone(defaultBlocks),
				Inventory = GetBaseInventory(),
				QuestInfo = {},
				Currency = 0,
			},
			Release = function() end,
		}
		DataStore.profiles[userId] = mockProfile
		return mockProfile.Data
	end

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
	end

	return profile.Data
end

function DataStore.SavePlayerData(userId)
	if TEST_MODE then
		warn("[TEST_MODE] Skipping save for userId:", userId)
		return
	end

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
		if TEST_MODE then
			warn("[TEST_MODE] Skipping profile release for userId:", userId)
			DataStore.profiles[userId] = nil
			return
		end
		profile:Release()
		--profileStore:WipeProfileAsync("Player_" .. userId)
	end
end

return DataStore
