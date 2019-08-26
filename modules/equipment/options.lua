local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local EM = KUI:GetModule('EquipManager')
local KBI = KUI:GetModule('KuiBagInfo')

local NONE = NONE
local PAPERDOLL_EQUIPMENTMANAGER = PAPERDOLL_EQUIPMENTMANAGER
local SPECIALIZATION_PRIMARY = SPECIALIZATION_PRIMARY
local SPECIALIZATION_SECONDARY = SPECIALIZATION_SECONDARY
local PVP = PVP
local DUNGEONS = DUNGEONS
local GENERAL = GENERAL
local TIMEWALKING = L["Timewalking"]

local sets = {}

local function GetAllEquipmentSets()
	local sets = { ["none"] = L["No Change"] }
	local equipmentSetIDs = T.C_EquipmentSet_GetEquipmentSetIDs();
	for key,value in T.pairs(equipmentSetIDs) do
		local name = T.C_EquipmentSet_GetEquipmentSetInfo(value)
		if name then
			sets[name] = name
		end
	end
	T.table_sort(sets, function(a, b) return a < b end)
	return sets
end

local function FillTable()

	T.table_wipe(sets)
	sets["NONE"] = NONE
	local equipmentSetIDs = T.C_EquipmentSet_GetEquipmentSetIDs()
	for index = 1, T.C_EquipmentSet_GetNumEquipmentSets() do
		local name, icon, lessIndex = T.C_EquipmentSet_GetEquipmentSetInfo(equipmentSetIDs[index])
		if name then
			sets[name] = name
		end
	end
	return sets
end

local function EquipManagerTable()
	local function ConstructSpecOption(ORDER, ID, OPTION)
		local SpecID, SpecName = T.GetSpecializationInfo(ID)
		local sets = GetAllEquipmentSets()
		if not SpecID then return nil end
		local config = {
			order = ORDER,
			type = "group",
			guiInline = true,
			name = SpecName,
			get = function(info) return EM.db[OPTION][ info[#info] ] end,
			set = function(info, value) EM.db[OPTION][ info[#info] ] = value; end,
			args = {
				infoz = {
					order = 1,
					type = "description",
					name =  T.string_format(L["Equip this set when switching to specialization %s."], SpecName),
				},
				general = {
					order = 2,
					type = "select",
					name = GENERAL,
					desc = L["Equip this set for open world/general use."],
					values = function()
						FillTable() 
						return sets
					end,
				},
				instance = {
					order = 3,
					type = "select",
					name = DUNGEONS,
					disabled = function() return not EM.db.instanceSet end,
					desc = L["Equip this set after entering dungeons or raids."],
					values = function()
						FillTable() 
						return sets
					end,
				},
				timewalking = {
					order = 4,
					type = "select",
					name = TIMEWALKING,
					disabled = function() return not EM.db.timewalkingSet end,
					desc = L["Equip this set after enetering a timewalking dungeon."],
					values = function()
						FillTable()
						return sets
					end,
				},
				pvp = {
					order = 5,
					type = "select",
					name = PVP,
					disabled = function() return not EM.db.pvpSet end,
					desc = L["Equip this set after entering battlegrounds or arens."],
					values = function()
						FillTable() 
						return sets
					end,
				},
			},
		}
		return config
	end
	
	E.Options.args.KlixUI.args.modules.args.equipmanager = {
		type = 'group',
		order = 13,
		name = L["Equipment Manager"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Equipment Manager"]),
			},
			intro = {
				order = 2,
				type = 'description',
				name = L["EM_DESC"],
			},
			general = {
				order = 3,
				type = "group",
				name = L["General"],
				guiInline = true,
				args = {
					enable = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						desc = L["Enable/Disable the Equipment Manager and the all character window texts."],
						get = function(info) return EM.db.enable end,
						set = function(info, value) EM.db.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
					},
					space1 = {
						order = 2,
						type = "description",
						name = "",
					},
					space2 = {
						order = 3,
						type = "description",
						name = "",
					},
					setoverlay = {
						type = "toggle",
						order = 4,
						name = L["Equipment Set Overlay"],	
						desc = L["Show the associated equipment sets for the items in your bags (or bank)."],
						disabled = function() return not E.private.bags.enable end,
						get = function(info) return E.private.KlixUI.equip.setoverlay end,
						set = function(info, value) E.private.KlixUI.equip.setoverlay = value; KBI:ToggleSettings() end,
					},
					lockbutton = {
						order = 5,
						type = "toggle",
						name = L["Block button"],
						desc = L["Create a button in the character window to allow temporary blocking of auto set swap."],
						disabled = function() return not EM.db.enable end,
						get = function(info) return EM.db.lockbutton end,
						set = function(info, value) EM.db.lockbutton = value; E:StaticPopup_Show("PRIVATE_RL") end
					},
					onlyTalent = {
						type = "toggle",
						order = 6,
						name = L["Ignore zone change"],
						desc = L["Swap sets only on specialization change ignoring location change when. Does not influence entering/leaving instances and bg/arena."],
						disabled = function() return not EM.db.enable end,
						get = function(info) return EM.db.onlyTalent end,
						set = function(info, value) EM.db.onlyTalent = value; end,
					},
				},
			},
			equipsets = {
				type = "group",
				name = PAPERDOLL_EQUIPMENTMANAGER,
				order = 11,
				disabled = function() return not EM.db.enable end,
				guiInline = true,
				args = {
					conditions = {
						order = 1,
						type = "input",
						width = "full",
						name = L["Equipment conditions"],
						desc = L["KUI_EM_CONDITIONS_DESC"],
						get = function(info) return EM.db.conditions end,
						set = function(info, value) EM.db.conditions = value; EM:UpdateTags() end
					},
					help = {
						order = 2,
						type = 'description',
						name = L["KUI_EM_TAGS_HELP"],
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, EquipManagerTable)