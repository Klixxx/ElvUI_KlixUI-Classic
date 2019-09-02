local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleBinding()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.binding ~= true or E.private.KlixUI.skins.blizzard.binding ~= true then return end
	
	local KeyBindingFrame = _G.KeyBindingFrame
	KeyBindingFrame:Styling()

	local function styleBindingButton(bu)
		local selected = bu.selectedHighlight

		for i = 1, 9 do
			T.select(i, bu:GetRegions()):Hide()
		end

		selected:SetTexture(E.media.normTex)
		selected:SetPoint("TOPLEFT", 1, -1)
		selected:SetPoint("BOTTOMRIGHT", -1, 1)
		selected:SetColorTexture(r, g, b, .2)

		KS:Reskin(bu)
	end

	for i = 1, KEY_BINDINGS_DISPLAYED do
		local button1 = _G["KeyBindingFrameKeyBinding"..i.."Key1Button"]
		local button2 = _G["KeyBindingFrameKeyBinding"..i.."Key2Button"]

		button2:SetPoint("LEFT", button1, "RIGHT", 1, 0)

		styleBindingButton(button1)
		styleBindingButton(button2)
	end

	--[[local line = KeyBindingFrame:CreateTexture(nil, "ARTWORK")
	line:SetSize(1, 546)
	line:SetPoint("LEFT", 205, 10)
	line:SetColorTexture(1, 1, 1, .2)]]
end

S:AddCallbackForAddon("Blizzard_BindingUI", "KuiBinding", styleBinding)