local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
require(ReplicatedStorage.Shared.network)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local InventoryClient = require(script.Services.InventoryClient)
InventoryClient.Start()

require(script.Modules.HealthBarManager)
local ItemEquip = require(script.Modules.ItemEquip)
local BlockPlacerService = require(StarterPlayer.StarterPlayerScripts.Client.Services.BlockPlacerService)
local DialogueClient = require(script.Services.DialogueClient)
local QuestClient = require(script.Services.QuestClient)
local ToolService = require(StarterPlayer.StarterPlayerScripts.Client.Services.ToolService)
local ShopClient = require(script.Services.ShopClient)
local PlayerClient = require(script.Services.PlayerClient)

BlockPlacerService.Start()
ToolService.Start()
ItemEquip.Start()
DialogueClient.Start()
QuestClient.Start()
ShopClient.Start()
PlayerClient.Start()

local InputService = require(script.Services.InputService)
InputService.Start()
