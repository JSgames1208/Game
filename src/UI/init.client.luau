local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local UIManager = require(script.UIManager)

UIManager.Init(Fusion.scoped(Fusion))
