util.AddNetworkString( "SendHitInfo" )
util.AddNetworkString( "HurtInfo" )
util.AddNetworkString( "ZombiePModel" )
util.AddNetworkString( "RZombiePModel" )
util.AddNetworkString( "net_DeathMessage" )
util.AddNetworkString( "net_DeathMessage2" )

hook.Add( "PlayerDisconnect", "tagfuck", function( ply )	
	if !IsValid( ply ) then return end

	if ply:GetNWInt( "TagTime" ) > CurTime() then
		ply:Kill()
	end
end )

function CreateBackpack_OLD(ply)
	local backpack = ents.Create( "backpack" )	
	backpack:SetNWString("OwnerNick", ply:Nick())
	
	if IsValid(ply.hat) then 
		ply.hat:Remove()
	end
	
	backpack.ItemTable = {}
	backpack.CharTable = {}

	for k, v in pairs( ply.CharTable ) do
		if GAMEMODE.DayZ_Items[ k ].VIP != nil and ply:IsVIP() then continue end
			
		backpack.CharTable[ k ] = 1
		PLib:QuickQuery( "DELETE FROM `players_character` WHERE `user_id` = " .. ply.ID .. " AND `item` = "..k..";" )
		PLib:QuickQuery( "ALTER TABLE `players_character` AUTO_INCREMENT = 1;" )

		ply.CharTable[ k ] = nil
	end
	ply:UpdateChar()
	
	for k, v in pairs( ply.InvTable ) do
	
		if k == 2 then continue end -- DONT DROP CREDITS!

		backpack.ItemTable[ k ] = v
		if ply.Perk3 == true then	-- has the player got the perk
			if math.random( 0, 100 ) <= 90 then -- perk check
				ply.InvTable[ k ] = nil
				PLib:QuickQuery( "DELETE FROM `players_inventory` WHERE `user_id` = " .. ply.ID .. " AND `item` = "..k..";" )
				PLib:QuickQuery( "ALTER TABLE `players_inventory` AUTO_INCREMENT = 1;" )
			else
				backpack.ItemTable[ k ] = nil 
			end
		else
			ply.InvTable[ k ] = nil
			PLib:QuickQuery( "Default", "DELETE FROM `players_inventory` WHERE `user_id` = " .. ply.ID .. " AND `item` = "..k..";" )
			PLib:QuickQuery( "Default", "ALTER TABLE `players_inventory` AUTO_INCREMENT = 1;" )
		end
	end
	ply:UpdateItem()
	
	backpack:Spawn()
	backpack:SetPos( ( ply:GetPos() + Vector( 0, 0, 30 ) ) + ply:GetForward() * -8 )
	backpack:SetAngles( ply:GetAngles() + Angle( 0, 180, 0 ) )
	backpack:GetPhysicsObject():SetMass( 5 )
	backpack:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	timer.Simple( 120, function()
		if IsValid( backpack ) then
			backpack:Remove()
		end
	end )
	
	save_player( ply )
		
	return backpack
end

function CreateBackpack( ply )
	
	local backpack = ents.Create( "backpack" )	
	backpack:SetNWString( "OwnerNick", ply:Nick() )
	
	if IsValid( ply.hat ) then
		ply.hat:Remove()
	end
	
	backpack.ItemTable = {}
	backpack.CharTable = {}

	if table.Count( ply.CharTable ) > 0 then
		local Delete = {}
		for k, v in pairs( ply.CharTable ) do
			if GAMEMODE.DayZ_Items[ k ].VIP != nil and ply:IsVIP() then continue end

			backpack.CharTable[ k ] = 1
			ply.CharTable[ k ] = nil

			Delete[ k ] = true
		end

		if table.Count( Delete ) > 0 then
			PLib:QuickQuery( "DELETE FROM `players_character` WHERE `user_id` = " .. ply.ID .. " AND `item` IN ( " .. table.concat( table.GetKeys( Delete ), ", " ) .. " );" )
			PLib:QuickQuery( "ALTER TABLE `players_character` AUTO_INCREMENT = 1;" )
		else
			PLib:QuickQuery( "DELETE FROM `players_character` WHERE `user_id` = " .. ply.ID .. ";" )
			PLib:QuickQuery( "ALTER TABLE `players_character` AUTO_INCREMENT = 1;" )

			ply.CharTable = {}
		end

		Delete = nil

		ply:UpdateChar()
	end

	if table.Count( ply.InvTable ) > 0 then
		local Delete = {}
		for k, v in pairs( ply.InvTable ) do
			if k == 2 then continue end -- Credits do not drop on death.

			if ply.Perk3 == true then -- has the player got the dead man's luck perk
				if math.random( 0, 100 ) <= 90 then -- 10% chance
					backpack.ItemTable[ k ] = v
					ply.InvTable[ k ] = nil

					Delete[ k ] = true
				end
			else
				break
			end
		end

		if table.Count( Delete ) > 0 then
			PLib:QuickQuery( "DELETE FROM `players_inventory` WHERE `user_id` = " .. ply.ID .. " AND `item` IN ( " .. table.concat( table.GetKeys( Delete ), ", " ) .. " );" )
			PLib:QuickQuery( "ALTER TABLE `players_inventory` AUTO_INCREMENT = 1;" )
		else
			PLib:QuickQuery( "DELETE FROM `players_inventory` WHERE `user_id` = " .. ply.ID .. " AND `item` != 2;" )
			PLib:QuickQuery( "ALTER TABLE `players_inventory` AUTO_INCREMENT = 1;" )

			backpack.ItemTable = ply.InvTable

			ply.InvTable = {}
			ply.InvTable[ 2 ] = ( backpack.ItemTable[ 2 ] and backpack.ItemTable[ 2 ] ) or nil

			backpack.ItemTable[ 2 ] = nil
		end

		Delete = nil

		ply:UpdateItem()
	end
	
	backpack:Spawn()
	backpack:SetPos( ( ply:GetPos() + Vector( 0, 0, 30 ) ) + ply:GetForward() * -8 )
	backpack:SetAngles( ply:GetAngles() + Angle( 0, 180, 0 ) )
	backpack:GetPhysicsObject():SetMass( 5 )
	backpack:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	timer.Simple( 120, function()
		if IsValid( backpack ) then
			backpack:Remove()
		end
	end )
	
	save_player( ply )
		
	return backpack
end

function CreateCorpse( ent, dmginfo )
	local ragdoll = ents.Create( "prop_ragdoll" )
	ragdoll:SetModel( ent.deathmodel or ent:GetModel() )
	ragdoll:SetPos( ent:GetPos() )
	ragdoll:SetAngles( ent:GetAngles() )
	ragdoll:Spawn()
	
	ragdoll:SetCollisionGroup( COLLISION_GROUP_WORLD )
	ragdoll:SetSkin( ent:GetSkin() )

	local col = ent:GetColor()
	if col.a < 1 then
		col.a = 255
	end
	
	ragdoll:SetRenderMode( 1 )
	ragdoll:SetColor( Color( col.r, col.g, col.b, col.a ) )

	ragdoll:SetMaterial( ent:GetMaterial() )
	
	if ent:IsNPC() then
		ent.nick = "Zombie"
		
		table.RemoveByValue( ZombieTbl, ent )
			
		ragdoll:Fire( "FadeAndRemove", "", 1 )
	elseif ent:IsPlayer() then
		ent.nick = ent:Nick()

		ragdoll.player = ent
		ragdoll:Fire( "FadeAndRemove", "", 120 )
	
		ent:SpectateEntity( ragdoll )
	end
	
	for bone = 0, ragdoll:GetPhysicsObjectCount() do
		local phys = ragdoll:GetPhysicsObjectNum( bone )
		local plybone = ragdoll:TranslatePhysBoneToBone( bone )
		local bonepos, boneang = ent:GetBonePosition( plybone )
		
		if IsValid( phys ) and IsValid( ent ) then
			phys:SetPos( bonepos )
			phys:SetAngles( boneang )
		end
		
		if IsValid( phys ) then
			phys:AddVelocity( ent:GetVelocity() )
		end
	end
	
	if ent:IsOnFire() then
		ragdoll:Ignite( math.random( 8, 10 ), 15 )
	end
	
	if !ent:IsPlayer() then -- whoops!
		ent:Remove()
	end
	
	return ragdoll
end

function GM:PlayerDeath( ply, infl, attacker )
	ply.Dead = true	
	
	ply:SetNWInt( "TagTime", 0 )
	ply:SetFrags( 0 )
	ply:SetNWBool( "friendly", false )
	
	local dtime = PHDayZ.DeathTime
	if ply:IsVIP() then
		dtime = PHDayZ.VIPDeathTime
	end
	
	timer.Simple( dtime, function()
		if IsValid( ply ) then
			ply.AllowRespawn = true
		
			net.Start( "net_DeathMessage2" )
			net.Send( ply )				
		end
	end )	

	local str = ""
	if attacker:IsPlayer() then
		if ply.DiedOf != nil then
			str = ply.DiedOf
			ply.DiedOf = nil
			
			return 
		end
		
		if attacker == ply then
			str = "Looks like suicide."
		else
			str = "You were killed by "..ply:Nick()
		end
	elseif attacker:IsNPC() then
		str = "You were eaten by a Zombie."
	end
	
	net.Start( "net_DeathMessage" )
	if str != "" then
		net.WriteString( str )
	end
	net.Send( ply )

	if attacker:IsVehicle() and attacker:GetDriver() then
		attacker = attacker:GetDriver()
	end
	
	if attacker:IsPlayer() and attacker != ply then
	
		if ply:Frags() > PHDayZ.KillsToBeBandit and ply:Frags() < PHDayZ.KillsToBeBounty then -- bandit
			if attacker:Frags() <= 1 then
				attacker:SetNWBool( "friendly", true )
				attacker:AddFrags( -1 )		
			end
		elseif ply:Frags() >= PHDayZ.KillsToBeBounty then -- bounty!
			attacker:GiveCredits( 5 )
			TipAll( 3, attacker:Nick() .. " claimed the bounty on " .. ply:Nick() .. "!", Color(0, 255, 0) )	
			
			if attacker:Frags() <= 1 then
				attacker:SetNWBool( "friendly", true )
			else
				attacker:AddFrags( -1 )		
			end
		else
			attacker:AddFrags( 1 )
			
			if attacker:Frags() >= PHDayZ.KillsToBeBandit then
				attacker:SetNWBool( "friendly", false )
			end
			
			if attacker:Frags() == PHDayZ.KillsToBeBounty then
				TipAll( 3, "A bounty has been placed on " .. attacker:Nick() .. "!", Color(255, 0, 0) )	
			end
		end
		
	end
	
	ply:SetModel( ply.oPModel ) -- Removing Ghillisuit.
	
	local ragdoll = CreateCorpse( ply )
	local backpack = CreateBackpack( ply )
	
	if !IsValid( ragdoll ) then return end
	local bone = ragdoll:LookupBone( "ValveBiped.Bip01_Spine" )
	local bone2 = ragdoll:LookupBone( "ValveBiped.Bip01_Pelvis" )
	
	if !bone then MsgAll( "Ragdoll with no bone!" ) return end
	if !bone2 then MsgAll( "Ragdoll with no bone2!" ) return end
	
	constraint.Weld( backpack, ragdoll, 0, bone, 0, 0, true )
	constraint.Weld( backpack, ragdoll, 0, bone2, 0, 0, true ) 
end

function GM:PlayerDeathThink( ply )
	if IsValid( ply ) then
		if ply.AllowRespawn == true then
			if( ply:KeyDown( IN_ATTACK ) ) then		
				ply.AllowRespawn = false
				ply:Spawn()
			end
		end
	end
end

function GM:EntityTakeDamage( ent, dmginfo )
	if dmginfo:GetAttacker():IsNPC() then
		dmginfo:ScaleDamage( ( math.random( 20, 30 ) / 10 ) )
	end
		
	if ent:IsNPC() and dmginfo:GetAttacker():IsPlayer() then
		if dmginfo:GetAttacker().Perk5 == true then
			dmginfo:ScaleDamage( 3.5 )
		else
			dmginfo:ScaleDamage( 2.5 )
		end
	end
		
	if ent:IsNPC() and dmginfo:GetAttacker():IsPlayer() then
		if ( ent:Health() - dmginfo:GetDamage() ) <= 0 then
			if dmginfo:GetAttacker():IsVIP() then
				dmginfo:GetAttacker():XPAward( 10 )	
			else
				dmginfo:GetAttacker():XPAward( 5 )			
			end			
		end
	end	
	
	if dmginfo:GetAttacker():IsVehicle() and IsValid( dmginfo:GetAttacker():GetDriver() ) then
		dmginfo:GetAttacker():GetDriver():AddFrags( 1 )
	end
	
	if ( ent:IsVehicle() ) then
		if dmginfo:IsExplosionDamage() then
			ent:SetHealth( ent:Health() - 10 )

			if IsValid( ent:GetDriver() ) then
				ent:GetDriver():TakeDamage( 10, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
			end
		else
			ent:SetHealth( ent:Health() - 5 )

			if IsValid(ent:GetDriver()) then
				ent:GetDriver():TakeDamage( 5, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
			end
		end
	end
		
	if ( ent:GetClass() == "sent_sakariashelicopter" ) then
		if dmginfo:IsExplosionDamage() then
			ent:SetHealth( ent:Health() - 10 )

			if IsValid( ent:GetDriver() ) then
				ent:GetDriver():TakeDamage( 10, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
			end
		else
			ent:SetHealth( ent:Health() - 5 )

			if IsValid(ent:GetDriver()) then
				ent:GetDriver():TakeDamage( 5, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
			end
		end

		ent:EmitSound( "npc/attack_helicopter/aheli_damaged_alarm1.wav" ) --- SOUND WHEN YOU  DAMAGE THE VEHICLE		
	end			
	
	if ent:IsPlayer() and ent:InVehicle() then
		dmginfo:ScaleDamage( 0 )
	end
	
	if ent:IsPlayer() then
		if ent:Alive() then
			net.Start( "HurtInfo" )
			net.Send( ent )				
		end
	end
	
	if dmginfo:GetAttacker():IsPlayer() then
		if ent:IsPlayer() or ent:IsNPC() then
			net.Start( "SendHitInfo" )
			net.Send( dmginfo:GetAttacker() )	
		end
	end
end

function PlayerDamages( victim, attacker )
end
hook.Add( "PlayerShouldTakeDamage", "PlayerDamages", PlayerDamages )

function OverrideDeathSound()
	return true
end
hook.Add( "PlayerDeathSound", "OverrideDeathSound", OverrideDeathSound )

local ENTITY = FindMetaTable("Entity")
function ENTITY:DropMoney( ent, amountlow, amounthigh, chance, pos )
	if math.random( 0, 100 ) <= chance then
		local moneyitem = ents.Create( "money" )
		--print("Spawning money!!")
		moneyitem:Spawn()
		moneyitem:SetPos( ent:GetPos() )		
		moneyitem.Money = math.random( amountlow, amounthigh )
	end
end