local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockLibrary = require(ReplicatedStorage.Shared.BlockLibrary)

local function RenderBlockToViewport(viewport: ViewportFrame, blockId: string)
	if blockId == "nothing" then
		return
	end
	local camera = viewport:FindFirstChildWhichIsA("Camera")
	if not camera then
		camera = Instance.new("Camera")
		camera.Name = "Camera"
		camera.FieldOfView = 10
		viewport.CurrentCamera = camera
		viewport.LightDirection = Vector3.one
		viewport.LightColor = Color3.new(1, 1, 1)
	end

	viewport:ClearAllChildren()
	viewport.CurrentCamera = camera

	local blockModel: Model = BlockLibrary.CreateBlockPart(blockId)
	blockModel.Parent = viewport

	blockModel:PivotTo(CFrame.new(Vector3.new(0, 0, 0)))

	local camPos = Vector3.new(20, 20, 20)
	camera.CFrame = CFrame.new(camPos, Vector3.new(0, 0, 0))
end

return RenderBlockToViewport
