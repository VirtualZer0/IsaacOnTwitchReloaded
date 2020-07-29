# Isaac Twitch Mod Reloaded

Rewrited and improved version of old TBoI mod, [Isaac On Twitch](https://github.com/VFStudio/IsaacOnTwitch/). There are new features in this mod:

- Internal web server instead file input/output system for external data exchange
- New callbacks system. Increase performance and code quality
- File-splitting. No more 4K lines in main.lua
- External Item Description support
- Fixed game saves

## Running
As before, **run Isaac with `--luadebug` launch parameter**

## Command line

For debug, you can use next commands in Isaac command line (~):



**<u>`itmr showcallbacks`</u>** - show all active callbacks for items, trinkets and events

**<u>`itmr storage`</u>** - show current mod storage in JSON format

**<u>`itmr allpassive`</u>** - spawn all passive items from Twitch mod in current room

**<u>`itmr allactive`</u>** - spawn all active items from Twitch mod in current room

**<u>`itmr toggleshader [shadername]`</u>** - enable/disable shader from mod

**<u>`itmr setshader [shadername] [paramname] [paramvalue]`</u>** - set parameter for shader from mod

**<u>`itmr debugtextfollow [text]`</u>** - add text for every entity in room

**<u>`itmr launchevent [eventname]`</u>** - launch event by name



## File structure

- **`content`** - Contains xml-files for Isaac mod API
- **`resources`** - Contains media-sources and files for replacing

- **`scripts`** - Contains .lua files for Twitch mod
  - **`ativeItems.lua`** - List of all active items from mod
  - **`callbacks.lua`** - Main callbacks for mod, like saving game
  - **`classes.lua`** - Mod classes, like active events or subscribers
  - **`cmd.lua`** - Commands for Isaac command line
  - **`enums.lua`** - Lists of different objects, like colors or enemies
  - **`events.lua`** - Events list
  - **`passiveItems.lua`** - List of all passive items from mod
  - **`helper.lua`** - Additional functions for comfort developing
  - **`server.lua`** - Twitch mod server for receiveng/sending data
  - **`sprites.lua`** - Contains UI and etc sprites from mod
  - **`shaders.lua`** - Contains shaders params
  - **`sounds.lua`** - Contains sounds from mod
  - **`trinkets.lua`** - List of all trinkets from mod
- **`main.lua`** - Main mod script, contains root mod object

- **`metadata.xml`** - Mod config
