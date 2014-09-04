AddCSLuaFile()

if SERVER then 
	util.AddNetworkString("net_SafeZone")
end

DEFINE_BASECLASS( "base_anim" )

ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT

if CLIENT then
	ShowZonesCvar = CreateClientConVar("cyb_showsz", 0, true, false)

	local ShowZones = 0
	function UpdateShowZones(str, old, new)
		ShowZones = math.floor(new)
	end
	cvars.AddChangeCallback(ShowZonesCvar:GetName(), UpdateShowZones)

	hook.Add("Initialize", "InitShowZones", function()
		ShowZones = ShowZonesCvar:GetInt() or 0
	end)

	function ENT:Draw()
		if ShowZones ~= 0 then
			if not LocalPlayer():IsAdmin() then return end
			render.DrawWireframeBox( self:GetPos(), self:GetAngles(), self:GetNWVector("min"), self:GetNWVector("max"), Color( 0, 255, 0 ), false )
		end
	end

end

AccessorFunc(ENT, "MinWorldBound", "MinWorldBound")
AccessorFunc(ENT, "MaxWorldBound", "MaxWorldBound")
AccessorFunc(ENT, "SafezoneEdge", "SafezoneEdge", FORCE_BOOL)
AccessorFunc(ENT, "VIPSZ", "VIPSZ", FORCE_BOOL)

function ENT:Initialize()
	if CLIENT then self:SetRenderBounds(Vector(-10000, -10000, -10000), Vector(10000, 10000, 10000)) end
	if not SERVER then return end

	self:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )

	local pos = LerpVector(0.5, self:GetMinWorldBound(), self:GetMaxWorldBound())
	self:SetPos(pos)
	local min = self:WorldToLocal(self:GetMinWorldBound())
	local max = self:WorldToLocal(self:GetMaxWorldBound())

	self:SetNWVector("min", min)
	self:SetNWVector("max", max)

	self:PhysicsInitBox( min, max )
	self:SetCollisionBounds( min, max )

	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	self:SetMoveType(MOVETYPE_NONE)

	self:SetTrigger(true)	
end

function ENT:StartTouch(ply)
	if not IsValid(ply) then return end
	if ply.IsZombie then CreateCorpse(ply) end
	if not ply:IsPlayer() then return end
	
	net.Start("net_SafeZone")
		net.WriteBit(self:GetSafezoneEdge())
		net.WriteBit(true)
	net.Send(ply)

	if self:GetSafezoneEdge() then
		ply.SafeZoneEdge = true
		ply.TouchedNewSZEdge = true
		--ply:ChatPrint("Entered SafeZone Edge")

		if ply:GetNWInt("TagTime") < CurTime() then
			ply:GodEnable()
		end
	else
		ply.SafeZone = true
		--ply:ChatPrint("Entered SafeZone")

		if self:GetVIPSZ() and !ply:IsVIP() then
			MsgAll(ply:Nick().." slain for Exploiting past VIP SafeZone Barrier!")
			ply.DiedOf = "You died from Exploiting. Nice try."
			ply:Kill()
		end
		
		if ply:GetNWInt("TagTime") > CurTime() then
			if not ply:IsAdmin() then
				MsgAll(ply:Nick().." slain for Climbing into SafeZone while tagged!")
				ply.DiedOf = "You died from Exploiting. Nice try."
				ply:Kill()
			end
		end

		ply:GodEnable()
		
		if ply:GetMoveType() != MOVETYPE_NOCLIP then
			ply:SelectWeapon( "weapon_EmptyHands" )
		end
		
		ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end
end

ENT.NextTouchCheck = 0
function ENT:Touch(ply)
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end
	
	if self.NextTouchCheck > CurTime() then return end
	self.NextTouchCheck = CurTime() + 0.05
	
	if not ply.SafeZone and not ply.SafeZoneEdge then
		self:StartTouch(ply)
	end
	
	if self:GetSafezoneEdge() then
		if ply:GetNWInt("TagTime") < CurTime() then
			ply:GodEnable()
		else
			ply:GodDisable()
		end
	else
		ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		
		ply:GodEnable()
		local wep = ply:GetActiveWeapon()
		if !IsValid(wep) then ply:SelectWeapon( "weapon_EmptyHands" ) return end
		
		if ( wep.AddSafeMode == true ) then
			if wep.FireMode != "safe" then
				wep:SelectFiremode("safe")
			end
		else
			if ply:GetMoveType() != MOVETYPE_NOCLIP then
				ply:SelectWeapon( "weapon_EmptyHands" ) --Fallback for the weapons not using SWB.
			end 
		end
	end
end

function ENT:EndTouch(ply)
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end
	
	net.Start("net_SafeZone")
		net.WriteBit(self:GetSafezoneEdge())
		net.WriteBit(false)
	net.Send(ply)

	if self:GetSafezoneEdge() then
		ply.SafeZoneEdge = false
		--ply:ChatPrint("Left SafeZone Edge")
	else
		ply.SafeZone = false
		--ply:ChatPrint("Left SafeZone")
	end

	ply:GodDisable()
	ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
end