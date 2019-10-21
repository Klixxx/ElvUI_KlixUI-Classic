local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleWeakAuras()
	if not T.IsAddOnLoaded("WeakAuras") or not E.private.KlixUI.skins.addonSkins.wa then return end
	
    local function Skin_WeakAuras(frame, ftype)
        if ftype == "icon" then
            if not frame.shadow then
				frame:CreateIconShadow()
				if E.db.KlixUI.general.iconShadow and not T.IsAddOnLoaded("Masque") then
					frame.ishadow:SetInside(frame, 0, 0)
				end  
                frame.icon:SetTexCoord(T.unpack(E.TexCoords))
                frame.icon.SetTexCoord = KUI.dummy
            end
        end

        if ftype == "aurabar" then
            if not frame.bar.shadow then
				if E.private.KlixUI.skins.addonSkins.wa and not (E.myname == "Tittebøh" and E.myrealm == "Firemaw") then
					frame.bar:Styling()
				end
                frame.icon:SetTexCoord(T.unpack(E.TexCoords))
                frame.icon.SetTexCoord = KUI.dummy
            end
        end
    end
    local Create_Icon, Modify_Icon = WeakAuras.regionTypes.icon.create, WeakAuras.regionTypes.icon.modify
    local Create_AuraBar, Modify_AuraBar = WeakAuras.regionTypes.aurabar.create, WeakAuras.regionTypes.aurabar.modify
    WeakAuras.regionTypes.icon.create = function(parent, data)
        local region = Create_Icon(parent, data)
        Skin_WeakAuras(region, "icon")
        return region
    end

    WeakAuras.regionTypes.aurabar.create = function(parent)
        local region = Create_AuraBar(parent)
        Skin_WeakAuras(region, "aurabar")
        return region
    end

    WeakAuras.regionTypes.icon.modify = function(parent, region, data)
        Modify_Icon(parent, region, data)
        Skin_WeakAuras(region, "icon")
    end

    WeakAuras.regionTypes.aurabar.modify = function(parent, region, data)
        Modify_AuraBar(parent, region, data)
        Skin_WeakAuras(region, "aurabar")
    end

    for weakAura, _ in T.pairs(WeakAuras.regions) do
        if WeakAuras.regions[weakAura].regionType == "icon"
        or WeakAuras.regions[weakAura].regionType == "aurabar" then
            Skin_WeakAuras(WeakAuras.regions[weakAura].region, WeakAuras.regions[weakAura].regionType)
        end
    end
end

S:AddCallbackForAddon("WeakAuras", "KuiWeakAuras", styleWeakAuras)