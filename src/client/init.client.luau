local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(ReplicatedStorage.Shared.network)

local BlockPlacer = require(script.BlockPlacer)

BlockPlacer.Start()
