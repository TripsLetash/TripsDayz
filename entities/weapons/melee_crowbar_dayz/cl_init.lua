
include('shared.lua')


SWEP.PrintName			= "Crowbar"		// 'Nice' Weapon name (Shown on HUD)
SWEP.Slot				= 0						// Slot in the weapon selection menu
SWEP.SlotPos			= 2						// Position in the slot
SWEP.DrawAmmo			= false					// Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true 					// Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= false					// Should draw the weapon info box
SWEP.BounceWeaponIcon   = false					// Should the weapon icon bounce?

// Override this in your SWEP to set the icon in the weapon selection
SWEP.WepSelectFont		= "TitleFont"
SWEP.WepSelectLetter	= "c"
SWEP.IconFont			= "HL2MPTypeDeath"
SWEP.IconLetter			= "6"

/*---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

	// Set us up the texture
	surface.SetDrawColor( color_transparent )
	surface.SetTextColor( 255, 220, 0, alpha )
	local w, h = surface.GetTextSize( self.WepSelectLetter )

end

