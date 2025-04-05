-- Serivces
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Settings
local skillSettings = {
    [2] = {key = Enum.KeyCode.Two, waitTime = 1.5},
    [3] = {key = Enum.KeyCode.Three, waitTime = 3.5},
    [4] = {key = Enum.KeyCode.Four, waitTime = 4},
    [5] = {key = Enum.KeyCode.Five, waitTime = 5}
}

-- UI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoSkillGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 100)
frame.Position = UDim2.new(0.02, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "⚔️ Auto Skill Control"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(0.8, 0, 0, 35)
toggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
toggleButton.Text = "Auto Skill: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true

local uiCornerBtn = Instance.new("UICorner", toggleButton)
uiCornerBtn.CornerRadius = UDim.new(0, 8)

local autoEnabled = false

toggleButton.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    toggleButton.Text = autoEnabled and "Auto Skill: ON" or "Auto Skill: OFF"
    toggleButton.BackgroundColor3 = autoEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- Cooldown checker
local function isSkillReady(skillNumber)
    local gui = PlayerGui:FindFirstChild("MainGui")
    if gui and gui:FindFirstChild("Cooldowns") then
        local cd = gui.Cooldowns:FindFirstChild(tostring(skillNumber))
        return not (cd and cd.Visible)
    end
    return true
end

-- Skill auto use
task.spawn(function()
    while true do
        if autoEnabled then
            for skillNum, skillData in pairs(skillSettings) do
                if isSkillReady(skillNum) then
                    VirtualInputManager:SendKeyEvent(true, skillData.key, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, skillData.key, false, game)
                    task.wait(0.2)

                    -- Click chuột để thi triển
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)

                    -- Delay thi triển animation
                    task.wait(skillData.waitTime)
                end
            end
        end
        task.wait(0.1)
    end
end)
