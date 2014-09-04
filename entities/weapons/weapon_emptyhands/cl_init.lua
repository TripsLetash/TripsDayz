
include('shared.lua')


SWEP.Slot				= 0					
SWEP.SlotPos			= 0					
SWEP.DrawAmmo			= false					// Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true 					// Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= false					// Should draw the weapon info box
SWEP.BounceWeaponIcon   = false					// Should the weapon icon bounce?


/*---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------*/


function SWEP:PrimaryAttack()
 	local trace = util.GetPlayerTrace(self.Owner)
 	local tr = util.TraceLine(trace)
	local EyeTrace = self.Owner:GetEyeTrace();
	
	if CLIENT then 
			print("Vector("..math.Round(tr.HitPos.x)..","..math.Round(tr.HitPos.y)..","..math.Round(tr.HitPos.z).."),")
	end	
end