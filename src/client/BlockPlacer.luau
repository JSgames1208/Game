local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ItemEquip = require(script.Parent.ItemEquip)
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)
local packets = require(ReplicatedStorage.Shared.network)

local BlockPlacer = {}

local currentBlock = nil
local blockPreview = nil

local currentSlot = nil

local normalMap = {
	[Enum.NormalId.Top] = Vector3.new(0, 1, 0),
	[Enum.NormalId.Bottom] = Vector3.new(0, -1, 0),
	[Enum.NormalId.Left] = Vector3.new(-1, 0, 0),
	[Enum.NormalId.Right] = Vector3.new(1, 0, 0),
	[Enum.NormalId.Front] = Vector3.new(0, 0, -1),
	[Enum.NormalId.Back] = Vector3.new(0, 0, 1),
}

function BlockPlacer.Start()
	RunService.RenderStepped:Connect(function()
		if currentBlock then
			ItemEquip.Equip(currentBlock)
			if not blockPreview then
				blockPreview = BlockLibrary.CreateBlockPart(currentBlock)
				blockPreview.Transparency = 1
				for _, texture in blockPreview:GetChildren() do
					if texture:IsA("Texture") then
						texture.Transparency = 0.6
					end
				end
				blockPreview.Parent = workspace
				blockPreview.CanCollide = false
				blockPreview.CanQuery = false
			end

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
				blockPreview.Position = placePos * 4
			end
		end
	end)
end

function BlockPlacer.SelectBlock(blockId: string, slot: number)
	currentSlot = slot
	if blockId == "nothing" then
		ItemEquip.UnEquip()
		currentBlock = nil
		if blockPreview then
			blockPreview:Destroy()
			blockPreview = nil
		end
	else
		currentBlock = blockId
		if blockPreview then
			blockPreview:Destroy()
			blockPreview = nil
		end
	end
end

function BlockPlacer.Place()
	if not currentBlock then
		return
	end
	local target = Mouse.Target
	if not target then
		return
	end

	local surface = Mouse.TargetSurface
	local normal = normalMap[surface]

	local blockId = currentBlock

	if normal then
		local placePos = Vector3.new(
			math.floor(target.Position.X / 4 + 0.5) + normal.X,
			math.floor(target.Position.Y / 4 + 0.5) + normal.Y,
			math.floor(target.Position.Z / 4 + 0.5) + normal.Z
		)
		packets.PlaceBlock.send({
			x = placePos.X,
			y = placePos.Y,
			z = placePos.Z,
			blockId = blockId,
			slot = currentSlot,
		})
	end
end

packets.InventorySync.listen(function(data)
	if not currentSlot then
		return
	end
	if data[currentSlot].count <= 0 then
		BlockPlacer.SelectBlock("nothing", currentSlot)
	end
end)

return BlockPlacer
