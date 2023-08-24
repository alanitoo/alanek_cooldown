local chatCooldown = {}
local cooldownTime = 5000
local discordWebhook = "https://discord.com/api/webhooks/1144220171280588860/wHrcZhOROLindZhCEkPzYSKPBptBsq4H8hvfjuMftDn_znoaWUwgcC5lYV8MzI5dDFog"

AddEventHandler("chatMessage", function(source, author, message)
    local currentTime = GetGameTimer()

    if not chatCooldown[source] or (currentTime - chatCooldown[source]) > cooldownTime then
        local playerIP = GetPlayerEP(source)
        local playerLicense = GetPlayerIdentifiers(source)[1]
        local playerSteam = GetPlayerIdentifiers(source)[2]
        local playerID = source
        chatCooldown[source] = currentTime
        SendChatToDiscord(author, message, playerIP, playerLicense, playerSteam, playerID)
    else
        CancelEvent()
        TriggerClientEvent("chatMessage", source, "^1[Cooldown] ^7Poczekaj chwilę przed napisaniem kolejnej wiadomości.")
    end
end)

function SendChatToDiscord(author, message, playerIP, playerLicense, playerSteam, playerID)
    local discordMessage = {
        {
            ["color"] = "16711680",
            ["title"] = "Ktoś napisał coś na chacie",
            ["description"] = "Autor: " .. author .. "\nWiadomość: " .. message .. "\nAdres IP: " .. playerIP ..
                             "\nLicense: " .. playerLicense .. "\nSteam: " .. playerSteam .. "\nID Gracza: " .. playerID,
            ["footer"] = {
                ["text"] = "by.alanek"
            }
        }
    }

    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode({username = "Chat Logger", embeds = discordMessage}), {['Content-Type'] = 'application/json'})
end