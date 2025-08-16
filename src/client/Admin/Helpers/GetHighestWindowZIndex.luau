local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

return function(): number
	local WindowGui = PlayerGui:WaitForChild("WindowGui")

	local max = 0

	if WindowGui and WindowGui:GetChildren() then
		for _, w in WindowGui:GetChildren() do
			if w.ZIndex and w.ZIndex > max then
				max = w.ZIndex
			end
		end
	end

	return max
end
