local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ByteNet = require(ReplicatedStorage.Packages.Bytenet)

local packets = ByteNet.defineNamespace("IslandNet", function()
	local SlotStruct = ByteNet.struct({
		count = ByteNet.int32,
		itemInfo = ByteNet.struct({
			id = ByteNet.string,
		}),
	})

	return {
		PlaceBlock = ByteNet.definePacket({
			value = ByteNet.struct({
				x = ByteNet.int32, -- or `ByteNet.int32` if blocks are at integer positions
				y = ByteNet.int32,
				z = ByteNet.int32,
				blockId = ByteNet.string,
				slot = ByteNet.int32,
			}),
			reliabilityType = "reliable",
		}),
		AssignPlot = ByteNet.definePacket({
			value = ByteNet.vec3,
			reliabilityType = "reliable",
		}),
		InventorySync = ByteNet.definePacket({
			value = ByteNet.array(SlotStruct),

			reliabilityType = "reliable",
		}),
		SlotPressed = ByteNet.definePacket({
			value = ByteNet.struct({
				slotIndex = ByteNet.int32,
			}),
			reliabilityType = "reliable",
		}),
		MineBlock = ByteNet.definePacket({
			value = ByteNet.struct({
				blockPosStr = ByteNet.string,
			}),
			reliabilityType = "reliable",
		}),
		SwapSlots = ByteNet.definePacket({
			value = ByteNet.struct({
				from = ByteNet.int32,
				to = ByteNet.int32,
			}),
			reliabilityType = "reliable",
		}),
		ShowDialogue = ByteNet.definePacket({
			value = ByteNet.struct({
				text = ByteNet.string,
				options = ByteNet.optional(ByteNet.array(ByteNet.struct({
					text = ByteNet.string,
					callback = ByteNet.string,
					shopId = ByteNet.optional(ByteNet.string),
				}))),
			}),
			reliabilityType = "reliable",
		}),
		ChooseDialogueOption = ByteNet.definePacket({
			value = ByteNet.struct({
				callback = ByteNet.string,
				shopId = ByteNet.string,
			}),
			reliabilityType = "reliable",
		}),
		OpenShop = ByteNet.definePacket({
			value = ByteNet.struct({
				shopId = ByteNet.string,
			}),
			reliabilityType = "reliable",
		}),
		CloseDialogue = ByteNet.definePacket({
			value = ByteNet.struct({}),
			reliabilityType = "reliable",
		}),
		StartDialogue = ByteNet.definePacket({
			value = ByteNet.struct({
				npcId = ByteNet.string,
			}),
			reliabilityType = "reliable",
		}),
	}
end)

return packets
