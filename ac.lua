-- Anti-Cheat Remote Blocker
-- Hook __namecall to intercept specific remote events

local eventbypass

eventbypass = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = { ... }

    -- Check if the call is from the game environment and not from our script
    if not checkcaller() then
        local remoteName = self.Name
        local className = self.ClassName

        -- Targeting the "AnalyticsReportEvent" RemoteEvent specifically
        if remoteName == "AnalyticsReportEvent" and method == "FireServer" then
            warn("[Bypass] Blocked attempt to fire remote:", remoteName)
            -- Optionally log more details about the attempted call
            -- print("Arguments:", unpack(args))
            return
        end
    end

    -- Call the original __namecall method
    return eventbypass(self, ...)
end)
