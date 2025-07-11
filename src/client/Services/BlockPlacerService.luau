local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local SoundService = require(script.Parent.SoundService)
local PlacementPreview = require(StarterPlayer.StarterPlayerScripts.Client.Modules.BlockPlacing.PlacementPreview)
local ItemEquip = require(StarterPlayer.StarterPlayerScripts.Client.Modules.ItemEquip)
local packets = require(ReplicatedStorage.Shared.network)

local BlockPlacerService = {}

local currentBlock = nil
local currentSlot = nil

local plotPosition = nil

local normalMap = {
	[Enum.NormalId.Top] = Vector3.new(0, 1, 0),
	[Enum.NormalId.Bottom] = Vector3.new(0, -1, 0),
	[Enum.NormalId.Left] = Vector3.new(-1, 0, 0),
	[Enum.NormalId.Right] = Vector3.new(1, 0, 0),
	[Enum.NormalId.Front] = Vector3.new(0, 0, -1),
	[Enum.NormalId.Back] = Vector3.new(0, 0, 1),
}

function BlockPlacerService.Start()
	RunService.RenderStepped:Connect(function()
		if currentBlock then
			ItemEquip.Equip(currentBlock)

			local target = Mouse.Target
			if not target then
				return
			end

			local surface = Mouse.TargetSurface
			local normal = normalMap[surface]

			if normal then
				local placePos = Vector3.new(
					math.floor(target.Position.X / 4 + 0.5) + normal.X,
					math.floor(target.Position.Y / 4 + 0.5) + normal.Y,
					math.floor(target.Position.Z / 4 + 0.5) + normal.Z
				)
				PlacementPreview.RenderPreview(currentBlock, placePos * 4)
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
	local normal = normalMap[surface]

	local blockId = currentBlock

	if normal then
		if not plotPosition then
			warn("No plot position!")
			return
		end
		local relativePos = target.Position - plotPosition

		local placePos = Vector3.new(
			math.floor(relativePos.X / 4 + 0.5) + normal.X,
			math.floor(relativePos.Y / 4 + 0.5) + normal.Y,
			math.floor(relativePos.Z / 4 + 0.5) + normal.Z
		)
		packets.PlaceBlock.send({
			x = placePos.X,
			y = placePos.Y,
			z = placePos.Z,
			blockId = blockId,
			slot = currentSlot,
		})
		print("Event sent!")
	end
end

packets.InventorySync.listen(function(data)
	if not currentSlot then
		return
	end
	if data and data[currentSlot] and data[currentSlot].count <= 0 then
		BlockPlacerService.SelectBlock("nothing", currentSlot)
	end
end)

packets.AssignPlot.listen(function(pos)
	plotPosition = pos
end)

packets.BlockPlaced.listen(function(vec3)
	SoundService:Play("place", vec3)
end)

return BlockPlacerService
