--// Fruit Battlegrounds Auto Skill (Manual Input Version)
--// Velocity Executor Compatible

local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

--================ CONFIG =================
local skills = {
	[1] = {key=Enum.KeyCode.One,   hold=5, cd=6, enabled=true, last=0},
	[2] = {key=Enum.KeyCode.Two,   hold=5, cd=6, enabled=true, last=0},
	[3] = {key=Enum.KeyCode.Three, hold=5, cd=6, enabled=true, last=0},
	[4] = {key=Enum.KeyCode.Four,  hold=5, cd=8, enabled=true, last=0},
	[5] = {key=Enum.KeyCode.Five,  hold=5, cd=10,enabled=true, last=0},
	[6] = {key=Enum.KeyCode.Six,   hold=5, cd=12,enabled=true, last=0},
}

local auto = false
local current = 1
local busy = false

--================ GUI =================
local gui = Instance.new("ScreenGui", PG)
gui.Name = "FB_AutoSkill"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,340,0,380)
main.Position = UDim2.new(0.05,0,0.2,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.Text = "Fruit Battlegrounds Auto Skill"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextScaled = true

local toggle = Instance.new("TextButton", main)
toggle.Position = UDim2.new(0,10,0,45)
toggle.Size = UDim2.new(1,-20,0,35)
toggle.Text = "AUTO: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
toggle.TextScaled = true
toggle.TextColor3 = Color3.new(1,1,1)

toggle.MouseButton1Click:Connect(function()
	auto = not auto
	toggle.Text = auto and "AUTO: ON" or "AUTO: OFF"
	toggle.BackgroundColor3 = auto and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
end)

local collapse = Instance.new("TextButton", main)
collapse.Size = UDim2.new(0,35,0,35)
collapse.Position = UDim2.new(1,-40,0,0)
collapse.Text = "-"
collapse.TextScaled = true

local collapsed = false
collapse.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	for _,v in ipairs(main:GetChildren()) do
		if v ~= title and v ~= collapse then
			v.Visible = not collapsed
		end
	end
	main.Size = collapsed and UDim2.new(0,340,0,40) or UDim2.new(0,340,0,380)
end)

--================ SKILL UI =================
local y = 90
for i,v in ipairs(skills) do
	local box = Instance.new("Frame", main)
	box.Size = UDim2.new(1,-20,0,45)
	box.Position = UDim2.new(0,10,0,y)
	box.BackgroundColor3 = Color3.fromRGB(35,35,35)

	-- Enable toggle
	local btn = Instance.new("TextButton", box)
	btn.Size = UDim2.new(0,40,1,0)
	btn.Text = "ON"
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(0,170,0)

	btn.MouseButton1Click:Connect(function()
		v.enabled = not v.enabled
		btn.Text = v.enabled and "ON" or "OFF"
		btn.BackgroundColor3 = v.enabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
	end)

	-- Label
	local lbl = Instance.new("TextLabel", box)
	lbl.Position = UDim2.new(0,45,0,0)
	lbl.Size = UDim2.new(0.45,0,1,0)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.TextScaled = true
	lbl.Text = "Skill "..i

	-- HOLD input
	local holdBox = Instance.new("TextBox", box)
	holdBox.Position = UDim2.new(0.55,0,0.1,0)
	holdBox.Size = UDim2.new(0.18,0,0.8,0)
	holdBox.Text = tostring(v.hold)
	holdBox.PlaceholderText = "HOLD"
	holdBox.TextScaled = true
	holdBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
	holdBox.TextColor3 = Color3.new(1,1,1)
	holdBox.ClearTextOnFocus = false

	holdBox.FocusLost:Connect(function()
		local n = tonumber(holdBox.Text)
		if n and n > 0 then
			v.hold = n
		else
			holdBox.Text = tostring(v.hold)
		end
	end)

	-- CD input
	local cdBox = Instance.new("TextBox", box)
	cdBox.Position = UDim2.new(0.75,0,0.1,0)
	cdBox.Size = UDim2.new(0.2,0,0.8,0)
	cdBox.Text = tostring(v.cd)
	cdBox.PlaceholderText = "CD"
	cdBox.TextScaled = true
	cdBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
	cdBox.TextColor3 = Color3.new(1,1,1)
	cdBox.ClearTextOnFocus = false

	cdBox.FocusLost:Connect(function()
		local n = tonumber(cdBox.Text)
		if n and n >= 0 then
			v.cd = n
		else
			cdBox.Text = tostring(v.cd)
		end
	end)

	y += 50
end

--================ AUTO LOGIC =================
RunService.Heartbeat:Connect(function()
	if not auto or busy then return end

	local s = skills[current]
	if not s or not s.enabled then
		current = current % 6 + 1
		return
	end

	if tick() - s.last < s.cd then
		current = current % 6 + 1
		return
	end

	busy = true
	s.last = tick()

	task.spawn(function()
		-- Select skill
		VIM:SendKeyEvent(true, s.key, false, game)
		task.wait(0.05)
		VIM:SendKeyEvent(false, s.key, false, game)

		-- Hold mouse to channel skill
		task.wait(0.1)
		VIM:SendMouseButtonEvent(0,0,0,true,game,0)
		task.wait(s.hold)
		VIM:SendMouseButtonEvent(0,0,0,false,game,0)

		current = current % 6 + 1
		busy = false
	end)
end)
