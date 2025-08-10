local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(ReplicatedStorage.Shared.network)
local AdminRights = require(script.Parent.AdminRights)
local Admin = {}

function Admin.Init(player: Player)
	if not AdminRights.HasRights(player) then
		warn(`PLAYER DOES NOT HAVE ADMIN RIGHTS: {player.Name}!!!`)
		return
	end

	print(player, packets.InitAdmin)

	packets.InitAdmin.sendTo(nil, player)
end

return Admin
