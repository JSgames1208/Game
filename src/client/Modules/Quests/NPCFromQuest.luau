local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NPCData = require(ReplicatedStorage.Shared.Data.NPCData)
return function(questId: string): string
	for _, npc in NPCData do
		if table.find(npc.questLine, questId) then
			return npc.name
		end
	end
	return ""
end
