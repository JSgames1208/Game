local ServerScriptService = game:GetService("ServerScriptService")
local Player = require(ServerScriptService.Server.Classes.Player)
local PlayerManager = {}

local PlayerList = {} --{userId: Player Object}

--[[
PlayerManager.luau:

--PlayerJoined: 
    -Create Player Object
    -Initialize Player with values from DataStore
--PlayerLeaving:
    -Save player data, like health, in DataStore
    -Cleanup the Player Object
]]

function PlayerManager.PlayerJoined(player: Player)
	local PlayerObj = Player.new(player)
	PlayerList[player.UserId] = PlayerObj

	task.delay(5, function()
		PlayerList[player.UserId]:removeHealth(100)
	end)
end

function PlayerManager.PlayerLeaving(player: Player)
	if PlayerList[player.UserId] then
		PlayerList[player.UserId] = nil
	end
end

function PlayerManager.Get(player: Player)
	if PlayerList[player.UserId] then
		return PlayerList[player.UserId]
	else
		warn("Player Object not found for player: " .. player.Name)
		return nil
	end
end

return PlayerManager
