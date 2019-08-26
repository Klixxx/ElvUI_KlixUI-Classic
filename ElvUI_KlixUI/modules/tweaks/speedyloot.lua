local KUI, T, E, L, V, P, G = unpack(select(2, ...))

local Frame, FrameEvents = T.CreateFrame('Frame'), {}

local block = {
	['TradeSkillMaster_Destroying'] = 'TSMDestroyingFrame',
	['Easy_Obliterate']							= 'ObliterumForgeFrame'
}

Frame.ready = false
Frame.group = false
Frame.count = 0
Frame.items = {}

local method, rarity, locked, treshold
function FrameEvents:LOOT_READY(...)
if E.global.KlixUI.speedyLoot == false or T.IsAddOnLoaded("FasterLoot") then return end
	if Frame.ready then
		return
	end
	
	for k, v in pairs(block) do
		if T.IsAddOnLoaded(k) and _G[v]:IsVisible() then
			return
		end
	end
	
	if (GetCVar('autoLootDefault') == '1' and not T.IsModifiedClick('AUTOLOOTTOGGLE')) or (T.GetCVar('autoLootDefault') ~= '1' and T.IsModifiedClick('AUTOLOOTTOGGLE')) then
		Frame.ready = true
		Frame.count = 5
		
		if T.IsInGroup() then
			method = T.GetLootMethod()
			Frame.group = method == 'master' and true or false
		end
		
		if #Frame.items ~= 0 then
			for i = #Frame.items, 1, -1 do
				T.table_remove(Frame.items, i)
			end
		end
		for i = T.GetNumLootItems(), 1, -1 do
			_, _, _, rarity, locked = T.GetLootSlotInfo(i)
			threshold = T.GetLootThreshold()
			
			if locked ~= nil and not locked then
				if (Frame.group and rarity < threshold) or not Frame.group then
					T.table_insert(Frame.items, i)
				end
			end
		end
	end
end

for k in T.pairs(FrameEvents) do
	Frame:RegisterEvent(k)
end
Frame:SetScript('OnEvent', function(self, event, ...)
	FrameEvents[event](self, ...)
end)

Frame:SetScript('OnUpdate', function(self)
	if not Frame.ready or Frame.count <= 0 then
		return
	end
	
	Frame.count = Frame.count - 1
	for k, v in T.pairs(Frame.items) do
		T.LootSlot(v)
	end
	
	if Frame.count <= 0 or T.GetNumLootItems() == 0 then
		Frame.ready = false
		for i = #Frame.items, 1, -1 do
			T.table_remove(Frame.items, i)
		end
		T.CloseLoot()
	end
end)