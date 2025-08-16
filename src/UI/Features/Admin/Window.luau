local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local GetTopMostWindowAtPosition =
	require(StarterPlayer.StarterPlayerScripts.Client.Admin.Helpers.GetTopMostWindowAtPosition)
local TopBar = require(script.Parent.WindowParts.TopBar)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local function Window(scope: typeof(Fusion.scoped(Fusion)), appName: string?, clickCallback): Frame
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
			if topWindow:FindFirstChild("TopBar") == frame then
				clickCallback(frame.Parent)
			end
		end
	end

	frame = scope:New("Frame")({
		Name = appName,
		Size = UDim2.new(0, 400, 0, 300),
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 300, 0, 300),
		[OnEvent("MouseEnter")] = onMouseEnter,
		[OnEvent("MouseLeave")] = onMouseLeave,
		[OnEvent("InputBegan")] = onInputBegan,
		[Children] = {
			TopBar(scope, appName, clickCallback),
		},
	}) :: Frame

	return frame
end

return Window
