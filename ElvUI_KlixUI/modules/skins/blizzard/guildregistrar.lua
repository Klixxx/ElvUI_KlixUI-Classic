local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleGuildRegistrar()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guildregistrar ~= true or E.private.KlixUI.skins.blizzard.guildregistrar ~= true then return end
	
	local GuildRegistrarFrame = _G.GuildRegistrarFrame
	if GuildRegistrarFrame.backdrop then
		GuildRegistrarFrame.backdrop:Styling()
	end
end

S:AddCallback('GuildRegistrar', styleGuildRegistrar)