local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)

local function RenderBlockToViewport(viewport: ViewportFrame, blockId: string)
	if blockId == "nothing" then
		viewport:ClearAllChildren()
		return
	end
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

	local blockModel: Model = BlockLibrary.CreateBlockPart(blockId)
	blockModel.Parent = viewport

	blockModel:PivotTo(CFrame.new(Vector3.new(0, 1000, 0)))

	local camPos = Vector3.new(-60, 1045, -60)
	camera.CFrame = CFrame.new(camPos, Vector3.new(0, 1000, 0))
end

return RenderBlockToViewport
