local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local buttonsize = 18

-- Init a table to store the backgrounds
local FreeBackgrounds = {}

local function CreateBG()
	local BG = T.CreateFrame("Frame")
	BG:SetTemplate("Transparent")
	BG:Styling()
	return BG
end

local function FreeStyle(bar)
	local bg = bar:Get("bigwigs:KlixUI:bg")
	if bg then
		bg:ClearAllPoints()
		bg:SetParent(UIParent)
		bg:Hide()
		FreeBackgrounds[#FreeBackgrounds + 1] = bg
	end

	local ibg = bar:Get("bigwigs:KlixUI:ibg")
	if ibg then
		ibg:ClearAllPoints()
		ibg:SetParent(UIParent)
		ibg:Hide()
		FreeBackgrounds[#FreeBackgrounds + 1] = ibg
	end

	--Reset Positions
	--Icon
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("TOPLEFT")
	bar.candyBarIconFrame:SetPoint("BOTTOMLEFT")
	bar.candyBarIconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)

	--Status Bar
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar.SetPoint = nil
	bar.candyBarBar:SetPoint("TOPRIGHT")
	bar.candyBarBar:SetPoint("BOTTOMRIGHT")

	--BG
	bar.candyBarBackground:SetAllPoints()
end

local function ApplyStyle(bar)
	if E.private.KlixUI.skins.addonSkins.bw ~= true or not T.IsAddOnLoaded("BigWigs") then return end
	-- general bar settings
	bar:SetHeight(buttonsize)

	local bg
	if #FreeBackgrounds > 0 then
		bg = T.table_remove(FreeBackgrounds)
	else
		bg = CreateBG()
	end

	bg:SetParent(bar)
	bg:SetFrameStrata(bar:GetFrameStrata())
	bg:SetFrameLevel(bar:GetFrameLevel() - 1)
	bg:ClearAllPoints()
	bg:SetOutside(bar)
	bg:SetTemplate("Transparent")
	bg:Show()
	bar:Set("bigwigs:KlixUI:bg", bg)

	if bar.candyBarIconFrame:GetTexture() then
		local ibg
		if #FreeBackgrounds > 0 then
			ibg = T.table_remove(FreeBackgrounds)
		else
			ibg = CreateBG()
		end
		ibg:SetParent(bar)
		ibg:SetFrameStrata(bar:GetFrameStrata())
		ibg:SetFrameLevel(bar:GetFrameLevel() - 1)
		ibg:ClearAllPoints()
		ibg:SetOutside(bar.candyBarIconFrame)
		ibg:SetBackdropColor(0, 0, 0, 0)
		ibg:Show()
		bar:Set("bigwigs:KlixUI:ibg", ibg)
	end

	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.SetPoint = KUI.dummy

	bar.candyBarBackground:SetTexture(T.unpack(E.media.backdropcolor))

	local height = bar:GetHeight()
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", (E.PixelMode and -3 or -5) or -3, 0)
	bar.candyBarIconFrame:SetSize(height, height)
	bar.candyBarIconFrame:SetTexCoord(T.unpack(E.TexCoords))

	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 2, 0)
	bar.candyBarLabel:SetPoint("RIGHT", bar, "RIGHT", -2, 0)

	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("LEFT", bar, "LEFT", 2, 0)
	bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", -2, 0)
end

local f = T.CreateFrame("Frame")
local function RegisterStyle()
	if not BigWigs then return end
	local styleName = "|cfff960d9KlixUI|r"
	local bars = BigWigs:GetPlugin("Bars", true)
	if not bars then return end
	bars:RegisterBarStyle(styleName, {
		apiVersion = 1,
		version = 10,
		GetSpacing = function() return (E.PixelMode and 4 or 8) or 4 end,
		ApplyStyle = ApplyStyle,
		BarStopped = FreeStyle,
		GetStyleName = function() return styleName end,
	})
	bars.defaultDB.barStyle = styleName
end
f:RegisterEvent("ADDON_LOADED")

local reason = nil
f:SetScript("OnEvent", function(self, event, msg)
	if event == "ADDON_LOADED" then
		if not reason then reason = (T.select(6, T.GetAddOnInfo("BigWigs_Plugins"))) end
		if (reason == "MISSING" and msg == "BigWigs") or msg == "BigWigs_Plugins" then
			RegisterStyle()
		end
	end
end)