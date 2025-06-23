-- LocalScript inside StarterPlayerScripts

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50

-- Create UI Button
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlightToggleGui"

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(1, -130, 0.25, 0)  -- right side of screen
toggleButton.AnchorPoint = Vector2.new(0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleButton.Text = "Fly: OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Parent = screenGui

-- Velocity holder
local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
BodyVelocity.P = 12500

-- Function to enable/disable flying
local function toggleFlight()
	flying = not flying
	toggleButton.Text = flying and "Fly: ON" or "Fly: OFF"

	if flying then
		BodyVelocity.Parent = humanoidRootPart
	else
		BodyVelocity.Velocity = Vector3.zero
		BodyVelocity.Parent = nil
	end
end

toggleButton.MouseButton1Click:Connect(toggleFlight)

-- Fly movement handler
RunService.RenderStepped:Connect(function()
	if flying and humanoidRootPart then
		local moveDirection = Vector3.zero
		local humanoid = character:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			moveDirection = humanoid.MoveDirection
		end

		local camera = workspace.CurrentCamera
		local camCF = camera.CFrame

		-- Fly in the direction the camera is facing (XZ + Up)
		local flyVector = (camCF.RightVector * moveDirection.X) +
			(camCF.LookVector * moveDirection.Z) +
			Vector3.new(0, moveDirection.Y, 0)

		BodyVelocity.Velocity = flyVector.Unit * speed
	end
end)