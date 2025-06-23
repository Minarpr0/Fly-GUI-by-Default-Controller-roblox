-- Super Jump Button Script (Client-Sided)

-- Settings
local normalJump = 50
local superJump = 250 -- change this for even higher jumping!
local isSuperJumpOn = false

-- Services
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuperJumpGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0, 150, 0, 50)
jumpButton.Position = UDim2.new(1, -160, 1, -60) -- bottom-right
jumpButton.AnchorPoint = Vector2.new(0, 0)
jumpButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
jumpButton.TextColor3 = Color3.new(1, 1, 1)
jumpButton.TextScaled = true
jumpButton.Text = "Super Jump: OFF"
jumpButton.Parent = screenGui

-- Function to toggle jump power
local function toggleJump()
	isSuperJumpOn = not isSuperJumpOn
	if isSuperJumpOn then
		humanoid.JumpPower = superJump
		jumpButton.Text = "Super Jump: ON"
		jumpButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
	else
		humanoid.JumpPower = normalJump
		jumpButton.Text = "Super Jump: OFF"
		jumpButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	end
end

-- Connect the button
jumpButton.MouseButton1Click:Connect(toggleJump)

-- Reset jump power on respawn
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
	humanoid.JumpPower = normalJump
	isSuperJumpOn = false
	jumpButton.Text = "Super Jump: OFF"
	jumpButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
end)