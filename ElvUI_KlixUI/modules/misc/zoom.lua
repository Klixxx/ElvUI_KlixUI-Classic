-------------------------------------------------------------------------------
-- Based on: MaxCam - Ketho
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KZ = KUI:NewModule("KuiZoom", "AceEvent-3.0")

local base = 15
local maxfactor = 4

local function CameraZoom(func, increment)
	local isCloseUp = T.GetCameraZoom() < 6 and E.db.KlixUI.misc.zoom.increment >= 2
	func(increment > 1 and increment or isCloseUp and 2 or E.db.KlixUI.misc.zoom.increment)
end

local oldZoomIn = CameraZoomIn
local oldZoomOut = CameraZoomOut

function CameraZoomIn(v)
	CameraZoom(oldZoomIn, v)
end

function CameraZoomOut(v)
	CameraZoom(oldZoomOut, v)
end

function KZ:PLAYER_ENTERING_WORLD()
	if E.db.KlixUI.misc.zoom.maxZoom then
		T.SetCVar("cameraDistanceMaxZoomFactor", 4)
	else
		T.SetCVar("cameraDistanceMaxZoomFactor", E.db.KlixUI.misc.zoom.distance)
	end
end

function KZ:Initialize()

	KZ:RegisterEvent("PLAYER_ENTERING_WORLD")
end

KUI:RegisterModule(KZ:GetName())