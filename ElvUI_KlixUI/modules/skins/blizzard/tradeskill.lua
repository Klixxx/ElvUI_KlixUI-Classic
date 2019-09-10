local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleTradeSkill()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tradeskill ~= true or E.private.KlixUI.skins.blizzard.tradeskill ~= true then return end

	-- MainFrame
	local TradeSkillFrame = _G.TradeSkillFrame
	if TradeSkillFrame.backdrop then
		TradeSkillFrame.backdrop:Styling()
	end
	
	if TradeSkillFrame.bg1 then
		TradeSkillFrame.bg1:Hide()
	end
	if TradeSkillFrame.bg2 then
		TradeSkillFrame.bg2:Hide()
	end
end

S:AddCallbackForAddon("Blizzard_TradeSkillUI", "KuiTradeSkill", styleTradeSkill)