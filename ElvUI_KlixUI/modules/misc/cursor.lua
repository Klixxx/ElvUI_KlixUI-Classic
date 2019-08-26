local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local FC = KUI:NewModule("FlashingCursor")

local x = 0
local y = 0
local speed = 0

local function OnUpdate(_, elapsed)
	if E.db.KlixUI.misc.cursorFlash.enable then
		if E.db.KlixUI.misc.cursorFlash.visibility == "ALWAYS" or (E.db.KlixUI.misc.cursorFlash.visibility == "MODIFIER" and T.IsModifierKeyDown()) or (E.db.KlixUI.misc.cursorFlash.visibility == "COMBAT" and T.InCombatLockdown()) then
			local dX = x
			local dY = y
			x, y = T.GetCursorPosition()
			dX = x - dX
			dY = y - dY
			local weight = 2048 ^ -elapsed
			speed = T.math_min(weight * speed + (1 - weight) * T.math_sqrt(dX * dX + dY * dY) / elapsed, 1024)
			local size = speed / 6 - 16
			if (size > 0) then
				local scale = UIParent:GetEffectiveScale()
				local r, g, b = E.db.KlixUI.misc.cursorFlash.color.r, E.db.KlixUI.misc.cursorFlash.color.g, E.db.KlixUI.misc.cursorFlash.color.b
				FC.texture:SetHeight(size)
				FC.texture:SetWidth(size)
				FC.texture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale)
				FC.texture:Show()
				FC.texture:SetAlpha(E.db.KlixUI.misc.cursorFlash.alpha)
				FC.texture:SetVertexColor(r, g, b)
			else
				FC.texture:Hide()
			end
		else
			FC.texture:Hide()
		end
	else
		FC.texture:Hide()
	end
end

function FC:Initialize()
    FC.frame = T.CreateFrame("Frame", nil, UIParent)
    FC.frame:SetFrameStrata("TOOLTIP")
    
    FC.texture = FC.frame:CreateTexture()
    FC.texture:SetTexture([[Interface\Cooldown\star4]])
    FC.texture:SetBlendMode("ADD")
    
    FC.frame:SetScript("OnUpdate", OnUpdate)
end

local function InitializeCallback()
    FC:Initialize()
end

KUI:RegisterModule(FC:GetName(), InitializeCallback)