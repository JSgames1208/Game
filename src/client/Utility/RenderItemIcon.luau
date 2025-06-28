local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)

local function RenderItemToViewport(viewport: ViewportFrame, itemId: string)
	if itemId == "nothing" then
		viewport:ClearAllChildren()
		return
	end
	if ItemLibrary.itemDefinitions[itemId].type == "block" then
		local camera = viewport:FindFirstChildWhichIsA("Camera")
		if not camera then
			camera = Instance.new("Camera")
			camera.Name = "Camera"
			camera.FieldOfView = 5
			viewport.CurrentCamera = camera
			viewport.LightDirection = -Vector3.one
			viewport.LightColor = Color3.fromRGB(208, 208, 208)
		end

		viewport:ClearAllChildren()
		viewport.CurrentCamera = camera

		local blockModel: Model = BlockLibrary.CreateBlockPart(itemId)
		blockModel.Parent = viewport

		blockModel:PivotTo(CFrame.new(Vector3.new(0, 1000, 0)))

		local camPos = Vector3.new(-60, 1045, -60)
		camera.CFrame = CFrame.new(camPos, Vector3.new(0, 1000, 0))
	elseif ItemLibrary.itemDefinitions[itemId].type == "tool" then
		local camera = viewport:FindFirstChildWhichIsA("Camera")
		if not camera then
			camera = Instance.new("Camera")
			camera.Name = "Camera"
			camera.FieldOfView = 5
			viewport.CurrentCamera = camera
			viewport.LightDirection = -Vector3.one
			viewport.LightColor = Color3.fromRGB(208, 208, 208)
		end

		viewport:ClearAllChildren()
		viewport.CurrentCamera = camera

		local toolModel: Model = ItemLibrary.CreateToolPart(itemId)
		toolModel.Parent = viewport

		local centerPos = Vector3.new(0, 1000, 0)

		local rotation = CFrame.Angles(math.rad(45), 0, 0)

		local handle = toolModel:FindFirstChild("Handle")
		if not handle then
			return
		end
		local offset = handle.Position - toolModel:GetBoundingBox().Position
		print(offset)

		toolModel:PivotTo(CFrame.new(centerPos + offset) * rotation)

		local camPos = centerPos + Vector3.new(-50, 0, 0)
		camera.CFrame = CFrame.new(camPos, centerPos)
	end
end

return RenderItemToViewport
