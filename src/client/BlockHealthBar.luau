local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local packets = require(ReplicatedStorage.Shared.network)
local Assets = ReplicatedStorage:FindFirstChild("Assets")
local UIAssets = Assets:FindFirstChild("UI")
local HealthBarTemplate = UIAssets:FindFirstChild("HealthBar")

local player = Players.LocalPlayer

local island = workspace:FindFirstChild("IslandsFolder"):WaitForChild(player.Name .. "_Island")

local BlockHealthBar = {}

local HealthBars = {}

function BlockHealthBar.Start()
	packets.MineBlock.listen(function(data)
		local pos = data.blockPosStr
		if pos then
			local block = island:FindFirstChild(pos)
			if block then
				local HealthBar = block:FindFirstChildOfClass("BillboardGui")
				if not HealthBar then
					HealthBar = HealthBarTemplate:Clone()
					HealthBar.Parent = block
				end

				local maxhp = block:GetAttribute("maxhp")
				local hp = block:GetAttribute("hp")

				HealthBar:FindFirstChild("Health").Size = UDim2.new(hp / maxhp, 0, 1, 0)

				HealthBars[HealthBar] = 7
			end
		end
	end)

	local delta = 0
	RunService.RenderStepped:Connect(function(dt)
		delta += dt
		if delta > 1 then
			delta -= 1
			for hb, _ in pairs(HealthBars) do
				HealthBars[hb] -= 1
				if HealthBars[hb] <= 0 then
					hb:Destroy()
					HealthBars[hb] = nil
				end
			end
		end
	end)
end

return BlockHealthBar
