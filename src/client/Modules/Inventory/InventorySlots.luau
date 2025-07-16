local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local packets = require(ReplicatedStorage.Shared.network)
local ItemManager = require(StarterPlayer.StarterPlayerScripts.Client.Modules.ItemManager)

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local MainGui = PlayerGui:WaitForChild("MainGui")
local Hotbar: Frame = MainGui:WaitForChild("Hotbar") :: Frame

local InventoryFrame: Frame = MainGui:WaitForChild("Inventory") :: Frame
local OpenHotbar: Frame = InventoryFrame:WaitForChild("Hotbar") :: Frame
local MainInventory: Frame = InventoryFrame:WaitForChild("MainInventory") :: Frame

local selectedSlot = nil

local inventory = {}

local InventorySlots = {}

function InventorySlots.SlotPressed(slotIndex: number)
	local slot = nil
	for _, s in Hotbar:GetChildren() do
		if s:GetAttribute("SlotIndex") == slotIndex then
			slot = s
		end
	end
	if slotIndex <= 9 then
		local UIStroke = slot:FindFirstChild("UIStroke")
		if not selectedSlot then
			selectedSlot = slot
			UIStroke.Enabled = true

			ItemManager.SelectItem(inventory[slotIndex].itemInfo.id, slotIndex)

			packets.SlotPressed.send({ slotIndex = slotIndex })
			return
		end
		selectedSlot:FindFirstChild("UIStroke").Enabled = false
		if selectedSlot ~= slot then
			UIStroke.Enabled = true
			selectedSlot = slot

			ItemManager.SelectItem(inventory[slotIndex].itemInfo.id, slotIndex)

			packets.SlotPressed.send({ slotIndex = slotIndex })
		else
			selectedSlot = nil
			ItemManager.SelectItem("nothing", 0)
			packets.SlotPressed.send({ slotIndex = 0 })
		end
	end
end

function InventorySlots.GetItem()
	if selectedSlot then
		return selectedSlot:GetAttribute("SlotIndex"), inventory[selectedSlot:GetAttribute("SlotIndex")]
	else
		return 0, { itemInfo = { id = "nothing" }, count = 0 }
	end
end

function InventorySlots.GetSelectedSlot()
	return selectedSlot
end

function InventorySlots.Init()
	packets.InventorySync.listen(function(data)
		inventory = data
	end)
end

return InventorySlots
