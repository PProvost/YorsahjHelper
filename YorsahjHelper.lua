﻿--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
-- Title          YorsahjHelper
-- Description    A simple addon to help your raid manage Yorsahj kill orders
-- Author         Quaiche of Dragonblight
-- Credits        Spell IDs from Yorsahj Automatic Raidwarnings by Tom and Gints
-- License        The MIT License (http://opensource.org/licenses/MIT)
--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--


--------------------------------------------------------------------------------
-- Configuration - adjust these to suit your needs
--------------------------------------------------------------------------------

local debugf = tekDebug and tekDebug:GetFrame("YorsahjHelper")
local function Debug(...) if debugf then debugf:AddMessage(string.join(", ", ...)) end end

local _SendChatMessage = function(...)
	Debug(...)
end

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

-- The spell IDs and add combos that they cause
-- These shouldn't change often
-- NOTE: Heroic mode not currently supported!
local spellCombos = {
	[105420] = { "PURPLE", "GREEN", "BLUE" },
	[105435] = { "GREEN", "RED", "BLACK" },
	[105436] = { "GREEN", "YELLOW", "RED" },
	[105437] = { "BLUE", "PURPLE", "YELLOW" },
	[105439] = { "BLUE", "BLACK", "YELLOW" },
	[105440] = { "PURPLE", "RED", "BLACK" },
}

--------------------------------------------------------------------------------
-- A little helper to help figure out if we're in LFR or not
--------------------------------------------------------------------------------
local function IsRaidLFR()
		if IsPartyLFG() and IsInLFGDungeon() then return true end
end

--------------------------------------------------------------------------------
-- Handles the spell, looking it up in the priority list and then announcing
-- what you should kill and then what you should do after
-- E.g. HandleBlobs("PURPLE", "GREEN", "BLUE")
--------------------------------------------------------------------------------
local function HandleBlobs(...)
	local args = {...}

	-- Make a set for quick lookups
	local blobs = {}
	for _,v in pairs(args) do blobs[v] = true end

	-- Announce the spawning blobs
	if useInformationalMessages == true then
		SendChatMessage("==== "..table.concat(args, ", ").." ====" , informationalChannel)
	end

	-- Figure out what the kill is and remove it from the set
	for _,v in pairs(killPriority) do
		if blobs[v] then
			if useInformationalMessages == true then SendChatMessage(" Kill "..v.." first", informationalChannel) end
			if emphasizeKill == true then SendChatMessage("KILL "..v, emphasizeChannel) end
			blobs[v] = null
			break
		end
	end

	-- Send the informational messages based on what is left in the set
	if useInformationalMessages == true then
		local isLFR = IsRaidLFR()
		local message = {}
		if blobs["PURPLE"] then table.insert(message,"Every 5th heal received will cause raid-wide damage (purple)") end
		if blobs["GREEN"] then table.insert(message, isLFR and "Stack up!" or "Stay 4-yds from others (green)") end
		if blobs["YELLOW"] then table.insert(message,"Boss hits 50% faster and does AOE (yellow)") end
		if blobs["BLUE"] then table.insert(message,"Kill mana void (blue)") end
		if blobs["RED"] then table.insert(message,"Stack close to boss (red)") end
		if blobs["BLACK"] then table.insert(message,"AOE the adds (black)") end
		SendChatMessage(" "..table.concat(message, ", "), informationalChannel)
	end
end

--------------------------------------------------------------------------------
-- Hook up to the Wow UNIT_SPELLCAST_SUCCEEDED event
-- NOTE: This does not currently do anything smart like delay load or even
-- confirm that you are in Dragon Soul, so if these spell IDs ever show up
-- elsewhere, things might get funky. Also, it will be enabled for LFR groups,
-- which may annoy people. You have been warned.
--------------------------------------------------------------------------------
function YorsahjHelper_OnEvent(...)
	local spellID = select(7,...)
	-- Debug("SpellID: " .. spellID or "Unknown")
	if spellID and spellCombos[spellID] then
		Debug("FOUND!")
		HandleBlobs( unpack( spellCombos[spellID] ) )
	end
end

local frame = CreateFrame("FRAME")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:SetScript("OnEvent", YorsahjHelper_OnEvent)

