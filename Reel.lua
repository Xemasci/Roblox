local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/mamafoni281/KingRua-Library/refs/heads/main/Source"))()

local Window = Library:NewWindow({
    Title = "Cube Script [ v.0.1] ",
    Description = "Made by: Everything"
})

local MainTab = Window:T("Main")
local FarmSection = MainTab:AddSection("Auto Farm")

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local RemoteHandler = ReplicatedStorage:WaitForChild("RemoteHandler")

local CollectRemote = RemoteHandler:WaitForChild("Collect")
local FishingRemote = RemoteHandler:WaitForChild("Fishing")

local AutoCollect = false

FarmSection:AddToggle({
    Title = "Auto Collect ",
    Description = "Automatically collects Plot 5 to 10",
    Default = false,
    Callback = function(value)
        AutoCollect = value
        
        task.spawn(function()
            while AutoCollect do
                for i = 1, 10 do
                    CollectRemote:FireServer("Plot"..i)
                    task.wait(0.2)
                end
                task.wait(1)
            end
        end)
    end
})

FarmSection:AddDropdown({
    Title = "Select Upgrade Tier",
    Description = "Choose upgrade level",
    Values = {"power1", "power5", "power10"},
    Default = "power1",
    Callback = function(value)
        targetUpgrade = value
    end
})

FarmSection:AddToggle({
    Title = "🚀 Auto-Upgrade",
    Description = "Automatically upgrades selected tier",
    Default = false,
    Callback = function(value)
        autoUpgrade = value
        task.spawn(function()
            while autoUpgrade do
                game:GetService("ReplicatedStorage")
                    :WaitForChild("RemoteHandler")
                    :WaitForChild("Upgrade")
                    :FireServer(targetUpgrade)

                task.wait(0.1)
            end
        end)
    end
})

FarmSection:AddButton({
    Title = "Instant Click",
    Description = "Carry Brainrot",
    Callback = function()
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                fireproximityprompt(prompt)
                task.wait(0.05) -- กันสแปม
            end
        end
    end
})

local FishAmount = 2

FarmSection:AddSlider({
    Title = "Fishing Amount",
    Description = "Amount sent to server",
    Min = 1,
    Max = 10,
    Increment = 1,
    Default = 2,
    Callback = function(value)
        FishAmount = value
    end
})

local AutoFishing = false

FarmSection:AddToggle({
    Title = "Auto Fishing",
    Description = "Automatically sends fishing event",
    Default = false,
    Callback = function(value)
        AutoFishing = value
        
        task.spawn(function()
            while AutoFishing do
                FishingRemote:FireServer("Caught", FishAmount)
                task.wait(0.5)
            end
        end)
    end
})
