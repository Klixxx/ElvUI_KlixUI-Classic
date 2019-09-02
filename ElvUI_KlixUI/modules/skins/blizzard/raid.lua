local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule('Skins')

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleRaid()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.raid ~= true or E.private.KlixUI.skins.blizzard.raid ~= true then return end
	
	for i = 1, NUM_RAID_GROUPS do
		local group = _G["RaidGroup"..i]
		group:GetRegions():SetAlpha(0)
		for j = 1, MEMBERS_PER_RAID_GROUP do
			local slot = _G["RaidGroup"..i.."Slot"..j]
			T.select(1, slot:GetRegions()):SetAlpha(0)
			T.select(2, slot:GetRegions()):SetColorTexture(r, g, b, .25)
			KS:CreateBDFrame(slot, .2)
		end
	end

	for i = 1, MAX_RAID_MEMBERS do
		local bu = _G["RaidGroupButton"..i]
		T.select(4, bu:GetRegions()):SetAlpha(0)
		T.select(5, bu:GetRegions()):SetColorTexture(r, g, b, .2)
		KS:CreateBDFrame(bu)
	end
end

S:AddCallbackForAddon("Blizzard_RaidUI", "KuiRaid", styleRaid)
