local eventbypass

eventbypass = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() and self.Name == "AnalyticsReportEvent" and method == "FireServer" then
        print("Anti Cheat remote was called and blocked.")
        return; 
    end

    return eventbypass(self, ...)
end)


