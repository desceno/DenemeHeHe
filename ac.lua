local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

shared.enabled = w
game:GetService("RunService").heartbeat:connect(function()
if not shared.enabled then return end
game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.GroundHit:FireServer(workspace.Map.Blocks,1645488277.345853)
wait()
end)

local playeranticheat = game.Players.LocalPlayer.PlayerScripts.Modules
local playeranticheattwo = game.StarterPlayer.StarterPlayerScripts.Modules.anticheat
local anticheatthree = game.ReplicatedStorage.Modules.anticheat
local lagbacker = game.ReplicatedStorage.rbxts_include.node_modules.net.out._NetManaged.GroundHit

playeranticheat:remove()
playeranticheattwo:remove()
anticheatthree:remove()
lagbacker:remove()
