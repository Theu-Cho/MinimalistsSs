-- ==========================================
-- ARSENAL XENO EXPLOIT (BULLETPROOF EDITION)
-- Compatible with Xeno Executer (Kindo)
-- ==========================================

-- 1. DIAGNOSTICS & SETUP
local function safePrint(msg)
    -- Wrap in pcall to ensure even print doesn't crash the script
    pcall(function()
        print(("[Arsenal]: %s"):format(msg))
    end)
end

safePrint("Starting Script Injection...")

-- Check for Xeno Environment
local isXeno = (pcall(function()
    return _G.Xeno or _G.XenoLib or _G.XenoUI
end)) and true or false

if isXeno then
    safePrint("Xeno Environment Detected. Optimizing for Xeno task library.")
else
    safePrint("Xeno not detected. Using standard Roblox wait().")
end

-- 2. UI CREATION (Standard Roblox GUI - Works Everywhere)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Check if UI already exists
if playerGui:FindFirstChild("ArsenalXenoUI") then
    playerGui:FindFirstChild("ArsenalXenoUI"):Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "ArsenalXenoUI"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = playerGui

local mainFrame = Instance.new("Frame", sg)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(1, -360, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true

-- Title Bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
titleBar.BorderSizePixel = 0
titleBar.Active = true

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Arsenal Xeno Exploit"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Position = UDim2.new(0, 10, 0, 0)

-- Scrolling Frame for Controls
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Name = "Controls"
scrollFrame.Position = UDim2.new(0, 0, 0, 35)
scrollFrame.Size = UDim2.new(1, 0, 1, -35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Helper to Create Toggles
local function createToggle(parent, name, defaultVal, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -20, 0, 40)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    container.BorderSizePixel = 0
    container.Position = UDim2.new(0, 10, 0, 0)
    
    -- Offset for next item
    if parent:GetChildren()[1] ~= container then
        -- Simple layout: we'll handle this by setting Y position dynamically later
    end

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", container)
    toggle.Name = "ToggleBtn"
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -60, 0.5, -12)
    toggle.BackgroundColor3 = defaultVal and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
    toggle.Text = defaultVal and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12
    
    toggle.MouseButton1Click:Connect(function()
        local newVal = not (toggle.Text == "ON")
        toggle.Text = newVal and "ON" or "OFF"
        toggle.BackgroundColor3 = newVal and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
        callback(newVal)
    end)
    
    return container
end

-- Helper to Create Slider
local function createSlider(parent, name, min, max, defaultVal, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -20, 0, 60)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    container.BorderSizePixel = 0
    
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 10, 0, 5)

    local slider = Instance.new("TextButton", container)
    slider.Size = UDim2.new(1, -20, 0, 20)
    slider.Position = UDim2.new(0, 10, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    slider.Text = ""
    slider.Font = Enum.Font.Gotham
    slider.TextSize = 12

    local valueLabel = Instance.new("TextLabel", container)
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 30)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Simple Drag Logic
    local dragging = false
    local dragStart, sliderPos, startPos
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            sliderPos = slider.AbsolutePosition
            startPos = slider.AbsoluteSize.X
        end
    end)
    
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local x = (input.Position.X - dragStart.X) + sliderPos.X
            local maxPos = slider.AbsolutePosition.X + slider.AbsoluteSize.X - 20
            if x > maxPos then x = maxPos end
            if x < slider.AbsolutePosition.X then x = slider.AbsolutePosition.X end
            
            slider.Position = UDim2.fromOffset(x - slider.AbsolutePosition.X, 0)
            -- Note: AbsolutePosition logic is tricky in scripts. 
            -- For simplicity, we use a Click-to-Set approach if drag fails.
            -- But for a robust script, let's stick to a simpler "Click to Cycle" or "Input Box" if drag is buggy.
            -- Actually, let's replace drag with a simple InputBox for reliability.
        end
    end)
    
    -- Better: Replace Slider with a Simple TextBox for absolute reliability
    slider:Destroy()
    local inputBox = Instance.new("TextBox", container)
    inputBox.Size = UDim2.new(1, -70, 0, 20)
    inputBox.Position = UDim2.new(0, 10, 0, 30)
    inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    inputBox.Text = tostring(defaultVal)
    inputBox.PlaceholderText = "Enter Value"
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 12
    
    inputBox.FocusLost:Connect(function()
        local val = tonumber(inputBox.Text)
        if val then
            if val < min then val = min end
            if val > max then val = max end
            inputBox.Text = tostring(val)
            callback(val)
        else
            inputBox.Text = tostring(defaultVal)
        end
    end)
    
    return container
end

-- 3. CONFIGURATION STATE
local config = {
    AutoFarm = true,
    AutoPickup = true,
    FarmX = 0,
    FarmZ = 0,
    PickupRange = 25,
    Debug = true
}

-- 4. POPULATE UI
local yOffset = 0
local function addControl(control)
    control.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + control.Size.Y.Offset + 10
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
end

-- Toggles
local farmToggle = createToggle(scrollFrame, "Auto Farm", true, function(val)
    config.AutoFarm = val
    safePrint("Auto Farm: " .. tostring(val))
end)
addControl(farmToggle)

local pickupToggle = createToggle(scrollFrame, "Auto Pickup", true, function(val)
    config.AutoPickup = val
    safePrint("Auto Pickup: " .. tostring(val))
end)
addControl(pickupToggle)

-- Sliders (TextBoxes)
local farmXSlider = createSlider(scrollFrame, "Farm Spot X", -1000, 1000, 0, function(val)
    config.FarmX = val
end)
addControl(farmXSlider)

local farmZSlider = createSlider(scrollFrame, "Farm Spot Z", -1000, 1000, 0, function(val)
    config.FarmZ = val
end)
addControl(farmZSlider)

local pickupSlider = createSlider(scrollFrame, "Pickup Range", 5, 100, 25, function(val)
    config.PickupRange = val
end)
addControl(pickupSlider)

-- Status Label
local statusContainer = Instance.new("Frame", scrollFrame)
statusContainer.Size = UDim2.new(1, -20, 0, 30)
statusContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
statusContainer.BorderSizePixel = 0
local statusLabel = Instance.new("TextLabel", statusContainer)
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Initializing..."
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Position = UDim2.new(0, 10, 0, 0)
addControl(statusContainer)

local function updateStatus(text, color)
    statusLabel.Text = "Status: " .. text
    statusLabel.TextColor3 = color or Color3.fromRGB(0, 255, 128)
    safePrint("Status: " .. text)
end

-- 5. CORE LOGIC
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local function waitForCharacter()
    while true do
        if player.Character then
            local character = player.Character
            local humanoid = character:WaitForChild("Humanoid")
            local rootPart = character:WaitForChild("HumanoidRootPart")
            if humanoid and rootPart then
                return character, humanoid, rootPart
            end
        end
        task.wait(0.5)
    end
end

local function findRemotes()
    local remotes = {}
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            table.insert(remotes, obj)
        end
    end
    return remotes
end

local allRemotes = {}

local function scanGame()
    updateStatus("Scanning Remotes...", Color3.fromRGB(255, 255, 0))
    allRemotes = findRemotes()
    updateStatus("Ready (" .. #allRemotes .. " Remotes)", Color3.fromRGB(0, 255, 128))
    safePrint("Found " .. #allRemotes .. " Remotes.")
end

local function findNearestEnemy(rootPart, range)
    local nearest = nil
    local nearestDist = range
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            if obj ~= player.Character then
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                if hrp then
                    local dist = (hrp.Position - rootPart.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = obj
                    end
                end
            end
        end
    end
    return nearest
end

local function startExploit()
    updateStatus("Starting Loops...")
    task.spawn(function()
        local character, humanoid, rootPart = waitForCharacter()
        scanGame()
        
        while player do
            pcall(function()
                if not player.Character then
                    task.wait(1)
                    return
                end
                
                local character = player.Character
                local humanoid = character:FindFirstChild("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                
                if not humanoid or not rootPart or humanoid.Health <= 0 then
                    task.wait(0.5)
                    return
                end

                -- AUTO FARM
                if config.AutoFarm then
                    local farmPos = Vector3.new(config.FarmX, 50, config.FarmZ) -- Y=50 is a safe guess for ground level
                    local distToSpot = (rootPart.Position - farmPos).Magnitude
                    
                    if distToSpot > 15 then
                        humanoid:MoveTo(farmPos)
                    else
                        local enemy = findNearestEnemy(rootPart, 20)
                        if enemy then
                            local head = enemy:FindFirstChild("Head")
                            if head then
                                local lookCFrame = CFrame.lookAt(rootPart.Position, head.Position)
                                rootPart.CFrame = rootPart.CFrame:Lerp(lookCFrame, 0.2)
                                
                                -- Fire
