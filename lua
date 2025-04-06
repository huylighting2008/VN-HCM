-- Modern GUI + Auto Aim + Trigger Bot for Shooter Games + ESP + Label VN_HCM + Drag GUI + FOV Key Toggle + LOS + Right-Click Toggle
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Config
local AimbotEnabled = false
local RightClickToggle = false
local RightMouseDown = false
local TriggerBotEnabled = false
local FOVVisible = true
local aimPart = "Head"
local aimRadius = 90
local aimSmoothness = 0.3
local teamCheck = true

-- UI Library (Simple, Modern Style)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ModernAimMenu"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 190)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Text = "Modern AimBot GUI - VN_HCM"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

local function createToggle(text, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Text = text .. ": OFF"
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
        callback(state)
    end)
end

createToggle("Auto Aim", function(state) AimbotEnabled = state end)
createToggle("Trigger Bot", function(state) TriggerBotEnabled = state end)
createToggle("RMB Aim Only", function(state) RightClickToggle = state end)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(0, 255, 0)
fovCircle.Thickness = 1.5
fovCircle.Radius = aimRadius
fovCircle.Visible = true
fovCircle.Filled = false

-- ESP Drawing for nearest enemy
local espText = Drawing.new("Text")
espText.Color = Color3.fromRGB(255, 50, 50)
espText.Size = 18
espText.Outline = true
espText.Center = true
espText.Visible = false

-- Check Line of Sight
local function hasLineOfSight(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * 1000
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local rayResult = workspace:Raycast(origin, direction, raycastParams)
    return rayResult and rayResult.Instance:IsDescendantOf(targetPart.Parent)
end

-- Get Closest Enemy
local function getClosestEnemy()
    local closest = nil
    local minDist = aimRadius
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimPart) then
            if teamCheck and player.Team == LocalPlayer.Team then continue end
            local part = player.Character[aimPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                if dist < minDist and hasLineOfSight(part) then
                    minDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

-- Trigger Bot
local function isCursorOnEnemy()
    local target = Mouse.Target
    if not target then return false end
    local model = target:FindFirstAncestorOfClass("Model")
    if model and Players:GetPlayerFromCharacter(model) and model:FindFirstChild("Humanoid") then
        if teamCheck and Players:GetPlayerFromCharacter(model).Team == LocalPlayer.Team then return false end
        return true
    end
    return false
end

-- Toggle FOV Circle visibility with keybind (F key)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        FOVVisible = not FOVVisible
        fovCircle.Visible = FOVVisible
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightMouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightMouseDown = false
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)  -- Vị trí chuột thay vì trung tâm màn hình
    fovCircle.Position = mousePos  -- Đặt vòng FOV tại vị trí chuột

    local enemy = getClosestEnemy()
    if enemy and enemy.Character and enemy.Character:FindFirstChild(aimPart) then
        local headPos, onScreen = Camera:WorldToViewportPoint(enemy.Character[aimPart].Position)
        if onScreen then
            espText.Visible = true
            espText.Position = Vector2.new(headPos.X, headPos.Y - 25)
            espText.Text = enemy.Name
        else
            espText.Visible = false
        end

        if AimbotEnabled and (not RightClickToggle or (RightClickToggle and RightMouseDown)) then
            local moveX = (headPos.X - mousePos.X) * aimSmoothness  -- Dịch chuyển theo vị trí chuột
            local moveY = (headPos.Y - mousePos.Y) * aimSmoothness
            mousemoverel(moveX, moveY)
        end
    else
        espText.Visible = false
    end

    if TriggerBotEnabled and isCursorOnEnemy() then
        mouse1press()
        wait(0.05)
        mouse1release()
    end
end)
