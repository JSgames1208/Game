local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local BillboardHealthBar = require(StarterGui.UI.Frames.HealthBars.BillboardHealthBar)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local BlockHealthBar = {}
BlockHealthBar.__index = BlockHealthBar

function BlockHealthBar.new(block: Model | Part | MeshPart)
	local self = setmetatable({}, BlockHealthBar)

	self.scope = Fusion.scoped(Fusion)

	self.block = block
	self.currentHP = self.scope:Value(block:GetAttribute("hp"))
	self.maxHP = self.scope:Value(block:GetAttribute("maxhp"))

	print("HERE")

	self.gui = BillboardHealthBar(
		self.scope,
		{
			currentHP = self.currentHP,
			maxHP = self.maxHP,
			Adornee = self.block,
		} :: BillboardHealthBar.BillboardHealthBarProps
	)

	print(self.gui)

	return self
end

function BlockHealthBar:UpdateHP(newHP)
	self.currentHP:set(newHP)
end

function BlockHealthBar:Destroy()
	self.scope:doCleanup()
end

return BlockHealthBar
