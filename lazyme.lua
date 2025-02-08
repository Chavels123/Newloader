local module = {
    MainWindow = nil,
    Notify = nil
}

-- Add TweenService
local TweenService = game:GetService("TweenService")

local GameIDs = {    
    ["Universal"] = "f54d1815663e1da8e35b596b3f7a190e"
}

module.ScriptID = GameIDs["Universal"]

-- Status types for notifications
local STATUS_TYPES = {
    ERROR = "Error",
    SUCCESS = "Success",
    WARNING = "Warning",
    INFO = "Info"
}

local function PlayClosingAnimation(callback)
    if not module.MainWindow then return end

    local Main = module.MainWindow:FindFirstChild("Main")
    if not Main then return end

    local mainFadeOut = TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 0.5, -50),
        Size = UDim2.new(0, 320, 0, 0),
        BackgroundTransparency = 1
    })

    for _, child in ipairs(Main:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
            TweenService:Create(child, TweenInfo.new(0.3), {
                TextTransparency = 1
            }):Play()
        elseif child:IsA("ImageLabel") or child:IsA("ImageButton") then
            TweenService:Create(child, TweenInfo.new(0.3), {
                ImageTransparency = 1
            }):Play()
        elseif child:IsA("Frame") and child.BackgroundTransparency < 1 then
            TweenService:Create(child, TweenInfo.new(0.3), {
                BackgroundTransparency = 1
            }):Play()
        end
    end
    
    mainFadeOut:Play()

    task.delay(0.5, function()
        module.MainWindow:Destroy()
        if callback then callback() end
    end)
end

local function SendNotification(title, content, duration, notifyType)
    if module.Notify then
        module.Notify({
            Title = title,
            Content = content,
            Duration = duration or 5,
            Type = notifyType or STATUS_TYPES.INFO
        })
    end
end

module.Functions = {
    CheckKey = function(Key)
        -- Validate key input
        if not Key or Key == "" then
            if module.Notify then
                module.Notify({
                    Title = "Error",
                    Content = "Please enter a key",
                    Duration = 5,
                    Type = "Error"
                })
            end
            return false
        end

        -- Set global key
        getgenv().script_key = Key

        -- Load API
        local api
        local success, result = pcall(function()
            return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
        end)

        if not success then
            if module.Notify then
                module.Notify({
                    Title = "Error",
                    Content = "Failed to load API: " .. tostring(result),
                    Duration = 5,
                    Type = "Error"
                })
            end
            return false
        end
        
        api = result
        api.script_id = module.ScriptID
        
        -- Check key validity
        local keySuccess, keyResult = pcall(function()
            return api.check_key(getgenv().script_key)
        end)
        
        if not keySuccess then
            if module.Notify then
                module.Notify({
                    Title = "Error",
                    Content = "Failed to validate key: " .. tostring(keyResult),
                    Duration = 5,
                    Type = "Error"
                })
            end
            return false
        end
        
        local status = keyResult
        
        -- Handle key status
        if status and status.code == "KEY_VALID" then
            if module.Notify then
                module.Notify({
                    Title = "Success",
                    Content = status.message,
                    Duration = 5,
                    Type = "Success"
                })
            end
            
            -- Wait a bit before animation
            task.wait(0.1)

            -- Play closing animation and then load script
            if module.MainWindow then
                PlayClosingAnimation(function()
                    -- Load script only once, after animation completes
                    local loadSuccess, loadError = pcall(function()
                        api.load_script()
                    end)

                    if not loadSuccess and module.Notify then
                        module.Notify({
                            Title = "Error",
                            Content = "Failed to load script: " .. tostring(loadError),
                            Duration = 5,
                            Type = "Error"
                        })
                    end
                end)
            end
            
            return true
        else
            -- Handle invalid key
            if module.Notify then
                module.Notify({
                    Title = "Error",
                    Content = status and status.message or "Invalid key response",
                    Duration = 5,
                    Type = "Error"
                })
            end
            return false
        end
    end,

    -- Add function to validate key format (optional)
    ValidateKeyFormat = function(key)
        if not key or type(key) ~= "string" then
            return false
        end
        
        -- Example: Check if key matches expected pattern
        -- Modify this pattern according to your key format
        local keyPattern = "^[A-Za-z0-9%-_]+$"
        return string.match(key, keyPattern) ~= nil
    end
}

return module
