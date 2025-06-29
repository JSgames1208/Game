local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
require(ReplicatedStorage.Shared.network)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local BlockPlacer = require(script.BlockPlacer)
local ToolManager = require(script.ToolManager)
local InputManager = require(script.InputManager)
local InventoryClient = require(script.InventoryClient)
local ItemEquip = require(script.ItemEquip)
local BlockHealthBar = require(script.BlockHealthBar)

BlockPlacer.Start()
ToolManager.Start()
InputManager.Start()
InventoryClient.Start()
ItemEquip.Start()
BlockHealthBar.Start()
