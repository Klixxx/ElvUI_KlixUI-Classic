local KUI, T, E, L, V, P, G = unpack(select(2, ...))

function KUI:LoadAddOnSkinsProfile()
	local AS = unpack(AddOnSkins)

	AS.data:SetProfile("KlixUI")
	
	-- defaults
	AS.db['EmbedLeft'] = 'Skada'
	AS.db['EmbedLeft'] = 'Skada'
	AS.db['EmbedMain'] = 'Skada'
	AS.db['EmbedRight'] = 'Skada'
	AS.db['EmbedSystem'] = false
	AS.db['EmbedSystemDual'] = false
	AS.db['ParchmentRemover'] = true
	AS.db['TransparentEmbed'] = false
	AS.db['TransparentEmbed'] = false
	AS.db["EmbedRightChat"] = true -- Always embed it to right chat!

	if IsAddOnLoaded('Recount') then
		AS.db['EmbedFrameStrata'] = "2-LOW"
		AS.db['EmbedBelowTop'] = false
		AS.db['EmbedMain'] = 'Recount'
		AS.db['EmbedSystem'] = true
		AS.db['EmbedSystemDual'] = false
		AS.db['RecountBackdrop'] = false
		AS.db['TransparentEmbed'] = true
		AS.db["HideChatFrame"] = "ChatFrame3"
	end

	if IsAddOnLoaded('Skada') then
		AS.db['EmbedFrameStrata'] = "2-LOW"
		AS.db['EmbedBelowTop'] = false
		AS.db['EmbedLeft'] = 'Skada'
		AS.db['EmbedMain'] = 'Skada'
		AS.db['EmbedRight'] = 'Skada'
		AS.db['EmbedSystem'] = true
		AS.db['EmbedSystemDual'] = false
		AS.db['SkadaBackdrop'] = false
		AS.db['TransparentEmbed'] = true
		AS.db["HideChatFrame"] = "ChatFrame3"
	end

	if IsAddOnLoaded('Details') then
		AS.db['EmbedFrameStrata'] = "2-LOW"
		AS.db['DetailsBackdrop'] = false
		AS.db['EmbedBelowTop'] = false
		AS.db['EmbedLeft'] = 'Details'
		AS.db['EmbedMain'] = 'Details'
		AS.db['EmbedRight'] = 'Details'
		AS.db['EmbedSystem'] = false
		AS.db['EmbedSystemDual'] = true
		AS.db['TransparentEmbed'] = true
		AS.db["HideChatFrame"] = "ChatFrame3"
		AS.db["EmbedLeftWidth"] = 193
	end

	if IsAddOnLoaded('DBM-Core') then
		AS.db['DBMFont'] = "Expressway"
		AS.db['DBMFont'] = "Expressway"
		AS.db['DBMFontSize'] = 10
		AS.db['DBMRadarTrans'] = true
		AS.db['DBMSkinHalf'] = false
	end
end