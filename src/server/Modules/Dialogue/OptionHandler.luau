local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ShopService = require(ServerScriptService.Server.Services.ShopService)
local packets = require(ReplicatedStorage.Shared.network)
local OptionHandler = {}

type option = {
	callback: "endDialogue" | "openShop",
	shopId: string?,
}

function OptionHandler.Init()
	packets.ChooseDialogueOption.listen(function(data: option, player: Player)
		OptionHandler.ProcessOption(player, data)
	end)
end

function OptionHandler.ProcessOption(player: Player, data: option)
	if data.callback == "endDialogue" then
		packets.CloseDialogue.sendTo(nil, player)
	elseif data.callback == "openShop" then
		if data.shopId then
			ShopService.InitShop(player, data.shopId)
		else
			warn("No shopId given")
		end
	end
end

return OptionHandler
