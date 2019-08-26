local KUI, T, E, L, V, P, G = unpack(select(2, ...))

local folder, ns = ...
local addon = T.CreateFrame('Frame','EasyDelete')


function addon:DELETE_ITEM_CONFIRM(...)
if E.global.KlixUI.easyDelete == false or T.IsAddOnLoaded("EasyDeleteConfirm") then return end
    if _G.StaticPopup1EditBox:IsShown() then
        _G.StaticPopup1EditBox:Hide()
        _G.StaticPopup1Button1:Enable()

        local link = T.select(3, T.GetCursorInfo())

        addon.link:SetText(link)
        addon.link:Show()
    end
end

function addon:ADDON_LOADED(loaded_addon)
    if loaded_addon ~= folder then return end

    -- create item link container
    addon.link = _G.StaticPopup1:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
    addon.link:SetPoint('CENTER', _G.StaticPopup1EditBox)
    addon.link:Hide()

    _G.StaticPopup1:HookScript('OnHide', function(self)
        addon.link:Hide()
    end)
end

addon:SetScript('OnEvent', function(self,event,...)
    self[event](self, ...)
end)

addon:RegisterEvent('ADDON_LOADED')
addon:RegisterEvent('DELETE_ITEM_CONFIRM')
