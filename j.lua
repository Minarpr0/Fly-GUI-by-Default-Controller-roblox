local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local flying = false
local bodyVelocity
local bodyGyro
local speed = 50

local vertical = 0

-- UI Buttons
local function createButton(name, position, callback)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0, 60, 0, 60)
	button.Position = position
	button.Text = name
	button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BackgroundTransparency = 0.3
	button.BorderSizePixel = 0
	button.Font = Enum.Font.SourceSansBold
	button.TextScaled = true
	button.ZIndex = 10

	button.Parent = StarterGui:WaitForChild("ScreenGui", 1)
	button.MouseButton1Down:Connect(function()
		callback(true)
	end)
	button.MouseButton1Up:Connect(function()
		callback(false)
	end)
	return button
end

local upBtn, downBtn

function startFlying()
	if flying then return end
	flying = true

	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")

	-- BodyVelocity for flying motion
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = root

	-- BodyGyro to face camera direction
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bodyGyro.CFrame = root.CFrame
	bodyGyro.P = 10000
	bodyGyro.Parent = root

	-- Mobile buttons
	if not StarterGui:FindFirstChild("ScreenGui") then
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "ScreenGui"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = StarterGui
	end

	upBtn = createButton("Up", UDim2.new(1, -140, 1, -160), function(pressed)
		vertical = pressed and 1 or 0
	end)

	downBtn = createButton("Down", UDim2.new(1, -70, 1, -160), function(pressed)
		vertical = pressed and -1 or 0
	end)

	-- Flight loop
	RunService.RenderStepped:Connect(function()
		if flying and character and root then
			local moveDir = character:FindFirstChildOfClass("Humanoid") and character:FindFirstChildOfClass("Humanoid").MoveDirection or Vector3.zero
			local cam = workspace.CurrentCamera
			local camCF = cam.CFrame
			local up = Vector3.new(0, vertical, 0)
			local direction = (camCF:VectorToWorldSpace(moveDir) + up).Unit * speed
			if direction ~= direction then direction = Vector3.zero end -- Fix NaN
			bodyVelocity.Velocity = direction
			bodyGyro.CFrame = cam.CFrame
		end
	end)
end

function stopFlying()
	flying = false
	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end
	if upBtn then upBtn:Destroy() end
	if downBtn then downBtn:Destroy() end
	vertical = 0
end

player.Chatted:Connect(function(msg)
	if msg:lower() == "/fly" then
		startFlying()
	elseif msg:lower() == "/disable" then
		stopFlying()
	end
end)