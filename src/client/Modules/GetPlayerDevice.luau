local UserInputService = game:GetService("UserInputService")
return function(): "pc" | "mobile"
	if UserInputService.TouchEnabled then
		return "mobile"
	else
		return "pc"
	end
end
