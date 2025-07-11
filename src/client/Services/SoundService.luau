local StarterPlayer = game:GetService("StarterPlayer")
local SoundIds = require(StarterPlayer.StarterPlayerScripts.Client.Modules.SoundIds)
local SoundService = {}

function SoundService:Play(soundName: string, position: Vector3?)
	local soundId = SoundIds[soundName]
	if not soundId then
		warn(`Sound {soundName} not found`)
		return
	end

	local sound = Instance.new("Sound")
	sound.SoundId = soundId
	sound.Volume = 0.6
	sound.RollOffMaxDistance = 40

	if position then
		local attachment = Instance.new("Attachment")
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false
		part.Transparency = 1
		part.Size = Vector3.new(1, 1, 1)
		part.Position = position
		part.Parent = workspace

		attachment.Parent = part
		sound.Parent = attachment

		sound:Play()

		sound.Ended:Connect(function()
			part:Destroy()
		end)
	else
		sound.Parent = workspace
		sound:Play()
	end

	game:GetService("Debris"):AddItem(sound, sound.TimeLength + 1)
end

return SoundService
