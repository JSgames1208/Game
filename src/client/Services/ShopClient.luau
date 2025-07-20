local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local ShopData = require(ReplicatedStorage.Shared.Data.ShopData)
local packets = require(ReplicatedStorage.Shared.network)
local ShopUI = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Shops.ShopUI)
local ShopClient = {}

function ShopClient.Start()
	ShopUI.Init()

	packets.UpdateShop.listen(function(data)
		if data.shopId and data.shopStock and ShopData[data.shopId] then
			ShopUI.SetShopData(ShopData[data.shopId])
			ShopUI.SetShopStock(data.shopStock)
		end
	end)

	packets.OpenShop.listen(function(data)
		ShopUI.SetVisible(true)
	end)

	packets.UpdateCurrency.listen(function(amount: number)
		ShopUI.SetCurrency(amount)
	end)
end

return ShopClient
