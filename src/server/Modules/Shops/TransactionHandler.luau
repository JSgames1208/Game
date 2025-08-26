local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerInventory = require(ServerScriptService.Server.Entity.Player.PlayerInventory)
local ItemStack = require(ReplicatedStorage.Shared.Item.ItemStack)
local RestockService = require(script.Parent.RestockService)
local ShopHelpers = require(script.Parent.ShopHelpers)
local CurrencyService = require(ServerScriptService.Server.Services.CurrencyService)
local EntityService = require(ServerScriptService.Server.Services.EntityService)
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
				local inventory: PlayerInventory.PlayerInventory = EntityService.getPlayerEntity(player):getInventory()
				inventory:addStack(ItemStack.new(itemId, 1))
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
