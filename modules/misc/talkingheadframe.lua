local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local THF = KUI:NewModule("TalkingHeadFrame", "AceEvent-3.0", "AceHook-3.0")

function THF:HideTalkingHead()
	if E.db.KlixUI.misc.talkingHead then
		hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
			-- Query subzone text when the talkinghead plays
			zoneName = T.GetSubZoneText()
			mainZoneName = T.GetZoneText()
			-- If we are not doing withered training or islands expeditions, suppress the talkinghead
			if zoneName ~= "Temple of Fal'adora" and
				zoneName ~= "Falanaar Tunnels" and
				zoneName ~= "Shattered Locus" or 
				zoneName ~= "Molten Cay" or
				zoneName ~= "Un'gol Ruins" or
				zoneName ~= "The Rotting Mire" or
				zoneName ~= "Whispering Reef" or
				zoneName ~= "Verdant Wilds" or
				zoneName ~= "The Dread Chain" or
				zoneName ~= "Skittering Hollow" or
				zoneName ~= "Havenswood" or
				zoneName ~= "Jorundall" or
				zoneName ~= "Crestfall" or
				zoneName ~= "Snowblossom Village" or 
				mainZoneName ~= "Ashran" or
				mainZoneName ~= "Nazjatar" then
						
				TalkingHeadFrame_CloseImmediately()
				KUI:Print("TalkingHeadFrame closed.")
			end
		end)
	end
end

function THF:Initialize()
    if T.IsAddOnLoaded("Blizzard_TalkingHeadUI") then
		THF:HideTalkingHead()
	else -- We want the mover to be available immediately, so we load it ourselves
		local f = T.CreateFrame("Frame")
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self, event)
			self:UnregisterEvent(event)
			T.TalkingHead_LoadUI()
			THF:HideTalkingHead()
		end)
	end
end

KUI:RegisterModule(THF:GetName())