local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
require(ReplicatedStorage.Shared.network)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local InventoryClient = require(script.InventoryClient)
InventoryClient.Start()
local BlockPlacer = require(script.BlockPlacer)
local ToolManager = require(script.ToolManager)
local InputManager = require(script.InputManager)
local ItemEquip = require(script.ItemEquip)
local BlockHealthBar = require(script.BlockHealthBar)

BlockPlacer.Start()
ToolManager.Start()
InputManager.Start()
ItemEquip.Start()
BlockHealthBar.Start()
