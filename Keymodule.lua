local module = {
    MainWindow = nil,
    Notify = nil
}

local GameIDs = {    
    [14350413280] = "dd624dce3675715d34af679cdc1f6860",
    [8884433153] = "2f3e1443b79ad9ca4c483dcf537d4288",
    [122220249529691] = "10934afa53546c3bbb7e6f8dd76cee72",
    [16981421605] = "d8915bbb7d1b33a9a95deb956eeb5f2c"
}

module.ScriptID = GameIDs[game.PlaceId]

module.Functions = {
    CheckKey = function(Key)
        local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
        
        api.script_id = module.ScriptID
        
        local status = api.check_key(Key)
        
        if status.code == "KEY_VALID" then
            if module.Notify then
                module.Notify({
                    Title = "Success",
                    Content = status.message,
                    Duration = 5
                })
            end
            
            api.load_script()
            
            if module.MainWindow then
                module.MainWindow:Destroy()
            end
            
            script:Destroy()
            return
        end
        
        if module.Notify then
            module.Notify({
                Title = "Error",
                Content = status.message,
                Duration = 5
            })
        end
        return
    end
}

return module 
