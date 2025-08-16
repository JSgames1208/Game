local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

return function(except: Frame): ()
	local WindowGui = PlayerGui:WaitForChild("WindowGui")

	if WindowGui and WindowGui:GetChildren() then
		for _, w in WindowGui:GetChildren() do
			if w ~= except then
				w.ZIndex -= 1
			end
		end
	end

	return
end
