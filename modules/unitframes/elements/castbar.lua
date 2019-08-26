local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KUIC = KUI:NewModule('KuiCastbar', 'AceTimer-3.0', 'AceEvent-3.0')
local UF = E:GetModule('UnitFrames')
local LSM = E.LSM or E.Libs.LSM

--Configure castbar text position and alpha
local function ConfigureText(unit, castbar)
	local db = E.db.KlixUI.unitframes.castbar.text

	if db.castText then
		castbar.Text:Show()
		castbar.Time:Show()
	else
		if (unit == 'target' and db.forceTargetText) then
			castbar.Text:Show()
			castbar.Time:Show()
		else
			castbar.Text:Hide()
			castbar.Time:Hide()
		end
	end

	-- Set position of castbar text according to chosen offsets
	castbar.Text:ClearAllPoints()
	castbar.Time:ClearAllPoints()
	if db.yOffset ~= 0 then
		if unit == 'player' then
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, db.player.yOffset)
			castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, db.player.yOffset)
		elseif unit == 'target' then
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, db.target.yOffset)
			castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, db.target.yOffset)
		end
	else
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
		castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, 0)
	end
end

local function changeCastbarLevel(unit, unitframe)
	unitframe.Castbar:SetFrameStrata("LOW")
	unitframe.Castbar:SetFrameLevel(unitframe.InfoPanel:GetFrameLevel() + 10)
end

local function resetCastbarLevel(unit, unitframe)
	local db = E.db.unitframe.units[unit].castbar;
	if unit == 'player' or unit == 'target' then
		unitframe.Castbar:SetFrameStrata(E.db.unitframe.units[unit].castbar.strataAndLevel.frameStrata)
	end
	unitframe.Castbar:SetFrameLevel(6)
end

--Initiate update/reset of castbar
local function ConfigureCastbar(unit, unitframe)
	local db = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar

	if unit == 'player' or unit == 'target' then
		ConfigureText(unit, castbar)
		if unitframe.USE_INFO_PANEL and db.insideInfoPanel then
			if E.db.KlixUI.unitframes.castbar.text.ShowInfoText then
				changeCastbarLevel(unit, unitframe)
			else
				resetCastbarLevel(unit, unitframe)
			end
		else
			resetCastbarLevel(unit, unitframe)
		end
	end
end

--Initiate update of unit
function KUIC:UpdateSettings(unit)
	if unit == 'player' or unit == 'target' then
		local unitFrameName = "ElvUF_"..E:StringTitle(unit)
		local unitframe = _G[unitFrameName]
		ConfigureCastbar(unit, unitframe)
	end
end

-- Function to be called when registered events fire
function KUIC:UpdateAllCastbars()
	KUIC:UpdateSettings("player")
	KUIC:UpdateSettings("target")
	KUIC:UpdateSettings("focus")
	KUIC:UpdateSettings("pet")
	KUIC:UpdateSettings("arena")
	KUIC:UpdateSettings("boss")
end

--Castbar texture
function KUIC:PostCast(unit, unitframe)
	local db = E.db.KlixUI.unitframes.castbar.text

	local castTexture = LSM:Fetch("statusbar", E.db.KlixUI.unitframes.textures.castbar)
	local pr, pg, pb, pa = KUI:unpackColor(db.player.textColor)
	local tr, tg, tb, ta = KUI:unpackColor(db.target.textColor)

	if not self.isTransparent then
		self:SetStatusBarTexture(castTexture)
	end

	if unit == 'player' then
		self.Text:SetTextColor(pr, pg, pb, pa)
		self.Time:SetTextColor(pr, pg, pb, pa)
	elseif unit == 'target' then
		self.Text:SetTextColor(tr, tg, tb, ta)
		self.Time:SetTextColor(tr, tg, tb, ta)	
	end
end

function KUIC:CastBarHooks()
	local units = {"Player", "Target", "Focus", "Pet"}
	for _, unit in T.pairs(units) do
		local unitframe = _G["ElvUF_"..unit];
		local castbar = unitframe and unitframe.Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", KUIC.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", KUIC.PostCast)
		end
	end

	for i = 1, 5 do
		local castbar = _G["ElvUF_Arena"..i].Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", KUIC.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", KUIC.PostCast)
		end
	end

	for i = 1, MAX_BOSS_FRAMES do
		local castbar = _G["ElvUF_Boss"..i].Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", KUIC.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", KUIC.PostCast)
		end
	end
end

function KUIC:Initialize()
	--ElvUI UnitFrames are not enabled, stop right here!
	if E.private.unitframe.enable ~= true then return end

	--Profile changed, update castbar overlay settings
	hooksecurefunc(E, "UpdateAll", function()
		--Delay it a bit to allow all db changes to take effect before we update
		self:ScheduleTimer('UpdateAllCastbars', 0.5)
	end)

	--Castbar was modified, re-apply settings
	hooksecurefunc(UF, "Configure_Castbar", function(self, frame, preventLoop)
		if preventLoop then return; end

		local unit = frame.unitframeType
		if unit and (unit == 'player' or unit == 'target') then
			KUIC:UpdateSettings(unit)
		end
	end)

	KUIC:CastBarHooks()
end

local function InitializeCallback()
	KUIC:Initialize()
end

KUI:RegisterModule(KUIC:GetName(), InitializeCallback)