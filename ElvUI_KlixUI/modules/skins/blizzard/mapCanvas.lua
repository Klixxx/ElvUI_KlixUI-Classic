local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleMapCanvas()
	if E.private.skins.blizzard.enable ~= true then return end

	--[[ AddOns\Blizzard_MapCanvasDetailLayer.lua ]]
	function KS.MapCanvasDetailLayerMixin_RefreshDetailTiles(self)
		local layers = T.C_Map_GetMapArtLayers(self.mapID)
		local layerInfo = layers[self.layerIndex]

		for detailTile in self.detailTilePool:EnumerateActive() do
			if not detailTile.isSkinned then
				detailTile:SetSize(layerInfo.tileWidth, layerInfo.tileHeight)
				detailTile.isSkinned = true
			end
		end
	end

	hooksecurefunc(_G.MapCanvasDetailLayerMixin, "RefreshDetailTiles", KS.MapCanvasDetailLayerMixin_RefreshDetailTiles)
end

S:AddCallbackForAddon("Blizzard_MapCancas", "KuiMapCanvas", styleMapCanvas)
