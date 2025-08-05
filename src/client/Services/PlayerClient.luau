local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local PlayerHealthBar = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Player.PlayerHealthBar)
local NotificationService = require(StarterPlayer.StarterPlayerScripts.Client.Services.NotificationService)
local packets = require(ReplicatedStorage.Shared.network)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local PlayerClient = {}

function PlayerClient.Start()
	PlayerHealthBar.Init(100, 100)

	packets.Die.listen(function(data)
		PlayerClient.Die(data.reason)
	end)

	packets.SetHealth.listen(function(data)
		local c = data.currentHP
		local m = data.maxHP
		if c then
			PlayerHealthBar.SetCurrentHP(c)
		end

		if m then
			PlayerHealthBar.SetMaxHP(m)
		end
	end)
end

function PlayerClient.Die(reason: string?)
	if reason then
		NotificationService.AddNotification(`You died: {reason}`)
	end

	PlayerHealthBar.SetCurrentHP(0)

	if character then
		character.Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
		task.wait(0.5)
		character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		task.wait(4.5)
		character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)

		PlayerHealthBar.SetCurrentHP("max")
	end
end

return PlayerClient
