local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopData = require(ReplicatedStorage.Shared.Data.ShopData)
local StockState = {}

type ItemStock = {
	stock: number,
	lastRestock: number,
}

export type ShopStock = {
	[string]: ItemStock,
}

export type ShopStateType = {
	[string]: ShopStock,
}

local state: ShopStateType = {}

function StockState.Init()
	for _, shop in ShopData do
		if shop.stock then
			state[shop.id] = {}
			for _, item in shop.stock do
				state[shop.id][item.id] = { stock = 0, lastRestock = 0 }
			end
		end
	end
end

function StockState.Get(shopId: string?, itemId: string?)
	if not shopId then
		return state
	end

	if itemId then
		return state[shopId] and state[shopId][itemId]
	end

	return state[shopId]
end

function StockState.Set(shopId: string, itemId: string, data: ItemStock)
	if not state[shopId] then
		state[shopId] = {}
	end

	print(shopId, itemId, data)

	state[shopId][itemId] = data
end

return StockState
