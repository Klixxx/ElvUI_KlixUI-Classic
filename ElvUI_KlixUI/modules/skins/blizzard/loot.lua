local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleLoot()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.loot ~= true or E.private.KlixUI.skins.blizzard.loot ~= true then return end
	
	local LootFrame = _G.LootFrame
	LootFrame:Styling()
	
	local ElvLootFrame = _G.ElvLootFrame
	ElvLootFrame:Styling()
end

S:AddCallback("KuiLoot", styleLoot)