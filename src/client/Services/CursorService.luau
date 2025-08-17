local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local CursorMap = require(StarterGui.UI.CursorMap)
local Cursor = require(StarterGui.UI.Frames.Cursor)
local IsOnScreen = require(StarterPlayer.StarterPlayerScripts.Client.Admin.Helpers.IsOnScreen)

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local windowFocussed: boolean = true

local mouse = player:GetMouse()

local scope = Fusion.scoped(Fusion)

local cursor: ImageButton = nil
local cursorId = scope:Value(CursorMap["default" :: CursorMap.CursorName])

local CursorService = {}

function CursorService.Init()
	UserInputService.MouseIconEnabled = false

	local CursorGui = scope:New("ScreenGui")({
		Name = "CursorGui",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 1,
		Parent = PlayerGui,
	})

	cursor = Cursor(scope, cursorId)
	cursor.Parent = CursorGui

	CursorService.StartFollowing()
end

function CursorService.StartFollowing()
	RunService.RenderStepped:Connect(function()
		if IsOnScreen(mouse.X, mouse.Y) and windowFocussed then
			cursor.Position = UDim2.new(0, mouse.X, 0, mouse.Y + GuiService:GetGuiInset().Y)
			cursor.Visible = true
		else
			cursor.Position = UDim2.new(0, 0, 0, 0)
			cursor.Visible = false
		end
	end)
end

function CursorService.SetCursor(name: CursorMap.CursorName): ()
	local id: string = CursorMap[name]

	if not id then
		return
	end

	cursorId:set(id)
end

UserInputService.WindowFocused:Connect(function()
	windowFocussed = true
end)

UserInputService.WindowFocusReleased:Connect(function()
	windowFocussed = false
end)

return CursorService
