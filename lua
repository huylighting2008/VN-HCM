local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local radarRadius = 100 -- phạm vi thế giới
local radarSize = 150 -- pixel trên màn hình
local scale = radarRadius / (radarSize / 2)

-- Radar GUI
local radarGui = Instance.new("ScreenGui", game.CoreGui)
radarGui.Name = "RadarGUI"

local radarFrame = Instance.new("Frame", radarGui)
radarFrame.Size = UDim2.new(0, radarSize, 0, radarSize)
radarFrame.Position = UDim2.new(1, -radarSize - 20, 1, -radarSize - 100)
radarFrame.BackgroundTransparency = 1

-- Vòng radar
local radarCircle = Instance.new("ImageLabel", radarFrame)
radarCircle.Size = UDim2.new(1, 0, 1, 0)
radarCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
radarCircle.AnchorPoint = Vector2.new(0.5, 0.5)
radarCircle.Image = "rbxassetid://6023426915" -- Hình vòng radar tròn
radarCircle.BackgroundTransparency = 1
radarCircle.ImageTransparency = 0.2
radarCircle.ImageColor3 = Color3.fromRGB(0, 255, 0)

-- Tâm radar (LocalPlayer)
local radarCenter = Instance.new("Frame", radarFrame)
radarCenter.Size = UDim2.new(0, 5, 0, 5)
radarCenter.Position = UDim2.new(0.5, -2.5, 0.5, -2.5)
radarCenter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
radarCenter.BorderSizePixel = 0
radarCenter.ZIndex = 10

local playerDots = {}

local function createDot(color)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 5, 0, 5)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.BackgroundTransparency = 0
    dot.ZIndex = 5

    local corner = Instance.new("UICorner", dot)
    corner.CornerRadius = UDim.new(1, 0)
    return dot
end

local function updateRadar()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, dot in pairs(playerDots) do
        dot:Destroy()
    end
    playerDots = {}

    local camLook = Camera.CFrame.LookVector
    local angle = math.atan2(camLook.X, camLook.Z)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            local offset = targetHRP.Position - hrp.Position
            local relX = offset.X
            local relZ = offset.Z

            -- Xoay offset theo hướng camera
            local rotatedX = relX * math.cos(-angle) - relZ * math.sin(-angle)
            local rotatedZ = relX * math.sin(-angle) + relZ * math.cos(-angle)

            local radarX = rotatedX / scale
            local radarY = rotatedZ / scale

            if math.abs(radarX) < radarSize/2 and math.abs(radarY) < radarSize/2 then
                local dot = createDot(player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
                dot.Position = UDim2.new(0.5, radarX, 0.5, radarY)
                dot.Parent = radarFrame
                table.insert(playerDots, dot)
            end
        end
    end
end

RunService.RenderStepped:Connect(updateRadar)
