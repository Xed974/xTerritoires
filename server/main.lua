local function getCops()
    local xPlayers, copsConnected = ESX.GetPlayers(), 0

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        for _,v in pairs(cfg.JobPolice) do
            if (xPlayer.getJob().name) == v then
                copsConnected = copsConnected + 1
            end
        end
    end
    return copsConnected
end

ESX.RegisterServerCallback('xTerritoires:getCops', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    cb(getCops() >= cfg.PoliceRequis)
end)

RegisterNetEvent("xTerritoires:poucave")
AddEventHandler("xTerritoires:poucave", function(zoneLabel)
    local xPlayers = ESX.GetPlayers()

    for _,v in pairs(allZone) do
        if zoneLabel == v.label then
            for i = 1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer.getJob2().name == v.owner then
                    TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Citoyen", "Discussion", cfg.messagePoucave[math.random(#cfg.messagePoucave)], "CHAR_ARTHUR", 1)
                end
            end
        end
    end
end)

ESX.RegisterServerCallback("xTerritoires:getDrug", function(source, cb, drug, zoneName, zoneLabel)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    local count, percentage = math.random(drug.countMin, drug.countMax), 1
    if (xPlayer.getInventoryItem(drug.Name).count) >= count then
        cb(true)
        MySQL.Async.fetchAll("SELECT owner FROM territoires WHERE zone = ?", { zoneName }, function(result)
            for _,v in pairs(result) do
                if v.owner == xPlayer.getJob2().name then
                    percentage = cfg.percentageAdd
                end
            end
        end)
        Wait(100)
        xPlayer.removeInventoryItem(drug.Name, count)
        xPlayer.addAccountMoney('black_money', (count * math.random(drug.MinPrice, drug.MaxPrice)) * percentage)
        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Citoyen", "Discussion", cfg.messageAccept[math.random(#cfg.messageAccept)], "CHAR_ARTHUR", 1)
        updateDataZone(xPlayer, zoneName, zoneLabel, count)
        if math.random(1, cfg.randomPoucave) == 1 then TriggerEvent("xTerritoires:poucave", zoneLabel) end
    else
        cb(false)
        TriggerClientEvent('esx:showNotification', xPlayer.source, ('Vous avez pas assez de ~r~%s~s~ sur vous.'):format(drug.Label))
    end
end)

RegisterNetEvent('xTerritoires:Call')
AddEventHandler('xTerritoires:Call', function(pPos)
	local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        for _,v in pairs(cfg.JobPolice) do
            if (xPlayer.getJob().name) == v then
                TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'LSPD CENTRALE', '~g~Appel d\'un citoyen', '~g~Citoyen:~s~ Une personne a tenté de me vendre de la drogue !', 'CHAR_CHAT_CALL', 1)
                TriggerClientEvent('xTerritoires:blips', xPlayers[i], pPos)
            end
        end
    end
end)