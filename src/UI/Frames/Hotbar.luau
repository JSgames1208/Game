local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local HotbarSlot = require(StarterGui.UI.Features.Inventory.HotbarSlot)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

local function Hotbar(scope: typeof(Fusion.scoped(Fusion)))
	local children = {}
	for i = 1, 9 do
		children[i] = HotbarSlot(scope, i)
		children[i]:SetAttribute("SlotIndex", i)
	end

	print(children, #children)

	return scope:New("Frame")({
		Name = "Hotbar",
		Size = UDim2.new(0.5, 0, 0.05, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.975, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		[Children] = {
			children,
			scope:New("UIListLayout")({
				Padding = UDim.new(0.013, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
		},
	})
end

return Hotbar
