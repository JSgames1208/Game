return function(x: number, y: number): ()
	local screenSize = workspace.CurrentCamera.ViewportSize

	if x < 0 or y < 0 or x > screenSize.X or y > screenSize.Y then
		return false
	end

	return true
end
