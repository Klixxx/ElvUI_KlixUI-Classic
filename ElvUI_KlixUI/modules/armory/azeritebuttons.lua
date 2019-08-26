local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local AZB = KUI:NewModule("AzeriteButtons", "AceEvent-3.0")
local S = E:GetModule('Skins')
local LCG = LibStub('LibCustomGlow-1.0')

function AZB:CreateAZbuttons()
	if not E.db.KlixUI.armory.azeritebtn then return end
	local function Head_OnEnter(self)
		GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["Open head slot azerite powers."])
		GameTooltip:Show()
	end

	local function Head_OnLeave(self)
		GameTooltip:Hide()
	end
	Hbtn = T.CreateFrame("Button", "headbtn", _G["PaperDollFrame"], "UIPanelButtonTemplate")
	Hbtn.text = KUI:CreateText(headbtn, "OVERLAY", 12, nil)
	Hbtn.text:SetPoint("CENTER")
	Hbtn.text:SetText(L["H"])
	Hbtn:SetScript('OnEnter', Head_OnEnter)
	Hbtn:SetScript('OnLeave', Head_OnLeave)
	Hbtn:SetScript("OnClick", function() AZB:openHead() end)
	S:HandleButton(headbtn)
	
	local function Shoulder_OnEnter(self)
		GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["Open shoulder slot azerite powers."])
		GameTooltip:Show()
	end

	local function Shoulder_OnLeave(self)
		GameTooltip:Hide()
	end
	Sbtn = T.CreateFrame("Button", "shoulderbtn", _G["PaperDollFrame"], "UIPanelButtonTemplate")
	Sbtn.text = KUI:CreateText(shoulderbtn, "OVERLAY", 12, nil)
	Sbtn.text:SetPoint("CENTER")
	Sbtn.text:SetText(L["S"])
	Sbtn:SetScript('OnEnter', Shoulder_OnEnter)
	Sbtn:SetScript('OnLeave', Shoulder_OnLeave)
	Sbtn:SetScript("OnClick", function() AZB:openShoulder() end)
	S:HandleButton(shoulderbtn)

	local function Chest_OnEnter(self)
		GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["Open chest slot azerite powers."])
		GameTooltip:Show()
	end

	local function Chest_OnLeave(self)
		GameTooltip:Hide()
	end
	Cbtn = T.CreateFrame("Button", "chestbtn", _G["PaperDollFrame"], "UIPanelButtonTemplate")
	Cbtn.text = KUI:CreateText(chestbtn, "OVERLAY", 12, nil)
	Cbtn.text:SetPoint("CENTER")
	Cbtn.text:SetText(L["C"])
	Cbtn:SetScript('OnEnter', Chest_OnEnter)
	Cbtn:SetScript('OnLeave', Chest_OnLeave)
	Cbtn:SetScript("OnClick", function() AZB:openChest() end)
	S:HandleButton(chestbtn)
	
	headbtn:SetFrameStrata("HIGH")
	headbtn:SetSize(20, 20)
		
	shoulderbtn:SetFrameStrata("HIGH")
	shoulderbtn:SetSize(20, 20)
		
	chestbtn:SetFrameStrata("HIGH")
	chestbtn:SetSize(20, 20)

	if T.IsAddOnLoaded("ElvUI_SLE") then
		headbtn:SetPoint("BOTTOMLEFT", _G["CharacterHeadSlot"], "TOPLEFT", -1, 4)
		shoulderbtn:SetPoint("BOTTOMLEFT", _G["CharacterHeadSlot"], "TOPLEFT", 20, 4)
		chestbtn:SetPoint("BOTTOMLEFT", _G["CharacterHeadSlot"], "TOPLEFT", 41, 4)
	else
		headbtn:SetPoint("BOTTOMLEFT", _G["CharacterHeadSlot"], "TOPLEFT", 0, 4)
		shoulderbtn:SetPoint("BOTTOMLEFT", _G["CharacterHeadSlot"], "TOPLEFT", 21, 4)
		chestbtn:SetPoint("BOTTOMLEFT", _G["CharacterHeadSlot"], "TOPLEFT", 42, 4)
	end
		
	if T.UnitLevel("player") <= 107 then
		headbtn:Hide()
		shoulderbtn:Hide()
		chestbtn:Hide()	
	end
end

function AZB:PLAYER_ENTERING_WORLD()
	AZB:buttonHightlight()
end

function AZB:PLAYER_EQUIPMENT_CHANGED()
	AZB:buttonHightlight()
end

function AZB:UNIT_INVENTORY_CHANGED()
	AZB:buttonHightlight()
end

function AZB:AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED()
	AZB:buttonHightlight()
end

function AZB:buttonHightlight()
	local itemLocation = ItemLocation:CreateFromEquipmentSlot(1);
	if T.C_Item_DoesItemExist(itemLocation) and T.C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem(itemLocation) then
		if T.C_AzeriteEmpoweredItem_HasAnyUnselectedPowers(itemLocation) then
			if T.IsAddOnLoaded("ElvUI_SLE") then
				LCG.PixelGlow_Start(headbtn, color, nil, -0.25, nil, 2)
			else
				local r, g, b = T.unpack(E["media"].rgbvaluecolor)
				local color = {r,g,b,1}
				LCG.PixelGlow_Start(headbtn, color, nil, -0.25, nil, 2)
			end
		else
			if T.IsAddOnLoaded("ElvUI_SLE") then
				LCG.PixelGlow_Stop(headbtn)
			else
				LCG.PixelGlow_Stop(headbtn)	
			end
		end
	else
		if T.IsAddOnLoaded("ElvUI_SLE") then
			LCG.PixelGlow_Stop(headbtn)
		else
			LCG.PixelGlow_Stop(headbtn)	
		end
	end
	
	local itemLocation = ItemLocation:CreateFromEquipmentSlot(3);
	if T.C_Item_DoesItemExist(itemLocation) and T.C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem(itemLocation) then
		if T.C_AzeriteEmpoweredItem_HasAnyUnselectedPowers(itemLocation) then
			if T.IsAddOnLoaded("ElvUI_SLE") then
				LCG.PixelGlow_Start(shoulderbtn, color, nil, -0.25, nil, 2)
			else
				local r, g, b = T.unpack(E["media"].rgbvaluecolor)
				local color = {r,g,b,1}
				LCG.PixelGlow_Start(shoulderbtn, color, nil, -0.25, nil, 2)
			end
		else
			if T.IsAddOnLoaded("ElvUI_SLE") then
				LCG.PixelGlow_Stop(shoulderbtn)
			else
				LCG.PixelGlow_Stop(shoulderbtn)	
			end
		end
	else
		if T.IsAddOnLoaded("ElvUI_SLE") then
			LCG.PixelGlow_Stop(shoulderbtn)
		else
			LCG.PixelGlow_Stop(shoulderbtn)	
		end
	end
		
	local itemLocationC = ItemLocation:CreateFromEquipmentSlot(5);
	if T.C_Item_DoesItemExist(itemLocationC) and T.C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem(itemLocationC) then
		if T.C_AzeriteEmpoweredItem_HasAnyUnselectedPowers(itemLocationC) then
			if T.IsAddOnLoaded("ElvUI_SLE") then
				LCG.PixelGlow_Start(chestbtn, color, nil, -0.25, nil, 2)
			else
				local r, g, b = T.unpack(E["media"].rgbvaluecolor)
				local color = {r,g,b,1}
				LCG.PixelGlow_Start(chestbtn, color, nil, -0.25, nil, 2)
			end
		else
			if T.IsAddOnLoaded("ElvUI_SLE") then
				LCG.PixelGlow_Stop(chestbtn)
			else
				LCG.PixelGlow_Stop(chestbtn)	
			end
		end	
	else
		if T.IsAddOnLoaded("ElvUI_SLE") then
			LCG.PixelGlow_Stop(chestbtn)
		else
			LCG.PixelGlow_Stop(chestbtn)	
		end
	end
end

function AZB:openHead()
	local itemLocation = ItemLocation:CreateFromEquipmentSlot(1);
	if T.C_Item_DoesItemExist(itemLocation) then 
		if T.C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem(itemLocation) then
			T.OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation);
		else
			KUI:Print(L["Equipped head is not an Azerite item."]);
			T.SocketInventoryItem(1);
		end
	else
		KUI:Print(L["No head item is equipped."]);
	end
end

function AZB:openShoulder()
	local itemLocation = ItemLocation:CreateFromEquipmentSlot(3);
	if T.C_Item_DoesItemExist(itemLocation) then 
		if T.C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem(itemLocation) then
			T.OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation);
		else
			KUI:Print(L["Equipped shoulder is not an Azerite item."]);
			T.SocketInventoryItem(3);
		end
	else
		KUI:Print(L["No shoulder item is equipped."]);
	end
end

function AZB:openChest()
	local itemLocation = ItemLocation:CreateFromEquipmentSlot(5);
	if T.C_Item_DoesItemExist(itemLocation) then 
		if T.C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem(itemLocation) then
			T.OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation);
		else
			KUI:Print(L["Equipped chest is not an Azerite item."]);
			T.SocketInventoryItem(5);
		end
	else
		KUI:Print(L["No chest item is equipped."]);
	end
end

function AZB:Initialize()
	if not E.db.KlixUI.armory.azeritebtn then return end
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	self:RegisterEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
	
	self:CreateAZbuttons()
end

KUI:RegisterModule(AZB:GetName())