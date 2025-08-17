local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local GetTopMostWindowAtPosition =
	require(StarterPlayer.StarterPlayerScripts.Client.Admin.Helpers.GetTopMostWindowAtPosition)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local function TopBar(scope: typeof(Fusion.scoped(Fusion)), appName: string?, clickCallback): Frame
	local dragging: boolean = false
	local dragStart: Vector3
	local startPos: UDim2
	local frame: Frame = nil

	local function onInputBegan(input: InputObject): ()
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local x, y = input.Position.X, input.Position.Y
			local topWindow = GetTopMostWindowAtPosition(Vector2.new(x, y))
			if topWindow:FindFirstChild("TopBar") == frame then
				if frame.Parent and frame.Parent:IsA("Frame") then
					dragging = true
					dragStart = input.Position
					startPos = frame.Parent.Position
					clickCallback(frame.Parent)
				end
			end
		end
	end

	local function onInputChanged(input: InputObject): ()
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
			local delta = input.Position - dragStart

			if frame.Parent and frame.Parent:IsA("Frame") then
				frame.Parent.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end
	end

	local function onInputEnded(input: InputObject): ()
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end

	frame = scope:New("Frame")({
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 25),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(230, 230, 230),
		ZIndex = 2,
		[OnEvent("InputBegan")] = onInputBegan,
		[Children] = {
			scope:New("UICorner")({
				CornerRadius = UDim.new(0.2, 0),
			}),
			TextLabel(
				scope,
				{
					Size = UDim2.new(0.7, 0, 1, 0),
					Text = ` {appName}` or "",
					TextXAlignment = Enum.TextXAlignment.Left,
					TextScaled = true,
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(0, 0, 0),
				} :: TextLabel.TextLabelProps
			),
			scope:New("UIStroke")({
				Thickness = 0.5,
				Color = Color3.fromRGB(200, 200, 200),
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Enabled = true,
			}),
		},
	}) :: Frame

	UserInputService.InputChanged:Connect(onInputChanged)
	UserInputService.InputEnded:Connect(onInputEnded)

	return frame
end

return TopBar
