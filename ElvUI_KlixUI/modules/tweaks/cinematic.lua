local KUI, T, E, L, V, P, G = unpack(select(2, ...))

local f = T.CreateFrame("frame")
local moviePlayed = false

_G.CinematicFrame:HookScript("OnShow", function(self, ...)
	if T.IsModifierKeyDown() or E.global.KlixUI.cinematic.kill == false or T.IsAddOnLoaded("CinematicCanceler") then return end
	KUI:Print("Cinematic Canceled.")
	T.CinematicFrame_CancelCinematic()
end)

local omfpf = _G["MovieFrame_PlayMovie"]
_G["MovieFrame_PlayMovie"] = function(...)
	if T.IsModifierKeyDown() or E.global.KlixUI.cinematic.kill == false or T.IsAddOnLoaded("CinematicCanceler") then return omfpf(...) end
	KUI:Print("Movie Canceled.")
	T.GameMovieFinished()
	return true
end


local function eventhandler(self, event)
if E.global.KlixUI.cinematic.kill then return end
	
	if not T.GetCVarBool("Sound_EnableAllSound") then
		if (event == "CINEMATIC_START") and E.global.KlixUI.cinematic.enableSound then
			T.SetCVar("Sound_EnableAllSound", 1)
		elseif (event == "PLAY_MOVIE") and E.global.KlixUI.cinematic.enableSound then
			moviePlayed = true
			T.SetCVar("Sound_EnableAllSound", 1)
		elseif(event == "CINEMATIC_STOP") and E.global.KlixUI.cinematic.enableSound then
			T.SetCVar("Sound_EnableAllSound", 0)
		elseif(event == "QUEST_COMPLETE") and E.global.KlixUI.cinematic.enableSound or E.global.KlixUI.cinematic.talkingheadSound then
			T.SetCVar("Sound_EnableAllSound", 0)
		end
		
		hooksecurefunc(_G, "GameMovieFinished", function() if moviePlayed then T.SetCVar("Sound_EnableAllSound", 0) end moviePlayed = false end)
	end
end

f:RegisterEvent("CINEMATIC_START")
f:RegisterEvent("CINEMATIC_STOP")
f:RegisterEvent("PLAY_MOVIE")
f:RegisterEvent("QUEST_COMPLETE")
f:SetScript("OnEvent", eventhandler)