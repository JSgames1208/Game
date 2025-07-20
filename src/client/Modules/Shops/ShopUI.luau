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

function ShopUI.Init()
	local ShopFrame =
		ShopFrame(scope, { shopData = shopData, shopStock = shopStock, visible = visible } :: ShopFrame.ShopFrameProps)
	ShopFrame.Parent = ShopGui
end

function ShopUI.SetShopStock(stock)
	print(stock)
	shopStock:set(stock)
end

function ShopUI.SetShopData(shop: ShopData.Shop)
	print(shop)
	shopData:set(shop)
end

function ShopUI.SetVisible(boolean: boolean)
	visible:set(boolean)
end

return ShopUI
