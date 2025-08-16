local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local AppButton = require(StarterGui.UI.Features.Admin.AppButton)
local WindowManager = require(StarterGui.UI.Features.Admin.WindowManager)
local GetAppButton = require(StarterPlayer.StarterPlayerScripts.Client.Admin.Helpers.GetAppButton)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local AppBarUI = {}

local scope: typeof(Fusion.scoped(Fusion))? = nil
local appBar: Frame? = nil
local apps -- Fusion state: list of app data

local function GetAppPos(amt: number, i: number): UDim2
	return UDim2.new(0.5, (-((amt - 1) / 2) + (i - 1)) * 40, 0.5, 0)
end

local function GetAppIndex(amt: number, pos: UDim2): number
	local xOffset = pos.X.Offset
	local i = (xOffset / 40) + ((amt - 1) / 2) + 1
	i = math.floor(i + 0.5) -- round to nearest integer
	i = math.clamp(i, 1, amt) -- keep index in range
	return i
end

local isMouseDown = false
local isDragging = false

local currentIndex = nil

local icon = nil
local dragId = nil

local dragConnection = nil

local buttonCache = {} -- id -> Instance / AppButton
local targetCache = {} -- id -> Value(UDim2)  (spring target)
local springCache = {} -- id -> Spring binding
local uniqueCounter = 0

local function ensureId(app)
	if not app._id then
		uniqueCounter = uniqueCounter + 1
		app._id = ("app_%s_%d"):format(tostring(math.floor(tick() * 1000)), uniqueCounter)
	end
	return app._id
end

function AppBarUI.StartDrag()
	if isDragging then
		return
	end
	isDragging = true
	isMouseDown = true

	icon = GetAppButton()
	if not scope or not icon then
		return
	end

	-- find the dragId
	for id, btn in pairs(buttonCache) do
		if btn == icon then
			dragId = id
			break
		end
	end

	local current = scope.peek(apps)
	local amt = #current

	currentIndex = GetAppIndex(
		amt,
		UDim2.new(
			0.5,
			icon.AbsolutePosition.X + icon.AbsoluteSize.X / 2 - workspace.CurrentCamera.ViewportSize.X / 2,
			0.5,
			0
		)
	)

	local offsetX = icon.AbsolutePosition.X - mouse.X + icon.AbsoluteSize.X / 2

	-- manual drag following
	dragConnection = RunService.RenderStepped:Connect(function()
		if not icon or not currentIndex then
			return
		end

		-- drag icon follows mouse
		if dragId and targetCache[dragId] and appBar then
			local mouseX = mouse.X - appBar.AbsolutePosition.X -- relative to AppBar
			targetCache[dragId]:set(UDim2.new(0, mouseX, 0.5, 0))
		end

		-- check new index
		local amt = #scope.peek(apps)
		local newIndex = GetAppIndex(
			amt,
			UDim2.new(
				0.5,
				icon.AbsolutePosition.X + icon.AbsoluteSize.X / 2 - workspace.CurrentCamera.ViewportSize.X / 2,
				0.5,
				0
			)
		)

		if newIndex ~= currentIndex then
			local current = table.clone(scope.peek(apps))
			local item = table.remove(current, currentIndex)
			table.insert(current, newIndex, item)
			apps:set(current)
			currentIndex = newIndex
		end
	end)
end

function AppBarUI.EndDrag()
	if not isDragging or not scope then
		return
	end

	isDragging = false
	isMouseDown = false

	-- stop manual drag
	if dragConnection then
		dragConnection:Disconnect()
		dragConnection = nil
	end

	if not icon or not currentIndex then
		print("Missing drag data:", icon, currentIndex)
		return
	end

	-- snap into place using Fusion spring
	if dragId and targetCache[dragId] then
		local amt = #scope.peek(apps)
		local newIndex = GetAppIndex(
			amt,
			UDim2.new(
				0.5,
				icon.AbsolutePosition.X + icon.AbsoluteSize.X / 2 - workspace.CurrentCamera.ViewportSize.X / 2,
				0.5,
				0
			)
		)
		targetCache[dragId]:set(GetAppPos(amt, newIndex))
	end

	icon = nil
	currentIndex = nil
	dragId = nil
end

local function mouseDown()
	if not scope then
		return
	end
	isMouseDown = true
	icon = GetAppButton()

	local amt = #scope.peek(apps)

	if icon then
		currentIndex = GetAppIndex(
			amt,
			UDim2.new(
				0.5,
				icon.AbsolutePosition.X + icon.AbsoluteSize.X / 2 - workspace.CurrentCamera.ViewportSize.X / 2,
				0.5,
				0
			)
		)
	end
end

local function mouseUp(icon)
	isMouseDown = false
	if isDragging then
		AppBarUI.EndDrag()
	else
		if scope then
			WindowManager.OpenWindow(scope.peek(apps)[currentIndex].name)
		end
	end
end

mouse.Move:Connect(function()
	if isMouseDown then
		if not isDragging then
			AppBarUI.StartDrag()
		end
	end
end)

--[[UserInputService.InputChanged:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if isMouseDown then
		print(input.UserInputType, isDragging)
		if input.UserInputType == Enum.UserInputType.MouseMovement and not isDragging then
			print("START DRAG")
			AppBarUI.StartDrag()
		end
	end
end)]]

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		AppBarUI.EndDrag()
	end
end)

function AppBarUI.Init(s: typeof(Fusion.scoped(Fusion)))
	scope = s

	appBar = Players.LocalPlayer.PlayerGui:WaitForChild("AdminGui"):WaitForChild("AppBar") :: Frame

	if not scope or not appBar then
		return
	end

	apps = scope:Value({})

	-- Attach reactive children to the existing AppBar instance.

	scope:Hydrate(appBar)({

		[Fusion.Children] = scope:Computed(function(use)
			local list = use(apps)

			-- Ensure ids, update order tracking
			for i, app in ipairs(list) do
				ensureId(app)
			end

			-- Ensure caches exist and update targets (do not recreate springs)
			for i, app in ipairs(list) do
				local id = app._id

				-- create caches if missing (only once)
				if not buttonCache[id] then
					-- create AppButton once and hydrate it once with a persistent spring
					local btn = AppButton(scope, app.name, mouseDown, mouseUp)
					buttonCache[id] = btn

					-- create a target Value and spring for this button and hydrate the instance
					targetCache[id] = scope:Value(GetAppPos(#list, i))
					springCache[id] = scope:Spring(targetCache[id], 30, 1)

					scope:Hydrate(btn)({
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = springCache[id],
					})
				end

				-- update the target for existing buttons (this is the only thing we change each frame)
				-- compute current index in the live list (in case of reorders)
				local currentIndex = table.find(list, app) or i
				local desired = GetAppPos(#list, currentIndex)

				-- update the target Value (this triggers the persistent spring to animate)
				if targetCache[id] then
					targetCache[id]:set(desired)
				end
			end

			-- Build children table keyed by stable id to let Fusion reuse instances
			local children = {}
			for i, app in ipairs(list) do
				local id = app._id
				children[id] = buttonCache[id]
			end

			return children
		end),
	})
end

function AppBarUI.AddApp(appData)
	if not scope then
		return
	end

	local current = table.clone(scope.peek(apps))
	table.insert(current, appData)
	apps:set(current)
end

function AppBarUI.RemoveApp(name: string)
	if not scope then
		return
	end

	local current = {}
	for _, app in ipairs(scope.peek(apps)) do
		if app.name ~= name then
			table.insert(current, app)
		end
	end
	apps:set(current)
end

function AppBarUI.Populate(list: { any })
	for _, app in ipairs(list) do
		AppBarUI.AddApp(app)
	end
end

return AppBarUI
