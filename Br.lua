local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImInsane-1337/neverlose-ui/refs/heads/main/source/library.lua"))()
local CheatName = "Cube Script"

Library.Folders = {
    Directory = CheatName,
    Configs = CheatName .. "/Configs",
    Assets = CheatName .. "/Assets",
}

local Accent = Color3.fromRGB(255, 80, 80)
local Gradient = Color3.fromRGB(120, 20, 20)

Library.Theme.Accent = Accent
Library.Theme.AccentGradient = Gradient
Library:ChangeTheme("Accent", Accent)
Library:ChangeTheme("AccentGradient", Gradient)

local Window = Library:Window({
    Name = "Ruóix Teleport",
    SubName = "Neverlose Style",
    Logo = "78101284749172"
})

local KeybindList = Library:KeybindList("Keybinds")

Library:Watermark({
    "Cube script [ ver.Brainrot ]",
    "by UAV",
    120959262762131
})

task.spawn(function()
    while true do
        local FPS = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
        Library:Watermark({
            "Cube brainrot",
            "by UAV",
            120959262762131,
            "FPS: " .. FPS
        })
        task.wait(0.5)
    end
end)

Window:Category("Main")

local MainPage = Window:Page({Name = "Main", Icon = "138827881557940"})
local MainSection = MainPage:Section({Name = "Teleport", Side = 1})
local PlayerSection = MainPage:Section({Name = "Player", Side = 2})

-- ✅ ปุ่มวาป
MainSection:Button({
    Name = "Teleport To Location",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        hrp.CFrame = CFrame.new(
            55.6105995, 12.1384544, -1723.91345,
            0.990924418, -6.45353566e-08, 0.134420291,
            6.49106298e-08, 1, 1.59074365e-09,
            -0.134420291, 7.14899873e-09, 0.990924418
        )
    end
})

-- ✅ Speed Slider
PlayerSection:Slider({
    Name = "WalkSpeed",
    Flag = "WalkSpeed",
    Min = 16,
    Max = 1000,
    Default = 16,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
        end
    end
})

-- ✅ JumpPower Slider
PlayerSection:Slider({
    Name = "JumpPower",
    Flag = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").JumpPower = Value
        end
    end
})

-- ✅ Infinite Jump
local InfiniteJump = false
PlayerSection:Toggle({
    Name = "Infinite Jump",
    Flag = "InfJump",
    Default = false,
    Callback = function(Value)
        InfiniteJump = Value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJump then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

Window:Category("Settings")
Library:CreateSettingsPage(Window, KeybindList)

Window:Init()
