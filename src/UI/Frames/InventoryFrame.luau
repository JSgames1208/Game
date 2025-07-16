local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local HotbarSlot = require(StarterGui.UI.Features.Inventory.HotbarSlot)
local InventorySlot = require(StarterGui.UI.Features.Inventory.InventorySlot)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

local function InventoryFrame(scope: typeof(Fusion.scoped(Fusion)))
	local hotbarChildren = {}
	for i = 1, 9 do
		local hotbarSlot = HotbarSlot(scope, i)
		hotbarSlot:SetAttribute("SlotIndex", i)
		table.insert(hotbarChildren, hotbarSlot)
	end

	local rowChildren = {}
	for i = 1, 9 do
		local inventorySlot = InventorySlot(scope)
		inventorySlot:SetAttribute("SlotIndex", i)
		table.insert(rowChildren, inventorySlot)
	end

	local function cloneTableWFrames(tbl)
		if not tbl then
			warn("cloneTableWFrames called with nil!")
			return {}
		end
		local t = {}
		for _, i in ipairs(tbl) do
			if i:IsA("Frame") then
				table.insert(t, i:Clone())
			end
		end
		return t
	end

	local row = scope:New("Frame")({
		Name = "Row",
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		[Children] = {
			scope:New("UIAspectRatioConstraint")({
				AspectRatio = 10,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width,
			}),
			scope:New("UIListLayout")({
				Padding = UDim.new(0.013, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			table.unpack(cloneTableWFrames(rowChildren)),
		},
	})

	local function makeRow(index)
		local cloned = row:Clone()
		cloned:SetAttribute("RowIndex", index)
		return cloned
	end

	local rows = {}
	for i = 1, 4 do
		rows[i] = makeRow(i)
	end

	return scope:New("Frame")({
		Name = "Inventory",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(83, 83, 83),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0.55, 0, 0.324, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		Visible = false,
		[Children] = {
			scope:New("Frame")({
				Name = "Hotbar",
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.975, 0),
				Size = UDim2.new(0.97, 0, 0.97, 0),
				[Children] = {
					scope:New("UIAspectRatioConstraint")({
						AspectRatio = 10,
						AspectType = Enum.AspectType.FitWithinMaxSize,
						DominantAxis = Enum.DominantAxis.Width,
					}),
					scope:New("UIListLayout")({
						Padding = UDim.new(0.013, 0),
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						ItemLineAlignment = Enum.ItemLineAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),
					table.unpack(hotbarChildren),
				},
			}),
			scope:New("Frame")({
				Name = "MainInventory",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.4, 0),
				Size = UDim2.new(0.97, 0, 0.97, 0),
				[Children] = {
					scope:New("UIAspectRatioConstraint")({
						AspectRatio = 2.3,
						AspectType = Enum.AspectType.ScaleWithParentSize,
						DominantAxis = Enum.DominantAxis.Width,
					}),
					scope:New("UIListLayout")({
						Padding = UDim.new(0.025, 0),
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
						VerticalAlignment = Enum.VerticalAlignment.Top,
					}),
					table.unpack(rows),
				},
			}),
		},
	})
end

return InventoryFrame
