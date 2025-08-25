local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EntityTypes = require(script.Parent.EntityTypes)
local BlockHelpers = require(ReplicatedStorage.Shared.Modules.BlockHelpers)
local Collision = require(ReplicatedStorage.Shared.Physics.Collision)

export type Entity = {
	player: Player?,
	position: Vector3,
	lifeTime: number,
	onGround: boolean,
	noClip: boolean,
	velocity: Vector3,
	type: string?,
	model: (Part | MeshPart)?,

	size: Vector3,

	shouldDestroy: boolean,
	isDestroyed: boolean,

	update: (self: Entity, dt: number) -> (),

	getGravity: (self: Entity) -> number,
	applyGravity: (self: Entity, dt: number) -> (),

	move: (self: Entity, dt: number) -> (),
	destroy: (self: Entity) -> (),

	onPlayerCollision: (self: Entity) -> (),

	setVelocity: (self: Entity, velocity: Vector3) -> (),
	getVelocity: (self: Entity) -> Vector3,
} & any

local Entity = {}
Entity.__index = Entity

--export type Entity = typeof(setmetatable({} :: self, Entity))

function Entity.new(pos: Vector3, player: Player?): Entity
	local self = setmetatable({}, Entity) :: Entity
	self.player = player or nil
	self.position = pos
	self.lifeTime = 0
	self.onGround = false
	self.noClip = false
	self.velocity = Vector3.zero
	self.model = nil
	self.type = nil

	self.size = Vector3.zero

	self.shouldDestroy = false
	self.isDestroyed = false
	return self
end

function Entity.update(self: Entity, dt): ()
	if self.shouldDestroy then
		self:destroy()
	end
	self.lifeTime += dt
end

--[[
	Changes the entity's position using a velocity that is set somewhere else.
	The entity has to be moved physically elsewhere, this just sets the position field.
  ]]

function Entity.move(self: Entity, dt): ()
	local movement = self.velocity * dt

	if not self.model then
		return
	end

	if not self.model:HasTag("Entity") then
		self.model:AddTag("Entity")
	end

	local hit = Collision.sweepRay(
		BlockHelpers.GetBottomCorners(self.position, Vector3.new(self.size.X / 2, self.size.Y / 2, self.size.Z / 2)),
		movement,
		workspace.Entities.FallingBlocks:GetChildren(),
		true
	)

	if hit then
		self.position = Vector3.new(self.position.X, hit.Position.Y + self.size.Y / 2 + 0.005, self.position.Z)
		self.velocity = Vector3.new(self.velocity.X, 0, self.velocity.Z)
		self.onGround = true

		if self.type == EntityTypes.fallingBlock then
			self.shouldDestroy = true
			if self.placeBlockCallback then
				self.placeBlockCallback(self.player, self.position, self.blockId)
			end
			return
		end
	else
		self.position = self.position + movement
		self.onGround = false
	end
end

function Entity.destroy(self: Entity): ()
	if self.model then
		self.model:Destroy()
		self.model = nil
	end
	self.isDestroyed = true
end

function Entity.onPlayerCollision(player: Entity) end

--[[
	Gravity:
	getGravity() returns the gravity that should be applied to an entity
	@Override it in each entity type, unless you don't want it to be affected by gravity

	applyGravity
  ]]

function Entity.getGravity(): number
	return 0
end

function Entity.applyGravity(self: Entity, dt: number)
	local g = self.getGravity()
	if g ~= 0 then
		self:setVelocity(self:getVelocity() + Vector3.new(0, g * dt, 0))
	end
end

--[[
velocity
]]

function Entity.setVelocity(self: Entity, velocity: Vector3): ()
	self.velocity = velocity
end

function Entity.getVelocity(self: Entity): Vector3
	return self.velocity
end

return Entity
