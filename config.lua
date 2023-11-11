print('^5Live Blips^7 - Easily configureable live job blip system by Nicky of ^4SG Scripts^7')
Config = Config or {}

Config.Debug = false                -- true to enable prints with helpful data in both client and server

Config.UpdateFreq = 2               -- How often (in seconds) the loop runs to update jobs if necessary (loop every 2 seconds to check for any job/duty changes). higher pop servers may need to increase.

Config.ChangeBlipText = {
  enable = false,                   -- Enable changing the blip label when on/off duty
  onDuty = '[OPEN]',                -- Text to add when players are on duty
  offDuty = '[CLOSED]',             -- Text to add when players are off duty
}

-- test blip coords are on the flightline, actual are the comments.
Config.Blips = {
  ['police'] = {
    [1] = {
      hideOffDuty = false,
      label = 'Mission Row Police Department',
      coords = vector3(-1554.07, -3017.5, 13.94), --vector3(185.0, -773.67, 30.68),
      sprite = 60,
      size = 0.65,
      color = 3,
      display = 6,
      shortRange = true,
    },
    [2] = {
      hideOffDuty = false,
      label = 'Paleto Bay Sheriff\'s Office',
      coords = vector3(-1523.46, -3035.87, 13.81), --vector3(-449.81, 6012.99, 31.716),
      sprite = 60,
      size = 0.65,
      color = 3,
      display = 6,
      shortRange = true,
    },
  },
  ['ambulance'] = {
    [1] = {
      hideOffDuty = false,
      label = 'Mt Zonah Hospital',
      coords = vector3(-1490.39, -3056.06, 13.63), --vector3(-436.0023, -326.0212, 34.9108),
      sprite = 61,
      size = 0.65,
      color = 6,
      display = 6,
      shortRange = true,
    },
    [2] = {
      hideOffDuty = false,
      label = 'Paleto Bay Clinic',
      coords = vector3(-1453.62, -3075.67, 13.57), --vector3(-251.90, 6334.19, 32.43),
      sprite = 61,
      size = 0.65,
      color = 6,
      display = 6,
      shortRange = true,
    },
    [3] = {
      label = 'Sandy Clinic',
      coords = vector3(-1420.33, -3095.54, 13.98), --vector3(1831.7538, 3681.9871, 34.2727),
      sprite = 61,
      size = 0.65,
      color = 6,
      display = 6,
      shortRange = true,
    },
  },
  ['lscustoms'] = {
    [1] = {
      hideOffDuty = true,
      label = 'Los Santos Customs',
      coords = vector3(-1382.83, -3116.87, 13.9), --vector3(-358.2362, -130.0659, 38.6988),
      sprite = 402,
      size = 0.65,
      color = 46,
      display = 6,
      shortRange = true,
    },
  },
}

---------------------------
-----    Blip Help    -----
---------------------------
-- @param hideOffDuty - boolean (true/false) - set to true to hide the blip when off duty, false to change color when off duty
-- @param label       - string - text displayed on the map
-- @param coords      - vector3 - location of blip
-- @param sprite      - integer - Sets the displayed sprite for a specific blip. List of sprites: https://docs.fivem.net/game-references/blips/
-- @param size        - float - size of blip on map. Default 0.65
-- @param color       - integer - Sets the displayed blip color for a specific blip. List of colors: https://docs.fivem.net/docs/game-references/blips/#blip-colors
-- @param display     - displayId Behaviour
--                      0 = Doesn't show up, ever, anywhere.
--                      1 = Doesn't show up, ever, anywhere.
--                      2 = Shows on both main map and minimap. (Selectable on map)
--                      3 = Shows on main map only. (Selectable on map)
--                      4 = Shows on main map only. (Selectable on map)
--                      5 = Shows on minimap only.
--                      6 = Shows on both main map and minimap. (Selectable on map)
--                      7 = Doesn't show up, ever, anywhere.
--                      8 = Shows on both main map and minimap. (Not selectable on map)
--                      9 = Shows on minimap only.
--                      10 = Shows on both main map and minimap. (Not selectable on map)
--                      Anything higher than 10 seems to be exactly the same as 10. Rockstar seem to only use 0, 2, 3, 4, 5 and 8 in the decompiled scripts.
-- @param shortRange  - boolean (true/false) - Sets whether or not the specified blip should only be displayed when nearby, or on the minimap.