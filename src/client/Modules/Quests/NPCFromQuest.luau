local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NPCData = require(ReplicatedStorage.Shared.Data.NPCData)
return function(questId: string): string
	for _, npc in NPCData do
		if npc.questLine then
			if npc.questLine[questId] then
				return npc.name
			end
		end
	end
	return ""
end
