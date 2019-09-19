local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local SOUNDKIT = _G.SOUNDKIT
local CLOSE = CLOSE

local ChangeLogData = {
	"Changes:",
		"• Added Chinese locales, thanks Cagemaker!",
		"• Added skin support for LFGShout addon.",
		"• Fixed various issues.",
		"• ",
		" ", -- Section space!
		-- "• ",
		
	"Notes:",
		"|cff00ffda• I'm looking for translators e.g. Spanish, French, Italian, Chinese, Taiwanese etc.\nPM me on discord if you want to contribute, to the UI!|r",
		--"• PlEASE DELETE THE OLD KLIXUI FOLDER BEFORE EXTRACTING THE NEW ONE!!",
		--"• 'Typing /kui will navigate you to the KlixUI configurations.'",
		-- "• ",
}

local function ModifiedString(string)
	local count = T.string_find(string, ":")
	local newString = string

	if count then
		local prefix = T.string_sub(string, 0, count)
		local suffix = T.string_sub(string, count + 1)
		local subHeader = T.string_find(string, "•")

		if subHeader then newString = T.tostring("|cFFFFFF00".. prefix .. "|r" .. suffix) else newString = T.tostring("|cfff960d9" .. prefix .. "|r" .. suffix) end
	end

	for pattern in T.string_gmatch(string, "('.*')") do newString = newString:gsub(pattern, "|cFFFF8800" .. pattern:gsub("'", "") .. "|r") end
	return newString
end

local function GetChangeLogInfo(i)
	for line, info in T.pairs(ChangeLogData) do
		if line == i then return info end
	end
end

function KUI:CreateChangelog()
	local frame = T.CreateFrame("Frame", "KlixUIChangeLog", E.UIParent)
	frame:SetPoint("CENTER")
	frame:SetSize(500, 350)
	frame:SetTemplate("Transparent")
	frame:Styling()
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:SetClampedToScreen(true)

	local icon = T.CreateFrame("Frame", nil, frame)
	icon:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 2)
	icon:SetSize(30, 30)
	icon:SetTemplate("Transparent")
	icon:Styling()
	icon.bg = icon:CreateTexture(nil, "ARTWORK")
	icon.bg:Point("TOPLEFT", 2, -2)
	icon.bg:Point("BOTTOMRIGHT", -2, 2)
	icon.bg:SetTexture(KUI.Logo)
	icon.bg:SetBlendMode("ADD")
	
	local title = T.CreateFrame("Frame", nil, frame)
	title:SetPoint("LEFT", icon, "RIGHT", 2, 0)
	title:SetSize(468, 30)
	title:SetTemplate("Transparent")
	title:Styling()
	title.text = title:CreateFontString(nil, "OVERLAY")
	title.text:SetPoint("CENTER", title, 0, -1)
	title.text:SetFont(E.media.normFont, 15, "OUTLINE")
	title.text:SetText(KUI.Title.."- ChangeLog version |cfff960d9"..KUI.Version)

	local close = T.CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	close:Point("BOTTOM", frame, "BOTTOM", 0, 10)
	close:SetText(CLOSE)
	close:SetSize(80, 20)
	close:SetScript("OnClick", function() frame:Hide() end)
	S:HandleButton(close)
	close:Disable()
	frame.close = close
	
	local warning = T.CreateFrame("Frame", nil, frame)
	warning:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 34)
	warning:SetSize(500, 20)
	warning:SetTemplate("Transparent")
	warning:Styling()
	warning.text = warning:CreateFontString(nil, "OVERLAY")
	warning.text:SetPoint("CENTER", warning, 0, 1)
	warning.text:SetFont(E.media.normFont, 12, "OUTLINE")
	warning.text:SetText("|cffff0000WARNING: Delete your old ElvUI_KlixUI folder before installing v"..KUI.Version.."!!|r")
	KUI:CreatePulse(warning, 1, 1)
	warning:Show() -- Use this to toggle this frame!
	
	local countdown = KUI:CreateText(close, "OVERLAY", 12, nil, "CENTER")
	countdown:SetPoint("LEFT", close.Text, "RIGHT", 3, 0)
	countdown:SetTextColor(DISABLED_FONT_COLOR:GetRGB())
	frame.countdown = countdown

	local offset = 4
	for i = 1, #ChangeLogData do
		local button = T.CreateFrame("Frame", "Button"..i, frame)
		button:SetSize(375, 16)
		button:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -offset)

		if i <= #ChangeLogData then
			local string = ModifiedString(GetChangeLogInfo(i))

			button.Text = button:CreateFontString(nil, "OVERLAY")
			button.Text:SetFont(E.media.normFont, 12, "OUTLINE")
			button.Text:SetText(string)
			button.Text:SetPoint("LEFT", 0, 0)
		end
		offset = offset + 16
	end
end

function KUI:CountDown()
	self.time = self.time - 1
	if self.time == 0 then
		KlixUIChangeLog.countdown:SetText("")
		KlixUIChangeLog.close:Enable()
		self:CancelAllTimers()
	else
		KlixUIChangeLog.countdown:SetText(T.string_format("(%s)", self.time))
	end
end

function KUI:ToggleChangeLog()
	if not KlixUIChangeLog then
		self:CreateChangelog()
	end
	T.PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF or 857)
	
	local fadeInfo = {}
	fadeInfo.mode = "IN"
	fadeInfo.timeToFade = 0.5
	fadeInfo.startAlpha = 0
	fadeInfo.endAlpha = 1
	E:UIFrameFade(KlixUIChangeLog, fadeInfo)
	
	self.time = 6
	self:CancelAllTimers()
	KUI:CountDown()
	self:ScheduleRepeatingTimer("CountDown", 1)
end

function KUI:CheckVersion(self)
	-- Don't show the frame if my install isn't finished
	--if E.db.KlixUI.installed == nil then return; end
	if not KUIDataDB["Version"] or (KUIDataDB["Version"] and KUIDataDB["Version"] ~= KUI.Version) then
		KUIDataDB["Version"] = KUI.Version
		KUI:ToggleChangeLog()
	end
end