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

module.ScriptID = GameIDs[game.PlaceId] or "baf0792f6cce01ba2040d6bf52996eb8"

module.Functions = {
    CheckKey = function(Key)
        if not Key or Key == "" then
            if module.Notify then
                module.Notify({
                    Title = "Error",
                    Content = "Please enter a key",
                    Duration = 5
                })
            end
            return
        end

        local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
        api.script_id = module.ScriptID
        getgenv().script_key = Key
        
        local success, status = pcall(function()
            return api.check_key(Key)
        end)
        
        if not success then
            if module.Notify then
                module.Notify({
                    Title = "Error",
                    Content = "Failed to validate key",
                    Duration = 5
                })
            end
            return
        end
        
        if status.code == "KEY_VALID" then
            if module.Notify then
                module.Notify({
                    Title = "Success",
                    Content = status.message,
                    Duration = 5
                })
            end
            pcall(function()
                api.load_script()
            end)
            if module.MainWindow then
                module.MainWindow:Destroy()
            end
            return
        else
            if module.Notify then
                module.Notify({
                    Title = "Error",
                    Content = status.message,
                    Duration = 5
                })
            end
            return
        end
    end
}

return module
