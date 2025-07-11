local ServerScriptService = game:GetService("ServerScriptService")
local DataStore = require(ServerScriptService.Server.Services.DataStore)
local CurrencyService = {}

function CurrencyService.AddCurrency(player: Player, amount: number)
	local profile = DataStore.profiles[player.UserId]
	profile.Data.Currency = (profile.Data.Currency or 0) + amount
end

function CurrencyService.GetCurrency(player: Player)
	return DataStore.profiles[player.UserId].Data.Currency or 0
end

return CurrencyService
