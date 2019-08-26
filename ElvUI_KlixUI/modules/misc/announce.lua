-------------------------------------------------------------------------------
-- Credits: Alleykat
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KAN = KUI:NewModule("KuiAnnounce", "AceEvent-3.0")
local LSM = E.LSM

local iconsize = 24

function KAN:PLAYER_REGEN_ENABLED()
	if (T.UnitIsDead("player")) then return end
	self:AlertRun(LEAVING_COMBAT.." !", 0.1, 1, 0.1)
end

function KAN:PLAYER_REGEN_DISABLED()
	if (T.UnitIsDead("player")) then return end
	self:AlertRun(ENTERING_COMBAT.." !", 1, 0.1, 0.1)
end

function KAN:CHAT_MSG_SKILL(event, message)
	UIErrorsFrame:AddMessage(message, ChatTypeInfo["SKILL"].r, ChatTypeInfo["SKILL"].g, ChatTypeInfo["SKILL"].b)
end

local speed = .057799924 -- how fast the text appears
local font = LSM:Fetch("font", "Expressway")
local fontflag = "OUTLINE" -- for pixelfont stick to this else OUTLINE or THINOUTLINE
local fontsize = 24 -- font size

local GetNextChar = function(word,num)
	local c = word:byte(num)
	local shift
	if not c then return "",num end
	if (c > 0 and c <= 127) then
		shift = 1
	elseif (c >= 192 and c <= 223) then
		shift = 2
	elseif (c >= 224 and c <= 239) then
		shift = 3
	elseif (c >= 240 and c <= 247) then
		shift = 4
	end
	return word:sub(num,num+shift-1),(num+shift)
end

local updaterun = T.CreateFrame("Frame")

local flowingframe = T.CreateFrame("Frame", nil, E.UIParent)
flowingframe:SetFrameStrata("HIGH")
flowingframe:SetPoint("CENTER", E.UIParent, 0, 140) -- where we want the textframe
flowingframe:SetHeight(64)

local flowingtext = flowingframe:CreateFontString(nil,"OVERLAY")
flowingtext:SetFont(font, fontsize, fontflag)
flowingtext:SetShadowOffset(1.5, -1.5)

local rightchar = flowingframe:CreateFontString(nil,"OVERLAY")
rightchar:SetFont(font, 60, fontflag)
rightchar:SetShadowOffset(1.5, -1.5)
rightchar:SetJustifyH("LEFT") -- left or right

local count, len, step, word, stringE, a, backstep

local nextstep = function()
	a,step = GetNextChar (word,step)
	flowingtext:SetText(stringE)
	stringE = stringE..a
	a = T.string_upper(a)
	rightchar:SetText(a)
end

local backrun = T.CreateFrame("Frame")
backrun:Hide()

local updatestring = function(self,t)
	count = count - t
	if count < 0 then
		count = speed
		if step > len then
			self:Hide()
			flowingtext:SetText(stringE)
			rightchar:SetText()
			flowingtext:ClearAllPoints()
			flowingtext:SetPoint("RIGHT")
			flowingtext:SetJustifyH("RIGHT")
			rightchar:ClearAllPoints()
			rightchar:SetPoint("RIGHT",flowingtext,"LEFT")
			rightchar:SetJustifyH("RIGHT")
			self:Hide()
			count = 1.456789
			backrun:Show()
		else
			nextstep()
		end
	end
end

updaterun:SetScript("OnUpdate",updatestring)
updaterun:Hide()

local backstepf = function()
	local a = backstep
	local firstchar
	local texttemp = ""
	local flagon = true
	while a <= len do
		local u
		u,a = GetNextChar(word,a)
		if flagon == true then
			backstep = a
			flagon = false
			firstchar = u
		else
			texttemp = texttemp..u
		end
	end
	flowingtext:SetText(texttemp)
	firstchar = T.string_upper(firstchar)
	rightchar:SetText(firstchar)
end

local rollback = function(self,t)
	count = count - t
	if count < 0 then
		count = speed
		if backstep > len then
			self:Hide()
			flowingtext:SetText()
			rightchar:SetText()
		else
			backstepf()
		end
	end
end

backrun:SetScript("OnUpdate",rollback)

function KAN:AlertRun(f, r, g, b)
	flowingframe:Hide()
	updaterun:Hide()
	backrun:Hide()

	flowingtext:SetText(f)
	local l = flowingtext:GetWidth()

	local color1 = r or 1
	local color2 = g or 1
	local color3 = b or 1

	flowingtext:SetTextColor(color1*.95, color2*.95, color3*.95) -- color in RGB(red green blue)(alpha)
	rightchar:SetTextColor(color1, color2, color3)

	word = f
	len = f:len()
	step,backstep = 1,1
	count = speed
	stringE = ""
	a = ""

	flowingtext:SetText("")
	flowingframe:SetWidth(l)
	flowingtext:ClearAllPoints()
	flowingtext:SetPoint("LEFT")
	flowingtext:SetJustifyH("LEFT")
	rightchar:ClearAllPoints()
	rightchar:SetPoint("LEFT",flowingtext,"RIGHT")
	rightchar:SetJustifyH("LEFT")

	rightchar:SetText("")
	updaterun:Show()
	flowingframe:Show()
end

function KAN:Initialize()
	if E.db.KlixUI.misc.combatState then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	end

	if E.db.KlixUI.misc.skillGains then
		self:RegisterEvent("CHAT_MSG_SKILL")
	end
	
	T.SetCVar("floatingCombatTextCombatState", "1")
end

local function InitializeCallback()
	KAN:Initialize()
end

KUI:RegisterModule(KAN:GetName(), InitializeCallback)