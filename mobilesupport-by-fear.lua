-- Mobile Support by fear (tablet/iPad optimized + askibs)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Hide default mobile controls
task.spawn(function()
	while true do
		local touchGui = playerGui:FindFirstChild("TouchGui")
		if touchGui then
			touchGui.Enabled = false
		end
		task.wait(0.5)
	end
end)

if playerGui:FindFirstChild("MobileControls") then
	playerGui.MobileControls:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileControls"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = playerGui

-- Credit text (bottom left)
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(0, 280, 0, 25)
Credit.Position = UDim2.new(0, 12, 1, -32)
Credit.BackgroundTransparency = 1
Credit.Text = "mobile support by fear • tablet/iPad"
Credit.TextColor3 = Color3.fromRGB(200, 200, 220)
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 14
Credit.TextXAlignment = Enum.TextXAlignment.Left
Credit.Parent = ScreenGui

-- Button sizes (scaled better for phones + tablets/iPads)
local btnSize = 78
local gap = 84
local actionSize = 70
local jumpSize = 76
local mouseSize = 70

local wasdX = 0.10
local wasdY = 0.60
local actionX = 0.58
local actionY = 0.10

local function createButton(name, text, pos, size, isCircle, accent)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = size
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
	btn.BackgroundTransparency = 0.1
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(240, 240, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.AutoButtonColor = false
	btn.Parent = ScreenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = isCircle and UDim.new(1, 0) or UDim.new(0, 16)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1.5
	stroke.Color = accent or Color3.fromRGB(80, 130, 255)
	stroke.Transparency = 0.4
	stroke.Parent = btn

	return btn
end

-- WASD
local W = createButton("W", "W", UDim2.new(wasdX, 0, wasdY, -gap), UDim2.new(0, btnSize, 0, btnSize))
local A = createButton("A", "A", UDim2.new(wasdX, -gap, wasdY, 0), UDim2.new(0, btnSize, 0, btnSize))
local S = createButton("S", "S", UDim2.new(wasdX, 0, wasdY, gap), UDim2.new(0, btnSize, 0, btnSize))
local D = createButton("D", "D", UDim2.new(wasdX, gap, wasdY, 0), UDim2.new(0, btnSize, 0, btnSize))

-- Action keys (B renamed to askibs)
local Askibs = createButton("askibs", "askibs", UDim2.new(actionX, 0, actionY, 0), UDim2.new(0, actionSize, 0, actionSize), false, Color3.fromRGB(255, 150, 60))
local E = createButton("E", "E", UDim2.new(actionX, actionSize + 16, actionY, 0), UDim2.new(0, actionSize, 0, actionSize), false, Color3.fromRGB(70, 220, 140))
local T = createButton("T", "T", UDim2.new(actionX, (actionSize + 16) * 2, actionY, 0), UDim2.new(0, actionSize, 0, actionSize), false, Color3.fromRGB(210, 90, 255))

-- Right side
local R = createButton("R", "R", UDim2.new(1, -jumpSize - 26, 1, -jumpSize - 165), UDim2.new(0, jumpSize, 0, jumpSize), false, Color3.fromRGB(255, 85, 85))
local Shift = createButton("Shift", "SHIFT", UDim2.new(1, -jumpSize - 26, 1, -jumpSize - 86), UDim2.new(0, jumpSize, 0, 56), false, Color3.fromRGB(160, 160, 255))
local Jump = createButton("Jump", "JUMP", UDim2.new(1, -jumpSize - 24, 1, -jumpSize - 20), UDim2.new(0, jumpSize, 0, jumpSize), true, Color3.fromRGB(80, 190, 255))

-- Mouse
local LMB = createButton("LMB", "LMB", UDim2.new(1, -jumpSize - mouseSize - 44, 1, -jumpSize - 20), UDim2.new(0, mouseSize, 0, mouseSize), false, Color3.fromRGB(255, 200, 50))
local RMB = createButton("RMB", "AIM", UDim2.new(1, -jumpSize - mouseSize * 2 - 64, 1, -jumpSize - 20), UDim2.new(0, mouseSize, 0, mouseSize), false, Color3.fromRGB(255, 70, 110))

-- States
local active = {
	W = false, A = false, S = false, D = false,
	R = false, B = false, E = false, T = false,
	Space = false
}
local shiftToggle = false
local rmbToggle = false
local lmbDown = false

local function setColor(btn, on, accent)
	if on then
		btn.BackgroundColor3 = accent or Color3.fromRGB(80, 130, 255)
		btn.TextColor3 = Color3.new(1, 1, 1)
	else
		btn.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
		btn.TextColor3 = Color3.fromRGB(240, 240, 255)
	end
end

local function pressKey(keyCode, isDown)
	pcall(function()
		VirtualInputManager:SendKeyEvent(isDown, keyCode, false, game)
	end)
end

local function getScreenCenter()
	local size = camera.ViewportSize
	return size.X / 2, size.Y / 2
end

local function forceMouseCenter()
	local cx, cy = getScreenCenter()
	pcall(function()
		VirtualInputManager:SendMouseMoveEvent(cx, cy, game)
	end)
end

local function setAimLock(enabled)
	if enabled then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		forceMouseCenter()
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end

local function bindHold(btn, keyName, keyCode, accent)
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			active[keyName] = true
			setColor(btn, true, accent)
			pressKey(keyCode, true)
		end
	end)
	btn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			active[keyName] = false
			setColor(btn, false)
			pressKey(keyCode, false)
		end
	end)
	btn.MouseLeave:Connect(function()
		if active[keyName] then
			active[keyName] = false
			setColor(btn, false)
			pressKey(keyCode, false)
		end
	end)
end

bindHold(W, "W", Enum.KeyCode.W)
bindHold(A, "A", Enum.KeyCode.A)
bindHold(S, "S", Enum.KeyCode.S)
bindHold(D, "D", Enum.KeyCode.D)
bindHold(Askibs, "B", Enum.KeyCode.B, Color3.fromRGB(255, 150, 60)) -- still sends B key
bindHold(E, "E", Enum.KeyCode.E, Color3.fromRGB(70, 220, 140))
bindHold(T, "T", Enum.KeyCode.T, Color3.fromRGB(210, 90, 255))
bindHold(R, "R", Enum.KeyCode.R, Color3.fromRGB(255, 85, 85))
bindHold(Jump, "Space", Enum.KeyCode.Space, Color3.fromRGB(80, 190, 255))

-- Shift
Shift.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		shiftToggle = not shiftToggle
		setColor(Shift, shiftToggle, Color3.fromRGB(140, 140, 255))
		pressKey(Enum.KeyCode.LeftShift, shiftToggle)
	end
end)

-- LMB
LMB.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		if lmbDown then return end
		lmbDown = true
		setColor(LMB, true, Color3.fromRGB(255, 200, 50))
		forceMouseCenter()
		local cx, cy = getScreenCenter()
		pcall(function()
			VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 0)
		end)
	end
end)

LMB.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		if not lmbDown then return end
		lmbDown = false
		setColor(LMB, false)
		local cx, cy = getScreenCenter()
		pcall(function()
			VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
		end)
	end
end)

LMB.MouseLeave:Connect(function()
	if lmbDown then
		lmbDown = false
		setColor(LMB, false)
		local cx, cy = getScreenCenter()
		pcall(function()
			VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
		end)
	end
end)

-- AIM (RMB)
RMB.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		rmbToggle = not rmbToggle
		setColor(RMB, rmbToggle, Color3.fromRGB(255, 70, 110))
		setAimLock(rmbToggle)

		local cx, cy = getScreenCenter()
		pcall(function()
			VirtualInputManager:SendMouseButtonEvent(cx, cy, 1, rmbToggle, game, 0)
		end)
	end
end)

-- Keep mouse centered + movement
RunService.RenderStepped:Connect(function()
	if lmbDown or rmbToggle then
		forceMouseCenter()
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	end

	local char = player.Character
	if not char then return end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end

	local move = Vector3.zero
	if active.W then move += Vector3.new(0, 0, -1) end
	if active.S then move += Vector3.new(0, 0, 1) end
	if active.A then move += Vector3.new(-1, 0, 0) end
	if active.D then move += Vector3.new(1, 0, 0) end

	if move.Magnitude > 0 then
		move = move.Unit
		local look = camera.CFrame.LookVector
		local flatLook = Vector3.new(look.X, 0, look.Z).Unit
		local flatRight = Vector3.new(camera.CFrame.RightVector.X, 0, camera.CFrame.RightVector.Z).Unit
		humanoid:Move((flatLook * -move.Z) + (flatRight * move.X), false)
	else
		humanoid:Move(Vector3.zero, false)
	end
end)

print("Mobile Support by fear (tablet/iPad + askibs) loaded")
