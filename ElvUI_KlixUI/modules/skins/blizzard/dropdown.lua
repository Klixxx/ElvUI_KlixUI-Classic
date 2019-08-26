local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")
local LSM = E.LSM

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleUIDropDownMenu()
	if E.private.skins.blizzard.enable ~= true then return end

	hooksecurefunc("UIDropDownMenu_SetIconImage", function(icon, texture)
		if texture:find("Divider") then
			icon:SetColorTexture(r, g, b, 0.45)
			icon:SetHeight(1)
		end
	end)

	hooksecurefunc("UIDropDownMenu_CreateFrames", function(_, index)
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			local listFrame = _G["DropDownList"..i]
			local listFrameName = listFrame:GetName()
			local index = listFrame and (listFrame.numButtons + 1) or 1
			local expandArrow = _G[listFrameName.."Button"..index.."ExpandArrow"]

			if expandArrow then
				expandArrow:SetNormalTexture('Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\arrow')
				expandArrow:SetSize(12, 12)
				expandArrow:GetNormalTexture():SetVertexColor(1, 1, 1)
				expandArrow:GetNormalTexture():SetRotation(KS.ArrowRotation['RIGHT'])
			end
		end
	end)

	hooksecurefunc("ToggleDropDownMenu", function(level)
		if not level then level = 1 end

		for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
			local button = _G["DropDownList"..level.."Button"..i]
			local check = _G["DropDownList"..level.."Button"..i.."Check"]
			local uncheck = _G["DropDownList"..level.."Button"..i.."UnCheck"]
			local highlight = _G["DropDownList"..level.."Button"..i.."Highlight"]

			highlight:SetColorTexture(r, g, b, .35)

			KS:CreateBackdrop(check)
			if check.backdrop then
				check.backdrop:Hide()
			end

			if not button.notCheckable then
				uncheck:SetTexture("")
				local _, co = check:GetTexCoord()
				if co == 0 then
					check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
					check:SetVertexColor(r, g, b, 1)
					check:SetSize(20, 20)
					check:SetDesaturated(true)
				else
					check:SetTexture(LSM:Fetch("statusbar", "Klix"))
					check:SetVertexColor(r, g, b, .6)
					check:SetSize(10, 10)
					check:SetDesaturated(false)
				end

				check:SetTexCoord(0, 1, 0, 1)
				check.backdrop:Show()
			else
				check:SetSize(16, 16)
			end
		end
	end)
end

S:AddCallback("KuiUIDropDownMenu", styleUIDropDownMenu)
