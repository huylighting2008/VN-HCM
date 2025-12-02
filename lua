local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleButton = Instance.new("TextButton", ScreenGui)

-- Cài đặt nút GUI
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleButton.Text = "Auto Skill: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true

local autoSkill = false

ToggleButton.MouseButton1Click:Connect(function()
    autoSkill = not autoSkill
    if autoSkill then
        ToggleButton.Text = "Auto Skill: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        ToggleButton.Text = "Auto Skill: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
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
    [1] = {key = Enum.KeyCode.One, waitTime = 1},
    [2] = {key = Enum.KeyCode.Two, waitTime = 1.5},
    [3] = {key = Enum.KeyCode.Three, waitTime = 2},
    [4] = {key = Enum.KeyCode.Four, waitTime = 3.5},
    [5] = {key = Enum.KeyCode.Five, waitTime = 4.5}
    [6] = {key = Enum.KeyCode.Six, waitTime = 5},
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
