local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
require(ReplicatedStorage.Shared.network)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local AdminClient = require(script.Admin.AdminClient)
local packets = require(ReplicatedStorage.Shared.network)

packets.InitAdmin.listen(function(data)
	AdminClient.Init()
end)

local InventoryClient = require(script.Services.InventoryClient)
InventoryClient.Start()

require(script.Modules.HealthBarManager)
local CursorService = require(StarterPlayer.StarterPlayerScripts.Client.Services.CursorService)
local ItemEquip = require(script.Modules.ItemEquip)
local BlockPlacerService = require(StarterPlayer.StarterPlayerScripts.Client.Services.BlockPlacerService)
local DialogueClient = require(script.Services.DialogueClient)
local QuestClient = require(script.Services.QuestClient)
local ToolService = require(StarterPlayer.StarterPlayerScripts.Client.Services.ToolService)
local ShopClient = require(script.Services.ShopClient)
local PlayerClient = require(script.Services.PlayerClient)

CursorService.Init()
BlockPlacerService.Start()
ToolService.Start()
ItemEquip.Start()
DialogueClient.Start()
QuestClient.Start()
ShopClient.Start()
PlayerClient.Start()

local InputService = require(script.Services.InputService)
InputService.Start()
