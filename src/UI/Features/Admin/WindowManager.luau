local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local DecrementZIndeces = require(StarterPlayer.StarterPlayerScripts.Client.Admin.Helpers.DecrementZIndeces)
local GetHighestWindowZIndex = require(StarterPlayer.StarterPlayerScripts.Client.Admin.Helpers.GetHighestWindowZIndex)
local GetLowestWindowZIndex = require(StarterPlayer.StarterPlayerScripts.Client.Admin.Helpers.GetLowestWindowZIndex)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Window = require(script.Parent.Window)
local WindowManager = {}

local init = false

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local scope = Fusion.scoped(Fusion)

local windows: { [string]: Frame } = {}
local focussedWindow = nil

local WindowGui = nil

local function getWindowAtZIndex(zIndex: number): Frame?
	for _, window: Frame in WindowGui:GetChildren() do
		if window.ZIndex == zIndex then
			return window
		end
	end

	return nil
end

function WindowManager.Init(scope: typeof(Fusion.scoped(Fusion)))
	if not WindowGui then
		WindowGui = scope:New("ScreenGui")({
			Name = "WindowGui",
			IgnoreGuiInset = false,
			ResetOnSpawn = false,
			Parent = PlayerGui,
		})

		init = true
	end

	return WindowGui
end

function WindowManager.OpenWindow(appName: string)
	if not init then
		return
	end
	if windows[appName] == nil then
		local window = Window(scope, appName, WindowManager.FocusWindow, WindowManager.CloseWindow)
		window.Parent = WindowGui
		windows[appName] = window
		WindowManager.FocusWindow(window)
	elseif windows[appName].ZIndex ~= GetHighestWindowZIndex() then
		windows[appName].Visible = true
		WindowManager.FocusWindow(windows[appName])
	else
		windows[appName].Visible = false
		windows[appName].ZIndex = GetLowestWindowZIndex() - 1

		WindowManager.FocusWindow(getWindowAtZIndex(GetHighestWindowZIndex()) or nil)
	end
end

function WindowManager.CloseWindow(appName: string): ()
	if windows[appName] and windows[appName].Visible then
		windows[appName]:Destroy()
		windows[appName] = nil
	end
end

function WindowManager.FocusWindow(window: Frame?): ()
	if window and window ~= focussedWindow then
		local top = GetHighestWindowZIndex()
		window.ZIndex = top + 1
		focussedWindow = window
		DecrementZIndeces(window)
	elseif GetHighestWindowZIndex() then
		focussedWindow = getWindowAtZIndex(GetHighestWindowZIndex())
	else
		focussedWindow = nil
	end
end

return WindowManager
