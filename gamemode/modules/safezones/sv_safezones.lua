print("Safe-Zones Loaded!")

Barriers = {
	{ --main door
		mdl = "models/hunter/plates/plate2x6.mdl",
		pos = Vector(5101,-8520,80),
		ang = Angle(90, 90, 180),
	},
	
	{ --window
		mdl = "models/hunter/plates/plate2x6.mdl",
		pos = Vector(5362,-8520,80),
		ang = Angle(90, 90, 180),
	},

	{ --side door
		mdl = "models/hunter/plates/plate2x6.mdl",
		pos = Vector(4874,-8751,65),
		ang = Angle(90, 0, 180),
	}
}

VIPBarriers = {
	{
		mdl = "models/hunter/plates/plate2x6.mdl",
		pos = Vector(8225,3718,-135),
		ang = Angle(90, -90, 180),
	}
}

SafeZoneAreas = {
	{
		spos = Vector(5643,-8512,-230),
		epos = Vector(4880,-8894,190),
	},	
	{
		spos = Vector(8663,3584,-192),
		epos = Vector(8040,3208,-88),	
		vip = true
	}
}

SafeZoneEdgeAreas = {	
	{
		spos = Vector(4881,-8976,0),
		epos = Vector(6000,-9088,230),
	},	
	{
		spos = Vector(5649,-8976,0),
		epos = Vector(6000,-8240,230),
	},	
	{
		spos = Vector(5520,-8688,1),
		epos = Vector(6000,-8240,230),
	},	
	{
		spos = Vector(5520,-8512,0),
		epos = Vector(3601,-8208,230),
	},	
	{
		spos = Vector(4870,-8511,0),
		epos = Vector(3600,-9088,230),
	},	
	{ -- VIP Stairs
		spos = Vector(8408,3585,-192),
		epos = Vector(8064,4088,-88),
	}
}

SafeZoneNPCs = {
	{
		pos = Vector(5545,-8879,48),
		ang = Angle(0, 180, 0),
	},
	
	{
		pos = Vector(5588,-8729,48),
		ang = Angle(0, -90, -0),
	}
}


function SpawnNPCs()
	print( "Calling InitPostEntity->NPC Creation!" )

	for k, v in pairs(SafeZoneNPCs) do
		local npc = ents.Create( "npc_sz" )
		npc:SetPos(v.pos)
		npc:SetAngles(v.ang)
		npc:Spawn()
	end
end
hook.Add( "InitPostEntity", "SpawnNPCs", SpawnNPCs )

function LoadBarrier()
	print("Called PostGamemodeLoaded->LoadBarrier")
	
 	for k, v in pairs(Barriers) do
		local barrier = ents.Create("no_entry")
		barrier:SetModel(v.mdl)
		barrier:SetPos(v.pos)
		barrier:SetAngles(v.ang)
		barrier:Spawn()
		if IsValid(barrier:GetPhysicsObject()) then
			barrier:GetPhysicsObject():EnableMotion(false)
		end
		barrier:SetMoveType( MOVETYPE_NONE )
	end
end
hook.Add("PostGamemodeLoaded", "BarrierLoad", LoadBarrier)

function LoadVIPBarrier()
	print("Called InitPostEntity->LoadVIPBarrier")
	
	for k, v in pairs(VIPBarriers) do
		local barrier = ents.Create("no_entry_vip")
		barrier:SetModel(v.mdl)
		barrier:SetPos(v.pos)
		barrier:SetAngles(v.ang)
		barrier:Spawn()
		if IsValid(barrier:GetPhysicsObject()) then
			barrier:GetPhysicsObject():EnableMotion(false)
		end
		barrier:SetMoveType( MOVETYPE_NONE )
	end
end
hook.Add( "InitPostEntity", "VIPBarrierLoad", LoadVIPBarrier )

function LoadSafeZones()
	print("Called InitPostEntity->SafezoneSetup")
	
	for k, v in pairs(SafeZoneAreas) do
		local safezone = ents.Create("safezone")
		safezone:SetMinWorldBound(v.spos)
		safezone:SetMaxWorldBound(v.epos)
		safezone:SetSafezoneEdge(false)
		safezone:SetVIPSZ(v.vip or false)
		safezone:Spawn()
		safezone:Activate()
	end
	
	for k, v in pairs(SafeZoneEdgeAreas) do
		local safezone = ents.Create("safezone")
		safezone:SetMinWorldBound(v.spos)
		safezone:SetMaxWorldBound(v.epos)
		safezone:SetSafezoneEdge(true)
		safezone:Spawn()
		safezone:Activate()
	end
	
end
hook.Add( "InitPostEntity", "LoadSafeZones", LoadSafeZones )

local function SetTagged(target, dmginfo)
	local tagtimed, tagtimev = 60, 60
	if dmginfo:GetAttacker():IsPlayer() and target:IsPlayer() then
	
		if dmginfo:GetAttacker() == target then return end

		if target.SafeZoneEdge or dmginfo:GetAttacker().SafeZoneEdge then 
			if dmginfo:GetAttacker():GetNWInt("TagTime") > CurTime() then
			
			else
				dmginfo:SetDamage(0)
			end
		end
		
		if dmginfo:GetAttacker():IsVIP() then tagtimed = 45 end
		dmginfo:GetAttacker():SetNWInt("TagTime", CurTime() + tagtimev )
		
		if !( (target.SafeZoneEdge or target.SafeZone) or (dmginfo:GetAttacker().SafeZoneEdge or dmginfo:GetAttacker().SafeZone) ) then
			
			if target:IsVIP() then tagtimev = 45 end
			target:SetNWInt("TagTime", CurTime() + tagtimev )

		end
	end
	
	if target:IsVehicle() or (target:GetClass() == "sent_sakariashelicopter") then
		if dmginfo:GetAttacker().SafeZone or dmginfo:GetAttacker().SafeZoneEdge then
			dmginfo:SetDamage(0)
		end
	end
	
end
hook.Add("EntityTakeDamage", "Tagging", SetTagged)