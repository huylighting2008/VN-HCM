-- 📦 Dịch vụ cần thiết
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 🎨 GUI Setup (nâng cấp)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AutoSkillGUI"

-- Đổ bóng dưới nút
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(0, 186, 0, 56)
shadow.Position = UDim2.new(0.05, -3, 0.1, 3)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = ScreenGui

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 10)
shadowCorner.Parent = shadow

-- Nút toggle
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 180, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleButton.Text = "Auto Skill: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.ZIndex = 2

-- Bo góc
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = ToggleButton

-- Hiệu ứng hover
ToggleButton.MouseEnter:Connect(function()
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 160)
end)
ToggleButton.MouseLeave:Connect(function()
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- 🟢 Bật/tắt auto
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

-- ⏱️ Kiểm tra cooldown
local function isSkillReady(skillNumber)
    local CooldownGui = PlayerGui:FindFirstChild("MainGui")
    if CooldownGui and CooldownGui:FindFirstChild("Cooldowns") then
        local frame = CooldownGui.Cooldowns:FindFirstChild(tostring(skillNumber))
        if frame and frame.Visible then
            return false
        end
    end
    return true
end

-- 📋 Danh sách kỹ năng + thời gian thi triển
local skillList = {
    [2] = {key = Enum.KeyCode.Two, waitTime = 1.5},
    [3] = {key = Enum.KeyCode.Three, waitTime = 3.5},
    [4] = {key = Enum.KeyCode.Four, waitTime = 4},
    [5] = {key = Enum.KeyCode.Five, waitTime = 5}
}

-- 🧠 Hàm dùng skill
local function useSkill(skillData)
    -- Chọn skill
    VirtualInputManager:SendKeyEvent(true, skillData.key, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, skillData.key, false, game)
    task.wait(0.2)

    -- Click chuột
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)

    -- Đợi skill xong animation
    task.wait(skillData.waitTime)
end

-- 🔁 Auto Loop
task.spawn(function()
    while true do
        if autoSkill then
            for skillNum, skillData in pairs(skillList) do
                if isSkillReady(skillNum) then
                    useSkill(skillData)
                end
            end
        end
        task.wait(0.1)
    end
end)

