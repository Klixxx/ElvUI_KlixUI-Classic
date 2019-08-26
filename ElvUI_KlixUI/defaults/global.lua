local KUI, T, E, L, V, P, G = unpack(select(2, ...))

if G["KlixUI"] == nil then G["KlixUI"] = {} end

G["KlixUI"] = {
	-- General
	["speedyLoot"] = true,
	["easyDelete"] = true,
	["cinematic"] = {
		["kill"] = false,
		["enableSound"] = true,
		["talkingheadSound"] = true,
	},
	
	-- Professions
	["DE"] = {
		["Blacklist"] = "",
		["IgnoreTabards"] = true,
		["IgnorePanda"] = true,
		["IgnoreCooking"] = true,
		["IgnoreFishing"] = true,
	},
	["LOCK"] = {
		["Blacklist"] = "",
		["TradeOpen"] = false,
	},
}