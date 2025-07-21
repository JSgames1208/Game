local ServerScriptService = game:GetService("ServerScriptService")
local RestockService = require(ServerScriptService.Server.Modules.Shops.RestockService)
local ShopNetworker = require(ServerScriptService.Server.Modules.Shops.ShopNetworker)
local StockState = require(ServerScriptService.Server.Modules.Shops.StockState)
local ShopService = {}

function ShopService.Init()
	RestockService.Init()
end

function ShopService.InitShop(player: Player, shopId: string)
	print(StockState.Get(shopId, nil, player))
	ShopNetworker.UpdateShop(shopId, StockState.Get(shopId, nil, player), false, player)
	ShopNetworker.OpenShop(player, shopId)
end

return ShopService
