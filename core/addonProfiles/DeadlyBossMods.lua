local KUI, T, E, L, V, P, G = unpack(select(2, ...))

function KUI:LoadDBMProfile()
	DBM:CreateProfile('Klix')

	DBM_AllSavedOptions["Klix"]["CountdownVoice"] = "Corsica"
	DBM_AllSavedOptions["Klix"]["SpecialWarningFontShadow"] = true
	DBM_AllSavedOptions["Klix"]["SpecialWarningFontStyle"] = "OUTLINE"
	DBM_AllSavedOptions["Klix"]["SpecialWarningX"] = 0
	DBM_AllSavedOptions["Klix"]["SpecialWarningY"] = 350
	DBM_AllSavedOptions["Klix"]["SpecialWarningFont"] = "Expressway"
	DBM_AllSavedOptions["Klix"]["WarningFontShadow"] = true
	DBM_AllSavedOptions["Klix"]["WarningFont"] = "Expressway"
	DBM_AllSavedOptions["Klix"]["WarningFontStyle"] = "OUTLINE"
	DBM_AllSavedOptions["Klix"]["WarningX"] = 0
	DBM_AllSavedOptions["Klix"]["WarningY"] = 200
	DBM_AllSavedOptions["Klix"]["HPFrameY"] = -230
	DBM_AllSavedOptions["Klix"]["HPFrameX"] = 325
	DBM_AllSavedOptions["Klix"]["HPFramePoint"] = "LEFT"
	DBT_AllPersistentOptions["Klix"]["DBM"]["Texture"] = "Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\Klix.tga"
	DBT_AllPersistentOptions["Klix"]["DBM"]["Scale"] = 1
	DBT_AllPersistentOptions["Klix"]["DBM"]["FontSize"] = 12
	DBT_AllPersistentOptions["Klix"]["DBM"]["HugeScale"] = 1
	DBT_AllPersistentOptions["Klix"]["DBM"]["Font"] = "Expressway"
	DBT_AllPersistentOptions["Klix"]["DBM"]["FontStyle"] = "OUTLINE"
	DBT_AllPersistentOptions["Klix"]["DBM"]["EndColorG"] = 0
	DBT_AllPersistentOptions["Klix"]["DBM"]["HugeTimerY"] = 262 --HugeY
	DBT_AllPersistentOptions["Klix"]["DBM"]["HugeBarXOffset"] = 0
	DBT_AllPersistentOptions["Klix"]["DBM"]["Scale"] = 0.899999976158142
	DBT_AllPersistentOptions["Klix"]["DBM"]["EnlargeBarsPercent"] = 0.125
	DBT_AllPersistentOptions["Klix"]["DBM"]["HugeBarYOffset"] = 1
	DBT_AllPersistentOptions["Klix"]["DBM"]["HugeWidth"] = 227
	DBT_AllPersistentOptions["Klix"]["DBM"]["BarYOffset"] = 1
	DBT_AllPersistentOptions["Klix"]["DBM"]["TimerY"] = 262 --Y
	DBT_AllPersistentOptions["Klix"]["DBM"]["StartColorR"] = 1
	DBT_AllPersistentOptions["Klix"]["DBM"]["ExpandUpwards"] = false
	DBT_AllPersistentOptions["Klix"]["DBM"]["ExpandUpwardsLarge"] = false
	DBT_AllPersistentOptions["Klix"]["DBM"]["TimerPoint"] = "BOTTOM"
	DBT_AllPersistentOptions["Klix"]["DBM"]["StartColorG"] = 0.701960784313726
	DBT_AllPersistentOptions["Klix"]["DBM"]["TimerX"] = -253 --X
	DBT_AllPersistentOptions["Klix"]["DBM"]["HugeTimerX"] = 277 --HugeX
	DBT_AllPersistentOptions["Klix"]["DBM"]["EndColorR"] = 1
	DBT_AllPersistentOptions["Klix"]["DBM"]["Width"] = 227
	DBT_AllPersistentOptions["Klix"]["DBM"]["HugeTimerPoint"] = "BOTTOM"
	DBT_AllPersistentOptions["Klix"]["DBM"]["EnlargeBarsTime"] = 8
	DBT_AllPersistentOptions["Klix"]["DBM"]["StartColorB"] = 0
	DBT_AllPersistentOptions["Klix"]["DBM"]["Height"] = 23
	DBT_AllPersistentOptions["Klix"]["DBM"]["BarXOffset"] = 0
	DBT_AllPersistentOptions["Klix"]["DBM"]["EndColorB"] = 0
	DBT_AllPersistentOptions["Klix"]["DBM"]["LastRevision"] = 11873
	DBT_AllPersistentOptions["Klix"]["DBM"]["SettingsMessageShown"] = true
	DBT_AllPersistentOptions["Klix"]["DBM"]["BugMessageShown"] = 1
	DBT_AllPersistentOptions["Klix"]["DBM"]["ForumsMessageShown"] = 11873

	DBM:ApplyProfile('Klix')
end
