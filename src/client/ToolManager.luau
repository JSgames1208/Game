local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ItemEquip = require(script.Parent.ItemEquip)
local packets = require(ReplicatedStorage.Shared.network)

local player = Players.LocalPlayer
local Mouse = player:GetMouse()

local character = player.Character or player.CharacterAdded:Wait()
local humanoid: Humanoid = character:WaitForChild("Humanoid")
local animator: Animator = humanoid:WaitForChild("Animator") :: Animator

local ToolManager = {}

ToolManager.MouseDown = false

local currentTool = nil
local currentSlot = nil

local highlightpart = workspace:WaitForChild("highlightpart")
local highlight = Instance.new("Highlight")
highlight.Parent = highlightpart
highlight.DepthMode = Enum.HighlightDepthMode.Occluded
highlight.FillTransparency = 1
highlight.Adornee = highlightpart

local miningAnimationTrack = Instance.new("Animation")
miningAnimationTrack.AnimationId = "rbxassetid://103813252472730"
miningAnimationTrack.Parent = character

local currentAnimation = nil

local miningAnimation = animator:LoadAnimation(miningAnimationTrack)
miningAnimation.Looped = true

local isMining = false

local function StartAnimation(animationName: string)
	if animationName ~= currentAnimation then
		currentAnimation = animationName
		if animationName == "miningAnimation" then
			isMining = true
			miningAnimation:Play(0, 1, 1)
		end
	end
end

local function StopAnimation(animationName: string)
	if animationName == "miningAnimation" then
		isMining = false
	end
	currentAnimation = nil
end

-- only connect DidLoop once
miningAnimation.DidLoop:Connect(function()
	if not isMining then
		miningAnimation:Stop()
	end
end)

local currentMiningCooldown = 0

function ToolManager.Start()
	RunService.RenderStepped:Connect(function(dt: number)
		if currentMiningCooldown > 0 then
			currentMiningCooldown = math.max(0, currentMiningCooldown - dt)
		end
		if currentTool then
			ItemEquip.Equip(currentTool)
			local target = Mouse.Target
			if target then
				if target:HasTag("Block") then
					if target ~= highlight.Adornee and target.Parent ~= highlight.Adornee then
						if target.Parent:HasTag("Block") then
							highlight.Adornee = target.Parent
						else
							highlight.Adornee = target
						end
					end

					if ToolManager.MouseDown and currentMiningCooldown <= 0 then
						StartAnimation("miningAnimation")
						currentMiningCooldown = miningAnimation.Length / miningAnimation.Speed
						coroutine.wrap(function()
							task.wait(0.4)
							if target.Parent:HasTag("Block") then
								packets.MineBlock.send({ blockPosStr = target.Parent.Name })
							else
								packets.MineBlock.send({ blockPosStr = target.Name })
							end
						end)()
					end
				else
					highlight.Adornee = highlightpart
				end
			else
				highlight.Adornee = highlightpart
			end
		else
			highlight.Adornee = highlightpart
		end
		if not ToolManager.MouseDown then
			if miningAnimation.IsPlaying then
				StopAnimation("miningAnimation")
			end
		end
	end)
end

function ToolManager.SelectTool(toolId: string, slotIndex)
	currentSlot = slotIndex
	currentTool = toolId
	if toolId == "nothing" then
		ItemEquip.UnEquip()
		currentTool = nil
	else
		currentTool = toolId
	end
end

function ToolManager.Unselect()
	currentTool = nil
	ToolManager.SelectTool("nothing", 0)
end

packets.InventorySync.listen(function(data)
	if not currentSlot then
		return
	end
	if data[currentSlot] then
		if data[currentSlot].count <= 0 then
			ToolManager.SelectTool("nothing", currentSlot)
		end
	end
end)

return ToolManager
