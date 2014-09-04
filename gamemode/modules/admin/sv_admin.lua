function GM:PlayerNoClip(ply, state)
	if ply:IsAdmin() then
		if state then
			ply:DrawShadow(false)
			ply:SetColor(Color(255,255,255,0))
			ply:SetKeyValue("rendermode", RENDERMODE_TRANSTEXTURE)
			ply:SetKeyValue("renderamt", "0")
			ply.CantLoot = true
			ply.Noclip = true
			timer.Destroy(ply:UniqueID().."NoLooting")
			return true
		else
			ply:SetKeyValue( "rendermode", RENDERMODE_NORMAL )
			ply:SetKeyValue( "renderamt", "255" )
			ply:DrawShadow(true)
			ply:SetColor(Color(255,255,255,255))
			ply.Noclip = false
			timer.Create( ply:UniqueID().."NoLooting", 10, 0, function()
				if !IsValid(ply) then return end
				ply.CantLoot = false
			end)
			return true
		end
	end
	return false
end

local function DZ_Physgun( ply ) 
	if ply:IsSuperAdmin() then
		ply:Give("weapon_physgun")
	end
end
concommand.Add("dz_physgun", DZ_Physgun)

local function DZ_NoPhysgun( ply ) 
	ply:StripWeapon("weapon_physgun")
end
concommand.Add("dz_nophysgun", DZ_NoPhysgun)

function PlayerPickup(ply, ent)
	//If the player is a super admin, and the entity is a player
	if ply:IsSuperAdmin() and ent:IsPlayer() then
		ent:GodEnable()
		return true -- Allow pickup
	end
end
hook.Add("PhysgunPickup", "AllowPlayerPickup", PlayerPickup)

function PhysgunDrop(ply, ent)
	//If the player is a super admin, and the entity is a player
	if ply:IsSuperAdmin() and ent:IsPlayer() then
		ent:GodDisable()
	end
end
hook.Add("PhysgunDrop", "AllowPlayerPickup", PhysgunDrop)