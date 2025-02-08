local module = {
    MainWindow = nil,
    Notify = nil
}

local GameIDs = {    
    ["Universal"] = "f54d1815663e1da8e35b596b3f7a190e"
}

module.ScriptID = GameIDs["Universal"]

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
        if not Key or Key == "" then
            SendNotification(
                STATUS_TYPES.ERROR,
                "Please enter a key",
                5,
                STATUS_TYPES.ERROR
            )
            return false
        end

        getgenv().script_key = Key

        local api, apiLoadSuccess = pcall(function()
            return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
        end)

        if not apiLoadSuccess then
            SendNotification(
                STATUS_TYPES.ERROR,
                "Failed to load API",
                5,
                STATUS_TYPES.ERROR
            )
            return false
        end

        api.script_id = module.ScriptID

        local success, status = pcall(function()
            return api.check_key(getgenv().script_key)
        end)
        
        if not success then
            SendNotification(
                STATUS_TYPES.ERROR,
                "Failed to validate key: Network error",
                5,
                STATUS_TYPES.ERROR
            )
            return false
        end
        
        -- Handle key status
        if status.code == "KEY_VALID" then
            SendNotification(
                STATUS_TYPES.SUCCESS,
                status.message,
                5,
                STATUS_TYPES.SUCCESS
            )

            task.wait(0.1)
            local loadSuccess, loadError = pcall(function()
                api.load_script()
            end)

            if not loadSuccess then
                SendNotification(
                    STATUS_TYPES.ERROR,
                    "Failed to load script: " .. tostring(loadError),
                    5,
                    STATUS_TYPES.ERROR
                )
                return false
            end

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
            SendNotification(
                STATUS_TYPES.ERROR,
                status.message,
                5,
                STATUS_TYPES.ERROR
            )
            return false
        end
    end,

    ValidateKeyFormat = function(key)
        if not key or type(key) ~= "string" then
            return false
        end

        local keyPattern = "^[A-Za-z0-9%-_]+$"
        return string.match(key, keyPattern) ~= nil
    end
}

return module
