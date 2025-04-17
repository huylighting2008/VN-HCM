local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- GUI setup
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "UtilityMenu"
ScreenGui.ResetOnSpawn = false

-- Draggable Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Toggle button
local ToggleButton = Instance.new("TextButton", MainFrame)
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -35, 0, 5)
ToggleButton.Text = "-"
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextScaled = true

-- Options container
local OptionsContainer = Instance.new("Frame", MainFrame)
OptionsContainer.Position = UDim2.new(0, 10, 0, 45)
OptionsContainer.Size = UDim2.new(1, -20, 1, -55)
OptionsContainer.BackgroundTransparency = 1

-- Toggle states
local settings = {
    Speed = false,
    InfiniteJump = false,
    ESP = false,
    Fly = false,
    NoClip = false,
}
local walkspeed = 16
local flying = false
local noclip = false

-- Button factory
local function createToggle(name, yPosition, callback)
    local button = Instance.new("TextButton", OptionsContainer)
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0, yPosition)
    button.Text = name .. ": OFF"
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextScaled = true

    button.MouseButton1Click:Connect(function()
        settings[name] = not settings[name]
        button.Text = name .. ": " .. (settings[name] and "ON" or "OFF")
        callback(settings[name])
    end)
end

-- Speed toggle
createToggle("Speed", 0, function(enabled)
    if enabled then
        LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Speed slider
local SpeedSlider = Instance.new("TextBox", OptionsContainer)
SpeedSlider.Size = UDim2.new(1, 0, 0, 25)
SpeedSlider.Position = UDim2.new(0, 0, 0, 30)
SpeedSlider.PlaceholderText = "Tốc độ (mặc định 16)"
SpeedSlider.Text = ""
SpeedSlider.TextColor3 = Color3.new(1, 1, 1)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedSlider.Font = Enum.Font.Gotham
SpeedSlider.TextScaled = true

SpeedSlider.FocusLost:Connect(function()
    local num = tonumber(SpeedSlider.Text)
    if num then
        walkspeed = num
        if settings.Speed then
            LocalPlayer.Character.Humanoid.WalkSpeed = num
        end
    end
end)

-- Infinite Jump
createToggle("InfiniteJump", 60, function(enabled)
    if enabled then
        UserInputService.JumpRequest:Connect(function()
            if settings.InfiniteJump and LocalPlayer.Character then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end
end)

-- ESP
createToggle("ESP", 90, function(enabled)
    if enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not player.Character:FindFirstChild("ESP") then
                local billboard = Instance.new("BillboardGui", player.Character)
                billboard.Name = "ESP"
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.AlwaysOnTop = true
                billboard.StudsOffset = Vector3.new(0, 3, 0)

                local text = Instance.new("TextLabel", billboard)
                text.Size = UDim2.new(1, 0, 1, 0)
                text.Text = player.Name
                text.TextColor3 = Color3.new(1, 0, 0)
                text.TextScaled = true
                text.BackgroundTransparency = 1
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character:FindFirstChild("ESP") then
                player.Character.ESP:Destroy()
            end
        end
    end
end)

-- Fly
createToggle("Fly", 120, function(enabled)
    flying = enabled
end)

-- NoClip
createToggle("NoClip", 150, function(enabled)
    noclip = enabled
end)

-- Toggle show/hide
local minimized = false
ToggleButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    OptionsContainer.Visible = not minimized
    SpeedSlider.Visible = not minimized
    ToggleButton.Text = minimized and "+" or "-"
end)

-- Fly/NoClip logic
RunService.RenderStepped:Connect(function()
    if flying and LocalPlayer.Character then
        local char = LocalPlayer.Character
        char:FindFirstChildOfClass("Humanoid").PlatformStand = true
        local cf = char.PrimaryPart.CFrame
        char:SetPrimaryPartCFrame(cf + Vector3.new(0, 0.5, 0))
    end
    if noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)
