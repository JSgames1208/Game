local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local CursorService = require(StarterPlayer.StarterPlayerScripts.Client.Services.CursorService)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

type Side = "right" | "left" | "top" | "bottom"

local OnEvent = Fusion.OnEvent

local function ResizeBar(scope: typeof(Fusion.scoped(Fusion)), side: Side): Frame
	local Size: UDim2
	local Position: UDim2

	local dragging = false

	if side == "right" then
		Size = UDim2.new(0, 4, 1, -25)
		Position = UDim2.new(1, 0, 0, 25)
	elseif side == "left" then
		Size = UDim2.new(0, 4, 1, -25)
		Position = UDim2.new(0, -4, 0, 25)
	elseif side == "top" then
		Size = UDim2.new(1, 0, 0, 4)
		Position = UDim2.new(0, 0, 0, -5)
	elseif side == "bottom" then
		Size = UDim2.new(1, 0, 0, 4)
		Position = UDim2.new(0, 0, 1, 0)
	else
		Size = UDim2.new(0, 0, 0, 0)
		Position = UDim2.new(0, 0, 0, 0)
	end

	return scope:New("Frame")({
		Name = `Bar_{side}`,
		Size = Size,
		Position = Position,
		ZIndex = 100,
		BackgroundTransparency = 1,

		[OnEvent("InputBegan")] = function(input: InputObject): ()
			if input.UserInputType == Enum.UserInputType.MouseButton1 and not dragging then
				dragging = true

				if side == "right" or side == "left" then
					CursorService.SetCursor("horizontal_resize")
				elseif side == "top" or side == "bottom" then
					CursorService.SetCursor("vertical_resize")
				end
			end
		end,
		[OnEvent("InputEnded")] = function(input: InputObject): ()
			if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
				dragging = false
				CursorService.SetCursor("default")
			end
		end,
		[OnEvent("InputChanged")] = function(input: InputObject): ()
			if input.UserInputType == Enum.UserInputType.MouseMovement and not dragging then
				if side == "right" or side == "left" then
					CursorService.SetCursor("horizontal_resize")
				elseif side == "top" or side == "bottom" then
					CursorService.SetCursor("vertical_resize")
				end
			end
		end,
		[OnEvent("MouseEnter")] = function(): ()
			if not dragging then
				if side == "right" or side == "left" then
					CursorService.SetCursor("horizontal_resize")
				elseif side == "top" or side == "bottom" then
					CursorService.SetCursor("vertical_resize")
				end
			end
		end,
		[OnEvent("MouseLeave")] = function(): ()
			if not dragging then
				CursorService.SetCursor("default")
			end
		end,
	}) :: Frame
end

return ResizeBar
