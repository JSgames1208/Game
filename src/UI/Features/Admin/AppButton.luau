local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local AppIcons = require(StarterPlayer.StarterPlayerScripts.Client.Admin.AppIcons)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local OnEvent = Fusion.OnEvent

local Children = Fusion.Children

local function AppButton(scope: typeof(Fusion.scoped(Fusion)), appName: string, mouseDown: () -> (), mouseUp: () -> ())
	local animSize = scope:Value(1)
	local animTransparency = scope:Value(1)

	return scope:New("ImageButton")({
		Name = "App_" .. appName,
		Image = AppIcons[appName] or "",
		Size = scope:Spring(
			scope:Computed(function(use)
				return UDim2.new(0.9 * use(animSize), 0, 0.9 * use(animSize), 0)
			end),
			30,
			1
		),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = scope:Spring(
			scope:Computed(function(use)
				return use(animTransparency)
			end),
			30,
			1
		),
		[OnEvent("MouseEnter")] = function()
			animTransparency:set(0.8)
		end,
		[OnEvent("MouseLeave")] = function()
			animTransparency:set(1)
		end,
		[OnEvent("MouseButton1Down")] = function()
			mouseDown()
			animSize:set(0.9)
			animTransparency:set(0.9)
		end,
		[OnEvent("MouseButton1Up")] = function()
			mouseUp()
			animSize:set(1)
			animTransparency:set(0.8)
		end,
		[Children] = {
			scope:New("UICorner")({
				CornerRadius = UDim.new(0.1, 0),
			}),
		},
	})
end

return AppButton
