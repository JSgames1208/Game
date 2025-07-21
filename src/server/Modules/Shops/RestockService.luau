local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopNetworker = require(script.Parent.ShopNetworker)
local StockState = require(script.Parent.StockState)
local ShopData = require(ReplicatedStorage.Shared.Data.ShopData)
local Chance = require(ReplicatedStorage.Shared.Utils.Math.Chance)
local Time = require(ReplicatedStorage.Shared.Utils.Math.Time)
local RestockService = {}

function RestockService.Init()
	RestockService.RestockAll()

	task.delay(Time.GetTimeUntilNext5MinMark(), function()
		while true do
			RestockService.RestockAll()
			task.wait(300) -- 5 minutes
		end
	end)
end

function RestockService.Restock(shopId: string)
	local shopConfig = ShopData[shopId]

	if not shopConfig then
		warn(`No shopData found for shop: {shopId}`)
		return
	end

	for _, item in shopConfig.stock do
		local chance = item.chance
		local total = 100000
		if chance then
			if not Chance(chance, total) then
				StockState.Set(shopId, { id = item.id, stock = 0, lastRestock = os.time() })
				continue
			end
		end

		local amount = math.random(1, item.maxStock)
		StockState.Set(shopId, { id = item.id, stock = amount, lastRestock = os.time() })
	end

	for _, player in Players:GetPlayers() do
		ShopNetworker.UpdateShop(shopId, StockState.Get(shopId, nil, player), true, player)
	end
end

function RestockService.SetItemStock(player: Player, shopId: string, itemId: string, amount: number)
	StockState.Set(shopId, { id = itemId, stock = amount }, player)

	ShopNetworker.UpdateItem(player, shopId, itemId, amount)
end

function RestockService.RestockAll()
	for _, shop in ShopData do
		RestockService.Restock(shop.id)
	end
end

return RestockService
