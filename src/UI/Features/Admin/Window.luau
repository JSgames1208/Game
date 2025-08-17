local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local ConnectResize = require(StarterPlayer.StarterPlayerScripts.Client.Admin.Helpers.ConnectResize)
local Contents = require(script.Parent.WindowParts.Contents)
local ResizeBar = require(script.Parent.WindowParts.ResizeBar)
local GetTopMostWindowAtPosition =
	require(StarterPlayer.StarterPlayerScripts.Client.Admin.Helpers.GetTopMostWindowAtPosition)
local TopBar = require(script.Parent.WindowParts.TopBar)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local function Window(
	scope: typeof(Fusion.scoped(Fusion)),
	appName: string?,
	clickCallback: (Frame) -> (),
	closeCallback: (string) -> ()
): Frame
	local isHovering = false

	local frame: Frame

	local function onMouseEnter()
		isHovering = true
	end

	local function onMouseLeave()
		isHovering = false
	end

	local function onInputBegan(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and isHovering then
			local x, y = input.Position.X, input.Position.Y
			local topWindow = GetTopMostWindowAtPosition(Vector2.new(x, y))
			if topWindow:FindFirstChild("TopBar") == frame and frame.Parent and frame.Parent:IsA("Frame") then
				clickCallback(frame.Parent)
			elseif topWindow == frame then
				clickCallback(frame)
			end
		end
	end

	local right = ResizeBar(scope, "right")
	local left = ResizeBar(scope, "left")
	local top = ResizeBar(scope, "top")
	local bottom = ResizeBar(scope, "bottom")

	frame = scope:New("Frame")({
		Name = appName,
		Size = UDim2.new(0, 400, 0, 300),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 300, 0, 300),
		[OnEvent("MouseEnter")] = onMouseEnter,
		[OnEvent("MouseLeave")] = onMouseLeave,
		[OnEvent("InputBegan")] = onInputBegan,
		[Children] = {
			scope:New("UIStroke")({
				Thickness = 0.5,
				Color = Color3.fromRGB(150, 150, 150),
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Enabled = true,
			}),
			scope:New("UICorner")({
				CornerRadius = UDim.new(0.02, 0),
			}),
			TopBar(scope, appName, clickCallback, closeCallback),
			Contents(scope, appName),

			right,
			left,
			top,
			bottom,
		},
	}) :: Frame

	ConnectResize(right, frame, "right")
	ConnectResize(left, frame, "left")
	ConnectResize(top, frame, "top")
	ConnectResize(bottom, frame, "bottom")

	return frame
end

return Window
