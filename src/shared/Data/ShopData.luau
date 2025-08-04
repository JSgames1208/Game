export type Shop = {
	id: string,
	name: string,
	mode: "buy" | "sell",
	stock: { { id: string, price: number, minStock: number?, maxStock: number, chance: number? } },
}

export type ShopData = {
	[string]: Shop,
}

return {
	Shop = {
		id = "Shop",
		name = "Shop",
		mode = "buy",
		stock = {
			{ id = "grass", price = 3, maxStock = 100 },
			{ id = "stone", price = 5, maxStock = 20, chance = 50000 },
			{ id = "sand", price = 25, maxStock = 20, chance = 10000 },
		},
	},
	TestShop = {
		id = "TestShop",
		name = "TestShop",
		mode = "buy",
		stock = {
			{ id = "gravel", price = 1, minStock = 80, maxStock = 100 },
			{ id = "cobblestone", price = 1, minStock = 80, maxStock = 100 },
			{ id = "obsidian", price = 1, minStock = 80, maxStock = 100 },
			{ id = "snow block", price = 1, minStock = 80, maxStock = 100 },
			{ id = "ice", price = 1, minStock = 80, maxStock = 100 },
			{ id = "bricks", price = 1, minStock = 80, maxStock = 100 },
		},
	},
} :: ShopData
