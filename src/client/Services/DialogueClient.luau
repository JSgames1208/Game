local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(ReplicatedStorage.Shared.network)

local DialogueClient = {}

function DialogueClient.Start()
	for _, NPC in workspace.NPCs:GetChildren() do
		if NPC:FindFirstChild("InteractPrompt") then
			local prompt: ProximityPrompt = NPC.InteractPrompt
			prompt.Triggered:Connect(function()
				packets.StartDialogue.send({ npcId = NPC.Name })
			end)
		end
	end
end

packets.ShowDialogue.listen(function(data)
	print(data.text)
	if data.options then
		for _, option in data.options do
			print(option.text)
		end
	end
end)

packets.CloseDialogue.listen(function(data)
	print("Close Dialogue")
end)

packets.OpenShop.listen(function(data)
	print("Open Shop")
end)

return DialogueClient
