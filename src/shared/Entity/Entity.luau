local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Collision = require(ReplicatedStorage.Shared.Physics.Collision)
local GridMath = require(ReplicatedStorage.Shared.Utils.Math.GridMath)
local Entity = {}
Entity.__index = Entity

function Entity.new(pos: Vector3, player: Player)
	local self = setmetatable({}, Entity)
	self.player = player
	self.position = pos
	self.lifeTime = 0
	self.onGround = false
	self.noClip = false
	self.velocity = Vector3.zero
	self.gravity = -55
	self.type = nil

	self.isDestroyed = false
	return self
end

function Entity:Update(dt)
	self.lifeTime += dt
	self:Move(dt)
end

local function getBottomCorners(center: Vector3, halfSize: Vector3)
	return {
		center + Vector3.new(-halfSize.X, -halfSize.Y, -halfSize.Z),
		center + Vector3.new(halfSize.X, -halfSize.Y, -halfSize.Z),
		center + Vector3.new(-halfSize.X, -halfSize.Y, halfSize.Z),
		center + Vector3.new(halfSize.X, -halfSize.Y, halfSize.Z),
		center + Vector3.new(0, -halfSize.Y, 0),
	}
end

function Entity:Move(dt)
	self.velocity = self:GetVelocity() + Vector3.new(0, self.gravity * dt, 0)
	local movement = self.velocity * dt

	if not self.model then
		return
	end

	local hit = Collision.sweepRay(
		getBottomCorners(self.position, self.model.Size / 2),
		movement,
		workspace.Entities.FallingBlocks:GetChildren()
	)

	if hit then
		self.position =
			Vector3.new(self.model.position.X, hit.Position.Y + self.model.Size.Y / 2 + 0.005, self.model.position.Z)
		self.velocity = Vector3.new(self.velocity.X, 0, self.velocity.Z)
		self.onGround = true

		if self.type == "fallingBlock" then
			self:Destroy()
			if self.placeBlockCallback then
				self.placeBlockCallback(self.player, self.position, self.blockId)
			end
			return
		end
	else
		self.position = self.position + movement
		self.onGround = false
	end

	self.model:PivotTo(CFrame.new(self.position))
end

function Entity:Destroy()
	if self.model then
		self.model:Destroy()
		self.model = nil
	end
	self.isDestroyed = true
	print("HERE")
end

-- public getters

function Entity:GetVelocity()
	return self.velocity
end

return Entity
