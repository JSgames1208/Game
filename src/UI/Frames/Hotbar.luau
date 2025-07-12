local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local HotbarSlot = require(StarterGui.UI.Components.HotbarSlot)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

local function Hotbar(scope: typeof(Fusion.scoped(Fusion)))
	local s = scope:innerScope({
		HotbarSlot = HotbarSlot,
	})
	local children = {}
	for i = 1, 9 do
		children[i] = s:HotbarSlot(i)
		children[i]:SetAttribute("SlotIndex", i)
	end

	return scope:New("Frame")({
		Name = "Hotbar",
		Size = UDim2.new(0.6, 0, 0.1, 0),
		Position = UDim2.new(0.5, 0, 0.975, 0),
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 1),
		Visible = true,
		ClipsDescendants = false,

		[Children] = {
			scope:New("UIAspectRatioConstraint")({
				AspectRatio = 10,
			}),
			scope:New("UIListLayout")({
				Padding = UDim.new(0.013, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			children,
		},
	})
end

return Hotbar
