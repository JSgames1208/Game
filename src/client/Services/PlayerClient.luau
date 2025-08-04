local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local NotificationService = require(StarterPlayer.StarterPlayerScripts.Client.Services.NotificationService)
local packets = require(ReplicatedStorage.Shared.network)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local PlayerClient = {}

function PlayerClient.Start()
	packets.Die.listen(function(data)
		print(data.reason)
		PlayerClient.Die(data.reason)
	end)
end

function PlayerClient.Die(reason: string?)
	if reason then
		NotificationService.AddNotification(`You died: {reason}`)
	end

	if character then
		character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
	end
end

return PlayerClient
