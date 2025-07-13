local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local QuestHandler = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Quests.QuestHandler)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local packets = require(ReplicatedStorage.Shared.network)

local QuestClient = {}

--[[

Client role:
  - Receive updates from server
  - Update UI
  - Change UI if quest is complete
  - Point to the quest's quest giver
  - OPTIONAL: Quest complete notification
]]

function QuestClient.Init()
	QuestHandler.Init()
end

return QuestClient
