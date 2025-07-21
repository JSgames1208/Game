local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local packets = require(ReplicatedStorage.Shared.network)
local DataStore = require(ServerScriptService.Server.Services.DataStore)
local CurrencyService = {}

function CurrencyService.AddCurrency(player: Player, amount: number)
	local profile = DataStore.profiles[player.UserId]
	profile.Data.Currency = (profile.Data.Currency or 0) + amount

	CurrencyService.SendToClient(player)
end

function CurrencyService.RemoveCurrency(player: Player, amount: number)
	local profile = DataStore.profiles[player.UserId]
	profile.Data.Currency = math.max((profile.Data.Currency or 0) - amount, 0)

	CurrencyService.SendToClient(player)
end

function CurrencyService.SendToClient(player: Player)
	local profile = DataStore.profiles[player.UserId]
	local amount = profile.Data.Currency

	if amount then
		packets.UpdateCurrency.sendTo(amount, player)
	end
end

function CurrencyService.GetCurrency(player: Player)
	return DataStore.profiles[player.UserId].Data.Currency or 0
end

function CurrencyService.CanAfford(player: Player, amount: number)
	return CurrencyService.GetCurrency(player) >= amount
end

function CurrencyService.PlayerJoined(player: Player)
	CurrencyService.SendToClient(player)
end

return CurrencyService
