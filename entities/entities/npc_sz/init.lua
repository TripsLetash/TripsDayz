AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.AddNetworkString( "net_DonatorMenu" )

function ENT:Initialize()
   self:SetModel("models/Humans/Group03/male_07.mdl")
   
   self:SetHullType( HULL_HUMAN )
   self:SetHullSizeNormal();
   self:SetSolid( SOLID_BBOX )
   --self:CapabilitiesAdd( CAP_WEAPON_MELEE_ATTACK1, CAP_ANIMATEDFACE, CAP_TURN_HEAD, CAP_USE_SHOT_REGULATOR, CAP_USE_WEAPONS, CAP_WEAPON_MELEE_ATTACK2, CAP_INNATE_MELEE_ATTACK1, CAP_INNATE_MELEE_ATTACK2)
   self:SetMoveType( MOVETYPE_STEP )
   self:SetMaxYawSpeed( 5000 )
  
   //Sets the entity values
   self:SetHealth(10000000)
   self:SetEnemy(NULL)
   self:SetSchedule(SCHED_IDLE_STAND)
   position = self:GetPos()
   self:SetUseType(SIMPLE_USE)
   
   self:SetKeyValue( "additionalequipment", "weapon_stunstick" )
   self:Give("weapon_stunstick")
   --self:GetActiveWeapon():SetMaterial("models/debug/debugwhite")
   --self:GetActiveWeapon():SetColor(Color(0,255,0,255))
   		
   
end

function ENT:AcceptInput( input, activator, caller )
	if input == "Use" && activator:IsPlayer() then
		net.Start( "net_DonatorMenu")  
		net.Send( activator )  
	end
end
   
function ENT:OnTakeDamage(dmg)
	self:SetHealth(100000)
end

function ENT:Think()
end