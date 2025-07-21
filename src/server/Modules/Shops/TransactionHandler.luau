local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ShopData = require(ReplicatedStorage.Shared.Data.ShopData)
local RestockService = require(script.Parent.RestockService)
local ShopHelpers = require(script.Parent.ShopHelpers)
local CurrencyService = require(ServerScriptService.Server.Services.CurrencyService)
local InventoryServer = require(ServerScriptService.Server.Services.InventoryServer)
local StockState = require(script.Parent.StockState)
local packets = require(ReplicatedStorage.Shared.network)
local TransactionHandler = {}

function TransactionHandler.Init() end

function TransactionHandler.BuyItem(player: Player, shopId: string, itemId: string)
	if StockState.IsInStock(player, shopId, itemId) then
		local price = ShopHelpers.GetPrice(shopId, itemId)
		if CurrencyService.CanAfford(player, price) then
			local stock = ShopHelpers.GetStockAmount(player, shopId, itemId)
			if stock and stock > 0 then
				CurrencyService.RemoveCurrency(player, price)
				InventoryServer.GiveItem(player, itemId, 1)
				RestockService.SetItemStock(player, shopId, itemId, stock - 1)
			end
		end
	end
end

packets.QueryPurchase.listen(function(data: { itemId: string, shopId: string }, player: Player)
	if data.itemId and data.shopId then
		TransactionHandler.BuyItem(player, data.shopId, data.itemId)
	end
end)

return TransactionHandler
