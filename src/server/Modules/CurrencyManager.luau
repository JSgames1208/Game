local DataStore = require(script.Parent.DataStore)
local CurrencyManager = {}

function CurrencyManager.AddCurrency(player: Player, amount: number)
	local profile = DataStore.profiles[player.UserId]
	profile.Data.Currency = (profile.Data.Currency or 0) + amount
end

function CurrencyManager.GetCurrency(player: Player)
	return DataStore.profiles[player.UserId].Data.Currency or 0
end

return CurrencyManager
