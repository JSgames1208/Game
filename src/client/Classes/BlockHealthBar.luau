local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local HealthBar = require(StarterGui.UI.Frames.HealthBar)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local BlockHealthBar = {}
BlockHealthBar.__index = BlockHealthBar

function BlockHealthBar.new(block: Model | Part | MeshPart)
	local self = setmetatable({}, BlockHealthBar)

	self.scope = Fusion.scoped(Fusion)

	self.block = block
	self.currentHP = self.scope:Value(block:GetAttribute("hp"))
	self.maxHP = self.scope:Value(block:GetAttribute("maxhp"))

	self.gui = HealthBar(
		self.scope,
		{
			currentHP = self.currentHP,
			maxHP = self.maxHP,
			adornee = self.block,
		} :: HealthBar.HealthBarProps
	)

	return self
end

function BlockHealthBar:UpdateHP(newHP)
	self.currentHP:set(newHP)
end

function BlockHealthBar:Destroy()
	self.scope:doCleanup()
end

return BlockHealthBar
