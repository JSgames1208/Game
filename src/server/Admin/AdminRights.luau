local AdminRightsList = require(script.Parent.AdminRightsList)
local AdminRights = {}

function AdminRights.HasRights(player: Player)
	if table.find(AdminRightsList, player.UserId) then
		return true
	else
		return false
	end
end

return AdminRights
