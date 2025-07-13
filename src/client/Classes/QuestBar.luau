local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local QuestBar = {}
QuestBar.__index = QuestBar

function QuestBar.new()
	local self = setmetatable({}, QuestBar)

	self.scope = Fusion.scoped(Fusion)
end

return QuestBar
