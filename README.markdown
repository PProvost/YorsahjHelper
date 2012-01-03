YorsahjHelper
=============

Important!!
-----------

This addon is not currently usable. For testing purposes it currently dumps all of the output
messages to a tekDebug frame (or into the bit bucket if you don't have tekDebug). The basic 
structure is there and the events are firing correctly, but I've not finished it yet.

Description
-----------

YorsahjHelper is a simple addon for World of Warcraft to help groups kill the correct set of globules
(adds) in the Yor'sahj the Unsleeping encounter in the Dragon Soul raid instance.

**NOTE:** This addon only works for the Normal mode encounter. Heroic mode spawns for adds and uses
a compeltely different priority system that is not supported.

The default configuration uses the following kill priority: Purple > Green > Yellow

When the boss spawns the adds, the highest priority kill target is announced as a Raid 
Warning and information messages are sent to the Raid channel to help the raid cope with the adds left
alive.

Configuration
-------------

The addon comes with no in-game configuration, so if you want to change something you will need to edit
the YorsahjHelper.lua file.

All configuration parameters are at the top of the file. The defaults are shown here:

    -- The kill priority you want
    local killPriority = { "PURPLE", "GREEN", "YELLOW" }
    
    -- Set this to false if you don't want the raid warning about the kill target
    local emphasizeKill = true
    
    -- Set this to false if you don't want the informational messages
    local useInformationalMessages = true
    
    -- Where the messages are delivered.
    -- Other possible values: RAID, RAID_WARNING, PARTY, SAY, YELL
    local informationalChannel = "RAID"
    local emphasizeChannel = "RAID_WARNING"

There is also a table in the config section that maps the boss's spell ID to the adds which are spawned but
that should not require modification.

Todo List
---------

* Support for Heroic (4 adds instead of 3)
* In-game configurable priority list.
* Different priority lists for LFR, Normal and Heroic
* Smart-disable messages if the raid leader has it
* Only send message if Raid Leader or Assistant
* If in LFR, ask whether to enable or not
* Only trap spellcast events when in Yorsahj's sub-zone

Credits
-------

* Spell IDs from Yorsahj Automatic Raidwarnings by Tom and Gints
* Thanks to my guild for putting up with me working out some of the bugs
