local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleSocketing()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.socket ~= true or E.private.KlixUI.skins.blizzard.socket ~= true then return end

	local ItemSocketingFrame = _G.ItemSocketingFrame
	
	if ItemSocketingFrame then
		if not ItemSocketingFrame.styling then
			ItemSocketingFrame:Styling()
			
			ItemSocketingFrame.styling = true
		end
	end
	
	ItemSocketingFrame:DisableDrawLayer("ARTWORK")

	local title = T.select(18, ItemSocketingFrame:GetRegions())
	title:ClearAllPoints()
	title:SetPoint("TOP", 0, -5)

	for i = 1, _G.MAX_NUM_SOCKETS do
		local bu = _G["ItemSocketingSocket"..i]
		local shine = _G["ItemSocketingSocket"..i.."Shine"]

		_G["ItemSocketingSocket"..i.."BracketFrame"]:Hide()
		_G["ItemSocketingSocket"..i.."Background"]:SetAlpha(0)
		T.select(2, bu:GetRegions()):Hide()

		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu.icon:SetTexCoord(T.unpack(E.TexCoords))

		shine:ClearAllPoints()
		shine:SetPoint("TOPLEFT", bu)
		shine:SetPoint("BOTTOMRIGHT", bu, 1, 0)

		bu.bg = KS:CreateBDFrame(bu, .25)
	end
end

S:AddCallbackForAddon("Blizzard_ItemSocketingUI", "KuiSocketing", styleSocketing)