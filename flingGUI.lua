-- Super's Fling GUI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SupersFlingGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Super's Fling GUI"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = frame

-- TextBox for player name
local targetBox = Instance.new("TextBox")
targetBox.PlaceholderText = "Enter player name"
targetBox.Size = UDim2.new(0, 280, 0, 30)
targetBox.Position = UDim2.new(0, 10, 0, 40)
targetBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
targetBox.TextColor3 = Color3.new(1, 1, 1)
targetBox.Font = Enum.Font.Gotham
targetBox.TextSize = 18
targetBox.ClearTextOnFocus = false
targetBox.Parent = frame

-- Fling button
local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(0, 130, 0, 30)
flingBtn.Position = UDim2.new(0, 10, 0, 80)
flingBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flingBtn.TextColor3 = Color3.new(1, 1, 1)
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextSize = 18
flingBtn.Text = "Fling"
flingBtn.Parent = frame

-- Unfling button
local unflingBtn = Instance.new("TextButton")
unflingBtn.Size = UDim2.new(0, 130, 0, 30)
unflingBtn.Position = UDim2.new(0, 160, 0, 80)
unflingBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
unflingBtn.TextColor3 = Color3.new(1, 1, 1)
unflingBtn.Font = Enum.Font.GothamBold
unflingBtn.TextSize = 18
unflingBtn.Text = "Unfling"
unflingBtn.Parent = frame

-- Variables to store fling state
local flingConnection
local flingTarget

-- Function to fling target player
local function flingPlayer(targetName)
    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer then
        warn("Player not found: " .. targetName)
        return
    end
    local targetChar = targetPlayer.Character
    local localChar = LocalPlayer.Character
    if not targetChar or not localChar then
        warn("Character not loaded for player(s)")
        return
    end

    local targetHumanoidRootPart = targetChar:FindFirstChild("HumanoidRootPart")
    local localHumanoidRootPart = localChar:FindFirstChild("HumanoidRootPart")
    if not targetHumanoidRootPart or not localHumanoidRootPart then
        warn("Missing HumanoidRootPart")
        return
    end

    -- Remove any existing fling
    if flingConnection then
        flingConnection:Disconnect()
        flingConnection = nil
    end

    flingTarget = targetHumanoidRootPart

    -- Apply BodyVelocity for fling effect
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 100, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = localHumanoidRootPart

    flingConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if flingTarget and localHumanoidRootPart and flingTarget.Parent and localHumanoidRootPart.Parent then
            localHumanoidRootPart.CFrame = flingTarget.CFrame * CFrame.new(0, 0, 2)
            bodyVelocity.Velocity = (flingTarget.Position - localHumanoidRootPart.Position).Unit * 100 + Vector3.new(0,50,0)
        else
            if flingConnection then
                flingConnection:Disconnect()
                flingConnection = nil
            end
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
    end)
end

-- Function to stop fling and reset position
local function unfling()
    if flingConnection then
        flingConnection:Disconnect()
        flingConnection = nil
    end
    local localChar = LocalPlayer.Character
    if localChar then
        localHumanoidRootPart = localChar:FindFirstChild("HumanoidRootPart")
        if localHumanoidRootPart then
            -- Remove any BodyVelocity objects
            for _, v in pairs(localHumanoidRootPart:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end
end

-- Button events
flingBtn.MouseButton1Click:Connect(function()
    local name = targetBox.Text
    if name ~= "" then
        flingPlayer(name)
    end
end)

unflingBtn.MouseButton1Click:Connect(unfling)
