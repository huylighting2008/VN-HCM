local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Camera = workspace.CurrentCamera
local radarRadius = 100 -- bán kính vòng radar
local radarSize = 150 -- size pixel trên màn hình
local scale = radarRadius / (radarSize / 2)

-- Tạo GUI
local radarGui = Instance.new("ScreenGui", game.CoreGui)
radarGui.Name = "RadarGUI"

local radarFrame = Instance.new("Frame", radarGui)
radarFrame.Size = UDim2.new(0, radarSize, 0, radarSize)
radarFrame.Position = UDim2.new(1, -radarSize - 20, 1, -radarSize - 100)
radarFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
radarFrame.BackgroundTransparency = 0.2
radarFrame.BorderSizePixel = 0
radarFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local radarCorner = Instance.new("UICorner", radarFrame)
radarCorner.CornerRadius = UDim.new(1, 0)

-- Vòng tròn trung tâm
local radarCenter = Instance.new("Frame", radarFrame)
radarCenter.Size = UDim2.new(0, 4, 0, 4)
radarCenter.Position = UDim2.new(0.5, -2, 0.5, -2)
radarCenter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
radarCenter.BorderSizePixel = 0

-- Lưu icon người chơi để tái sử dụng
local playerDots = {}

local function updateRadar()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, dot in pairs(playerDots) do
        dot:Destroy()
    end
    playerDots = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local otherChar = player.Character
        local otherHRP = otherChar and otherChar:FindFirstChild("HumanoidRootPart")
        if otherHRP then
            local offset = otherHRP.Position - hrp.Position
            local x = offset.X / scale
            local z = offset.Z / scale

            if math.abs(x) <= radarSize/2 and math.abs(z) <= radarSize/2 then
                local dot = Instance.new("Frame", radarFrame)
                dot.Size = UDim2.new(0, 5, 0, 5)
                dot.Position = UDim2.new(0.5, x, 0.5, z)
                dot.BackgroundColor3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                dot.BorderSizePixel = 0
                dot.BackgroundTransparency = 0
                table.insert(playerDots, dot)
            end
        end
    end
end

-- Update radar mỗi frame
RunService.RenderStepped:Connect(updateRadar)
