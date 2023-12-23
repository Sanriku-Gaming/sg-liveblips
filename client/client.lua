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
      SetBlipAsShortRange(blip, blipData.shortRange)

      SetBlipColour(blip, 39)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(blipData.changeBlipText and (Config.ChangeBlipText.offDuty..' '..blipData.label) or blipData.label)
      EndTextCommandSetBlipName(blip)
      SetBlipAlpha(blip, blipData.hideOffDuty and 0 or 255)
      if Config.Debug then print('^2[Blip ('..blip..') Created]:^7 '..jobName..' | coords: '..blipData.coords..' | label: '..blipData.label..' | sprite: '..blipData.sprite..' | size: '..blipData.size..' | color: '..blipData.color..' | display: '..blipData.display..' | shortRange: '..(blipData.shortRange and 'true' or 'false')) end
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
  if Config.Debug then print('Update Blip Started', jobName, hasOnDuty) end
  if jobBlips then
    for i, blipData in pairs(jobBlips) do
      local blip = blips[jobName..'_'..i]
      local statusText = (hasOnDuty and Config.ChangeBlipText.onDuty or Config.ChangeBlipText.offDuty) .. ' ' .. blipData.label
      SetBlipColour(blip, hasOnDuty and blipData.color or 39)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(blipData.changeBlipText and statusText or blipData.label)
      EndTextCommandSetBlipName(blip)
      SetBlipAlpha(blip, blipData.hideOffDuty and (hasOnDuty and 255 or 0) or 255)
      if Config.Debug then print('Blip ['..blip..'] has been updated') end
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
  TriggerServerEvent('sg-liveblips:server:getInitialBlips')
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
  TriggerServerEvent('sg-liveblips:server:getInitialBlips')
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
    for i = 1, #blips do
      RemoveBlip(blip[i])
      if Config.Debug then print('Blip '..blip[i]..' removed.') end
    end
	end
end)