local QBCore = exports['qb-core']:GetCoreObject()
local openedUI 

local ui = false
RegisterNetEvent('lv-seller:client:openUI', function()
    openUI("ILLEGAL")
end)

RegisterNetEvent('lv-seller:client:openUIOdun', function()
    openUI("ODUN")
end)

RegisterNetEvent('lv-seller:client:openUIBalik', function()
    openUI("BALIK")
end)

RegisterNUICallback("buyItem", function(data,cb)
    if QBCore.Functions.HasItem(data.itemName) then
        QBCore.Functions.TriggerCallback("lv-seller:server:sellItem", function(limit,success,msg,type)
            if success then
                QBCore.Functions.Notify(msg, type) 
                TriggerServerEvent("QBCore:Server:RemoveItem", data.itemName, data.qty)
                TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[data.itemName], "remove",data.qty)
            else
                QBCore.Functions.Notify(msg, type)
            end
            cb(limit)
        end, data.itemName,data.qty, data.shopType)
    else
        QBCore.Functions.Notify("Bu eşya sizde bulunmuyor.", "error")
    end
end)

RegisterNUICallback("getItems", function(data,cb)
    cb(Config.Items[data])
end)

RegisterNUICallback("closeUI", function(data,cb)
    closeUI()
end)

function openUI(itemsType)
    if ui then
        ui = false
    else
        ui = true
    end
    SetNuiFocusKeepInput(false)
    SetNuiFocus(ui,ui)
    SendNUIMessage({
        type = "ui",
        status = ui,
        itemsType = itemsType
    })
end

function closeUI()
	SetNuiFocusKeepInput(false)
    SetNuiFocus(false,false)
    SendNUIMessage({
        type = "ui",
        status = false,
    })
    ui = false
end
