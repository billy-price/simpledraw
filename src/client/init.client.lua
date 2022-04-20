-- Services
local Shared = game:GetService("ReplicatedStorage").Common
local Players = game:GetService("Players")

-- Imports
local Roact = require(Shared.Roact)
local e = Roact.createElement
local App = require(script.App)

local handle = Roact.mount(e(App), Players.LocalPlayer.PlayerGui)
