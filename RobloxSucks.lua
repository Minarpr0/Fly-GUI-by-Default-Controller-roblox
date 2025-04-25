local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flying = false
local bodyVelocity
local bodyGyro

local speed = 50

function startFlying()
	if flying then return end
	flying = true

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	-- Add BodyVelocity
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = humanoidRootPart

	-- Add BodyGyro to keep orientation steady
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bodyGyro.CFrame = humanoidRootPart.CFrame
	bodyGyro.P = 10000
	bodyGyro.Parent = humanoidRootPart

	RunService.RenderStepped:Connect(function()
		if flying and character and humanoidRootPart then
			local moveDirection = character:FindFirstChildOfClass("Humanoid") and character:FindFirstChildOfClass("Humanoid").MoveDirection or Vector3.zero
			bodyVelocity.Velocity = moveDirection * speed
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
		end
	end)
end

function stopFlying()
	flying = false
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	if bodyGyro then
		bodyGyro:Destroy()
		bodyGyro = nil
	end
end

player.Chatted:Connect(function(msg)
	if msg:lower() == "/fly" then
		startFlying()
	elseif msg:lower() == "/disable" then
		stopFlying()
	end
end)