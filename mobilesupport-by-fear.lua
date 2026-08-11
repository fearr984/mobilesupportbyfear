-- LocalScript Mobile Controls (có bảng chọn thiết bị)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Ẩn control mặc định
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
-- BẢNG CHỌN THIẾT BỊ
-------------------------------------------------
local SelectFrame = Instance.new("Frame")
SelectFrame.Name = "DeviceSelect"
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