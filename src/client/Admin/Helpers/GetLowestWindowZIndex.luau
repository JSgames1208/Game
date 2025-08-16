local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

return function(): number
	local WindowGui = PlayerGui:WaitForChild("WindowGui")

	local min = 0

	if WindowGui and WindowGui:GetChildren() then
		for _, w in WindowGui:GetChildren() do
			if w.ZIndex and w.ZIndex < min then
				min = w.ZIndex
			end
		end
	end

	return min
end
