local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StockState = require(script.Parent.StockState)
local packets = require(ReplicatedStorage.Shared.network)

local ShopNetworker = {}

function ShopNetworker.OpenShop(player: Player, shopId: string)
	packets.OpenShop.sendTo({ shopId = shopId }, player)
end

function ShopNetworker.UpdateShop(shopId: string, shopStock: StockState.ShopStock, restock: boolean, player: Player?)
	if player then
		packets.UpdateShop.sendTo({ shopId = shopId, shopStock = shopStock, restock = restock }, player)
	else
		packets.UpdateShop.sendToAll({ shopId = shopId, shopStock = shopStock, restock = restock })
	end
end

function ShopNetworker.UpdateItem(player: Player, shopId: string, itemId: string, stock: number)
	packets.SetShopItem.sendTo({ itemId = itemId, shopId = shopId, stock = stock }, player)
end

return ShopNetworker
