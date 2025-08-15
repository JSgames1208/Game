local UserInputService = game:GetService("UserInputService")
local AdminUI = require(script.Parent.AdminUI)
local AdminClient = {}

function AdminClient.Init()
	AdminUI.Init()

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.Semicolon then
				AdminUI.Toggle()
			end
		end
	end)
end

return AdminClient
