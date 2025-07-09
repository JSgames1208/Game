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

local plotPosition = nil

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
				for _, child in blockPreview:GetDescendants() do
					if child:IsA("Texture") then
						child.Transparency = 0.6
					elseif child:IsA("MeshPart") then
						child.Transparency = 0.6
						child.CanCollide = false
						child.CanQuery = false
					elseif child:IsA("Part") then
						child.CanCollide = false
						child.CanQuery = false
					end
				end

				if blockPreview:IsA("Part") then
					blockPreview.Transparency = 1
					blockPreview.CanCollide = false
					blockPreview.CanQuery = false
				end

				blockPreview.Parent = workspace
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
				blockPreview:PivotTo(CFrame.new(placePos * 4))
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

function BlockPlacer.Unselect()
	currentBlock = nil
	BlockPlacer.SelectBlock("nothing", 0)
end

function BlockPlacer.Place()
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
	end
end

packets.InventorySync.listen(function(data)
	if not currentSlot then
		return
	end
	if data and data[currentSlot] and data[currentSlot].count <= 0 then
		BlockPlacer.SelectBlock("nothing", currentSlot)
	end
end)

packets.AssignPlot.listen(function(pos)
	plotPosition = pos
end)

return BlockPlacer
