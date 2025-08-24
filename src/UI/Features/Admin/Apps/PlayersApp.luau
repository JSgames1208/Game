local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Children = Fusion.Children

local function PlayersApp(scope: typeof(Fusion.scoped(Fusion))): { any }
	local children = {}
	local players = scope:Value(Players:GetPlayers())

	Players.PlayerAdded:Connect(function(player: Player): ()
		players:set(Players:GetPlayers())
	end)

	local function insert(a: any): ()
		table.insert(children, a)
	end

	insert(scope:New("ScrollingFrame")({
		Name = "ScrollingFrame",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[Children] = {
			scope:New("UIListLayout")({
				Padding = UDim.new(0, 3),
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),

			scope:Computed(function(use)
				local playerButtons = {}
				for _, p in use(players) do
					if p.UserId ~= Players.LocalPlayer.UserId then
						table.insert(
							playerButtons,
							scope:New("TextButton")({
								Name = `{p.Name}_Button`,
								Text = `{p.Name}`,
								TextScaled = true,
								Size = UDim2.new(0.975, 0, 0, 30),
							})
						)
					end
				end

				return playerButtons
			end),
		},
	}))

	return children
end

return PlayersApp
