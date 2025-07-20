local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopData = require(ReplicatedStorage.Shared.Data.ShopData)
local StockState = {}

type ItemStock = {
	stock: number,
	lastRestock: number,
	id: string,
}

export type ShopStock = { ItemStock }

export type ShopStateType = {
	[string]: ShopStock,
}

local state: ShopStateType = {}

function StockState.Init()
	for _, shop in ShopData do
		if shop.stock then
			state[shop.id] = {}
			for _, item in shop.stock do
				table.insert(state[shop.id], { id = item.id, stock = 0, lastRestock = 0 })
			end
		end
	end
end

function StockState.Get(shopId: string?, itemId: string?)
	if not shopId then
		return state
	end

	if itemId then
		for _, itemStock in state[shopId] do
			if itemStock.id == itemId then
				return itemStock
			end
		end
	end

	return state[shopId]
end

function StockState.Set(shopId: string, data: ItemStock)
	if not state[shopId] then
		state[shopId] = {}
	end

	for i, itemStock in state[shopId] do
		if itemStock.id == data.id then
			state[shopId][i] = data
			return
		end
	end

	table.insert(state[shopId], data)
end

return StockState
