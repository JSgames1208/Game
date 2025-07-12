local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventorySlot = require(script.Parent.InventorySlot)
local TextLabel = require(script.Parent.TextLabel)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local function HotbarSlot(scope: typeof(Fusion.scoped(Fusion)), slotIndex: number)
	local s = scope:innerScope({
		InventorySlot = InventorySlot,
		TextLabel = TextLabel,
	})

	local slot = s:InventorySlot()

	scope:New("TextLabel")({
		AnchorPoint = Vector2.zero,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Name = "TextLabel",
		Text = tostring(slotIndex),
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0.3, 0, 0.4, 0),
		FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold),
		TextScaled = true,
		TextTransparency = 0.5,
		Parent = slot,
	} :: TextLabel.TextLabelProps)

	return slot
end

return HotbarSlot
