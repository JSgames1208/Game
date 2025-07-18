local StarterPlayer = game:GetService("StarterPlayer")
local QuestHandler = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Quests.QuestHandler)
local QuestMarker = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Quests.QuestMarker)
local QuestUI = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Quests.QuestUI)

local QuestClient = {}

--[[
Client role:- Receive updates from server
- Update UI
- Change UI if quest is complete
- Point to the quest's quest giver
- OPTIONAL: Quest complete notification
]]

function QuestClient.Start()
	QuestHandler.Init()
	QuestUI.Init()
	QuestMarker.Init()
end

return QuestClient
