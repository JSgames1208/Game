local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local BlockHealthBar = require(StarterPlayer.StarterPlayerScripts.Client.Classes.BlockHealthBar)
local packets = require(ReplicatedStorage.Shared.network)

local player = Players.LocalPlayer

local island = workspace:FindFirstChild("IslandsFolder"):WaitForChild(player.UserId .. "_Island")

local HealthBarManager = {}

local HealthBars = {}

packets.MineBlock.listen(function(data)
	local pos = data.blockPosStr
	if pos then
		local block = island:FindFirstChild(pos)
		if block then
			local HealthBar = if HealthBars[block] then HealthBars[block].hb else nil
			if not HealthBar then
				HealthBar = BlockHealthBar.new(block)
			end

			HealthBar:UpdateHP(block:GetAttribute("hp"))

			HealthBars[block] = { hb = HealthBar, t = 3 }
		end
	end
end)

local nextCleanup = tick() + 1
RunService.RenderStepped:Connect(function()
	if tick() > nextCleanup then
		nextCleanup += 1
		for block, data in pairs(HealthBars) do
			data.t -= 1
			if data.t <= 0 then
				data.hb:Destroy()
				HealthBars[block] = nil
			end
		end
	end
end)

return HealthBarManager
