local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KAB = KUI:NewModule('KUIActionbars', 'AceEvent-3.0', "AceHook-3.0", "AceBucket-3.0")
local AB = LibStub("LibActionButton-1.0-ElvUI")
local LCG = LibStub('LibCustomGlow-1.0')

if E.private.actionbar.enable ~= true then return; end

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local availableActionbars = availableActionbars or 6

local styleOtherBacks = {ElvUI_BarPet, ElvUI_StanceBar}

local ActiveButtons = AB.activeButtons

local function CheckExtraAB()
	if T.IsAddOnLoaded('ElvUI_ExtraActionBars') then
		availableActionbars = 10
	else
		availableActionbars = 6
	end
end

function KAB:ABStyling()
	-- Buttons
	local db = E.db.KlixUI.actionbars
	for i = 1, availableActionbars do
		for k = 1, 12 do
			local buttonBars = {_G["ElvUI_Bar"..i.."Button"..k]}
			for _, button in T.pairs(buttonBars) do
				if button.backdrop then
					button.backdrop:Styling()
				end
				button:CreateIconShadow()
			end
		end
	end

	-- Pet Buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		local petButtons = {_G['PetActionButton'..i]}
		for _, button in T.pairs(petButtons) do
			button:CreateIconShadow()
		end
	end
	
	-- Stance Buttons
	for i = 1, NUM_STANCE_SLOTS do
		local stanceButtons = {_G["ElvUI_StanceBarButton"..i]}
		for _, button in T.pairs(stanceButtons) do
			button:CreateIconShadow()
		end
	end
end

function KAB:StyleBackdrops()
	-- Actionbar backdrops
	for i = 1, availableActionbars do
		local styleBacks = {_G['ElvUI_Bar'..i]}
		for _, frame in T.pairs(styleBacks) do
			if frame.backdrop then
				frame.backdrop:Styling()
			end
		end
	end

	-- Other bar backdrops
	for _, frame in T.pairs(styleOtherBacks) do
		if frame.backdrop then
			frame.backdrop:Styling()
		end
	end
	
	-- Pet Buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		local petButtons = {_G['PetActionButton'..i]}
		for _, button in T.pairs(petButtons) do
			if button.backdrop then
				button.backdrop:Styling()
			end
		end
	end
end

function KAB:Initialize()
	CheckExtraAB()
	T.C_Timer_After(1, KAB.ABStyling)
	T.C_Timer_After(1, KAB.StyleBackdrops)
end

KUI:RegisterModule(KAB:GetName())