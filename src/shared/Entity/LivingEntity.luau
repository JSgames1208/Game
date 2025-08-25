local Entity = require(script.Parent.Entity)

export type LivingEntity = Entity.Entity & {
	health: number,
	maxHealth: number,

	damage: (self: LivingEntity, amount: number) -> (),
	getHealth: (self: LivingEntity) -> number,
	setHealth: (self: LivingEntity, health: number) -> (),
	getMaxHealth: (self: LivingEntity) -> number,
}

local LivingEntity = setmetatable({}, Entity)
LivingEntity.__index = LivingEntity

function LivingEntity.new(pos: Vector3): LivingEntity
	local self = setmetatable(Entity.new(pos) :: any, LivingEntity) :: LivingEntity
	return self
end

function LivingEntity.isDead(self: LivingEntity): boolean
	return self:getHealth() <= 0
end

function LivingEntity.damage(self: LivingEntity, amount: number): ()
	self:setHealth(math.max(self:getHealth() - amount, 0))
end

function LivingEntity.getHealth(self: LivingEntity): number
	return self.health
end

function LivingEntity.setHealth(self: LivingEntity, health: number): ()
	self.health = math.clamp(health, 0, self:getMaxHealth())
end

function LivingEntity.getMaxHealth(self: LivingEntity): number
	return self.maxHealth
end

return LivingEntity
