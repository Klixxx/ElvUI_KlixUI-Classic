local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleWorldmap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true or E.private.KlixUI.skins.blizzard.worldmap ~= true then return end
	
	_G.WorldMapFrame:Styling()

	--[[local frame = T.CreateFrame("Frame", nil, _G.QuestScrollFrame)
	_G.QuestScrollFrame.QuestCountFrame = frame

	frame:RegisterEvent("QUEST_LOG_UPDATE")
	frame:Size(240, 20)
	frame:Point("TOP", -1, 22)
	KS:CreateBD(frame, .25)

	local text = KUI:CreateText(frame, "OVERLAY", 12, "OUTLINE")
	text:SetTextColor(r, g, b)
	text:SetAllPoints()

	frame.text = text
	local str = "%d / 25 Quests"
	frame.text:SetFormattedText(str, T.select(2, T.GetNumQuestLogEntries()))

	frame:SetScript("OnEvent", function(self, event)
		local _, quests = T.GetNumQuestLogEntries()
		frame.text:SetFormattedText(str, quests)
	end)

	if _G.QuestScrollFrame.DetailFrame.backdrop then
		_G.QuestScrollFrame.DetailFrame.backdrop:Hide()
	end]]
end

S:AddCallback("KuiSkinWorldMap", styleWorldmap)
