local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KDB = KUI:GetModule("KuiDatabars")
local EDB = E:GetModule("DataBars")

local function UpdateHonor(self)
    local bar = self.honorBar
    local color = E.db.KlixUI.databars.honorBar.color
    bar.statusBar:SetStatusBarColor(color.r, color.g, color.b, color.a)

    if E.db.KlixUI.databars.honorBar.progress then
        local avg = T.UnitHonor("player") / T.UnitHonorMax("player")
        avg = KDB:Round(avg, 2)
        bar.statusBar:SetAlpha(avg)
    else
        bar.statusBar:SetAlpha(0.8)
    end
end

function KDB:HookHonorBar()
    if E.db.KlixUI.databars.enable and EDB.honorBar then
        if not KDB:IsHooked(EDB, "UpdateHonor") then
            KDB:SecureHook(EDB, "UpdateHonor", UpdateHonor)
        end
    elseif not E.db.KlixUI.databars.enable or not EDB.honorBar then
        if KDB:IsHooked(EDB, "UpdateHonor") then
            KDB:Unhook(EDB, "UpdateHonor")
        end
        KDB:RestoreHonorBar()
    end
    EDB:UpdateHonor()
end

function KDB:RestoreHonorBar()
    local bar = EDB.honorBar
    if bar then
        bar.statusBar:SetStatusBarColor(0.941, 0.447, 0.254, 0.8)
    end
end
