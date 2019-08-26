if not IsAddOnLoaded("BigWigs") then return end

local heroes = {
	"UT2003",
}
local key = "Klix - Unreal Tournament 2003"
local path = "Interface\\AddOns\\ElvUI_KlixUI\\media\\sounds\\Unreal_Tournament\\Classic2003\\%s_%d.ogg"

for i = 1, #heroes do
	local hero = heroes[i]
	BigWigsAPI:RegisterCountdown(key:format(hero), {
		path:format(hero, 1), 
		path:format(hero, 2),
		path:format(hero, 3),
		path:format(hero, 4),
		path:format(hero, 5),
		path:format(hero, 6),
		path:format(hero, 7),
		path:format(hero, 8),
		path:format(hero, 9),
		path:format(hero, 10),
	})
end