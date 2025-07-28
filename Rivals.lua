local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local button = script.Parent
local AIM_RADIUS = 100
local TARGET_PART_NAME = "Head"

local aimAssistEnabled = true -- Estado inicial

button.Text = "Aim Assist: ON"

-- Botón para activar/desactivar
button.MouseButton1Click:Connect(function()
	aimAssistEnabled = not aimAssistEnabled
	button.Text = "Aim Assist: " .. (aimAssistEnabled and "ON" or "OFF")
end)

-- Encuentra enemigo más cercano al cursor
local function GetClosestEnemy()
	local closestTarget = nil
	local shortestDistance = AIM_RADIUS

	for _, character in pairs(workspace:GetChildren()) do
		if character:IsA("Model") and character:FindFirstChild("Humanoid") and character:FindFirstChild(TARGET_PART_NAME) and character ~= LocalPlayer.Character then
			local part = character:FindFirstChild(TARGET_PART_NAME)
			local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)

			if onScreen then
				local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
				if dist < shortestDistance then
					shortestDistance = dist
					closestTarget = part
				end
			end
		end
	end

	return closestTarget
end

-- Loop de apuntado
RunService.RenderStepped:Connect(function()
	if not aimAssistEnabled then return end

	local targetPart = GetClosestEnemy()
	if targetPart then
		local direction = (targetPart.Position - Camera.CFrame.Position).Unit
		local newCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
		Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 0.1)
	end
end)
