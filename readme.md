# SG LiveBlips

Live updating blips for jobs based on players currently on duty.

## Features

- Blips are created for configured jobs
- Blip colors update based on players on duty
- Optimized to only send updates when duty status changes
- Server queues updates to prevent race conditions
- Fully configurable job blips

## Requirements

- [qb-core](https://github.com/qbcore-framework/qb-core)

## Installation

1. Download the latest version
2. Place `sg-liveblips` in your `resources` or `standalone` folder (remove `-main` from folder if necessary)
3. Add `ensure sg-liveblips` to your server.cfg (after all qb scripts), unless in `standalone` folder
4. Configure the blips in `config.lua` to add new jobs
5. Restart your server

See config for full setup details.

## Configuration

All blips and options are configured in `config.lua`:

- Set debug mode
- List job blips with details like coordinates, sprite, color etc.
- Set multiple blips per job if necessary

## Usage

Blips are automatically created and updated based on players with that job coming on/off duty.

No manual interaction needed!

## Credits

- Created by: [Nicky](https://forum.cfx.re/u/Sanriku)
- [SG Scripts Discord](https://discord.gg/uEDNgAwhey)