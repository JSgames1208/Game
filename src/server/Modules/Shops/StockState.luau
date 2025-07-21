local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopData = require(ReplicatedStorage.Shared.Data.ShopData)
local StockState = {}

type ItemStock = {
	stock: number,
	lastRestock: number?,
	id: string,
}

export type ShopStock = { ItemStock }

export type ShopStateType = {
	[string]: ShopStock,
}

local state: { [number]: ShopStateType } = {} -- userId = ShopStateType

function StockState.PlayerJoined(player: Player)
	StockState.Init(player)
end

function StockState.PlayerLeaving(player: Player)
	if state[player.UserId] then
		state[player.UserId] = nil
	end
end

function StockState.Init(player: Player)
	if not state[player.UserId] then
		state[player.UserId] = {}
	end
	for _, shop in ShopData do
		if shop.stock then
			if not state[player.UserId][shop.id] then
				state[player.UserId][shop.id] = {}
			end
			for _, item in shop.stock do
				table.insert(state[player.UserId][shop.id], { id = item.id, stock = 0, lastRestock = 0 })
			end
		end
	end
end

function StockState.Get(shopId: string?, itemId: string?, player: Player)
	if not shopId then
		return state
	end

	if itemId then
		for _, itemStock in state[player.UserId][shopId] do
			if itemStock.id == itemId then
				return itemStock
			end
		end
	end

	return state[player.UserId][shopId]
end

function StockState.Set(shopId: string, data: ItemStock, player: Player?)
	local function setFor(player: Player)
		local userState = state[player.UserId]
		if not userState then
			return
		end

		local shopStock = userState[shopId]
		if not shopStock then
			userState[shopId] = {}
			shopStock = userState[shopId]
		end

		for i, itemStock in ipairs(shopStock) do
			if itemStock.id == data.id then
				if not data.lastRestock then
					data.lastRestock = itemStock.lastRestock or os.time()
				end
				shopStock[i] = data
				return
			end
		end

		table.insert(shopStock, data)
	end

	if player then
		setFor(player)
	else
		for _, plr in Players:GetPlayers() do
			setFor(plr)
		end
	end
end

function StockState.IsInStock(player: Player, shopId: string, itemId: string)
	if not state[player.UserId] then
		return false
	end

	if not state[player.UserId][shopId] then
		return false
	end

	for _, itemStock in state[player.UserId][shopId] do
		if itemStock.id == itemId then
			return itemStock.stock > 0
		end
	end

	return false
end

return StockState
