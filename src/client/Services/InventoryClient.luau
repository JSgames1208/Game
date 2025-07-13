local StarterPlayer = game:GetService("StarterPlayer")
local InventoryDrag = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Inventory.InventoryDrag)
local InventoryHandler = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Inventory.InventoryHandler)
local InventorySlots = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Inventory.InventorySlots)
local InventoryTweens = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Inventory.InventoryTweens)
local InventoryUI = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Inventory.InventoryUI)

local InventoryClient = {}

function InventoryClient.Start()
	InventoryHandler.Init()
	InventoryUI.Init()
	InventorySlots.Init()
	InventoryDrag.Init()
	InventoryTweens.Init()
end

return InventoryClient
