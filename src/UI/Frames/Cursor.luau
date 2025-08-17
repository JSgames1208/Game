local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local function Cursor(scope: typeof(Fusion.scoped(Fusion)), ImageId: Fusion.UsedAs<string>): ImageButton
	return scope:New("ImageLabel")({
		Name = "Cursor",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 32, 0, 32),
		Position = UDim2.new(0, 0, 0, 0),
		Active = false,
		Selectable = false,
		Image = scope:Computed(function(use)
			return use(ImageId)
		end),
		BackgroundTransparency = 1,
	}) :: ImageButton
end

return Cursor
