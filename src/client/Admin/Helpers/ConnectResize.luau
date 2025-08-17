local UserInputService = game:GetService("UserInputService")
return function(bar: Frame, window: Frame, side: "right" | "left" | "top" | "bottom"): ()
	local dragging: boolean = false
	local dragStart: Vector3 --because InputObject.Position is a Vector3
	local startSize: UDim2
	local startPos: UDim2

	local minSize = 200

	bar.InputBegan:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startSize = window.Size
			startPos = window.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input: InputObject)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart

			if side == "right" then
				window.Size = UDim2.new(
					startSize.X.Scale,
					math.max(minSize, startSize.X.Offset + delta.X),
					startSize.Y.Scale,
					startSize.Y.Offset
				)
				window.Position = UDim2.new(
					startPos.X.Scale,
					math.max(startPos.X.Offset - startSize.X.Offset / 2 + minSize / 2, startPos.X.Offset + delta.X / 2),
					startPos.Y.Scale,
					startPos.Y.Offset
				)
			elseif side == "left" then
				window.Size = UDim2.new(
					startSize.X.Scale,
					math.max(minSize, startSize.X.Offset - delta.X),
					startSize.Y.Scale,
					startSize.Y.Offset
				)
				window.Position = UDim2.new(
					startPos.X.Scale,
					math.min(startPos.X.Offset + startSize.X.Offset / 2 - minSize / 2, startPos.X.Offset + delta.X / 2),
					startPos.Y.Scale,
					startPos.Y.Offset
				)
			elseif side == "top" then
				window.Size = UDim2.new(
					startSize.X.Scale,
					startSize.X.Offset,
					startSize.Y.Scale,
					math.max(minSize, startSize.Y.Offset - delta.Y)
				)
				window.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset,
					startPos.Y.Scale,
					math.min(startPos.Y.Offset + startSize.Y.Offset / 2 - minSize / 2, startPos.Y.Offset + delta.Y / 2)
				)
			elseif side == "bottom" then
				window.Size = UDim2.new(
					startSize.X.Scale,
					startSize.X.Offset,
					startSize.Y.Scale,
					math.max(minSize, startSize.Y.Offset + delta.Y)
				)
				window.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset,
					startPos.Y.Scale,
					math.max(startPos.Y.Offset - startSize.Y.Offset / 2 + minSize / 2, startPos.Y.Offset + delta.Y / 2)
				)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	return
end
