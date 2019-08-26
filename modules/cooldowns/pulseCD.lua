local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local PC = KUI:NewModule("PulseCooldown", "AceHook-3.0")

PC.cooldowns, PC.animating, PC.watching = { }, { }, { }
local fadeInTime, fadeOutTime, maxAlpha, animScale, iconSize, holdTime
local testtable

local DCP = T.CreateFrame("Frame", nil, E.UIParent)
DCP:SetAlpha(0)
DCP:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
DCP.TextFrame = DCP:CreateFontString(nil, "ARTWORK", "GameFontNormal")
DCP.TextFrame:SetPoint("TOP", DCP, "BOTTOM", 0, -5)
DCP.TextFrame:SetWidth(185)
DCP.TextFrame:SetJustifyH("CENTER")
DCP.TextFrame:SetTextColor(1,1,1)
PC.DCP = DCP

local DCPT = DCP:CreateTexture(nil, "BACKGROUND")
DCPT:SetTexCoord(.08, .92, .08, .92)
DCPT:SetAllPoints(DCP)
DCPT:CreateBackdrop()

local defaultsettings = {
	["enable"] = false,
	["fadeInTime"] = 0.3,
	["fadeOutTime"] = 0.6,
	["maxAlpha"] = 0.8,
	["animScale"] = 1.5,
	["iconSize"] = 50,
	["holdTime"] = 0.3,
	["enablePet"] = false,
	["showSpellName"] = false,
	["x"] = UIParent:GetWidth()/2,
	["y"] = UIParent:GetHeight()/2,
}

-----------------------
-- Utility Functions --
-----------------------
local function tcount(tab)
	local n = 0
	for _ in T.pairs(tab) do
		n = n + 1
	end
	return n
end

local function GetPetActionIndexByName(name)
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		if (T.GetPetActionInfo(i) == name) then
			return i
		end
	end
	return nil
end

--------------------------
-- Cooldown / Animation --
--------------------------
local elapsed = 0
local runtimer = 0
local function OnUpdate(_,update)
	elapsed = elapsed + update
	if (elapsed > 0.05) then
		for i,v in T.pairs(PC.watching) do
			if (T.GetTime() >= v[1] + 0.5) then
				local start, duration, enabled, texture, isPet, name
				if (v[2] == "spell") then
					name = T.GetSpellInfo(v[3])
					texture = T.GetSpellTexture(v[3])
					start, duration, enabled = T.GetSpellCooldown(v[3])
				elseif (v[2] == "item") then
					name = T.GetItemInfo(i)
					texture = v[3]
					start, duration, enabled = T.GetItemCooldown(i)
				elseif (v[2] == "pet") then
					texture = T.select(3, T.GetPetActionInfo(v[3]))
					start, duration, enabled = T.GetPetActionCooldown(v[3])
					isPet = true
				end
				if (enabled ~= 0) then
					if (duration and duration > 2.0 and texture) then
						PC.cooldowns[i] = { start, duration, texture, isPet, name }
					end
				end
				if (not (enabled == 0 and v[2] == "spell")) then
					PC.watching[i] = nil
				end
			end
		end
		for i,v in T.pairs(PC.cooldowns) do
			local remaining = v[2]-(T.GetTime()-v[1])
			if (remaining <= 0) then
				T.table_insert(PC.animating, {v[3], v[4], v[5]})
				PC.cooldowns[i] = nil
			end
		end

		elapsed = 0
		if (#PC.animating == 0 and tcount(PC.watching) == 0 and tcount(PC.cooldowns) == 0) then
			DCP:SetScript("OnUpdate", nil)
			return
		end
	end

	if (#PC.animating > 0) then
		runtimer = runtimer + update
		if (runtimer > (PC.db.fadeInTime + PC.db.holdTime + PC.db.fadeOutTime)) then
			T.table_remove(PC.animating, 1)
			runtimer = 0
			DCP.TextFrame:SetText(nil)
			DCPT:SetTexture(nil)
			DCPT:SetVertexColor(1, 1, 1)
			DCP:SetAlpha(0)
			DCP:SetSize(PC.db.iconSize, PC.db.iconSize)
		elseif PC.db.enable then
			if (not DCPT:GetTexture()) then
				if (PC.animating[1][3] ~= nil and PC.db.showSpellName) then
					DCP.TextFrame:SetText(PC.animating[1][3])
				end
				DCPT:SetTexture(PC.animating[1][1])
			end
			local alpha = PC.db.maxAlpha
			if (runtimer < PC.db.fadeInTime) then
				alpha = PC.db.maxAlpha * (runtimer / PC.db.fadeInTime)
			elseif (runtimer >= PC.db.fadeInTime + PC.db.holdTime) then
				alpha = PC.db.maxAlpha - ( PC.db.maxAlpha * ((runtimer - PC.db.holdTime - PC.db.fadeInTime) / PC.db.fadeOutTime))
			end
			DCP:SetAlpha(alpha)
			local scale = PC.db.iconSize + (PC.db.iconSize * ((PC.db.animScale - 1) * (runtimer / (PC.db.fadeInTime + PC.db.holdTime + PC.db.fadeOutTime))))
			DCP:SetWidth(scale)
			DCP:SetHeight(scale)
		end
	end
end

--------------------
-- Event Handlers --
--------------------
function DCP:ADDON_LOADED(addon)
	if (not KUIDataDB_DCP) then
		KUIDataDB_DCP = defaultsettings
	else
		for i, v in pairs(defaultsettings) do
			if (not KUIDataDB_DCP[i]) then
				KUIDataDB_DCP[i] = v
			end
		end
	end
	-- self:SetPoint("CENTER", E.UIParent,"BOTTOMLEFT", KUIDataDB_DCP.x, KUIDataDB_DCP.y)
	E:CreateMover(DCP, "PulseCooldownMover", L["Pulse Cooldown"], nil, nil, nil, 'ALL,SOLO,KLIXUI', nil, "KlixUI,modules,cooldowns,pulse")
end

function DCP:UNIT_SPELLCAST_SUCCEEDED(unit,lineID,spellID)
    if (unit == "player") then
        PC.watching[spellID] = {T.GetTime(),"spell",spellID}
        if (not self:IsMouseEnabled()) then
			self:SetScript("OnUpdate", OnUpdate)
		end
    end
end

function DCP:COMBAT_LOG_EVENT_UNFILTERED()
    local _,event,_,_,_,sourceFlags,_,_,_,_,_,spellID = T.CombatLogGetCurrentEventInfo()
	if (event == "SPELL_CAST_SUCCESS") then
		if (T.bit_band(sourceFlags,COMBATLOG_OBJECT_TYPE_PET) == COMBATLOG_OBJECT_TYPE_PET and T.bit_band(sourceFlags,COMBATLOG_OBJECT_AFFILIATION_MINE) == COMBATLOG_OBJECT_AFFILIATION_MINE) then
			local name = T.GetSpellInfo(spellID)
			local index = GetPetActionIndexByName(name)
			if (index and not T.select(7, T.GetPetActionInfo(index))) then
				PC.watching[spellID] = {T.GetTime(),"pet",index}
			elseif (not index and spellID) then
				PC.watching[spellID] = {T.GetTime(),"spell",spellID}
			else
				return
			end
			if (not self:IsMouseEnabled()) then
				self:SetScript("OnUpdate", OnUpdate)
			end
		end
	end
end

function DCP:PLAYER_ENTERING_WORLD()
	local inInstance,instanceType = T.IsInInstance()
	if (inInstance and instanceType == "arena") then
		self:SetScript("OnUpdate", nil)
		T.table_wipe(PC.cooldowns)
		T.table_wipe(PC.watching)
	end
end

function PC:UseAction(slot)
	local actionType,itemID = T.GetActionInfo(slot)
	if (actionType == "item") then
		local texture = T.GetActionTexture(slot)
		PC.watching[itemID] = {T.GetTime(),"item",texture}
		DCP:SetScript("OnUpdate", OnUpdate)
	end
end

function PC:UseInventoryItem(slot)
	local itemID = T.GetInventoryItemID("player", slot);
	if (itemID) then
		local texture = T.GetInventoryItemTexture("player", slot)
		PC.watching[itemID] = {T.GetTime(), "item", texture}
		DCP:SetScript("OnUpdate", OnUpdate)
	end
end

function PC:UseContainerItem(bag, slot)
	local itemID = T.GetContainerItemID(bag, slot)
	if (itemID) then
		local texture = T.select(10, T.GetItemInfo(itemID))
		PC.watching[itemID] = {T.GetTime(), "item", texture}
		DCP:SetScript("OnUpdate", OnUpdate)
	end
end

function PC:UseItemByName(itemName)
	local itemID
	if itemName then
		itemID = T.string_match(T.select(2, T.GetItemInfo(itemName)), "item:(%d+)")
	end
	if (itemID) then
		local texture = T.select(10, T.GetItemInfo(itemID))
		PC.watching[itemID] = {T.GetTime(), "item", texture}
		DCP:SetScript("OnUpdate", OnUpdate)
	end
end

function PC:EnableCooldownFlash()
	self:SecureHook("UseContainerItem")
	self:SecureHook("UseInventoryItem")
	self:SecureHook("UseAction")
	self:SecureHook("UseItemByName")
	DCP:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	DCP:RegisterEvent("PLAYER_ENTERING_WORLD")
	DCP:RegisterEvent("ADDON_LOADED")
	if self.db.enablePet then
		DCP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function PC:DisableCooldownFlash()
	self:Unhook("UseContainerItem")
	self:Unhook("UseInventoryItem")
	self:Unhook("UseAction")
	self:Unhook("UseItemByName")
	DCP:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	DCP:UnregisterEvent("PLAYER_ENTERING_WORLD")
	DCP:UnregisterEvent("ADDON_LOADED")
	DCP:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function PC:TestMode()
	T.table_insert(PC.animating, {"Interface\\Icons\\achievement_guildperk_ladyluck_rank2", nil, "Spell Name"})
	DCP:SetScript("OnUpdate", OnUpdate)
end

function PC:Initialize()
	if PC.db == nil then PC.db = {} end -- rare nil error
	PC.db = E.db.KlixUI.cooldowns.pulse
	
	DCP:SetSize(PC.db.iconSize, PC.db.iconSize)

	DCP.TextFrame:SetFont(E.db.general.fontSize, 18, "OUTLINE")
	DCP.TextFrame:SetShadowOffset(2, -2)
	if self.db.enable then
		self:EnableCooldownFlash()
	end
	DCP:SetPoint("CENTER", E.UIParent, "CENTER")
end

local function InitializeCallback()
	PC:Initialize()
end

KUI:RegisterModule(PC:GetName(), InitializeCallback)