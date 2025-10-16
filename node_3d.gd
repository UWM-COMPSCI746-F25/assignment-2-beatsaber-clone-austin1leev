extends Node3D

func _ready():
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized")
		# Enable XR rendering on viewport
		get_viewport().use_xr = true
		# Optional: disable vsync for VR
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		print("OpenXR not initialized, check headset connection")
