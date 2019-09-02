local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleHelp()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.help ~= true or E.private.KlixUI.skins.blizzard.help ~= true then return end

	local frames = {
		"HelpFrame",
		"HelpFrameKnowledgebase",
	}

	-- skin main frames
	for i = 1, #frames do
		_G[frames[i]].backdrop:Styling()
	end

	if _G.HelpFrameHeader.backdrop then
		_G.HelpFrameHeader.backdrop:Hide()
	end

	KS:CreateBD(_G.HelpFrameHeader, .65)
	_G.HelpFrameHeader:Styling()
end

S:AddCallback("KuiHelp", styleHelp)