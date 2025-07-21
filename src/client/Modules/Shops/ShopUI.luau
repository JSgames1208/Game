local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local ShopData = require(ReplicatedStorage.Shared.Data.ShopData)
local ShopFrame = require(StarterGui.UI.Frames.ShopFrame)

local PlayerGui = Players.LocalPlayer.PlayerGui
local ShopGui = PlayerGui:WaitForChild("ShopGui")

local scope = Fusion.scoped(Fusion)

local ShopUI = {}

local shopData = scope:Value({})
local shopStock = scope:Value({})
local visible = scope:Value(false)
local currency = scope:Value(0)
local timeTillRestock = scope:Value(0)
local buttonCallback = nil

function ShopUI.Init()
	local ShopFrame = ShopFrame(
		scope,
		{
			shopData = shopData,
			shopStock = shopStock,
			visible = visible,
			currency = currency,
			timeTillRestock = timeTillRestock,
			buttonCallback = buttonCallback,
		} :: ShopFrame.ShopFrameProps
	)
	ShopFrame.Parent = ShopGui
end

function ShopUI.SetShopStock(s)
	local stock = {}
	for _, item in s do
		table.insert(stock, { id = item.id, stock = scope:Value(item.stock), lastRestock = item.lastRestock })
	end

	shopStock:set(stock)
end

function ShopUI.UpdateItem(itemId: string, stock: number)
	for _, item in scope.peek(shopStock) do
		if item.id == itemId then
			item.stock:set(stock)
		end
	end
end

function ShopUI.SetShopData(shop: ShopData.Shop)
	shopData:set(shop)
end

function ShopUI.SetVisible(boolean: boolean)
	visible:set(boolean)
end

function ShopUI.SetCurrency(amount: number)
	currency:set(amount)
end

function ShopUI.SetTimeLeft(time: number)
	timeTillRestock:set(time)
end

function ShopUI.SetButtonCallback(callback)
	buttonCallback = callback
end

return ShopUI
