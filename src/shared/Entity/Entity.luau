local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EntityTypes = require(script.Parent.EntityTypes)
local BlockHelpers = require(ReplicatedStorage.Shared.Modules.BlockHelpers)
local Collision = require(ReplicatedStorage.Shared.Physics.Collision)

export type Entity = {
	player: Player,
	position: Vector3,
	lifeTime: number,
	onGround: boolean,
	noClip: boolean,
	velocity: Vector3,
	gravity: number,
	type: string?,
	model: (Part | MeshPart)?,

	size: Vector3,

	shouldDestroy: boolean,
	isDestroyed: boolean,

	Update: (self: Entity, number) -> (),
	Move: (self: Entity, number) -> (),
	Destroy: (self: Entity) -> (),
	GetVelocity: (self: Entity) -> Vector3,
} & any

local Entity = {}
Entity.__index = Entity

--export type Entity = typeof(setmetatable({} :: self, Entity))

function Entity.new(pos: Vector3, player: Player): Entity
	local self = setmetatable({}, Entity) :: Entity
	self.player = player
	self.position = pos
	self.lifeTime = 0
	self.onGround = false
	self.noClip = false
	self.velocity = Vector3.zero
	self.gravity = -196.2
	self.model = nil
	self.type = nil

	self.size = Vector3.zero

	self.shouldDestroy = false
	self.isDestroyed = false
	return self
end

function Entity.Update(self: Entity, dt)
	if self.shouldDestroy then
		self:Destroy()
	end
	self.lifeTime += dt
	Entity.Move(self, dt)
end

function Entity.Move(self: Entity, dt)
	self.velocity = Entity.GetVelocity(self) + Vector3.new(0, self.gravity * dt, 0)
	local movement = self.velocity * dt

	if not self.model then
		return
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

	--self.model:PivotTo(CFrame.new(self.position))
end

function Entity.Destroy(self: Entity)
	if self.model then
		self.model:Destroy()
		self.model = nil
	end
	self.isDestroyed = true
end

-- public getters

function Entity.GetVelocity(self: Entity)
	return self.velocity
end

return Entity
