
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

SWEP.Weight				= 5			// Decides whether we should switch from/to this
SWEP.AutoSwitchTo		= true		// Auto switch to if we pick it up
SWEP.AutoSwitchFrom		= true		// Auto switch from if you pick up a better weapon

/*---------------------------------------------------------
   Name: OnDrop
   Desc: Weapon was dropped
---------------------------------------------------------*/
function SWEP:OnDrop()

	if ( ValidEntity( self.Weapon ) ) then
		self.Weapon:Remove()
	end

end

function SWEP:PrimaryAttack()
 	local trace = util.GetPlayerTrace(self.Owner)
 	local tr = util.TraceLine(trace)
	local EyeTrace = self.Owner:GetEyeTrace();
	
	if CLIENT then 
		if self.Owner:IsAdmin() then
			print("Vector("..math.Round(tr.HitPos.x)..","..math.Round(tr.HitPos.y)..","..math.Round(tr.HitPos.z).."),")
		end
	end	
end