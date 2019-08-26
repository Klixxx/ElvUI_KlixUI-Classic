--[[
Name: LibTourist-3.0
Revision: $Rev: 222 $
Author(s): Odica (maintainer), originally created by ckknight and Arrowmaster
Documentation: https://www.wowace.com/projects/libtourist-3-0/pages/api-reference
SVN: svn://svn.wowace.com/wow/libtourist-3-0/mainline/trunk
Description: A library to provide information about zones and instances.
License: MIT
]]

local MAJOR_VERSION = "LibTourist-3.0"
local MINOR_VERSION = 90000 + tonumber(("$Revision: 222 $"):match("(%d+)"))

if not LibStub then error(MAJOR_VERSION .. " requires LibStub") end
local C_Map = C_Map
local Tourist, oldLib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not Tourist then
	return
end
if oldLib then
	oldLib = {}
	for k, v in pairs(Tourist) do
		Tourist[k] = nil
		oldLib[k] = v
	end
end

local HBD = LibStub("HereBeDragons-2.0")
function Tourist:GetHBD() return HBD end

local function trace(msg)
	--DEFAULT_CHAT_FRAME:AddMessage(msg)
end

--trace("|r|cffff4422! -- Tourist:|r Warning: This is an alpha version with limited functionality." )		

-- Localization tables
local BZ = {}
local BZR = {}

local playerLevel = UnitLevel("player")

local isAlliance, isHorde, isNeutral
do
	local faction = UnitFactionGroup("player")
	isAlliance = faction == "Alliance"
	isHorde = faction == "Horde"
	isNeutral = not isAlliance and not isHorde
end

local isWestern = GetLocale() == "enUS" or GetLocale() == "deDE" or GetLocale() == "frFR" or GetLocale() == "esES"

local Azeroth = "Azeroth"
local Kalimdor = "Kalimdor"
local Eastern_Kingdoms = "Eastern Kingdoms"
local Outland = "Outland"
local Northrend = "Northrend"
local The_Maelstrom = "The Maelstrom"
local Pandaria = "Pandaria"
local Draenor = "Draenor"
local Broken_Isles = "Broken Isles"
local Argus = "Argus"
local Zandalar = "Zandalar"
local Kul_Tiras = "Kul Tiras"

local X_Y_ZEPPELIN = "%s - %s Zeppelin"
local X_Y_BOAT = "%s - %s Boat"
local X_Y_PORTAL = "%s - %s Portal"
local X_Y_TELEPORT = "%s - %s Teleport"

if GetLocale() == "zhCN" then
	X_Y_ZEPPELIN = "%s - %s 飞艇"
	X_Y_BOAT = "%s - %s 船"
	X_Y_PORTAL = "%s - %s 传送门"
	X_Y_TELEPORT = "%s - %s 传送门"
elseif GetLocale() == "zhTW" then
	X_Y_ZEPPELIN = "%s - %s 飛艇"
	X_Y_BOAT = "%s - %s 船"
	X_Y_PORTAL = "%s - %s 傳送門"
	X_Y_TELEPORT = "%s - %s 傳送門"
elseif GetLocale() == "frFR" then
	X_Y_ZEPPELIN = "Zeppelin %s - %s"
	X_Y_BOAT = "Bateau %s - %s"
	X_Y_PORTAL = "Portail %s - %s"
	X_Y_TELEPORT = "Téléport %s - %s"
elseif GetLocale() == "koKR" then
	X_Y_ZEPPELIN = "%s - %s 비행선"
	X_Y_BOAT = "%s - %s 배"
	X_Y_PORTAL = "%s - %s 차원문"
	X_Y_TELEPORT = "%s - %s 차원문"
elseif GetLocale() == "deDE" then
	X_Y_ZEPPELIN = "%s - %s Zeppelin"
	X_Y_BOAT = "%s - %s Schiff"
	X_Y_PORTAL = "%s - %s Portal"
	X_Y_TELEPORT = "%s - %s Teleport"	
elseif GetLocale() == "esES" then
	X_Y_ZEPPELIN = "%s - %s Zepelín"
	X_Y_BOAT = "%s - %s Barco"
	X_Y_PORTAL = "%s - %s Portal"
	X_Y_TELEPORT = "%s - %s Teletransportador"
end

local recZones = {}
local recInstances = {}
local lows = setmetatable({}, {__index = function() return 0 end})
local highs = setmetatable({}, getmetatable(lows))
local continents = {}
local instances = {}
local paths = {}
local flightnodes = {}
local types = {}
local groupSizes = {}
local groupMinSizes = {}
local groupMaxSizes = {}
local groupAltSizes = {}
local factions = {}
local yardWidths = {}
local yardHeights = {}
local yardXOffsets = {}
local yardYOffsets = {}
local continentScales = {}
local fishing = {}
local battlepet_lows = {}
local battlepet_highs = {}
local cost = {}
local textures = {}
local textures_rev = {}
local complexOfInstance = {}
local zoneComplexes = {}
local entrancePortals_zone = {}
local entrancePortals_x = {}
local entrancePortals_y = {}

local zoneMapIDtoContinentMapID = {}
local zoneMapIDs = {}
local mapZonesByContinentID = {}

local FlightnodeLookupTable = {}
local gatheringFlightnodes = false
local flightnodeDataGathered = false

local COSMIC_MAP_ID = 946
local THE_MAELSTROM_MAP_ID = 948
local DRAENOR_MAP_ID = 572
local BROKEN_ISLES_MAP_ID = 619


--------------------------------------------------------------------------------------------------------
--                                            Localization                                            --
--------------------------------------------------------------------------------------------------------

local MapIdLookupTable = {
    [1] = "Durotar",
    [2] = "Burning Blade Coven",
    [3] = "Tiragarde Keep",
    [4] = "Tiragarde Keep",
    [5] = "Skull Rock",
    [6] = "Dustwind Cave",
    [7] = "Mulgore",
    [8] = "Palemane Rock",
    [9] = "The Venture Co. Mine",
    [10] = "Northern Barrens",
    [11] = "Wailing Caverns",
    [12] = "Kalimdor",
    [13] = "Eastern Kingdoms",
    [14] = "Arathi Highlands",
    [15] = "Badlands",
    [16] = "Uldaman",
    [17] = "Blasted Lands",
    [18] = "Tirisfal Glades",
    [19] = "Scarlet Monastery Entrance",
    [20] = "Keeper's Rest",
    [21] = "Silverpine Forest",
    [22] = "Western Plaguelands",
    [23] = "Eastern Plaguelands",
    [24] = "Light's Hope Chapel",
    [25] = "Hillsbrad Foothills",
    [26] = "The Hinterlands",
    [27] = "Dun Morogh",
    [28] = "Coldridge Pass",
    [29] = "The Grizzled Den",
    [30] = "New Tinkertown",
    [31] = "Gol'Bolar Quarry",
    [32] = "Searing Gorge",
    [33] = "Blackrock Mountain",
    [34] = "Blackrock Mountain",
    [35] = "Blackrock Mountain",
    [36] = "Burning Steppes",
    [37] = "Elwynn Forest",
    [38] = "Fargodeep Mine",
    [39] = "Fargodeep Mine",
    [40] = "Jasperlode Mine",
    [41] = "Dalaran",
    [42] = "Deadwind Pass",
    [43] = "The Master's Cellar",
    [44] = "The Master's Cellar",
    [45] = "The Master's Cellar",
    [46] = "Karazhan Catacombs",
    [47] = "Duskwood",
    [48] = "Loch Modan",
    [49] = "Redridge Mountains",
    [50] = "Northern Stranglethorn",
    [50] = "Northern Stranglethorn",
    [51] = "Swamp of Sorrows",
    [52] = "Westfall",
    [53] = "Gold Coast Quarry",
    [54] = "Jangolode Mine",
    [55] = "The Deadmines",
    [56] = "Wetlands",
    [57] = "Teldrassil",
    [58] = "Shadowthread Cave",
    [59] = "Fel Rock",
    [60] = "Ban'ethil Barrow Den",
    [61] = "Ban'ethil Barrow Den",
    [62] = "Darkshore",
    [63] = "Ashenvale",
    [64] = "Thousand Needles",
    [65] = "Stonetalon Mountains",
    [66] = "Desolace",
    [67] = "Maraudon",
    [68] = "Maraudon",
    [69] = "Feralas",
    [70] = "Dustwallow Marsh",
    [71] = "Tanaris",
    [72] = "The Noxious Lair",
    [73] = "The Gaping Chasm",
    [74] = "Caverns of Time",
    [75] = "Caverns of Time",
    [76] = "Azshara",
    [77] = "Felwood",
    [78] = "Un'Goro Crater",
    [79] = "The Slithering Scar",
    [80] = "Moonglade",
    [81] = "Silithus",
    [82] = "Twilight's Run",
    [83] = "Winterspring",
    [84] = "Stormwind City",
    [85] = "Orgrimmar",
    [86] = "Orgrimmar",
    [87] = "Ironforge",
    [88] = "Thunder Bluff",
    [89] = "Darnassus",
    [90] = "Undercity",
    [91] = "Alterac Valley",
    [92] = "Warsong Gulch",
    [93] = "Arathi Basin",
    [94] = "Eversong Woods",
    [95] = "Ghostlands",
    [96] = "Amani Catacombs",
    [97] = "Azuremyst Isle",
    [98] = "Tides' Hollow",
    [99] = "Stillpine Hold",
    [100] = "Hellfire Peninsula",
    [101] = "Outland",
    [102] = "Zangarmarsh",
    [103] = "The Exodar",
    [104] = "Shadowmoon Valley",
    [105] = "Blade's Edge Mountains",
    [106] = "Bloodmyst Isle",
    [107] = "Nagrand",
    [108] = "Terokkar Forest",
    [109] = "Netherstorm",
    [110] = "Silvermoon City",
    [111] = "Shattrath City",
    [112] = "Eye of the Storm",
    [113] = "Northrend",
    [114] = "Borean Tundra",
    [115] = "Dragonblight",
    [116] = "Grizzly Hills",
    [117] = "Howling Fjord",
    [118] = "Icecrown",
    [119] = "Sholazar Basin",
    [120] = "The Storm Peaks",
    [121] = "Zul'Drak",
    [122] = "Isle of Quel'Danas",
    [123] = "Wintergrasp",
    [124] = "Plaguelands: The Scarlet Enclave",
    [125] = "Dalaran",
    [126] = "Dalaran",
    [127] = "Crystalsong Forest",
    [128] = "Strand of the Ancients",
    [129] = "The Nexus",
    [130] = "The Culling of Stratholme",
    [131] = "The Culling of Stratholme",
    [132] = "Ahn'kahet: The Old Kingdom",
    [133] = "Utgarde Keep",
    [134] = "Utgarde Keep",
    [135] = "Utgarde Keep",
    [136] = "Utgarde Pinnacle",
    [137] = "Utgarde Pinnacle",
    [138] = "Halls of Lightning",
    [139] = "Halls of Lightning",
    [140] = "Halls of Stone",
    [141] = "The Eye of Eternity",
    [142] = "The Oculus",
    [143] = "The Oculus",
    [144] = "The Oculus",
    [145] = "The Oculus",
    [146] = "The Oculus",
    [147] = "Ulduar",
    [148] = "Ulduar",
    [149] = "Ulduar",
    [150] = "Ulduar",
    [150] = "Ulduar",
    [151] = "Ulduar",
    [152] = "Ulduar",
    [153] = "Gundrak",
    [154] = "Gundrak",
    [155] = "The Obsidian Sanctum",
    [156] = "Vault of Archavon",
    [157] = "Azjol-Nerub",
    [158] = "Azjol-Nerub",
    [159] = "Azjol-Nerub",
    [160] = "Drak'Tharon Keep",
    [161] = "Drak'Tharon Keep",
    [162] = "Naxxramas",
    [163] = "Naxxramas",
    [164] = "Naxxramas",
    [165] = "Naxxramas",
    [166] = "Naxxramas",
    [167] = "Naxxramas",
    [168] = "The Violet Hold",
    [169] = "Isle of Conquest",
    [170] = "Hrothgar's Landing",
    [171] = "Trial of the Champion",
    [172] = "Trial of the Crusader",
    [173] = "Trial of the Crusader",
    [174] = "The Lost Isles",
    [175] = "Kaja'mite Cavern",
    [176] = "Volcanoth's Lair",
    [177] = "Gallywix Labor Mine",
    [178] = "Gallywix Labor Mine",
    [179] = "Gilneas",
    [180] = "Emberstone Mine",
    [181] = "Greymane Manor",
    [182] = "Greymane Manor",
    [183] = "The Forge of Souls",
    [184] = "Pit of Saron",
    [185] = "Halls of Reflection",
    [186] = "Icecrown Citadel",
    [187] = "Icecrown Citadel",
    [188] = "Icecrown Citadel",
    [189] = "Icecrown Citadel",
    [190] = "Icecrown Citadel",
    [191] = "Icecrown Citadel",
    [192] = "Icecrown Citadel",
    [193] = "Icecrown Citadel",
    [194] = "Kezan",
    [195] = "Kaja'mine",
    [196] = "Kaja'mine",
    [197] = "Kaja'mine",
    [198] = "Mount Hyjal",
    [199] = "Southern Barrens",
    [200] = "The Ruby Sanctum",
    [201] = "Kelp'thar Forest",
    [202] = "Gilneas City",
    [203] = "Vashj'ir",
    [204] = "Abyssal Depths",
    [205] = "Shimmering Expanse",
    [206] = "Twin Peaks",
    [207] = "Deepholm",
    [208] = "Twilight Depths",
    [209] = "Twilight Depths",
    [210] = "The Cape of Stranglethorn",
    [213] = "Ragefire Chasm",
    [217] = "Ruins of Gilneas",
    [218] = "Ruins of Gilneas City",
    [219] = "Zul'Farrak",
    [220] = "The Temple of Atal'Hakkar",
    [221] = "Blackfathom Deeps",
    [222] = "Blackfathom Deeps",
    [223] = "Blackfathom Deeps",
    [224] = "Stranglethorn Vale",
    [225] = "The Stockade",
    [226] = "Gnomeregan",
    [227] = "Gnomeregan",
    [228] = "Gnomeregan",
    [229] = "Gnomeregan",
    [230] = "Uldaman",
    [231] = "Uldaman",
    [232] = "Molten Core",
    [233] = "Zul'Gurub",
    [234] = "Dire Maul",
    [235] = "Dire Maul",
    [236] = "Dire Maul",
    [237] = "Dire Maul",
    [238] = "Dire Maul",
    [239] = "Dire Maul",
    [240] = "Dire Maul",
    [241] = "Twilight Highlands",
    [242] = "Blackrock Depths",
    [243] = "Blackrock Depths",
    [244] = "Tol Barad",
    [245] = "Tol Barad Peninsula",
    [246] = "The Shattered Halls",
    [247] = "Ruins of Ahn'Qiraj",
    [248] = "Onyxia's Lair",
    [249] = "Uldum",
    [250] = "Blackrock Spire",
    [251] = "Blackrock Spire",
    [252] = "Blackrock Spire",
    [253] = "Blackrock Spire",
    [254] = "Blackrock Spire",
    [255] = "Blackrock Spire",
    [256] = "Auchenai Crypts",
    [257] = "Auchenai Crypts",
    [258] = "Sethekk Halls",
    [259] = "Sethekk Halls",
    [260] = "Shadow Labyrinth",
    [261] = "The Blood Furnace",
    [262] = "The Underbog",
    [263] = "The Steamvault",
    [264] = "The Steamvault",
    [265] = "The Slave Pens",
    [266] = "The Botanica",
    [267] = "The Mechanar",
    [268] = "The Mechanar",
    [269] = "The Arcatraz",
    [270] = "The Arcatraz",
    [271] = "The Arcatraz",
    [272] = "Mana-Tombs",
    [273] = "The Black Morass",
    [274] = "Old Hillsbrad Foothills",
    [275] = "The Battle for Gilneas",
    [276] = "The Maelstrom",
    [277] = "Lost City of the Tol'vir",
    [279] = "Wailing Caverns",
    [280] = "Maraudon",
    [281] = "Maraudon",
    [282] = "Baradin Hold",
    [283] = "Blackrock Caverns",
    [284] = "Blackrock Caverns",
    [285] = "Blackwing Descent",
    [286] = "Blackwing Descent",
    [287] = "Blackwing Lair",
    [288] = "Blackwing Lair",
    [289] = "Blackwing Lair",
    [290] = "Blackwing Lair",
    [291] = "The Deadmines",
    [292] = "The Deadmines",
    [293] = "Grim Batol",
    [294] = "The Bastion of Twilight",
    [295] = "The Bastion of Twilight",
    [296] = "The Bastion of Twilight",
    [297] = "Halls of Origination",
    [298] = "Halls of Origination",
    [299] = "Halls of Origination",
    [300] = "Razorfen Downs",
    [301] = "Razorfen Kraul",
    [302] = "Scarlet Monastery",
    [303] = "Scarlet Monastery",
    [304] = "Scarlet Monastery",
    [305] = "Scarlet Monastery",
    [306] = "ScholomanceOLD",
    [307] = "ScholomanceOLD",
    [308] = "ScholomanceOLD",
    [309] = "ScholomanceOLD",
    [310] = "Shadowfang Keep",
    [311] = "Shadowfang Keep",
    [312] = "Shadowfang Keep",
    [313] = "Shadowfang Keep",
    [314] = "Shadowfang Keep",
    [315] = "Shadowfang Keep",
    [316] = "Shadowfang Keep",
    [317] = "Stratholme",
    [318] = "Stratholme",
    [319] = "Ahn'Qiraj",
    [320] = "Ahn'Qiraj",
    [321] = "Ahn'Qiraj",
    [322] = "Throne of the Tides",
    [323] = "Throne of the Tides",
    [324] = "The Stonecore",
    [325] = "The Vortex Pinnacle",
    [327] = "Ahn'Qiraj: The Fallen Kingdom",
    [328] = "Throne of the Four Winds",
    [329] = "Hyjal Summit",
    [330] = "Gruul's Lair",
    [331] = "Magtheridon's Lair",
    [332] = "Serpentshrine Cavern",
    [333] = "Zul'Aman",
    [334] = "Tempest Keep",
    [335] = "Sunwell Plateau",
    [336] = "Sunwell Plateau",
    [337] = "Zul'Gurub",
    [338] = "Molten Front",
    [339] = "Black Temple",
    [340] = "Black Temple",
    [341] = "Black Temple",
    [342] = "Black Temple",
    [343] = "Black Temple",
    [344] = "Black Temple",
    [345] = "Black Temple",
    [346] = "Black Temple",
    [347] = "Hellfire Ramparts",
    [348] = "Magisters' Terrace",
    [349] = "Magisters' Terrace",
    [350] = "Karazhan",
    [351] = "Karazhan",
    [352] = "Karazhan",
    [353] = "Karazhan",
    [354] = "Karazhan",
    [355] = "Karazhan",
    [356] = "Karazhan",
    [357] = "Karazhan",
    [358] = "Karazhan",
    [359] = "Karazhan",
    [360] = "Karazhan",
    [361] = "Karazhan",
    [362] = "Karazhan",
    [363] = "Karazhan",
    [364] = "Karazhan",
    [365] = "Karazhan",
    [366] = "Karazhan",
    [367] = "Firelands",
    [368] = "Firelands",
    [369] = "Firelands",
    [370] = "The Nexus",
    [371] = "The Jade Forest",
    [372] = "Greenstone Quarry",
    [373] = "Greenstone Quarry",
    [374] = "The Widow's Wail",
    [375] = "Oona Kagu",
    [376] = "Valley of the Four Winds",
    [377] = "Cavern of Endless Echoes",
    [378] = "The Wandering Isle",
    [379] = "Kun-Lai Summit",
    [380] = "Howlingwind Cavern",
    [381] = "Pranksters' Hollow",
    [382] = "Knucklethump Hole",
    [383] = "The Deeper",
    [384] = "The Deeper",
    [385] = "Tomb of Conquerors",
    [386] = "Ruins of Korune",
    [387] = "Ruins of Korune",
    [388] = "Townlong Steppes",
    [389] = "Niuzao Temple",
    [390] = "Vale of Eternal Blossoms",
    [391] = "Shrine of Two Moons",
    [392] = "Shrine of Two Moons",
    [393] = "Shrine of Seven Stars",
    [394] = "Shrine of Seven Stars",
    [395] = "Guo-Lai Halls",
    [396] = "Guo-Lai Halls",
    [397] = "Eye of the Storm",
    [398] = "Well of Eternity",
    [399] = "Hour of Twilight",
    [400] = "Hour of Twilight",
    [401] = "End Time",
    [402] = "End Time",
    [403] = "End Time",
    [404] = "End Time",
    [405] = "End Time",
    [406] = "End Time",
    [407] = "Darkmoon Island",
    [408] = "Darkmoon Island",
    [409] = "Dragon Soul",
    [410] = "Dragon Soul",
    [411] = "Dragon Soul",
    [412] = "Dragon Soul",
    [413] = "Dragon Soul",
    [414] = "Dragon Soul",
    [415] = "Dragon Soul",
    [416] = "Dustwallow Marsh",
    [417] = "Temple of Kotmogu",
    [418] = "Krasarang Wilds",
    [419] = "Ruins of Ogudei",
    [420] = "Ruins of Ogudei",
    [421] = "Ruins of Ogudei",
    [422] = "Dread Wastes",
    [423] = "Silvershard Mines",
    [424] = "Pandaria",
    [425] = "Northshire",
    [426] = "Echo Ridge Mine",
    [427] = "Coldridge Valley",
    [428] = "Frostmane Hovel",
    [429] = "Temple of the Jade Serpent",
    [430] = "Temple of the Jade Serpent",
    [431] = "Scarlet Halls",
    [432] = "Scarlet Halls",
    [433] = "The Veiled Stair",
    [434] = "The Ancient Passage",
    [435] = "Scarlet Monastery",
    [436] = "Scarlet Monastery",
    [437] = "Gate of the Setting Sun",
    [438] = "Gate of the Setting Sun",
    [439] = "Stormstout Brewery",
    [440] = "Stormstout Brewery",
    [441] = "Stormstout Brewery",
    [442] = "Stormstout Brewery",
    [443] = "Shado-Pan Monastery",
    [444] = "Shado-Pan Monastery",
    [445] = "Shado-Pan Monastery",
    [446] = "Shado-Pan Monastery",
    [447] = "A Brewing Storm",
    [448] = "The Jade Forest",
    [449] = "Temple of Kotmogu",
    [450] = "Unga Ingoo",
    [451] = "Assault on Zan'vess",
    [452] = "Brewmoon Festival",
    [453] = "Mogu'shan Palace",
    [454] = "Mogu'shan Palace",
    [455] = "Mogu'shan Palace",
    [456] = "Terrace of Endless Spring",
    [457] = "Siege of Niuzao Temple",
    [458] = "Siege of Niuzao Temple",
    [459] = "Siege of Niuzao Temple",
    [460] = "Shadowglen",
    [461] = "Valley of Trials",
    [462] = "Camp Narache",
    [463] = "Echo Isles",
    [464] = "Spitescale Cavern",
    [465] = "Deathknell",
    [466] = "Night Web's Hollow",
    [467] = "Sunstrider Isle",
    [468] = "Ammen Vale",
    [469] = "New Tinkertown",
    [470] = "Frostmane Hold",
    [471] = "Mogu'shan Vaults",
    [472] = "Mogu'shan Vaults",
    [473] = "Mogu'shan Vaults",
    [474] = "Heart of Fear",
    [475] = "Heart of Fear",
    [476] = "Scholomance",
    [477] = "Scholomance",
    [478] = "Scholomance",
    [479] = "Scholomance",
    [480] = "Proving Grounds",
    [481] = "Crypt of Forgotten Kings",
    [482] = "Crypt of Forgotten Kings",
    [483] = "Dustwallow Marsh",
    [486] = "Krasarang Wilds",
    [487] = "A Little Patience",
    [488] = "Dagger in the Dark",
    [489] = "Dagger in the Dark",
    [490] = "Black Temple",
    [491] = "Black Temple",
    [492] = "Black Temple",
    [493] = "Black Temple",
    [494] = "Black Temple",
    [495] = "Black Temple",
    [496] = "Black Temple",
    [497] = "Black Temple",
    [498] = "Krasarang Wilds",
    [499] = "Deeprun Tram",
    [500] = "Deeprun Tram",
    [501] = "Dalaran",
    [502] = "Dalaran",
    [503] = "Brawl'gar Arena",
    [504] = "Isle of Thunder",
    [505] = "Lightning Vein Mine",
    [506] = "The Swollen Vault",
    [507] = "Isle of Giants",
    [508] = "Throne of Thunder",
    [509] = "Throne of Thunder",
    [510] = "Throne of Thunder",
    [511] = "Throne of Thunder",
    [512] = "Throne of Thunder",
    [513] = "Throne of Thunder",
    [514] = "Throne of Thunder",
    [515] = "Throne of Thunder",
    [516] = "Isle of Thunder",
    [517] = "Lightning Vein Mine",
    [518] = "Thunder King's Citadel",
    [519] = "Deepwind Gorge",
    [520] = "Vale of Eternal Blossoms",
    [521] = "Vale of Eternal Blossoms",
    [522] = "The Secrets of Ragefire",
    [523] = "Dun Morogh",
    [524] = "Battle on the High Seas",
    [525] = "Frostfire Ridge",
    [526] = "Turgall's Den",
    [527] = "Turgall's Den",
    [528] = "Turgall's Den",
    [529] = "Turgall's Den",
    [530] = "Grom'gar",
    [531] = "Grulloc's Grotto",
    [532] = "Grulloc's Grotto",
    [533] = "Snowfall Alcove",
    [534] = "Tanaan Jungle",
    [535] = "Talador",
    [536] = "Tomb of Lights",
    [537] = "Tomb of Souls",
    [538] = "The Breached Ossuary",
    [539] = "Shadowmoon Valley",
    [540] = "Bloodthorn Cave",
    [541] = "Den of Secrets",
    [542] = "Spires of Arak",
    [543] = "Gorgrond",
    [544] = "Moira's Reach",
    [545] = "Moira's Reach",
    [546] = "Fissure of Fury",
    [547] = "Fissure of Fury",
    [548] = "Cragplume Cauldron",
    [549] = "Cragplume Cauldron",
    [550] = "Nagrand",
    [551] = "The Masters' Cavern",
    [552] = "Stonecrag Gorge",
    [553] = "Oshu'gun",
    [554] = "Timeless Isle",
    [555] = "Cavern of Lost Spirits",
    [556] = "Siege of Orgrimmar",
    [557] = "Siege of Orgrimmar",
    [558] = "Siege of Orgrimmar",
    [559] = "Siege of Orgrimmar",
    [560] = "Siege of Orgrimmar",
    [561] = "Siege of Orgrimmar",
    [562] = "Siege of Orgrimmar",
    [563] = "Siege of Orgrimmar",
    [564] = "Siege of Orgrimmar",
    [565] = "Siege of Orgrimmar",
    [566] = "Siege of Orgrimmar",
    [567] = "Siege of Orgrimmar",
    [568] = "Siege of Orgrimmar",
    [569] = "Siege of Orgrimmar",
    [570] = "Siege of Orgrimmar",
    [571] = "Celestial Tournament",
    [572] = "Draenor",
    [573] = "Bloodmaul Slag Mines",
    [574] = "Shadowmoon Burial Grounds",
    [575] = "Shadowmoon Burial Grounds",
    [576] = "Shadowmoon Burial Grounds",
    [577] = "Tanaan Jungle",
    [578] = "Umbral Halls",
    [579] = "Lunarfall Excavation",
    [580] = "Lunarfall Excavation",
    [581] = "Lunarfall Excavation",
    [582] = "Lunarfall",
    [585] = "Frostwall Mine",
    [586] = "Frostwall Mine",
    [587] = "Frostwall Mine",
    [588] = "Ashran",
    [589] = "Ashran Mine",
    [590] = "Frostwall",
--  [592] = "Defense of Karabor", -- Not in C_Map
    [593] = "Auchindoun",
    [594] = "Shattrath City",
    [595] = "Iron Docks",
    [596] = "Blackrock Foundry",
    [597] = "Blackrock Foundry",
    [598] = "Blackrock Foundry",
    [599] = "Blackrock Foundry",
    [600] = "Blackrock Foundry",
    [601] = "Skyreach",
    [602] = "Skyreach",
    [606] = "Grimrail Depot",
    [607] = "Grimrail Depot",
    [608] = "Grimrail Depot",
    [609] = "Grimrail Depot",
    [610] = "Highmaul",
    [611] = "Highmaul",
    [612] = "Highmaul",
    [613] = "Highmaul",
    [614] = "Highmaul",
    [615] = "Highmaul",
    [616] = "Upper Blackrock Spire",
    [617] = "Upper Blackrock Spire",
    [618] = "Upper Blackrock Spire",
    [619] = "Broken Isles",
    [620] = "The Everbloom",
    [621] = "The Everbloom",
    [622] = "Stormshield",
    [623] = "Hillsbrad Foothills (Southshore vs. Tarren Mill)",
    [624] = "Warspear",
    [625] = "Dalaran",
    [626] = "Dalaran",
    [627] = "Dalaran",
    [628] = "Dalaran",
    [629] = "Dalaran",
    [630] = "Azsuna",
    [631] = "Nar'thalas Academy",
    [632] = "Oceanus Cove",
    [633] = "Temple of a Thousand Lights",
    [634] = "Stormheim",
    [635] = "Shield's Rest",
    [636] = "Stormscale Cavern",
    [637] = "Thorignir Refuge",
    [638] = "Thorignir Refuge",
    [639] = "Aggramar's Vault",
    [640] = "Vault of Eyir",
    [641] = "Val'sharah",
    [642] = "Darkpens",
    [643] = "Sleeper's Barrow",
    [644] = "Sleeper's Barrow",
    [645] = "Twisting Nether",
    [646] = "Broken Shore",
    [647] = "Acherus: The Ebon Hold",
    [648] = "Acherus: The Ebon Hold",
    [649] = "Helheim",
    [650] = "Highmountain",
    [651] = "Bitestone Enclave",
    [652] = "Thunder Totem",
    [653] = "Cave of the Blood Trial",
    [654] = "Mucksnout Den",
    [655] = "Lifespring Cavern",
    [656] = "Lifespring Cavern",
    [657] = "Path of Huln",
    [658] = "Path of Huln",
    [659] = "Stonedark Grotto",
    [660] = "Feltotem Caverns",
    [661] = "Hellfire Citadel",
    [662] = "Hellfire Citadel",
    [663] = "Hellfire Citadel",
    [664] = "Hellfire Citadel",
    [665] = "Hellfire Citadel",
    [666] = "Hellfire Citadel",
    [667] = "Hellfire Citadel",
    [668] = "Hellfire Citadel",
    [669] = "Hellfire Citadel",
    [670] = "Hellfire Citadel",
    [671] = "The Cove of Nashal",
    [672] = "Mardum, the Shattered Abyss",
    [673] = "Cryptic Hollow",
    [674] = "Soul Engine",
    [675] = "Soul Engine",
    [676] = "Broken Shore",
    [677] = "Vault of the Wardens",
    [678] = "Vault of the Wardens",
    [679] = "Vault of the Wardens",
    [680] = "Suramar",
    [681] = "The Arcway Vaults",
    [682] = "Felsoul Hold",
    [683] = "The Arcway Vaults",
    [684] = "Shattered Locus",
    [685] = "Shattered Locus",
    [686] = "Elor'shan",
    [687] = "Kel'balor",
    [688] = "Ley Station Anora",
    [689] = "Ley Station Moonfall",
    [690] = "Ley Station Aethenar",
    [691] = "Nyell's Workshop",
    [692] = "Falanaar Arcway",
    [693] = "Falanaar Arcway",
    [694] = "Helmouth Shallows",
    [695] = "Skyhold",
    [696] = "Stormheim",
    [697] = "Azshara",
    [698] = "Icecrown Citadel",
    [699] = "Icecrown Citadel",
    [700] = "Icecrown Citadel",
    [701] = "Icecrown Citadel",
    [702] = "Netherlight Temple",
    [703] = "Halls of Valor",
    [704] = "Halls of Valor",
    [705] = "Halls of Valor",
    [706] = "Helmouth Cliffs",
    [707] = "Helmouth Cliffs",
    [708] = "Helmouth Cliffs",
    [709] = "The Wandering Isle",
    [710] = "Vault of the Wardens",
    [711] = "Vault of the Wardens",
    [712] = "Vault of the Wardens",
    [713] = "Eye of Azshara",
    [714] = "Niskara",
    [715] = "Emerald Dreamway",
    [716] = "Skywall",
    [717] = "Dreadscar Rift",
    [718] = "Dreadscar Rift",
    [719] = "Mardum, the Shattered Abyss",
    [720] = "Mardum, the Shattered Abyss",
    [721] = "Mardum, the Shattered Abyss",
    [723] = "The Violet Hold",
    [725] = "The Maelstrom",
    [726] = "The Maelstrom",
    [728] = "Terrace of Endless Spring",
    [729] = "Crumbling Depths",
    [731] = "Neltharion's Lair",
    [732] = "Violet Hold",
    [733] = "Darkheart Thicket",
    [734] = "Hall of the Guardian",
    [735] = "Hall of the Guardian",
    [736] = "The Beyond",
    [737] = "The Vortex Pinnacle",
    [738] = "Firelands",
    [739] = "Trueshot Lodge",
    [740] = "Shadowgore Citadel",
    [741] = "Shadowgore Citadel",
    [742] = "Abyssal Maw",
    [743] = "Abyssal Maw",
    [744] = "Ulduar",
    [745] = "Ulduar",
    [746] = "Ulduar",
    [747] = "The Dreamgrove",
    [748] = "Niskara",
    [749] = "The Arcway",
    [750] = "Thunder Totem",
    [751] = "Black Rook Hold",
    [752] = "Black Rook Hold",
    [753] = "Black Rook Hold",
    [754] = "Black Rook Hold",
    [755] = "Black Rook Hold",
    [756] = "Black Rook Hold",
    [757] = "Ursoc's Lair",
    [758] = "Gloaming Reef",
    [759] = "Black Temple",
    [760] = "Malorne's Nightmare",
    [761] = "Court of Stars",
    [762] = "Court of Stars",
    [763] = "Court of Stars",
    [764] = "The Nighthold",
    [765] = "The Nighthold",
    [766] = "The Nighthold",
    [767] = "The Nighthold",
    [768] = "The Nighthold",
    [769] = "The Nighthold",
    [770] = "The Nighthold",
    [771] = "The Nighthold",
    [772] = "The Nighthold",
    [773] = "Tol Barad",
    [774] = "Tol Barad",
    [775] = "The Exodar",
    [776] = "Azuremyst Isle",
    [777] = "The Emerald Nightmare",
    [778] = "The Emerald Nightmare",
    [779] = "The Emerald Nightmare",
    [780] = "The Emerald Nightmare",
    [781] = "The Emerald Nightmare",
    [782] = "The Emerald Nightmare",
    [783] = "The Emerald Nightmare",
    [784] = "The Emerald Nightmare",
    [785] = "The Emerald Nightmare",
    [786] = "The Emerald Nightmare",
    [787] = "The Emerald Nightmare",
    [788] = "The Emerald Nightmare",
    [789] = "The Emerald Nightmare",
    [790] = "Eye of Azshara",
    [791] = "Temple of the Jade Serpent",
    [792] = "Temple of the Jade Serpent",
    [793] = "Black Rook Hold",
    [794] = "Karazhan",
    [795] = "Karazhan",
    [796] = "Karazhan",
    [797] = "Karazhan",
    [798] = "The Arcway",
    [799] = "The Oculus",
    [800] = "The Oculus",
    [801] = "The Oculus",
    [802] = "The Oculus",
    [803] = "The Oculus",
    [804] = "Scarlet Monastery",
    [805] = "Scarlet Monastery",
    [806] = "Trial of Valor",
    [807] = "Trial of Valor",
    [808] = "Trial of Valor",
    [809] = "Karazhan",
    [810] = "Karazhan",
    [811] = "Karazhan",
    [812] = "Karazhan",
    [813] = "Karazhan",
    [814] = "Karazhan",
    [815] = "Karazhan",
    [816] = "Karazhan",
    [817] = "Karazhan",
    [818] = "Karazhan",
    [819] = "Karazhan",
    [820] = "Karazhan",
    [821] = "Karazhan",
    [822] = "Karazhan",
    [823] = "Pit of Saron",
    [824] = "Islands",
    [825] = "Wailing Caverns",
    [826] = "Cave of the Bloodtotem",
    [827] = "Stratholme",
    [828] = "The Eye of Eternity",
    [829] = "Halls of Valor",
    [830] = "Krokuun",
    [831] = "The Exodar",
    [832] = "The Exodar",
    [833] = "Nath'raxas Spire",
    [834] = "Coldridge Valley",
    [835] = "The Deadmines",
    [836] = "The Deadmines",
    [837] = "Arathi Basin",
    [838] = "Battle for Blackrock Mountain",
    [839] = "The Maelstrom",
    [840] = "Gnomeregan",
    [841] = "Gnomeregan",
    [842] = "Gnomeregan",
    [843] = "Shado-Pan Showdown",
    [844] = "Arathi Basin",
    [845] = "Cathedral of Eternal Night",
    [846] = "Cathedral of Eternal Night",
    [847] = "Cathedral of Eternal Night",
    [848] = "Cathedral of Eternal Night",
    [849] = "Cathedral of Eternal Night",
    [850] = "Tomb of Sargeras",
    [851] = "Tomb of Sargeras",
    [852] = "Tomb of Sargeras",
    [853] = "Tomb of Sargeras",
    [854] = "Tomb of Sargeras",
    [855] = "Tomb of Sargeras",
    [856] = "Tomb of Sargeras",
    [857] = "Throne of the Four Winds",
    [858] = "Assault on Broken Shore",
    [859] = "Warsong Gulch",
    [860] = "The Ruby Sanctum",
    [861] = "Mardum, the Shattered Abyss",
    [862] = "Zuldazar",
    [863] = "Nazmir",
    [864] = "Vol'dun",
    [865] = "Stormheim",
    [866] = "Stormheim",
    [867] = "Azsuna",
    [868] = "Val'sharah",
    [869] = "Highmountain",
    [870] = "Highmountain",
    [871] = "The Lost Glacier",
    [872] = "Stormstout Brewery",
    [873] = "Stormstout Brewery",
    [874] = "Stormstout Brewery",
    [875] = "Zandalar",
    [876] = "Kul Tiras",
    [877] = "Fields of the Eternal Hunt",
    [879] = "Mardum, the Shattered Abyss",
    [880] = "Mardum, the Shattered Abyss",
    [881] = "The Eye of Eternity",
    [882] = "Mac'Aree",
    [883] = "The Vindicaar",
    [884] = "The Vindicaar",
    [885] = "Antoran Wastes",
    [886] = "The Vindicaar",
    [887] = "The Vindicaar",
    [888] = "Hall of Communion",
    [889] = "Arcatraz",
    [890] = "Arcatraz",
    [891] = "Azuremyst Isle",
    [892] = "Azuremyst Isle",
    [893] = "Azuremyst Isle",
    [894] = "Azuremyst Isle",
    [895] = "Tiragarde Sound",
    [896] = "Drustvar",
    [897] = "The Deaths of Chromie",
    [898] = "The Deaths of Chromie",
    [899] = "The Deaths of Chromie",
    [900] = "The Deaths of Chromie",
    [901] = "The Deaths of Chromie",
    [902] = "The Deaths of Chromie",
    [903] = "The Seat of the Triumvirate",
    [904] = "Silithus Brawl",
    [905] = "Argus",
    [906] = "Arathi Highlands",
    [907] = "Seething Shore",
    [908] = "Ruins of Lordaeron",
    [909] = "Antorus, the Burning Throne",
    [910] = "Antorus, the Burning Throne",
    [911] = "Antorus, the Burning Throne",
    [912] = "Antorus, the Burning Throne",
    [913] = "Antorus, the Burning Throne",
    [914] = "Antorus, the Burning Throne",
    [915] = "Antorus, the Burning Throne",
    [916] = "Antorus, the Burning Throne",
    [917] = "Antorus, the Burning Throne",
    [918] = "Antorus, the Burning Throne",
    [919] = "Antorus, the Burning Throne",
    [920] = "Antorus, the Burning Throne",
    [921] = "Invasion Point: Aurinor",
    [922] = "Invasion Point: Bonich",
    [923] = "Invasion Point: Cen'gar",
    [924] = "Invasion Point: Naigtal",
    [925] = "Invasion Point: Sangua",
    [926] = "Invasion Point: Val",
    [927] = "Greater Invasion Point: Pit Lord Vilemus",
    [928] = "Greater Invasion Point: Mistress Alluradel",
    [929] = "Greater Invasion Point: Matron Folnuna",
    [930] = "Greater Invasion Point: Inquisitor Meto",
    [931] = "Greater Invasion Point: Sotanathor",
    [932] = "Greater Invasion Point: Occularus",
    [933] = "Forge of Aeons",
    [934] = "Atal'Dazar",
    [935] = "Atal'Dazar",
    [936] = "Freehold",
    [938] = "Gilneas Island",
    [939] = "Tropical Isle 8.0",
    [940] = "The Vindicaar",
    [941] = "The Vindicaar",
    [942] = "Stormsong Valley",
    [943] = "Arathi Highlands",
    [946] = "Cosmic",
    [947] = "Azeroth",
    [948] = "The Maelstrom",
    [971] = "Telogrus Rift",
    [972] = "Telogrus Rift",
    [973] = "The Sunwell",
    [974] = "Tol Dagor",
    [975] = "Tol Dagor",
    [976] = "Tol Dagor",
    [977] = "Tol Dagor",
    [978] = "Tol Dagor",
    [979] = "Tol Dagor",
    [980] = "Tol Dagor",
    [981] = "Un'gol Ruins",
    [985] = "Eastern Kingdoms",
    [986] = "Kalimdor",
    [987] = "Outland",
    [988] = "Northrend",
    [989] = "Pandaria",
    [990] = "Draenor",
    [991] = "Zandalar",
    [992] = "Kul Tiras",
    [993] = "Broken Isles",
    [994] = "Argus",
    [997] = "Tirisfal Glades",
    [998] = "Undercity",
    [1004] = "Kings' Rest",
    [1009] = "Atul'Aman",
    [1010] = "The MOTHERLODE!!",
    [1011] = "Zandalar",
    [1012] = "Stormwind City",
    [1013] = "The Stockade",
    [1014] = "Kul Tiras",
    [1015] = "Waycrest Manor",
    [1016] = "Waycrest Manor",
    [1017] = "Waycrest Manor",
    [1018] = "Waycrest Manor",
    [1021] = "Chamber of Heart",
    [1022] = "Uncharted Island",
    [1029] = "WaycrestDimension",
    [1030] = "Greymane Manor",
    [1031] = "Greymane Manor",
    [1032] = "Skittering Hollow",
    [1033] = "The Rotting Mire",
    [1034] = "Verdant Wilds",
    [1035] = "Molten Cay",
    [1036] = "The Dread Chain",
    [1037] = "Whispering Reef",
    [1038] = "Temple of Sethraliss",
    [1039] = "Shrine of the Storm",
    [1040] = "Shrine of the Storm",
    [1041] = "The Underrot",
    [1042] = "The Underrot",
    [1043] = "Temple of Sethraliss",
    [1044] = "Arathi Highlands",
    [1045] = "Thros, The Blighted Lands",
    [1148] = "Uldir",
    [1149] = "Uldir",
    [1150] = "Uldir",
    [1151] = "Uldir",
    [1152] = "Uldir",
    [1153] = "Uldir",
    [1154] = "Uldir",
    [1155] = "Uldir",
    [1156] = "The Great Sea",
    [1157] = "The Great Sea",
    [1158] = "Arathi Highlands",
    [1159] = "Blackrock Depths",
    [1160] = "Blackrock Depths",
    [1161] = "Boralus",
    [1162] = "Siege of Boralus",
    [1163] = "Dazar'alor",
    [1164] = "Dazar'alor",
    [1165] = "Dazar'alor",
    [1166] = "Zanchul",
    [1167] = "Zanchul",
    [1169] = "Tol Dagor",
    [1170] = "Gorgrond - Mag'har Scenario",
    [1171] = "Gol Thovas",
    [1172] = "Gol Thovas",
    [1173] = "Rastakhan's Might",
    [1174] = "Rastakhan's Might",
    [1176] = "Breath Of Pa'ku",
    [1177] = "Breath Of Pa'ku",
    [1179] = "Abyssal Melody",
    [1180] = "Abyssal Melody",
    [1181] = "Zuldazar",
    [1182] = "SalstoneMine_Stormsong",
    [1183] = "Thornheart",
    [1184] = "Winterchill Mine",
    [1185] = "Winterchill Mine",
    [1186] = "Blackrock Depths",
    [1187] = "Azsuna",
    [1188] = "Val'sharah",
    [1189] = "Highmountain",
    [1190] = "Stormheim",
    [1191] = "Suramar",
    [1192] = "Broken Shore",
    [1193] = "Zuldazar",
    [1194] = "Nazmir",
    [1195] = "Vol'dun",
    [1196] = "Tiragarde Sound",
    [1197] = "Drustvar",
    [1198] = "Stormsong Valley",
    [1203] = "Darkshore",
    [1208] = "Eastern Kingdoms",
    [1209] = "Kalimdor",
    [1244] = "Arathi Highlands",
    [1245] = "Badlands",
    [1246] = "Blasted Lands",
    [1247] = "Tirisfal Glades",
    [1248] = "Silverpine Forest",
    [1249] = "Western Plaguelands",
    [1250] = "Eastern Plaguelands",
    [1251] = "Hillsbrad Foothills",
    [1252] = "The Hinterlands",
    [1253] = "Dun Morogh",
    [1254] = "Searing Gorge",
    [1255] = "Burning Steppes",
    [1256] = "Elwynn Forest",
    [1257] = "Deadwind Pass",
    [1258] = "Duskwood",
    [1259] = "Loch Modan",
    [1260] = "Redridge Mountains",
    [1261] = "Swamp of Sorrows",
    [1262] = "Westfall",
    [1263] = "Wetlands",
    [1264] = "Stormwind City",
    [1265] = "Ironforge",
    [1266] = "Undercity",
    [1267] = "Eversong Woods",
    [1268] = "Ghostlands",
    [1269] = "Silvermoon City",
    [1270] = "Isle of Quel'Danas",
    [1271] = "Gilneas",
    [1272] = "Vashj'ir",
    [1273] = "Ruins of Gilneas",
    [1274] = "Stranglethorn Vale",
    [1275] = "Twilight Highlands",
    [1276] = "Tol Barad",
    [1277] = "Tol Barad Peninsula",
    [1305] = "Durotar",
    [1306] = "Mulgore",
    [1307] = "Northern Barrens",
    [1308] = "Teldrassil",
    [1309] = "Darkshore",
    [1310] = "Ashenvale",
    [1311] = "Thousand Needles",
    [1312] = "Stonetalon Mountains",
    [1313] = "Desolace",
    [1314] = "Feralas",
    [1315] = "Dustwallow Marsh",
    [1316] = "Tanaris",
    [1317] = "Azshara",
    [1318] = "Felwood",
    [1319] = "Un'Goro Crater",
    [1320] = "Moonglade",
    [1321] = "Silithus",
    [1322] = "Winterspring",
    [1323] = "Thunder Bluff",
    [1324] = "Darnassus",
    [1325] = "Azuremyst Isle",
    [1326] = "The Exodar",
    [1327] = "Bloodmyst Isle",
    [1328] = "Mount Hyjal",
    [1329] = "Southern Barrens",
    [1330] = "Uldum",
    [1331] = "The Exodar",
    [1332] = "Darkshore",
    [1333] = "Darkshore",
    [1334] = "Wintergrasp",
    [1335] = "Cooking: Impossible",
    [1336] = "Havenswood",
    [1337] = "Jorundall",
    [1338] = "Darkshore",
    [1339] = "Warsong Gulch",
    [1343] = "8.1 Darkshore Outdoor Final Phase",
    [1345] = "Crucible of Storms",
    [1346] = "Crucible of Storms",
    [1347] = "Zandalari Treasury",
    [1348] = "Zandalari Treasury",
    [1349] = "Tol Dagor",
    [1350] = "Tol Dagor",
    [1351] = "Tol Dagor",
    [1352] = "Battle of Dazar'alor",
    [1353] = "Battle of Dazar'alor",
    [1354] = "Battle of Dazar'alor",
    [1356] = "Battle of Dazar'alor",
    [1357] = "Battle of Dazar'alor",
    [1358] = "Battle of Dazar'alor",
    [1359] = "Icecrown Citadel",
    [1360] = "Icecrown Citadel",
    [1361] = "OldIronforge",
    [1362] = "Shrine of the Storm",
    [1363] = "CrucibleRaid_Bottom_Intro",
    [1364] = "Battle of Dazar'alor",
    [1366] = "Arathi Basin",
    [1367] = "Battle of Dazar'alor",	
    [1381] = "Uldir",
    [1382] = "Uldir",
    [1383] = "Arathi Basin",
    [1384] = "Northrend",
    [1396] = "Borean Tundra",
    [1397] = "Dragonblight",
    [1398] = "Grizzly Hills",
    [1399] = "Howling Fjord",
    [1400] = "Icecrown",
    [1401] = "Sholazar Basin",
    [1402] = "The Storm Peaks",
    [1403] = "Zul'Drak",
    [1404] = "Wintergrasp",
    [1405] = "Crystalsong Forest",
    [1406] = "Hrothgar's Landing",
    [1407] = "Prison of Ink",
    [1408] = "Ashran",
    [1465] = "Scarlet Halls",
    [1467] = "Outland",	
}


-- These zones are known in LibTourist's zones collection but are not returned by C_Map.GetMapInfo.
-- The IDs are the areaIDs as used by C_Map.GetAreaInfo.
local zoneTranslation = {
	enUS = {		
		-- Complexes
		[4406] = "The Ring of Valor",
		[3905] = "Coilfang Reservoir",
		[3893] = "Ring of Observance",
		[4024] = "Coldarra",

		-- Transports
		[72] = "The Dark Portal",

		-- Dungeons
		[5914] = "Dire Maul - East",
		[5913] = "Dire Maul - North",
		[5915] = "Dire Maul - West",

		-- Arenas
		[3698] = "Nagrand Arena",   -- was 559
		[3702] = "Blade's Edge Arena",  -- was 562
		[4378] = "Dalaran Arena",
		[6732] = "The Tiger's Peak",

		-- Other
		[3508] = "Amani Pass",
		[3979] = "The Frozen Sea",
	},
	deDE = {
		-- Complexes
		[4406] = "Der Ring der Ehre",
		[3905] = "Der Echsenkessel",
		[3893] = "Ring der Beobachtung",
		[4024] = "Kaltarra",

		-- Transports
		[72] = "Das Dunkle Portal",

		-- Dungeons
		[5914] = "Düsterbruch - Ost",
		[5913] = "Düsterbruch - Nord",
		[5915] = "Düsterbruch - West",

		-- Arenas
		[3698] = "Arena von Nagrand",
		[3702] = "Arena des Schergrats",
		[4378] = "Arena von Dalaran",
		[6732] = "Der Tigergipfel", 

		-- Other
		[3508] = "Amanipass",
		[3979] = "Die Gefrorene See",
	},
	esES = {
		-- Complexes
		[4406] = "El Círculo del Valor",
		[3905] = "Reserva Colmillo Torcido",
		[3893] = "Círculo de la Observancia",
		[4024] = "Gelidar",

		-- Transports
		[72] = "El Portal Oscuro",

		-- Dungeons
		[5914] = "La Masacre: Este",
		[5913] = "La Masacre: Norte",
		[5915] = "La Masacre: Oeste",

		-- Arenas
		[3698] = "Arena de Nagrand",
		[3702] = "Arena Filospada",
		[4378] = "Arena de Dalaran",
		[6732] = "La Cima del Tigre",

		-- Other
		[3508] = "Paso de Amani",
		[3979] = "El Mar Gélido",
	},
	esMX = {
		-- Complexes
		[4406] = "El Círculo del Valor",
		[3905] = "Reserva Colmillo Torcido",
		[3893] = "Círculo de la Observancia",
		[4024] = "Gelidar",

		-- Transports
		[72] = "El Portal Oscuro",

		-- Dungeons
		[5914] = "La Masacre: Este",
		[5913] = "La Masacre: Norte",
		[5915] = "La Masacre: Oeste",

		-- Arenas
		[3698] = "Arena de Nagrand",
		[3702] = "Arena Filospada",
		[4378] = "Arena de Dalaran",
		[6732] = "La Cima del Tigre",

		-- Other
		[3508] = "Paso de Amani",
		[3979] = "El Mar Gélido",
	},
	frFR = {
		-- Complexes
		[4406] = "L’arène des Valeureux",
		[3905] = "Réservoir de Glissecroc",
		[3893] = "Cercle d’observance",
		[4024] = "Frimarra",

		-- Transports
		[72] = "La porte des Ténèbres",

		-- Dungeons
		[5914] = "Haches-Tripes - Est",
		[5913] = "Haches-Tripes - Nord",
		[5915] = "Haches-Tripes - Ouest",

		-- Arenas
		[3698] = "Arène de Nagrand",
		[3702] = "Arène des Tranchantes",
		[4378] = "Arène de Dalaran",
		[6732] = "Le croc du Tigre",

		-- Other
		[3508] = "Passage des Amani",
		[3979] = "La mer Gelée",
	},
	itIT = {
		-- Complexes
		[4406] = "Arena del Valore",
		[3905] = "Bacino degli Spiraguzza",
		[3893] = "Anello dell'Osservanza",
		[4024] = "Ibernia",

		-- Transports
		[72] = "Portale Oscuro",

		-- Dungeons
		[5914] = "Maglio Infausto - Est",
		[5913] = "Maglio Infausto - Nord",
		[5915] = "Maglio Infausto - Ovest",

		-- Arenas
		[3698] = "Arena di Nagrand",
		[3702] = "Arena di Spinaguzza",
		[4378] = "Arena di Dalaran",
		[6732] = "Picco della Tigre",

		-- Other
		[3508] = "Passo degli Amani",
		[3979] = "Mare Ghiacciato",
	},
	koKR = {
		-- Complexes
		[4406] = "용맹의 투기장",
		[3905] = "갈퀴송곳니 저수지",
		[3893] = "규율의 광장",
		[4024] = "콜다라",

		-- Transports
		[72] = "어둠의 문",

		-- Dungeons
		[5914] = "혈투의 전장 - 동쪽",
		[5913] = "혈투의 전장 - 북쪽",
		[5915] = "혈투의 전장 - 서쪽",

		-- Arenas
		[3698] = "나그란드 투기장",
		[3702] = "칼날 산맥 투기장",
		[4378] = "달라란 투기장",
		[6732] = "범의 봉우리",

		-- Other
		[3508] = "아마니 고개",
		[3979] = "얼어붙은 바다",
	},
	ptBR = {
		-- Complexes
		[4406] = "Ringue dos Valorosos",
		[3905] = "Reservatório Presacurva",
		[3893] = "Círculo da Obediência",
		[4024] = "Gelarra",

		-- Transports
		[72] = "Portal Negro",

		-- Dungeons
		[5914] = "Gládio Cruel – Leste",
		[5913] = "Gládio Cruel – Norte",
		[5915] = "Gládio Cruel – Oeste",

		-- Arenas
		[3698] = "Arena de Nagrand",
		[3702] = "Arena da Lâmina Afiada",
		[4378] = "Arena de Dalaran",
		[6732] = "O Pico do Tigre",
		
		-- Other
		[3508] = "Desfiladeiro Amani",
		[3979] = "Mar Congelado",
	},
	ruRU = {
		-- Complexes
		[4406] = "Арена Доблести",
		[3905] = "Резервуар Кривого Клыка",
		[3893] = "Ритуальный Круг",
		[4024] = "Хладарра",

		-- Transports
		[72] = "Темный портал",

		-- Dungeons
		[5914] = "Забытый город – восток",
		[5913] = "Забытый город – север",
		[5915] = "Забытый город – запад",

		-- Arenas
		[3698] = "Арена Награнда",
		[3702] = "Арена Острогорья",
		[4378] = "Арена Даларана",
		[6732] = "Пик Тигра",
		
		-- Other
		[3508] = "Перевал Амани",
		[3979] = "Ледяное море",
	},
	zhCN = {
		-- Complexes
		[4406] = "勇气竞技场",
		[3905] = "盘牙水库",
		[3893] = "仪式广场",
		[4024] = "考达拉",

		-- Transports
		[72] = "黑暗之门",

		-- Dungeons
		[5914] = "厄运之槌 - 东",
		[5913] = "厄运之槌 - 北",
		[5915] = "厄运之槌 - 西",

		-- Arenas
		[3698] = "纳格兰竞技场",
		[3702] = "刀锋山竞技场",
		[4378] = "达拉然竞技场",
		[6732] = "虎踞峰",
		
		-- Other
		[3508] = "阿曼尼小径",
		[3979] = "冰冻之海",
	},
	zhTW = {
		-- Complexes
		[4406] = "勇武競技場",
		[3905] = "盤牙蓄湖",
		[3893] = "儀式競技場",
		[4024] = "凜懼島",

		-- Transports
		[72] = "黑暗之門",

		-- Dungeons
		[5914] = "厄運之槌 - 東方",
		[5913] = "厄運之槌 - 北方",
		[5915] = "厄運之槌 - 西方",

		-- Arenas
		[3698] = "納葛蘭競技場",
		[3702] = "劍刃競技場",
		[4378] = "達拉然競技場",
		[6732] = "猛虎峰",
		
		-- Other
		[3508] = "阿曼尼小徑",
		[3979] = "冰凍之海",
	},
}

local function CreateLocalizedZoneNameLookups()
	local uiMapID
	local mapInfo
	local localizedZoneName
	local englishZoneName

	-- 8.0: Use the C_Map API
	-- Note: the loop below is not very sexy but makes sure missing entries in MapIdLookupTable are reported.
	-- It is executed only once, upon initialization.
	for uiMapID = 1, 5000, 1 do
		mapInfo = C_Map.GetMapInfo(uiMapID)	
		if mapInfo then
			localizedZoneName = mapInfo.name
			englishZoneName = MapIdLookupTable[uiMapID]
			
			if englishZoneName then 		
				-- Add combination of English and localized name to lookup tables
				if not BZ[englishZoneName] then
					BZ[englishZoneName] = localizedZoneName
				end
				if not BZR[localizedZoneName] then
					BZR[localizedZoneName] = englishZoneName
				end	
			else
				-- Not in lookup
				trace("|r|cffff4422! -- Tourist:|r English name not found in lookup for uiMapID "..tostring(uiMapID).." ("..tostring(localizedZoneName)..")" )				
			end
		end
	end

	-- Load from zoneTranslation
	local GAME_LOCALE = GetLocale()
	for key, localizedZoneName in pairs(zoneTranslation[GAME_LOCALE]) do
		local englishName = zoneTranslation["enUS"][key]
		if not BZ[englishName] then
			BZ[englishName] = localizedZoneName
		end
		if not BZR[localizedZoneName] then
			BZR[localizedZoneName] = englishName
		end
	end
end

local function AddDuplicatesToLocalizedLookup()
	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("The Maelstrom", THE_MAELSTROM_MAP_ID)] = Tourist:GetUniqueZoneNameForLookup("The Maelstrom", THE_MAELSTROM_MAP_ID)
	BZR[Tourist:GetUniqueZoneNameForLookup("The Maelstrom", THE_MAELSTROM_MAP_ID)] = Tourist:GetUniqueEnglishZoneNameForLookup("The Maelstrom", THE_MAELSTROM_MAP_ID)
	
	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("Nagrand", DRAENOR_MAP_ID)] = Tourist:GetUniqueZoneNameForLookup("Nagrand", DRAENOR_MAP_ID)
	BZR[Tourist:GetUniqueZoneNameForLookup("Nagrand", DRAENOR_MAP_ID)] = Tourist:GetUniqueEnglishZoneNameForLookup("Nagrand", DRAENOR_MAP_ID)

	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("Shadowmoon Valley", DRAENOR_MAP_ID)] = Tourist:GetUniqueZoneNameForLookup("Shadowmoon Valley", DRAENOR_MAP_ID)
	BZR[Tourist:GetUniqueZoneNameForLookup("Shadowmoon Valley", DRAENOR_MAP_ID)] = Tourist:GetUniqueEnglishZoneNameForLookup("Shadowmoon Valley", DRAENOR_MAP_ID)
	
	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("Hellfire Citadel", DRAENOR_MAP_ID)] = Tourist:GetUniqueZoneNameForLookup("Hellfire Citadel", DRAENOR_MAP_ID)
	BZR[Tourist:GetUniqueZoneNameForLookup("Hellfire Citadel", DRAENOR_MAP_ID)] = Tourist:GetUniqueEnglishZoneNameForLookup("Hellfire Citadel", DRAENOR_MAP_ID)
	
	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("Dalaran", BROKEN_ISLES_MAP_ID)] = Tourist:GetUniqueZoneNameForLookup("Dalaran", BROKEN_ISLES_MAP_ID)
	BZR[Tourist:GetUniqueZoneNameForLookup("Dalaran", BROKEN_ISLES_MAP_ID)] = Tourist:GetUniqueEnglishZoneNameForLookup("Dalaran", BROKEN_ISLES_MAP_ID)
	
	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("The Violet Hold", BROKEN_ISLES_MAP_ID)] = Tourist:GetUniqueZoneNameForLookup("The Violet Hold", BROKEN_ISLES_MAP_ID)
	BZR[Tourist:GetUniqueZoneNameForLookup("The Violet Hold", BROKEN_ISLES_MAP_ID)] = Tourist:GetUniqueEnglishZoneNameForLookup("The Violet Hold", BROKEN_ISLES_MAP_ID)
end

local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function GetFlightnodeFaction(faction)
	if faction == 0 then
		return "Neutral"
	end
	if faction == 1 then
		return "Horde"
	end
	if faction == 2 then
		return "Alliance"
	else
		return tostring(faction)
	end
end

--[[
	GatherFlightnodeData is called just in time, right before first use, because when LibTourist is being loaded at player logon,
	not all flightpoints are available yet through the C_TaxiMap interface.

	The FlightnodeLookupTable, which is built during initialization using the hardcoded relationships between zones and nodes, 
	contains the flightnode IDs but no values yet. GatherFlightnodeData fills the lookup as much as possible with MapTaxiNodeInfo 
	structures retrieved from the C_TaxiMap interface.
	
	structure TaxiMap.MapTaxiNodeInfo
		number nodeID						-- unique node ID
		table position						-- position of the node on the Flight Master's map
		string name							-- node name as displayed in game, includes zone name (mostly)
		string atlasName					-- atlas object type, includes faction
		Enum.FlightPathFaction faction		-- 0 = Neutral, 1 = Horde, 2 = Alliance
		(optional) string textureKitPrefix	-- no clue what this is for
		string factionName					-- added by LibTourist
]]--

local function GatherFlightnodeData()
	local zMapID, zName, nodes
	local count = 0
	local errCount = 0
	if gatheringFlightnodes == true then return end
	gatheringFlightnodes = true
	
	local missingNodes = {}
	
	
	-- Add node objects from the C_TaxiMap interface to the lookup
	for zMapID, zName in pairs(MapIdLookupTable) do	
		-- Use MapIdLookupTable instead of iterating through continents and zones to be sure all known zones are checked for flight nodes
--		cMapID = Tourist:GetContinentMapID(zMapID)
--		cName = MapIdLookupTable[cMapID]
		nodes = C_TaxiMap.GetTaxiNodesForMap(zMapID)

		if nodes ~= nil then
			numNodes = tablelength(nodes)
			if numNodes > 0 then
				for i, node in ipairs(nodes) do
					if not FlightnodeLookupTable[node.nodeID] then
						if not missingNodes[node.nodeID] then
							trace("|r|cffff4422! -- Tourist: Missing flightnode in lookup: "..tostring(node.nodeID).." = "..tostring(node.name))
							errCount = errCount + 1
							missingNodes[node.nodeID] = node.name
						end
					else
						if FlightnodeLookupTable[node.nodeID] == true then
							count = count + 1
							-- Add faction name
							node["factionName"] = GetFlightnodeFaction(node.faction)
							-- Store node object in lookup
							FlightnodeLookupTable[node.nodeID] = node
						end
					end
				end
			end
		end	
	end

	-- Add hardcoded node-to-zone relations to FlightnodeLookupTable
	local nodesToUpdate = {}
	for zone in Tourist:IterateZones() do
		for node in Tourist:IterateZoneFlightnodes(zone) do
			if FlightnodeLookupTable[node.nodeID] then
				if not nodesToUpdate[node.nodeID] then
					nodesToUpdate[node.nodeID] = {}
				end
				nodesToUpdate[node.nodeID][zone] = true
			else
				trace("|r|cffff4422! -- Tourist: Missing flightnode in lookup: "..tostring(node.nodeID).." = "..tostring(node.name))
				errCount = errCount + 1
			end
		end
	end
	for k, v in pairs(nodesToUpdate) do
		FlightnodeLookupTable[k]["zones"] = v
	end
	
	trace("Tourist: Found "..tostring(count).." of "..tostring(tablelength(FlightnodeLookupTable)).." known flight nodes; "..tostring(errCount).." unknown nodes.")

	flightnodeDataGathered = true
	gatheringFlightnodes = false
end

-- Refreshes the values of the FlightnodeLookupTable
function Tourist:RefreshFlightNodeData()
	-- Reset lookup
	for k, v in pairs(FlightnodeLookupTable) do
		FlightnodeLookupTable[k] = true
	end
	-- Re-gather data
	GatherFlightnodeData()
end

-- Returns the lookup table with all flightnodes. Key = node ID.
-- Value is a node struct(see C_Taximap.MapTaxiNodeInfo) if the node could be found by GatherFlightnodeData.
-- If the node was not returned by C_Taximap, value is true.
function Tourist:GetFlightnodeLookupTable()
	if flightnodeDataGathered == false then
		GatherFlightnodeData()
	end
	return FlightnodeLookupTable
end

-- Returns a C_Taximap.MapTaxiNodeInfo (with some extra attributes) for the specified nodeID, if available
function Tourist:GetFlightnode(nodeID)
	local node = Tourist:GetFlightnodeLookupTable()[nodeID]
	if node == true then 
		return nil
	else
		return node
	end
end

-- This function replaces the abandoned LibBabble-Zone library and returns a lookup table 
-- containing all zone names (including continents, instances etcetera) where the English 
-- zone name is the key and the localized zone name is the value.
function Tourist:GetLookupTable()
	return BZ
end

-- This function replaces the abandoned LibBabble-Zone library and returns a lookup table 
-- containing all zone names (including continents, instances etcetera) where the localized 
-- zone name is the key and the English zone name is the value.
function Tourist:GetReverseLookupTable()
	return BZR
end

-- Returns the lookup table with all uiMapIDs as key and the English zone name as value.
function Tourist:GetMapIDLookupTable()
	return MapIdLookupTable
end




-- HELPER AND LOOKUP FUNCTIONS -------------------------------------------------------------

local function PLAYER_LEVEL_UP(self, level)
	playerLevel = UnitLevel("player")
	
	for k in pairs(recZones) do
		recZones[k] = nil
	end
	for k in pairs(recInstances) do
		recInstances[k] = nil
	end
	for k in pairs(cost) do
		cost[k] = nil
	end

	for zone in pairs(lows) do
		if not self:IsHostile(zone) then
			local low, high, scaled = self:GetLevel(zone)
			if scaled then
				low = scaled
				high = scaled
			end
			
			local zoneType = self:GetType(zone)
			if zoneType == "Zone" or zoneType == "PvP Zone" and low and high then
				if low <= playerLevel and playerLevel <= high then
					recZones[zone] = true
				end
			elseif zoneType == "Battleground" and low and high then
				local playerLevel = playerLevel
				if low <= playerLevel and playerLevel <= high then
					recInstances[zone] = true
				end
			elseif zoneType == "Instance" and low and high then
				if low <= playerLevel and playerLevel <= high then
					recInstances[zone] = true
				end
			end
		end
	end
end


-- Public alternative for GetMapContinents, removes the map IDs that were added to its output in WoW 6.0
-- Note: GetMapContinents has been removed entirely in 8.0
-- 8.0.1: returns uiMapID as key
function Tourist:GetMapContinentsAlt()
	local continents = C_Map.GetMapChildrenInfo(COSMIC_MAP_ID, Enum.UIMapType.Continent, true)
	local retValue = {}
	for i, continentInfo in ipairs(continents) do
		--trace("Continent "..tostring(i)..": "..continentInfo.mapID..": ".. continentInfo.name)
		retValue[continentInfo.mapID] = continentInfo.name
	end
	return retValue
end

-- Public Alternative for GetMapZones because GetMapZones does NOT return all zones (as of 6.0.2), 
-- making its output useless as input for SetMapZoom. 
-- Note: GetMapZones has been removed entirely in 8.0, just as SetMapZoom
-- NOTE: This method does not convert duplicate zone names for lookup in LibTourist,
-- use GetUniqueZoneNameForLookup for that.
-- 8.0.1: returns uiMapID as key
function Tourist:GetMapZonesAlt(continentID)
	if mapZonesByContinentID[continentID] then
		-- Get from cache
		return mapZonesByContinentID[continentID]
	else	
		local mapZones = {}
		local mapChildrenInfo = { C_Map.GetMapChildrenInfo(continentID, Enum.UIMapType.Zone, true) }
		for key, zones in pairs(mapChildrenInfo) do  -- don't know what this extra table is for
			for zoneIndex, zone in pairs(zones) do
				-- Get the localized zone name
				mapZones[zone.mapID] = zone.name
			end
		end

		-- Add to cache
		mapZonesByContinentID[continentID] = mapZones		
		
		return mapZones
	end
end

-- Public alternative for GetMapNameByID (which was removed in 8.0.1), 
-- returns a unique localized zone name to be used to lookup data in LibTourist
function Tourist:GetMapNameByIDAlt(uiMapID)
	if tonumber(uiMapID) == nil then
		return nil
	end

	local mapInfo = C_Map.GetMapInfo(uiMapID)
	if mapInfo then
		local zoneName = C_Map.GetMapInfo(uiMapID).name
		local continentMapID = Tourist:GetContinentMapID(uiMapID)
		--trace("ContinentMap ID for "..tostring(zoneName).." ("..tostring(uiMapID)..") is "..tostring(continentMapID))
		if uiMapID == THE_MAELSTROM_MAP_ID then
			-- Exception for The Maelstrom continent because GetUniqueZoneNameForLookup excpects the zone mane and not the continent name
			return zoneName
		else
			return Tourist:GetUniqueZoneNameForLookup(zoneName, continentMapID)
		end
	else
		return nil
	end
end 

-- Returns the uiMapID of the Continent for the given uiMapID
function Tourist:GetContinentMapID(uiMapID)
	-- First, check the cache, built during initialisation based on the zones returned by GetMapZonesAlt
	local continentMapID = zoneMapIDtoContinentMapID[uiMapID]
	if continentMapID then
		-- Done
		return continentMapID
	end
	
	-- Not in cache, look for the continent, searching up through the map hierarchy.
	-- Add the results to the cache to speed up future queries.
	local mapInfo = C_Map.GetMapInfo(uiMapID)
	if not mapInfo or mapInfo.mapType == 0 or mapInfo.mapType == 1 then
		-- No data or Cosmic map or World map
		zoneMapIDtoContinentMapID[uiMapID] = nil
		return nil
	end
	
	if mapInfo.mapType == 2 then
		-- Map is a Continent map
		zoneMapIDtoContinentMapID[uiMapID] = mapInfo.mapID
		return mapInfo.mapID
	end
	
	local parentMapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
	if not parentMapInfo then
		-- No parent -> no continent ID
		zoneMapIDtoContinentMapID[uiMapID] = nil
		return nil
	else
		if parentMapInfo.mapType == 2 then
			-- Found the continent
			zoneMapIDtoContinentMapID[uiMapID] = parentMapInfo.mapID
			return parentMapInfo.mapID
		else
			-- Parent is not the Continent -> Search up one level
			return Tourist:GetContinentMapID(parentMapInfo.mapID)
		end
	end
end

-- Returns a unique localized zone name to be used to lookup data in LibTourist,
-- based on a localized or English zone name
function Tourist:GetUniqueZoneNameForLookup(zoneName, continentMapID)
	if continentMapID == THE_MAELSTROM_MAP_ID then  -- The Maelstrom
		if zoneName == BZ["The Maelstrom"] or zoneName == "The Maelstrom" then
			zoneName = BZ["The Maelstrom"].." (zone)"
		end
	end
	if continentMapID == DRAENOR_MAP_ID then  -- Draenor
		if zoneName == BZ["Nagrand"] or zoneName == "Nagrand"  then
			zoneName = BZ["Nagrand"].." ("..BZ["Draenor"]..")"
		end
		if zoneName == BZ["Shadowmoon Valley"] or zoneName == "Shadowmoon Valley"  then
			zoneName = BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"
		end
		if zoneName == BZ["Hellfire Citadel"] or zoneName == "Hellfire Citadel"  then
			zoneName = BZ["Hellfire Citadel"].." ("..BZ["Draenor"]..")"
		end
	end
	if continentMapID == BROKEN_ISLES_MAP_ID then  -- Broken Isles
		if zoneName == BZ["Dalaran"] or zoneName == "Dalaran"  then
			zoneName = BZ["Dalaran"].." ("..BZ["Broken Isles"]..")"
		end
		if zoneName == BZ["The Violet Hold"] or zoneName == "The Violet Hold"  then
			zoneName = BZ["The Violet Hold"].." ("..BZ["Broken Isles"]..")"
		end
	end
	return zoneName
end

-- Returns a unique English zone name to be used to lookup data in LibTourist,
-- based on a localized or English zone name
function Tourist:GetUniqueEnglishZoneNameForLookup(zoneName, continentMapID)
	if continentMapID == THE_MAELSTROM_MAP_ID then  -- The Maelstrom
		if zoneName == BZ["The Maelstrom"] or zoneName == "The Maelstrom" then
			zoneName = "The Maelstrom (zone)"
		end
	end
	if continentMapID == DRAENOR_MAP_ID then -- Draenor
		if zoneName == BZ["Nagrand"] or zoneName == "Nagrand" then
			zoneName = "Nagrand (Draenor)"
		end
		if zoneName == BZ["Shadowmoon Valley"] or zoneName == "Shadowmoon Valley" then
			zoneName = "Shadowmoon Valley (Draenor)"
		end
		if zoneName == BZ["Hellfire Citadel"] or zoneName == "Hellfire Citadel" then
			zoneName = "Hellfire Citadel (Draenor)"
		end
	end
	if continentMapID == BROKEN_ISLES_MAP_ID then  -- Broken Isles
		if zoneName == BZ["Dalaran"] or zoneName == "Dalaran" then
			zoneName = "Dalaran (Broken Isles)"
		end	
		if zoneName == BZ["The Violet Hold"] or zoneName == "The Violet Hold"  then
			zoneName = "The Violet Hold (Broken Isles)"
		end
	end
	return zoneName
end

-- Minimum fishing skill to fish these zones junk-free (Draenor: to catch Enormous Fish only)
-- 8.0.1: SUSPENDED until it is clear how the fishing skills currently work, if a minimum skill is still required 
-- and how it should be calculated. There is no WoW API for this.
function Tourist:GetFishingLevel(zone)
	return 0
--	zone = Tourist:GetMapNameByIDAlt(zone) or zone
--	return fishing[zone]
end

-- Returns the minimum and maximum battle pet levels for the given zone, if the zone is known 
-- and contains battle pets (otherwise returns nil)
function Tourist:GetBattlePetLevel(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return battlepet_lows[zone], battlepet_highs[zone]
end

-- WoW patch 7.3.5: most zones now scale - within their level range - to the player's level
function Tourist:GetScaledZoneLevel(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local playerLvl = playerLevel

	if playerLvl <= lows[zone] then 
		return lows[zone]
	elseif playerLvl >= highs[zone] then
		return highs[zone]
	else
		return playerLvl
	end
end


-- Formats the minimum and maximum player level for the given zone as "[min]-[max]". 
-- Returns one number if min and max are equal. 
-- Returns an empty string if no player levels are applicable (like in Cities).
-- If zone is a zone or an instance, the string will be formatted like "[scaled] ([min]-[max])", i.e. "47 (40-60)".
function Tourist:GetLevelString(zone)
	local lo, hi, scaled = Tourist:GetLevel(zone)
	
	if lo and hi then
		if scaled then
			if lo == hi then
				return tostring(scaled).." ("..tostring(lo)..")"
			else
				return tostring(scaled).." ("..tostring(lo).."-"..tostring(hi)..")"
			end
		else	
			if lo == hi then
				return tostring(lo)
			else
				return tostring(lo).."-"..tostring(hi)
			end
		end
	else
		return tostring(lo or hi or "")
	end
end


-- Formats the minimum and maximum battle pet level for the given zone as "min-max". 
-- Returns one number if min and max are equal. Returns an empty string if no battle pet levels are available.
function Tourist:GetBattlePetLevelString(zone)
	local lo, hi = Tourist:GetBattlePetLevel(zone)
	if lo and hi then
		if lo == hi then
			return tostring(lo)
		else
			return tostring(lo).."-"..tostring(hi)
		end
	else
		return tostring(lo or hi or "")
	end
end

-- Returns the minimum and maximum level for the given zone, instance or battleground.
-- If zone is a zone or an instance, a third value is returned: the scaled zone level. 
-- This is the level 'presented' to the player when inside the zone. It's calculated by GetScaledZoneLevel.
function Tourist:GetLevel(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone

	if types[zone] == "Battleground" then
		-- Note: Not all BG's start at level 10, but all BG's support players up to MAX_PLAYER_LEVEL.

		local playerLvl = playerLevel
		if playerLvl <= lows[zone] then
			-- Player is too low level to enter the BG -> return the lowest available bracket
			-- by assuming the player is at the min level required for the BG.
			playerLvl = lows[zone]
		end

		-- Find the most suitable bracket
		if playerLvl >= MAX_PLAYER_LEVEL then
			return MAX_PLAYER_LEVEL, MAX_PLAYER_LEVEL, nil
		elseif playerLvl >= 115 then
			return 115, 119, nil
		elseif playerLvl >= 110 then
			return 110, 114, nil
		elseif playerLvl >= 105 then
			return 105, 109, nil
		elseif playerLvl >= 100 then
			return 100, 104, nil			
		elseif playerLvl >= 95 then
			return 95, 99, nil
		elseif playerLvl >= 90 then
			return 90, 94, nil
		elseif playerLvl >= 85 then
			return 85, 89, nil
		elseif playerLvl >= 80 then
			return 80, 84, nil
		elseif playerLvl >= 75 then
			return 75, 79, nil
		elseif playerLvl >= 70 then
			return 70, 74, nil
		elseif playerLvl >= 65 then
			return 65, 69, nil
		elseif playerLvl >= 60 then
			return 60, 64, nil
		elseif playerLvl >= 55 then
			return 55, 59, nil
		elseif playerLvl >= 50 then
			return 50, 54, nil
		elseif playerLvl >= 45 then
			return 45, 49, nil
		elseif playerLvl >= 40 then
			return 40, 44, nil
		elseif playerLvl >= 35 then
			return 35, 39, nil
		elseif playerLvl >= 30 then
			return 30, 34, nil
		elseif playerLvl >= 25 then
			return 25, 29, nil
		elseif playerLvl >= 20 then
			return 20, 24, nil
		elseif playerLvl >= 15 then
			return 15, 19, nil
		else
			return 10, 14, nil
		end
	else
		if types[zone] ~= "Arena" and types[zone] ~= "Complex" and types[zone] ~= "City" and types[zone] ~= "Continent" then
			-- Zones and Instances (scaling):
			local scaled = Tourist:GetScaledZoneLevel(zone)
			if scaled == lows[zone] and scaled == highs[zone] then scaled = nil end -- nothing to scale in a one-level bracket (like Suramar)
			return lows[zone], highs[zone], scaled
		else
			-- Other zones
			return lows[zone], highs[zone], nil
		end
	end
end

-- Returns an r, g and b value representing a color ranging from grey (too low) via
-- green, yellow and orange to red (too high), depending on the player's battle pet level 
-- within the battle pet level range of the given zone.
function Tourist:GetBattlePetLevelColor(zone, petLevel)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local low, high = self:GetBattlePetLevel(zone)
	
	return Tourist:CalculateLevelColor(low, high, petLevel)
end

-- Returns an r, g and b value representing a color ranging from grey (too low) via 
-- green, yellow and orange to red (too high), by calling CalculateLevelColor with 
-- the min and max level of the given zone and the current player level.
-- Note: if zone is a zone or an instance, the zone's scaled level (calculated 
-- by GetScaledZoneLevel) is used instead of it's minimum and maximum level. 
function Tourist:GetLevelColor(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local low, high, scaled = self:GetLevel(zone)

	if types[zone] == "Battleground" then
		if playerLevel < low then
			-- player cannot enter the lowest bracket of the BG -> red
			return 1, 0, 0
		end
	end
	
	if scaled then
		return Tourist:CalculateLevelColor(scaled, scaled, playerLevel)
	else
		return Tourist:CalculateLevelColor(low, high, playerLevel)
	end
end
	
-- Returns an r, g and b value representing a color ranging from grey (too low) via 
-- green, yellow and orange to red (too high) depending on the player level within 
-- the given range. Returns white if no level is applicable, like in cities.	
function Tourist:CalculateLevelColor(low, high, currentLevel)
	local midBracket = (low + high) / 2

	if low <= 0 and high <= 0 then
		-- City or level unknown -> White
		return 1, 1, 1
	elseif currentLevel == low and currentLevel == high then
		-- Exact match, one-level bracket -> Yellow
		return 1, 1, 0
	elseif currentLevel <= low - 3 then
		-- Player is three or more levels short of Low -> Red
		return 1, 0, 0
	elseif currentLevel < low then
		-- Player is two or less levels short of Low -> sliding scale between Red and Orange
		-- Green component goes from 0 to 0.5
		local greenComponent = (currentLevel - low + 3) / 6
		return 1, greenComponent, 0
	elseif currentLevel == low then
		-- Player is at low, at least two-level bracket -> Orange
		return 1, 0.5, 0
	elseif currentLevel < midBracket then
		-- Player is between low and the middle of the bracket -> sliding scale between Orange and Yellow
		-- Green component goes from 0.5 to 1
		local halfBracketSize = (high - low) / 2
		local posInBracketHalf = currentLevel - low
		local greenComponent = 0.5 + (posInBracketHalf / halfBracketSize) * 0.5
		return 1, greenComponent, 0
	elseif currentLevel == midBracket then
		-- Player is at the middle of the bracket -> Yellow
		return 1, 1, 0
	elseif currentLevel < high then
		-- Player is between the middle of the bracket and High -> sliding scale between Yellow and Green
		-- Red component goes from 1 to 0
		local halfBracketSize = (high - low) / 2
		local posInBracketHalf = currentLevel - midBracket
		local redComponent = 1 - (posInBracketHalf / halfBracketSize)
		return redComponent, 1, 0
	elseif currentLevel == high then
		-- Player is at High, at least two-level bracket -> Green
		return 0, 1, 0
	elseif currentLevel < high + 3 then
		-- Player is up to three levels above High -> sliding scale between Green and Gray
		-- Red and Blue components go from 0 to 0.5
		-- Green component goes from 1 to 0.5
		local pos = (currentLevel - high) / 3
		local redAndBlueComponent = pos * 0.5
		local greenComponent = 1 - redAndBlueComponent
		return redAndBlueComponent, greenComponent, redAndBlueComponent
	else
		-- Player is at High + 3 or above -> Gray
		return 0.5, 0.5, 0.5
	end
end

-- Returns an r, g and b value representing a color, depending on the given zone and the current character's faction.
function Tourist:GetFactionColor(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone

	if factions[zone] == "Sanctuary" then
		-- Blue
		return 0.41, 0.8, 0.94
	elseif self:IsPvPZone(zone) then
		-- Orange
		return 1, 0.7, 0
	elseif factions[zone] == (isHorde and "Alliance" or "Horde") then
		-- Red
		return 1, 0, 0
	elseif factions[zone] == (isHorde and "Horde" or "Alliance") then
		-- Green
		return 0, 1, 0
	else
		-- Yellow
		return 1, 1, 0
	end
end

-- Returns an r, g and b value representing a color, depending on the given flight node faction and the current character's faction.
-- faction can be 0, 1, 2, "Neutral", "Horde" or "Alliance".
function Tourist:GetFlightnodeFactionColor(faction)
	faction = GetFlightnodeFaction(faction)
	if faction == (isHorde and "Alliance" or "Horde") then
		-- Red (hostile)
		return 1, 0, 0
	elseif faction == (isHorde and "Horde" or "Alliance") then
		-- Green (friendly)
		return 0, 1, 0
	else
		-- Yellow (neutral or unknown)
		return 1, 1, 0 
	end
end

-- Returns the width and height of a zone map in game yards. The height is always 2/3 of the width.
function Tourist:GetZoneYardSize(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return yardWidths[zone], yardHeights[zone]
end

-- Calculates a distance in game yards between point A and point B. 
-- Points A and B can be in different zones but must be on the same continent.
function Tourist:GetYardDistance(zone1, x1, y1, zone2, x2, y2)
	if tonumber(zone1) == nil then	
		-- Not a uiMapID, translate zone name to map ID
		zone1 = Tourist:GetZoneMapID(zone1)
	end
	if tonumber(zone2) == nil then	
		-- Not a uiMapID, translate zone name to map ID
		zone2 = Tourist:GetZoneMapID(zone2)
	end
	if zone1 and zone2 then
		return HBD:GetZoneDistance(zone1, x1, y1, zone2, x2, y2)
	else
		return nil, nil, nil
	end
end

-- This function is used to calculate the coordinates of a location in zone1, on the map of zone2. 
-- The zones can be continents (including Azeroth). 
-- The return value can be outside the 0 to 1 range.
function Tourist:TransposeZoneCoordinate(x, y, zone1, zone2)
	if tonumber(zone1) == nil then	
		-- Not a uiMapID, translate zone name to map ID
		zone1 = Tourist:GetZoneMapID(zone1)
	end
	if tonumber(zone2) == nil then	
		-- Not a uiMapID, translate zone name to map ID
		zone2 = Tourist:GetZoneMapID(zone2)
	end

	return HBD:TranslateZoneCoordinates(x, y, zone1, zone2, true)  -- True: allow < 0 and > 1
end

-- This function is used to find the actual zone a player is in, including coordinates for that zone, if the current map 
-- is a map that contains the player position, but is not the map of the zone where the player really is.
-- Return values:
-- x, y = player position on the most suitable map
-- zone = the unique localized zone name of the most suitable map 
-- uiMapID = ID of the most suitable map 
function Tourist:GetBestZoneCoordinate()
	local uiMapID = C_Map.GetBestMapForUnit("player")
	
	if uiMapID then
		local zone = Tourist:GetMapNameByIDAlt(uiMapID)
		local pos = C_Map.GetPlayerMapPosition(uiMapID, "player")
		if pos then 
			return pos.x, pos.y, zone, uiMapID
		else
			return nil, nil, zone, uiMapID
		end
	end
	return nil, nil, nil, nil 
end


local function GetBFAInstanceLow(instanceLow, instanceFaction)
	if (isHorde and instanceFaction == "Horde") or (isHorde == false and instanceFaction == "Alliance") then
		return instanceLow
	else
		-- 'Hostile' instances can be accessed at max BfA level (120)
		return 120
	end
end

local function GetSiegeOfBoralusEntrance()
	if isHorde then
		return { BZ["Tiragarde Sound"], 88.3, 51.0 }
	else
		return { BZ["Tiragarde Sound"], 72.5, 23.6 }
	end
end

local function GetTheMotherlodeEntrance()
	if isHorde then
		return { BZ["Zuldazar"], 56.1, 59.9 }
	else
		return { BZ["Zuldazar"], 39.3, 71.4 }
	end
end


-- Returns an r, g and b value representing a color, depending on the given zone and the current character's faction.
function Tourist:GetFactionColor(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone

	if factions[zone] == "Sanctuary" then
		-- Blue
		return 0.41, 0.8, 0.94
	elseif self:IsPvPZone(zone) then
		-- Orange
		return 1, 0.7, 0
	elseif factions[zone] == (isHorde and "Alliance" or "Horde") then
		-- Red
		return 1, 0, 0
	elseif factions[zone] == (isHorde and "Horde" or "Alliance") then
		-- Green
		return 0, 1, 0
	else
		-- Yellow
		return 1, 1, 0
	end
end


local function retNil() 
	return nil 
end
	
local function retOne(object, state)
	if state == object then
		return nil
	else
		return object
	end
end

local function retNormal(t, position)
	return (next(t, position))
end

local function round(num, digits)
	-- banker's rounding
	local mantissa = 10^digits
	local norm = num*mantissa
	norm = norm + 0.5
	local norm_f = math.floor(norm)
	if norm == norm_f and (norm_f % 2) ~= 0 then
		return (norm_f-1)/mantissa
	end
	return norm_f/mantissa
end

local function mysort(a,b)
	if not lows[a] then
		return false
	elseif not lows[b] then
		return true
	else
		local aval, bval = groupSizes[a] or groupMaxSizes[a], groupSizes[b] or groupMaxSizes[b]
		if aval and bval then
			if aval ~= bval then
				return aval < bval
			end
		end
		aval, bval = lows[a], lows[b]
		if aval ~= bval then
			return aval < bval
		end
		aval, bval = highs[a], highs[b]
		if aval ~= bval then
			return aval < bval
		end
		return a < b
	end
end
local t = {}
local function myiter(t)
	local n = t.n
	n = n + 1
	local v = t[n]
	if v then
		t[n] = nil
		t.n = n
		return v
	else
		t.n = nil
	end
end
local function flightnodesort(a, b)
	return a.name < b.name
end

function Tourist:IterateZoneInstances(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local inst = instances[zone]

	if not inst then
		return retNil
	elseif type(inst) == "table" then
		for k in pairs(t) do
			t[k] = nil
		end
		for k in pairs(inst) do
			t[#t+1] = k
		end
		table.sort(t, mysort)
		t.n = 0
		return myiter, t, nil
	else
		return retOne, inst, nil
	end
end

function Tourist:IterateZoneFlightnodes(zone)
	if flightnodeDataGathered == false then
		GatherFlightnodeData()
	end

	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local nodes = flightnodes[zone]
		
	if not nodes then
		-- No nodes
		return retNil
	elseif type(nodes) == "table" then
		-- Table of node IDs. Check if they have been found by GatherFlightnodeData
		-- If so, the value is a node object, otherwise the value is true
		local foundNodes = {}
		for id, _ in pairs(nodes) do
			if FlightnodeLookupTable[id] ~= true then
				-- FlightnodeLookupTable[id] is an object, use it as key for the iter code below
				foundNodes[FlightnodeLookupTable[id]] = true
--			else
				--trace("Skipped: "..tostring(id))
			end
		end

		for k in pairs(t) do
			t[k] = nil
		end
		for k in pairs(foundNodes) do
			t[#t+1] = k
		end
		table.sort(t, flightnodesort)
		t.n = 0
		return myiter, t, nil
	else
		-- Single node ID. Check if it has been found by GatherFlightnodeData
		if FlightnodeLookupTable[nodes] ~= true then
			return retOne, FlightnodeLookupTable[nodes], nil
		else
			-- No data
			return retNil
		end		
	end
end


function Tourist:IterateZoneComplexes(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local compl = zoneComplexes[zone]

	if not compl then
		return retNil
	elseif type(compl) == "table" then
		for k in pairs(t) do
			t[k] = nil
		end
		for k in pairs(compl) do
			t[#t+1] = k
		end
		table.sort(t, mysort)
		t.n = 0
		return myiter, t, nil
	else
		return retOne, compl, nil
	end
end

function Tourist:GetInstanceZone(instance)
	instance = Tourist:GetMapNameByIDAlt(instance) or instance
	for k, v in pairs(instances) do
		if v then
			if type(v) == "string" then
				if v == instance then
					return k
				end
			else -- table
				for l in pairs(v) do
					if l == instance then
						return k
					end
				end
			end
		end
	end
end

function Tourist:GetComplexZone(complex)
	complex = Tourist:GetMapNameByIDAlt(complex) or complex
	for k, v in pairs(zoneComplexes) do
		if v then
			if type(v) == "string" then
				if v == complex then
					return k
				end
			else -- table
				for l in pairs(v) do
					if l == complex then
						return k
					end
				end
			end
		end
	end
end

function Tourist:DoesZoneHaveInstances(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return not not instances[zone]
end

function Tourist:DoesZoneHaveFlightnodes(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return not not flightnodes[zone]
end

function Tourist:DoesZoneHaveComplexes(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return not not zoneComplexes[zone]
end


local zonesInstances
local function initZonesInstances()
	if not zonesInstances then
		zonesInstances = {}
		for zone, v in pairs(lows) do
			if types[zone] ~= "Transport" then
				zonesInstances[zone] = true
			end
		end
	end
	initZonesInstances = nil  -- Set function to nil so initialisation is done only once (and just in time)
end

function Tourist:IterateZonesAndInstances()
	if initZonesInstances then
		initZonesInstances()
	end
	return retNormal, zonesInstances, nil
end

local function zoneIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and (types[k] == "Instance" or types[k] == "Battleground" or types[k] == "Arena" or types[k] == "Complex") do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateZones()
	if initZonesInstances then
		initZonesInstances()
	end
	return zoneIter, nil, nil
end

local function instanceIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and (types[k] ~= "Instance" and types[k] ~= "Battleground" and types[k] ~= "Arena") do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateInstances()
	if initZonesInstances then
		initZonesInstances()
	end
	return instanceIter, nil, nil
end

local function bgIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and types[k] ~= "Battleground" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateBattlegrounds()
	if initZonesInstances then
		initZonesInstances()
	end
	return bgIter, nil, nil
end

local function arIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and types[k] ~= "Arena" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateArenas()
	if initZonesInstances then
		initZonesInstances()
	end
	return arIter, nil, nil
end

local function compIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and types[k] ~= "Complex" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateComplexes()
	if initZonesInstances then
		initZonesInstances()
	end
	return compIter, nil, nil
end

local function pvpIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and types[k] ~= "PvP Zone" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IteratePvPZones()
	if initZonesInstances then
		initZonesInstances()
	end
	return pvpIter, nil, nil
end

local function allianceIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and factions[k] ~= "Alliance" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateAlliance()
	if initZonesInstances then
		initZonesInstances()
	end
	return allianceIter, nil, nil
end

local function hordeIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and factions[k] ~= "Horde" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateHorde()
	if initZonesInstances then
		initZonesInstances()
	end
	return hordeIter, nil, nil
end

if isHorde then
	Tourist.IterateFriendly = Tourist.IterateHorde
	Tourist.IterateHostile = Tourist.IterateAlliance
else
	Tourist.IterateFriendly = Tourist.IterateAlliance
	Tourist.IterateHostile = Tourist.IterateHorde
end

local function sanctIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and factions[k] ~= "Sanctuary" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateSanctuaries()
	if initZonesInstances then
		initZonesInstances()
	end
	return sanctIter, nil, nil
end

local function contestedIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and factions[k] do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateContested()
	if initZonesInstances then
		initZonesInstances()
	end
	return contestedIter, nil, nil
end

local function kalimdorIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Kalimdor do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateKalimdor()
	if initZonesInstances then
		initZonesInstances()
	end
	return kalimdorIter, nil, nil
end

local function easternKingdomsIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Eastern_Kingdoms do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateEasternKingdoms()
	if initZonesInstances then
		initZonesInstances()
	end
	return easternKingdomsIter, nil, nil
end

local function outlandIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Outland do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateOutland()
	if initZonesInstances then
		initZonesInstances()
	end
	return outlandIter, nil, nil
end

local function northrendIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Northrend do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateNorthrend()
	if initZonesInstances then
		initZonesInstances()
	end
	return northrendIter, nil, nil
end

local function theMaelstromIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= The_Maelstrom do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateTheMaelstrom()
	if initZonesInstances then
		initZonesInstances()
	end
	return theMaelstromIter, nil, nil
end

local function pandariaIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Pandaria do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IteratePandaria()
	if initZonesInstances then
		initZonesInstances()
	end
	return pandariaIter, nil, nil
end


local function draenorIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Draenor do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateDraenor()
	if initZonesInstances then
		initZonesInstances()
	end
	return draenorIter, nil, nil
end


local function brokenislesIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Broken_Isles do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateBrokenIsles()
	if initZonesInstances then
		initZonesInstances()
	end
	return brokenislesIter, nil, nil
end


local function argusIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Argus do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateArgus()
	if initZonesInstances then
		initZonesInstances()
	end
	return argusIter, nil, nil
end

local function zandalarIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Zandalar do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateZandalar()
	if initZonesInstances then
		initZonesInstances()
	end
	return zandalarIter, nil, nil
end

local function kultirasIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Kul_Tiras do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateKulTiras()
	if initZonesInstances then
		initZonesInstances()
	end
	return kultirasIter, nil, nil
end


function Tourist:IterateRecommendedZones()
	return retNormal, recZones, nil
end

function Tourist:IterateRecommendedInstances()
	return retNormal, recInstances, nil
end

function Tourist:HasRecommendedInstances()
	return next(recInstances) ~= nil
end

function Tourist:IsInstance(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local t = types[zone]
	return t == "Instance" or t == "Battleground" or t == "Arena"
end

function Tourist:IsZone(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local t = types[zone]
	return t and t ~= "Instance" and t ~= "Battleground" and t ~= "Transport" and t ~= "Arena" and t ~= "Complex"
end

function Tourist:IsContinent(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local t = types[zone]
	return t == "Continent"
end

function Tourist:GetComplex(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return complexOfInstance[zone]
end

function Tourist:GetType(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return types[zone] or "Zone"
end

function Tourist:IsZoneOrInstance(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local t = types[zone]
	return t and t ~= "Transport"
end

function Tourist:IsTransport(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local t = types[zone]
	return t == "Transport"
end

function Tourist:IsComplex(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local t = types[zone]
	return t == "Complex"
end

function Tourist:IsBattleground(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local t = types[zone]
	return t == "Battleground"
end

function Tourist:IsArena(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local t = types[zone]
	return t == "Arena"
end

function Tourist:IsPvPZone(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local t = types[zone]
	return t == "PvP Zone"
end

function Tourist:IsCity(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local t = types[zone]
	return t == "City"
end

function Tourist:IsAlliance(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return factions[zone] == "Alliance"
end

function Tourist:IsHorde(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return factions[zone] == "Horde"
end

if isHorde then
	Tourist.IsFriendly = Tourist.IsHorde
	Tourist.IsHostile = Tourist.IsAlliance
else
	Tourist.IsFriendly = Tourist.IsAlliance
	Tourist.IsHostile = Tourist.IsHorde
end

function Tourist:IsSanctuary(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return factions[zone] == "Sanctuary"
end

function Tourist:IsContested(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return not factions[zone]
end

function Tourist:GetContinent(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return BZ[continents[zone]] or UNKNOWN
end

function Tourist:IsInKalimdor(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return continents[zone] == Kalimdor
end

function Tourist:IsInEasternKingdoms(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return continents[zone] == Eastern_Kingdoms
end

function Tourist:IsInOutland(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return continents[zone] == Outland
end

function Tourist:IsInNorthrend(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return continents[zone] == Northrend
end

function Tourist:IsInTheMaelstrom(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return continents[zone] == The_Maelstrom
end

function Tourist:IsInPandaria(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return continents[zone] == Pandaria
end

function Tourist:IsInDraenor(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return continents[zone] == Draenor
end

function Tourist:IsInBrokenIsles(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return continents[zone] == Broken_Isles
end

function Tourist:IsInArgus(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return continents[zone] == Argus
end

function Tourist:IsInZandalar(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return continents[zone] == Zandalar
end

function Tourist:IsInKulTiras(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return continents[zone] == Kul_Tiras
end

function Tourist:GetInstanceGroupSize(instance)
	instance = Tourist:GetMapNameByIDAlt(instance) or instance
	return groupSizes[instance] or groupMaxSizes[instance] or 0
end

function Tourist:GetInstanceGroupMinSize(instance)
	instance = Tourist:GetMapNameByIDAlt(instance) or instance
	return groupMinSizes[instance] or groupSizes[instance] or 0
end

function Tourist:GetInstanceGroupMaxSize(instance)
	instance = Tourist:GetMapNameByIDAlt(instance) or instance
	return groupMaxSizes[instance] or groupSizes[instance] or 0
end

function Tourist:GetInstanceGroupSizeString(instance, includeAltSize)
	instance = Tourist:GetMapNameByIDAlt(instance) or instance
	local retValue
	if groupSizes[instance] then
		-- Fixed size
		retValue = tostring(groupSizes[instance])
	elseif groupMinSizes[instance] and groupMaxSizes[instance] then
		-- Variable size
		if groupMinSizes[instance] == groupMaxSizes[instance] then
			-- ...but equal
			retValue = tostring(groupMinSizes[instance])
		else
			retValue = tostring(groupMinSizes[instance]).."-"..tostring(groupMaxSizes[instance])
		end
	else
		-- No size known
		return ""
	end
	if includeAltSize and groupAltSizes[instance] then
		-- Add second size
		retValue = retValue.." or "..tostring(groupAltSizes[instance])
	end
	return retValue
end

function Tourist:GetInstanceAltGroupSize(instance)
	instance = Tourist:GetMapNameByIDAlt(instance) or instance
	return groupAltSizes[instance] or 0
end

function Tourist:GetTexture(zone)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	return textures[zone]
end

function Tourist:GetZoneMapID(zone)
	return zoneMapIDs[zone]
end

function Tourist:GetEntrancePortalLocation(instance)
	instance = Tourist:GetMapNameByIDAlt(instance) or instance
	local x, y = entrancePortals_x[instance], entrancePortals_y[instance]
	if x then x = x/100 end
	if y then y = y/100 end
	return entrancePortals_zone[instance], x, y
end

local inf = math.huge
local stack = setmetatable({}, {__mode='k'})
local function iterator(S)
	local position = S['#'] - 1
	S['#'] = position
	local x = S[position]
	if not x then
		for k in pairs(S) do
			S[k] = nil
		end
		stack[S] = true
		return nil
	end
	return x
end

setmetatable(cost, {
	__index = function(self, vertex)
		local price = 1

		if lows[vertex] > playerLevel then
			price = price * (1 + math.ceil((lows[vertex] - playerLevel) / 6))
		end

		if factions[vertex] == (isHorde and "Horde" or "Alliance") then
			price = price / 2
		elseif factions[vertex] == (isHorde and "Alliance" or "Horde") then
			if types[vertex] == "City" then
				price = price * 10
			else
				price = price * 3
			end
		end

		if types[x] == "Transport" then
			price = price * 2
		end

		self[vertex] = price
		return price
	end
})

-- This function tries to calculate the most optimal path between alpha and bravo 
-- by foot or ground mount, that is, without using a flying mount or a taxi service. 
-- The return value is an iteration that gives a travel advice in the form of a list 
-- of zones and transports to follow in order to get from alpha to bravo. 
-- The function tries to avoid hostile zones by calculating a "price" for each possible 
-- route. The price calculation takes zone level, faction and type into account.
-- See metatable above for the 'pricing' mechanism.
function Tourist:IteratePath(alpha, bravo)
	alpha = Tourist:GetMapNameByIDAlt(alpha) or alpha
	bravo = Tourist:GetMapNameByIDAlt(bravo) or bravo

	if paths[alpha] == nil or paths[bravo] == nil then
		return retNil
	end

	local d = next(stack) or {}
	stack[d] = nil
	local Q = next(stack) or {}
	stack[Q] = nil
	local S = next(stack) or {}
	stack[S] = nil
	local pi = next(stack) or {}
	stack[pi] = nil

	for vertex, v in pairs(paths) do
		d[vertex] = inf
		Q[vertex] = v
	end
	d[alpha] = 0

	while next(Q) do
		local u
		local min = inf
		for z in pairs(Q) do
			local value = d[z]
			if value < min then
				min = value
				u = z
			end
		end
		if min == inf then
			return retNil
		end
		Q[u] = nil
		if u == bravo then
			break
		end

		local adj = paths[u]
		if type(adj) == "table" then
			local d_u = d[u]
			for v in pairs(adj) do
				local c = d_u + cost[v]
				if d[v] > c then
					d[v] = c
					pi[v] = u
				end
			end
		elseif adj ~= false then
			local c = d[u] + cost[adj]
			if d[adj] > c then
				d[adj] = c
				pi[adj] = u
			end
		end
	end

	local i = 1
	local last = bravo
	while last do
		S[i] = last
		i = i + 1
		last = pi[last]
	end

	for k in pairs(pi) do
		pi[k] = nil
	end
	for k in pairs(Q) do
		Q[k] = nil
	end
	for k in pairs(d) do
		d[k] = nil
	end
	stack[pi] = true
	stack[Q] = true
	stack[d] = true

	S['#'] = i

	return iterator, S
end


local function retIsZone(t, key)
	while true do
		key = next(t, key)
		if not key then
			return nil
		end
		if Tourist:IsZone(key) then
			return key
		end
	end
end

-- This returns an iteration of zone connections (paths).
-- The second parameter determines whether other connections like transports and portals should be included
function Tourist:IterateBorderZones(zone, zonesOnly)
	zone = Tourist:GetMapNameByIDAlt(zone) or zone
	local path = paths[zone]
	
	if not path then
		return retNil
	elseif type(path) == "table" then
		return zonesOnly and retIsZone or retNormal, path
	else
		if zonesOnly and not Tourist:IsZone(path) then
			return retNil
		end
		return retOne, path
	end
end


--------------------------------------------------------------------------------------------------------
--                                            Main code                                               --
--------------------------------------------------------------------------------------------------------

do
	Tourist.frame = oldLib and oldLib.frame or CreateFrame("Frame", MAJOR_VERSION .. "Frame", UIParent)
	Tourist.frame:UnregisterAllEvents()
	Tourist.frame:RegisterEvent("PLAYER_LEVEL_UP")
	Tourist.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	Tourist.frame:SetScript("OnEvent", function(frame, event, ...)
		PLAYER_LEVEL_UP(Tourist, ...)
	end)


	trace("Tourist: Initializing localized zone name lookups...")
	CreateLocalizedZoneNameLookups()
	AddDuplicatesToLocalizedLookup()

	
	-- TRANSPORT DEFINITIONS ----------------------------------------------------------------

	local transports = {}

	-- Boats
	transports["BOOTYBAY_RATCHET_BOAT"] = string.format(X_Y_BOAT, BZ["The Cape of Stranglethorn"], BZ["Northern Barrens"])
	transports["MENETHIL_HOWLINGFJORD_BOAT"] = string.format(X_Y_BOAT, BZ["Wetlands"], BZ["Howling Fjord"])
	transports["MENETHIL_THERAMORE_BOAT"] = string.format(X_Y_BOAT, BZ["Wetlands"], BZ["Dustwallow Marsh"])
	transports["MOAKI_KAMAGUA_BOAT"] = string.format(X_Y_BOAT, BZ["Dragonblight"], BZ["Howling Fjord"])
	transports["MOAKI_UNUPE_BOAT"] = string.format(X_Y_BOAT, BZ["Dragonblight"], BZ["Borean Tundra"])
	transports["STORMWIND_BOREANTUNDRA_BOAT"] = string.format(X_Y_BOAT, BZ["Stormwind City"], BZ["Borean Tundra"])
--	transports["TELDRASSIL_AZUREMYST_BOAT"] = string.format(X_Y_BOAT, BZ["Teldrassil"], BZ["Azuremyst Isle"])  -- 8.0: portal
--	transports["TELDRASSIL_STORMWIND_BOAT"] = string.format(X_Y_BOAT, BZ["Teldrassil"], BZ["Stormwind City"])  -- 8.0: portal
	transports["STORMWIND_TIRAGARDESOUND_BOAT"] = string.format(X_Y_BOAT, BZ["Stormwind City"], BZ["Tiragarde Sound"])
	transports["ECHOISLES_ZULDAZAR_BOAT"] = string.format(X_Y_BOAT, BZ["Echo Isles"], BZ["Zuldazar"])
	
	-- Zeppelins
	transports["ORGRIMMAR_BOREANTUNDRA_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Orgrimmar"], BZ["Borean Tundra"])
	transports["ORGRIMMAR_GROMGOL_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Orgrimmar"], BZ["Northern Stranglethorn"])
	transports["ORGRIMMAR_THUNDERBLUFF_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Orgrimmar"], BZ["Thunder Bluff"])
--	transports["ORGRIMMAR_UNDERCITY_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Orgrimmar"], BZ["Undercity"])  -- 8.0: portal
--	transports["UNDERCITY_GROMGOL_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Undercity"], BZ["Northern Stranglethorn"])  -- 8.0: portal
--	transports["UNDERCITY_HOWLINGFJORD_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Undercity"], BZ["Howling Fjord"])  -- 8.0: portal
	
	-- Teleports
	transports["SILVERMOON_UNDERCITY_TELEPORT"] = string.format(X_Y_TELEPORT, BZ["Silvermoon City"], BZ["Undercity"])
	transports["DALARAN_CRYSTALSONG_TELEPORT"] = string.format(X_Y_TELEPORT, BZ["Dalaran"], BZ["Crystalsong Forest"])
	
	-- Portals
	transports["AZSUNA_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Azsuna"], BZ["Orgrimmar"])
	transports["AZSUNA_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Azsuna"], BZ["Stormwind City"])
	transports["DALARAN_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"], BZ["Orgrimmar"])
	transports["DALARAN_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"], BZ["Stormwind City"])
	transports["DALARANBROKENISLES_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Orgrimmar"])
	transports["DALARANBROKENISLES_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Stormwind City"])
	transports["DARKMOON_ELWYNNFOREST_PORTAL"] = string.format(X_Y_PORTAL, BZ["Darkmoon Island"], BZ["Elwynn Forest"])
	transports["DARKMOON_MULGORE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Darkmoon Island"], BZ["Mulgore"])
	transports["DARNASSUS_EXODAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Darnassus"], BZ["The Exodar"])
	transports["DARNASSUS_HELLFIRE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Darnassus"], BZ["Hellfire Peninsula"])
	transports["DEEPHOLM_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Deepholm"], BZ["Orgrimmar"])
	transports["DEEPHOLM_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Deepholm"], BZ["Stormwind City"])
	transports["ELWYNNFOREST_DARKMOON_PORTAL"] = string.format(X_Y_PORTAL, BZ["Elwynn Forest"], BZ["Darkmoon Island"])
	transports["EXODAR_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["The Exodar"], BZ["Stormwind City"])
	transports["FROSTWALL_WARSPEAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Frostwall"], BZ["Warspear"])
	transports["HELLFIRE_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Hellfire Peninsula"], BZ["Orgrimmar"])
	transports["HELLFIRE_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Hellfire Peninsula"], BZ["Stormwind City"])
	transports["ISLEOFTHUNDER_TOWNLONGSTEPPES_PORTAL"] = string.format(X_Y_PORTAL, BZ["Isle of Thunder"], BZ["Townlong Steppes"])
	transports["JADEFOREST_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["The Jade Forest"], BZ["Orgrimmar"])
	transports["JADEFOREST_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["The Jade Forest"], BZ["Stormwind City"])
	transports["LUNARFALL_STORMSHIELD_PORTAL"] = string.format(X_Y_PORTAL, BZ["Lunarfall"], BZ["Stormshield"])
	transports["MOUNTHYJAL_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Mount Hyjal"], BZ["Orgrimmar"])
	transports["MOUNTHYJAL_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Mount Hyjal"], BZ["Stormwind City"])
	transports["MULGORE_DARKMOON_PORTAL"] = string.format(X_Y_PORTAL, BZ["Mulgore"], BZ["Darkmoon Island"])
	transports["ORGRIMMAR_AZSUNA_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Azsuna"])
	transports["ORGRIMMAR_DALARAN_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Dalaran"])
	transports["ORGRIMMAR_DEEPHOLM_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Deepholm"])
	transports["ORGRIMMAR_JADEFOREST_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["The Jade Forest"])
	transports["ORGRIMMAR_MOUNTHYJAL_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Mount Hyjal"])
	transports["ORGRIMMAR_SHATTRATH_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Shattrath City"])
	transports["ORGRIMMAR_SILVERMOON_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Silvermoon City"])
	transports["ORGRIMMAR_TOLBARAD_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Tol Barad Peninsula"])
	transports["ORGRIMMAR_TWILIGHTHIGHLANDS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Twilight Highlands"])
	transports["ORGRIMMAR_ULDUM_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Uldum"])
	transports["ORGRIMMAR_UNDERCITY_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Undercity"]) -- 8.0: former zeppelin
	transports["ORGRIMMAR_VASHJIR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Vashj'ir"])
	transports["ORGRIMMAR_WARSPEAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Warspear"])
	transports["ORGRIMMAR_ZULDAZAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Dazar'alor"])
	transports["SEVENSTARS_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Seven Stars"], BZ["Stormwind City"])
	transports["SHATTRATH_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shattrath City"], BZ["Orgrimmar"])
	transports["SHATTRATH_QUELDANAS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shattrath City"], BZ["Isle of Quel'Danas"])
	transports["SHATTRATH_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shattrath City"], BZ["Stormwind City"])
	transports["SILITHUS_TIRAGARDESOUND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Silithus"], BZ["Boralus"])
	transports["SILITHUS_ZULDAZAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Silithus"], BZ["Dazar'alor"])
	transports["SILVERMOON_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Silvermoon City"], BZ["Orgrimmar"])	
	transports["STORMSHIELD_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormshield"], BZ["Stormwind City"])
	transports["STORMSHIELD_TANAANJUNGLE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormshield"], BZ["Tanaan Jungle"])
	transports["STORMWIND_AZSUNA_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Azsuna"])
	transports["STORMWIND_DALARAN_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Dalaran"])
	transports["STORMWIND_DEEPHOLM_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Deepholm"])
	transports["STORMWIND_EXODAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["The Exodar"])
	transports["STORMWIND_JADEFOREST_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["The Jade Forest"])
	transports["STORMWIND_MOUNTHYJAL_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Mount Hyjal"])
	transports["STORMWIND_SHATTRATH_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Shattrath City"])
	transports["STORMWIND_STORMSHIELD_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Stormshield"])
	transports["STORMWIND_TELDRASSIL_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Teldrassil"])  -- 8.0: former boat
	transports["STORMWIND_TIRAGARDESOUND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Boralus"])
	transports["STORMWIND_TOLBARAD_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Tol Barad Peninsula"])
	transports["STORMWIND_TWILIGHTHIGHLANDS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Twilight Highlands"])
	transports["STORMWIND_ULDUM_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Uldum"])
	transports["STORMWIND_VASHJIR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Vashj'ir"])
	transports["TANAANJUNGLE_STORMSHIELD_PORTAL"] = string.format(X_Y_PORTAL, BZ["Tanaan Jungle"], BZ["Stormshield"])
	transports["TANAANJUNGLE_WARSPEAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Tanaan Jungle"], BZ["Warspear"])
	transports["TELDRASSIL_AZUREMYST_PORTAL"] = string.format(X_Y_PORTAL, BZ["Teldrassil"], BZ["Azuremyst Isle"])  -- 8.0: former boat
	transports["TIRAGARDESOUND_EXODAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Boralus"], BZ["The Exodar"])
	transports["TIRAGARDESOUND_IRONFORGE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Boralus"], BZ["Ironforge"])
	transports["TIRAGARDESOUND_SILITHUS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Boralus"], BZ["Silithus"])
	transports["TIRAGARDESOUND_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Boralus"], BZ["Stormwind City"])
	transports["TOLBARAD_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Tol Barad Peninsula"], BZ["Orgrimmar"])
	transports["TOLBARAD_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Tol Barad Peninsula"], BZ["Stormwind City"])
	transports["TOWNLONGSTEPPES_ISLEOFTHUNDER_PORTAL"] = string.format(X_Y_PORTAL, BZ["Townlong Steppes"], BZ["Isle of Thunder"])
	transports["TWILIGHTHIGHLANDS_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Twilight Highlands"], BZ["Orgrimmar"])
	transports["TWILIGHTHIGHLANDS_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Twilight Highlands"], BZ["Stormwind City"])
	transports["TWOMOONS_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Two Moons"], BZ["Orgrimmar"])
	transports["UNDERCITY_GROMGOL_PORTAL"] = string.format(X_Y_PORTAL, BZ["Undercity"], BZ["Northern Stranglethorn"]) -- 8.0: former zeppelin
	transports["UNDERCITY_HELLFIRE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Undercity"], BZ["Hellfire Peninsula"])
	transports["UNDERCITY_HOWLINGFJORD_PORTAL"] = string.format(X_Y_PORTAL, BZ["Undercity"], BZ["Howling Fjord"]) -- 8.0: former zeppelin
	transports["WARSPEAR_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Warspear"], BZ["Orgrimmar"])
	transports["WARSPEAR_TANAANJUNGLE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Warspear"], BZ["Tanaan Jungle"])
	transports["ZULDAZAR_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dazar'alor"], BZ["Orgrimmar"])
	transports["ZULDAZAR_SILVERMOON_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dazar'alor"], BZ["Silvermoon City"])
	transports["ZULDAZAR_THUNDERBLUFF_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dazar'alor"], BZ["Thunder Bluff"])
	transports["ZULDAZAR_SILITHUS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dazar'alor"], BZ["Silithus"])

	
	local zones = {}

	-- CONTINENTS ---------------------------------------------------------------

	zones[BZ["Azeroth"]] = {
		type = "Continent",
--		yards = 44531.82907938571,
		yards = 33400.121,
		x_offset = 0,
		y_offset = 0,
		continent = Azeroth,
	}
	
	zones[BZ["Eastern Kingdoms"]] = {
		type = "Continent",
		continent = Eastern_Kingdoms,
	}

	zones[BZ["Kalimdor"]] = {
		type = "Continent",
		continent = Kalimdor,
	}

	zones[BZ["Outland"]] = {
		type = "Continent",
		continent = Outland,
	}

	zones[BZ["Northrend"]] = {
		type = "Continent",
		continent = Northrend,
	}

	zones[BZ["The Maelstrom"]] = {
		type = "Continent",
		continent = The_Maelstrom,
	}

	zones[BZ["Pandaria"]] = {
		type = "Continent",
		continent = Pandaria,
	}

	zones[BZ["Draenor"]] = {
		type = "Continent",
		continent = Draenor,
	}

	zones[BZ["Broken Isles"]] = {
		type = "Continent",
		continent = Broken_Isles,
	}

	zones[BZ["Argus"]] = {
		type = "Continent",
		continent = Argus,
	}

	zones[BZ["Zandalar"]] = {
		type = "Continent",
		continent = Zandalar,
		faction = "Horde"
	}	

	zones[BZ["Kul Tiras"]] = {
		type = "Continent",
		continent = Kul_Tiras,
		faction = "Alliance"
	}	
	
	-- TRANSPORTS ---------------------------------------------------------------

	zones[transports["STORMWIND_BOREANTUNDRA_BOAT"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
			[BZ["Borean Tundra"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_BOREANTUNDRA_ZEPPELIN"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
			[BZ["Borean Tundra"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["UNDERCITY_HOWLINGFJORD_PORTAL"]] = {
		paths = {
			[BZ["Tirisfal Glades"]] = true,
			[BZ["Howling Fjord"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_SILVERMOON_PORTAL"]] = {
		paths = {
			[BZ["Silvermoon City"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_SHATTRATH_PORTAL"]] = {
		paths = {
			[BZ["Silvermoon City"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_DALARAN_PORTAL"]] = {
		paths = {
			[BZ["Dalaran"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["ORGRIMMAR_AZSUNA_PORTAL"]] = {
		paths = {
			[BZ["Azsuna"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["AZSUNA_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["ORGRIMMAR_ZULDAZAR_PORTAL"]] = {
		paths = {
			[BZ["Dazar'alor"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["HELLFIRE_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["UNDERCITY_HELLFIRE_PORTAL"]] = {
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["STORMWIND_EXODAR_PORTAL"]] = {
		paths = {
			[BZ["The Exodar"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	
	
	zones[transports["STORMWIND_SHATTRATH_PORTAL"]] = {
		paths = {
			[BZ["Shattrath City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}		
	
	zones[transports["STORMWIND_DALARAN_PORTAL"]] = {
		paths = {
			[BZ["Dalaran"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}		
	
	zones[transports["STORMWIND_AZSUNA_PORTAL"]] = {
		paths = {
			[BZ["Azsuna"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}		
	
	zones[transports["AZSUNA_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}		
	
	zones[transports["HELLFIRE_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DALARAN_STORMWIND_PORTAL"]] = {
		paths = BZ["Stormwind City"],
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DALARAN_ORGRIMMAR_PORTAL"]] = {
		paths = BZ["Orgrimmar"],
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["DARNASSUS_HELLFIRE_PORTAL"]] = {
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DARNASSUS_EXODAR_PORTAL"]] = {
		paths = {
			[BZ["The Exodar"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["EXODAR_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["MULGORE_DARKMOON_PORTAL"]] = {
		paths = BZ["Darkmoon Island"],
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["DARKMOON_MULGORE_PORTAL"]] = {
		paths = BZ["Mulgore"],
		faction = "Horde",
		type = "Transport",
	}


	zones[transports["ELWYNNFOREST_DARKMOON_PORTAL"]] = {
		paths = BZ["Darkmoon Island"],
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DARKMOON_ELWYNNFOREST_PORTAL"]] = {
		paths = BZ["Elwynn Forest"],
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_TELDRASSIL_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
			[BZ["Teldrassil"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["TELDRASSIL_AZUREMYST_PORTAL"]] = {
		paths = {
			[BZ["Teldrassil"]] = true,
			[BZ["Azuremyst Isle"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["BOOTYBAY_RATCHET_BOAT"]] = {
		paths = {
			[BZ["The Cape of Stranglethorn"]] = true,
			[BZ["Northern Barrens"]] = true,
		},
		type = "Transport",
	}

	zones[transports["MENETHIL_HOWLINGFJORD_BOAT"]] = {
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Howling Fjord"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["MENETHIL_THERAMORE_BOAT"]] = {
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Dustwallow Marsh"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_GROMGOL_ZEPPELIN"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
			[BZ["Northern Stranglethorn"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_UNDERCITY_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
			[BZ["Tirisfal Glades"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_THUNDERBLUFF_ZEPPELIN"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
			[BZ["Thunder Bluff"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["SHATTRATH_QUELDANAS_PORTAL"]] = {
		paths = BZ["Isle of Quel'Danas"],
		type = "Transport",
	}

	zones[transports["SHATTRATH_ORGRIMMAR_PORTAL"]] = {
		paths = BZ["Orgrimmar"],
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["SHATTRATH_STORMWIND_PORTAL"]] = {
		paths = BZ["Stormwind City"],
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["MOAKI_UNUPE_BOAT"]] = {
		paths = {
			[BZ["Dragonblight"]] = true,
			[BZ["Borean Tundra"]] = true,
		},
		type = "Transport",
	}

	zones[transports["MOAKI_KAMAGUA_BOAT"]] = {
		paths = {
			[BZ["Dragonblight"]] = true,
			[BZ["Howling Fjord"]] = true,
		},
		type = "Transport",
	}

	zones[BZ["The Dark Portal"]] = {
		paths = {
			[BZ["Blasted Lands"]] = true,
			[BZ["Hellfire Peninsula"]] = true,
		},
		type = "Transport",
	}

	zones[BZ["Deeprun Tram"]] = {
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Stormwind City"]] = true,
			[BZ["Ironforge"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["UNDERCITY_GROMGOL_PORTAL"]] = {
		paths = {
			[BZ["Northern Stranglethorn"]] = true,
			[BZ["Tirisfal Glades"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["SILVERMOON_UNDERCITY_TELEPORT"]] = {
		paths = {
			[BZ["Silvermoon City"]] = true,
			[BZ["Undercity"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["DALARAN_CRYSTALSONG_TELEPORT"]] = {
		paths = {
			[BZ["Dalaran"]] = true,
			[BZ["Crystalsong Forest"]] = true,
		},
		type = "Transport",
	}

	zones[transports["STORMWIND_TWILIGHTHIGHLANDS_PORTAL"]] = {
		paths = {
			[BZ["Twilight Highlands"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["TWILIGHTHIGHLANDS_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_MOUNTHYJAL_PORTAL"]] = {
		paths = {
			[BZ["Mount Hyjal"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["MOUNTHYJAL_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["STORMWIND_DEEPHOLM_PORTAL"]] = {
		paths = {
			[BZ["Deepholm"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DEEPHOLM_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["TOLBARAD_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_ULDUM_PORTAL"]] = {
		paths = {
			[BZ["Uldum"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_VASHJIR_PORTAL"]] = {
		paths = {
			[BZ["Vashj'ir"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_TOLBARAD_PORTAL"]] = {
		paths = {
			[BZ["Tol Barad Peninsula"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_TWILIGHTHIGHLANDS_PORTAL"]] = {
		paths = {
			[BZ["Twilight Highlands"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["TWILIGHTHIGHLANDS_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_MOUNTHYJAL_PORTAL"]] = {
		paths = {
			[BZ["Mount Hyjal"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["MOUNTHYJAL_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}	
	
	zones[transports["ORGRIMMAR_DEEPHOLM_PORTAL"]] = {
		paths = {
			[BZ["Deepholm"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["DEEPHOLM_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["TOLBARAD_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_ULDUM_PORTAL"]] = {
		paths = {
			[BZ["Uldum"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_VASHJIR_PORTAL"]] = {
		paths = {
			[BZ["Vashj'ir"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_TOLBARAD_PORTAL"]] = {
		paths = {
			[BZ["Tol Barad Peninsula"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_JADEFOREST_PORTAL"]] = {
		paths = {
			[BZ["The Jade Forest"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["JADEFOREST_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["STORMWIND_JADEFOREST_PORTAL"]] = {
		paths = {
			[BZ["The Jade Forest"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["JADEFOREST_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	

	zones[transports["TOWNLONGSTEPPES_ISLEOFTHUNDER_PORTAL"]] = {
		paths = {
			[BZ["Isle of Thunder"]] = true,
		},
		type = "Transport",
	}	

	zones[transports["ISLEOFTHUNDER_TOWNLONGSTEPPES_PORTAL"]] = {
		paths = {
			[BZ["Townlong Steppes"]] = true,
		},
		type = "Transport",
	}	

	zones[transports["ORGRIMMAR_WARSPEAR_PORTAL"]] = {
		paths = {
			[BZ["Warspear"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["WARSPEAR_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["WARSPEAR_TANAANJUNGLE_PORTAL"]] = {
		paths = {
			[BZ["Tanaan Jungle"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["TANAANJUNGLE_WARSPEAR_PORTAL"]] = {
		paths = {
			[BZ["Warspear"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["STORMWIND_STORMSHIELD_PORTAL"]] = {
		paths = {
			[BZ["Stormshield"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	
	
	zones[transports["STORMSHIELD_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	

	zones[transports["STORMSHIELD_TANAANJUNGLE_PORTAL"]] = {
		paths = {
			[BZ["Tanaan Jungle"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	
	
	zones[transports["TANAANJUNGLE_STORMSHIELD_PORTAL"]] = {
		paths = {
			[BZ["Stormshield"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	

	zones[transports["LUNARFALL_STORMSHIELD_PORTAL"]] = {
		paths = {
			[BZ["Stormshield"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	

	zones[transports["FROSTWALL_WARSPEAR_PORTAL"]] = {
		paths = {
			[BZ["Warspear"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}	
	
	zones[transports["TWOMOONS_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}	
	
	zones[transports["SEVENSTARS_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["DALARANBROKENISLES_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DALARANBROKENISLES_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ECHOISLES_ZULDAZAR_BOAT"]] = {
		paths = {
			[BZ["Echo Isles"]] = true,
			[BZ["Zuldazar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["STORMWIND_TIRAGARDESOUND_BOAT"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
			[BZ["Tiragarde Sound"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_TIRAGARDESOUND_PORTAL"]] = {
		paths = {
			[BZ["Boralus"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["TIRAGARDESOUND_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["TIRAGARDESOUND_EXODAR_PORTAL"]] = {
		paths = {
			[BZ["The Exodar"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["TIRAGARDESOUND_IRONFORGE_PORTAL"]] = {
		paths = {
			[BZ["Ironforge"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	
	
	zones[transports["TIRAGARDESOUND_SILITHUS_PORTAL"]] = {
		paths = {
			[BZ["Silithus"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	

	zones[transports["SILITHUS_TIRAGARDESOUND_PORTAL"]] = {
		paths = {
			[BZ["Boralus"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}		

	zones[transports["SILVERMOON_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}		
	
	zones[transports["ZULDAZAR_SILVERMOON_PORTAL"]] = {
		paths = {
			[BZ["Silvermoon City"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}		

	zones[transports["ZULDAZAR_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}	

	zones[transports["ZULDAZAR_THUNDERBLUFF_PORTAL"]] = {
		paths = {
			[BZ["Thunder Bluff"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["ZULDAZAR_SILITHUS_PORTAL"]] = {
		paths = {
			[BZ["Silithus"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["SILITHUS_ZULDAZAR_PORTAL"]] = {
		paths = {
			[BZ["Dazar'alor"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	
	-- ZONES, INSTANCES AND COMPLEXES ---------------------------------------------------------

	-- Eastern Kingdoms cities and zones --
	
	zones[BZ["Stormwind City"]] = {
		continent = Eastern_Kingdoms,
		instances = BZ["The Stockade"],
		paths = {
			[BZ["Deeprun Tram"]] = true,
			[BZ["The Stockade"]] = true,
			[BZ["Elwynn Forest"]] = true,
			[transports["STORMWIND_TELDRASSIL_PORTAL"]] = true,
			[transports["STORMWIND_BOREANTUNDRA_BOAT"]] = true,
			[transports["STORMWIND_TWILIGHTHIGHLANDS_PORTAL"]] = true,
			[transports["STORMWIND_MOUNTHYJAL_PORTAL"]] = true,
			[transports["STORMWIND_DEEPHOLM_PORTAL"]] = true,
			[transports["STORMWIND_ULDUM_PORTAL"]] = true,
			[transports["STORMWIND_VASHJIR_PORTAL"]] = true,
			[transports["STORMWIND_TOLBARAD_PORTAL"]] = true,
			[transports["STORMWIND_JADEFOREST_PORTAL"]] = true,
			[transports["STORMWIND_TIRAGARDESOUND_BOAT"]] = true,
			[transports["STORMWIND_TIRAGARDESOUND_PORTAL"]] = true,
			[transports["STORMWIND_STORMSHIELD_PORTAL"]] = true,
			[transports["STORMWIND_EXODAR_PORTAL"]] = true,
			[transports["STORMWIND_SHATTRATH_PORTAL"]] = true,
			[transports["STORMWIND_DALARAN_PORTAL"]] = true,
			[transports["STORMWIND_AZSUNA_PORTAL"]] = true,
		},
		flightnodes = {
			[2] = true,      -- Stormwind, Elwynn (A)
		},
		faction = "Alliance",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 1,
	}
	
	zones[BZ["Undercity"]] = {
		continent = Eastern_Kingdoms,
		instances = BZ["Ruins of Lordaeron"],
		paths = {
			[BZ["Tirisfal Glades"]] = true,
			[transports["SILVERMOON_UNDERCITY_TELEPORT"]] = true,
			[transports["UNDERCITY_HELLFIRE_PORTAL"]] = true,
		},
		flightnodes = {
			[11] = true,     -- Undercity, Tirisfal (H)
		},
		faction = "Horde",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 3,
	}	
	
	zones[BZ["Ironforge"]] = {
		continent = Eastern_Kingdoms,
		instances = BZ["Gnomeregan"],
		paths = {
			[BZ["Dun Morogh"]] = true,
			[BZ["Deeprun Tram"]] = true,
		},
		flightnodes = {
			[6] = true,      -- Ironforge, Dun Morogh (A)
		},
		faction = "Alliance",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 3,
	}

	zones[BZ["Silvermoon City"]] = {
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Eversong Woods"]] = true,
			[transports["SILVERMOON_UNDERCITY_TELEPORT"]] = true,
			[transports["SILVERMOON_ORGRIMMAR_PORTAL"]] = true,
		},
		flightnodes = {
			[82] = true,    -- Silvermoon City (H)
		},
		faction = "Horde",
		type = "City",
		battlepet_low = 1,
		battlepet_high = 3,
	}
	
	
	zones[BZ["Northshire"]] = {
		low = 1,
		high = 6,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Elwynn Forest"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
	}

	zones[BZ["Sunstrider Isle"]] = {
		low = 1,
		high = 6,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Eversong Woods"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
	}

	zones[BZ["Deathknell"]] = {
		low = 1,
		high = 6,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Tirisfal Glades"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
	}	
	
	zones[BZ["Coldridge Valley"]] = {
		low = 1,
		high = 6,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Dun Morogh"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
	}
	
	zones[BZ["New Tinkertown"]] = {
		low = 1,
		high = 6,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Dun Morogh"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
	}	
	
	zones[BZ["Dun Morogh"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		instances = BZ["Gnomeregan"],
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Gnomeregan"]] = true,
			[BZ["Ironforge"]] = true,
			[BZ["Loch Modan"]] = true,
			[BZ["Coldridge Valley"]] = true,
			[BZ["New Tinkertown"]] = true,
		},
		flightnodes = {
			[620] = true,    -- Gol'Bolar Quarry, Dun Morogh (A)
			[619] = true,    -- Kharanos, Dun Morogh (A)
			[6] = true,      -- Ironforge, Dun Morogh (A)
		},
		faction = "Alliance",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Elwynn Forest"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Northshire"]] = true,
			[BZ["Westfall"]] = true,
			[BZ["Redridge Mountains"]] = true,
			[BZ["Stormwind City"]] = true,
			[BZ["Duskwood"]] = true,
			[BZ["Burning Steppes"]] = true,
			[transports["ELWYNNFOREST_DARKMOON_PORTAL"]] = true,
		},
		flightnodes = {
			[2] = true,      -- Stormwind, Elwynn (A)
			[582] = true,    -- Goldshire, Elwynn (A)
			[589] = true,    -- Eastvale Logging Camp, Elwynn (A)
		},
		faction = "Alliance",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Eversong Woods"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Silvermoon City"]] = true,
			[BZ["Ghostlands"]] = true,
			[BZ["Sunstrider Isle"]] = true,
		},
		flightnodes = {
			[82] = true,     -- Silvermoon City (H)
			[631] = true,    -- Falconwing Square, Eversong Woods (H)
			[625] = true,    -- Fairbreeze Village, Eversong Woods (H)
		},
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Gilneas"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		paths = {},  -- phased instance
		faction = "Alliance",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 1,
	}	
	
	zones[BZ["Gilneas City"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		paths = {},  -- phased instance
		faction = "Alliance",
		battlepet_low = 1,
		battlepet_high = 2,
	}

	zones[BZ["Ruins of Gilneas"]] = {
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Silverpine Forest"]] = true,
			[BZ["Ruins of Gilneas City"]] = true,
		},
		flightnodes = {
			[646] = true,    -- Forsaken Forward Command, Gilneas (H)
		},
		fishing_min = 75,
	}

	zones[BZ["Ruins of Gilneas City"]] = {
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Silverpine Forest"]] = true,
			[BZ["Ruins of Gilneas"]] = true,
		},
		fishing_min = 75,
	}
	
	zones[BZ["Tirisfal Glades"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Scarlet Monastery"]] = true,
			[BZ["Scarlet Halls"]] = true,
		},
		paths = {
			[BZ["Western Plaguelands"]] = true,
			[BZ["Undercity"]] = true,
			[BZ["Scarlet Monastery"]] = true,
			[BZ["Scarlet Halls"]] = true,
			[transports["UNDERCITY_GROMGOL_PORTAL"]] = true,
			[transports["ORGRIMMAR_UNDERCITY_PORTAL"]] = true,
			[transports["UNDERCITY_HOWLINGFJORD_PORTAL"]] = true,
			[BZ["Silverpine Forest"]] = true,
			[BZ["Deathknell"]] = true,
		},
		flightnodes = {
			[11] = true,     -- Undercity, Tirisfal (H)
			[384] = true,    -- The Bulwark, Tirisfal (H)
			[460] = true,    -- Brill, Tirisfal Glades (H)
		},
--		complexes = {
--			[BZ["Scarlet Monastery"]] = true,   -- Duplicate name with instance (thanks, Blizz)
--		},
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Westfall"]] = {
		low = 10,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["The Deadmines"],
		paths = {
			[BZ["Duskwood"]] = true,
			[BZ["Elwynn Forest"]] = true,
			[BZ["The Deadmines"]] = true,
		},
		flightnodes = {
			[584] = true,    -- Furlbrow's Pumpkin Farm, Westfall (A)
			[583] = true,    -- Moonbrook, Westfall (A)
			[4] = true,      -- Sentinel Hill, Westfall (A)
		},
		faction = "Alliance",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 4,
	}	
	
	zones[BZ["Ghostlands"]] = {
		low = 10,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Zul'Aman"],
		paths = {
			[BZ["Eastern Plaguelands"]] = true,
			[BZ["Zul'Aman"]] = true,
			[BZ["Eversong Woods"]] = true,
		},
		flightnodes = {
			[83] = true,     -- Tranquillien, Ghostlands (H)
			[205] = true,    -- Zul'Aman, Ghostlands (N)
		},
		faction = "Horde",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 6,
	}

	zones[BZ["Loch Modan"]] = {
		low = 10,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Badlands"]] = true,
			[BZ["Dun Morogh"]] = true,
			[BZ["Searing Gorge"]] = not isHorde and true or nil,
		},
		flightnodes = {
			[555] = true,    -- Farstrider Lodge, Loch Modan (A)
			[8] = true,     -- Thelsamar, Loch Modan (A)
		},
		faction = "Alliance",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 6,
	}

	zones[BZ["Silverpine Forest"]] = {
		low = 10,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Shadowfang Keep"],
		paths = {
			[BZ["Tirisfal Glades"]] = true,
			[BZ["Hillsbrad Foothills"]] = true,
			[BZ["Shadowfang Keep"]] = true,
			[BZ["Ruins of Gilneas"]] = true,
		},
		flightnodes = {
			[654] = true,    -- The Forsaken Front, Silverpine Forest (H)
			[10] = true,     -- The Sepulcher, Silverpine Forest (H)
			[645] = true,    -- Forsaken High Command, Silverpine Forest (H)
			[681] = true,    -- Forsaken Rear Guard, Silverpine Forest (H)
		},
		faction = "Horde",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 6,
	}

	zones[BZ["Redridge Mountains"]] = {
		low = 15,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Burning Steppes"]] = true,
			[BZ["Elwynn Forest"]] = true,
			[BZ["Duskwood"]] = true,
			[BZ["Swamp of Sorrows"]] = true,
		},
		flightnodes = {
			[596] = true,    -- Shalewind Canyon, Redridge (A)
			[615] = true,    -- Camp Everstill, Redridge (A)
			[5] = true,      -- Lakeshire, Redridge (A)
		},
		fishing_min = 75,
		battlepet_low = 4,
		battlepet_high = 6,
	}
	
	zones[BZ["Duskwood"]] = {
		low = 20,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Redridge Mountains"]] = true,
			[BZ["Northern Stranglethorn"]] = true,
			[BZ["Westfall"]] = true,
			[BZ["Deadwind Pass"]] = true,
			[BZ["Elwynn Forest"]] = true,
		},
		flightnodes = {
			[622] = true,    -- Raven Hill, Duskwood (A)
			[12] = true,     -- Darkshire, Duskwood (A)
		},
		fishing_min = 150,
		battlepet_low = 5,
		battlepet_high = 7,
	}	
	
	zones[BZ["Hillsbrad Foothills"]] = {
		low = 15,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Alterac Valley"],
		paths = {
			[BZ["Alterac Valley"]] = true,
			[BZ["The Hinterlands"]] = true,
			[BZ["Arathi Highlands"]] = true,
			[BZ["Silverpine Forest"]] = true,
			[BZ["Western Plaguelands"]] = true,
		},
		flightnodes = {
			[670] = true,    -- Strahnbrad, Alterac Mountains (H)
			[13] = true,     -- Tarren Mill, Hillsbrad (H)
			[667] = true,    -- Ruins of Southshore, Hillsbrad (H)
			[669] = true,    -- Eastpoint Tower, Hillsbrad (H)
			[668] = true,    -- Southpoint Gate, Hillsbrad (H)
		},
		faction = "Horde",
		fishing_min = 150,
		battlepet_low = 6,
		battlepet_high = 7,
	}

	zones[BZ["Wetlands"]] = {
		low = 25,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Arathi Highlands"]] = true,
			[transports["MENETHIL_THERAMORE_BOAT"]] = true,
			[transports["MENETHIL_HOWLINGFJORD_BOAT"]] = true,
			[BZ["Dun Morogh"]] = true,
			[BZ["Loch Modan"]] = true,
		},
		flightnodes = {
			[551] = true,    -- Whelgar's Retreat, Wetlands (A)
			[553] = true,    -- Dun Modr, Wetlands (A)
			[552] = true,    -- Greenwarden's Grove, Wetlands (A)
			[554] = true,    -- Slabchisel's Survey, Wetlands (A)
			[7] = true,      -- Menethil Harbor, Wetlands (A)
		},
		fishing_min = 150,
		battlepet_low = 6,
		battlepet_high = 7,
	}

	zones[BZ["Arathi Highlands"]] = {
		low = 25,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Arathi Basin"],
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Hillsbrad Foothills"]] = true,
			[BZ["Arathi Basin"]] = true,
			[BZ["The Hinterlands"]] = true,
		},
		flightnodes = {
			[601] = true,    -- Galen's Fall, Arathi (H)
			[17] = true,     -- Hammerfall, Arathi (H)
			[16] = true,     -- Refuge Pointe, Arathi (A)
		},
		fishing_min = 150,
		battlepet_low = 7,
		battlepet_high = 8,
	}

	zones[BZ["Stranglethorn Vale"]] = {
		low = 25,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Zul'Gurub"],
		paths = {
			[BZ["Duskwood"]] = true,
			[BZ["Zul'Gurub"]] = true,
			[transports["ORGRIMMAR_GROMGOL_ZEPPELIN"]] = true,
			[transports["UNDERCITY_GROMGOL_PORTAL"]] = true,
			[transports["BOOTYBAY_RATCHET_BOAT"]] = true,
		},
		flightnodes = {
			[593] = true,    -- Bambala, Stranglethorn (H)
			[18] = true,     -- Booty Bay, Stranglethorn (H)
			[19] = true,     -- Booty Bay, Stranglethorn (A)
			[590] = true,    -- Fort Livingston, Stranglethorn (A)
			[592] = true,    -- Hardwrench Hideaway, Stranglethorn (H)
			[195] = true,    -- Rebel Camp, Stranglethorn Vale (A)
			[591] = true,    -- Explorers' League Digsite, Stranglethorn (A)
			[20] = true,     -- Grom'gol, Stranglethorn (H)
		},
		fishing_min = 150,
		battlepet_low = 7,
		battlepet_high = 10,
	}
	
	zones[BZ["Northern Stranglethorn"]] = {
		low = 25,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Zul'Gurub"],
		paths = {
			[BZ["The Cape of Stranglethorn"]] = true,
			[BZ["Duskwood"]] = true,
			[BZ["Zul'Gurub"]] = true,
			[transports["ORGRIMMAR_GROMGOL_ZEPPELIN"]] = true,
			[transports["UNDERCITY_GROMGOL_PORTAL"]] = true,
		},
		flightnodes = {
			[593] = true,    -- Bambala, Stranglethorn (H)
			[590] = true,    -- Fort Livingston, Stranglethorn (A)
			[195] = true,    -- Rebel Camp, Stranglethorn Vale (A)
			[20] = true,     -- Grom'gol, Stranglethorn (H)
		},
		fishing_min = 150,
		battlepet_low = 7,
		battlepet_high = 9,
	}

	zones[BZ["The Cape of Stranglethorn"]] = {
		low = 30,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[transports["BOOTYBAY_RATCHET_BOAT"]] = true,
			["Northern Stranglethorn"] = true,
		},
		flightnodes = {
			[18] = true,     -- Booty Bay, Stranglethorn (H)
			[19] = true,     -- Booty Bay, Stranglethorn (A)
			[592] = true,    -- Hardwrench Hideaway, Stranglethorn (H)
			[591] = true,    -- Explorers' League Digsite, Stranglethorn (A)
		},
		fishing_min = 225,
		battlepet_low = 9,
		battlepet_high = 10,
	}

	zones[BZ["The Hinterlands"]] = {
		low = 30,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Hillsbrad Foothills"]] = true,
			[BZ["Western Plaguelands"]] = true,
			[BZ["Arathi Highlands"]] = true,
		},
		flightnodes = {
			[617] = true,    -- Hiri'watha Research Station, The Hinterlands (H)
			[43] = true,     -- Aerie Peak, The Hinterlands (A)
			[618] = true,    -- Stormfeather Outpost, The Hinterlands (A)
			[76] = true,     -- Revantusk Village, The Hinterlands (H)
		},
		fishing_min = 225,
		battlepet_low = 11,
		battlepet_high = 12,
	}

	zones[BZ["Western Plaguelands"]] = {
		low = 35,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Scholomance"],
		paths = {
			[BZ["The Hinterlands"]] = true,
			[BZ["Eastern Plaguelands"]] = true,
			[BZ["Tirisfal Glades"]] = true,
			[BZ["Scholomance"]] = true,
			[BZ["Hillsbrad Foothills"]] = true,
		},
		flightnodes = {
			[649] = true,    -- Andorhal, Western Plaguelands (H)
			[651] = true,    -- The Menders' Stead, Western Plaguelands (N)
			[650] = true,    -- Andorhal, Western Plaguelands (A)
			[66] = true,     -- Chillwind Camp, Western Plaguelands (A)
			[672] = true,    -- Hearthglen, Western Plaguelands (N)
		},
		fishing_min = 225,
		battlepet_low = 10,
		battlepet_high = 11,
	}

	zones[BZ["Eastern Plaguelands"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Stratholme"],
		paths = {
			[BZ["Western Plaguelands"]] = true,
			[BZ["Stratholme"]] = true,
			[BZ["Ghostlands"]] = true,
		},
		flightnodes = {
			[383] = true,     -- Thondroril River, Eastern Plaguelands (N)
			[1862] = true,    -- Acherus: The Ebon Hold (N)
			[67] = true,      -- Light's Hope Chapel, Eastern Plaguelands (A)
			[86] = true,      -- Eastwall Tower, Eastern Plaguelands (N)
			[68] = true,      -- Light's Hope Chapel, Eastern Plaguelands (H)
			[630] = true,     -- Light's Shield Tower, Eastern Plaguelands (N)
			[85] = true,      -- Northpass Tower, Eastern Plaguelands (N)
			[87] = true,      -- Crown Guard Tower, Eastern Plaguelands (N)
			[84] = true,      -- Plaguewood Tower, Eastern Plaguelands (N)
			[315] = true,     -- Acherus: The Ebon Hold (N)
		},
		type = "PvP Zone",
		fishing_min = 300,
		battlepet_low = 12,
		battlepet_high = 13,
	}

	zones[BZ["Badlands"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Uldaman"],
		paths = {
			[BZ["Uldaman"]] = true,
			[BZ["Searing Gorge"]] = true,
			[BZ["Loch Modan"]] = true,
		},
		flightnodes = {
			[635] = true,    -- Fuselight, Badlands (N)
			[632] = true,    -- Bloodwatcher Point, Badlands (H)
			[634] = true,    -- Dragon's Mouth, Badlands (A)
			[633] = true,    -- Dustwind Dig, Badlands (A)
			[21] = true,     -- New Kargath, Badlands (H)
		},
		fishing_min = 300,
		battlepet_low = 13,
		battlepet_high = 14,
	}	
	
	zones[BZ["Searing Gorge"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Blackrock Depths"]] = true,
			[BZ["Blackrock Caverns"]] = true,
			[BZ["Blackwing Lair"]] = true,
			[BZ["Blackwing Descent"]] = true,
			[BZ["Molten Core"]] = true,
			[BZ["Blackrock Spire"]] = true,
			[BZ["Upper Blackrock Spire"]] = true,
		},
		paths = {
			[BZ["Blackrock Mountain"]] = true,
			[BZ["Badlands"]] = true,
			[BZ["Loch Modan"]] = not isHorde and true or nil,
		},
		flightnodes = {
			[673] = true,    -- Iron Summit, Searing Gorge (N)
			[75] = true,     -- Thorium Point, Searing Gorge (H)
			[74] = true,     -- Thorium Point, Searing Gorge (A)
		},
		complexes = {
			[BZ["Blackrock Mountain"]] = true,
		},
		fishing_min = 425,
		battlepet_low = 13,
		battlepet_high = 14,
	}	
	
	zones[BZ["Burning Steppes"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Blackrock Depths"]] = true,
			[BZ["Blackrock Caverns"]] = true,
			[BZ["Blackwing Lair"]] = true,
			[BZ["Blackwing Descent"]] = true,
			[BZ["Molten Core"]] = true,
			[BZ["Blackrock Spire"]] = true,
			[BZ["Upper Blackrock Spire"]] = true,
		},
		paths = {
			[BZ["Blackrock Mountain"]] = true,
			[BZ["Redridge Mountains"]] = true,
			[BZ["Elwynn Forest"]] = true,
		},
		flightnodes = {
			[70] = true,     -- Flame Crest, Burning Steppes (H)
			[676] = true,    -- Chiselgrip, Burning Steppes (N)
			[675] = true,    -- Flamestar Post, Burning Steppes (N)
			[71] = true,     -- Morgan's Vigil, Burning Steppes (A)
		},
		complexes = {
			[BZ["Blackrock Mountain"]] = true,
		},
		fishing_min = 425,
		battlepet_low = 15,
		battlepet_high = 16,
	}	
	
	zones[BZ["Swamp of Sorrows"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["The Temple of Atal'Hakkar"],
		paths = {
			[BZ["Blasted Lands"]] = true,
			[BZ["Deadwind Pass"]] = true,
			[BZ["The Temple of Atal'Hakkar"]] = true,
			[BZ["Redridge Mountains"]] = true,
		},
		flightnodes = {
			[599] = true,    -- Bogpaddle, Swamp of Sorrows (N)
			[598] = true,    -- Marshtide Watch, Swamp of Sorrows (A)
			[600] = true,    -- The Harborage, Swamp of Sorrows (A)
			[56] = true,     -- Stonard, Swamp of Sorrows (H)
		},
		fishing_min = 425,
		battlepet_low = 14,
		battlepet_high = 15,
	}

	zones[BZ["Blasted Lands"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["The Dark Portal"]] = true,
			[BZ["Swamp of Sorrows"]] = true,
		},
		flightnodes = {
			[602] = true,    -- Surwich, Blasted Lands (A)
			[603] = true,    -- Sunveil Excursion, Blasted Lands (H)
			[604] = true,    -- Dreadmaul Hold, Blasted Lands (H)
			[45] = true,     -- Nethergarde Keep, Blasted Lands (A)
			[1537] = true, 	 -- Shattered Landing, Blasted Lands (H)
			[1538] = true,   -- Shattered Beachhead, Blasted Lands (A)	
		},
		fishing_min = 425,
		battlepet_low = 16,
		battlepet_high = 17,
	}

	zones[BZ["Deadwind Pass"]] = {
		low = 50,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Karazhan"],
		paths = {
			[BZ["Duskwood"]] = true,
			[BZ["Swamp of Sorrows"]] = true,
			[BZ["Karazhan"]] = true,
		},
		fishing_min = 425,
		battlepet_low = 17,
		battlepet_high = 18,
	}

	-- DK starting zone
	zones[BZ["Plaguelands: The Scarlet Enclave"]] = {
		low = 55,
		high = 58,
		continent = Eastern_Kingdoms,
		yards = 3162.5,
		x_offset = 0,
		y_offset = 0,
		texture = "ScarletEnclave",
	}

	zones[BZ["Isle of Quel'Danas"]] = {
		continent = Eastern_Kingdoms,
		low = 70,
		high = 70,
		paths = {
			[BZ["Magisters' Terrace"]] = true,
			[BZ["Sunwell Plateau"]] = true,
		},
		flightnodes = {
			[213] = true,    -- Shattered Sun Staging Area (N)
		},
		instances = {
			[BZ["Magisters' Terrace"]] = true,
			[BZ["Sunwell Plateau"]] = true,
		},
		fishing_min = 450,
		battlepet_low = 20,
		battlepet_high = 20,
	}
	
	zones[BZ["Vashj'ir"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Throne of the Tides"]] = true,
		},
		flightnodes = {
			[522] = true,    -- Silver Tide Hollow, Vashj'ir (N) S seahorse
			[524] = true,    -- Darkbreak Cove, Vashj'ir (A) A seahorse
			[526] = true,    -- Tenebrous Cavern, Vashj'ir (H) A seahorse
			[605] = true,    -- Voldrin's Hold, Vashj'ir (A) S seahorse
			[611] = true,    -- Voldrin's Hold, Vashj'ir (A) S
			[606] = true,    -- Sandy Beach, Vashj'ir (A) S 
			[607] = true,    -- Sandy Beach, Vashj'ir (A) S seahorse
			[608] = true,    -- Sandy Beach, Vashj'ir (H) S 
			[609] = true,    -- Sandy Beach, Vashj'ir (H) S seahorse
			[610] = true,    -- Stygian Bounty, Vashj'ir (H) S 
			[612] = true,    -- Stygian Bounty, Vashj'ir (H) S seahorse
			[521] = true,    -- Smuggler's Scar, Vashj'ir (N) K seahorse
			[523] = true,    -- Tranquil Wash, Vashj'ir (A) S seahorse
			[525] = true,    -- Legion's Rest, Vashj'ir (H) S seahorse
		},
		fishing_min = 575,
		battlepet_low = 22,
		battlepet_high = 23,
	}

	zones[BZ["Kelp'thar Forest"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Shimmering Expanse"]] = true,
		},
		flightnodes = {
			[521] = true,    -- Smuggler's Scar, Vashj'ir (N) seahorse
		},
		fishing_min = 575,
		battlepet_low = 22,
		battlepet_high = 23,
	}

	zones[BZ["Shimmering Expanse"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Kelp'thar Forest"]] = true,
			[BZ["Abyssal Depths"]] = true,
		},
		flightnodes = {
			[522] = true,    -- Silver Tide Hollow, Vashj'ir (N) seahorse
			[605] = true,    -- Voldrin's Hold, Vashj'ir (A) seahorse
			[611] = true,    -- Voldrin's Hold, Vashj'ir (A) 
			[606] = true,    -- Sandy Beach, Vashj'ir (A)  
			[607] = true,    -- Sandy Beach, Vashj'ir (A) seahorse
			[608] = true,    -- Sandy Beach, Vashj'ir (H)  
			[609] = true,    -- Sandy Beach, Vashj'ir (H) seahorse
			[610] = true,    -- Stygian Bounty, Vashj'ir (H)  
			[612] = true,    -- Stygian Bounty, Vashj'ir (H) seahorse
			[523] = true,    -- Tranquil Wash, Vashj'ir (A) seahorse
			[525] = true,    -- Legion's Rest, Vashj'ir (H) seahorse
		},
		fishing_min = 575,
		battlepet_low = 22,
		battlepet_high = 23,
	}

	zones[BZ["Abyssal Depths"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Throne of the Tides"]] = true,
		},
		paths = {
			[BZ["Shimmering Expanse"]] = true,
			[BZ["Throne of the Tides"]] = true,
		},
		flightnodes = {
			[524] = true,    -- Darkbreak Cove, Vashj'ir (A) seahorse
			[526] = true,    -- Tenebrous Cavern, Vashj'ir (H) seahorse
		},
		fishing_min = 575,
		battlepet_low = 22,
		battlepet_high = 23,
	}	
	
	zones[BZ["Twilight Highlands"]] = {
		low = 84,
		high = 90,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Grim Batol"]] = true,
			[BZ["The Bastion of Twilight"]] = true,
			[BZ["Twin Peaks"]] = true,
		},
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Grim Batol"]] = true,
			[BZ["Twin Peaks"]] = true,
			[transports["TWILIGHTHIGHLANDS_STORMWIND_PORTAL"]] = true,
			[transports["TWILIGHTHIGHLANDS_ORGRIMMAR_PORTAL"]] = true,
		},
		flightnodes = {
			[657] = true,    -- The Gullet, Twilight Highlands (H)
			[659] = true,    -- Bloodgulch, Twilight Highlands (H)
			[661] = true,    -- Dragonmaw Port, Twilight Highlands (H)
			[663] = true,    -- Victor's Point, Twilight Highlands (A)
			[665] = true,    -- Thundermar, Twilight Highlands (A)
			[656] = true,    -- Crushblow, Twilight Highlands (H)
			[658] = true,    -- Vermillion Redoubt, Twilight Highlands (N)
			[660] = true,    -- The Krazzworks, Twilight Highlands (H)
			[662] = true,    -- Highbank, Twilight Highlands (A)
			[664] = true,    -- Firebeard's Patrol, Twilight Highlands (A)
			[666] = true,    -- Kirthaven, Twilight Highlands (A)
		},
		fishing_min = 650,
		battlepet_low = 23,
		battlepet_high = 24,
	}	
	
	zones[BZ["Tol Barad"]] = {
		low = 84,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Tol Barad Peninsula"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 675,
		battlepet_low = 23,
		battlepet_high = 24,
	}

	zones[BZ["Tol Barad Peninsula"]] = {
		low = 84,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Tol Barad"]] = true,
			[transports["TOLBARAD_ORGRIMMAR_PORTAL"]] = true,
			[transports["TOLBARAD_STORMWIND_PORTAL"]] = true,
		},
		fishing_min = 675,
		battlepet_low = 23,
		battlepet_high = 24,
	}	
	
	zones[BZ["Amani Pass"]] = {
		continent = Eastern_Kingdoms,
	}	



	-- Kalimdor cities and zones --
	
	zones[BZ["Orgrimmar"]] = {
		continent = Kalimdor,
		instances = {
			[BZ["Ragefire Chasm"]] = true,
			[BZ["The Ring of Valor"]] = true,
		},
		paths = {
			[BZ["Durotar"]] = true,
			[BZ["Ragefire Chasm"]] = true,
			[BZ["Azshara"]] = true,
			[transports["ORGRIMMAR_UNDERCITY_PORTAL"]] = true,
			[transports["ORGRIMMAR_GROMGOL_ZEPPELIN"]] = true,
			[transports["ORGRIMMAR_BOREANTUNDRA_ZEPPELIN"]] = true,
			[transports["ORGRIMMAR_THUNDERBLUFF_ZEPPELIN"]] = true,
			[transports["ORGRIMMAR_TWILIGHTHIGHLANDS_PORTAL"]] = true,
			[transports["ORGRIMMAR_MOUNTHYJAL_PORTAL"]] = true,
			[transports["ORGRIMMAR_DEEPHOLM_PORTAL"]] = true,
			[transports["ORGRIMMAR_ULDUM_PORTAL"]] = true,
			[transports["ORGRIMMAR_VASHJIR_PORTAL"]] = true,
			[transports["ORGRIMMAR_TOLBARAD_PORTAL"]] = true,
			[transports["ORGRIMMAR_JADEFOREST_PORTAL"]] = true,
			[transports["ORGRIMMAR_ZULDAZAR_PORTAL"]] = true,
			[transports["ORGRIMMAR_WARSPEAR_PORTAL"]] = true,
			[transports["ORGRIMMAR_SILVERMOON_PORTAL"]] = true,
			[transports["ORGRIMMAR_SHATTRATH_PORTAL"]] = true,
			[transports["ORGRIMMAR_DALARAN_PORTAL"]] = true,
			[transports["ORGRIMMAR_AZSUNA_PORTAL"]] = true,
		},
		flightnodes = {
			[23] = true,     -- Orgrimmar, Durotar (H)
		},
		faction = "Horde",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 1,
	}
	
	zones[BZ["Thunder Bluff"]] = {
		continent = Kalimdor,
		paths = {
			[BZ["Mulgore"]] = true,
			[transports["ORGRIMMAR_THUNDERBLUFF_ZEPPELIN"]] = true,
		},
		flightnodes = {
			[22] = true,     -- Thunder Bluff, Mulgore (H)
		},
		faction = "Horde",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 2,
	}
	
	zones[BZ["The Exodar"]] = {
		continent = Kalimdor,
		paths = {
			[BZ["Azuremyst Isle"]] = true,
			[transports["EXODAR_STORMWIND_PORTAL"]] = true,
		},
		flightnodes = {
			[94] = true,    -- The Exodar (A)
		},
		faction = "Alliance",
		type = "City",
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Darnassus"]] = {
		continent = Kalimdor,
		paths = {
			[BZ["Teldrassil"]] = true,
			[transports["DARNASSUS_HELLFIRE_PORTAL"]] = true,
			[transports["DARNASSUS_EXODAR_PORTAL"]] = true,
		},
		flightnodes = {
			[457] = true,    -- Darnassus, Teldrassil (A)
		},
		faction = "Alliance",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 2,
	}



	zones[BZ["Ammen Vale"]] = {
		low = 1,
		high = 6,
		continent = Kalimdor,
		paths = {
			[BZ["Azuremyst Isle"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
	}
	
	zones[BZ["Valley of Trials"]] = {
		low = 1,
		high = 6,
		continent = Kalimdor,
		paths = {
			[BZ["Durotar"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
	}
	
	zones[BZ["Echo Isles"]] = {
		low = 1,
		high = 6,
		continent = Kalimdor,
		paths = {
			[BZ["Durotar"]] = true,
			[transports["ECHOISLES_ZULDAZAR_BOAT"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
	}

	zones[BZ["Camp Narache"]] = {
		low = 1,
		high = 6,
		continent = Kalimdor,
		paths = {
			[BZ["Mulgore"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
	}
	
	zones[BZ["Shadowglen"]] = {
		low = 1,
		high = 6,
		continent = Kalimdor,
		paths = {
			[BZ["Teldrassil"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
	}	
	
	
	zones[BZ["Azuremyst Isle"]] = {
		low = 1,
		high = 20,
		continent = Kalimdor,
		paths = {
			[BZ["The Exodar"]] = true,
			[BZ["Ammen Vale"]] = true,
			[BZ["Bloodmyst Isle"]] = true,
			[transports["TELDRASSIL_AZUREMYST_PORTAL"]] = true,
		},
		flightnodes = {
			[94] = true,     -- The Exodar (A)
			[624] = true,    -- Azure Watch, Azuremyst Isle (A)
		},
		faction = "Alliance",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Durotar"]] = {
		low = 1,
		high = 20,
		continent = Kalimdor,
		instances = BZ["Ragefire Chasm"],
		paths = {
			[BZ["Northern Barrens"]] = true,
			[BZ["Orgrimmar"]] = true,
			[BZ["Valley of Trials"]] = true,
			[BZ["Echo Isles"]] = true,
		},
		flightnodes = {
			[536] = true,    -- Sen'jin Village, Durotar (H)
			[537] = true,    -- Razor Hill, Durotar (H)
			[23] = true,     -- Orgrimmar, Durotar (H)
		},
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Mulgore"]] = {
		low = 1,
		high = 20,
		continent = Kalimdor,
		paths = {
			[BZ["Thunder Bluff"]] = true,
			[BZ["Southern Barrens"]] = true,
			[transports["MULGORE_DARKMOON_PORTAL"]] = true,
		},
		flightnodes = {
			[402] = true,    -- Bloodhoof Village, Mulgore (H)
			[22] = true,     -- Thunder Bluff, Mulgore (H)
		},
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Teldrassil"]] = {
		low = 1,
		high = 20,
		continent = Kalimdor,
		paths = {
			[BZ["Darnassus"]] = true,
			[BZ["Shadowglen"]] = true,
			[transports["TELDRASSIL_AZUREMYST_PORTAL"]] = true,
			[transports["STORMWIND_TELDRASSIL_PORTAL"]] = true,
		},
		flightnodes = {
			[27] = true,     -- Rut'theran Village, Teldrassil (A)
			[456] = true,    -- Dolanaar, Teldrassil (A)
			[457] = true,    -- Darnassus, Teldrassil (A)
		},
		faction = "Alliance",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Azshara"]] = {
		low = 10,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Ashenvale"]] = true,
			[BZ["Orgrimmar"]] = true,
		},
		flightnodes = {
			[683] = true,    -- Valormok, Azshara (H)
			[613] = true,    -- Southern Rocketway, Azshara (H)
			[44] = true,     -- Bilgewater Harbor, Azshara (H)
			[614] = true,    -- Northern Rocketway, Azshara (H)
		},
		fishing_min = 75,
		faction = "Horde",
		battlepet_low = 3,
		battlepet_high = 6,
	}	
	
	zones[BZ["Bloodmyst Isle"]] = {
		low = 10,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Azuremyst Isle"],
		flightnodes = {
			[93] = true,    -- Blood Watch, Bloodmyst Isle (A)
		},
		faction = "Alliance",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 6,
	}	
	
	zones[BZ["Darkshore"]] = {
		low = 10,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Ashenvale"]] = true,
		},
		flightnodes = {
			[339] = true,    -- Grove of the Ancients, Darkshore (A)
			[26] = true,     -- Lor'danel, Darkshore (A)
		},
		faction = "Alliance",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 6,
	}

	zones[BZ["Northern Barrens"]] = {
		low = 10,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Wailing Caverns"]] = true,
			[BZ["Warsong Gulch"]] = isHorde and true or nil,
		},
		paths = {
			[BZ["Southern Barrens"]] = true,
			[BZ["Ashenvale"]] = true,
			[BZ["Durotar"]] = true,
			[BZ["Wailing Caverns"]] = true,
			[transports["BOOTYBAY_RATCHET_BOAT"]] = true,
			[BZ["Warsong Gulch"]] = isHorde and true or nil,
			[BZ["Stonetalon Mountains"]] = true,
		},
		flightnodes = {
			[458] = true,   -- Nozzlepot's Outpost, Northern Barrens (H)
			[80] = true,    -- Ratchet, Northern Barrens (N)
			[25] = true,    -- The Crossroads, Northern Barrens (H)
		},
		faction = "Horde",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 4,
	}

	zones[BZ["Ashenvale"]] = {
		low = 15,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Blackfathom Deeps"]] = true,
			[BZ["Warsong Gulch"]] = not isHorde and true or nil,
		},
		paths = {
			[BZ["Azshara"]] = true,
			[BZ["Northern Barrens"]] = true,
			[BZ["Blackfathom Deeps"]] = true,
			[BZ["Warsong Gulch"]] = not isHorde and true or nil,
			[BZ["Felwood"]] = true,
			[BZ["Darkshore"]] = true,
			[BZ["Stonetalon Mountains"]] = true,
		},
		flightnodes = {
			[61] = true,     -- Splintertree Post, Ashenvale (H)
			[351] = true,    -- Stardust Spire, Ashenvale (A)
			[338] = true,    -- Blackfathom Camp, Ashenvale (A)
			[28] = true,     -- Astranaar, Ashenvale (A)
			[356] = true,    -- Silverwind Refuge, Ashenvale (H)
			[58] = true,     -- Zoram'gar Outpost, Ashenvale (H)
			[167] = true,    -- Forest Song, Ashenvale (A)
			[354] = true,    -- The Mor'Shan Ramparts, Ashenvale (H)
			[350] = true,    -- Hellscream's Watch, Ashenvale (H)
		},
		fishing_min = 150,
		battlepet_low = 4,
		battlepet_high = 6,
	}

	zones[BZ["Stonetalon Mountains"]] = {
		low = 20,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Desolace"]] = true,
			[BZ["Northern Barrens"]] = true,
			[BZ["Southern Barrens"]] = true,
			[BZ["Ashenvale"]] = true,
		},
		flightnodes = {
			[365] = true,    -- Farwatcher's Glen, Stonetalon Mountains (A)
			[33] = true,     -- Thal'darah Overlook, Stonetalon Mountains (A)
			[541] = true,    -- Mirkfallon Post, Stonetalon Mountains (A)
			[29] = true,     -- Sun Rock Retreat, Stonetalon Mountains (H)
			[360] = true,    -- Cliffwalker Post, Stonetalon Mountains (H)
			[540] = true,    -- The Sludgewerks, Stonetalon Mountains (H)
			[362] = true,    -- Krom'gar Fortress, Stonetalon Mountains (H)
			[363] = true,    -- Malaka'jin, Stonetalon Mountains (H)
			[364] = true,    -- Northwatch Expedition Base Camp, Stonetalon Mountains (A)
			[361] = true,    -- Windshear Hold, Stonetalon Mountains (A)
		},
		fishing_min = 150,
		battlepet_low = 5,
		battlepet_high = 7,
	}
	
	zones[BZ["Desolace"]] = {
		low = 30,
		high = 60,
		continent = Kalimdor,
		instances = BZ["Maraudon"],
		paths = {
			[BZ["Feralas"]] = true,
			[BZ["Stonetalon Mountains"]] = true,
			[BZ["Maraudon"]] = true,
		},
		flightnodes = {
			[367] = true,    -- Thargad's Camp, Desolace (A)
			[368] = true,    -- Karnum's Glade, Desolace (N)
			[369] = true,    -- Thunk's Abode, Desolace (N)
			[370] = true,    -- Ethel Rethor, Desolace (N)
			[38] = true,     -- Shadowprey Village, Desolace (H)
			[366] = true,    -- Furien's Post, Desolace (H)
			[37] = true,     -- Nijel's Point, Desolace (A)
		},
		fishing_min = 225,
		battlepet_low = 7,
		battlepet_high = 9,
	}	
	
	zones[BZ["Southern Barrens"]] = {
		low = 25,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Razorfen Kraul"]] = true,
		},
		paths = {
			[BZ["Northern Barrens"]] = true,
			[BZ["Thousand Needles"]] = true,
			[BZ["Razorfen Kraul"]] = true,
			[BZ["Dustwallow Marsh"]] = true,
			[BZ["Stonetalon Mountains"]] = true,
			[BZ["Mulgore"]] = true,
		},
		flightnodes = {
			[388] = true,    -- Northwatch Hold, Southern Barrens (A)
			[389] = true,    -- Fort Triumph, Southern Barrens (A)
			[390] = true,    -- Hunter's Hill, Southern Barrens (H)
			[77] = true,     -- Vendetta Point, Southern Barrens (H)
			[387] = true,    -- Honor's Stand, Southern Barrens (A)
			[391] = true,    -- Desolation Hold, Southern Barrens (H)
		},
		fishing_min = 225,
		battlepet_low = 9,
		battlepet_high = 10,
	}	
	
	zones[BZ["Dustwallow Marsh"]] = {
		low = 35,
		high = 60,
		continent = Kalimdor,
		instances = BZ["Onyxia's Lair"],
		paths = {
			[BZ["Onyxia's Lair"]] = true,
			[BZ["Southern Barrens"]] = true,
			[BZ["Thousand Needles"]] = true,
			[transports["MENETHIL_THERAMORE_BOAT"]] = true,
		},
		flightnodes = {
			[55] = true,     -- Brackenwall Village, Dustwallow Marsh (H)
			[179] = true,    -- Mudsprocket, Dustwallow Marsh (N)
			[32] = true,     -- Theramore, Dustwallow Marsh (A)
		},
		fishing_min = 225,
		battlepet_low = 12,
		battlepet_high = 13,
	}	
	
	zones[BZ["Feralas"]] = {
		low = 35,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Dire Maul - East"]] = true,
			[BZ["Dire Maul - North"]] = true,
			[BZ["Dire Maul - West"]] = true,
		},
		paths = {
			[BZ["Thousand Needles"]] = true,
			[BZ["Desolace"]] = true,
			[BZ["Dire Maul"]] = true,
		},
		flightnodes = {
			[565] = true,    -- Dreamer's Rest, Feralas (A)
			[567] = true,    -- Tower of Estulan, Feralas (A)
			[569] = true,    -- Stonemaul Hold, Feralas (H)	
			[41] = true,     -- Feathermoon, Feralas (A)
			[568] = true,    -- Camp Ataya, Feralas (H)
			[42] = true,     -- Camp Mojache, Feralas (H)
			[31] = true,     -- Shadebough, Feralas (A)
		},
		complexes = {
			[BZ["Dire Maul"]] = true,
		},
		fishing_min = 225,
		battlepet_low = 11,
		battlepet_high = 12,
	}	
	
	zones[BZ["Thousand Needles"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Razorfen Downs"]] = true,
		},
		paths = {
			[BZ["Feralas"]] = true,
			[BZ["Southern Barrens"]] = true,
			[BZ["Tanaris"]] = true,
			[BZ["Dustwallow Marsh"]] = true,
			[BZ["Razorfen Downs"]] = true,
		},
		flightnodes = {
			[513] = true,    -- Fizzle & Pozzik's Speedbarge, Thousand Needles (N)
			[30] = true,     -- Westreach Summit, Thousand Needles (H)
		},
		fishing_min = 300,
		battlepet_low = 13,
		battlepet_high = 14,
	}	
	
	zones[BZ["Felwood"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Winterspring"]] = true,
			[BZ["Moonglade"]] = true,
			[BZ["Ashenvale"]] = true,
		},
		flightnodes = {
			[595] = true,    -- Wildheart Point, Felwood (N)
			[597] = true,    -- Irontree Clearing, Felwood (H)
			[166] = true,    -- Emerald Sanctuary, Felwood (N)
			[594] = true,    -- Whisperwind Grove, Felwood (N)
			[65] = true,     -- Talonbranch Glade, Felwood (A)
		},
		fishing_min = 300,
		battlepet_low = 14,
		battlepet_high = 15,
	}	
	
	zones[BZ["Tanaris"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Zul'Farrak"]] = true,
			[BZ["Old Hillsbrad Foothills"]] = true,
			[BZ["The Black Morass"]] = true,
			[BZ["Hyjal Summit"]] = true,
			[BZ["The Culling of Stratholme"]] = true,
			[BZ["End Time"]] = true,
			[BZ["Hour of Twilight"]] = true,
			[BZ["Well of Eternity"]] = true,
			[BZ["Dragon Soul"]] = true,
		},
		paths = {
			[BZ["Thousand Needles"]] = true,
			[BZ["Un'Goro Crater"]] = true,
			[BZ["Zul'Farrak"]] = true,
			[BZ["Caverns of Time"]] = true,
			[BZ["Uldum"]] = true,
		},
		flightnodes = {
			[532] = true,    -- Gunstan's Dig, Tanaris (A)
			[39] = true,     -- Gadgetzan, Tanaris (A)
			[531] = true,    -- Dawnrise Expedition, Tanaris (H)
			[40] = true,     -- Gadgetzan, Tanaris (H)
			[539] = true,    -- Bootlegger Outpost, Tanaris (N)
		},
		complexes = {
			[BZ["Caverns of Time"]] = true,
		},
		fishing_min = 300,
		battlepet_low = 13,
		battlepet_high = 14,
	}

	zones[BZ["Un'Goro Crater"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Silithus"]] = true,
			[BZ["Tanaris"]] = true,
		},
		flightnodes = {
			[79] = true,     -- Marshal's Stand, Un'Goro Crater (N)
			[386] = true,    -- Mossy Pile, Un'Goro Crater (N)
		},
		fishing_min = 375,
		battlepet_low = 15,
		battlepet_high = 16,
	}

	zones[BZ["Winterspring"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Felwood"]] = true,
			[BZ["Moonglade"]] = true,
			[BZ["Mount Hyjal"]] = true,
		},
		flightnodes = {
			[53] = true,    -- Everlook, Winterspring (H)
			[52] = true,    -- Everlook, Winterspring (A)
		},
		fishing_min = 425,
		battlepet_low = 17,
		battlepet_high = 18,
	}	
	
	zones[BZ["Silithus"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Ruins of Ahn'Qiraj"]] = true,
			[BZ["Un'Goro Crater"]] = true,
			[BZ["Ahn'Qiraj: The Fallen Kingdom"]] = true,
			[transports["SILITHUS_ZULDAZAR_PORTAL"]] = true,
			[transports["SILITHUS_TIRAGARDESOUND_PORTAL"]] = true,
		},
		flightnodes = {
			[73] = true,    -- Cenarion Hold, Silithus (A)
			[72] = true,    -- Cenarion Hold, Silithus (H)
		},
		instances = {
			[BZ["Ahn'Qiraj"]] = true,
			[BZ["Ruins of Ahn'Qiraj"]] = true,
		},
		complexes = {
			[BZ["Ahn'Qiraj: The Fallen Kingdom"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 425,
		battlepet_low = 16,
		battlepet_high = 17,
	}

	zones[BZ["Moonglade"]] = {
		continent = Kalimdor,
		low = 1,
		high = 90,
		paths = {
			[BZ["Felwood"]] = true,
			[BZ["Winterspring"]] = true,
		},
		flightnodes = {
			[49] = true,    -- Moonglade (A)
			[69] = true,    -- Moonglade (H)
			[62] = true,    -- Nighthaven, Moonglade (A)
			[63] = true,    -- Nighthaven, Moonglade (H)
		},
		fishing_min = 300,
		battlepet_low = 15,
		battlepet_high = 16,
	}

	zones[BZ["Mount Hyjal"]] = {
		low = 80,
		high = 90,
		continent = Kalimdor,
		paths = {
			[BZ["Winterspring"]] = true,
			[transports["MOUNTHYJAL_ORGRIMMAR_PORTAL"]] = true,
			[transports["MOUNTHYJAL_STORMWIND_PORTAL"]] = true,
		},
		flightnodes = {
			[558] = true,    -- Grove of Aessina, Hyjal (N)
			[616] = true,    -- Gates of Sothann, Hyjal (N)
			[781] = true,    -- Sanctuary of Malorne, Hyjal (N)
			[559] = true,    -- Nordrassil, Hyjal (N)
			[557] = true,    -- Shrine of Aviana, Hyjal (N)
		},
		instances = {
			[BZ["Firelands"]] = true,
		},
		fishing_min = 575,
		battlepet_low = 22,
		battlepet_high = 24,
	}

	zones[BZ["Uldum"]] = {
		low = 80,
		high = 90,
		continent = Kalimdor,
		paths = {
			[BZ["Tanaris"]] = true,
		},
		flightnodes = {
			[653] = true,    -- Oasis of Vir'sar, Uldum (N)
			[652] = true,    -- Ramkahen, Uldum (N)
			[674] = true,    -- Schnottz's Landing, Uldum (N)
		},
		instances = {
			[BZ["Halls of Origination"]] = true,
			[BZ["Lost City of the Tol'vir"]] = true,
			[BZ["The Vortex Pinnacle"]] = true,
			[BZ["Throne of the Four Winds"]] = true,
		},
		fishing_min = 650,
		battlepet_low = 23,
		battlepet_high = 24,
	}

	zones[BZ["Molten Front"]] = {
		low = 85,
		high = 85,
		continent = Kalimdor,
		battlepet_low = 24,
		battlepet_high = 24,
	}
	
	
	
	
	-- Outland city and zones --
	
	zones[BZ["Shattrath City"]] = {
		continent = Outland,
		paths = {
			[BZ["Terokkar Forest"]] = true,
			[BZ["Nagrand"]] = true,
			[transports["SHATTRATH_QUELDANAS_PORTAL"]] = true,
			[transports["SHATTRATH_STORMWIND_PORTAL"]] = true,
			[transports["SHATTRATH_ORGRIMMAR_PORTAL"]] = true,
		},
		flightnodes = {
			[128] = true,    -- Shattrath, Terokkar Forest (N)
		},
		faction = "Sanctuary",
		type = "City",
		battlepet_low = 17,
		battlepet_high = 17,
	}
	
	
	
	zones[BZ["Hellfire Peninsula"]] = {
		low = 58,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["The Blood Furnace"]] = true,
			[BZ["Hellfire Ramparts"]] = true,
			[BZ["Magtheridon's Lair"]] = true,
			[BZ["The Shattered Halls"]] = true,
		},
		paths = {
			[BZ["Zangarmarsh"]] = true,
			[BZ["The Dark Portal"]] = true,
			[BZ["Terokkar Forest"]] = true,
			[BZ["Hellfire Citadel"]] = true,
			[transports["HELLFIRE_ORGRIMMAR_PORTAL"]] = true,
			[transports["HELLFIRE_STORMWIND_PORTAL"]] = true,
		},
		flightnodes = {
			[99] = true,     -- Thrallmar, Hellfire Peninsula (H)
			[101] = true,    -- Temple of Telhamat, Hellfire Peninsula (A)
			[141] = true,    -- Spinebreaker Ridge, Hellfire Peninsula (H)
			[100] = true,    -- Honor Hold, Hellfire Peninsula (A)
			[102] = true,    -- Falcon Watch, Hellfire Peninsula (H)
			[129] = true,    -- Hellfire Peninsula, The Dark Portal (A)
			[130] = true,    -- Hellfire Peninsula, The Dark Portal (H)
		},
		complexes = {
			[BZ["Hellfire Citadel"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 375,
		battlepet_low = 17,
		battlepet_high = 18,
	}	
	
	zones[BZ["Zangarmarsh"]] = {
		low = 60,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["The Underbog"]] = true,
			[BZ["Serpentshrine Cavern"]] = true,
			[BZ["The Steamvault"]] = true,
			[BZ["The Slave Pens"]] = true,
		},
		paths = {
			[BZ["Coilfang Reservoir"]] = true,
			[BZ["Blade's Edge Mountains"]] = true,
			[BZ["Terokkar Forest"]] = true,
			[BZ["Nagrand"]] = true,
			[BZ["Hellfire Peninsula"]] = true,
		},
		flightnodes = {
			[118] = true,    -- Zabra'jin, Zangarmarsh (H)
			[164] = true,    -- Orebor Harborage, Zangarmarsh (A)
			[117] = true,    -- Telredor, Zangarmarsh (A)
			[151] = true,    -- Swamprat Post, Zangarmarsh (H)
		},
		complexes = {
			[BZ["Coilfang Reservoir"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 400,
		battlepet_low = 18,
		battlepet_high = 19,
	}	
	
	zones[BZ["Terokkar Forest"]] = {
		low = 62,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["Mana-Tombs"]] = true,
			[BZ["Sethekk Halls"]] = true,
			[BZ["Shadow Labyrinth"]] = true,
			[BZ["Auchenai Crypts"]] = true,
		},
		paths = {
			[BZ["Ring of Observance"]] = true,
			[BZ["Shadowmoon Valley"]] = true,
			[BZ["Zangarmarsh"]] = true,
			[BZ["Shattrath City"]] = true,
			[BZ["Hellfire Peninsula"]] = true,
			[BZ["Nagrand"]] = true,
		},
		flightnodes = {
			[127] = true,    -- Stonebreaker Hold, Terokkar Forest (H)
			[128] = true,    -- Shattrath, Terokkar Forest (N)
			[121] = true,    -- Allerian Stronghold, Terokkar Forest (A)
		},
		complexes = {
			[BZ["Ring of Observance"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 450,
		battlepet_low = 18,
		battlepet_high = 19,
	}

	zones[BZ["Nagrand"]] = {
		low = 64,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["Nagrand Arena"]] = true,
		},
		paths = {
			[BZ["Zangarmarsh"]] = true,
			[BZ["Shattrath City"]] = true,
			[BZ["Terokkar Forest"]] = true,
		},
		flightnodes = {
			[120] = true,    -- Garadar, Nagrand (H)
			[119] = true,    -- Telaar, Nagrand (A)
		},
		type = "PvP Zone",
		fishing_min = 475,
		battlepet_low = 18,
		battlepet_high = 19,
	}

	zones[BZ["Blade's Edge Mountains"]] = {
		low = 65,
		high = 80,
		continent = Outland,
		instances =
		{
			[BZ["Gruul's Lair"]] = true,
			[BZ["Blade's Edge Arena"]] = true,
		},
		paths = {
			[BZ["Netherstorm"]] = true,
			[BZ["Zangarmarsh"]] = true,
			[BZ["Gruul's Lair"]] = true,
		},
		flightnodes = {
			[126] = true,    -- Thunderlord Stronghold, Blade's Edge Mountains (H)
			[163] = true,    -- Mok'Nathal Village, Blade's Edge Mountains (H)
			[160] = true,    -- Evergrove, Blade's Edge Mountains (N)
			[125] = true,    -- Sylvanaar, Blade's Edge Mountains (A)
			[156] = true,    -- Toshley's Station, Blade's Edge Mountains (A)
		},
		battlepet_low = 18,
		battlepet_high = 20,
	}

	zones[BZ["Netherstorm"]] = {
		low = 67,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["The Mechanar"]] = true,
			[BZ["The Botanica"]] = true,
			[BZ["The Arcatraz"]] = true,
			[BZ["Tempest Keep"]] = true,  -- previously "The Eye"
			[BZ["Eye of the Storm"]] = true,
		},
		paths = {
--			[BZ["Tempest Keep"]] = true,
			[BZ["Blade's Edge Mountains"]] = true,
		},
		flightnodes = {
			[150] = true,    -- Cosmowrench, Netherstorm (N)
			[122] = true,    -- Area 52, Netherstorm (N)
			[139] = true,    -- The Stormspire, Netherstorm (N)
		},
--		complexes = {
--			[BZ["Tempest Keep"]] = true,
--		},
		fishing_min = 475,
		battlepet_low = 20,
		battlepet_high = 21,
	}

	zones[BZ["Shadowmoon Valley"]] = {
		low = 67,
		high = 80,
		continent = Outland,
		instances = BZ["Black Temple"],
		paths = {
			[BZ["Terokkar Forest"]] = true,
			[BZ["Black Temple"]] = true,
		},
		flightnodes = {
			[124] = true,    -- Wildhammer Stronghold, Shadowmoon Valley (A)
			[140] = true,    -- Altar of Sha'tar, Shadowmoon Valley (N)		
			[123] = true,    -- Shadowmoon Village, Shadowmoon Valley (H)
			[159] = true,    -- Sanctum of the Stars, Shadowmoon Valley (N)
		},
		fishing_min = 375,
		battlepet_low = 20,
		battlepet_high = 21,
	}
	
	
	
	
	-- Northrend city and zones --
	
	zones[BZ["Dalaran"]] = {
		continent = Northrend,
		paths = {
			[BZ["The Violet Hold"]] = true,
			[transports["DALARAN_CRYSTALSONG_TELEPORT"]] = true,
			[transports["DALARAN_STORMWIND_PORTAL"]] = true,
			[transports["DALARAN_ORGRIMMAR_PORTAL"]] = true,
		},
		flightnodes = {
			[310] = true,    -- Dalaran (N)
		},
		instances = {
			[BZ["The Violet Hold"]] = true,
			[BZ["Dalaran Arena"]] = true,
		},
		type = "City",
		texture = "Dalaran",
		faction = "Sanctuary",
		fishing_min = 525,
		battlepet_low = 21,
		battlepet_high = 21,
	}
	
	
	zones[BZ["Borean Tundra"]] = {
		low = 58,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Coldarra"]] = true,
			[BZ["Dragonblight"]] = true,
			[BZ["Sholazar Basin"]] = true,
			[transports["STORMWIND_BOREANTUNDRA_BOAT"]] = true,
			[transports["ORGRIMMAR_BOREANTUNDRA_ZEPPELIN"]] = true,
			[transports["MOAKI_UNUPE_BOAT"]] = true,
		},
		flightnodes = {
			[245] = true,    -- Valiance Keep, Borean Tundra (A)
			[259] = true,    -- Bor'gorok Outpost, Borean Tundra (H)
			[246] = true,    -- Fizzcrank Airstrip, Borean Tundra (A)
			[258] = true,    -- Taunka'le Village, Borean Tundra (H)
			[226] = true,    -- Transitus Shield, Coldarra (N)
			[257] = true,    -- Warsong Hold, Borean Tundra (H)
			[289] = true,    -- Amber Ledge, Borean Tundra (N)
			[296] = true,    -- Unu'pe, Borean Tundra (N)
		},
		instances = {
			[BZ["The Nexus"]] = true,
			[BZ["The Oculus"]] = true,
			[BZ["The Eye of Eternity"]] = true,
		},
		complexes = {
			[BZ["Coldarra"]] = true,
		},
		fishing_min = 475,
		battlepet_low = 20,
		battlepet_high = 22,
	}	
	
	zones[BZ["Howling Fjord"]] = {
		low = 58,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Grizzly Hills"]] = true,
			[transports["MENETHIL_HOWLINGFJORD_BOAT"]] = true,
			[transports["UNDERCITY_HOWLINGFJORD_PORTAL"]] = true,
			[transports["MOAKI_KAMAGUA_BOAT"]] = true,
			[BZ["Utgarde Keep"]] = true,
			[BZ["Utgarde Pinnacle"]] = true,
		},
		flightnodes = {
			[248] = true,    -- Apothecary Camp, Howling Fjord (H)
			[191] = true,    -- Vengeance Landing, Howling Fjord (H)
			[190] = true,    -- New Agamand, Howling Fjord (H)
			[192] = true,    -- Camp Winterhoof, Howling Fjord (H)
			[184] = true,    -- Fort Wildervar, Howling Fjord (A)
			[295] = true,    -- Kamagua, Howling Fjord (N)
			[185] = true,    -- Westguard Keep, Howling Fjord (A)
			[183] = true,    -- Valgarde Port, Howling Fjord (A)
		},
		instances = {
			[BZ["Utgarde Keep"]] = true,
			[BZ["Utgarde Pinnacle"]] = true,
		},
		fishing_min = 475,
		battlepet_low = 20,
		battlepet_high = 22,
	}	
	
	zones[BZ["Dragonblight"]] = {
		low = 61,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Borean Tundra"]] = true,
			[BZ["Grizzly Hills"]] = true,
			[BZ["Zul'Drak"]] = true,
			[BZ["Crystalsong Forest"]] = true,
			[transports["MOAKI_UNUPE_BOAT"]] = true,
			[transports["MOAKI_KAMAGUA_BOAT"]] = true,
			[BZ["Azjol-Nerub"]] = true,
			[BZ["Ahn'kahet: The Old Kingdom"]] = true,
			[BZ["Naxxramas"]] = true,
			[BZ["The Obsidian Sanctum"]] = true,
		},
		flightnodes = {
			[252] = true,    -- Wyrmrest Temple, Dragonblight (N)
			[256] = true,    -- Agmar's Hammer, Dragonblight (H)
			[260] = true,    -- Kor'kron Vanguard, Dragonblight (H)
			[254] = true,    -- Venomspite, Dragonblight (H)
			[247] = true,    -- Stars' Rest, Dragonblight (A)
			[244] = true,    -- Wintergarde Keep, Dragonblight (A)
			[251] = true,    -- Fordragon Hold, Dragonblight (A)
			[294] = true,    -- Moa'ki, Dragonblight (N)
		},
		instances = {
			[BZ["Azjol-Nerub"]] = true,
			[BZ["Ahn'kahet: The Old Kingdom"]] = true,
			[BZ["Naxxramas"]] = true,
			[BZ["The Obsidian Sanctum"]] = true,
			[BZ["Strand of the Ancients"]] = true,
		},
		fishing_min = 475,
		battlepet_low = 22,
		battlepet_high = 23,
	}	
	
	zones[BZ["Grizzly Hills"]] = {
		low = 63,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Howling Fjord"]] = true,
			[BZ["Dragonblight"]] = true,
			[BZ["Zul'Drak"]] = true,
			[BZ["Drak'Tharon Keep"]] = true,
		},
		flightnodes = {
			[249] = true,    -- Camp Oneqwah, Grizzly Hills (H)
			[255] = true,    -- Westfall Brigade, Grizzly Hills (A)
			[250] = true,    -- Conquest Hold, Grizzly Hills (H)
			[253] = true,    -- Amberpine Lodge, Grizzly Hills (A)
		},
		instances = BZ["Drak'Tharon Keep"],
		fishing_min = 475,
		battlepet_low = 21,
		battlepet_high = 22,
	}	
	
	zones[BZ["Zul'Drak"]] = {
		low = 64,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Dragonblight"]] = true,
			[BZ["Grizzly Hills"]] = true,
			[BZ["Crystalsong Forest"]] = true,
			[BZ["Gundrak"]] = true,
			[BZ["Drak'Tharon Keep"]] = true,
		},
		flightnodes = {
			[304] = true,    -- The Argent Stand, Zul'Drak (N)
			[305] = true,    -- Ebon Watch, Zul'Drak (N)
			[306] = true,    -- Light's Breach, Zul'Drak (N)
			[307] = true,    -- Zim'Torga, Zul'Drak (N)
			[331] = true,    -- Gundrak, Zul'Drak (N)
		},
		instances = {
			[BZ["Gundrak"]] = true,
			[BZ["Drak'Tharon Keep"]] = true,
		},
		fishing_min = 475,
		battlepet_low = 22,
		battlepet_high = 23,
	}

	zones[BZ["Sholazar Basin"]] = {
		low = 66,
		high = 80,
		continent = Northrend,
		paths = BZ["Borean Tundra"],
		flightnodes = {
			[308] = true,    -- River's Heart, Sholazar Basin (N)
			[309] = true,    -- Nesingwary Base Camp, Sholazar Basin (N)
		},
		fishing_min = 525,
		battlepet_low = 21,
		battlepet_high = 22,
	}

	zones[BZ["Icecrown"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Trial of the Champion"]] = true,
			[BZ["Trial of the Crusader"]] = true,
			[BZ["The Forge of Souls"]] = true,
			[BZ["Pit of Saron"]] = true,
			[BZ["Halls of Reflection"]] = true,
			[BZ["Icecrown Citadel"]] = true,
			[BZ["Hrothgar's Landing"]] = true,
		},
		flightnodes = {
			[325] = true,    -- Death's Rise, Icecrown (N)
			[333] = true,    -- The Shadow Vault, Icecrown (N)
			[334] = true,    -- The Argent Vanguard, Icecrown (N)
			[335] = true,    -- Crusaders' Pinnacle, Icecrown (N)
			[340] = true,    -- Argent Tournament Grounds, Icecrown (N)
		},
		instances = {
			[BZ["Trial of the Champion"]] = true,
			[BZ["Trial of the Crusader"]] = true,
			[BZ["The Forge of Souls"]] = true,
			[BZ["Pit of Saron"]] = true,
			[BZ["Halls of Reflection"]] = true,
			[BZ["Icecrown Citadel"]] = true,
			[BZ["Isle of Conquest"]] = true,
		},
		fishing_min = 550,
		battlepet_low = 22,
		battlepet_high = 23,
	}
	
	zones[BZ["The Storm Peaks"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Crystalsong Forest"]] = true,
			[BZ["Halls of Stone"]] = true,
			[BZ["Halls of Lightning"]] = true,
			[BZ["Ulduar"]] = true,
		},
		flightnodes = {
			[326] = true,    -- Ulduar, The Storm Peaks (N)
			[320] = true,    -- K3, The Storm Peaks (N)
			[321] = true,    -- Frosthold, The Storm Peaks (A)
			[322] = true,    -- Dun Niffelem, The Storm Peaks (N)
			[323] = true,    -- Grom'arsh Crash-Site, The Storm Peaks (H)
			[324] = true,    -- Camp Tunka'lo, The Storm Peaks (H)
			[327] = true,    -- Bouldercrag's Refuge, The Storm Peaks (N)
		},
		instances = {
			[BZ["Halls of Stone"]] = true,
			[BZ["Halls of Lightning"]] = true,
			[BZ["Ulduar"]] = true,
		},
		fishing_min = 550,
		battlepet_low = 22,
		battlepet_high = 23,
	}	
	
	zones[BZ["Crystalsong Forest"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = {
			[transports["DALARAN_CRYSTALSONG_TELEPORT"]] = true,
			[BZ["Dragonblight"]] = true,
			[BZ["Zul'Drak"]] = true,
			[BZ["The Storm Peaks"]] = true,
		},
		flightnodes = {
			[336] = true,    -- Windrunner's Overlook, Crystalsong Forest (A)
			[310] = true,    -- Dalaran (N)
			[337] = true,    -- Sunreaver's Command, Crystalsong Forest (H)
		},
		fishing_min = 500,
		battlepet_low = 22,
		battlepet_high = 23,
	}	
	
	zones[BZ["Hrothgar's Landing"]] = {
		low = 67,
		high = 80,
		paths = BZ["Icecrown"],
		continent = Northrend,
		fishing_min = 550,
		battlepet_low = 22,
		battlepet_high = 22,
	}	
	
	zones[BZ["Wintergrasp"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = BZ["Vault of Archavon"],
		flightnodes = {
			[303] = true,    -- Valiance Landing Camp, Wintergrasp (A)
			[332] = true,    -- Warsong Camp, Wintergrasp (H)
		},
		instances = BZ["Vault of Archavon"],
		type = "PvP Zone",
		fishing_min = 525,
		battlepet_low = 22,
		battlepet_high = 22,
	}	

	zones[BZ["The Frozen Sea"]] = {
		continent = Northrend,
		fishing_min = 575,
	}	
	
	-- The Maelstrom zones --
	
	-- Goblin start zone
	zones[BZ["Kezan"]] = {
		low = 1,
		high = 5,
		continent = The_Maelstrom,
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 1,
	}

	-- Goblin start zone
	zones[BZ["The Lost Isles"]] = {
		low = 1,
		high = 10,
		continent = The_Maelstrom,
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["The Maelstrom"].." (zone)"] = {
		low = 82,
		high = 90,
		continent = The_Maelstrom,
		paths = {
		},
		faction = "Sanctuary",
	}

	zones[BZ["Deepholm"]] = {
		low = 82,
		high = 90,
		continent = The_Maelstrom,
		instances = {
			[BZ["The Stonecore"]] = true,
		},
		paths = {
			[BZ["The Stonecore"]] = true,
			[transports["DEEPHOLM_ORGRIMMAR_PORTAL"]] = true,
			[transports["DEEPHOLM_STORMWIND_PORTAL"]] = true,
		},
		fishing_min = 550,
		battlepet_low = 22,
		battlepet_high = 23,
	}	
	
	zones[BZ["Darkmoon Island"]] = {
		continent = The_Maelstrom,
		fishing_min = 75,
		paths = {
			[transports["DARKMOON_MULGORE_PORTAL"]] = true,
			[transports["DARKMOON_ELWYNNFOREST_PORTAL"]] = true,
		},
		battlepet_low = 1, 
		battlepet_high = 10,
	}
	
	
	
	-- Pandaria cities and zones -- 
	
	zones[BZ["Shrine of Seven Stars"]] = {
		continent = Pandaria,
		paths = {
			[BZ["Vale of Eternal Blossoms"]] = true,
			[transports["SEVENSTARS_STORMWIND_PORTAL"]] = true,
		},
		faction = "Alliance",
		type = "City",
		battlepet_low = 23,
		battlepet_high = 23,
	}

	zones[BZ["Shrine of Two Moons"]] = {
		continent = Pandaria,
		paths = {
			[BZ["Vale of Eternal Blossoms"]] = true,
			[transports["TWOMOONS_ORGRIMMAR_PORTAL"]] = true,
		},
		faction = "Horde",
		type = "City",
		battlepet_low = 23,
		battlepet_high = 23,
	}
	
	
	zones[BZ["The Wandering Isle"]] = {
		low = 1,
		high = 10,
		continent = Pandaria,
--		fishing_min = 25,
 		faction = "Sanctuary",  -- Not contested and not Alliance nor Horde -> no PvP -> sanctuary
	}	
	
	zones[BZ["The Jade Forest"]] = {
		low = 80,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Temple of the Jade Serpent"]] = true,
		},
		paths = {
			[BZ["Temple of the Jade Serpent"]] = true,
			[BZ["Valley of the Four Winds"]] = true,
			[BZ["Timeless Isle"]] = true,
			[transports["JADEFOREST_ORGRIMMAR_PORTAL"]] = true,
			[transports["JADEFOREST_STORMWIND_PORTAL"]] = true,
		},
		flightnodes = {
			[968] = true,    -- Jade Temple Grounds, Jade Forest (N)
			[895] = true,    -- Dawn's Blossom, Jade Forest (N)
			[972] = true,    -- Pearlfin Village, Jade Forest (A)
			[967] = true,    -- The Arboretum, Jade Forest (N)
			[969] = true,    -- Sri-La Village, Jade Forest (N)
			[971] = true,    -- Tian Monastery, Jade Forest (N)
			[973] = true,    -- Honeydew Village, Jade Forest (H)
			[1080] = true,   -- Serpent's Overlook, Jade Forest (N)
			[894] = true,    -- Grookin Hill, Jade Forest (H)
			[966] = true,    -- Paw'Don Village, Jade Forest (A)
			[970] = true,    -- Emperor's Omen, Jade Forest (N)
		},
		fishing_min = 650,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Valley of the Four Winds"]] = {
		low = 81,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Stormstout Brewery"]] = true,
			[BZ["Deepwind Gorge"]] = true,
		},
		paths = {
			[BZ["Stormstout Brewery"]] = true,
			[BZ["The Jade Forest"]] = true,
			[BZ["Krasarang Wilds"]] = true,
			[BZ["The Veiled Stair"]] = true,
			[BZ["Deepwind Gorge"]] = true,
		},
		flightnodes = {
			[989] = true,    -- Stoneplow, Valley of the Four Winds (N)
			[985] = true,    -- Halfhill, Valley of the Four Winds (N)
			[984] = true,    -- Pang's Stead, Valley of the Four Winds (N)
			[1052] = true,   -- Grassy Cline, Valley of the Four Winds (N)
		},
		fishing_min = 700,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Krasarang Wilds"]] = {
		low = 81,
		high = 90,
		continent = Pandaria,
		paths = {
			[BZ["Valley of the Four Winds"]] = true,
		},
		flightnodes = {
			[1190] = true,   -- Lion's Landing, Krasarang Wilds (A)
			[991] = true,    -- Sentinel Basecamp, Krasarang Wilds (A)
			[993] = true,    -- Marista, Krasarang Wilds (N)
			[1195] = true,   -- Domination Point, Krasarang Wilds (H)
			[986] = true,    -- Zhu's Watch, Krasarang Wilds (N)
			[988] = true,    -- The Incursion, Krasarang Wilds (A)
			[990] = true,    -- Dawnchaser Retreat, Krasarang Wilds (H)
			[992] = true,    -- Cradle of Chi-Ji, Krasarang Wilds (N)
			[987] = true,    -- Thunder Cleft, Krasarang Wilds (H)
		},
		fishing_min = 700,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["The Veiled Stair"]] = {
		low = 87,
		high = 87,
		continent = Pandaria,
		instances = {
			[BZ["Terrace of Endless Spring"]] = true,
		},
		paths = {
			[BZ["Terrace of Endless Spring"]] = true,
			[BZ["Valley of the Four Winds"]] = true,
			[BZ["Kun-Lai Summit"]] = true,
		},
		flightnodes = {
			[1029] = true,    -- Tavern in the Mists, The Veiled Stair (N)
		},
		fishing_min = 750,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Kun-Lai Summit"]] = {
		low = 82,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Shado-Pan Monastery"]] = true,
			[BZ["Mogu'shan Vaults"]] = true,
			[BZ["The Tiger's Peak"]] = true,
		},
		paths = {
			[BZ["Shado-Pan Monastery"]] = true,
			[BZ["Mogu'shan Vaults"]] = true,
			[BZ["Vale of Eternal Blossoms"]] = true,
			[BZ["The Veiled Stair"]] = true,
		},
		flightnodes = {
			[1025] = true,    -- Winter's Blossom, Kun-Lai Summit (N)
			[1019] = true,    -- Eastwind Rest, Kun-Lai Summit (H)
			[1021] = true,    -- Zouchin Village, Kun-Lai Summit (N)
			[1023] = true,    -- Kota Basecamp, Kun-Lai Summit (N)
			[1117] = true,    -- Serpent's Spine, Kun-Lai Summit (H)
			[1020] = true,    -- Westwind Rest, Kun-Lai Summit (A)
			[1022] = true,    -- One Keg, Kun-Lai Summit (N)
			[1024] = true,    -- Shado-Pan Fallback, Kun-Lai Summit (N)
			[1017] = true,    -- Binan Village, Kun-Lai Summit (N)
			[1018] = true,    -- Temple of the White Tiger, Kun-Lai Summit (N)
		},
		fishing_min = 625,
		battlepet_low = 23,
		battlepet_high = 25,
	}

	zones[BZ["Townlong Steppes"]] = {
		low = 83,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Siege of Niuzao Temple"]] = true,
		},
		paths = {
			[BZ["Siege of Niuzao Temple"]] = true,
			[BZ["Dread Wastes"]] = true,
			[transports["TOWNLONGSTEPPES_ISLEOFTHUNDER_PORTAL"]] = true,
		},
		flightnodes = {
			[1053] = true,    -- Longying Outpost, Townlong Steppes (N)
			[1054] = true,    -- Gao-Ran Battlefront, Townlong Steppes (N)
			[1055] = true,    -- Rensai's Watchpost, Townlong Steppes (N)
			[1056] = true,    -- Shado-Pan Garrison, Townlong Steppes (N)
		},
		fishing_min = 700,
		battlepet_low = 24,
		battlepet_high = 25,
	}

	zones[BZ["Dread Wastes"]] = {
		low = 84,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Gate of the Setting Sun"]] = true,
			[BZ["Heart of Fear"]] = true,
		},
		paths = {
			[BZ["Gate of the Setting Sun"]] = true,
			[BZ["Heart of Fear"]] = true,
			[BZ["Townlong Steppes"]] = true
		},
		flightnodes = {
			[1072] = true,    -- The Sunset Brewgarden, Dread Wastes (N)
			[1090] = true,    -- The Briny Muck, Dread Wastes (N)
			[1115] = true,    -- The Lion's Redoubt, Dread Wastes (A)
			[1070] = true,    -- Klaxxi'vess, Dread Wastes (N)
			[1071] = true,    -- Soggy's Gamble, Dread Wastes (N)
		},
		fishing_min = 625,
		battlepet_low = 24,
		battlepet_high = 25,
	}

	zones[BZ["Vale of Eternal Blossoms"]] = {
		low = 85,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Mogu'shan Palace"]] = true,
			[BZ["Siege of Orgrimmar"]] = true,
		},
		paths = {
			[BZ["Mogu'shan Palace"]] = true,
			[BZ["Kun-Lai Summit"]] = true,
			[BZ["Siege of Orgrimmar"]] = true,
			[BZ["Shrine of Two Moons"]] = true,
			[BZ["Shrine of Seven Stars"]] = true,
		},
		flightnodes = {
			[1057] = true,    -- Shrine of Seven Stars, Vale of Eternal Blossoms (A)
			[1058] = true,    -- Shrine of Two Moons, Vale of Eternal Blossoms (H)
			[1073] = true,    -- Serpent's Spine, Vale of Eternal Blossoms (N)
		},
		fishing_min = 825,
		battlepet_low = 23,
		battlepet_high = 25,
	}

	zones[BZ["Isle of Giants"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		flightnodes = {
			[1221] = true,    -- Beeble's Wreck, Isle Of Giants (A)
			[1222] = true,    -- Bozzle's Wreck, Isle Of Giants (H)
		},
		fishing_min = 750,
		battlepet_low = 23,
		battlepet_high = 25,
	}
	
	zones[BZ["Isle of Thunder"]] = {
		low = 85,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Throne of Thunder"]] = true,
		},
		paths = {
			[transports["ISLEOFTHUNDER_TOWNLONGSTEPPES_PORTAL"]] = true,
		},
		fishing_min = 750,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Timeless Isle"]] = {
		low = 85,
		high = 90,
		continent = Pandaria,
		paths = BZ["The Jade Forest"],
		flightnodes = {
			[1293] = true,    -- Tushui Landing, Timeless Isle (A)
			[1294] = true,    -- Huojin Landing, Timeless Isle (H)
		},		
		fishing_min = 825,
		battlepet_low = 25,
		battlepet_high = 25,
	}	
	
	
	-- Draenor cities, garrisons and zones -- 
	
	zones[BZ["Warspear"]] = {
		continent = Draenor,
		paths = {
			[BZ["Ashran"]] = true,
			[transports["WARSPEAR_ORGRIMMAR_PORTAL"]] = true,
			[transports["WARSPEAR_TANAANJUNGLE_PORTAL"]] = true,
		},
		faction = "Horde",
		type = "City",
        fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}

	zones[BZ["Stormshield"]] = {
		continent = Draenor,
		paths = {
			[BZ["Ashran"]] = true,
			[transports["STORMSHIELD_STORMWIND_PORTAL"]] = true,
			[transports["STORMSHIELD_TANAANJUNGLE_PORTAL"]] = true,
		},
		faction = "Alliance",
		type = "City",
        fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}
	
	-- Alliance garrison
	zones[BZ["Lunarfall"]] = {
        low = 90,
        high = 100,
        continent = Draenor,
        paths = {
            [BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"] = true,
			[transports["LUNARFALL_STORMSHIELD_PORTAL"]] = true,
        },
		flightnodes = {
			[1476] = true,    -- Lunarfall (Alliance), Shadowmoon Valley (A)
		},
        faction = "Alliance",
        fishing_min = 950,
		yards = 683.334,
		x_offset = 11696.5098,
		y_offset = 9101.3333,
		texture = "garrisonsmvalliance"
    }
	
	-- Horde garrison
	zones[BZ["Frostwall"]] = {
        low = 90,
        high = 100,
        continent = Draenor,
        paths = {
            [BZ["Frostfire Ridge"]] = true,
			[transports["FROSTWALL_WARSPEAR_PORTAL"]] = true,
        },
		flightnodes = {
			[1432] = true,    -- Frostwall Garrison, Frostfire Ridge (H)
		},
        faction = "Horde",
        fishing_min = 950,
		yards = 702.08,
		x_offset = 7356.9277,
		y_offset = 5378.4173,
		texture = "garrisonffhorde"
    }

	
	
	zones[BZ["Frostfire Ridge"]] = {
		low = 90,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Bloodmaul Slag Mines"]] = true,
		},
		paths = {
			[BZ["Gorgrond"]] = true,
			[BZ["Frostwall"]] = true,
		},
		flightnodes = {
			[1396] = true,    -- Darkspear's Edge, Frostfire Ridge (H)
			[1389] = true,    -- Bloodmaul Slag Mines, Frostfire Ridge (N)
			[1528] = true,    -- Iron Siegeworks, Frostfire Ridge (A)
			[1386] = true,    -- Wor'gol, Frostfire Ridge (H)
			[1390] = true,    -- Stonefang Outpost, Frostfire Ridge (H)
			[1559] = true,    -- Wolf's Stand, Frostfire Ridge (H)
			[1432] = true,    -- Frostwall Garrison, Frostfire Ridge (H)
			[1395] = true,    -- Thunder Pass, Frostfire Ridge (H)
			[1388] = true,    -- Throm'Var, Frostfire Ridge (H)
			[1387] = true,    -- Bladespire Citadel, Frostfire Ridge (H)
		},
		fishing_min = 950,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"] = {
		low = 90,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Shadowmoon Burial Grounds"]] = true,
		},
		paths = {
			[BZ["Talador"]] = true,
			[BZ["Spires of Arak"]] = true,
			[BZ["Tanaan Jungle"]] = true,
			[BZ["Lunarfall"]] = true,
		},
		flightnodes = {
			[1467] = true,    -- The Draakorium, Shadowmoon Valley (A)
			[1381] = true,    -- Embaari Village, Shadowmoon Valley (A)
			[1475] = true,    -- Socrethar's Rise, Shadowmoon Valley (N)
			[1569] = true,    -- Akeeta's Hovel, Shadowmoon Valley (N)
			[1468] = true,    -- Elodor (Alliance), Shadowmoon Valley (A)
			[1382] = true,    -- Twilight Glade, Shadowmoon Valley (A)
			[1476] = true,    -- Lunarfall (Alliance), Shadowmoon Valley (A)
			[1529] = true,    -- Darktide Roost, Shadowmoon Valley (N)
			[1383] = true,    -- Path of the Light, Shadowmoon Valley (A)
			[1567] = true,    -- Temple of Karabor, Shadowmoon Valley (A)
			[1556] = true,    -- Tranquil Court, Shadowmoon Valley (A)
			[1384] = true,    -- Exile's Rise, Shadowmoon Valley (N)
		},
		fishing_min = 950,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Gorgrond"]] = {
		low = 92,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Iron Docks"]] = true,
			[BZ["Grimrail Depot"]] = true,
			[BZ["The Everbloom"]] = true,
			[BZ["Blackrock Foundry"]] = true,
		},
		paths = {
			[BZ["Frostfire Ridge"]] = true,
			[BZ["Talador"]] = true,
			[BZ["Tanaan Jungle"]] = true,
		},
		flightnodes = {
			[1512] = true,    -- Bastion Rise, Gorgrond (H)
			[1580] = true,    -- Everbloom Overlook, Gorgrond (N)
			[1539] = true,    -- Skysea Ridge, Gorgrond (N)
			[1442] = true,    -- Beastwatch, Gorgrond (H)
			[1514] = true,    -- Evermorn Springs, Gorgrond (H)
			[1518] = true,    -- Wildwood Wash, Gorgrond (A)
			[1520] = true,    -- Breaker's Crown, Gorgrond (N)
			[1511] = true,    -- Bastion Rise, Gorgrond (A)
			[1524] = true,    -- Iron Docks, Gorgrond (N)
			[1519] = true,    -- Highpass, Gorgrond (A)
			[1523] = true,    -- Deeproot, Gorgrond (A)
			[1568] = true,    -- Everbloom Wilds, Gorgrond (N)
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}	
	
	zones[BZ["Talador"]] = {
		low = 94,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Auchindoun"]] = true,
		},
		paths = {
			[BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"] = true,
			[BZ["Gorgrond"]] = true,
			[BZ["Tanaan Jungle"]] = true,
			[BZ["Spires of Arak"]] = true,
			[BZ["Nagrand"].." ("..BZ["Draenor"]..")"] = true,
		},
		flightnodes = {
			[1452] = true,    -- Retribution Point, Talador (N)
			[1441] = true,    -- Frostwolf Overlook, Talador (H)
			[1445] = true,    -- Durotan's Grasp, Talador (H)
			[1453] = true,    -- Exarch's Refuge, Talador (A)
			[1450] = true,    -- Shattrath City, Talador (N)
			[1454] = true,    -- Exarch's Refuge, Talador (H)
			[1443] = true,    -- Vol'jin's Pride, Talador (H)
			[1447] = true,    -- Fort Wrynn (Alliance), Talador (A)
			[1451] = true,    -- Anchorite's Sojourn, Talador (A)
			[1440] = true,    -- Zangarra, Talador (N)
			[1448] = true,    -- Redemption Rise, Talador (A)
			[1462] = true,    -- Terokkar Refuge, Talador (N)
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}		
	
	zones[BZ["Spires of Arak"]] = {
		low = 96,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Skyreach"]] = true,
			[BZ["Blackrock Foundry"]] = true,
		},
		paths = {
			[BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"] = true,
			[BZ["Talador"]] = true,
		},
		flightnodes = {
			[1513] = true,    -- Apexis Excavation, Spires of Arak (N)
			[1510] = true,    -- Pinchwhistle Gearworks, Spires of Arak (N)
			[1493] = true,    -- Southport, Spires of Arak (A)
			[1515] = true,    -- Crow's Crook, Spires of Arak (N)
			[1487] = true,    -- Axefall, Spires of Arak (H)
			[1509] = true,    -- Talon Watch, Spires of Arak (N)
			[1508] = true,    -- Veil Terokk, Spires of Arak (N)
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}	
	
	zones[BZ["Nagrand"].." ("..BZ["Draenor"]..")"] = {
		low = 98,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Highmaul"]] = true,
			[BZ["Blackrock Foundry"]] = true,
		},
		paths = {
			[BZ["Talador"]] = true,
		},
		flightnodes = {
			[1572] = true,    -- Rilzit's Holdfast, Nagrand (N)
			[1505] = true,    -- Riverside Post, Nagrand (H)
			[1573] = true,    -- Nivek's Overlook, Nagrand (N)
			[1502] = true,    -- The Ring of Trials, Nagrand (N)
			[1506] = true,    -- Telaari Station, Nagrand (A)
			[1574] = true,    -- Joz's Rylaks, Nagrand (N)
			[1503] = true,    -- Throne of the Elements, Nagrand (N)
			[1507] = true,    -- Yrel's Watch, Nagrand (A)
			[1504] = true,    -- Wor'var, Nagrand (H)
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}

	zones[BZ["Tanaan Jungle"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Hellfire Citadel"].." ("..BZ["Draenor"]..")"] = true,
		},
		paths = {
			[BZ["Talador"]] = true,
			[BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"] = true,
			[BZ["Gorgrond"]] = true,
			[transports["TANAANJUNGLE_STORMSHIELD_PORTAL"]] = true,
			[transports["TANAANJUNGLE_WARSPEAR_PORTAL"]] = true,
		},
		flightnodes = {
			[1646] = true,    -- Vault of the Earth, Tanaan Jungle (N)
			[1643] = true,    -- Aktar's Post, Tanaan Jungle (N)
			[1647] = true,    -- Malo's Lookout, Tanaan Jungle (N)
			[1644] = true,    -- The Iron Front, Tanaan Jungle (H)
			[1620] = true,    -- Lion's Watch, Tanaan Jungle (A)
			[1645] = true,    -- The Iron Front, Tanaan Jungle (A)
			[1621] = true,    -- Vol'mar, Tanaan Jungle (H)
			[1648] = true,    -- Sha'naari Refuge, Tanaan Jungle (N)
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}	
	
	zones[BZ["Ashran"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		type = "PvP Zone",
		paths = {
			[BZ["Warspear"]] = true,
			[BZ["Stormshield"]] = true,
			[transports["WARSPEAR_ORGRIMMAR_PORTAL"]] = true,
			[transports["STORMSHIELD_STORMWIND_PORTAL"]] = true,
		},
		flightnodes = {
			[1420] = true,    -- Stormshield (Alliance), Ashran (A)
			[1408] = true,    -- Warspear, Ashran (H)
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}	
	
	
	
	-- The Broken Isles cities and zones

	zones[BZ["Dalaran"].." ("..BZ["Broken Isles"]..")"] = {
		continent = Broken_Isles,
		paths = {
			[BZ["The Violet Hold"].." ("..BZ["Broken Isles"]..")"] = true,
			[transports["DALARANBROKENISLES_STORMWIND_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_ORGRIMMAR_PORTAL"]] = true,
		},
		flightnodes = {
			[1774] = true,    -- Dalaran (N)
		},
		instances = {
			[BZ["The Violet Hold"].." ("..BZ["Broken Isles"]..")"] = true,
		},		
		faction = "Sanctuary",
		type = "City",
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}

	zones[BZ["Thunder Totem"]] = {
		continent = Broken_Isles,
		paths = {
			[BZ["Highmountain"]] = true,
			[BZ["Stormheim"]] = true,
		},
		flightnodes = {
			[1719] = true,    -- Thunder Totem, Highmountain (N)
		},
		faction = "Sanctuary",
		type = "City",
--		fishing_min = 950,  TODO: check for fishable waters
		battlepet_low = 25,
		battlepet_high = 25,
	}


	zones[BZ["Azsuna"]] = {
		low = 98,
		high = 110,
		continent = Broken_Isles,
		instances = {
			[BZ["Vault of the Wardens"]] = true,
			[BZ["Eye of Azshara"]] = true,
		},
		paths = {
			[BZ["Suramar"]] = true,
			[BZ["Val'sharah"]] = true,
			[transports["AZSUNA_STORMWIND_PORTAL"]] = true,
			[transports["AZSUNA_ORGRIMMAR_PORTAL"]] = true,
		},
		flightnodes = {
			[1861] = true,    -- Illidari Perch, Azsuna (N)
			[1633] = true,    -- Shackle's Den, Azsuna (N)
			[1622] = true,    -- Illidari Stand, Azsuna (N)
			[1615] = true,    -- Challiane's Terrace, Azsuna (N)
			[1859] = true,    -- Felblaze Ingress, Azsuna (N)
			[1837] = true,    -- Wardens' Redoubt, Azsuna (N)
			[1860] = true,    -- Watchers' Aerie, Azsuna (N)
			[1613] = true,    -- Azurewing Repose, Azsuna (N)
			[1870] = true,    -- Eye of Azshara, Azsuna (N)
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}
	
	zones[BZ["Val'sharah"]] = {
		low = 98,
		high = 110,
		continent = Broken_Isles,
		instances = {
			[BZ["Black Rook Hold"]] = true,
			[BZ["Darkheart Thicket"]] = true,
			[BZ["The Emerald Nightmare"]] = true,
		},
		paths = {
			[BZ["Suramar"]] = true,
			[BZ["Azsuna"]] = true,
			[BZ["Highmountain"]] = true,
		},
		flightnodes = {
			[1713] = true,    -- Bradensbrook, Val'sharah (N)
			[1885] = true,    -- Gloaming Reef, Val'sharah (N)
			[1764] = true,    -- Starsong Refuge, Val'sharah (N)
			[1766] = true,    -- Garden of the Moon, Val'sharah (N)
			[1673] = true,    -- Lorlathil, Val'sharah (N)
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}
	
	zones[BZ["Highmountain"]] = {
		low = 98,
		high = 110,
		continent = Broken_Isles,
		instances = {
			[BZ["Neltharion's Lair"]] = true,
		},
		paths = {
			[BZ["Suramar"]] = true,
			[BZ["Stormheim"]] = true,
			[BZ["Val'sharah"]] = true,
			[BZ["Trueshot Lodge"]] = true,
		},
		flightnodes = {
			[1767] = true,    -- Nesingwary, Highmountain (N)
			[1756] = true,    -- Shipwreck Cove, Highmountain (N)
			[1719] = true,    -- Thunder Totem, Highmountain (N)
			[1753] = true,    -- Skyhorn, Highmountain (N)
			[1761] = true,    -- Prepfoot, Highmountain (N)
			[1754] = true,    -- The Witchwood, Highmountain (N)
			[1758] = true,    -- Obsidian Overlook, Highmountain (N)
			[1777] = true,    -- Sylvan Falls, Highmountain (N)
			[1755] = true,    -- Felbane Camp, Highmountain (N)
			[1759] = true,    -- Ironhorn Enclave, Highmountain (N)
			[1778] = true,    -- Stonehoof Watch, Highmountain (N)
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}
	
	zones[BZ["Stormheim"]] = {
		low = 98,
		high = 110,
		continent = Broken_Isles,
		instances = {
			[BZ["Halls of Valor"]] = true,
			[BZ["Helmouth Cliffs"]] = true, 
		},
		paths = {
			[BZ["Suramar"]] = true,
			[BZ["Highmountain"]] = true,
		},
		flightnodes = {
			[1857] = true,    -- Stormtorn Foothills, Stormheim (N)
			[1741] = true,    -- Forsaken Foothold, Stormheim (H)
			[1745] = true,    -- Lorna's Watch, Stormheim (A)
			[1738] = true,    -- Cullen's Post, Stormheim (H)
			[1742] = true,    -- Valdisdall, Stormheim (N)
			[1855] = true,    -- Shield's Rest, Stormheim (N)
			[1739] = true,    -- Dreadwake's Landing, Stormheim (H)
			[1863] = true,    -- Hafr Fjall, Stormheim (N)
			[1747] = true,    -- Skyfire Triage Camp, Stormheim (A)
			[1744] = true,    -- Greywatch, Stormheim (A)
		},		
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}

	zones[BZ["Broken Shore"]] = {
		low = 110,
		high = 110,
		continent = Broken_Isles,
		instances = {
			[BZ["Cathedral of Eternal Night"]] = true,
		},
		flightnodes = {
			[1941] = true,    -- Deliverance Point, Broken Shore (N)
			[1942] = true,    -- Aalgen Point, Broken Shore (N)
			[1856] = true,    -- Vengeance Point, Broken Shore (N)
			[1906] = true,    -- The Fel Hammer, Broken Shore (N), Demon Hunter Class Order Hall
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}

	zones[BZ["Suramar"]] = {
		low = 110,
		high = 110,
		continent = Broken_Isles,
		instances = {
			[BZ["Court of Stars"]] = true,
			[BZ["The Arcway"]] = true,
			[BZ["The Nighthold"]] = true,		
		},
		paths = {
			[BZ["Broken Shore"]] = true,
			[BZ["Azsuna"]] = true,
			[BZ["Val'sharah"]] = true,
			[BZ["Highmountain"]] = true,
			[BZ["Stormheim"]] = true,
		},
		flightnodes = {
			[1879] = true,    -- Crimson Thicket, Suramar (N)
			[1880] = true,    -- Irongrove Retreat, Suramar (N)
			[1858] = true,    -- Meredil, Suramar (N)
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}
	
	-- Hunter class hall. This map is reported by C_Map as a zone, unclear why
	zones[BZ["Trueshot Lodge"]] = {
		continent = Broken_Isles,
		paths = {
			[BZ["Highmountain"]] = true,
		},
		faction = "Sanctuary",
	}

	
	-- Argus zones --
	
	zones[BZ["Krokuun"]] = {
		low = 110,
		high = 110,
		continent = Argus,
		flightnodes = {
			[1976] = true,    -- Destiny Point, Krokuun (N)
			[1967] = true,    -- Shattered Fields, Krokuun (N)
			[1928] = true,    -- Krokul Hovel, Krokuun (N)
		},
	}
	
	zones[BZ["Antoran Wastes"]] = {
		low = 110,
		high = 110,
		continent = Argus,
		flightnodes = {
			[1993] = true,    -- The Veiled Den, Antoran Wastes (N)
			[1988] = true,    -- Hope's Landing, Antoran Wastes (N)
	        [1992] = true,    -- Light's Purchase, Antoran Wastes (N)
		},		
	}
	
	zones[BZ["Mac'Aree"]] = {
		low = 110,
		high = 110,
		continent = Argus,
		instances = {
			[BZ["The Seat of the Triumvirate"]] = true,
		},
		flightnodes = {
			[2003] = true,    -- City Center, Mac'Aree (N)
			[1991] = true,    -- Prophet's Reflection, Mac'Aree (N)
			[1981] = true,    -- Shadowguard Incursion, Mac'Aree (N)
			[1978] = true,    -- Conservatory of the Arcane, Mac'Aree (N)
			[1982] = true,    -- Triumvirate's End, Mac'Aree (N)
		},
	}
	
	-- WoW BFA zones
	
	-- Zandalar cities and zones (Horde)
	
	zones[BZ["Dazar'alor"]] = {
		instances = {
			[BZ["The MOTHERLODE!!"]] = true,	
		},
		paths = {
			[BZ["Zuldazar"]] = true,
			[BZ["The MOTHERLODE!!"]] = true,
			[transports["ECHOISLES_ZULDAZAR_BOAT"]] = true,
			[transports["ZULDAZAR_ORGRIMMAR_PORTAL"]] = true,
			[transports["ZULDAZAR_THUNDERBLUFF_PORTAL"]] = true,
			[transports["ZULDAZAR_SILVERMOON_PORTAL"]] = true,
			[transports["ZULDAZAR_SILITHUS_PORTAL"]] = true,
		},	
		flightnodes = {
			[2061] = true,    -- The Sliver, Zuldazar (H)
			[1959] = true,    -- The Great Seal (H)
			[1957] = true,    -- Port of Zandalar, Zuldazar (H)
			[2381] = true,    -- The Mugambala, Zuldazar (H)
		},
		faction = "Horde",
		continent = Zandalar,
		type = "City",
	}
	
	zones[BZ["Nazmir"]] = {
		low = 110,
		high = 120,
		instances = {
			[BZ["The Underrot"]] = true,
			[BZ["Uldir"]] = true,
		},
		paths = {
			[BZ["Vol'dun"]] = true,
			[BZ["Zuldazar"]] = true,		
			[BZ["The Underrot"]] = true,
			[BZ["Uldir"]] = true,
		},	
		flightnodes = {
			[2161] = true,    -- Redfield's Watch, Nazmir (A)
			[2078] = true,    -- Fort Victory, Nazmir (A)
			[1955] = true,    -- Gloom Hollow, Nazmir (H)
			[2080] = true,    -- Grimwatt's Crash, Nazmir (A)
			[1956] = true,    -- Forlorn Ruins, Nazmir (H)
			[1953] = true,    -- Zul'jan, Nazmir (H)
			[1954] = true,    -- Zo'bal Ruins, Nazmir (H)
		},
		faction = "Horde",
		continent = Zandalar,
	}
	
	zones[BZ["Vol'dun"]] = {
		low = 110,
		high = 120,
		instances = {
			[BZ["Temple of Sethraliss"]] = true,
		},
		paths = {
			[BZ["Nazmir"]] = true,
			[BZ["Zuldazar"]] = true,		
			[BZ["Temple of Sethraliss"]] = true,
		},	
		flightnodes = {
			[2112] = true,    -- Vulture's Nest, Vol'dun (A)
			[2120] = true,    -- Tortaka Refuge, Vol'dun (N)
			[2162] = true,    -- Devoted Sanctuary, Vol'dun (N)
			[2143] = true,    -- Scorched Sands Outpost, Vol'dun (H)
			[2119] = true,    -- Sanctuary of the Devoted, Vol'dun (N)
			[2117] = true,    -- Vulpera Hideaway, Vol'dun (H)
			[2111] = true,    -- Vorrik's Sanctum, Vol'dun (H)
			[2118] = true,    -- Temple of Akunda, Vol'dun (H)
		},
		faction = "Horde",
		continent = Zandalar,
	}
	
	zones[BZ["Zuldazar"]] = {
		low = 110,
		high = 120,
		instances = {
			[BZ["The MOTHERLODE!!"]] = true,
			[BZ["Atal'Dazar"]] = true,
			[BZ["Kings' Rest"]] = true,
			[BZ["Battle of Dazar'alor"]] = true,	
		},
		paths = {
			[BZ["Dazar'alor"]] = true,
			[BZ["Nazmir"]] = true,
			[BZ["Vol'dun"]] = true,		
			[BZ["Atal'Dazar"]] = true,
			[BZ["Kings' Rest"]] = true,
			[BZ["Battle of Dazar'alor"]] = true,	
		},	
		flightnodes = {
			[1975] = true,    -- Zeb'ahari, Zuldazar (H)
			[2061] = true,    -- The Sliver, Zuldazar (H)
			[2009] = true,    -- Warport Rastari, Zuldazar (H)
			[2012] = true,    -- Xibala, Zuldazar (A)
			[2164] = true,    -- Isle of Fangs, Zuldazar (H)
			[2045] = true,    -- Garden of the Loa, Zuldazar (H)
			[2075] = true,    -- Seeker's Outpost, Zuldazar (N)
			[2145] = true,    -- Verdant Hollow, Zuldazar (A)
			[2147] = true,    -- Castaway Encampment, Zuldazar (A)
			[1959] = true,    -- The Great Seal (H)
			[2153] = true,    -- Mistvine Ledge, Zuldazar (A)
			[2126] = true,    -- Scaletrader Post, Zuldazar (N)
			[2066] = true,    -- Atal'Gral, Zuldazar (N)
			[2027] = true,    -- Temple of the Prophet, Zuldazar (H)
			[1966] = true,    -- Warbeast Kraal, Zuldazar (H)
			[2165] = true,    -- Tusk Isle, Zuldazar (H)
			[1965] = true,    -- Nesingwary's Gameland, Zuldazar (N)
			[2076] = true,    -- Atal'Gral, Zuldazar (N)
			[1957] = true,    -- Port of Zandalar, Zuldazar (H)
			[1974] = true,    -- Xibala, Zuldazar (H)
			[2071] = true,    -- Dreadpearl, Zuldazar (N)
			[2046] = true,    -- Atal'dazar, Zuldazar (H)
			[2148] = true,    -- Mugamba Overlook, Zuldazar (A)
			[2157] = true,    -- Veiled Grotto, Zuldazar (A)
		},
		faction = "Horde",
		continent = Zandalar,
	}
	
	-- Kul Tiras cities and zones (Alliance)
	
	zones[BZ["Boralus"]] = {
		paths = {
			[BZ["Tiragarde Sound"]] = true,
			[transports["STORMWIND_TIRAGARDESOUND_BOAT"]] = true,
			[transports["TIRAGARDESOUND_STORMWIND_PORTAL"]] = true,
			[transports["TIRAGARDESOUND_EXODAR_PORTAL"]] = true,
			[transports["TIRAGARDESOUND_IRONFORGE_PORTAL"]] = true,
			[transports["TIRAGARDESOUND_SILITHUS_PORTAL"]] = true,
		},	
		flightnodes = {
			[2083] = true,    -- Tradewinds Market, Tiragarde Sound (A)
			[2277] = true,    -- Proudmoore Keep, Tiragarde Sound (A)
			[2278] = true,    -- Mariner's Row, Tiragarde Sound (A)
		},
		faction = "Alliance",
		continent = Kul_Tiras,
		type = "City",
	}
	
	zones[BZ["Stormsong Valley"]] = {
		low = 110,
		high = 120,
		instances = {
			[BZ["Shrine of the Storm"]] = true,
			[BZ["Crucible of Storms"]] = true,
		},
		paths = {
			[BZ["Shrine of the Storm"]] = true,
			[BZ["Tiragarde Sound"]] = true,
			[BZ["Crucible of Storms"]] = true,
		},		
		flightnodes = {
			[2101] = true,    -- The Amber Waves, Stormsong Valley (A)
			[2094] = true,    -- Warfang Hold, Stormsong Valley (H)
			[2095] = true,    -- Shrine of the Storm, Stormsong Valley (H)
			[2088] = true,    -- Mildenhall Meadery, Stormsong Valley (A)
			[2089] = true,    -- Seekers Vista, Stormsong Valley (N)
			[2097] = true,    -- Deadwash, Stormsong Valley (A)
			[2093] = true,    -- Ironmaul Overlook, Stormsong Valley (H)
			[2092] = true,    -- Diretusk Hollow, Stormsong Valley (H)
			[2133] = true,    -- Shrine of the Storm, Stormsong Valley (A)
			[2137] = true,    -- Millstone Hamlet, Stormsong Valley (A)
			[2085] = true,    -- Tidecross, Stormsong Valley (A)
			[2138] = true,    -- Fort Daelin, Stormsong Valley (A)
			[2086] = true,    -- Brennadam, Stormsong Valley (A)
			[2139] = true,    -- Windfall Cavern, Stormsong Valley (H)
			[2090] = true,    -- Hillcrest Pasture, Stormsong Valley (H)
			[2091] = true,    -- Stonetusk Watch, Stormsong Valley (H)
		},
		faction = "Alliance",
		continent = Kul_Tiras,
	}	

	zones[BZ["Drustvar"]] = {
		low = 110,
		high = 120,	
		instances = {
			[BZ["Waycrest Manor"]] = true,
		},		
		paths = {
			[BZ["Tiragarde Sound"]] = true,
			[BZ["Waycrest Manor"]] = true,
		},		
		flightnodes = {
			[2037] = true,    -- Barbthorn Ridge, Drustvar (A)
			[2109] = true,    -- Whitegrove Chapel, Drustvar (N)
			[2034] = true,    -- Hangman's Point, Drustvar (A)
			[2127] = true,    -- Anyport, Drustvar (N)
			[2135] = true,    -- Krazzlefrazz Outpost, Drustvar (H)
			[2106] = true,    -- Arom's Stand, Drustvar (A)
			[2107] = true,    -- Watchman's Rise, Drustvar (A)
			[2033] = true,    -- Fallhaven, Drustvar (A)
			[2108] = true,    -- Falconhurst, Drustvar (A)
			[2035] = true,    -- Fletcher's Hollow, Drustvar (A)
			[2275] = true,    -- Mudfisher Cove, Drustvar (H)
			[2274] = true,    -- Swiftwind Post, Drustvar (H)
		},
		faction = "Alliance",
		continent = Kul_Tiras,
	}
	
	zones[BZ["Tiragarde Sound"]] = {
		low = 110,
		high = 120,
		instances = {
			[BZ["Tol Dagor"]] = true,
			[BZ["Freehold"]] = true,
			[BZ["Siege of Boralus"]] = true,
		},
		paths = {
			[BZ["Boralus"]] = true,
			[BZ["Drustvar"]] = true,
			[BZ["Stormsong Valley"]] = true,
			[BZ["Tol Dagor"]] = true,
			[BZ["Freehold"]] = true,
			[BZ["Siege of Boralus"]] = true,
		},		
		flightnodes = {
			[2079] = true,    -- Kennings Lodge, Tiragarde Sound (A)
			[2102] = true,    -- Roughneck Camp, Tiragarde Sound (A)
			[2096] = true,    -- Tol Dagor, Tiragarde Sound (A)
			[2023] = true,    -- Freehold, Tiragarde Sound (N)
			[2276] = true,    -- Tol Dagor, Tiragarde Sound (H)
			[2074] = true,    -- Bridgeport, Tiragarde Sound (A)
			[2277] = true,    -- Proudmoore Keep, Tiragarde Sound (A)
			[2060] = true,    -- Hatherford, Tiragarde Sound (A)
			[2278] = true,    -- Mariner's Row, Tiragarde Sound (A)
			[2087] = true,    -- Outrigger Post, Tiragarde Sound (A)
			[2084] = true,    -- Norwington Estate, Tiragarde Sound (A)
			[2077] = true,    -- Castaway Point, Tiragarde Sound (N)
			[2083] = true,    -- Tradewinds Market, Tiragarde Sound (A)
			[2273] = true,    -- Waning Glacier, Tiragarde Sound (H)
			[2042] = true,    -- Vigil Hill, Tiragarde Sound (A)
			[2279] = true,    -- Stonefist Watch, Tiragarde Sound (H)
			[2062] = true,    -- Wolf's Den, Tiragarde Sound (H)
			[2140] = true,    -- Plunder Harbour, Tiragarde Sound (H)
			[2067] = true,    -- Timberfell Outpost, Tiragarde Sound (H)
		},
		faction = "Alliance",
		continent = Kul_Tiras,
	}	
	
	
	
	
	-- Classic dungeons --
	
	zones[BZ["Ragefire Chasm"]] = {
		low = 15,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Orgrimmar"],
		groupSize = 5,
		faction = "Horde",
		type = "Instance",
		entrancePortal = { BZ["Orgrimmar"], 52.8, 49 },
	}
	
	zones[BZ["The Deadmines"]] = {
		low = 15,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Westfall"],
		groupSize = 5,
		faction = "Alliance",
		type = "Instance",
		fishing_min = 75,
		entrancePortal = { BZ["Westfall"], 42.6, 72.2 },
	}	
	
	zones[BZ["Shadowfang Keep"]] = {
		low = 17,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Silverpine Forest"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Silverpine Forest"], 44.80, 67.83 },
	}	
	
	zones[BZ["Wailing Caverns"]] = {
		low = 15,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Northern Barrens"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 75,
		entrancePortal = { BZ["Northern Barrens"], 42.1, 66.5 },
	}	
	
	zones[BZ["Blackfathom Deeps"]] = {
		low = 20,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Ashenvale"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 75,
		entrancePortal = { BZ["Ashenvale"], 14.6, 15.3 },
	}	
	
	zones[BZ["The Stockade"]] = {
		low = 20,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Stormwind City"],
		groupSize = 5,
		faction = "Alliance",
		type = "Instance",
		entrancePortal = { BZ["Stormwind City"], 50.5, 66.3 },
	}
	
	zones[BZ["Gnomeregan"]] = {
		low = 24,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Dun Morogh"],
		groupSize = 5,
		faction = "Alliance",
		type = "Instance",
		entrancePortal = { BZ["Dun Morogh"], 24, 38.9 },
	}	
	
	zones[BZ["Scarlet Halls"]] = {
		low = 26,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Tirisfal Glades"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Tirisfal Glades"], 84.9, 35.3 },
	}	
	
	zones[BZ["Scarlet Monastery"]] = {
		low = 28,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Tirisfal Glades"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Tirisfal Glades"], 85.3, 32.1 },
	}	

	zones[BZ["Razorfen Kraul"]] = {
		low = 30,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Southern Barrens"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Southern Barrens"], 40.8, 94.5 },
	}
	
	-- consists of The Wicked Grotto, Foulspore Cavern and Earth Song Falls
	zones[BZ["Maraudon"]] = {
		low = 30,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Desolace"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 300,
		entrancePortal = { BZ["Desolace"], 29, 62.4 },
	}	
	
	zones[BZ["Razorfen Downs"]] = {
		low = 35,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Thousand Needles"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Thousand Needles"], 47.5, 23.7 },
	}	
	
	zones[BZ["Uldaman"]] = {
		low = 35,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Badlands"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Badlands"], 42.4, 18.6 },
	}
	
	-- a.k.a. Warpwood Quarter
	zones[BZ["Dire Maul - East"]] = {
		low = 36,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Dire Maul"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Dire Maul"],
		entrancePortal = { BZ["Feralas"], 66.7, 34.8 },
	}	
	
	-- a.k.a. Capital Gardens
	zones[BZ["Dire Maul - West"]] = {
		low = 39,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Dire Maul"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Dire Maul"],
		entrancePortal = { BZ["Feralas"], 60.3, 30.6 },
	}

	-- a.k.a. Gordok Commons
	zones[BZ["Dire Maul - North"]] = {
		low = 42,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Dire Maul"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Dire Maul"],
		entrancePortal = { BZ["Feralas"], 62.5, 24.9 },
	}

	zones[BZ["Scholomance"]] = {
		low = 38,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Western Plaguelands"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 425,
		entrancePortal = { BZ["Western Plaguelands"], 69.4, 72.8 },
	}
	
	-- consists of Main Gate and Service Entrance
	zones[BZ["Stratholme"]] = {
		low = 42,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Eastern Plaguelands"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 425,
		entrancePortal = { BZ["Eastern Plaguelands"], 30.8, 14.4 },
	}	
	
	zones[BZ["Zul'Farrak"]] = {
		low = 44,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Tanaris"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Tanaris"], 36, 11.7 },
	}	
	
	-- consists of Detention Block and Upper City
	zones[BZ["Blackrock Depths"]] = {
		low = 47,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Molten Core"]] = true,
			[BZ["Blackrock Mountain"]] = true,
		},
		groupSize = 5,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Searing Gorge"], 35.4, 84.4 },
	}	
	
	-- a.k.a. Sunken Temple
	zones[BZ["The Temple of Atal'Hakkar"]] = {
		low = 50,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Swamp of Sorrows"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 300,
		entrancePortal = { BZ["Swamp of Sorrows"], 70, 54 },
	}	
	
	-- a.k.a. Lower Blackrock Spire
	zones[BZ["Blackrock Spire"]] = {
		low = 55,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Blackrock Mountain"]] = true,
			[BZ["Blackwing Lair"]] = true,
			[BZ["Blackwing Descent"]] = true,
		},
		groupSize = 5,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Burning Steppes"], 29.7, 37.5 },
	}

	
	
	-- Burning Crusade dungeons (Outland) --
	
	zones[BZ["Hellfire Ramparts"]] = {
		low = 58,
		high = 80,
		continent = Outland,
		paths = BZ["Hellfire Citadel"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Hellfire Citadel"],
		entrancePortal = { BZ["Hellfire Peninsula"], 46.8, 54.9 },
	}	

	zones[BZ["The Blood Furnace"]] = {
		low = 59,
		high = 80,
		continent = Outland,
		paths = BZ["Hellfire Citadel"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Hellfire Citadel"],
		entrancePortal = { BZ["Hellfire Peninsula"], 46.8, 54.9 },
	}
	
	zones[BZ["The Slave Pens"]] = {
		low = 60,
		high = 80,
		continent = Outland,
		paths = BZ["Coilfang Reservoir"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Coilfang Reservoir"],
		entrancePortal = { BZ["Zangarmarsh"], 50.2, 40.8 },
	}	
	
	zones[BZ["The Underbog"]] = {
		low = 61,
		high = 80,
		continent = Outland,
		paths = BZ["Coilfang Reservoir"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Coilfang Reservoir"],
		entrancePortal = { BZ["Zangarmarsh"], 50.2, 40.8 },
	}

	zones[BZ["Mana-Tombs"]] = {
		low = 62,
		high = 80,
		continent = Outland,
		paths = BZ["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Ring of Observance"],
		entrancePortal = { BZ["Terokkar Forest"], 39.6, 65.5 },
	}

	zones[BZ["Auchenai Crypts"]] = {
		low = 63,
		high = 80,
		continent = Outland,
		paths = BZ["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Ring of Observance"],
		entrancePortal = { BZ["Terokkar Forest"], 39.6, 65.5 },
	}
	
	-- a.k.a. The Escape from Durnhold Keep
	zones[BZ["Old Hillsbrad Foothills"]] = {
		low = 64,
		high = 80,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 26.7, 32.6 },
	}

	zones[BZ["Sethekk Halls"]] = {
		low = 65,
		high = 80,
		continent = Outland,
		paths = BZ["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Ring of Observance"],
		entrancePortal = { BZ["Terokkar Forest"], 39.6, 65.5 },
	}
	
	zones[BZ["Shadow Labyrinth"]] = {
		low = 67,
		high = 80,
		continent = Outland,
		paths = BZ["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Ring of Observance"],
		entrancePortal = { BZ["Terokkar Forest"], 39.6, 65.5 },
	}

	zones[BZ["The Shattered Halls"]] = {
		low = 67,
		high = 80,
		continent = Outland,
		paths = BZ["Hellfire Citadel"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Hellfire Citadel"],
		entrancePortal = { BZ["Hellfire Peninsula"], 46.8, 54.9 },
	}

	zones[BZ["The Steamvault"]] = {
		low = 67,
		high = 80,
		continent = Outland,
		paths = BZ["Coilfang Reservoir"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Coilfang Reservoir"],
		entrancePortal = { BZ["Zangarmarsh"], 50.2, 40.8 },
	}

	zones[BZ["The Mechanar"]] = {
		low = 67,
		high = 80,
		continent = Outland,
--		paths = BZ["Tempest Keep"],
		paths = BZ["Netherstorm"],
		groupSize = 5,
		type = "Instance",
--		complex = BZ["Tempest Keep"],
		entrancePortal = { BZ["Netherstorm"], 76.5, 65.1 },
	}

	zones[BZ["The Botanica"]] = {
		low = 67,
		high = 80,
		continent = Outland,
--		paths = BZ["Tempest Keep"],
		paths = BZ["Netherstorm"],
		groupSize = 5,
		type = "Instance",
--		complex = BZ["Tempest Keep"],
		entrancePortal = { BZ["Netherstorm"], 76.5, 65.1 },
	}
	
	zones[BZ["The Arcatraz"]] = {
		low = 68,
		high = 80,
		continent = Outland,
--		paths = BZ["Tempest Keep"],
		paths = BZ["Netherstorm"],
		groupSize = 5,
		type = "Instance",
--		complex = BZ["Tempest Keep"],
		entrancePortal = { BZ["Netherstorm"], 76.5, 65.1 },
	}
	
	
	-- Wrath of the Lich King dungeons (Northrend) --
	
	zones[BZ["Utgarde Keep"]] = {
		low = 58,
		high = 80,
		continent = Northrend,
		paths = BZ["Howling Fjord"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Howling Fjord"], 57.30, 46.84 },
	}	
	
	zones[BZ["The Nexus"]] = {
		low = 59,
		high = 80,
		continent = Northrend,
		paths = BZ["Coldarra"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Coldarra"],
		entrancePortal = { BZ["Borean Tundra"], 27.50, 26.03 },
	}	
	
	zones[BZ["Azjol-Nerub"]] = {
		low = 60,
		high = 80,
		continent = Northrend,
		paths = BZ["Dragonblight"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Dragonblight"], 26.01, 50.83 },
	}	
	
	zones[BZ["Ahn'kahet: The Old Kingdom"]] = {
		low = 61,
		high = 80,
		continent = Northrend,
		paths = BZ["Dragonblight"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Dragonblight"], 28.49, 51.73 },
	}	
	
	zones[BZ["Drak'Tharon Keep"]] = {
		low = 62,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Grizzly Hills"]] = true,
			[BZ["Zul'Drak"]] = true,
		},
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Zul'Drak"], 28.53, 86.93 },
	}	
	
	zones[BZ["The Violet Hold"]] = {
		low = 63,
		high = 80,
		continent = Northrend,
		paths = BZ["Dalaran"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Dalaran"], 66.78, 68.19 },
	}
	
	zones[BZ["Gundrak"]] = {
		low = 64,
		high = 80,
		continent = Northrend,
		paths = BZ["Zul'Drak"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 475,
		entrancePortal = { BZ["Zul'Drak"], 76.14, 21.00 },
	}	
	
	zones[BZ["Halls of Stone"]] = {
		low = 65,
		high = 80,
		continent = Northrend,
		paths = BZ["The Storm Peaks"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["The Storm Peaks"], 39.52, 26.91 },
	}	
	
	zones[BZ["Halls of Lightning"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = BZ["The Storm Peaks"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["The Storm Peaks"], 45.38, 21.37 },
	}	
	
	zones[BZ["The Oculus"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = BZ["Coldarra"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Coldarra"],
		entrancePortal = { BZ["Borean Tundra"], 27.52, 26.67 },
	}	
	
	zones[BZ["Utgarde Pinnacle"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = BZ["Howling Fjord"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Howling Fjord"], 57.25, 46.60 },
	}
	
	zones[BZ["The Culling of Stratholme"]] = {
		low = 68,
		high = 80,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 60.3, 82.8 },
	}	
	
	zones[BZ["Magisters' Terrace"]] = {
		low = 68,
		high = 80,
		continent = Eastern_Kingdoms,
		paths = BZ["Isle of Quel'Danas"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Isle of Quel'Danas"], 61.3, 30.9 },
	}
	
	-- a.k.a. The Opening of the Black Portal
	zones[BZ["The Black Morass"]] = {
		low = 68,
		high = 75,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 34.4, 84.9 },
	}	
	
	zones[BZ["Trial of the Champion"]] = {
		low = 68,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Icecrown"], 74.18, 20.45 },
	}	
	
	zones[BZ["The Forge of Souls"]] = {
		low = 70,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Icecrown"], 52.60, 89.35 },
	}	
	
	zones[BZ["Halls of Reflection"]] = {
		low = 70,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Icecrown"], 52.60, 89.35 },
	}	
	
	zones[BZ["Pit of Saron"]] = {
		low = 70,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 550,
		entrancePortal = { BZ["Icecrown"], 52.60, 89.35 },
	}	
	
	
	-- Cataclysm dungeons --
	
	zones[BZ["Blackrock Caverns"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Blackrock Mountain"]] = true,
		},
		groupSize = 5,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Searing Gorge"], 47.8, 69.1 },
	}	
	
	zones[BZ["Throne of the Tides"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		paths = BZ["Abyssal Depths"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Abyssal Depths"], 69.3, 25.2 },
	}	
	
	zones[BZ["The Stonecore"]] = {
		low = 81,
		high = 90,
		continent = The_Maelstrom,
		paths = BZ["Deepholm"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Deepholm"], 47.70, 51.96 },
	}	
	
	zones[BZ["The Vortex Pinnacle"]] = {
		low = 81,
		high = 90,
		continent = Kalimdor,
		paths = BZ["Uldum"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Uldum"], 76.79, 84.51 },
	}
	
	zones[BZ["Lost City of the Tol'vir"]] = {
		low = 84,
		high = 90,
		continent = Kalimdor,
		paths = BZ["Uldum"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Uldum"], 60.53, 64.24 },
	}
	
	zones[BZ["Grim Batol"]] = {
		low = 84,
		high = 90,
		continent = Eastern_Kingdoms,
		paths = BZ["Twilight Highlands"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Twilight Highlands"], 19, 53.5 },
	}	
	
	-- TODO: confirm level range
	zones[BZ["Halls of Origination"]] = {
		low = 85,
		high = 85,
		continent = Kalimdor,
		paths = BZ["Uldum"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Uldum"], 69.09, 52.95 },
	}
	
	-- TODO: confirm level range
	zones[BZ["End Time"]] = {
		low = 84,
		high = 90,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 57.1, 25.7 },
	}

	-- TODO: confirm level range
	zones[BZ["Hour of Twilight"]] = {
		low = 84,
		high = 90,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 67.9, 29.0 },
	}

	-- TODO: confirm level range
	zones[BZ["Well of Eternity"]] = {
		low = 84,
		high = 90,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 22.2, 63.6 },
	}
	
	-- Note: before Cataclysm, this was a lvl 70 10-man raid
	zones[BZ["Zul'Aman"]] = {
		low = 85,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = BZ["Ghostlands"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Ghostlands"], 77.7, 63.2 },
		fishing_min = 425,
	}	

	-- Note: before Cataclysm, this was a lvl 60 20-man raid
	zones[BZ["Zul'Gurub"]] = {
		low = 85,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = BZ["Northern Stranglethorn"],
		groupSize = 5,
		type = "Instance",
--		fishing_min = 330,
		entrancePortal = { BZ["Northern Stranglethorn"], 52.2, 17.1 },
	}


	
	-- Mists of Pandaria dungeons --
	
	zones[BZ["Temple of the Jade Serpent"]] = {
		low = 80,
		high = 90,
		continent = Pandaria,
		paths = BZ["The Jade Forest"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["The Jade Forest"], 56.20, 57.90 },
	}	
	
	zones[BZ["Stormstout Brewery"]] = {
		low = 80,
		high = 90,
		continent = Pandaria,
		paths = BZ["Valley of the Four Winds"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Valley of the Four Winds"], 36.10, 69.10 }, 
	}	
	
	zones[BZ["Shado-Pan Monastery"]] = {
		low = 82,
		high = 90,
		continent = Pandaria,
		paths = BZ["Kun-Lai Summit"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Kun-Lai Summit"], 36.7, 47.6 },  
	}	
	
	zones[BZ["Mogu'shan Palace"]] = {
		low = 82,
		high = 90,
		continent = Pandaria,
		paths = BZ["Vale of Eternal Blossoms"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Vale of Eternal Blossoms"], 80.7, 33.0 }, 
	}	
	
	zones[BZ["Gate of the Setting Sun"]] = {
		low = 83,
		high = 90,
		continent = Pandaria,
		paths = BZ["Dread Wastes"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Dread Wastes"], 15.80, 74.30 }, 
	}	
	
	zones[BZ["Siege of Niuzao Temple"]] = {
		low = 83,
		high = 90,
		continent = Pandaria,
		paths = BZ["Townlong Steppes"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Townlong Steppes"], 34.5, 81.1 },
	}	
	


	-- Warlords of Draenor dungeons --

	zones[BZ["Bloodmaul Slag Mines"]] = {
		low = 90,
		high = 100,
		continent = Draenor,
		paths = BZ["Forstfire Ridge"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Forstfire Ridge"], 50.0, 24.8 }, 
	}
	
	zones[BZ["Iron Docks"]] = {
		low = 92,
		high = 100,
		continent = Draenor,
		paths = BZ["Gorgrond"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Gorgrond"], 45.2, 13.7 },
	}		
	
	zones[BZ["Auchindoun"]] = {
		low = 94,
		high = 100,
		continent = Draenor,
		paths = BZ["Talador"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Talador"], 43.6, 74.1 },
	}	
	
	zones[BZ["Skyreach"]] = {
		low = 97,
		high = 100,
		continent = Draenor,
		paths = BZ["Spires of Arak"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Spires of Arak"], 35.6, 33.5 }, 
	}

	zones[BZ["Shadowmoon Burial Grounds"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")",
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")", 31.9, 42.5 },
	}
	
	zones[BZ["Grimrail Depot"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Gorgrond"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Gorgrond"], 55.2, 32.1 },
	}	
	
	zones[BZ["The Everbloom"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Gorgrond"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Gorgrond"], 59.5, 45.3 },
	}

	zones[BZ["Upper Blackrock Spire"]] = {
		low = 100,
		high = 100,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Blackrock Mountain"]] = true,
		},
		groupSize = 5,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Burning Steppes"], 29.7, 37.5 },
	}
	
	
	-- Legion dungeons --
	
	zones[BZ["Eye of Azshara"]] = {
		low = 98,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Aszuna"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Aszuna"], 67.1, 41.1 }, 
	}

	zones[BZ["Darkheart Thicket"]] = {
		low = 98,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Val'sharah"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Val'sharah"], 59.2, 31.5 }, 
	}

	zones[BZ["Neltharion's Lair"]] = {
		low = 98,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Highmountain"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Highmountain"], 49.9, 63.6 }, 
	}

	zones[BZ["Halls of Valor"]] = {
		low = 98,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Stormheim"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Stormheim"], 68.3, 66.2 }, 
	}	

	zones[BZ["The Violet Hold"].." ("..BZ["Broken Isles"]..")"] = {
		low = 105,
		high = 110,
		continent = Broken_Isles,
		paths = {
			[BZ["Dalaran"].." ("..BZ["Broken Isles"]..")"] = true,
		},
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", 66.78, 68.19 },
	}
	
	zones[BZ["Helmouth Cliffs"]] = {
		low = 110,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Stormheim"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Stormheim"], 53.0, 47.2 }, 
	}	
	
	zones[BZ["Court of Stars"]] = {
		low = 110,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Suramar"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Suramar"], 50.7, 65.5 }, 
	}		
	
	zones[BZ["The Arcway"]] = {
		low = 110,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Suramar"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Suramar"], 43, 62 }, 
	}		
	
	zones[BZ["Cathedral of Eternal Night"]] = {
		low = 110,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Broken Shore"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Broken Shore"], 63, 18 },
	}	
	
	zones[BZ["The Seat of the Triumvirate"]] = {
		low = 110,
		high = 110,
		continent = Argus,
		paths = BZ["Mac'Aree"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Mac'Aree"], 22.3, 56.1 }, 
	}	

	zones[BZ["Black Rook Hold"]] = {
		low = 110,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Val'sharah"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Val'sharah"], 38.7, 53.2 }, 
	}	
	
	zones[BZ["Vault of the Wardens"]] = {
		low = 110,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Aszuna"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Aszuna"], 48.2, 82.7 }, 
	}	
	
	
	
	-- WoW BFA dungeons
	-- Alliance
	
	zones[BZ["Shrine of the Storm"]] = {
		low = GetBFAInstanceLow(110, "Alliance"),
		high = 120,
		continent = Kul_Tiras,
		paths = BZ["Stormsong Valley"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Stormsong Valley"], 78.8, 26.6 },
	}

	zones[BZ["Waycrest Manor"]] = {
		low = GetBFAInstanceLow(110, "Alliance"),
		high = 120,
		continent = Kul_Tiras,
		paths = BZ["Drustvar"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Drustvar"], 33.7, 12.7 }, 
	}		
	
	zones[BZ["Freehold"]] = {
		low = GetBFAInstanceLow(110, "Alliance"),
		high = 120,
		continent = Kul_Tiras,
		paths = BZ["Tiragarde Sound"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Tiragarde Sound"], 84.7, 78.7 }, 
	}		
	
	zones[BZ["Tol Dagor"]] = {
		low = GetBFAInstanceLow(115, "Alliance"),
		high = 120,
		continent = Kul_Tiras,
		paths = BZ["Tiragarde Sound"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Tiragarde Sound"], 99.1, 47.3 }, 
	}		
	
	zones[BZ["Siege of Boralus"]] = {
		low = 120,
		high = 120,
		continent = Kul_Tiras,
		paths = BZ["Tiragarde Sound"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = GetSiegeOfBoralusEntrance(),
	}
	
	-- Patch 8.1.5 raid
	
	zones[BZ["Crucible of Storms"]] = {
		low = 120,
		high = 120,
		continent = Kul_Tiras,
		paths = BZ["Stormsong Valley"],
		groupSize = 10,
		altGroupSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Stormsong Valley"], 84.0, 46.4 }, 
	}	
	
	
	-- Horde

	zones[BZ["Atal'Dazar"]] = {
		low = GetBFAInstanceLow(110, "Horde"),
		high = 120,
		continent = Zandalar,
		paths = BZ["Zuldazar"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Zuldazar"], 43.6, 39.4 }, 
	}	
	
	zones[BZ["Temple of Sethraliss"]] = {
		low = GetBFAInstanceLow(110, "Horde"),
		high = 120,
		continent = Zandalar,
		paths = BZ["Vol'dun"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Vol'dun"], 51.9, 25.1 }, 
	}		

	zones[BZ["The Underrot"]] = {
		low = GetBFAInstanceLow(110, "Horde"),
		high = 120,
		continent = Zandalar,
		paths = BZ["Nazmir"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Nazmir"], 51.9, 65.8 }, 
	}	

	zones[BZ["The MOTHERLODE!!"]] = {
		low = GetBFAInstanceLow(115, "Horde"),
		high = 120,
		continent = Zandalar,
		paths = BZ["Dazar'alor"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = GetTheMotherlodeEntrance(), 
	}	
	
	zones[BZ["Kings' Rest"]] = {
		low = 120,
		high = 120,
		continent = Zandalar,
		paths = BZ["Zuldazar"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Zuldazar"], 37.9, 39.5 }, 
	}


	-- Patch 8.1 raids
	zones[BZ["Battle of Dazar'alor"]] = {
		low = 120,
		high = 120,
		continent = Zandalar,
		paths = BZ["Zuldazar"],
		groupSize = 10,
		altGroupSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Zuldazar"], 54.3, 29.9 },
	}

	zones[BZ["Uldir"]] = {
		low = 120,
		high = 120,
		continent = Zandalar,
		paths = BZ["Nazmir"],
		groupSize = 10,
		altGroupSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Nazmir"], 53.9, 62.7 }, 
	}


	

	
	-- Raids --
	
	zones[BZ["Blackwing Lair"]] = {
		low = 60,
		high = 62,
		continent = Eastern_Kingdoms,
		paths = BZ["Blackrock Mountain"],
		groupSize = 40,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Burning Steppes"], 29.7, 37.5 },
	}

	zones[BZ["Molten Core"]] = {
		low = 60,
		high = 62,
		continent = Eastern_Kingdoms,
		paths = BZ["Blackrock Mountain"],
		groupSize = 40,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		fishing_min = 1,  -- lava
		entrancePortal = { BZ["Searing Gorge"], 35.4, 84.4 },
	}

	zones[BZ["Ahn'Qiraj"]] = {
		low = 60,
		high = 63,
		continent = Kalimdor,
		paths = BZ["Ahn'Qiraj: The Fallen Kingdom"],
		groupSize = 40,
		type = "Instance",
		complex = BZ["Ahn'Qiraj: The Fallen Kingdom"],
		entrancePortal = { BZ["Ahn'Qiraj: The Fallen Kingdom"], 46.6, 7.4 },
	}
	
	zones[BZ["Ruins of Ahn'Qiraj"]] = {
		low = 60,
		high = 63,
		continent = Kalimdor,
		paths = BZ["Ahn'Qiraj: The Fallen Kingdom"],
		groupSize = 20,
		type = "Instance",
		complex = BZ["Ahn'Qiraj: The Fallen Kingdom"],
		entrancePortal = { BZ["Ahn'Qiraj: The Fallen Kingdom"], 58.9, 14.3 },
	}	
	
	
	zones[BZ["Karazhan"]] = {
		low = 70,
		high = 72,
		continent = Eastern_Kingdoms,
		paths = BZ["Deadwind Pass"],
		groupSize = 10,
		type = "Instance",
		entrancePortal = { BZ["Deadwind Pass"], 40.9, 73.2 },
	}	
	
	-- a.k.a. The Battle for Mount Hyjal
	zones[BZ["Hyjal Summit"]] = {
		low = 70,
		high = 72,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 25,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 38.8, 16.6 },
	}

	zones[BZ["Black Temple"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = BZ["Shadowmoon Valley"],
		groupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Shadowmoon Valley"], 77.7, 43.7 },
	}

	zones[BZ["Magtheridon's Lair"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = BZ["Hellfire Citadel"],
		groupSize = 25,
		type = "Instance",
		complex = BZ["Hellfire Citadel"],
		entrancePortal = { BZ["Hellfire Peninsula"], 46.8, 54.9 },
	}

	zones[BZ["Serpentshrine Cavern"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = BZ["Coilfang Reservoir"],
		groupSize = 25,
		type = "Instance",
		complex = BZ["Coilfang Reservoir"],
		entrancePortal = { BZ["Zangarmarsh"], 50.2, 40.8 },
	}

	zones[BZ["Gruul's Lair"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = BZ["Blade's Edge Mountains"],
		groupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Blade's Edge Mountains"], 68, 24 },
	}

	zones[BZ["Tempest Keep"]] = {
		low = 70,
		high = 72,
		continent = Outland,
--		paths = BZ["Tempest Keep"],
		paths = BZ["Netherstorm"],
		groupSize = 25,
		type = "Instance",
--		complex = BZ["Tempest Keep"],
		entrancePortal = { BZ["Netherstorm"], 76.5, 65.1 },
	}
	
	zones[BZ["Sunwell Plateau"]] = {
		low = 70,
		high = 72,
		continent = Eastern_Kingdoms,
		paths = BZ["Isle of Quel'Danas"],
		groupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Isle of Quel'Danas"], 44.3, 45.7 },
	}


	zones[BZ["The Eye of Eternity"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Coldarra"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		complex = BZ["Coldarra"],
		entrancePortal = { BZ["Borean Tundra"], 27.54, 26.68 },
	}
	
	zones[BZ["Onyxia's Lair"]] = {
		low = 80,
		high = 80,
		continent = Kalimdor,
		paths = BZ["Dustwallow Marsh"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Dustwallow Marsh"], 52, 76 },
	}	

	zones[BZ["Naxxramas"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Dragonblight"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		fishing_min = 1,  -- acid
		entrancePortal = { BZ["Dragonblight"], 87.30, 51.00 },
	}

	zones[BZ["The Obsidian Sanctum"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Dragonblight"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		fishing_min = 1,  -- lava
		entrancePortal = { BZ["Dragonblight"], 60.00, 57.00 },
	}	
	
	zones[BZ["Ulduar"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["The Storm Peaks"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["The Storm Peaks"], 41.56, 17.76 },
		fishing_min = 550,
	}

	zones[BZ["Trial of the Crusader"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Icecrown"], 75.07, 21.80 },
	}

	zones[BZ["Icecrown Citadel"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Icecrown"], 53.86, 87.27 },
	}

	zones[BZ["Vault of Archavon"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Wintergrasp"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Wintergrasp"], 50, 11.2 },
	}

	zones[BZ["The Ruby Sanctum"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Dragonblight"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		fishing_min = 650,
		entrancePortal = { BZ["Dragonblight"], 61.00, 53.00 },
	}	
	

	zones[BZ["Firelands"]] = {
		low = 85,
		high = 85,
		continent = Kalimdor,
		paths = BZ["Mount Hyjal"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Mount Hyjal"], 47.3, 78.3 },
	}
	
	zones[BZ["Throne of the Four Winds"]] = {
		low = 85,
		high = 85,
		continent = Kalimdor,
		paths = BZ["Uldum"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Uldum"], 38.26, 80.66 },
	}	

	zones[BZ["Blackwing Descent"]] = {
		low = 85,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Burning Steppes"]] = true,
			[BZ["Blackrock Mountain"]] = true,
			[BZ["Blackrock Spire"]] = true,
		},
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Burning Steppes"], 26.1, 24.6 },
	}
	
	zones[BZ["The Bastion of Twilight"]] = {
		low = 85,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = BZ["Twilight Highlands"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Twilight Highlands"], 33.8, 78.2 },
	}	
	
	zones[BZ["Dragon Soul"]] = {
		low = 85,
		high = 85,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 60.0, 21.1 },
	}	


	zones[BZ["Mogu'shan Vaults"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		paths = BZ["Kun-Lai Summit"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Kun-Lai Summit"], 59.1, 39.8 }, 
	}

	zones[BZ["Heart of Fear"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		paths = BZ["Dread Wastes"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Dread Wastes"], 39.0, 35.0 }, 
	}

	zones[BZ["Terrace of Endless Spring"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		paths = BZ["The Veiled Stair"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["The Veiled Stair"], 47.9, 60.8 }, 
	}

	zones[BZ["Throne of Thunder"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		paths = BZ["Isle of Thunder"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["The Veiled Stair"], 63.5, 32.2 }, 
	}

	zones[BZ["Siege of Orgrimmar"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		paths = BZ["Vale of Eternal Blossoms"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Vale of Eternal Blossoms"], 74.0, 42.2 },
	}
	
	
	
	zones[BZ["Blackrock Foundry"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Gorgrond"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Gorgrond"], 51.5, 27.4 },
	}	
	
	zones[BZ["Highmaul"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Nagrand"].." ("..BZ["Draenor"]..")",
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Nagrand"].." ("..BZ["Draenor"]..")", 34, 38 },
	}
	
	zones[BZ["Hellfire Citadel"].." ("..BZ["Draenor"]..")"] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Tanaan Jungle"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Tanaan Jungle"], 45, 53 },
	}

	zones[BZ["The Emerald Nightmare"]] = {
		low = 110,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Val'sharah"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Val'sharah"], 57.1, 39.9 }, 
	}
	
	zones[BZ["The Nighthold"]] = {
		low = 110,
		high = 110,
		continent = Broken_Isles,
		paths = BZ["Suramar"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Suramar"], 43, 62 }, 
	}
	
	zones[BZ["Antorus, the Burning Throne"]] = {
		low = 110,
		high = 110,
		continent = Argus,
		paths = BZ["Antoran Wastes"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		--entrancePortal = { BZ["Antoran Wastes"], 0, 0 }, TODO
	}

	
	
	-- Battlegrounds --
	
	zones[BZ["Arathi Basin"]] = {
		low = 10,
		high = MAX_PLAYER_LEVEL,
		continent = Eastern_Kingdoms,
		paths = BZ["Arathi Highlands"],
		groupSize = 15,
		type = "Battleground",
		texture = "ArathiBasin",
	}

	zones[BZ["Warsong Gulch"]] = {
		low = 10,
		high = MAX_PLAYER_LEVEL,
		continent = Kalimdor,
		paths = isHorde and BZ["Northern Barrens"] or BZ["Ashenvale"],
		groupSize = 10,
		type = "Battleground",
		texture = "WarsongGulch",
	}	

	zones[BZ["Eye of the Storm"]] = {
		low = 35,
		high = MAX_PLAYER_LEVEL,
		continent = Outland,
		groupSize = 15,
		type = "Battleground",
		texture = "NetherstormArena",
	}
	
	zones[BZ["Alterac Valley"]] = {
		low = 45,
		high = MAX_PLAYER_LEVEL,
		continent = Eastern_Kingdoms,
		paths = BZ["Hillsbrad Foothills"],
		groupSize = 40,
		type = "Battleground",
		texture = "AlteracValley",
	}	
	
	zones[BZ["Strand of the Ancients"]] = {
		low = 65,
		high = MAX_PLAYER_LEVEL,
		continent = Northrend,
		groupSize = 15,
		type = "Battleground",
		texture = "StrandoftheAncients",
	}

	zones[BZ["Isle of Conquest"]] = {
		low = 75,
		high = MAX_PLAYER_LEVEL,
		continent = Northrend,
		groupSize = 40,
		type = "Battleground",
		texture = "IsleofConquest",
	}

	zones[BZ["The Battle for Gilneas"]] = {
		low = 85,
		high = MAX_PLAYER_LEVEL,
		continent = Eastern_Kingdoms,
		groupSize = 10,
		type = "Battleground",
		texture = "TheBattleforGilneas",
	}

	zones[BZ["Twin Peaks"]] = {
		low = 85,
		high = MAX_PLAYER_LEVEL,
		continent = Eastern_Kingdoms,
		paths = BZ["Twilight Highlands"],
		groupSize = 10,
		type = "Battleground",
		texture = "TwinPeaks",  -- TODO: verify
	}
	
	zones[BZ["Deepwind Gorge"]] = {
		low = 90,
		high = MAX_PLAYER_LEVEL,
		continent = Pandaria,
		paths = BZ["Valley of the Four Winds"],
		groupSize = 15,
		type = "Battleground",
		texture = "DeepwindGorge",  -- TODO: verify
	}


	-- Arenas --
	
	zones[BZ["Blade's Edge Arena"]] = {
		low = 70,
		high = 70,
		continent = Outland,
		type = "Arena",
	}

	zones[BZ["Nagrand Arena"]] = {
		low = 70,
		high = 70,
		continent = Outland,
		type = "Arena",
	}

	zones[BZ["Ruins of Lordaeron"]] = {
		low = 70,
		high = 70,
		continent = Kalimdor,
		type = "Arena",
	}	
	
	zones[BZ["Dalaran Arena"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		type = "Arena",
	}

	zones[BZ["The Ring of Valor"]] = {
		low = 80,
		high = 80,
		continent = Kalimdor,
		type = "Arena",
	}

	zones[BZ["The Tiger's Peak"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		type = "Arena",
	}
	
	
	
	-- Complexes --

	zones[BZ["Dire Maul"]] = {
		low = 36,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Dire Maul - East"]] = true,
			[BZ["Dire Maul - North"]] = true,
			[BZ["Dire Maul - West"]] = true,
		},
		paths = {
			[BZ["Feralas"]] = true,
			[BZ["Dire Maul - East"]] = true,
			[BZ["Dire Maul - North"]] = true,
			[BZ["Dire Maul - West"]] = true,
		},
		type = "Complex",
	}	
	
	zones[BZ["Blackrock Mountain"]] = {
		low = 47,
		high = 100,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Blackrock Depths"]] = true,
			[BZ["Blackrock Caverns"]] = true,
			[BZ["Blackwing Lair"]] = true,
			[BZ["Blackwing Descent"]] = true,
			[BZ["Molten Core"]] = true,
			[BZ["Blackrock Spire"]] = true,
			[BZ["Upper Blackrock Spire"]] = true,
		},
		paths = {
			[BZ["Burning Steppes"]] = true,
			[BZ["Searing Gorge"]] = true,
			[BZ["Blackwing Lair"]] = true,
			[BZ["Blackwing Descent"]] = true,
			[BZ["Molten Core"]] = true,
			[BZ["Blackrock Depths"]] = true,
			[BZ["Blackrock Caverns"]] = true,
			[BZ["Blackrock Spire"]] = true,
			[BZ["Upper Blackrock Spire"]] = true,
		},
		type = "Complex",
		fishing_min = 1, -- lava
	}

	zones[BZ["Hellfire Citadel"]] = {
		low = 58,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["The Blood Furnace"]] = true,
			[BZ["Hellfire Ramparts"]] = true,
			[BZ["Magtheridon's Lair"]] = true,
			[BZ["The Shattered Halls"]] = true,
		},
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
			[BZ["The Blood Furnace"]] = true,
			[BZ["Hellfire Ramparts"]] = true,
			[BZ["Magtheridon's Lair"]] = true,
			[BZ["The Shattered Halls"]] = true,
		},
		type = "Complex",
	}

	zones[BZ["Coldarra"]] = {
		low = 59,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Borean Tundra"]] = true,
			[BZ["The Nexus"]] = true,
			[BZ["The Oculus"]] = true,
			[BZ["The Eye of Eternity"]] = true,
		},
		instances = {
			[BZ["The Nexus"]] = true,
			[BZ["The Oculus"]] = true,
			[BZ["The Eye of Eternity"]] = true,
		},
		type = "Complex",
	}
	
	zones[BZ["Coilfang Reservoir"]] = {
		low = 60,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["The Underbog"]] = true,
			[BZ["Serpentshrine Cavern"]] = true,
			[BZ["The Steamvault"]] = true,
			[BZ["The Slave Pens"]] = true,
		},
		paths = {
			[BZ["Zangarmarsh"]] = true,
			[BZ["The Underbog"]] = true,
			[BZ["Serpentshrine Cavern"]] = true,
			[BZ["The Steamvault"]] = true,
			[BZ["The Slave Pens"]] = true,
		},
		fishing_min = 400,
		type = "Complex",
	}
	
	zones[BZ["Ahn'Qiraj: The Fallen Kingdom"]] = {
		low = 60,
		high = 63,
		continent = Kalimdor,
		paths = {
			[BZ["Silithus"]] = true,
		},
		instances = {
			[BZ["Ahn'Qiraj"]] = true,
			[BZ["Ruins of Ahn'Qiraj"]] = true,
		},
		type = "Complex",
		battlepet_low = 16,
		battlepet_high = 17,
	}
	
	zones[BZ["Ring of Observance"]] = {
		low = 62,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["Mana-Tombs"]] = true,
			[BZ["Sethekk Halls"]] = true,
			[BZ["Shadow Labyrinth"]] = true,
			[BZ["Auchenai Crypts"]] = true,
		},
		paths = {
			[BZ["Terokkar Forest"]] = true,
			[BZ["Mana-Tombs"]] = true,
			[BZ["Sethekk Halls"]] = true,
			[BZ["Shadow Labyrinth"]] = true,
			[BZ["Auchenai Crypts"]] = true,
		},
		type = "Complex",
	}

	zones[BZ["Caverns of Time"]] = {
		low = 64,
		high = 90,
		continent = Kalimdor,
		instances = {
			[BZ["Old Hillsbrad Foothills"]] = true,
			[BZ["The Black Morass"]] = true,
			[BZ["Hyjal Summit"]] = true,
			[BZ["The Culling of Stratholme"]] = true,
			[BZ["End Time"]] = true,
			[BZ["Hour of Twilight"]] = true,
			[BZ["Well of Eternity"]] = true,
			[BZ["Dragon Soul"]] = true,
		},
		paths = {
			[BZ["Tanaris"]] = true,
			[BZ["Old Hillsbrad Foothills"]] = true,
			[BZ["The Black Morass"]] = true,
			[BZ["Hyjal Summit"]] = true,
			[BZ["The Culling of Stratholme"]] = true,
		},
		type = "Complex",
	}
	
	
	-- Had to remove the complex 'Tempest Keep' because of the renamed 'The Eye' instance now has same name (Legion)
	-- zones[BZ["Tempest Keep"]] = {
		-- low = 67,
		-- high = 75,
		-- continent = Outland,
		-- instances = {
			-- [BZ["The Mechanar"]] = true,
			-- [BZ["Tempest Keep"]] = true,  -- previously "The Eye"
			-- [BZ["The Botanica"]] = true,
			-- [BZ["The Arcatraz"]] = true,
		-- },
		-- paths = {
			-- [BZ["Netherstorm"]] = true,
			-- [BZ["The Mechanar"]] = true,
			-- [BZ["Tempest Keep"]] = true,
			-- [BZ["The Botanica"]] = true,
			-- [BZ["The Arcatraz"]] = true,
		-- },
		-- type = "Complex",
	-- }

	

	
--------------------------------------------------------------------------------------------------------
--                                                CORE                                                --
--------------------------------------------------------------------------------------------------------

	trace("Tourist: Initializing continents...")
	local continentNames = Tourist:GetMapContinentsAlt()
	local counter = 0

	for continentMapID, continentName in pairs(continentNames) do
		--trace("Processing Continent "..tostring(continentMapID)..": "..continentName.."...")
		
		if zones[continentName] then
			-- Set MapID
			zones[continentName].zoneMapID = continentMapID
			-- Get map art ID			
			zones[continentName].texture = C_Map.GetMapArtID(continentMapID)
			-- Get map size in yards
			local cWidth = HBD:GetZoneSize(continentMapID)
			if not cWidth then
				trace("|r|cffff4422! -- Tourist:|r No size data for "..tostring(continentName))
			end
			if cWidth == 0 then
				trace("|r|cffff4422! -- Tourist:|r Size is zero for "..tostring(continentName))
			end
			zones[continentName].yards = cWidth or 0
			--trace("Tourist: Continent size in yards for "..tostring(continentName).." ("..tostring(continentMapID).."): "..tostring(round(zones[continentName].yards, 2)))
		else
			-- Unknown Continent
			trace("|r|cffff4422! -- Tourist:|r TODO: Add Continent '"..tostring(continentName).."' ("..tostring(continentMapID)..")")		
		end
		
		counter = counter + 1
	end
	trace("Tourist: Processed "..tostring(counter).." continents")
	
	trace("Tourist: Initializing zones...")
	local doneZones = {}
	local mapZones = {}
	local uniqueZoneName
	local minLvl, maxLvl, minPetLvl, maxPetLvl
	local counter2 = 0
	counter = 0
	
	for continentMapID, continentName in pairs(continentNames) do	
		mapZones = Tourist:GetMapZonesAlt(continentMapID)
		counter = 0
		for zoneMapID, zoneName in pairs(mapZones) do
			-- Add mapIDs to lookup table
			zoneMapIDtoContinentMapID[zoneMapID] = continentMapID

			-- Check for duplicate on continent name + zone name
			if not doneZones[continentName.."."..zoneName] then
				uniqueZoneName = Tourist:GetUniqueZoneNameForLookup(zoneName, continentMapID)
				if zones[uniqueZoneName] then
					-- Set zone mapID
					zones[uniqueZoneName].zoneMapID = zoneMapID
					-- Get zone texture ID
					zones[uniqueZoneName].texture = C_Map.GetMapArtID(continentMapID)
					-- Get zone player and battle pet levels
					minLvl, maxLvl, minPetLvl, maxPetLvl = C_Map.GetMapLevels(zoneMapID)
					if minLvL and minLvL > 0 then zones[uniqueZoneName].low = minLvl end
					if maxLvl and maxLvl > 0 then zones[uniqueZoneName].high = maxLvl end
					if minPetLvl and minPetLvl > 0 then zones[uniqueZoneName].battlepet_low = minPetLvl end
					if maxPetLvl and maxPetLvl > 0 then zones[uniqueZoneName].battlepet_high = maxPetLvl end
					-- Get map size
					local zWidth = HBD:GetZoneSize(zoneMapID)
					if not zWidth then
						trace("|r|cffff4422! -- Tourist:|r No size data for "..tostring(zoneName).." ("..tostring(continentName)..")" )
					end
					if zWidth == 0 then
						trace("|r|cffff4422! -- Tourist:|r Size is zero for "..tostring(zoneName).." ("..tostring(continentName)..")" )
					end
					if zWidth ~= 0 or not zones[uniqueZoneName].yards then
						-- Make sure the size is always set (even if it's 0) but don't overwrite any hardcoded values if the size is 0
						zones[uniqueZoneName].yards = zWidth
					end
				else
					trace("|r|cffff4422! -- Tourist:|r TODO: Add zone "..tostring(zoneName).." (to "..tostring(continentName)..")" )			
				end
				
				doneZones[continentName.."."..zoneName] = true
			else
				trace("|r|cffff4422! -- Tourist:|r Duplicate zone: "..tostring(zoneName).." [ID "..tostring(zoneMapID).."] (at "..tostring(continentName)..")" )
			end
			counter = counter + 1
		end -- zone loop
		
		trace( "Tourist: Processed "..tostring(counter).." zones for "..continentName.." (ID = "..tostring(continentMapID)..")" )
		counter2 = counter2 + counter
	end -- continent loop

	trace("Tourist: Processed "..tostring(counter2).." zones")
	
	trace("Tourist: Filling lookup tables...")
	
	-- Fill the lookup tables
	for k,v in pairs(zones) do
		lows[k] = v.low or 0
		highs[k] = v.high or 0
		continents[k] = v.continent or UNKNOWN
		instances[k] = v.instances
		paths[k] = v.paths or false
		flightnodes[k] = v.flightnodes or false
		types[k] = v.type or "Zone"
		groupSizes[k] = v.groupSize
		groupMinSizes[k] = v.groupMinSize
		groupMaxSizes[k] = v.groupMaxSize
		groupAltSizes[k] = v.altGroupSize
		factions[k] = v.faction
		yardWidths[k] = v.yards
		yardHeights[k] = v.yards and v.yards * 2/3 or nil
		fishing[k] = v.fishing_min
		battlepet_lows[k] = v.battlepet_low
		battlepet_highs[k] = v.battlepet_high
		textures[k] = v.texture
		complexOfInstance[k] = v.complex
		zoneComplexes[k] = v.complexes
		if v.texture then
			textures_rev[v.texture] = k
		end
		zoneMapIDs[k] = v.zoneMapID
		if v.entrancePortal then
			entrancePortals_zone[k] = v.entrancePortal[1]
			entrancePortals_x[k] = v.entrancePortal[2]
			entrancePortals_y[k] = v.entrancePortal[3]
		end
		if v.flightnodes then
			for nodeID in pairs(v.flightnodes) do
				if not FlightnodeLookupTable[nodeID] then
					FlightnodeLookupTable[nodeID] = true
				end
			end
		end
	end

	trace("Tourist: Built Flightnode lookup table: "..tostring(tablelength(FlightnodeLookupTable)).." nodes.")
	
	zones = nil

	trace("Tourist: Initialized.")

	PLAYER_LEVEL_UP(Tourist)
end
