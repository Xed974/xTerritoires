allZone = {}
local function zoneExist(name, label)
    if #allZone > 0 then
        for _,v in pairs(allZone) do
            if name == v.name then
                return true
            end
        end
    else
        MySQL.Async.fetchAll("SELECT * FROM territoires", {}, function(result)
            for _,v in pairs(result) do
                table.insert(allZone, { name = v.zone, label = v.label, owner = v.owner, data = v.data })
            end
        end)
        Wait(100)
        for _,v in pairs(allZone) do
            if name == v.name then
                return true
            end
        end
    end
    table.insert(allZone, { name = name, label = label, owner = nil, data = {} }) 
    MySQL.Async.execute("INSERT INTO territoires (zone, label) VALUES (@zone, @label)", {
        ["@zone"] = name,
        ["@label"] = label
    })
    return true
end

local function getDataFromZone(name)
    for _,v in pairs(allZone) do
        if v.name == name then
            return v.data
        end
    end
    return nil
end

function updateDataZone(xPlayer, zoneName, zoneLabel, count)
    if (not xPlayer) then return end
    if xPlayer.getJob2().name == "unemployed" then return end
    if zoneExist(zoneName, zoneLabel) then
        local data = getDataFromZone(zoneName)
        if data ~= nil then
            for _,v in pairs(data) do
                if v.job == xPlayer.getJob2().name then
                    v.count = v.count + count
                    MySQL.Async.execute("UPDATE territoires SET data = @data WHERE zone = @zone", {
                        ["@data"] = json.encode(data),
                        ["@zone"] = zoneName
                    })
                    return
                end
            end
        end
        table.insert(data, { job = xPlayer.getJob2().name, count = count } )
        MySQL.Async.execute("UPDATE territoires SET data = @data WHERE zone = @zone", {
            ["@data"] = json.encode(data),
            ["@zone"] = zoneName
        })
    end
end

CreateThread(function()
    while true do
        Wait(cfg.refreshOwnerZone)
        local owner, pts = nil, 0
        MySQL.Async.fetchAll("SELECT * FROM territoires", {}, function(result)
            for a,b in pairs(result) do
                if #b.data > 0 then
                    for _,v in pairs(json.decode(b.data)) do
                        if v.count > pts then
                            owner = v.job
                        end
                    end
                    b.owner = owner
                    MySQL.Async.execute("UPDATE territoires SET owner = @owner WHERE zone = @zone", {
                        ["@zone"] = b.zone,
                        ["@owner"] = owner
                    })
                end
            end
        end)
    end
end)