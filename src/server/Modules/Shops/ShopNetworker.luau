local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StockState = require(script.Parent.StockState)
local packets = require(ReplicatedStorage.Shared.network)

local ShopNetworker = {}

function ShopNetworker.OpenShop(player: Player, shopId: string)
	packets.OpenShop.sendTo({ shopId = shopId }, player)
end

function ShopNetworker.UpdateShop(shopId: string, shopStock: StockState.ShopStock, player: Player?)
	print(shopId, shopStock)

	if player then
		packets.UpdateShop.sendTo({ shopId = shopId, shopStock = shopStock }, player)
	else
		packets.UpdateShop.sendToAll({ shopId = shopId, shopStock = shopStock })
	end
end

return ShopNetworker
