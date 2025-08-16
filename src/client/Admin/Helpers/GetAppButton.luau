local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local mouse = player:GetMouse()

return function()
	local guiObjects = PlayerGui:GetGuiObjectsAtPosition(mouse.X, mouse.Y)

	if guiObjects then
		for _, guiObject in guiObjects do
			if guiObject:IsA("ImageButton") then
				return guiObject
			end
		end
	end

	return nil
end
