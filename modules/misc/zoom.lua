-------------------------------------------------------------------------------
-- Based on: MaxCam - Ketho
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KZ = KUI:NewModule("KuiZoom");

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

-- multi-passenger mounts / quest vehicles
local oldVehicleZoomIn = VehicleCameraZoomIn
local oldVehicleZoomOut = VehicleCameraZoomOut

function VehicleCameraZoomIn(v)
	CameraZoom(oldVehicleZoomIn, v)
end

function VehicleCameraZoomOut(v)
	CameraZoom(oldVehicleZoomOut, v)
end