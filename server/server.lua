local QBCore = exports['qb-core']:GetCoreObject()
QBCore.Functions.CreateCallback("lv-seller:server:sellItem", function(source, cb, itemName, qtyY, shopType)
    if Config.Items[shopType].unlimited then
        cb(-1,true,"Başarıyla satıldı!","success")
    else
        local Player = QBCore.Functions.GetPlayer(source)
        local date = os.date("%Y-%m-%d")
        local citizenId = Player.PlayerData.citizenid 
        local result = MySQL.Sync.fetchAll("SELECT * FROM toptanci WHERE citizenid = ? AND itemName = ? AND date = ?  LIMIT 1", {citizenId, itemName, date})
        local logic = (result ~= nil and result[1] ~= nil)
        local playerCount = Player.Functions.GetItemByName(itemName).amount
        local qty = tonumber(qtyY)
        if playerCount >= qty then
            if logic == true then
                local limit = result[1].dailyEarnings - (Config.Items[shopType][itemName].value*qty)                
                if limit >= 0 then
                    MySQL.Sync.fetchAll("UPDATE toptanci SET dailyEarnings =  ? WHERE id = ?", {limit, result[1].id})
                    Player.Functions.AddMoney("cash", (Config.Items[shopType][itemName].value*qty))
                    cb(limit,true,"Kalan Satış Hakkı "..limit.."$", "success")
                else
                    cb(0,false,"Satış hakkınız bulunmamakta, lütfen başka bir zaman deneyin.","error")
                end
            else
                local limit = Config.Items[shopType].dailyEarnings - (Config.Items[shopType][itemName].value*qty)
                if limit >= 0 then
                    MySQL.Async.insert('INSERT INTO toptanci (citizenid, itemName, dailyEarnings) VALUES (:citizenid, :itemName, :dailyEarnings)', {
                    ['citizenid'] = citizenId,
                    ['itemName'] = itemName,
                    ['dailyEarnings'] = limit
                    })
                    Player.Functions.AddMoney("cash", (Config.Items[shopType][itemName].value*qty))
                    cb(limit,true,"Kalan Satış Hakkı "..limit.."$", "success")                 
                else                    
                    cb(limit,false,"Satmak istediğiniz miktar çok fazla!","error")  
                end
            end
        else
            cb(limit,false,"Satmak istediğiniz miktar çok fazla!","error")
        end
        
    end
    
end)