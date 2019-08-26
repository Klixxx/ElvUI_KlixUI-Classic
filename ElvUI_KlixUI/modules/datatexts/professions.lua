local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

local lastPanel
local profValues = {}
local displayString = ""
local tooltipString = ""

function DT:GetProfessionName(index)
    local name, _, _, _, _, _, _, _ = T.GetProfessionInfo(index)
    return name
end

local function OnEvent(self, event, ...)
	local prof1, prof2, archy, fishing, cooking = T.GetProfessions()
	
	if E.db.KlixUI.profDT.prof == "prof1" then
		
		if prof1 ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = T.GetProfessionInfo(prof1)
			self.text:SetFormattedText(displayString, name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end
	
	elseif E.db.KlixUI.profDT.prof == "prof2" then
	
		if prof2 ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = T.GetProfessionInfo(prof2)
			self.text:SetFormattedText(displayString, name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end
	
	elseif E.db.KlixUI.profDT.prof == "archy" then
	
		if archy ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = T.GetProfessionInfo(archy)
			self.text:SetFormattedText(displayString, name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end
	
	elseif E.db.KlixUI.profDT.prof == "fishing" then
	
		if fishing ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = T.GetProfessionInfo(fishing)
			self.text:SetFormattedText(displayString, name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end
	
	elseif E.db.KlixUI.profDT.prof == "cooking" then
	
		if cooking ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = T.GetProfessionInfo(cooking)
			self.text:SetFormattedText(displayString, name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end
	
	end
end

local function Click(self, button)
	local prof1, prof2, archy, _, cooking = T.GetProfessions()
	if button == "LeftButton" then
		if T.IsShiftKeyDown() and archy == nil then return
		elseif not T.IsShiftKeyDown() and prof1 == nil then return end
		local name, _, _, _, _, _, _, _ = T.GetProfessionInfo(T.IsShiftKeyDown() and archy or prof1)
		T.CastSpellByName(name == L["Mining"] and L["Smelting"] or name)
	elseif button == "RightButton" then
		if T.IsShiftKeyDown() and cooking == nil then return
		elseif not T.IsShiftKeyDown() and prof2 == nil then return end
		local name, _, _, _, _, _, _, _ = T.GetProfessionInfo(T.IsShiftKeyDown() and cooking or prof2)
		T.CastSpellByName(name == L["Mining"] and L["Smelting"] or name)
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	
	local prof1, prof2, archy, fishing, cooking = T.GetProfessions()
	local professions = {}
	
	if prof1 ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = T.GetProfessionInfo(prof1)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end
	
	if prof2 ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = T.GetProfessionInfo(prof2)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end
	
	if archy ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = T.GetProfessionInfo(archy)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end
	
	if fishing ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = T.GetProfessionInfo(fishing)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end
	
	if cooking ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = T.GetProfessionInfo(cooking)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end
	
	if #professions == 0 then return end	
	T.table_sort(professions, function(a, b) return a["name"] < b["name"] end)
	
	for i = 1, #professions do
		DT.tooltip:AddDoubleLine(T.string_join("", professions[i].texture, "  ", professions[i].name), tooltipString:format(professions[i].rank, professions[i].maxRank), 1, 1, 1, 1, 1, 1)
	end
	
	if E.db.KlixUI.profDT.hint then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(L["Left Click:"], L["Open "] .. DT:GetProfessionName(prof1), 0.7, 0.7, 1.0)
		
	if prof2 ~= nil then
		DT.tooltip:AddDoubleLine(L["Right Click:"], L["Open "] .. DT:GetProfessionName(prof2), 0.7, 0.7, 1.0)
	else
		DT.tooltip:AddDoubleLine(L["Right Click:"], L["No Profession"], 0.7, 0.7, 1.0)
	end

	if archy ~= nil then
		DT.tooltip:AddDoubleLine(L["Shift + Left Click:"], L["Open "] .. DT:GetProfessionName(archy), 0.7, 0.7, 1.0)
	end

	if cooking ~= nil then
		DT.tooltip:AddDoubleLine(L["Shift + Right Click:"], L["Open "] .. DT:GetProfessionName(cooking), 0.7, 0.7, 1.0)
	end

	end
	
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = T.string_join("", "|cffffffff%s:|r ", hex, "%d|r/", hex, "%d|r")
	tooltipString = T.string_join("" , hex, "%d|r|cffffffff/|r", hex, "%d|r")
	if lastPanel ~= nil then OnEvent(lastPanel) end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("Professions (KUI)", {"PLAYER_ENTERING_WORLD", "CHAT_MSG_SKILL", "SKILL_LINES_CHANGED"}, OnEvent, nil, Click, OnEnter)