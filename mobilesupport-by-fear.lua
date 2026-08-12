-- Mobile Support by fear
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

-------------------------------------------------
-- START MENU
-------------------------------------------------
local SelectFrame = Instance.new("Frame")
SelectFrame.Name = "StartMenu"
SelectFrame.Size = UDim2.new(0, 320, 0, 260)
SelectFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
SelectFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
SelectFrame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 22)
corner.Parent = SelectFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 90)
Title.Position = UDim2.new(0, 20, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Mobile support made by fear"
Title.TextColor3 = Color3.fromRGB(245, 245, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextWrapped = true
Title.Parent = SelectFrame

local BeginBtn = Instance.new("TextButton")
BeginBtn.Size = UDim2.new(0.75, 0, 0, 60)
BeginBtn.Position = UDim2.new(0.125, 0, 0, 150)
BeginBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
BeginBtn.Text = "Begin"
BeginBtn.TextColor3 = Color3.fromRGB(240, 240, 255)
BeginBtn.Font = Enum.Font.GothamBold
BeginBtn.TextSize = 24
BeginBtn.AutoButtonColor = false
BeginBtn.Parent = SelectFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 16)
btnCorner.Parent = BeginBtn

BeginBtn.MouseEnter:Connect(function()
	BeginBtn.BackgroundColor3 = Color3.fromRGB(45, 55, 80)
end)
BeginBtn.MouseLeave:Connect(function()
	BeginBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
end)

-------------------------------------------------
-- CREATE CONTROLS
-------------------------------------------------
local function createControls()
	SelectFrame:Destroy()

	-- Good default size for most phones
	local btnSize = 74
	local gap = 78
	local actionSize = 66
	local jumpSize = 72
	local mouseSize = 66
	local wasdX = 0.11
	local wasdY = 0.62
	local actionX = 0.61
	local actionY = 0.11

	local function createButton(name, text, pos, size, isCircle, accent)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = size
		btn.Position = pos
		btn.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
		btn.BackgroundTransparency = 0.05
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(245, 245, 255)
		btn.Font = Enum.Font.GothamBold
		btn.TextScaled = true
		btn.AutoButtonColor = false
		btn.Parent = ScreenGui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = isCircle and UDim.new(1, 0) or UDim.new(0, 18)
		corner.Parent = btn

		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 1.6
		stroke.Color = accent or Color3.fromRGB(90, 140, 255)
		stroke.Transparency = 0.25
		stroke.Parent = btn

		return btn
	end

	-- WASD
	local W = createButton("W", "W", UDim2.new(wasdX, 0, wasdY, -gap), UDim2.new(0, btnSize, 0, btnSize))
	local A = createButton("A", "A", UDim2.new(wasdX, -gap, wasdY, 0), UDim2.new(0, btnSize, 0, btnSize))
	local S = createButton("S", "S", UDim2.new(wasdX, 0, wasdY, gap), UDim2.new(0, btnSize, 0, btnSize))
	local D = createButton("D", "D", UDim2.new(wasdX, gap, wasdY, 0), UDim2.new(0, btnSize, 0, btnSize))

	-- Action keys
	local B = createButton("B", "askibs", UDim2.new(actionX, 0, actionY, 0), UDim2.new(0, actionSize, 0, actionSize), false, Color3.fromRGB(255, 155, 50))
	local E = createButton("E", "E", UDim2.new(actionX, actionSize + 15, actionY, 0), UDim2.new(0, actionSize, 0, actionSize), false, Color3.fromRGB(60, 220, 140))
	local T = createButton("T", "T", UDim2.new(actionX, (actionSize + 15) * 2, actionY, 0), UDim2.new(0, actionSize, 0, actionSize), false, Color3.fromRGB(200, 90, 255))

	-- Right side
	local R = createButton("R", "R", UDim2.new(1, -jumpSize - 22, 1, -jumpSize - 160), UDim2.new(0, jumpSize, 0, jumpSize), false, Color3.fromRGB(255, 80, 80))
	local Shift = createButton("Shift", "SHIFT", UDim2.new(1, -jumpSize - 22, 1, -jumpSize - 80), UDim2.new(0, jumpSize, 0, 54), false, Color3.fromRGB(150, 150, 255))
	local Jump = createButton("Jump", "JUMP", UDim2.new(1, -jumpSize - 20, 1, -jumpSize - 18), UDim2.new(0, jumpSize, 0, jumpSize), true, Color3.fromRGB(70, 185, 255))

	-- Mouse
	local LMB = createButton("LMB", "LMB", UDim2.new(1, -jumpSize - mouseSize - 40, 1, -jumpSize - 18), UDim2.new(0, mouseSize, 0, mouseSize), false, Color3.fromRGB(255, 200, 50))
	local RMB = createButton("RMB", "AIM", UDim2.new(1, -jumpSize - mouseSize * 2 - 58, 1, -jumpSize - 18), UDim2.new(0, mouseSize, 0, mouseSize), false, Color3.fromRGB(255, 70, 110))

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
			btn.BackgroundColor3 = accent or Color3.fromRGB(90, 140, 255)
			btn.TextColor3 = Color3.new(1, 1, 1)
		else
			btn.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
			btn.TextColor3 = Color3.fromRGB(245, 245, 255)
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
	bindHold(B, "B", Enum.KeyCode.B, Color3.fromRGB(255, 155, 50))
	bindHold(E, "E", Enum.KeyCode.E, Color3.fromRGB(60, 220, 140))
	bindHold(T, "T", Enum.KeyCode.T, Color3.fromRGB(200, 90, 255))
	bindHold(R, "R", Enum.KeyCode.R, Color3.fromRGB(255, 80, 80))
	bindHold(Jump, "Space", Enum.KeyCode.Space, Color3.fromRGB(70, 185, 255))

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

	-- AIM
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
end

-- Begin button
BeginBtn.MouseButton1Click:Connect(function()
	createControls()
end)

print("Mobile Support by fear loaded")SelectFrame.Name = "DeviceSelect"
SelectFrame.Size = UDim2.new(0, 340, 0, 420)
SelectFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
SelectFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SelectFrame.BackgroundTransparency = 0.1
SelectFrame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = SelectFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.3
stroke.Parent = SelectFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 70)
Title.Position = UDim2.new(0, 10, 0, 15)
Title.BackgroundTransparency = 1
Title.Text = "hi lads pick ur device\nand begin playing"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextWrapped = true
Title.Parent = SelectFrame

-- Hàm tạo nút chọn thiết bị
local function createDeviceButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.85, 0, 0, 55)
	btn.Position = UDim2.new(0.075, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Parent = SelectFrame

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 10)
	c.Parent = btn

	return btn
end

local AndroidBtn   = createDeviceButton("Android Phone", 100)
local iPhoneBtn    = createDeviceButton("iPhone", 165)
local iPadBtn      = createDeviceButton("iPad", 230)
local TabletBtn    = createDeviceButton("Android Tablet", 295)

-------------------------------------------------
-- HÀM TẠO CONTROL THEO THIẾT BỊ
-------------------------------------------------
local function createControls(device)
	SelectFrame:Destroy()

	-- Cấu hình theo từng loại máy
	local config = {
		Android = {
			btnSize = 72,
			gap = 76,
			actionSize = 64,
			jumpSize = 68,
			mouseSize = 64,
			wasdX = 0.12,
			wasdY = 0.62,
			actionX = 0.60,
			actionY = 0.11,
		},
		iPhone = {
			btnSize = 70,
			gap = 74,
			actionSize = 62,
			jumpSize = 66,
			mouseSize = 62,
			wasdX = 0.11,
			wasdY = 0.61,
			actionX = 0.58,
			actionY = 0.10,
		},
		iPad = {
			btnSize = 90,
			gap = 96,
			actionSize = 80,
			jumpSize = 85,
			mouseSize = 78,
			wasdX = 0.10,
			wasdY = 0.60,
			actionX = 0.65,
			actionY = 0.12,
		},
		Tablet = {
			btnSize = 88,
			gap = 94,
			actionSize = 78,
			jumpSize = 82,
			mouseSize = 76,
			wasdX = 0.10,
			wasdY = 0.60,
			actionX = 0.64,
			actionY = 0.12,
		}
	}

	local c = config[device]

	-- Hàm tạo nút
	local function createButton(name, text, pos, size, isCircle)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = size
		btn.Position = pos
		btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		btn.BackgroundTransparency = 0.3
		btn.Text = text
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.GothamBold
		btn.TextScaled = true
		btn.AutoButtonColor = false
		btn.Parent = ScreenGui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = isCircle and UDim.new(1, 0) or UDim.new(0.22, 0)
		corner.Parent = btn

		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 2.5
		stroke.Color = Color3.new(1, 1, 1)
		stroke.Transparency = 0.4
		stroke.Parent = btn

		return btn
	end

	-- WASD
	local W = createButton("W", "W", UDim2.new(c.wasdX, 0, c.wasdY, -c.gap), UDim2.new(0, c.btnSize, 0, c.btnSize))
	local A = createButton("A", "A", UDim2.new(c.wasdX, -c.gap, c.wasdY, 0), UDim2.new(0, c.btnSize, 0, c.btnSize))
	local S = createButton("S", "S", UDim2.new(c.wasdX, 0, c.wasdY, c.gap), UDim2.new(0, c.btnSize, 0, c.btnSize))
	local D = createButton("D", "D", UDim2.new(c.wasdX, c.gap, c.wasdY, 0), UDim2.new(0, c.btnSize, 0, c.btnSize))

	-- B E T
	local B = createButton("B", "B", UDim2.new(c.actionX, 0, c.actionY, 0), UDim2.new(0, c.actionSize, 0, c.actionSize))
	local E = createButton("E", "E", UDim2.new(c.actionX, c.actionSize + 12, c.actionY, 0), UDim2.new(0, c.actionSize, 0, c.actionSize))
	local T = createButton("T", "T", UDim2.new(c.actionX, (c.actionSize + 12) * 2, c.actionY, 0), UDim2.new(0, c.actionSize, 0, c.actionSize))

	-- R
	local R = createButton("R", "R", UDim2.new(1, -c.jumpSize - 20, 1, -c.jumpSize - 145), UDim2.new(0, c.jumpSize, 0, c.jumpSize))

	-- Shift (Toggle)
	local Shift = createButton("Shift", "SHIFT", UDim2.new(1, -c.jumpSize - 20, 1, -c.jumpSize - 70), UDim2.new(0, c.jumpSize, 0, 55))

	-- Jump (hình tròn)
	local Jump = createButton("Jump", "JUMP", UDim2.new(1, -c.jumpSize - 18, 1, -c.jumpSize - 18), UDim2.new(0, c.jumpSize, 0, c.jumpSize), true)

	-- LMB + RMB
	local LMB = createButton("LMB", "LMB", UDim2.new(1, -c.jumpSize - c.mouseSize - 35, 1, -c.jumpSize - 18), UDim2.new(0, c.mouseSize, 0, c.mouseSize))
	local RMB = createButton("RMB", "RMB", UDim2.new(1, -c.jumpSize - c.mouseSize * 2 - 52, 1, -c.jumpSize - 18), UDim2.new(0, c.mouseSize, 0, c.mouseSize))

	-- Trạng thái
	local active = {
		W = false, A = false, S = false, D = false,
		R = false, B = false, E = false, T = false,
		Space = false
	}
	local shiftToggle = false
	local rmbToggle = false

	local function setColor(btn, on)
		if on then
			btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextColor3 = Color3.new(0, 0, 0)
		else
			btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			btn.TextColor3 = Color3.new(1, 1, 1)
		end
	end

	local function pressKey(keyCode, isDown)
		pcall(function()
			VirtualInputManager:SendKeyEvent(isDown, keyCode, false, game)
		end)
	end

	-- Helper: get screen center for mouse events (stops aim pulling left)
	local function getScreenCenter()
		local size = camera.ViewportSize
		return size.X / 2, size.Y / 2
	end

	local function bindHold(btn, keyName, keyCode)
		btn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				active[keyName] = true
				setColor(btn, true)
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
	bindHold(B, "B", Enum.KeyCode.B)
	bindHold(E, "E", Enum.KeyCode.E)
	bindHold(T, "T", Enum.KeyCode.T)
	bindHold(R, "R", Enum.KeyCode.R)
	bindHold(Jump, "Space", Enum.KeyCode.Space)

	-- Shift Toggle
	Shift.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			shiftToggle = not shiftToggle
			setColor(Shift, shiftToggle)
			pressKey(Enum.KeyCode.LeftShift, shiftToggle)
		end
	end)

	-- LMB (now at screen center)
	LMB.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			setColor(LMB, true)
			local cx, cy = getScreenCenter()
			pcall(function()
				VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 0)
			end)
		end
	end)
	LMB.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			setColor(LMB, false)
			local cx, cy = getScreenCenter()
			pcall(function()
				VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
			end)
		end
	end)

	-- RMB Toggle (now at screen center)
	RMB.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			rmbToggle = not rmbToggle
			setColor(RMB, rmbToggle)
			local cx, cy = getScreenCenter()
			pcall(function()
				VirtualInputManager:SendMouseButtonEvent(cx, cy, 1, rmbToggle, game, 0)
			end)
		end
	end)

	-- Di chuyển
	RunService.RenderStepped:Connect(function()
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
end

-- Kết nối nút chọn thiết bị
AndroidBtn.MouseButton1Click:Connect(function()
	createControls("Android")
end)
iPhoneBtn.MouseButton1Click:Connect(function()
	createControls("iPhone")
end)
iPadBtn.MouseButton1Click:Connect(function()
	createControls("iPad")
end)
TabletBtn.MouseButton1Click:Connect(function()
	createControls("Tablet")
end)

print("Device selection menu loaded. Thank you for using this script!")
