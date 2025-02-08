local module = {
    MainWindow = nil,
    Notify = nil
}

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
            
            -- Load script with error handling
            task.wait(0.1)
            local loadSuccess, loadError = pcall(function()
                api.load_script()
            end)

            if not loadSuccess then
                if module.Notify then
                    module.Notify({
                        Title = "Error",
                        Content = "Failed to load script: " .. tostring(loadError),
                        Duration = 5,
                        Type = "Error"
                    })
                end
                return false
            end

            -- Clean up UI
            if module.MainWindow then
                local destroySuccess, destroyError = pcall(function()
                    module.MainWindow:Destroy()
                end)
                
                if not destroySuccess then
                    warn("Failed to destroy UI:", destroyError)
                end
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
