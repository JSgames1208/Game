local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
require(ReplicatedStorage.Shared.network)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local BlockPlacer = require(script.BlockPlacer)
local InputManager = require(script.InputManager)
local InventoryClient = require(script.InventoryClient)
local ItemEquip = require(script.ItemEquip)

BlockPlacer.Start()
InputManager.Start()
InventoryClient.Start()
ItemEquip.Start()
