-------------------------------------------------------------------------------
-- Credits: Auto Confirm Static Popups - PeknaMrcha
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local CSP = KUI:NewModule("ConfirmStaticPopups", "AceEvent-3.0", "AceTimer-3.0")

local ACCEPT, CANCEL, OKAY, YES = ACCEPT, CANCEL, OKAY, YES
local DELETE_ITEM_CONFIRM_STRING = DELETE_ITEM_CONFIRM_STRING

local showWhich = {}
local TIMER = 0.5

local blacklisted = {
  ["DANGEROUS_SCRIPTS_WARNING"] = true, -- it call protected function
  ["GARRISON_SHIP_RENAME"] = true, -- it make no sence, because name of ship need to be typed before confirm
  ["VOTE_BOOT_PLAYER"] = true, -- this I will not automate anyone can decide on his own
  ["CONFIRM_ARTIFACT_RESPEC"] = true, -- Respec cost power so no automation here
  ["REPLACE_ENCHANT"] = true, -- it call protected function
  ["SPELL_CONFIRMATION_PROMPT"] = true, -- sometime call protected function
  ["PET_BATTLE_FORFEIT_NO_PENALTY"] = true, -- another piece code moved to protected
  ["CONFIRM_DISENCHANT_ROLL"] = true, -- sorry but this addon is too simple minded to support this
  ["CONFIRM_LOOT_ROLL"] = true, -- sorry but this addon is too simple minded to support this
  ["CANCEL_AUCTION"] = true, -- another protected function CancelAuction() 
  ["CONFIRM_FOLLOWER_EQUIPMENT"] = true, -- 7.1.5 patch another protected function pain in ass
  ["GUILDBANK_WITHDRAW"] = true, -- dialog need fill-up number it can't be automated
  ["GUILDBANK_DEPOSIT"] = true, -- dialog need fill-up number it can't be automated
  ["WQA_LEAVE_GROUP"] = true, -- this is from 3rd party add-on and leave instance group is handled by default
  ["USE_NO_REFUND_CONFIRM"] = true, -- another option rendered unusable 7.3 hotfix
  ["BUYOUT_AUCTION"] = true, -- require interaction
  ["RENAME_PET"] = true, -- name need to be defined by user
}

function CSP:Message(...)
	KUI:Print(...)
end

function CSP:BackTimer()
	if T.InCombatLockdown() or T.IsModifierKeyDown() or not E.db.KlixUI.misc.popupsEnable then return end -- only out-of combat is safe to simulate clicks or disable the auto accept temporarily with modifierkey.
	for i = 1, 10 do
    local frame = _G["StaticPopup" .. i]
		if frame and frame.which and not blacklisted[frame.which] and frame.IsShown and frame:IsShown()  then
			local button = _G["StaticPopup" .. i .. "Button1"] -- /run local b = _G["StaticPopup1Button1"]; T.print(b)
			if button and button.IsShown and button:IsShown() then
				if not (button.GetText and (button:GetText() == CANCEL)) then -- static popup with single cancel button, like logout etc.
					if E.db.KlixUI.misc.popups[frame.which] or (_G.WoWBox and (frame.which == "BUYEMALL_CONFIRM")) then -- configured or personal app
						local editbox = _G["StaticPopup" .. i .. "EditBox"]
						if editbox and editbox.IsShown and editbox:IsShown() then -- fill in confirm edit box
							editbox:SetText(DELETE_ITEM_CONFIRM_STRING)
						end
						if button.Click then
							button:Click("LeftButton")
						end
					else
						if not showWhich[frame.which] then
							if (E.db.KlixUI.misc.popups[frame.which] == nil) then
								if button.GetText and ((button:GetText() == YES) or (button:GetText() == OKAY) or (button:GetText() == ACCEPT)) then
									self:Message(frame.which, L["REQUEST"]..KUI:PrintURL('https://discord.gg/GbQbDRX'))
								end
							else
								if not _G.WoWBox then self:Message(frame.which, L["NOTENABLED"]) end
							end
						end	
						showWhich[frame.which] = true
					end
				end
			end
		end
	end
end

-- Profile sort order
local function __genOrderedIndex(t)
  local orderedIndex = {}
  for key in T.pairs(t) do T.table_insert(orderedIndex, key) end
  T.table_sort(orderedIndex)
  return orderedIndex
end

local function orderedNext(t, state)
	local key = nil
	if state == nil then
		t.__orderedIndex = __genOrderedIndex( t )
		key = t.__orderedIndex[1]
	else
		for i = 1, T.table_getn(t.__orderedIndex) do
			if t.__orderedIndex[i] == state then
				key = t.__orderedIndex[i+1]
			end
		end
	end
	if key then
		return key, t[key]
	end
	t.__orderedIndex = nil
	return
end

function CSP:orderedPairs(t)
	return orderedNext, t, nil
end

function CSP:Initialize()
	if not self.backTimer then self.backTimer = self:ScheduleRepeatingTimer("BackTimer", TIMER) end
end

KUI:RegisterModule(CSP:GetName())