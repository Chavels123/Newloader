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
    [14259168147] = "803ee8b1b0de8e505559c362220eb34b",
    [18794863104] = "f94ef2b233e95b8ff359b6b089d46f48",
    [18199615050] = "f94ef2b233e95b8ff359b6b089d46f48",
    [142823291] = "8cd48d4ae8ca2c6da70cd1a3092efdc6",
    [2768379856] = "877b22f6944965a8f352ff8980d055ee",
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

        getgenv().script_key = Key

        local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
        api.script_id = module.ScriptID
        
        local success, status = pcall(function()
            return api.check_key(getgenv().script_key)
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
            task.wait(0.1)
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
