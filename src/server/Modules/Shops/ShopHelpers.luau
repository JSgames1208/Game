local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StockState = require(script.Parent.StockState)
local ShopData = require(ReplicatedStorage.Shared.Data.ShopData)
local ShopHelpers = {}

function ShopHelpers.GetPrice(shopId: string, itemId: string)
	if ShopData[shopId] and ShopData[shopId].stock then
		for _, item in ShopData[shopId].stock do
			if item.id == itemId then
				return item.price
			end
		end
	end

	return math.huge
end

function ShopHelpers.GetStockAmount(player: Player, shopId: string, itemId: string)
	local itemStock = StockState.Get(shopId, itemId, player)
	if StockState.Get(shopId, itemId, player) then
		if itemStock.stock then
			return itemStock.stock
		end
	end

	return 0
end

return ShopHelpers
