local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleScriptErrors()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.debug ~= true or E.private.KlixUI.skins.blizzard.debug ~= true then return end
	
	local ScriptErrorsFrame = _G.ScriptErrorsFrame
	ScriptErrorsFrame:Styling()
end

local function styleDebugTools()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.debug ~= true or E.private.KlixUI.skins.blizzard.debug ~= true then return end
	
	local EventTraceFrame = _G.EventTraceFrame
	EventTraceFrame:Styling()

	-- Table Attribute Display
	local function reskinTableAttribute(frame)
		frame:Styling()
	end

	reskinTableAttribute(_G.TableAttributeDisplay)

	hooksecurefunc(_G.TableInspectorMixin, "InspectTable", function(self)
		reskinTableAttribute(self)
	end)
end

S:AddCallback('KuiScriptErrorsFrame', styleScriptErrors)

if _G.IsAddOnLoaded('Blizzard_DebugTools') then
	S:AddCallback('KuiDebugTools', styleDebugTools)
else
	S:AddCallbackForAddon("Blizzard_DebugTools", "KuiDebugTools", styleDebugTools)
end