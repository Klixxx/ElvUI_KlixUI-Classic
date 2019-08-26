local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local format = string.format

local int, int2 = 6, 5
local memoryTable = {}
local cpuTable = {}
local statusColors = {
	"|cff0CD809",
	"|cffE8DA0F",
	"|cffFF9000",
	"|cffD80909"
}

local enteredFrame = false
local bandwidthString = "%.2f Mbps"
local percentageString = "%.2f%%"
local homeLatencyString = "%d ms"
local kiloByteString = "%d kb"
local megaByteString = "%.2f mb"

local function FormatMemory(memory)
	local mult = 10 ^ 1
	if memory > 999 then
		local mem = ((memory / 1024) * mult) / mult
		return T.string_format(megaByteString, mem)
	else
		local mem = (memory * mult) / mult
		return T.string_format(kiloByteString, mem)
	end
end

local function RebuildAddonList()
	local addonCount = T.GetNumAddOns()
	if addonCount == #memoryTable then return end

	memoryTable = {}
	cpuTable = {}
	for i = 1, addonCount do
		memoryTable[i] = {i, T.select(2, T.GetAddOnInfo(i)), 0, T.IsAddOnLoaded(i)}
		cpuTable[i] = {i, T.select(2, T.GetAddOnInfo(i)), 0, T.IsAddOnLoaded(i)}
	end
end

local function GetNumLoadedAddons()
	local loaded = 0
	for i = 1, T.GetNumAddOns() do
		if T.IsAddOnLoaded(i) then loaded = loaded + 1 end
	end
	return loaded
end

local function UpdateMemory()
	T.UpdateAddOnMemoryUsage()

	local addonMemory, totalMemory = 0, 0
	for i = 1, #memoryTable do
		addonMemory = T.GetAddOnMemoryUsage(memoryTable[i][1])
		memoryTable[i][3] = addonMemory
		totalMemory = totalMemory + addonMemory
	end

	T.table_sort(memoryTable, function(a, b)
		if a and b then
			return a[3] > b[3]
		end
	end)

	return totalMemory
end

local function UpdateCPU()
	T.UpdateAddOnCPUUsage()

	local addonCPU, totalCPU = 0, 0
	for i = 1, #cpuTable do
		addonCPU = T.GetAddOnCPUUsage(cpuTable[i][1])
		cpuTable[i][3] = addonCPU
		totalCPU = totalCPU + addonCPU
	end

	T.table_sort(cpuTable, function(a, b)
		if a and b then
			return a[3] > b[3]
		end
	end)

	return totalCPU
end

local function OnEnter(self)
	local r, g, b = T.unpack(E.media.rgbvaluecolor)

	DT:SetupTooltip(self)
	enteredFrame = true

	local cpuProfiling = T.GetCVar("scriptProfile") == "1"
	local bandwidth = T.GetAvailableBandwidth()
	local _, _, home_latency, world_latency = T.GetNetStats() 
	local shown = 0

	DT.tooltip:AddDoubleLine(L["Home Latency:"], T.string_format(homeLatencyString, home_latency), r, g, b)
	DT.tooltip:AddDoubleLine(L["World Latency:"], T.string_format(homeLatencyString, world_latency), r, g, b)
	if bandwidth ~= 0 then
		DT.tooltip:AddDoubleLine(L["Bandwidth"] , T.string_format(bandwidthString, bandwidth), r, g, b)
		DT.tooltip:AddDoubleLine(L["Download"] , T.string_format(percentageString, T.GetDownloadedPercentage() *100), r, g, b)
		DT.tooltip:AddLine(" ")
	end

	if ( T.GetCVarBool("useIPv6") ) then
		local ipTypes = { "IPv4", "IPv6" }
		local ipTypeHome, ipTypeWorld = T.GetNetIpTypes();
		DT.tooltip:AddDoubleLine(L["Home Protocol:"], ipTypes[ipTypeHome or 0] or UNKNOWN, r, g, b)
		DT.tooltip:AddDoubleLine(L["World Protocol:"], ipTypes[ipTypeWorld or 0] or UNKNOWN, r, g, b)
	end

	DT.tooltip:AddDoubleLine(L["Loaded Addons:"], GetNumLoadedAddons(), r, g, b)
	DT.tooltip:AddDoubleLine(L["Total Addons:"], T.GetNumAddOns(), r, g, b)

	local totalMemory = UpdateMemory()
	local totalCPU = nil
	DT.tooltip:AddDoubleLine(L["Total Memory:"], FormatMemory(totalMemory), r, g, b)
	if cpuProfiling then
		totalCPU = UpdateCPU()
		DT.tooltip:AddDoubleLine(L["Total CPU:"], T.string_format(homeLatencyString, totalCPU), r, g, b)
	end

	if T.IsShiftKeyDown() or not cpuProfiling then
		DT.tooltip:AddLine(" ")
		for i = 1, #memoryTable do
			if E.db.KlixUI.systemDT.maxAddons - shown <= 1 then break end
			if (memoryTable[i][4]) then
				local red = memoryTable[i][3] / totalMemory
				local green = 1 - red
				DT.tooltip:AddDoubleLine(memoryTable[i][2], FormatMemory(memoryTable[i][3]), 1, 1, 1, red, green + .5, 0)
				shown = shown + 1
			end
		end
	end

	if cpuProfiling and not T.IsShiftKeyDown() then
		shown = 0
		DT.tooltip:AddLine(" ")
		for i = 1, #cpuTable do
			if E.db.KlixUI.systemDT.maxAddons - shown <= 1 then break end
			if (cpuTable[i][4]) then
				local red = cpuTable[i][3] / totalCPU
				local green = 1 - red
				DT.tooltip:AddDoubleLine(cpuTable[i][2], T.string_format(homeLatencyString, cpuTable[i][3]), 1, 1, 1, red, green + .5, 0)
				shown = shown + 1
			end
		end
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["(Hold Shift) Memory Usage"])
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(L["Left Click:"], L["Garbage Collect"], 0.7, 0.7, 1.0)
	DT.tooltip:AddDoubleLine(L["Right Click:"], L["Reload UI"], 0.7, 0.7, 1.0)

	DT.tooltip:Show()
end

local function OnLeave()
	enteredFrame = false
	DT.tooltip:Hide()
end

local function Update(self, t)
	int = int - t
	int2 = int2 - t

	if int <= 0 then
		RebuildAddonList()
		int = 10
	end

	if int2 <= 0 then
		local fps, fpsColor = T.math_floor(T.GetFramerate()), 4
		local latency = T.select(E.db.KlixUI.systemDT.latency == "world" and 4 or 3, T.GetNetStats())
		local latencyColor = 4

		-- determine latency color based on ping
		if latency < 150 then
			latencyColor = 1
		elseif latency >= 150 and latency < 300 then
			latencyColor = 2
		elseif latency >= 300 and latency < 500 then
			latencyColor = 3
		end

		-- determine fps color based on framerate
		if fps >= 30 then
			fpsColor = 1
		elseif fps >= 20 and fps < 30 then
			fpsColor = 2
		elseif fps >= 10 and fps < 20 then
			fpsColor = 3
		end

		-- set the datatext
		local fpsString = E.db.KlixUI.systemDT.showFPS and ("%s: %s%d|r "):format(L["FPS"], statusColors[fpsColor], fps) or ""
		local msString = E.db.KlixUI.systemDT.showMS and ("%s: %s%d|r "):format(L["MS"], statusColors[latencyColor], latency) or ""
		local memString = E.db.KlixUI.systemDT.showMemory and ("|cffffff00%s|r"):format(FormatMemory(UpdateMemory())) or ""
		self.text:SetText(T.string_join("", fpsString, msString, memString))
		int2 = 1

		if enteredFrame then OnEnter(self) end
	end
end

local function Click(self, button)
	if button == "LeftButton" and not T.InCombatLockdown() then
		local preCollect = UpdateMemory()
		collectgarbage("collect")
		Update(self, 20)
		local postCollect = UpdateMemory()
		if E.db.KlixUI.systemDT.announceFreed then
			KUI:Print(T.string_format(L["Garbage Collection Freed"]..(" |cff00ff00%s|r"):format(FormatMemory(preCollect - postCollect))))
		end
	elseif button == "RightButton" and not T.InCombatLockdown() then
		E:StaticPopup_Show("CONFIG_RL")
	end
end

local function ValueColorUpdate(hex, r, g, b)
	freedString = T.string_join("", hex, "ElvUI|r", " ", L["Garbage Collection Freed"], " ", "|cff00ff00%s|r")
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true


DT:RegisterDatatext("System (KUI)", nil, nil, Update, Click, OnEnter, OnLeave)