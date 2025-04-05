-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AutoSkillGUI"

local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 180, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleButton.Text = "Auto Skill: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold

-- Bo góc
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = ToggleButton

-- Hiệu ứng đổ bóng
local shadow = Instance.new("Frame")
shadow.Size = ToggleButton.Size + UDim2.new(0, 6, 0, 6)
shadow.Position = ToggleButton.Position + UDim2.new(0, -3, 0, 3)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = ScreenGui

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 10)
shadowCorner.Parent = shadow

ToggleButton.ZIndex = 2

-- Hover effect
ToggleButton.MouseEnter:Connect(function()
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 160)
end)

ToggleButton.MouseLeave:Connect(function()
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- Kết nối toggle
local autoSkill = false

ToggleButton.MouseButton1Click:Connect(function()
    autoSkill = not autoSkill
    if autoSkill then
        ToggleButton.Text = "Auto Skill: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleButton.Text = "Auto Skill: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)
