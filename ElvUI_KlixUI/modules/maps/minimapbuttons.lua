local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local SMB = KUI:NewModule("KuiSquareMinimapButtons", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

SMB.Buttons = {}

local ignoreButtons = {
	'GameTimeFrame',
	'HelpOpenWebTicketButton',
	'MiniMapVoiceChatFrame',
	'TimeManagerClockButton',
	'BattlefieldMinimap',
	'ButtonCollectFrame',
	'GameTimeFrame',
	'QueueStatusMinimapButton',
	'MiniMapMailFrame',
	'MiniMapTracking',
	'TukuiMinimapZone',
	'TukuiMinimapCoord',
	'TukuiMinimapCoord',
	'Questie',
	'Guidelime',
}

local GenericIgnores = {
	'Archy',
	'GatherMatePin',
	'GatherNote',
	'GuildInstance',
	'HandyNotesPin',
	'MiniMap',
	'Spy_MapNoteList_mini',
	'ZGVMarker',
	'poiMinimap',
	'GuildMap3Mini',
	'LibRockConfig-1.0_MinimapButton',
	'NauticusMiniIcon',
	'WestPointer',
	'Cork',
	'DugisArrowMinimapPoint',
}

local PartialIgnores = { 'Node', 'Note', 'Pin', 'POI' }

local ButtonFunctions = { 'SetParent', 'ClearAllPoints', 'SetPoint', 'SetSize', 'SetScale', 'SetFrameStrata', 'SetFrameLevel' }

function SMB:LockButton(Button)
	for _, Function in T.pairs(ButtonFunctions) do
		Button[Function] = KUI.dummy
	end
end

function SMB:UnlockButton(Button)
	for _, Function in T.pairs(ButtonFunctions) do
		Button[Function] = nil
	end
end

function SMB:HandleBlizzardButtons()
	if not SMB.db.enable then return end

	if SMB.db.moveMail and not _G.MiniMapMailFrame.SMB then
		local Frame = T.CreateFrame('Frame', 'SMB_MailFrame', self.Bar)
		Frame:SetSize(SMB.db.iconSize, SMB.db.iconSize)
		Frame:SetTemplate()
		Frame.Icon = Frame:CreateTexture(nil, 'ARTWORK')
		Frame.Icon:SetPoint('CENTER')
		Frame.Icon:Size(18)
		Frame.Icon:SetTexture(_G.MiniMapMailIcon:GetTexture())
		Frame:EnableMouse(true)
		Frame:HookScript('OnEnter', function(self)
			if T.HasNewMail() then
				_G.GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
				if _G.GameTooltip:IsOwned(self) then
					T.MinimapMailFrameUpdate()
				end
			end
			self:SetBackdropBorderColor(T.unpack(E.media.rgbvaluecolor))
			if SMB.Bar:IsShown() then
				T.UIFrameFadeIn(SMB.Bar, 0.2, SMB.Bar:GetAlpha(), 1)
			end
		end)
		Frame:HookScript('OnLeave', function(self)
			_G.GameTooltip:Hide()
			self:SetTemplate()
			if SMB.Bar:IsShown() and SMB.db.BarMouseOver then
				T.UIFrameFadeOut(SMB.Bar, 0.2, SMB.Bar:GetAlpha(), 0)
			end
		end)
		_G.MiniMapMailFrame:HookScript('OnShow', function() Frame.Icon:SetVertexColor(0, 1, 0)	end)
		_G.MiniMapMailFrame:HookScript('OnHide', function() Frame.Icon:SetVertexColor(1, 1, 1) end)

		-- Hide Icon & Border
		_G.MiniMapMailIcon:Hide()
		_G.MiniMapMailBorder:Hide()

		_G.MiniMapMailFrame.SMB = true
		T.table_insert(self.Buttons, Frame)
	end
	
	if SMB.db.moveTracker and not _G.MiniMapTrackingButton.SMB then
		_G.MiniMapTracking.Show = nil

		_G.MiniMapTracking:Show()

		_G.MiniMapTracking:SetParent(self.Bar)
		_G.MiniMapTracking:SetSize(SMB.db.iconSize, SMB.db.iconSize)

		_G.MiniMapTrackingIcon:ClearAllPoints()
		_G.MiniMapTrackingIcon:SetPoint('CENTER')

		_G.MiniMapTrackingBackground:SetAlpha(0)
		_G.MiniMapTrackingIconOverlay:SetAlpha(0)
		_G.MiniMapTrackingButton:SetAlpha(0)

		_G.MiniMapTrackingButton:SetParent(MinimapTracking)
		_G.MiniMapTrackingButton:ClearAllPoints()
		_G.MiniMapTrackingButton:SetAllPoints(_G.MiniMapTracking)

		_G.MiniMapTrackingButton:SetScript('OnMouseDown', nil)
		_G.MiniMapTrackingButton:SetScript('OnMouseUp', nil)

		_G.MiniMapTrackingButton:HookScript('OnEnter', function(self)
			_G.MiniMapTracking:SetBackdropBorderColor(T.unpack(E.media.rgbvaluecolor))
			if SMB.Bar:IsShown() then
				T.UIFrameFadeIn(SMB.Bar, 0.2, SMB.Bar:GetAlpha(), 1)
			end
		end)
		_G.MiniMapTrackingButton:HookScript('OnLeave', function(self)
			_G.MiniMapTracking:SetTemplate()
			if SMB.Bar:IsShown() and SMB.db.barMouseOver then
				T.UIFrameFadeOut(SMB.Bar, 0.2, SMB.Bar:GetAlpha(), 0)
			end
		end)

		_G.MiniMapTrackingButton.SMB = true
		T.table_insert(self.Buttons, _G.MiniMapTracking)
	end

	if SMB.db.moveQueue and not _G.QueueStatusMinimapButton.SMB then
		local Frame = T.CreateFrame('Frame', 'SMB_QueueFrame', self.Bar)
		Frame:SetTemplate()
		Frame:SetSize(SMB.db.iconSize, SMB.db.iconSize)
		Frame.Icon = Frame:CreateTexture(nil, 'ARTWORK')
		Frame.Icon:SetSize(SMB.db.iconSize, SMB.db.iconSize)
		Frame.Icon:SetPoint('CENTER')
		Frame.Icon:SetTexture([[Interface\LFGFrame\LFG-Eye]])
		Frame.Icon:SetTexCoord(0, 64 / 512, 0, 64 / 256)
		Frame:SetScript('OnMouseDown', function()
			if _G.PVEFrame:IsShown() then
				T.HideUIPanel(_G.PVEFrame)
			else
				T.ShowUIPanel(_G.PVEFrame)
				T.GroupFinderFrame_ShowGroupFrame()
			end
		end)
		Frame:HookScript('OnEnter', function(self)
			self:SetBackdropBorderColor(T.unpack(E.media.rgbvaluecolor))
			if SMB.Bar:IsShown() then
				T.UIFrameFadeIn(SMB.Bar, 0.2, SMB.Bar:GetAlpha(), 1)
			end
		end)
		Frame:HookScript('OnLeave', function(self)
			self:SetTemplate()
			if SMB.Bar:IsShown() and SMB.db.barMouseOver then
				T.UIFrameFadeOut(SMB.Bar, 0.2, SMB.Bar:GetAlpha(), 0)
			end
		end)

		_G.QueueStatusMinimapButton:SetParent(self.Bar)
		_G.QueueStatusMinimapButton:SetFrameLevel(Frame:GetFrameLevel() + 2)
		_G.QueueStatusMinimapButton:ClearAllPoints()
		_G.QueueStatusMinimapButton:SetPoint("CENTER", Frame, "CENTER", 0, 0)

		_G.QueueStatusMinimapButton:SetHighlightTexture(nil)

		_G.QueueStatusMinimapButton:HookScript('OnShow', function(self)
			Frame:EnableMouse(false)
		end)
		_G.QueueStatusMinimapButton:HookScript('PostClick', T.QueueStatusMinimapButton_OnLeave)
		_G.QueueStatusMinimapButton:HookScript('OnHide', function(self)
			Frame:EnableMouse(true)
		end)

		_G.QueueStatusMinimapButton.SMB = true
		T.table_insert(self.Buttons, Frame)
	end
		
	self:Update()
end

function SMB:SkinMinimapButton(Button)
	if (not Button) or Button.isSkinned then return end

	local Name = Button:GetName()
	if not Name then return end

	if T.tContains(ignoreButtons, Name) then return end

	for i = 1, #GenericIgnores do
		if T.string_sub(Name, 1, T.string_len(GenericIgnores[i])) == GenericIgnores[i] then return end
	end

	for i = 1, #PartialIgnores do
		if T.string_find(Name, PartialIgnores[i]) ~= nil then return end
	end

	for i = 1, Button:GetNumRegions() do
		local Region = T.select(i, Button:GetRegions())
		if Region.IsObjectType and Region:IsObjectType('Texture') then
			local Texture = T.string_lower(T.tostring(Region:GetTexture()))

			if (T.string_find(Texture, "interface\\characterframe") or T.string_find(Texture, "interface\\minimap") or T.string_find(Texture, 'border') or T.string_find(Texture, 'background') or T.string_find(Texture, 'alphamask') or T.string_find(Texture, 'highlight')) then
				Region:SetTexture(nil)
				Region:SetAlpha(0)
			else
				if Name == 'BagSync_MinimapButton' then
					Region:SetTexture('Interface\\AddOns\\BagSync\\media\\icon')
				elseif Name == 'LibDBIcon10_DBM' then
					Region:SetTexture('Interface\\Icons\\INV_Helmet_87')
				elseif Name == 'OutfitterMinimapButton' then
					if Texture == 'interface\\addons\\outfitter\\textures\\minimapbutton' then
						Region:SetTexture(nil)
					end
				elseif Name == 'SmartBuff_MiniMapButton' then
					Region:SetTexture('Interface\\Icons\\Spell_Nature_Purge')
				elseif Name == 'VendomaticButtonFrame' then
					Region:SetTexture('Interface\\Icons\\INV_Misc_Rabbit_2')
				end
				Region:ClearAllPoints()
				Region:SetInside()
				Region:SetTexCoord(T.unpack(self.TexCoords))
				Button:HookScript('OnLeave', function() Region:SetTexCoord(T.unpack(self.TexCoords)) end)
				Region:SetDrawLayer('ARTWORK')
				Region.SetPoint = function() return end
			end
		end
	end
	
	Button:CreateIconShadow()
	Button:SetFrameLevel(_G.Minimap:GetFrameLevel() + 5)
	Button:SetSize(SMB.db.iconSize, SMB.db.iconSize)
	Button:SetTemplate()
	Button:HookScript('OnEnter', function(self)
		self:SetBackdropBorderColor(T.unpack(E.media.rgbvaluecolor))
		if SMB.Bar:IsShown() then
			T.UIFrameFadeIn(SMB.Bar, 0.2, SMB.Bar:GetAlpha(), 1)
		end
	end)
	Button:HookScript('OnLeave', function(self)
		self:SetTemplate()
		if SMB.Bar:IsShown() and SMB.db.barMouseOver then
			T.UIFrameFadeOut(SMB.Bar, 0.2, SMB.Bar:GetAlpha(), 0)
		end
	end)

	Button.isSkinned = true
	T.table_insert(self.Buttons, Button)
end

function SMB:GrabMinimapButtons()
	if T.InCombatLockdown() then return end

	for _, Frame in T.pairs({ _G.Minimap, _G.MinimapBackdrop }) do
		local NumChildren = Frame:GetNumChildren()
		if NumChildren < (Frame.SMBNumChildren or 0) then return end
		for i = 1, NumChildren do
			local object = T.select(i, Frame:GetChildren())
			if object then
				local name = object:GetName()
				local width = object:GetWidth()
				if name and width > 15 and width < 40 and (object:IsObjectType('Button') or object:IsObjectType('Frame')) then
					self:SkinMinimapButton(object)
				end
			end
		end
		Frame.SMBNumChildren = NumChildren
	end

	self:Update()
end

function SMB:Update()
	if not SMB.db.enable then return end

	local AnchorX, AnchorY, MaxX = 0, 1, SMB.db.buttonsPerRow or 8
	local ButtonsPerRow = SMB.db.buttonsPerRow or 8
	local NumColumns = T.math_ceil(#SMB.Buttons / ButtonsPerRow)
	local Spacing, Mult = SMB.db.buttonSpacing or 2, 1
	local Size = SMB.db.iconSize or 20
	local ActualButtons, Maxed = 0

	if NumColumns == 1 and ButtonsPerRow > #SMB.Buttons then
		ButtonsPerRow = #SMB.Buttons
	end

	for _, Button in T.pairs(SMB.Buttons) do
		if Button:IsVisible() then
			AnchorX = AnchorX + 1
			ActualButtons = ActualButtons + 1
			if AnchorX > MaxX then
				AnchorY = AnchorY + 1
				AnchorX = 1
				Maxed = true
			end

			SMB:UnlockButton(Button)

			Button:SetTemplate()
			Button:SetParent(self.Bar)
			Button:ClearAllPoints()
			Button:SetPoint('TOPLEFT', self.Bar, 'TOPLEFT', (Spacing + ((Size + Spacing) * (AnchorX - 1))), (- Spacing - ((Size + Spacing) * (AnchorY - 1))))
			Button:SetSize(SMB.db['iconSize'], SMB.db['iconSize'])
			Button:SetScale(1)
			Button:SetFrameStrata('LOW')
			Button:SetFrameLevel(self.Bar:GetFrameLevel() + 1)
			Button:SetScript('OnDragStart', nil)
			Button:SetScript('OnDragStop', nil)

			SMB:LockButton(Button)

			if Maxed then ActualButtons = ButtonsPerRow end
		end
	end

	local BarWidth = (Spacing + ((Size * (ActualButtons * Mult)) + ((Spacing * (ActualButtons - 1)) * Mult) + (Spacing * Mult)))
	local BarHeight = (Spacing + ((Size * (AnchorY * Mult)) + ((Spacing * (AnchorY - 1)) * Mult) + (Spacing * Mult)))
	self.Bar:SetSize(BarWidth, BarHeight)

	if SMB.db.backdrop then
		self.Bar:SetTemplate("Transparent", true)
		self.Bar:Styling()
	else
		self.Bar:SetBackdrop(nil)
		if self.Bar.squares or self.Bar.gradient or self.Bar.mshadow then
			self.Bar.squares:SetTexture(nil)
			self.Bar.gradient:SetTexture(nil)
			self.Bar.mshadow:SetTexture(nil)
		end
	end

	if ActualButtons == 0 then
		self.Bar:Hide()
	else
		self.Bar:Show()
	end

	if SMB.db['barMouseOver'] then
		T.UIFrameFadeOut(self.Bar, 0.2, self.Bar:GetAlpha(), 0)
	else
		T.UIFrameFadeIn(self.Bar, 0.2, self.Bar:GetAlpha(), 1)
	end
end

function SMB:PLAYER_REGEN_DISABLED()
	if SMB.db.hideInCombat then SMB.Bar:Hide() end
end

function SMB:PLAYER_REGEN_ENABLED()
	if SMB.db.enable then SMB.Bar:Show() end
end

function SMB:UpdateVisibility()
	T.RegisterStateDriver(SMB.Bar, 'visibility', SMB.db.visibility)
end

function SMB:Initialize()
	if not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.buttons.enable then return end
	if T.IsAddOnLoaded("ProjectAzilroka") then return end

	SMB.db = E.db.KlixUI.maps.minimap.buttons

	SMB.Hider = T.CreateFrame("Frame", nil, UIParent)

	SMB.Bar = T.CreateFrame('Frame', 'SquareMinimapButtonBar', UIParent)
	SMB.Bar:Hide()
	
	if T.IsAddOnLoaded('XIV_Databar') then
		SMB.Bar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -10, -211)
	else
		SMB.Bar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -10, -196)
	end
	SMB.Bar:SetFrameStrata('LOW')
	SMB.Bar:SetClampedToScreen(true)
	SMB.Bar:SetMovable(true)
	SMB.Bar:EnableMouse(true)
	SMB.Bar:SetSize(SMB.db.iconSize, SMB.db.iconSize)
	SMB:UpdateVisibility()

	SMB.Bar:SetScript('OnEnter', function(self) T.UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1) end)
	SMB.Bar:SetScript('OnLeave', function(self)
		if SMB.db['barMouseOver'] then
			T.UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
		end
	end)

	function SMB:ForUpdateAll()
		SMB.db = E.db.KlixUI.maps.minimap.buttons
		SMB:Update()
	end
	SMB:ForUpdateAll()

	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	E:CreateMover(SMB.Bar, "KUI_SquareMinimapButtonBarMover", L["Square Minimap Buttons Bar"], nil, nil, nil, 'ALL,GENERAL,KLIXUI', nil, "KlixUI,modules,maps,minimap,buttons")

	SMB.TexCoords = {T.unpack(E.TexCoords)}

	SMB:ScheduleRepeatingTimer('GrabMinimapButtons', 6)
	SMB:ScheduleTimer('HandleBlizzardButtons', 7)
end

KUI:RegisterModule(SMB:GetName())