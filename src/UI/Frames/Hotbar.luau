local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local AutoScaledFrame = require(StarterGui.UI.Components.AutoScaledFrame)
local HotbarSlot = require(StarterGui.UI.Components.HotbarSlot)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

local function Hotbar(scope: typeof(Fusion.scoped(Fusion)))
	local s = scope:innerScope({
		HotbarSlot = HotbarSlot,
		AutoScaledFrame = AutoScaledFrame,
	})
	local frame = s:AutoScaledFrame({
		Name = "Hotbar",
		Size = UDim2.fromOffset(2082, 207),
		Position = UDim2.new(0.5, 0, 0.975, 0),
		AnchorPoint = Vector2.new(0.5, 1),
	})

	local children = {}
	for i = 1, 9 do
		children[i] = s:HotbarSlot(i)
		children[i]:SetAttribute("SlotIndex", i)
		children[i].Parent = frame
	end

	scope:New("UIAspectRatioConstraint")({
		AspectRatio = 10,
		Parent = frame,
	})
	scope:New("UIListLayout")({
		Padding = UDim.new(0.013, 0),
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		ItemLineAlignment = Enum.ItemLineAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Parent = frame,
	})

	return frame
end

return Hotbar
