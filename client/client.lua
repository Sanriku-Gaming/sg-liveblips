local QBCore = exports['qb-core']:GetCoreObject()

---------------------------
-----    Variables    -----
---------------------------
local blipsLoaded = false
local blips = {}

---------------------------
-----     Threads     -----
---------------------------
CreateThread(function()
  for jobName, jobBlips in pairs(Config.Blips) do
    for i, blipData in pairs(jobBlips) do

      local blip = AddBlipForCoord(blipData.coords)
      SetBlipSprite(blip, blipData.sprite)
      SetBlipDisplay(blip, blipData.display)
      SetBlipScale(blip, blipData.size)
      SetBlipColour(blip, 39)
      SetBlipAsShortRange(blip, blipData.shortRange)
      
      if Config.ChangeBlipText.enable then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.ChangeBlipText.offDuty..' '..blipData.label)
        EndTextCommandSetBlipName(blip)
      else
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipData.label)
        EndTextCommandSetBlipName(blip)
      end

      if Config.Debug then print('^2[Blip Created]:^7 '..jobName..' | coords: '..blipData.coords..' | label: '..blipData.label..' | sprite: '..blipData.sprite..' | size: '..blipData.size..' | color: '..blipData.color..' | display: '..blipData.display..' | shortRange: '..(blipData.shortRange and 'true' or 'false')) end
      blips[jobName.."_"..i] = blip
    end
  end
  blipsLoaded = true
  if Config.Debug then print('All Blips Created') end
end)

---------------------------
-----     Events      -----
---------------------------
RegisterNetEvent('sg-liveblips:client:updateBlip', function(jobName, hasOnDuty)
  local jobBlips = Config.Blips[jobName]
  if jobBlips then
    for i, blipData in pairs(jobBlips) do
      local blip = blips[jobName..'_'..i]
      if hasOnDuty then
        SetBlipColour(blip, blipData.color)
        if Config.ChangeBlipText.enable then
          BeginTextCommandSetBlipName("STRING")
          AddTextComponentString(Config.ChangeBlipText.onDuty..' '..blipData.label)
          EndTextCommandSetBlipName(blip)
        end
      else
        SetBlipColour(blip, 39)
        if Config.ChangeBlipText.enable then
          BeginTextCommandSetBlipName("STRING")
          AddTextComponentString(Config.ChangeBlipText.offDuty..' '..blipData.label)
          EndTextCommandSetBlipName(blip)
        end
      end
    end
  end
end)

--------------------------
--     Core Events      --
--     DO NOT TOUCH     --
--------------------------
RegisterNetEvent('QBCore:Client:OnJobUpdate', function()
  if Config.Debug then print('Job Updated') end
  TriggerServerEvent('sg-liveblips:server:updateBlips')
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
  local ped = PlayerPedId()
  local id = GetPlayerServerId(ped)
  local loadingTime = 0
  while not blipsLoaded do
    Wait(1000)
    loadingTime += 1
    if loadingTime >= 90 then
      print('Blip Loading Timed Out - Player: '..id)
      return
    end
  end
  TriggerServerEvent('sg-liveblips:server:updateBlips')
end)

AddEventHandler('onResourceStart', function(resource)
	if resource ~= GetCurrentResourceName() then return end
  local ped = PlayerPedId()
  local id = GetPlayerServerId(ped)
  local loadingTime = 0
  while not blipsLoaded do
    Wait(1000)
    loadingTime += 1
    if loadingTime >= 90 then
      print('Blip Loading Timed Out - Player: '..id)
      return
    end
  end
  TriggerServerEvent('sg-liveblips:server:updateBlips')
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
    for i = 1, #blips do
      if DoesBlipExist(blips[i]) then
        RemoveBlip(blip[i])
        if Config.Debug then print('Blip '..blip[i]..' removed.') end
      end
    end
	end
end)