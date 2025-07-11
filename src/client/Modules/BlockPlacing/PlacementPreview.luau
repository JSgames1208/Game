local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)
local PlacementPreview = {}

local blockPreview = nil

function PlacementPreview.RenderPreview(blockId: string, position: Vector3)
	if not blockPreview then
		blockPreview = BlockLibrary.CreateBlockPart(blockId)
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

		blockPreview:PivotTo(CFrame.new(position))
	else
		blockPreview:PivotTo(CFrame.new(position))
	end
end

function PlacementPreview.RemovePreview()
	if blockPreview then
		blockPreview:Destroy()
		blockPreview = nil
	end
end

return PlacementPreview
