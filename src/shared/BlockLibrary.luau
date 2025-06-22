local BlockLibrary = {}

local BLOCK_SIZE = 4

local blockDefinitions = {
	grass = {
		color = Color3.fromRGB(95, 159, 53),
		material = Enum.Material.SmoothPlastic,
	},
	dirt = {
		color = Color3.fromRGB(115, 85, 49),
		material = Enum.Material.SmoothPlastic,
	},
	stone = {
		color = Color3.fromRGB(125, 125, 125),
		material = Enum.Material.SmoothPlastic,
	},
}

function BlockLibrary.CreateBlockPart(blockId: string)
	local def = blockDefinitions[blockId]
	if not def then
		error("Unknown blockId: " .. tostring(blockId))
	end

	local part = Instance.new("Part")
	part.Size = Vector3.new(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
	part.Anchored = true
	part.Material = def.material
	part.Color = def.color
	part.Name = blockId
	return part
end

return BlockLibrary
