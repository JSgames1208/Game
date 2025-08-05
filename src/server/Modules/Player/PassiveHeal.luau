local RunService = game:GetService("RunService")
local PassiveHeal = {}

local players = {}

function PassiveHeal.Interrupt(player)
	if players[player.UserId] then
		players[player.UserId].lastInterrupt = os.time()
	end
end

function PassiveHeal.Start(playerObj)
	local player = playerObj.player
	players[player.UserId] = { obj = playerObj, lastInterrupt = os.time(), lastHeal = os.time() }

	RunService.Heartbeat:Connect(function()
		if os.time() - players[player.UserId].lastInterrupt >= 5 then
			if os.time() - players[player.UserId].lastHeal >= 1 then
				players[player.UserId].obj:addHealth(3)
				players[player.UserId].lastHeal = os.time()
			end
		end
	end)
end

return PassiveHeal
