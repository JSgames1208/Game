local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.ServerPackages.ProfileService)

local defaultBlocks = {}
for x = -5, 5 do
	for z = -5, 5 do
		if (x + z) % 2 == 0 then
			defaultBlocks[tostring(x) .. ",0," .. tostring(z)] = "grass"
		else
			defaultBlocks[tostring(x) .. ",0," .. tostring(z)] = "dirt"
		end
	end
end

local function GetBaseInventory()
	local inventory = {}
	inventory[1] = { id = "wooden pickaxe", count = 1 }
	for i = 2, 9 do
		inventory[i] = { id = "nothing", count = 0 }
	end
	return inventory
end

local profileStore = ProfileService.GetProfileStore("PlayerIslands", {
	Blocks = {},
	Progress = {},
	Inventory = GetBaseInventory(),
})

local DataStore = {}

DataStore.profiles = {} -- [userId] = profile

function DataStore.LoadPlayerData(userId)
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
		-- profile:ListenToRelease will clear profiles[userId] automatically
	end
end

return DataStore
