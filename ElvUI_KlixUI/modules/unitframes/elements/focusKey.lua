local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local FK = KUI:NewModule("FocusKey")
	
local function SetFocusHotkey(frame)
	if not frame then return; end
	frame:SetAttribute(E.db.KlixUI.unitframes.focusKey.focusButton1.."-type"..E.db.KlixUI.unitframes.focusKey.focusButton2,"focus")
end
	
local function CreateFrame_Hook(type, name, parent, template)
	if template == "SecureUnitButtonTemplate" then
		SetFocusHotkey(_G[name])
	end
end

function FK:Initialize()
	if not E.db.KlixUI.unitframes.focusKey.enable then return end
	
	hooksecurefunc("CreateFrame", CreateFrame_Hook)
	
	local f = T.CreateFrame("CheckButton", "KuiFocusButton", E.UIParent, "SecureActionButtonTemplate")
	f:SetAttribute("type1","macro")
	f:SetAttribute("macrotext","/focus mouseover")
	T.SetOverrideBindingClick(KuiFocusButton, true, E.db.KlixUI.unitframes.focusKey.focusButton1.."-BUTTON"..E.db.KlixUI.unitframes.focusKey.focusButton2, "KuiFocusButton")
	local duf = {
		ElvUF_Player,
		ElvUF_Pet,	
		ElvUF_Target,
		ElvUF_Targettarget,
		PlayerFrame,
		PetFrame,
		PartyMemberFrame1,
		PartyMemberFrame2,
		PartyMemberFrame3,
		PartyMemberFrame4,
		PartyMemberFrame1PetFrame,
		PartyMemberFrame2PetFrame,
		PartyMemberFrame3PetFrame,
		PartyMemberFrame4PetFrame,
		TargetFrame,
		TargetofTargetFrame,
	}

	for i, frame in pairs(_G.duf) do
		SetFocusHotkey(frame)
	end
end

local function InitializeCallback()
	FK:Initialize()
end

KUI:RegisterModule(FK:GetName(), InitializeCallback)