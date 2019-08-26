local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KDT = KUI:NewModule('KuiDataTexts', 'AceEvent-3.0')
local DT = E:GetModule('DataTexts')
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
local LSM = E.LSM or E.Libs.LSM

DT.SetupTooltipKui = DT.SetupTooltip
function DT:SetupTooltip(panel)
	self:SetupTooltipKui(panel)
end

local lastPanel
local displayString = ''

local menu = {}
local menuDatatext
local menuFrame

local dataLayout = {
	['LeftChatDataPanel'] = {
		['left'] = 10,
		['middle'] = 5,
		['right'] = 2,
	},
	['RightChatDataPanel'] = {
		['left'] = 4,
		['middle'] = 3,
		['right'] = 11,
	},
	['KuiLeftChatDTPanel'] = {
		['left'] = 10,
		['middle'] = 5,
		['right'] = 2,
	},
	['KuiRightChatDTPanel'] = {
		['left'] = 4,
		['middle'] = 3,
		['right'] = 11,
	},
}

local dataStrings = {
	[10] = DAMAGE,
	[5] = HONOR,
	[2] = KILLING_BLOWS,
	[4] = DEATHS,
	[3] = HONORABLE_KILLS,
	[11] = SHOW_COMBAT_HEALING,
}

local name

function KDT:UPDATE_BATTLEFIELD_SCORE()
	lastPanel = self
	local pointIndex = dataLayout[self:GetParent():GetName()][self.pointIndex]
	for i=1, T.GetNumBattlefieldScores() do
		name = T.GetBattlefieldScore(i)
		if name == E.myname then
			self.text:SetFormattedText(displayString, dataStrings[pointIndex], E:ShortValue(T.select(pointIndex, T.GetBattlefieldScore(i))))
			break
		end
	end
end

function KDT:HideBattlegroundTexts()
	DT.ForceHideBGStats = true
	KDT:LoadDataTexts()
	E:Print(L["Battleground datatexts temporarily hidden, to show type /bgstats or right click the 'C' icon near the minimap."])
end

function DT:LoadDataTexts()
	self.db = E.db.datatexts
	for name, obj in LDB:DataObjectIterator() do
		LDB:UnregisterAllCallbacks(self)
	end

	local inInstance, instanceType = T.IsInInstance()
	local fontTemplate = LSM:Fetch("font", self.db.font)
	for panelName, panel in pairs(DT.RegisteredPanels) do
		--Restore Panels
		for i=1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			panel.dataPanels[pointIndex]:UnregisterAllEvents()
			panel.dataPanels[pointIndex]:SetScript('OnUpdate', nil)
			panel.dataPanels[pointIndex]:SetScript('OnEnter', nil)
			panel.dataPanels[pointIndex]:SetScript('OnLeave', nil)
			panel.dataPanels[pointIndex]:SetScript('OnClick', nil)
			panel.dataPanels[pointIndex].text:FontTemplate(fontTemplate, self.db.fontSize, self.db.fontOutline)
			panel.dataPanels[pointIndex].text:SetWordWrap(self.db.wordWrap)
			panel.dataPanels[pointIndex].text:SetText(nil)
			panel.dataPanels[pointIndex].pointIndex = pointIndex

			if (panelName == 'LeftChatDataPanel' or panelName == 'RightChatDataPanel' or panelName == 'KuiLeftChatDTPanel' or panelName == 'KuiRightChatDTPanel') and (inInstance and (instanceType == "pvp")) and not DT.ForceHideBGStats and E.db.datatexts.battleground then
				panel.dataPanels[pointIndex]:RegisterEvent('UPDATE_BATTLEFIELD_SCORE')
				panel.dataPanels[pointIndex]:SetScript('OnEvent', KDT.UPDATE_BATTLEFIELD_SCORE)
				panel.dataPanels[pointIndex]:SetScript('OnEnter', DT.BattlegroundStats)
				panel.dataPanels[pointIndex]:SetScript('OnLeave', DT.Data_OnLeave)
				panel.dataPanels[pointIndex]:SetScript('OnClick', KDT.HideBattlegroundTexts)
				KDT.UPDATE_BATTLEFIELD_SCORE(panel.dataPanels[pointIndex])
			else
				--Register Panel to Datatext
				for name, data in T.pairs(DT.RegisteredDataTexts) do
					for option, value in T.pairs(self.db.panels) do
						if value and T.type(value) == 'table' then
							if option == panelName and self.db.panels[option][pointIndex] and self.db.panels[option][pointIndex] == name then
								DT:AssignPanelToDataText(panel.dataPanels[pointIndex], data)
							end
						elseif value and T.type(value) == 'string' and value == name then
							if self.db.panels[option] == name and option == panelName then
								DT:AssignPanelToDataText(panel.dataPanels[pointIndex], data)
							end
						end
					end
				end
			end
		end
	end
	
	if DT.ForceHideBGStats then
		DT.ForceHideBGStats = nil;
	end
end

--function KUI:LoadDataTexts()
	--local db = E.db.KlixUI.datatexts

	--for panelName, panel in pairs(DT.RegisteredPanels) do
		--for i=1, panel.numPoints do
			--local pointIndex = DT.PointLocation[i]

			--Register Panel to Datatext
			--for name, data in T.pairs(DT.RegisteredDataTexts) do
				--for option, value in pairs(db.panels) do
					--if value and T.type(value) == "table" then
						--if option == panelName and db.panels[option][pointIndex] and db.panels[option][pointIndex] == name then
							--DT:AssignPanelToDataText(panel.dataPanels[pointIndex], data)
						--end
					--elseif value and T.type(value) == "string" and value == name then
						--if db.panels[option] == name and option == panelName then
							--DT:AssignPanelToDataText(panel.dataPanels[pointIndex], data)
						--end
					--end
				--end
			--end
		--end
	--end
--end
--hooksecurefunc(DT, "LoadDataTexts", KUI.LoadDataTexts)

local function ValueColorUpdate(hex)
	displayString = T.string_join("", "%s: ", hex, "%s|r")

	if lastPanel ~= nil then
		KDT.UPDATE_BATTLEFIELD_SCORE(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true


function KDT:GetPanelDatatextName()
	if menuPanel.numPoints == 1 then
		return E.db.datatexts.panels[menuPanel:GetName()]
	else
		local index = T.tonumber(T.string_match(menuDatatext:GetName(), "%d+"))
		local pointIndex = DT.PointLocation[index]
		return E.db.datatexts.panels[menuPanel:GetName()][pointIndex]
	end
end

function KDT:ChangeDatatext(name)
	if menuPanel.numPoints == 1 then
		E.db.datatexts.panels[menuPanel:GetName()] = name
	else
		local index = T.tonumber(T.string_match(menuDatatext:GetName(), "%d+"))
		local pointIndex = DT.PointLocation[index]
		E.db.datatexts.panels[menuPanel:GetName()][pointIndex] = name
	end

	DT:LoadDataTexts()	
end

function KDT:UpdateCheckedMenuOption()
	local current = KDT:GetPanelDatatextName()
	for _, v in T.ipairs(menu) do
		v.checked = false
		if (v.text == current) or (v.text == 'None' and current == '') then
			v.checked = true
		end
	end
end

local enhancedClickMenu = function(self, button)
	menuDatatext = self
	menuPanel = DT.RegisteredPanels[self:GetParent():GetName()]

	if button == "RightButton" and T.IsAltKeyDown() and T.IsControlKeyDown() then
		menuFrame.point = "BOTTOM"
		menuFrame.relativePoint = "TOP"
		
		KDT:UpdateCheckedMenuOption()
		
		T.EasyMenu(menu, menuFrame, menuDatatext, 0 , 3, "MENU", 2);			
	else
		local data = DT.RegisteredDataTexts[KDT:GetPanelDatatextName()]
		if data and data['origOnClick'] then
			data['origOnClick'](self, button)
		end
	end
end

function KDT:ExtendClickFunction(data)
	if data['onClick'] then
		data['origOnClick'] = data['onClick']
	end
	data['onClick'] = enhancedClickMenu
end

function KDT:HookClickMenuToEmptyDataText()
	for panelName, panel in T.pairs(DT.RegisteredPanels) do
		for i=1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			local datatext = panel.dataPanels[pointIndex]
			local isSet
			if panel.numPoints == 1 then
				isSet = E.db.datatexts.panels[panelName]
			else
				if E.db.datatexts.panels[panelName] then
				    isSet = E.db.datatexts.panels[panelName][pointIndex] --20141124
				else
				    isSet = ''
				end				
			end
			if not isSet or isSet == '' then
				datatext:SetScript('OnClick', enhancedClickMenu)
			end
		end		
	end
end

function KDT:Initialize()

	DT:LoadDataTexts()
	--KUI:LoadDataTexts()
	
	menuFrame = T.CreateFrame("Frame", "KDTMenuFrame", E.UIParent, "UIDropDownMenuTemplate")
	menuFrame:SetTemplate("Transparent")
	
	-- extend datatext click function
	for name, data in T.pairs(DT.RegisteredDataTexts) do
	 	KDT:ExtendClickFunction(DT.RegisteredDataTexts[name])
	end
	
	-- hook function for datatexts that are added later
	hooksecurefunc(DT, "RegisterDatatext", function(self, name)
		KDT:ExtendClickFunction(DT.RegisteredDataTexts[name])	
	end)
	
	hooksecurefunc(DT, "LoadDataTexts", function()
		T.table_wipe(menu)
		for name, _ in T.pairs(DT.RegisteredDataTexts) do
			T.table_insert(menu, { text = name, func = function() KDT:ChangeDatatext(name) end, checked = false })
		end
		T.table_sort(menu, function(a,b) return a.text < b.text end)
		T.table_insert(menu, 1, { text = 'None', func = function() KDT:ChangeDatatext('') end, checked = false })
		
		KDT:HookClickMenuToEmptyDataText()
	end)
end

local function InitializeCallback()
	KDT:Initialize()
end

KUI:RegisterModule(KDT:GetName(), InitializeCallback)