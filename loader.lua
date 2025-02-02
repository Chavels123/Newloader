local module = {
    MainWindow = nil,
    Notify = nil
}

local GameIDs = {    
    [6348640020] = "fa4e49b11535d5a034b51e9bfd716abf",
    [6137321701] = "fa4e49b11535d5a034b51e9bfd716abf",
    [8260276694] = "963cec62def32b2419a935d99b45f1cc",
    [4623386862] = "6e17bb33ce19a54874ef18805c1c4dad",
    [1962086868] = "9abaceaa22f3631d6dd3a9c9420cf349",
}

local function GetScriptID()
    return GameIDs[game.PlaceId]
end

local function HandleNotification(title, message, duration)
    if module.Notify then
        module.Notify({
            Title = title,
            Content = message,
            Duration = duration or 5
        })
    end
end

local function LoadScript(api)
    if module.MainWindow then
        module.MainWindow:Destroy()
    end
    api.load_script()
end

module.Functions = {}

function module.Functions.CheckKey(key)
    if not key or type(key) ~= "string" then
        HandleNotification("Error", "Invalid key format", 5)
        return
    end

    local success, api = pcall(function()
        return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
    end)

    if not success then
        HandleNotification("Error", "Failed to load authentication system", 5)
        return
    end

    api.script_id = GetScriptID()
    
    local status = api.check_key(key)
    
    if status.code == "KEY_VALID" then
        HandleNotification("Success", status.message, 5)
        LoadScript(api)
    else
        HandleNotification("Error", status.message, 5)
    end
end

return module 
