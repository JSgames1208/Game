local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local function AppBar(scope: typeof(Fusion.scoped(Fusion)))
	return scope:New("Frame")({
		Name = "AppBar",
		Size = UDim2.new(1, 0, 0.033, 0),
	})
end

return AppBar
