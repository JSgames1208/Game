local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

return function(pos: Vector2)
	local WindowGui = PlayerGui:WaitForChild("WindowGui")

	local objs = PlayerGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
	local topWindow = nil
	local topZ = -math.huge

	for _, obj in ipairs(objs) do
		local window = nil

		for _, w in pairs(WindowGui:GetChildren()) do
			if obj:IsDescendantOf(w) then
				window = w
				break
			end
		end

		if window and window.ZIndex > topZ then
			topWindow = window
			topZ = window.ZIndex
		end
	end

	return topWindow
end
