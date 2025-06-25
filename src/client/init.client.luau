local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.network)

local BlockPlacer = require(script.BlockPlacer)
local InputManager = require(script.InputManager)
local InventoryClient = require(script.InventoryClient)

BlockPlacer.Start()
InputManager.Start()
InventoryClient.Start()
