local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local GameName = ""


local GameIds = {
    [6137321701] = "Blair (Lobby)",
    [6348640020] = "Blair",
    [18199615050] = "Demonology [Lobby]",
    [18794863104] = "Demonology [Game]",
    [8260276694] = "Ability Wars",

}

GameName = GameIds[game.PlaceId] or "Universal"

local KeyModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Chavels123/Newloader/refs/heads/main/KeymodulesBeta.lua"))()


KeyModule.MainWindow = nil 
print("[PulseHub] Key system initialized!")

local function CreateInstance(instanceType)
    return function(properties)
        local instance = Instance.new(instanceType)
        for property, value in pairs(properties) do
            instance[property] = value
        end
        return instance
    end
end

local function Tween(instance, properties, duration, easingStyle, easingDirection, delay)
    local info = TweenInfo.new(
        duration or 0.5,
        easingStyle or Enum.EasingStyle.Quint,
        easingDirection or Enum.EasingDirection.Out,
        0,
        false,
        delay or 0
    )
    
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

local function CreateRipple(parent, position)
    local ripple = CreateInstance("Frame")({
        Name = "Ripple",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.8,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = position,
        Size = UDim2.new(0, 0, 0, 0),
        Parent = parent,
        BorderSizePixel = 0,
        ZIndex = parent.ZIndex + 1
    })
    
    local corner = CreateInstance("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    })
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    
    Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.8)
    
    task.delay(0.8, function()
        ripple:Destroy()
    end)
end

local function checkSavedKey()
    local success, keyData = pcall(function()
        if isfile("KeyText.txt") then
            return readfile("KeyText.txt")
        end
        return nil
    end)
    
    if success and keyData then
        return keyData
    else
        return nil
    end
 end

local function saveKeyToFile(key)
    local success, err = pcall(function()
        writefile("KeyText.txt", key)
    end)
    
    if not success then
        warn("[PulseHub] Failed to save key: " .. tostring(err))
    end
end

local function deleteKeyFile()
    if isfile("KeyText.txt") then
        pcall(function()
            delfile("KeyText.txt")
        end)
    end
end

local function CreateKeySystem()
    local screenGui = CreateInstance("ScreenGui")({
        Name = "PulseHubKeySystem",
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })
    
    KeyModule.MainWindow = screenGui
    
    local introFrame = CreateInstance("Frame")({
        Name = "IntroFrame",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = screenGui,
        BorderSizePixel = 0,
        ZIndex = 10
    })
    
    local introLogo = CreateInstance("ImageLabel")({
        Name = "IntroLogo",
        BackgroundTransparency = 1,
        Image = "?",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = introFrame,
        ZIndex = 11,
        ImageColor3 = Color3.fromRGB(255, 255, 255)
    })
    
    local introText = CreateInstance("TextLabel")({
        Name = "IntroText",
        BackgroundTransparency = 1,
        Text = "PULSE HUB",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 0,
        Font = Enum.Font.GothamBold,
        Position = UDim2.new(0.5, 0, 0.6, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = introFrame,
        ZIndex = 11
    })
    
    local mainFrame = CreateInstance("Frame")({
        Name = "MainFrame",
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Size = UDim2.new(0, 400, 0, 500),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = screenGui,
        BorderSizePixel = 0,
        Visible = false
    })
    
    local shadow = CreateInstance("ImageLabel")({
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://7912134082",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.2,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 50, 1, 50),
        SliceCenter = Rect.new(80, 80, 80, 80),
        SliceScale = 1,
        ScaleType = Enum.ScaleType.Slice,
        Parent = mainFrame,
        ZIndex = 0
    })
    
    local uiCorner = CreateInstance("UICorner")({
        CornerRadius = UDim.new(0, 12),
        Parent = mainFrame
    })
    
    local topBar = CreateInstance("Frame")({
        Name = "TopBar",
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = mainFrame,
        BorderSizePixel = 0
    })
    
    local isDragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and isDragging then
            updateDrag(input)
        end
    end)
    
    local topBarCorner = CreateInstance("UICorner")({
        CornerRadius = UDim.new(0, 12),
        Parent = topBar
    })
    
    local topBarFix = CreateInstance("Frame")({
        Name = "TopBarFix",
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        Parent = topBar,
        BorderSizePixel = 0
    })
    
    local title = CreateInstance("TextLabel")({
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = "PulseHub - " .. GameName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    local closeButton = CreateInstance("TextButton")({
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -40, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 24,
        Parent = topBar
    })
    
    closeButton.MouseButton1Click:Connect(function()
        Tween(mainFrame, {Size = UDim2.new(0, 400, 0, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.5)
        screenGui:Destroy()
    end)
    
    local content = CreateInstance("Frame")({
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        Parent = mainFrame
    })
    
    local profileFrame = CreateInstance("Frame")({
        Name = "ProfileFrame",
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0.5, 0, 0, 30),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = content
    })
    
    local profileCorner = CreateInstance("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = profileFrame
    })
    
    local profileStroke = CreateInstance("UIStroke")({
        Color = Color3.fromRGB(0, 170, 255),
        Thickness = 3,
        Parent = profileFrame
    })
    
    local logo = CreateInstance("ImageLabel")({
        Name = "Logo",
        BackgroundTransparency = 1,
        Image = "https://imgur.com/a/MB1FdTF",
        Size = UDim2.new(0.8, 0, 0.8, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = profileFrame,
        ImageColor3 = Color3.fromRGB(255, 255, 255)
    })
    
    local logoGlow = CreateInstance("ImageLabel")({
        Name = "LogoGlow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://7912134082",
        ImageColor3 = Color3.fromRGB(0, 170, 255),
        ImageTransparency = 0.7,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1.5, 0, 1.5, 0),
        Parent = profileFrame,
        ZIndex = 0
    })
    
    local welcomeLabel = CreateInstance("TextLabel")({
        Name = "WelcomeLabel",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 120),
        Font = Enum.Font.GothamBold,
        Text = "Welcome to PulseHub",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Parent = content
    })
    
    local gameLabel = CreateInstance("TextLabel")({
        Name = "GameLabel",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 145),
        Font = Enum.Font.GothamSemibold,
        Text = "Detected: " .. GameName,
        TextColor3 = Color3.fromRGB(0, 170, 255),
        TextSize = 14,
        Parent = content
    })
    
    local keyLabel = CreateInstance("TextLabel")({
        Name = "KeyLabel",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 165),
        Font = Enum.Font.GothamSemibold,
        Text = "Enter Key to Continue",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 14,
        Parent = content
    })
    
    local keyInputFrame = CreateInstance("Frame")({
        Name = "KeyInputFrame",
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(0.8, 0, 0, 45),
        Position = UDim2.new(0.5, 0, 0, 205),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = content,
        BorderSizePixel = 0
    })
    
    local keyInputCorner = CreateInstance("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = keyInputFrame
    })
    
    local keyInputStroke = CreateInstance("UIStroke")({
        Color = Color3.fromRGB(60, 60, 60),
        Thickness = 2,
        Parent = keyInputFrame
    })
    
    local keyInput = CreateInstance("TextBox")({
        Name = "KeyInput",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Enum.Font.Gotham,
        PlaceholderText = "Enter your key here...",
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        ClearTextOnFocus = false,
        Parent = keyInputFrame
    })
    
    local submitButton = CreateInstance("TextButton")({
        Name = "SubmitButton",
        BackgroundColor3 = Color3.fromRGB(0, 120, 255),
        Size = UDim2.new(0.8, 0, 0, 45),
        Position = UDim2.new(0.5, 0, 0, 265),
        AnchorPoint = Vector2.new(0.5, 0),
        Font = Enum.Font.GothamBold,
        Text = "Submit Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Parent = content,
        BorderSizePixel = 0
    })
    
    local submitGradient = CreateInstance("UIGradient")({
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255))
        }),
        Rotation = 90,
        Parent = submitButton
    })
    
    local submitCorner = CreateInstance("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = submitButton
    })
    
    local orLabel = CreateInstance("TextLabel")({
        Name = "OrLabel",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 320),
        Font = Enum.Font.GothamBold,
        Text = "OR",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 14,
        Parent = content
    })
    
    local getKeyButton = CreateInstance("TextButton")({
        Name = "GetKeyButton",
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(0.8, 0, 0, 40),
        Position = UDim2.new(0.5, 0, 0, 345),
        AnchorPoint = Vector2.new(0.5, 0),
        Font = Enum.Font.GothamBold,
        Text = "Get Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Parent = content,
        BorderSizePixel = 0
    })
    
    local getKeyGradient = CreateInstance("UIGradient")({
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 70, 70))
        }),
        Rotation = 90,
        Parent = getKeyButton
    })
    
    local getKeyCorner = CreateInstance("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = getKeyButton
    })
    
    local statusLabel = CreateInstance("TextLabel")({
        Name = "StatusLabel",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 395),
        Font = Enum.Font.GothamSemibold,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Parent = content
    })
    

    
    local function validateKey(key)
        if not key or key == "" then
            statusLabel.Text = "Please enter a key first!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            local shake = function(obj, intensity, times)
                local origPos = obj.Position
                for i = 1, times do
                    Tween(obj, {Position = origPos + UDim2.new(0, math.random(-intensity, intensity), 0, 0)}, 0.05)
                    task.wait(0.05)
                end
                Tween(obj, {Position = origPos}, 0.1)
            end
            
            shake(keyInputFrame, 5, 5)
            return false
        end
        
        KeyModule.MainWindow = screenGui
        KeyModule.Notify = function(notifyData)
            statusLabel.Text = notifyData.Content
            statusLabel.TextColor3 = notifyData.Title == "Success" and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
            
            if notifyData.Title == "Success" then
                keyInputStroke.Color = Color3.fromRGB(0, 255, 100)
                Tween(keyInputFrame, {BackgroundColor3 = Color3.fromRGB(30, 50, 30)}, 0.3)
                local successIcon = CreateInstance("ImageLabel")({
                    Name = "SuccessIcon",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://7733715400",
                    ImageColor3 = Color3.fromRGB(0, 255, 100),
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Parent = mainFrame
                })
                Tween(successIcon, {Size = UDim2.new(0, 100, 0, 100)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                task.wait(1)
                Tween(successIcon, {Size = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.wait(0.3)
                print("[PulseHub] Loading script directly...")
                local currentKey = keyInput.Text
                if currentKey and currentKey ~= "" then
                    getgenv().script_key = currentKey
                    local scriptId = KeyModule.ScriptID
                    pcall(function()
                        local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
                        api.script_id = scriptId
                        print("[PulseHub] Using script ID:", scriptId)
                        print("[PulseHub] Using key:", string.sub(currentKey, 1, 5) .. "...")
                        api.load_script()
                        print("[PulseHub] Script loaded successfully!")
                    end)
                end
                
                
                Tween(mainFrame, {Size = UDim2.new(0, 400, 0, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.wait(0.5)
                
                screenGui:Destroy()
            else
                keyInputStroke.Color = Color3.fromRGB(255, 50, 50)
                Tween(keyInputFrame, {BackgroundColor3 = Color3.fromRGB(50, 30, 30)}, 0.3)
                
                local shake = function(obj, intensity, times)
                    local origPos = obj.Position
                    for i = 1, times do
                        Tween(obj, {Position = origPos + UDim2.new(0, math.random(-intensity, intensity), 0, 0)}, 0.05)
                        task.wait(0.05)
                    end
                    Tween(obj, {Position = origPos}, 0.1)
                end
                
                shake(keyInputFrame, 5, 5)
                task.wait(1)
                
                keyInputStroke.Color = Color3.fromRGB(60, 60, 60)
                Tween(keyInputFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.3)
            end
        end
        return KeyModule.CheckKey(key)
    end
    
    submitButton.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local buttonPos = submitButton.AbsolutePosition
        local relativePos = UDim2.new(0, mousePos.X - buttonPos.X, 0, mousePos.Y - buttonPos.Y)
        CreateRipple(submitButton, relativePos)
        
        local key = keyInput.Text
        if key and key ~= "" then
            validateKey(key)
        else
            statusLabel.Text = "Please enter a key first!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            local shake = function(obj, intensity, times)
                local origPos = obj.Position
                for i = 1, times do
                    Tween(obj, {Position = origPos + UDim2.new(0, math.random(-intensity, intensity), 0, 0)}, 0.05)
                    task.wait(0.05)
                end
                Tween(obj, {Position = origPos}, 0.1)
            end
            
            shake(keyInputFrame, 5, 5)
        end
    end)
    
    getKeyButton.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local buttonPos = getKeyButton.AbsolutePosition
        local relativePos = UDim2.new(0, mousePos.X - buttonPos.X, 0, mousePos.Y - buttonPos.Y)
        CreateRipple(getKeyButton, relativePos)
        
        statusLabel.Text = "Generating Link..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
        
        task.wait(0.5)
        
        local keyLink = "https://ads.luarmor.net/get_key?for=Pulse_Hub_Checkpoint-TxLYDUUMfNao"
        setclipboard(keyLink)
        statusLabel.Text = "Link copied to clipboard!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "PulseHub",
            Text = "Key link has been copied to your clipboard!",
            Duration = 5
        })
    end)
    
    local particles = CreateInstance("Frame")({
        Name = "Particles",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = mainFrame,
        ClipsDescendants = true
    })
    
    local function createParticle()
        local size = math.random(2, 4)
        local particle = CreateInstance("Frame")({
            BackgroundColor3 = Color3.fromRGB(0, 170, 255),
            BackgroundTransparency = 0.8,
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(math.random(), 0, 1, 10),
            BorderSizePixel = 0,
            Parent = particles
        })
        
        local corner = CreateInstance("UICorner")({
            CornerRadius = UDim.new(1, 0),
            Parent = particle
        })
        
        local duration = math.random(5, 10)
        Tween(particle, {
            Position = UDim2.new(particle.Position.X.Scale, 0, 0, -10),
            BackgroundTransparency = 1
        }, duration)
        
        task.delay(duration, function()
            particle:Destroy()
        end)
    end
    
    task.spawn(function()
        while screenGui.Parent do
            createParticle()
            task.wait(0.5)
        end
    end)
    
    local function pulseGlow()
        while screenGui.Parent do
            Tween(logoGlow, {ImageTransparency = 0.5}, 1.2)
            Tween(profileStroke, {Thickness = 4}, 1.2)
            task.wait(1.2)
            Tween(logoGlow, {ImageTransparency = 0.7}, 1.2)
            Tween(profileStroke, {Thickness = 3}, 1.2)
            task.wait(1.2)
        end
    end
    
    task.spawn(pulseGlow)

    task.spawn(function()
        Tween(introLogo, {Size = UDim2.new(0, 150, 0, 150)}, 0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.3)
        Tween(introText, {TextSize = 32}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        
        task.wait(1.5)

        Tween(introLogo, {ImageTransparency = 1}, 0.5)
        Tween(introText, {TextTransparency = 1}, 0.5)
        Tween(introFrame, {BackgroundTransparency = 1}, 0.5)
        
        task.wait(0.5)

        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 400, 0, 0)
        Tween(mainFrame, {Size = UDim2.new(0, 400, 0, 500)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        task.wait(0.5)
        introFrame:Destroy()

        local savedKey = KeyModule.LoadSavedKey()
        if savedKey then
            keyInput.Text = savedKey
            statusLabel.Text = "Found saved key! Click Submit to validate."
            statusLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
        end
    end)
    
    return {
        ValidateKey = validateKey,
        Close = function()
            Tween(mainFrame, {Size = UDim2.new(0, 400, 0, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.5)
            screenGui:Destroy()
            for _, child in pairs(game:GetService("CoreGui"):GetChildren()) do
                if child.Name == "PulseHubKeySystem" then
                    child:Destroy()
                end
            end
        end
    }
end

local KeySystem = CreateKeySystem()

return KeySystem
