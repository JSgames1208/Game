local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
require(ReplicatedStorage.Shared.network)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local InventoryClient = require(script.Services.InventoryClient)
InventoryClient.Start()

local BlockHealthBar = require(script.BlockHealthBar)
local ItemEquip = require(script.Modules.ItemEquip)
local BlockPlacerService = require(StarterPlayer.StarterPlayerScripts.Client.Services.BlockPlacerService)
local DialogueClient = require(script.Services.DialogueClient)
local InputService = require(script.Services.InputService)
local ToolService = require(StarterPlayer.StarterPlayerScripts.Client.Services.ToolService)

ToolService.Start()
BlockPlacerService.Start()
InputService.Start()
ItemEquip.Start()
BlockHealthBar.Start()
DialogueClient.Start()
