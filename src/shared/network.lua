local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ByteNet = require(ReplicatedStorage.Packages.Bytenet)

local packets = ByteNet.defineNamespace("IslandNet", function()
	local SlotStruct = ByteNet.struct({
		count = ByteNet.int32,
		id = ByteNet.string,
	})

	return {
		PlaceBlock = ByteNet.definePacket({
			-- Use `value`, not `structure` or dataTypes
			value = ByteNet.struct({
				x = ByteNet.int32, -- or `ByteNet.int32` if blocks are at integer positions
				y = ByteNet.int32,
				z = ByteNet.int32,
				blockId = ByteNet.string,
			}),
			reliabilityType = "reliable", -- ensure the block place request always reaches the server
		}),
		InventorySync = ByteNet.definePacket({
			value = ByteNet.array(SlotStruct),

			reliabilityType = "reliable",
		}),
	}
end)

return packets
