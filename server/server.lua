local QBCore = exports['qb-core']:GetCoreObject()

---------------------------
-----    Variables    -----
---------------------------
local jobOnDuty = {}
local jobs = {}
local queuedJobs = {}
local pendingUpdates = false

---------------------------
-----    Functions    -----
---------------------------
function jobUpdateQueue(jobName)
  -- Check if already queued
  if queuedJobs[jobName] then
    return
  end
  queuedJobs[jobName] = true
  pendingUpdates = true
end

function updateAllJobBlips()
  if Config.Debug then print('updateAllJobBlips Started') end

  for jobName, _ in pairs(jobOnDuty) do
    if Config.Debug then print('Job Name: ', jobName) end
    local hasOnDuty = false
    local players = QBCore.Functions.GetQBPlayers()
    for _, player in pairs(players) do
      if Config.Debug then print('Player: ', player.PlayerData.source) end
      if player.PlayerData.job.name == jobName and player.PlayerData.job.onduty then
        hasOnDuty = true
        break
      end
    end
    
    if Config.Debug then print('Job: ', jobName, 'Current: ', jobOnDuty[jobName], 'Status: ', hasOnDuty) end
    if hasOnDuty ~= jobOnDuty[jobName] then
      TriggerClientEvent('sg-liveblips:client:updateBlip', -1, jobName, hasOnDuty)
      if Config.Debug then print('sg-liveblips:client:updateBlip Triggered') end
    end
    jobOnDuty[jobName] = hasOnDuty
  end
end

function updateJobBlip(jobName)
  if Config.Debug then print('updateJobBlip Started') end
  -- check if this is a job on the jobs table (Config.Blips[jobName])
  if not jobs[jobName] then return end
  -- search for any onDuty player with jobName
  local hasOnDuty = false
  for _, player in pairs(QBCore.Functions.GetQBPlayers()) do
    if player.PlayerData.job.name == jobName and player.PlayerData.job.onduty then
      hasOnDuty = true
      break
    end
  end
  -- if status changed, update blips
  if Config.Debug then print('Job: ', jobName, 'Current: ', jobOnDuty[jobName], 'Status: ', hasOnDuty) end
  if jobOnDuty[jobName] == hasOnDuty then return end
  TriggerClientEvent('sg-liveblips:client:updateBlip', -1, jobName, hasOnDuty)
  jobOnDuty[jobName] = hasOnDuty
end

---------------------------
-----     Threads     -----
---------------------------
-- Create thread to process queue
CreateThread(function()
  while true do
    Wait(Config.UpdateFreq * 1000)
    if pendingUpdates then
      if queuedJobs['FULL_UPDATE'] then
        updateAllJobBlips()
        queuedJobs['FULL_UPDATE'] = false
        if Config.Debug then print('All Blips Updated and queuedJobs[\'FULL_UPDATE\'] = false ') end
      else
        for job, _ in pairs(queuedJobs) do
          updateJobBlip(job)
          queuedJobs[job] = false
        end
        if Config.Debug then print('Job Blips Updated and queuedJobs[\'job\'] = false') end
      end
      pendingUpdates = false
    end
  end
end)

---------------------------
-----     Events      -----
---------------------------
RegisterNetEvent('sg-liveblips:server:updateBlips', function()
  if Config.Debug then print('Update Blips Triggered') end
  -- Queue full update
  jobUpdateQueue('FULL_UPDATE')
end)

--------------------------
--     Core Events      --
--     DO NOT TOUCH     --
--------------------------
-- Handle duty change
RegisterNetEvent('QBCore:ToggleDuty', function()
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  if not Player then return end
  local job = Player.PlayerData.job.name
  if Config.Debug then print('ToggleDuty:'..job, Player.PlayerData.job.onduty) end
  jobUpdateQueue(job)
end)

-- Build local tables on start
AddEventHandler('onResourceStart', function(resource)
	if resource ~= GetCurrentResourceName() then return end
  for jobName,_ in pairs(Config.Blips) do
    if not QBCore.Shared.Jobs[jobName] then print('^1[ERROR]^0 - job ('..jobName..') not found on QBShared.Jobs') return end
    if not jobOnDuty[jobName] then
      jobOnDuty[jobName] = false
    end
    if not jobs[jobName] then
      jobs[jobName] = jobName
    end
    if not queuedJobs[jobName] then
      queuedJobs[jobName] = false
    end
  end
  queuedJobs['FULL_UPDATE'] = false
end)