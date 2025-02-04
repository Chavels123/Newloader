local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local GUI = Instance.new("ScreenGui")
GUI.Name = HttpService:GenerateGUID(false)
GUI.Parent = CoreGui
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = GUI
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0, 300, 0, 350)
Main.ClipsDescendants = true

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
})
UIGradient.Rotation = 45
UIGradient.Parent = Main

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Main

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = Main
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 47, 1, 47)
Shadow.ZIndex = 0
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.Size = UDim2.new(1, 0, 0, 30)

local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 8)
UICorner_2.Parent = TopBar

local Extension = Instance.new("Frame")
Extension.Name = "Extension"
Extension.Parent = TopBar
Extension.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Extension.BorderSizePixel = 0
Extension.Position = UDim2.new(0, 0, 0.5, 0)
Extension.Size = UDim2.new(1, 0, 0.5, 0)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(1, -24, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "PulseHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Parent = TopBar
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.Size = UDim2.new(0, 25, 1, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.TextSize = 20

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Parent = Main
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0.5, -50, 0, 50)
Logo.Size = UDim2.new(0, 100, 0, 100)
Logo.Image = Players.LocalPlayer.CharacterAppearanceId and "rbxthumb://type=AvatarHeadShot&id=" .. Players.LocalPlayer.UserId .. "&w=150&h=150" or "rbxasset://textures/ui/GuiImagePlaceholder.png"
Logo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = Logo

local KeyInput = Instance.new("TextBox")
KeyInput.Name = "KeyInput"
KeyInput.Parent = Main
KeyInput.AnchorPoint = Vector2.new(0.5, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyInput.Position = UDim2.new(0.5, 0, 0, 170)
KeyInput.Size = UDim2.new(0.85, 0, 0, 40)
KeyInput.Font = Enum.Font.GothamSemibold
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
KeyInput.ClearTextOnFocus = false

local UICorner_3 = Instance.new("UICorner")
UICorner_3.CornerRadius = UDim.new(0, 6)
UICorner_3.Parent = KeyInput

local UIGradient_2 = Instance.new("UIGradient")
UIGradient_2.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
})
UIGradient_2.Rotation = 45
UIGradient_2.Parent = KeyInput

local SubmitKey = Instance.new("TextButton")
SubmitKey.Name = "SubmitKey"
SubmitKey.Parent = Main
SubmitKey.AnchorPoint = Vector2.new(0.5, 0)
SubmitKey.BackgroundColor3 = Color3.fromRGB(0, 72, 255)
SubmitKey.Position = UDim2.new(0.5, 0, 0, 230)
SubmitKey.Size = UDim2.new(0.85, 0, 0, 40)
SubmitKey.Font = Enum.Font.GothamBold
SubmitKey.Text = "Submit Key"
SubmitKey.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitKey.TextSize = 14
SubmitKey.AutoButtonColor = false

local UICorner_4 = Instance.new("UICorner")
UICorner_4.CornerRadius = UDim.new(0, 6)
UICorner_4.Parent = SubmitKey

local UIGradient_3 = Instance.new("UIGradient")
UIGradient_3.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 72, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 102, 255))
})
UIGradient_3.Rotation = 45
UIGradient_3.Parent = SubmitKey

local GetKey = Instance.new("TextButton")
GetKey.Name = "GetKey"
GetKey.Parent = Main
GetKey.AnchorPoint = Vector2.new(0.5, 0)
GetKey.BackgroundTransparency = 1
GetKey.Position = UDim2.new(0.5, 0, 0, 290)
GetKey.Size = UDim2.new(0.85, 0, 0, 20)
GetKey.Font = Enum.Font.GothamBold
GetKey.Text = "Get Key"
GetKey.TextColor3 = Color3.fromRGB(150, 150, 150)
GetKey.TextSize = 14
GetKey.AutoButtonColor = false

local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/Chavels123/Newloader/refs/heads/main/OldLoadersKeySystemLoaders"))()
KeySystem.MainWindow = GUI
KeySystem.Notify = function(options)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = options.Title,
        Text = options.Content,
        Duration = options.Duration
    })
end

local function CheckKey(key)
    KeySystem.Functions.CheckKey(key)
end

local function AddHoverEffect(button, colorStart, colorEnd)
    if button == GetKey then
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                TextColor3 = Color3.fromRGB(150, 150, 150)
            }):Play()
        end)
    else
        local gradient = button:FindFirstChild("UIGradient")
        
        button.MouseEnter:Connect(function()
            TweenService:Create(gradient, TweenInfo.new(0.2), {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, colorStart:Lerp(Color3.fromRGB(255, 255, 255), 0.1)),
                    ColorSequenceKeypoint.new(1, colorEnd:Lerp(Color3.fromRGB(255, 255, 255), 0.1))
                })
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(gradient, TweenInfo.new(0.2), {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, colorStart),
                    ColorSequenceKeypoint.new(1, colorEnd)
                })
            }):Play()
        end)
    end
end

AddHoverEffect(SubmitKey, Color3.fromRGB(0, 72, 255), Color3.fromRGB(0, 102, 255))
AddHoverEffect(GetKey)

local function AddButtonHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        }):Play()
    end)
end

AddButtonHoverEffect(GetKey)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    GUI:Destroy()
end)

SubmitKey.MouseButton1Click:Connect(function()
    TweenService:Create(SubmitKey, TweenInfo.new(0.1), {Size = UDim2.new(0.83, 0, 0, 38)}):Play()
    wait(0.1)
    TweenService:Create(SubmitKey, TweenInfo.new(0.1), {Size = UDim2.new(0.85, 0, 0, 40)}):Play()
    CheckKey(KeyInput.Text)
end)

GetKey.MouseButton1Click:Connect(function()
    setclipboard("https://ads.luarmor.net/get_key?for=Pulse_Hub_Checkpoint-EZwqJKYLjCoC")
    KeySystem.Notify({
        Title = "Link Copied",
        Content = "Key system link copied to clipboard",
        Duration = 5
    })
end)

local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    local goal = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(Main, TweenInfo.new(0.1), {Position = goal}):Play()
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

Main.Position = UDim2.new(0.5, 0, 0.5, -50)
TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
