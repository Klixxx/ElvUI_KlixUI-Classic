﻿local KUI, T, E, L, V, P, G = unpack(select(2, ...))
if E.db.KlixUI.pvp == nil then E.db.KlixUI.pvp = {} end
if not E.db.KlixUI.pvp.killStreaks then return end

local soundpath = "Interface\\AddOns\\ElvUI_KlixUI\\media\\sounds\\Unreal_Tournament\\Killstreaks\\"
local forthealliance = "Interface\\AddOns\\ElvUI_KlixUI\\media\\sounds\\heroism.mp3"
local forthehorde = "Interface\\AddOns\\ElvUI_KlixUI\\media\\sounds\\bloodlust.mp3"

local firstblood = soundpath.."firstblood.ogg"
local killingspree = soundpath.."killingspree.ogg"
local dominating = soundpath.."dominating.ogg"
local megakill = soundpath.."megakill.ogg"
local unstoppable = soundpath.."unstoppable.ogg"
local wickedsick = soundpath.."wickedsick.ogg"
local monsterkill = soundpath.."monsterkill.ogg"
local godlike = soundpath.."godlike.ogg"
local holyshit = soundpath.."holyshit.ogg"

local doublekill = soundpath.."doublekill.ogg"
local triplekill = soundpath.."triplekill.ogg"
local ultrakill = soundpath.."ultrakill.ogg"
local rampage = soundpath.."rampage.ogg"


local DOTA_timer_reset = false
local DOTA_reset_time = 1800
local DOTA_mkill_time = 20
local DOTA_kills = 0
local enemyname = nil
local total = 0

local frame = T.CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

function frame:OnUpdate(elps)
	total = total + elps
	if total >= 2 then
		T.pcall(T.PlaySoundFile, DOTA_file_m, "Master")
		total = 0
		frame:SetScript('OnUpdate', nil)
	end
end

frame:SetScript("OnEvent", function(self, event, arg1)
	local player = T.UnitGUID("player")
	local pname = T.UnitName("player")
	local arg1, eventType, hideCaster, srcGUID, srcName, sourceFlags, sourceRaidFlags, destGUID, dstName, dstFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
	local COMBATLOG_OBJECT_NONE = COMBATLOG_OBJECT_NONE	
	local DOTA_COMBATLOG_FILTER_ENEMY_PLAYERS = T.bit_bor(COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER)
	local DOTA_COMBATLOG_FILTER_ENEMY_NPC = T.bit_bor(COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC)

	local DOTA_timer_reset_control

	if (event=="COMBAT_LOG_EVENT_UNFILTERED") then

		if (eventType=="SPELL_DAMAGE" or eventType=="RANGE_DAMAGE" or eventType=="SPELL_PERIODIC_DAMAGE" or eventType=="SPELL_BUILDING_DAMAGE") then
			local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, overkill = CombatLogGetCurrentEventInfo()
			if overkill and overkill > 0 then
				if(dstName == pname and srcName ~= pname) then
					enemyname = srcName
				elseif(dstName == pname and srcName == pname) then
					DOTA_timer_reset_control = true

					enemyname = nil
				end
			end

		elseif eventType=="SWING_DAMAGE" then
			local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, overkill = CombatLogGetCurrentEventInfo()
			if overkill and overkill > 0 then
				if(dstName == pname and srcName ~= pname) then
					enemyname = srcName
				elseif(dstName == pname and srcName == pname) then
					DOTA_timer_reset_control = true
					enemyname = nil
				end
			end
		elseif eventType=="ENVIRONMENTAL_DAMAGE" then
			local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13,overkill = CombatLogGetCurrentEventInfo()
			if overkill and overkill > 0 then
				if(dstName == pname and srcName ~= pname) then
					enemyname = srcName

				elseif(dstName == pname and srcName == pname) then
					DOTA_timer_reset_control = true

					enemyname = nil
				end
			end
	 	end
	end
  
	if event == "PLAYER_DEAD" then
		if DOTA_timer_reset_control == true then
			DOTA_timer_reset = DOTA_timer_reset
		else
			DOTA_timer_reset = true
			DOTA_timer_reset_control = false
		end

	end
	
	if event == "ZONE_CHANGED_NEW_AREA" then 
		local faction = T.UnitFactionGroup("player")
		local inInstance, instanceType = T.IsInInstance()

		if instanceType == 'pvp' or instanceType == 'arena' then
			-- just for fun :)
			if faction == "Alliance" then
				T.pcall(T.PlaySoundFile, forthealliance, "Master")
			elseif faction == "Horde" then
				T.pcall(T.PlaySoundFile, forthehorde, "Master")
			end
		end

		DOTA_timer_reset = true
	end

	local toEnemy
	local toEnemyPlayer
	local toEnemyNPC
	if (dstName and not T.CombatLog_Object_IsA(dstFlags, COMBATLOG_OBJECT_NONE) ) then
		toEnemyPlayer = T.CombatLog_Object_IsA(dstFlags, DOTA_COMBATLOG_FILTER_ENEMY_PLAYERS)
		toEnemyNPC = T.CombatLog_Object_IsA(dstFlags, DOTA_COMBATLOG_FILTER_ENEMY_NPC)
	end

	toEnemy = toEnemyPlayer

	if (eventType == "PARTY_KILL" and srcGUID == player and toEnemy ) then
		if (not DOTA_lastkill or (GetTime() - DOTA_lastkill > DOTA_reset_time ) or DOTA_timer_reset) then

			DOTA_file = firstblood
			DOTA_kills = 1
			DOTA_mkills = 1
			DOTA_timer_reset = false

		elseif (GetTime() - DOTA_lastkill <= DOTA_reset_time ) then
			DOTA_kills = DOTA_kills + 1
			
			if (GetTime() - DOTA_lastkill <= DOTA_mkill_time) then
				DOTA_firstmkill = DOTA_lastkill
				
				if (DOTA_kills == 2) then
					DOTA_file = ""

				elseif (DOTA_kills == 3) then
					DOTA_file = killingspree

				elseif (DOTA_kills == 4) then
					DOTA_file = dominating

				elseif (DOTA_kills == 5) then
					DOTA_file = megakill

				elseif (DOTA_kills == 6) then
					DOTA_file = unstoppable

				elseif (DOTA_kills == 7) then
					DOTA_file = wickedsick

				elseif (DOTA_kills == 8) then
					DOTA_file = monsterkill

				elseif (DOTA_kills == 9) then
					DOTA_file = godlike

				elseif (DOTA_kills > 9) then
					DOTA_file = holyshit

				else
					DOTA_file = ""

				end


				if (GetTime() - DOTA_firstmkill <= DOTA_mkill_time) then
					DOTA_mkills = DOTA_mkills + 1
					if (DOTA_mkills == 2) then
						DOTA_file_m = doublekill

					elseif (DOTA_mkills == 3) then
						DOTA_file_m = triplekill

					elseif (DOTA_mkills == 4) then
						DOTA_file_m = ultrakill

					elseif (DOTA_mkills == 5) then
						DOTA_file_m = rampage

					elseif (DOTA_mkills > 5) then
						DOTA_file_m = rampage

					else
						DOTA_file_m = ""

					end
				end

			else
				DOTA_mkills = 1
				if (DOTA_kills == 2) then
						DOTA_file = ""

				elseif (DOTA_kills == 3) then
					DOTA_file = killingspree

				elseif (DOTA_kills == 4) then
					DOTA_file = dominating

				elseif (DOTA_kills == 5) then
					DOTA_file = megakill

				elseif (DOTA_kills == 6) then
					DOTA_file = unstoppable

				elseif (DOTA_kills == 7) then
					DOTA_file = wickedsick

				elseif (DOTA_kills == 8) then
					DOTA_file = monsterkill

				elseif (DOTA_kills == 9) then
					DOTA_file = godlike

				elseif (DOTA_kills > 9) then
					DOTA_file = holyshit

				else
					DOTA_file = ""

				end

			end
		end

		DOTA_lastkill = GetTime()
		if DOTA_kills >=2 and DOTA_mkills >=2 then
			T.pcall(T.PlaySoundFile, DOTA_file, "Master")

			frame:SetScript('OnUpdate', frame.OnUpdate)
		elseif DOTA_kills ~= nil and DOTA_mkills == 1 then

			T.pcall(T.PlaySoundFile, DOTA_file, "Master")
		elseif DOTA_kills == 2 and DOTA_mkills ~= nil then

			T.pcall(T.PlaySoundFile, DOTA_file, "Master")
		end

	else
		return
	end
end)
