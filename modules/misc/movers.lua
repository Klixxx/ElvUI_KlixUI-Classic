local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local MI = KUI:GetModule("KuiMisc")

function MI:UpdateMoverTransparancy()
	local mover
	for name, _ in T.pairs(E.CreatedMovers) do
		mover = _G[name]
		if mover then
			mover:SetAlpha(E.db.KlixUI.general.Movertransparancy)
		end
	end
end

function MI:LoadMoverTransparancy()
	hooksecurefunc(E, "CreateMover", function(self, parent, name, text, overlay, snapOffset, postdrag, shouldDisable)
		if not parent then return end -- If for some reason the parent isnt loaded yet
		if E.CreatedMovers[name].Created then return end
		parent.mover:SetAlpha(E.db.KlixUI.general.Movertransparancy)
	end)

	self:UpdateMoverTransparancy()
end