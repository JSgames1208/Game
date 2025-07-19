local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local scope
local Notifications

local NotificationService = {}

function NotificationService.Init(s: typeof(Fusion.scoped(Fusion)), notifications)
	scope = s
	Notifications = notifications
end

function NotificationService.AddNotification(text: string)
	if scope and Notifications then
		local current = scope.peek(Notifications) or {}

		local newList = {}
		for i, v in ipairs(current) do
			newList[i] = v
		end

		local goal = scope:Value(0)

		local new = {
			id = HttpService:GenerateGUID(false),
			text = text,
			fade = scope:Spring(goal, 20, 1),
		}

		table.insert(newList, 1, new)
		Notifications:set(newList)

		task.delay(4, function()
			goal:set(1)

			task.delay(1, function()
				local currentList = scope.peek(Notifications)
				for i, v in ipairs(currentList) do
					if v.id == new.id then
						table.remove(currentList, i)
					end
				end
				Notifications:set(currentList)
			end)
		end)
	end
end

return NotificationService
