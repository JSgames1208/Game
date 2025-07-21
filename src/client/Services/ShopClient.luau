local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local NotificationService = require(StarterPlayer.StarterPlayerScripts.Client.Services.NotificationService)
local ShopData = require(ReplicatedStorage.Shared.Data.ShopData)
local Time = require(ReplicatedStorage.Shared.Utils.Math.Time)
local packets = require(ReplicatedStorage.Shared.network)
local ShopUI = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Shops.ShopUI)
local ShopClient = {}

function ShopClient.Start()
	ShopUI.SetButtonCallback(ShopClient.ButtonClicked)
	ShopUI.Init()

	packets.UpdateShop.listen(function(data)
		if data.restock then
			NotificationService.AddNotification(`Your {data.shopId} has restocked!`)
		end
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

	local last = tick()
	RunService.RenderStepped:Connect(function()
		local now = tick()
		if now - last >= 1 then
			last = now

			ShopUI.SetTimeLeft(Time.GetTimeUntilNext5MinMark())
		end
	end)
end

function ShopClient.ButtonClicked(mode: string, shopId: string, itemId: string)
	if mode == "buy" then
		packets.QueryPurchase.send({ shopId = shopId, itemId = itemId })
	else
		return
	end
end

return ShopClient
