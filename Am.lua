local Genim = loadstring(game:HttpGet("https://raw.githubusercontent.com/raphaelsancho21-byte/Genim-Libary/refs/heads/main/Genim.lua"))()

-- ==========================================
-- CONFIGURAÇÕES
-- ==========================================
local Settings = {
    Aimbot = {
        Enabled = false,
        FOV = 100,
        Smoothing = 5,
        AimPart = "Head",
        TeamCheck = true,
        VisibleCheck = true
    },
    ESP = {
        Enabled = false,
        Boxes = false,
        Names = false,
        Tracers = false,
        TeamColor = true,
        Distance = false
    },
    Teleport = {
        SelectedPlayer = ""
    }
}

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Drawing objects
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 60
FOVCircle.Radius = Settings.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

local ESPObjects = {}

-- ==========================================
-- LÓGICA DE ESP (RIPPING DO SEU SCRIPT)
-- ==========================================
local function CreateESP(Player)
    local Objects = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        Distance = Drawing.new("Text")
    }
    
    Objects.Box.Thickness = 1
    Objects.Box.Filled = false
    Objects.Name.Size = 13
    Objects.Name.Center = true
    Objects.Name.Outline = true
    Objects.Distance.Size = 12
    Objects.Distance.Center = true
    Objects.Distance.Outline = true
    
    ESPObjects[Player] = Objects
    
    local Connection
    Connection = RunService.RenderStepped:Connect(function()
        if Player.Parent and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Settings.ESP.Enabled then
            local RootPart = Player.Character.HumanoidRootPart
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
            
            if OnScreen then
                local Color = Settings.ESP.TeamColor and Player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
                local TopPos = Camera:WorldToViewportPoint(RootPart.Position + Vector3.new(0, 3, 0))
                local BottomPos = Camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3.5, 0))
                local Height = BottomPos.Y - TopPos.Y
                local Width = Height / 1.8
                
                Objects.Box.Visible = Settings.ESP.Boxes
                Objects.Box.Position = Vector2.new(ScreenPos.X - Width/2, ScreenPos.Y - Height/2)
                Objects.Box.Size = Vector2.new(Width, Height)
                Objects.Box.Color = Color
                
                Objects.Name.Visible = Settings.ESP.Names
                Objects.Name.Position = Vector2.new(ScreenPos.X, ScreenPos.Y - Height/2 - 15)
                Objects.Name.Text = Player.Name
                Objects.Name.Color = Color
                
                Objects.Distance.Visible = Settings.ESP.Distance
                Objects.Distance.Position = Vector2.new(ScreenPos.X, ScreenPos.Y + Height/2 + 5)
                local Dist = math.floor((Camera.CFrame.Position - RootPart.Position).Magnitude)
                Objects.Distance.Text = "[" .. Dist .. "m]"
                Objects.Distance.Color = Color
                
                Objects.Tracer.Visible = Settings.ESP.Tracers
                Objects.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                Objects.Tracer.To = Vector2.new(ScreenPos.X, ScreenPos.Y + Height/2)
                Objects.Tracer.Color = Color
            else
                for _, obj in pairs(Objects) do obj.Visible = false end
            end
        else
            for _, obj in pairs(Objects) do obj.Visible = false end
            if not Player.Parent then
                for _, obj in pairs(Objects) do obj:Remove() end
                ESPObjects[Player] = nil
                Connection:Disconnect()
            end
        end
    end)
end

-- ==========================================
-- LÓGICA DO AIMBOT
-- ==========================================
local function GetClosestPlayer()
    local Target = nil
    local ClosestDistance = Settings.Aimbot.FOV
    
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild(Settings.Aimbot.AimPart) then
            if Settings.Aimbot.TeamCheck and Player.Team == LocalPlayer.Team then continue end
            
            local Part = Player.Character[Settings.Aimbot.AimPart]
            local ScreenPos, OnScreen = Camera:WorldToScreenPoint(Part.Position)
            
            if OnScreen then
                local MousePos = UserInputService:GetMouseLocation()
                local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                
                if Distance < ClosestDistance then
                    if Settings.Aimbot.VisibleCheck then
                        local RayParams = RaycastParams.new()
                        RayParams.FilterType = Enum.RaycastFilterType.Exclude
                        RayParams.FilterDescendantsInstances = {LocalPlayer.Character, Player.Character}
                        local RayResult = workspace:Raycast(Camera.CFrame.Position, (Part.Position - Camera.CFrame.Position).Unit * 500, RayParams)
                        if RayResult then continue end
                    end
                    ClosestDistance = Distance
                    Target = Part
                end
            end
        end
    end
    return Target
end

-- ==========================================
-- CRIAÇÃO DA INTERFACE
-- ==========================================
local Window = Genim:CreateWindow({
    Name = "infinix Hub | Official",
    Theme = "Ocean",
    LoadingTitle = "infinix Cheats",
    LoadingSubtitle = "by Aiba",
    Keybind = Enum.KeyCode.K
})

-- TAB: COMBATE
local AimTab = Window:CreateTab("Combate", 10734898357)
AimTab:CreateSection("Aimbot Settings")

AimTab:CreateToggle({
    Name = "Aimbot Ativado",
    CurrentValue = false,
    Callback = function(Value) Settings.Aimbot.Enabled = Value end
})

AimTab:CreateSlider({
    Name = "Raio do FOV",
    Min = 10, Max = 800, CurrentValue = 100,
    Callback = function(Value) Settings.Aimbot.FOV = Value end
})

AimTab:CreateSlider({
    Name = "Suavidade (Smoothing)",
    Min = 1, Max = 20, CurrentValue = 5,
    Callback = function(Value) Settings.Aimbot.Smoothing = Value end
})

AimTab:CreateDropdown({
    Name = "Parte do Corpo",
    Options = {"Head", "UpperTorso", "HumanoidRootPart"},
    CurrentOption = "Head",
    Callback = function(Option) Settings.Aimbot.AimPart = Option end
})

-- TAB: VISUALS
local ESPTab = Window:CreateTab("Visuals", 10734898801)
ESPTab:CreateSection("ESP Settings")

ESPTab:CreateToggle({
    Name = "Master ESP",
    CurrentValue = false,
    Callback = function(Value) Settings.ESP.Enabled = Value end
})

ESPTab:CreateToggle({
    Name = "Mostrar Caixas",
    CurrentValue = false,
    Callback = function(Value) Settings.ESP.Boxes = Value end
})

ESPTab:CreateToggle({
    Name = "Mostrar Nomes",
    CurrentValue = false,
    Callback = function(Value) Settings.ESP.Names = Value end
})

ESPTab:CreateToggle({
    Name = "Mostrar Distância",
    CurrentValue = false,
    Callback = function(Value) Settings.ESP.Distance = Value end
})

ESPTab:CreateToggle({
    Name = "Mostrar Linhas",
    CurrentValue = false,
    Callback = function(Value) Settings.ESP.Tracers = Value end
})

-- TAB: TELEPORTE
local TeleTab = Window:CreateTab("Teleporte", 15132379512)
TeleTab:CreateSection("Movimentação")

local PlayerDropdown = TeleTab:CreateDropdown({
    Name = "Selecionar Jogador",
    Options = {"Atualizar..."},
    CurrentOption = "Atualizar...",
    Callback = function(Option) Settings.Teleport.SelectedPlayer = Option end
})

TeleTab:CreateButton({
    Name = "1. Atualizar Lista",
    Callback = function()
        local Names = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(Names, p.Name) end
        end
        PlayerDropdown:Refresh(Names, true)
        Genim:Notify({
            Title = "infinix Hub",
            Content = "Updated player list!",
            Duration = 3
        })
    end
})

TeleTab:CreateButton({
    Name = "2. Teleportar",
    Callback = function()
        local Target = Players:FindFirstChild(Settings.Teleport.SelectedPlayer)
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end
})

-- ==========================================
-- LOOPS E INICIALIZAÇÃO
-- ==========================================
for _, Player in pairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer then CreateESP(Player) end
end
Players.PlayerAdded:Connect(CreateESP)

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Settings.Aimbot.Enabled
    FOVCircle.Radius = Settings.Aimbot.FOV
    FOVCircle.Position = UserInputService:GetMouseLocation()
    
    if Settings.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local Target = GetClosestPlayer()
        if Target then
            local ScreenPos = Camera:WorldToScreenPoint(Target.Position)
            local MousePos = UserInputService:GetMouseLocation()
            mousemoverel((ScreenPos.X - MousePos.X) / Settings.Aimbot.Smoothing, (ScreenPos.Y - MousePos.Y) / Settings.Aimbot.Smoothing)
        end
    end
end)

Genim:Notify({
    Title = "YouTube, infinix hub!",
    Content = "infinix Hub loading success.",
    Duration = 5
})
