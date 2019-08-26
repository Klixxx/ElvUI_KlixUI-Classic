local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")
local LCG = LibStub('LibCustomGlow-1.0')

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local InCombat , a, f, _, id, cns, ncns, l, n, q, o, w = false, ...
local nQ = T.CreateFrame("Frame", a)
function f.PLAYER_LOGIN()
	_G.WorldMapTitleButton:HookScript('OnClick', function(_, b, d)
		if b == "LeftButton" and not d then
			local mainlist, tasks, other = {}, {}, {}
			for i = 1, 1000 do
				_, _, _, _, _, _, _, id, _, _, _, _, _, cns, _, ncns = T.GetQuestLogTitle(i)
				l = T.GetQuestLink(id)
				if l then
					if ncns then
						T.table_insert(other,l)
					elseif cns then
						T.table_insert(tasks,l)
					else
						T.table_insert(mainlist,l)
					end
				end
			end
		end
	end)
end

function f.PLAYER_REGEN_DISABLED()
	InCombat = true
end
function f.PLAYER_REGEN_ENABLED()
	InCombat = false
end
function f.QUEST_LOG_UPDATE()
	local questNum, q, o
	local block = _G.ObjectiveTrackerBlocksFrame
	local frame = _G.ObjectiveTrackerFrame

	if not T.InCombatLockdown() then
		questNum = T.select(2, T.GetNumQuestLogEntries())
		if questNum >= (MAX_QUESTS - 5) then -- go red
			q = T.string_format("|cffff0000%d/%d|r %s", questNum, MAX_QUESTS, TRACKER_HEADER_QUESTS)
			o = T.string_format("|cffff0000%d/%d|r %s", questNum, MAX_QUESTS, OBJECTIVES_TRACKER_LABEL)
		else
			q = T.string_format("%d/%d %s", questNum, MAX_QUESTS, TRACKER_HEADER_QUESTS)
			o = T.string_format("%d/%d %s", questNum, MAX_QUESTS, OBJECTIVES_TRACKER_LABEL)
		end
		block.QuestHeader.Text:SetText(q)
		frame.HeaderMenu.Title:SetText(o)
	end
end

local function styleObjectiveTracker()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.KlixUI.skins.blizzard.objectiveTracker ~= true then return end

	-- Add Panels
	hooksecurefunc("ObjectiveTracker_Update", function()
		local Frame = _G.ObjectiveTrackerFrame.MODULES

		if (Frame) then
			for i = 1, #Frame do

				local Modules = Frame[i]
				if (Modules) then
					local Header = Modules.Header
					Header:SetFrameStrata("LOW")

					if not (Modules.IsSkinned) then
						local HeaderPanel = T.CreateFrame("Frame", nil, Modules.Header)
						HeaderPanel:SetFrameLevel(Modules.Header:GetFrameLevel() - 1)
						HeaderPanel:SetFrameStrata("LOW")
						HeaderPanel:SetPoint("BOTTOMLEFT", 0, 3)
						HeaderPanel:SetSize(210, 3)
						KS:SkinPanel(HeaderPanel)

						Modules.IsSkinned = true
					end
				end
			end
		end
	end)

	-- Skin POI Buttons
	--[[hooksecurefunc("QuestPOI_GetButton", function(parent, questID, style, index)
		local Incomplete = _G.ObjectiveTrackerBlocksFrame.poiTable["numeric"]
		local Complete = _G.ObjectiveTrackerBlocksFrame.poiTable["completed"]

		for i = 1, #Incomplete do
			local Button = _G.ObjectiveTrackerBlocksFrame.poiTable["numeric"][i]

			if Button and not Button.IsSkinned then
				Button.NormalTexture:SetTexture("")
				Button.PushedTexture:SetTexture("")
				Button.HighlightTexture:SetTexture("")
				Button.Glow:SetAlpha(0)
				Button:CreateBackdrop("Transparent")
				S:HandleButton(Button)

				Button.IsSkinned = true
			end
		end

		for i = 1, #Complete do
			local Button = _G.ObjectiveTrackerBlocksFrame.poiTable["completed"][i]

			if Button and not Button.IsSkinned then
				Button.NormalTexture:SetTexture("")
				Button.PushedTexture:SetTexture("")
				Button.FullHighlightTexture:SetTexture("")
				Button.Glow:SetAlpha(0)
				Button:CreateBackdrop("Transparent")
				S:HandleButton(Button)

				Button.IsSkinned = true
			end
		end
	end)

	hooksecurefunc("QuestPOI_SelectButton", function(poiButton)
		local Backdrop = poiButton.backdrop

		if Backdrop then
			local ID = T.GetQuestLogIndexByID(poiButton.questID)
			local Level = T.select(2, T.GetQuestLogTitle(ID))
			local Color = T.GetQuestDifficultyColor(Level) or {r = 1, g = 1, b = 0, a = 1}
			local Number = poiButton.Number

			if PreviousPOI then
				PreviousPOI:SetBackdropColor(T.unpack(E.media.backdropcolor))
				PreviousPOI.backdrop:SetBackdropBorderColor(T.unpack(E.media.bordercolor))
				if E.db.KlixUI.general.OTGlow then
					LCG.PixelGlow_Stop(PreviousPOI)
				end
			end

			poiButton.backdrop:SetBackdropBorderColor(Color.r, Color.g, Color.b)
			poiButton:SetBackdropColor(0/255, 152/255, 34/255, 1)

			PreviousPOI = poiButton
			if E.db.KlixUI.general.OTGlow then
				LCG.PixelGlow_Start(poiButton, {r, g, b, 1}, nil, -0.25, nil, 1)
			end
		end
	end)]]

	local function SkinAutoQuestPopUpBlock()
		for i = 1, T.GetNumAutoQuestPopUps() do
			local ID, type = T.GetAutoQuestPopUp(i)
			local Title = T.GetQuestLogTitle(T.GetQuestLogIndexByID(ID))

			if Title and Title ~= "" then
				local Block = _G.AUTO_QUEST_POPUP_TRACKER_MODULE:GetBlock(ID)

				if Block then
					local Frame = Block.ScrollChild

					if not Frame.IsSkinned then
						Frame:SetSize(227, 68)
						Frame:CreateBackdrop("Transparent")
						Frame.backdrop:SetPoint("TOPLEFT", Frame, 40, -4)
						Frame.backdrop:SetPoint("BOTTOMRIGHT", Frame, 0, 4)
						Frame.backdrop:SetFrameLevel(0)
						Frame.backdrop:SetTemplate("Transparent")

						Frame.FlashFrame.IconFlash:Hide()

						Frame.QuestName:SetPoint("LEFT", Frame.QuestIconBg, "RIGHT", -6, 0)
						Frame.QuestName:SetPoint("RIGHT", -8, 0)
						Frame.TopText:SetPoint("LEFT", Frame.QuestIconBg, "RIGHT", -6, 0)
						Frame.TopText:SetPoint("RIGHT", -8, 0)
						Frame.BottomText:SetPoint("BOTTOM", 0, 8)
						Frame.BottomText:SetPoint("LEFT", Frame.QuestIconBg, "RIGHT", -6, 0)
						Frame.BottomText:SetPoint("RIGHT", -8, 0)

						Frame.IsSkinned = true
					end

					if type == "COMPLETE" then
						Frame.QuestIconBg:SetAlpha(0)
						Frame.QuestIconBadgeBorder:SetAlpha(0)
						Frame.QuestionMark:ClearAllPoints()
						Frame.QuestionMark:SetPoint("CENTER", Frame.backdrop, "LEFT", 10, 0)
						Frame.QuestionMark:SetParent(Frame.backdrop)
						Frame.QuestionMark:SetDrawLayer("OVERLAY", 7)
						Frame.IconShine:Hide()
					elseif type == "OFFER" then
						Frame.QuestIconBg:SetAlpha(0)
						Frame.QuestIconBadgeBorder:SetAlpha(0)
						Frame.Exclamation:ClearAllPoints()
						Frame.Exclamation:SetPoint("CENTER", Frame.backdrop, "LEFT", 10, 0)
						Frame.Exclamation:SetParent(Frame.backdrop)
						Frame.Exclamation:SetDrawLayer("OVERLAY", 7)
					end

					Frame.FlashFrame:Hide()
					Frame.Bg:Hide()

					for _, v in T.pairs({Frame.BorderTopLeft, Frame.BorderTopRight, Frame.BorderBotLeft, Frame.BorderBotRight, Frame.BorderLeft, Frame.BorderRight, Frame.BorderTop, Frame.BorderBottom}) do
						v:Hide()
					end
				end
			end
		end
	end

	hooksecurefunc(_G.AUTO_QUEST_POPUP_TRACKER_MODULE, "Update", function(self)
		for _, block in T.next, self.usedBlocks do
			if not block.IsSkinned then
				SkinAutoQuestPopUpBlock(block)
				block.IsSkinned = true
			end
		end
	end)

	_G.ObjectiveTrackerFrame:SetSize(235, 140)
	_G.ObjectiveTrackerFrame.HeaderMenu:SetSize(10, 10)

	local ScenarioChallengeModeBlock = _G.ScenarioChallengeModeBlock
	local bg = T.select(3, ScenarioChallengeModeBlock:GetRegions())
	bg:Hide()
	ScenarioChallengeModeBlock:CreateBackdrop("Transparent")

	ScenarioChallengeModeBlock.TimerBGBack:Hide()
	ScenarioChallengeModeBlock.TimerBG:Hide()

	_G.ScenarioStageBlock:SetSize(201, 83)

	S:HandleButton(_G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton)

	nQ:RegisterEvent("PLAYER_LOGIN")
	nQ:RegisterEvent("PLAYER_REGEN_DISABLED")
	nQ:RegisterEvent("PLAYER_REGEN_ENABLED")
	nQ:RegisterEvent("QUEST_LOG_UPDATE")
	nQ:SetScript("OnEvent", function(_, event, ...)
		f[event](...)
	end)
end

S:AddCallback("KuiObjectiveTracker", styleObjectiveTracker)