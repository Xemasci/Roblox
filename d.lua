local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImInsane-1337/neverlose-ui/refs/heads/main/source/library.lua"))()

local Window = Library:Window({
    Name = "Cube Script [ ver.brainrot ]",
    SubName = "By. Hiromix",
    Logo = "123456789", -- Roblox Asset ID
    MenuKeybind = Enum.KeyCode.End
})

local Page = Window:Page({Name = "Main", Icon = "rbxassetid://..."})
local MainSection = Page:Section({Name = "Teleport", Side = 1}) -- Side 1 (Left) or 2 (Right)

MainSection:Button({
    Name = "Teleport 67",
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

MainSection:Button({
    Name = "Teleport safe zone",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        hrp.CFrame = CFrame.new(
            81.2470169, 4.30880547, -7.38919687, 0.888223052, -3.8904318e-08, -0.459412485, 4.90530034e-08, 1, 1.01557767e-08, 0.459412485, -3.15561586e-08, 0.888223052
        )
    end
})
