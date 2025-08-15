local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local AppButton = require(StarterGui.UI.Features.Admin.AppButton)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local scope: typeof(Fusion.scoped(Fusion))

local appBar

local AppBarUI = {}

local apps = {}
local visibleApps = {}

function AppBarUI.Init(scope: typeof(Fusion.scoped(Fusion)))
	scope = scope
	Players.LocalPlayer.PlayerGui:WaitForChild("AdminGui"):WaitForChild("AppBar")
end

function AppBarUI.GetAppPos(amt: number, i: number): UDim2
	return UDim2.new(0.5, (-((amt - 1) / 2.0) + (i - 1)) * 40.0, 0.5, 0)
end

function AppBarUI.CreateButton(scope: typeof(Fusion.scoped(Fusion)), apps: { any }, index: number)
	return AppButton(scope, apps[index].name)
end

function AppBarUI.Populate(scope: typeof(Fusion.scoped(Fusion)), apps: { any })
	for i, app in ipairs(apps) do
		local appButton = visibleApps[app.name]
		if not appButton then
			appButton = AppBarUI.CreateButton(scope, apps, i)
			visibleApps[app.name] = appButton
		end

		if not appButton then
			return
		end

		appButton.Position = scope.peek(scope:Spring(AppBarUI.GetAppPos(#apps, i), 20, 1))
		appButton.Parent = appBar
	end
end

return AppBarUI
