// Variables that are used on both client and server

SWEP.Category				= "Melee Sweps"

SWEP.PrintName		= "Hands"

SWEP.Author = ""
SWEP.Instructions = "For use when walking around."
SWEP.Contact = ""
SWEP.Purpose = "Normal tasks"


SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true


SWEP.ViewModelFOV	= 0
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"
SWEP.AnimPrefix		= "none"
SWEP.HoldType		= "normal"
SWEP.UseHands 			= false

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "None"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "None"

SWEP.DrawCrosshair		= false



/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if ( SERVER ) then
		self:SetNPCMinBurst( 0 )
		self:SetNPCMaxBurst( 0 )
		self:SetNPCFireRate( self.Primary.Delay )
		
		
	end
	
	self:SetWeaponHoldType( self.HoldType )

end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
end

function SWEP:DrawWorldModel()
	return false
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
---------------------------------------------------------*/
function SWEP:Reload()
end


/*---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetDeploySpeed( self.Weapon:SequenceDuration() )

	return true

end


/*---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack( )
   Desc: Helper function for checking for no ammo
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
	return false
end


/*---------------------------------------------------------
   Name: SWEP:CanSecondaryAttack( )
   Desc: Helper function for checking for no ammo
---------------------------------------------------------*/
function SWEP:CanSecondaryAttack()
	return false
end


/*---------------------------------------------------------
   Name: SetDeploySpeed
   Desc: Sets the weapon deploy speed.
		 This value needs to match on client and server.
---------------------------------------------------------*/
function SWEP:SetDeploySpeed( speed )

	self.m_WeaponDeploySpeed = tonumber( speed / GetConVarNumber( "phys_timescale" ) )

	self.Weapon:SetNextPrimaryFire( CurTime() + speed )
	self.Weapon:SetNextSecondaryFire( CurTime() + speed )

end

