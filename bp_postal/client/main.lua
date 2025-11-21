local QBCore = exports['qb-core']:GetCoreObject()
local currentPostal = nil
local postalBlip = nil

-- Función para encontrar el código postal más cercano
local function GetClosestPostal()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestDistance = math.huge
    local closestPostal = nil
    
    for _, postal in pairs(Config.PostalCodes) do
        local distance = #(playerCoords - vector3(postal.x, postal.y, 0.0))
        if distance < closestDistance then
            closestDistance = distance
            closestPostal = postal
        end
    end
    
    return closestPostal
end

-- Función para actualizar el código postal actual
local function UpdateCurrentPostal()
    local postal = GetClosestPostal()
    if postal then
        currentPostal = postal.code
        SendNUIMessage({
            type = "updatePostal",
            postal = currentPostal
        })
    end
end

-- Función para marcar un código postal en el mapa
local function MarkPostalOnMap(postalCode)
    -- Remover blip anterior si existe
    if postalBlip then
        RemoveBlip(postalBlip)
        postalBlip = nil
    end
    
    -- Buscar el código postal
    local targetPostal = nil
    for _, postal in pairs(Config.PostalCodes) do
        if postal.code == postalCode then
            targetPostal = postal
            break
        end
    end
    
    if targetPostal then
        -- Crear blip en el mapa
        postalBlip = AddBlipForCoord(targetPostal.x, targetPostal.y, 0.0)
        SetBlipSprite(postalBlip, 1)
        SetBlipDisplay(postalBlip, 4)
        SetBlipScale(postalBlip, 0.8)
        SetBlipColour(postalBlip, 2)
        SetBlipAsShortRange(postalBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Código Postal " .. postalCode)
        EndTextCommandSetBlipName(postalBlip)
        
        -- Centrar el mapa en la ubicación
        SetNewWaypoint(targetPostal.x, targetPostal.y)
        
        QBCore.Functions.Notify("Código Postal " .. postalCode .. " marcado en el mapa", "success")
    else
        QBCore.Functions.Notify("Código postal no encontrado", "error")
    end
end

-- Comando para marcar código postal
RegisterCommand('postal', function(source, args)
    if args[1] then
        MarkPostalOnMap(args[1])
    else
        QBCore.Functions.Notify("Uso: /postal [código]", "error")
    end
end, false)

-- Actualizar código postal cada 5 segundos
CreateThread(function()
    while true do
        UpdateCurrentPostal()
        
        -- Verificar si el jugador llegó al postal marcado
        if postalBlip then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            -- Buscar el postal actualmente marcado
            for _, postal in pairs(Config.PostalCodes) do
                if postal.code == currentPostal then
                    local distance = #(playerCoords - vector3(postal.x, postal.y, 0.0))
                    if distance < 50.0 then -- Si está a menos de 50 metros
                        RemoveBlip(postalBlip)
                        postalBlip = nil
                        QBCore.Functions.Notify("Has llegado al código postal " .. currentPostal, "success")
                        break
                    end
                end
            end
        end
        
        Wait(5000)
    end
end)

-- Mostrar interfaz al iniciar
CreateThread(function()
    Wait(1000)
    SendNUIMessage({
        type = "showUI"
    })
end) 