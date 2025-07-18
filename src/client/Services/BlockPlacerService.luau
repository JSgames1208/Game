local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local BlockRequestHandler = require(StarterPlayer.StarterPlayerScripts.Client.Modules.BlockPlacing.BlockRequestHandler)
local PlacementCalculator = require(StarterPlayer.StarterPlayerScripts.Client.Modules.BlockPlacing.PlacementCalculator)
local PlacementPreview = require(StarterPlayer.StarterPlayerScripts.Client.Modules.BlockPlacing.PlacementPreview)
local ItemEquip = require(StarterPlayer.StarterPlayerScripts.Client.Modules.ItemEquip)
local packets = require(ReplicatedStorage.Shared.network)

local BlockPlacerService = {}

local currentBlock = nil
local currentSlot = nil

local plotPosition = nil

function BlockPlacerService.Start()
	packets.AssignPlot.listen(function(pos)
		print(pos)
		plotPosition = pos
	end)

	packets.InventorySync.listen(function(data)
		if not currentSlot then
			return
		end
		if data and data[currentSlot] and data[currentSlot].count <= 0 then
			BlockPlacerService.SelectBlock("nothing", currentSlot)
		end
	end)

	RunService.RenderStepped:Connect(function()
		if currentBlock then
			ItemEquip.Equip(currentBlock)

			local target = Mouse.Target
			if not target then
				return
			end

			local surface = Mouse.TargetSurface
			local previewPos = PlacementCalculator.CalculatePlacePosition(target.Position, surface, plotPosition)
			if previewPos then
				PlacementPreview.RenderPreview(currentBlock, previewPos * 4 + plotPosition)
			end
		end
	end)
end

function BlockPlacerService.SelectBlock(blockId: string, slot: number)
	currentSlot = slot
	if blockId == "nothing" then
		ItemEquip.UnEquip()
		currentBlock = nil
	else
		currentBlock = blockId
	end
	PlacementPreview.RemovePreview()
end

function BlockPlacerService.Unselect()
	currentBlock = nil
	BlockPlacerService.SelectBlock("nothing", 0)
end

function BlockPlacerService.Place()
	if not currentBlock then
		return
	end
	local target = Mouse.Target
	if not target or not target:HasTag("Block") then
		return
	end

	local surface = Mouse.TargetSurface

	local placePos = PlacementCalculator.CalculatePlacePosition(target.Position, surface, plotPosition)

	BlockRequestHandler.PlaceBlock(placePos, currentBlock, currentSlot)
end

return BlockPlacerService
