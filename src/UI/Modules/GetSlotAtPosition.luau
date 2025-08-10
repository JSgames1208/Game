local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer.PlayerGui
return function(x: number, y: number)
	local objects = PlayerGui:GetGuiObjectsAtPosition(x, y)

	for _, obj in pairs(objects) do
		if obj:GetAttribute("SlotIndex") then
			if obj.Parent == PlayerGui.MainGui.Hotbar then
				return obj
			end
		end
	end

	return nil
end
