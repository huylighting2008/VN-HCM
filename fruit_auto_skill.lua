local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

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

-- Kiểm tra cooldown
local function isSkillReady(skillNumber)
    if not PlayerGui then return false end
    local CooldownGui = PlayerGui:FindFirstChild("MainGui") -- Thay tên nếu khác
    if CooldownGui and CooldownGui:FindFirstChild("Cooldowns") then
        local CooldownFrame = CooldownGui:FindFirstChild("Cooldowns"):FindFirstChild(tostring(skillNumber))
        if CooldownFrame and CooldownFrame.Visible then
            return false
        end
    end
    return true
end

-- Danh sách kỹ năng và thời gian chờ sau khi thi triển
local skillList = {
    [1] = {key = Enum.KeyCode.One, waitTime = 1.5},
    [2] = {key = Enum.KeyCode.Two, waitTime = 1.5},
    [3] = {key = Enum.KeyCode.Three, waitTime = 3.5},
    [4] = {key = Enum.KeyCode.Four, waitTime = 4},
    [5] = {key = Enum.KeyCode.Five, waitTime = 5}
}

-- Auto Skill Loop
while true do
    if autoSkill then
        for skillNum, skillData in pairs(skillList) do
            if isSkillReady(skillNum) then
                -- Chọn skill
                VirtualInputManager:SendKeyEvent(true, skillData.key, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, skillData.key, false, game)
                task.wait(0.2)

                -- Click chuột để kích hoạt
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)

                -- ⏳ Chờ thời gian thi triển animation
                task.wait(skillData.waitTime)
            end
        end
    end
    task.wait(0.1)
end
