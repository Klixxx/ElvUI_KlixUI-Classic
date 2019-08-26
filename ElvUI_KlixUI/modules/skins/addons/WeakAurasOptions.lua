local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function InitStyleWAO()
	local function Skin_WeakAurasOptions(...)
		--T.print("Options opened", ...)
		if not T.IsAddOnLoaded("WeakAuras") or not E.private.KlixUI.skins.addonSkins.wa then return end

		local frame = WeakAuras.OptionsFrame()
		if frame.skinned then return end
		
		local children = {frame:GetChildren()}

		-- Close button
		children[1]:Hide()
		local close = children[1]:GetChildren()
		close:SetParent(frame)
		S:HandleCloseButton(close)

		-- Disable import check
		children[2]:Hide()
		local import = children[2]:GetChildren()
		S:HandleCheckBox(import)
		import:SetParent(frame)
		import:SetSize(25, 25)
		import:ClearAllPoints()
		import:SetPoint("LEFT", close, "RIGHT", 1, 0)

		-- Title
		--children[3]

		-- Frame size handle
		local sizer = children[4]
		sizer:SetNormalTexture("")
		sizer:SetHighlightTexture("")
		sizer:SetPushedTexture("")

		for i = 1, 3 do
			local tex = sizer:CreateTexture(nil, "OVERLAY")
			tex:SetSize(2, 2)
			tex:SetTexture(E.media.normTex)
			tex:SetVertexColor(r, g, b, .8)
			tex:Show()
			sizer[i] = tex
		end
		sizer[1]:SetPoint("BOTTOMLEFT", sizer, "BOTTOMLEFT", 6, 6)
		sizer[2]:SetPoint("BOTTOMLEFT", sizer[1], "TOPLEFT", 0, 4)
		sizer[3]:SetPoint("BOTTOMLEFT", sizer[1], "BOTTOMRIGHT", 4, 0)

		-- Tutorial
		--children[6]
		local _, _, _, enabled, loadable = T.GetAddOnInfo("WeakAurasTutorials")
		local tutOfs = (enabled and loadable) and 1 or 0

		--[[ Ace groups
			children[6+tutOfs] container
			children[7+tutOfs] texturePick
			children[8+tutOfs] iconPick
			children[9+tutOfs] modelPick
			children[10+tutOfs] importexport
			children[11+tutOfs] texteditor
			children[12+tutOfs] codereview
			children[13+tutOfs] buttonsContainer
		]]

		-- Search
		S:HandleEditBox(WeakAurasFilterInput)

		-- Remove Title BG
		KS:StripTextures(frame)

		-- StripTextures will actually remove the backdrop too, so we need to put that back
		KS:CreateBD(frame)
		KS:CreateSD(frame)
		frame:Styling()

		frame.skinned = true
	end
	hooksecurefunc(WeakAuras, "ShowOptions", Skin_WeakAurasOptions)
end

if T.IsAddOnLoaded("WeakAurasOptions") then
	InitStyleWAO()
else
	local load = T.CreateFrame("Frame")
	load:RegisterEvent("ADDON_LOADED")
	load:SetScript("OnEvent", function(self, _, addon)
		if addon ~= "WeakAurasOptions" then return end
		self:UnregisterEvent("ADDON_LOADED")

		InitStyleWAO()

		load = nil
	end)
end