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

local profileStore = ProfileService.GetProfileStore("PlayerIslands", {
	Blocks = defaultBlocks,
	Progress = {},
})

local IslandDataStore = {}

IslandDataStore.profiles = {} -- [userId] = profile

function IslandDataStore.LoadPlayerData(userId)
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

		IslandDataStore.profiles[userId] = profile

		-- Listen to release to cleanup cache
		profile:ListenToRelease(function()
			IslandDataStore.profiles[userId] = nil
		end)

		print(profile.Data)
	else
		-- Always reconcile after load to fill missing fields
		profile.Data = {
			Blocks = defaultBlocks,
			Progress = {},
		}
		profile:Reconcile()

		IslandDataStore.profiles[userId] = profile

		-- Listen to release to cleanup cache
		profile:ListenToRelease(function()
			IslandDataStore.profiles[userId] = nil
		end)

		print(profile.Data)
	end

	return profile.Data
end

function IslandDataStore.SavePlayerData(userId)
	local profile = IslandDataStore.profiles[userId]
	if profile then
		local success, err = pcall(function()
			profile:Save()
		end)
		if not success then
			warn("Failed to save profile for userId:", userId, err)
		end
	end
end

function IslandDataStore.ReleasePlayerData(userId)
	local profile = IslandDataStore.profiles[userId]
	if profile then
		profile:Release()
		-- profile:ListenToRelease will clear profiles[userId] automatically
	end
end

return IslandDataStore
