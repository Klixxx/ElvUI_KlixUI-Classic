local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")
local B = E:GetModule('Bags')

local weShown = false

local function styleScrappingMachine()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Scrapping ~= true or E.private.KlixUI.skins.blizzard.Scrapping ~= true then return end

	local MachineFrame = _G.ScrappingMachineFrame
	MachineFrame:Styling()
	
	-- Automatic open the Bags if the MachineFrame shows
	MachineFrame:HookScript("OnShow", function()
		if E.private.bags.enable ~= true or E.db.KlixUI.misc.scrapper.autoOpen ~= true then return end
		
		if MachineFrame:IsShown() and not B.BagFrame:IsShown() then
			T.ToggleAllBags()
			weShown = true
		end
	end)
	MachineFrame:HookScript("OnHide", function()
		if (weShown) then
			T.ToggleAllBags()
		end
		weShown = false
	end)
end

S:AddCallbackForAddon('Blizzard_ScrappingMachineUI', "KuiScrappingMachine", styleScrappingMachine)