-- Common Zombie

AddCSLuaFile()

ENT.Base = "base_nextbot"

// Moddable

ENT.IsZombie = true
--ENT.Skins = 22
--ENT.AttackAnims = { "attack01", "attack02", "attack03", "attack04" }
ENT.MaxDist = 800
ENT.AnimSpeed = 1.2
ENT.AttackTime = 0.5
ENT.MeleeDistance = 64
ENT.BreakableDistance = 64
ENT.Damage = 15
ENT.BaseHealth = 120
ENT.JumpHeight = 100
ENT.MoveSpeed = 260
ENT.BumpSpeed = 700
ENT.MoveAnim = ACT_RUN
ENT.WalkAnim = ACT_WALK
ENT.AttackAnims = {
	"attackA",
	"attackB",
	"attackC"
}

ENT.WalkSequences = {
	"walk1",
	"walk2",
	"walk3",
	"walk4",
	"walk5",
	"walk6",
	"walk7",
	"walk8",
	"walk9",
	"walk10"
}

ENT.IdleSequences = {
	"Idle01",
	"Idle02",
	"Idle03",
	"Idle04"
}

ENT.HeardSound = false
ENT.SoundPos = nil

ENT.Models = { 	
	Model("models/nmr_zombie/berny.mdl"),
	Model("models/nmr_zombie/casual_02.mdl"),
	Model("models/nmr_zombie/herby.mdl"),
	Model("models/nmr_zombie/jogger.mdl"),
	Model("models/nmr_zombie/julie.mdl"),
	Model("models/nmr_zombie/maxx.mdl"),
	Model("models/nmr_zombie/officezom.mdl"),
	Model("models/nmr_zombie/toby.mdl")
}

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = { 
	Sound( "cyb_zombies/death1.wav" ),
	Sound( "cyb_zombies/death2.wav" )
}
 
ENT.VoiceSounds.Pain = {
	Sound( "cyb_zombies/pain1.wav" ),
	Sound( "cyb_zombies/pain2.wav" ),
	Sound( "cyb_zombies/pain3.wav" ),
	Sound( "cyb_zombies/pain4.wav" )
}

ENT.VoiceSounds.Taunt = {
	Sound( "cyb_zombies/idle1.wav" ),
	Sound( "cyb_zombies/idle2.wav" ),
	Sound( "cyb_zombies/idle3.wav" )
}

ENT.VoiceSounds.Attack = {
	Sound( "cyb_zombies/roar1.wav" ),
	Sound( "cyb_zombies/roar2.wav" ),
	Sound( "cyb_zombies/screech1.wav" ),
	Sound( "cyb_zombies/screech2.wav" ),
	Sound( "zombies/zombie_hit.wav" ),
	Sound( "zombies/zombie_pound_door.wav" )
}

ENT.WoodHit = Sound( "Wood_Plank.Break" )
ENT.WoodBust = Sound( "Wood_Crate.Break" ) 

ENT.ClawHit = { Sound( "npc/zombie/claw_strike1.wav" ),
Sound( "npc/zombie/claw_strike2.wav" ),
Sound( "npc/zombie/claw_strike3.wav" ) }

ENT.ClawMiss = { Sound( "npc/zombie/claw_miss1.wav" ),
Sound( "npc/zombie/claw_miss2.wav" ) }

ENT.Corpses = {}

ENT.NextBot = true
ENT.ShouldDrawPath = false
ENT.Obstructed = false
ENT.Alert = false
ENT.FireDamageTime = 0
ENT.FireTime = 0

ENT.DoorHit = Sound( "npc/zombie/zombie_hit.wav" )

function ENT:Initialize()
	local officezombie = false
	if self.Models then
		local model = table.Random( self.Models )
		self:SetModel( model )
		if (model == Model"models/nmr_zombie/officezom.mdl") then officezombie = true end
	else	
		self:SetModel( self.Model )
	
	end	
	self:SetHealth( self.BaseHealth )
	self:SetCollisionGroup( COLLISION_GROUP_NPC )
	self:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) ) // nice fat shaming
	local skin = 1
	if officezombie == true then skin = math.floor(math.random( 1, 5 )) end
	self:SetSkin( skin )
	self:SetTrigger( true )
	
	self.loco:SetDeathDropHeight( 1000 )
	self.loco:SetStepHeight(20)	
	self.loco:SetAcceleration(200) --math.random(350, 650)	
	--self.MoveSpeed = 320--math.random(150, 400)
	self.loco:SetJumpHeight( self.JumpHeight )
	
	self.DmgTable = {}
	self.LastPos = self:GetPos()
	self.Stuck = CurTime() + 1
	
end

function ENT:Think()			
	if ( self.IdleTalk or 0 ) < CurTime() then	
		self:VoiceSound( self.VoiceSounds.Taunt )
		self.IdleTalk = CurTime() + math.Rand(10,20)		
	end
	
	if ( self.Stuck or 0 ) < CurTime() then	
		self:StuckThink()
	
		self.Stuck = CurTime() + 1
		self.LastPos = self:GetPos() 		
	end

	if self.CurAttack and self.CurAttack < CurTime() then	
		self.CurAttack = nil
		
		if IsValid( self.CurEnemy ) then		
			if self.CurEnemy:IsPlayer() or self.CurEnemy:IsNPC() then			
				local enemy = self:CanAttackEnemy( self.CurEnemy )				
				if IsValid( enemy ) then				
					self:VoiceSound( self.ClawHit )
					self:OnHitEnemy( enemy )				
				else									
					self:VoiceSound( self.ClawMiss )				
				end
			elseif ( self.CurEnemy:GetPos():Distance( self:GetPos() ) <= self.BreakableDistance ) or self.CurEnemy == self:GetBreakable() then
				self:EmitSound( self.DoorHit, 100, math.random(90,110) )
				self:OnHitBreakable( self.CurEnemy )			
			end
		else		
			self:VoiceSound( self.ClawMiss )
		end
	end
end

function ENT:OnHitBot( enemy )
	enemy:TakeDamage( self.Damage, self )
end

function ENT:Touch(ent)
	self:EmitSound( "ambient/explosions/explode_" .. math.random( 1, 9 ) .. ".wav" )
end

function ENT:OnTakeDamage(dmg)
   self:SetHealth(self:Health() - dmg:GetDamage())

   if self:Health() <= 0 then //run on death
		
		if dmg:IsExplosionDamage() then			
			local ragdoll = CreateCorpse( self, dmginfo )
			local corpse = table.Random( self.Corpses )
			ragdoll:SetModel( corpse )
			table.RemoveByValue(ZombieTbl, self)
		else
			self:VoiceSound( self.VoiceSounds.Death )			
			local ragdoll = CreateCorpse( self, dmginfo )
			table.RemoveByValue(ZombieTbl, self)
			
			if self:OnFire() then
				umsg.Start( "Burned" )
				umsg.Vector( self:GetPos() )
				umsg.End()
			end
		end
	end
end

function ENT:HandleStuck()
	self:StopMovingToPos()
	self:OnStuck()	
end

function ENT:StuckThink()
end

function ENT:StartRespawn()
	local pos = Vector( math.random( -6000, 6000 ), math.random( -6000, 6000 ), 1800 )
	local tr = util.TraceLine( {
		start = pos, endpos = pos - Vector( 0, 0, 9999 )
	})
	
	if tr.HitWorld then
		self:SetPos(tr.HitPos + Vector( 0, 0, 64 ))
	end
end

function ENT:OnLimbHit( hitgroup, dmginfo )
	if not IsValid( self ) then return end

	if hitgroup == HITGROUP_HEAD then			
		dmginfo:ScaleDamage( 2.75 ) 
    elseif hitgroup == HITGROUP_CHEST then	
		dmginfo:ScaleDamage( 1.25 ) 
	elseif hitgroup == HITGROUP_STOMACH then	
		dmginfo:ScaleDamage( 0.75 ) 				
	else	
		dmginfo:ScaleDamage( 0.50 )
	end
end

function ENT:OnInjured( dmginfo )
	if IsValid( dmginfo:GetAttacker() ) and dmginfo:GetAttacker():GetClass() == "trigger_hurt" then
		local ragdoll = CreateCorpse( self, dmginfo )
		table.RemoveByValue(ZombieTbl, self)
		return
	end

	if dmginfo:IsExplosionDamage() then
		dmginfo:ScaleDamage( 1.75 )
	elseif not self:OnFire() then
	end
		
	if self:Health() > 0 and math.random(1,2) == 1 then
		self:VoiceSound( self.VoiceSounds.Pain )
	end
	self.Agroer = dmginfo:GetAttacker()
end 

function ENT:OnKilled( dmginfo )

	if self.Dying then return end
	self.Dying = true
	self:OnDeath( dmginfo )

	if dmginfo then
		local ent1 = dmginfo:GetAttacker()
		GAMEMODE:OnNPCKilled( self, ent1, dmginfo:GetInflictor() )
		if IsValid( ent1 ) then			
			if dmginfo:IsExplosionDamage() then									
				local ragdoll = CreateCorpse( self, dmginfo )
				local corpse = table.Random( self.Corpses )
				ragdoll:SetModel(corpse)
				table.RemoveByValue(ZombieTbl, self)
			else
				self:VoiceSound( self.VoiceSounds.Death )
				ent:DropMoney( self, 10, 75, 30)
				local ragdoll = CreateCorpse( self, dmginfo )
				table.RemoveByValue(ZombieTbl, self)
				
				if self:OnFire() then
					umsg.Start( "Burned" )
					umsg.Vector( self:GetPos() )
					umsg.End()
				end
			end
		end
	end
end

function ENT:OnDeath( dmginfo ) // override this 
end

function ENT:OnFire()
	return self.FireTime > CurTime()
end

function ENT:DoIgnite( att )
	if self:OnFire() then return end
	
	if IsValid( att ) and att:IsPlayer() then
	
		att:AddStat( "Igniter" )
	
	end
	
	self.FireTime = CurTime() + 5
	self.FireAttacker = att
	self.FireSound = true
end

function ENT:StopFireSounds()
end

function ENT:VoiceSound( tbl )
	if ( self.VoiceTime or 0 ) > CurTime() then return end
	self.VoiceTime = CurTime() + 1.5
	
	local snd = table.Random( tbl )
	sound.Play( snd, self:GetPos() + Vector(0,0,50), 75, ( self.SoundOverride or math.random( 75, 125 ) ), 0.2 )
	
	/*
	if DayZ_NightTime then
		sound.Play( snd, self:GetPos() + Vector(0,0,50), 100, ( self.SoundOverride or math.random( 75, 125 ) ), 0.3 )
	else
		sound.Play( snd, self:GetPos() + Vector(0,0,50), 75, ( self.SoundOverride or math.random( 75, 125 ) ), 0.2 )
	end	*/
end


function ENT:EmitVoiceSound( snd )
	if ( self.VoiceTime or 0 ) > CurTime() then return end
	self.VoiceTime = CurTime() + 1.5
	sound.Play( snd, self:GetPos() + Vector(0,0,50), 75, ( self.SoundOverride or math.random( 75, 125 ) ), 0.2 )
	
	/*if DayZ_NightTime then
		sound.Play( snd, self:GetPos() + Vector(0,0,50), 100, ( self.SoundOverride or math.random( 75, 125 ) ), 0.3 )
	else
		sound.Play( snd, self:GetPos() + Vector(0,0,50), 75, ( self.SoundOverride or math.random( 75, 125 ) ), 0.2 )
	end*/
end

function ENT:StartAttack( enemy )
	self.Stuck = CurTime() + 1
	self.CurAttack = CurTime() + self.AttackTime
	self.CurEnemy = enemy
	
	self:VoiceSound( self.VoiceSounds.Attack )
end

function ENT:OnHitEnemy( enemy )
	enemy:TakeDamage( self.Damage, self )
end

function ENT:OnHitBreakable( ent )

	if not IsValid( ent ) then return end
	if string.find( ent:GetClass(), "func_breakable" ) then			
		ent:TakeDamage( 25, self, self )				
		if ent:GetClass() == "func_breakable_surf" then			
			ent:Fire( "shatter", "1 1 1", 0 )
		end
			
	elseif string.find( ent:GetClass(), "func_door" ) then				
		ent:Remove()			
	else		
		if not ent.Hits then				
			ent.Hits = 1
			ent.MaxHits = math.random(10,20)					
			ent:EmitSound( self.WoodHit )				
		else
			ent.Hits = ent.Hits + 1					
			if ent.Hits > ent.MaxHits then					
				if ent:GetModel() != "models/props_debris/wood_board04a.mdl" then					
					local prop = ents.Create( "prop_physics" )
					prop:SetModel( ent:GetModel() )
					prop:SetPos( ent:GetPos() )
					prop:SetAngles( ent:GetAngles() + Angle( math.random(-10,10), math.random(-5,5), math.random(-5,5) ) )
					prop:SetSkin( ent:GetSkin() )
					prop:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
					prop:Spawn()
							
					--local dir = ( ent:GetPos() - self:GetPos() ):Normalize()
					local phys = prop:GetPhysicsObject()
							
					if IsValid( phys ) then							
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*20000 + Vector(0, 0, 2))
						phys:AddAngleVelocity( VectorRand() * 1600 )
					end
							
					ent:EmitSound( self.WoodBust )					
					ent:SetPos( ent:GetPos() + ent:GetUp()*-800) --Move door underground/out of sights
					
					timer.Simple( math.random(400, 600), function() ent:SetPos( ent:GetPos() + ent:GetUp()*800) ent.Hits = nil end) --Move door up again to 'respawn'
					timer.Simple( 10, function() prop:Remove() end)
					
							
				else						
					ent:Fire( "break", "", 0 )						
				end
			else					
				ent:EmitSound( self.WoodHit )					
			end				
		end		
	end
end

function ENT:BehaveAct() // what does this do?
end

function ENT:CanTarget( v )
	if v:IsPlayer() and v:Alive() and !(v.SafeZone or v.SafeZoneEdge) and !v.Noclip then return true end
	return false
end

ENT.LastFindEnemy = 0
function ENT:FindEnemy()
	-- Search around us for entities
	-- This can be done any way you want eg. ents.FindInCone() to replicate eyesight
	local _ents = ents.FindInBox( self:GetPos()+ Vector(-self.MaxDist, -self.MaxDist, -100), self:GetPos()+Vector(self.MaxDist, self.MaxDist, 100) )
	local enemy = NULL
	-- Here we loop through every entity the above search finds and see if ( it's the one we want
	for k,v in pairs( _ents ) do
		if ( v:IsPlayer() and self:CanTarget(v) ) then
			if v:Crouching() and v:GetPos():Distance(self:GetPos())<= math.random(self.MaxDist/3,self.MaxDist/2) then			
				-- We found one so lets set it as our enemy and return true
				enemy = v
			elseif !v:Crouching() then
				enemy = v
			end
		end
	end	
	-- We found nothing so we will set our enemy as nil ( nothing ) and return false
	return enemy
end

function ENT:CanAttack( ent )
	return IsValid( ent ) and self:CanTarget( ent ) and ent:GetPos():Distance( self:GetPos() ) <= self.MeleeDistance and self:MeleeTrace( ent )
end

function ENT:MeleeTrace( ent )
	local trace = {}
	trace.start = self:GetPos() + Vector(0,0,50)
	trace.endpos = ent:GetPos() + Vector(0,0,50)
	trace.filter = { ent, self }
	
	local tr = util.TraceLine( trace )
	if not tr.Hit then
		return true
	end
	
	if tr.HitWorld or tr.Entity:GetClass() == "prop_door_rotating" or tr.Entity:GetClass() == "func_breakable" or tr.Entity:GetClass() == "func_breakable_surf"	then
		return false
	end
	return true
end

function ENT:CanAttackEnemy( ent )
	if self:CanAttack( ent ) then
		return ent
	end

	for k,v in pairs( ents.FindInBox(self:GetPos()+Vector(-64,-64,-64), self:GetPos()+Vector(64,64,64) ) ) do
		if v:IsPlayer() and self:CanAttack( v ) then
			return v
		end
	end
end

function ENT:GetJumpable()
	local trace = {}
	trace.start = self:GetPos() + Vector(0,0,20)
	trace.endpos = trace.start + self:GetForward() * 128
	trace.filter = self
	
	local tr = util.TraceLine( trace )
	
	if tr.Hit then
		if tr.Entity:IsPlayer() then return false end
		if tr.Entity:IsVehicle() then return false end
		if tr.Entity:IsNPC() then return false end
		return true
	end
end

function ENT:GetBreakable()
	doors = ents.FindByModel( "models/props_debris/wood_board04a.mdl" )	
	doors = table.Add( doors, ents.FindByClass( "prop_door_rotating" ))
	doors = table.Add( doors, ents.FindByClass( "func_breakable*" ) )
	doors = table.Add( doors, ents.FindByClass( "func_door*" ) )	
		
	local remove 
	for k,v in pairs( doors ) do	
		if IsValid( v ) and v:GetPos() != Vector(0,0,0) and v:GetPos():Distance( self:GetPos() ) <= self.BreakableDistance then
			return v		
		end	
	end	
	local trace = {}
	trace.start = self:GetPos() + Vector(0,0,50)
	trace.endpos = trace.start + self:GetForward() * self.BreakableDistance
	trace.filter = self
	
	local tr = util.TraceLine( trace )	
	if table.HasValue( doors, tr.Entity ) then	
		return tr.Entity	
	end
	
	return NULL

end

function ENT:OnStuck()
	local ent = self:GetBreakable()
	
	if IsValid(ent) then
		self.Obstructed = true
	else
		self.Obstructed = false
	end
	
	self.loco:SetDesiredSpeed( self.BumpSpeed )
	self.loco:Jump()
	self.loco:SetDesiredSpeed( self.BumpSpeed )
		
	self:StopMovingToPos()		
	self.loco:ClearStuck()

end

function ENT:OnUnStuck()
	self.Obstructed = false
end

function ENT:BreakableRoutine()

	local ent = self:GetBreakable()			
	while IsValid( ent ) do			
		local anim = table.Random( self.AttackAnims )
		self:StartActivity(ACT_MELEE_ATTACK1)
		coroutine.wait(1)
		self:StartAttack( ent )		
		ent = self:GetBreakable()			
	end

end

function ENT:EnemyRoutine()

	local closest = self:CanAttackEnemy( enemy )
			
	while IsValid( closest ) do		
			self:StartActivity(ACT_MELEE_ATTACK1)
			self:SetPoseParameter("move_x",0.8)
			coroutine.wait(1)
			self:StartAttack( closest )			
		closest = self:CanAttackEnemy( closest )
				
	end

end
function ENT:ListenToSounds( pos, heard)	
	self.SoundPos = pos
	self.HeardSound = heard
end

function ENT:PlayActivity(act)
	if self:GetActivity()~=act then
		self:StartActivity(act)
	end
end

ENT.NextCheckJump = 0
ENT.Jumps = 0
function ENT:RunBehaviour()

    while true do
	
		if self.Agroer then
			self.loco:FaceTowards(self.Agroer:GetPos())
			self:PlayActivity( self.MoveAnim )
			self.loco:SetDesiredSpeed( self.MoveSpeed )
			self.loco:SetAcceleration(120)
			self:MoveToPos(self.Agroer:GetPos())
			self.Agroer = nil
		end
		
		if self.HeardSound == true then	
			self.loco:FaceTowards(self.SoundPos)
			self:PlayActivity( self.MoveAnim )
			self:EmitVoiceSound( "cyb_zombies/alertroar.wav" )
			self.loco:SetDesiredSpeed( self.MoveSpeed )
			self.loco:SetAcceleration(120)
			self:MoveToPos(self.SoundPos)
			self.HeardSound = false
			self.SoundPos = nil
		end
		
		local enemy = self:FindEnemy()
		
		if IsValid(enemy) then		
			self.loco:FaceTowards(enemy:GetPos())
			self:PlayActivity( self.MoveAnim )
			self.loco:SetDesiredSpeed( self.MoveSpeed )
			self.loco:SetAcceleration(120)
			if !self.Alert then
				self:StopMovingToPos()
				self:EmitVoiceSound( "cyb_zombies/alertroar.wav" )
				self.Alert = true
			end
					
			local age = math.Clamp( math.min( enemy:GetPos():Distance( self:GetPos() ), 1000 ) / 1000, 0.2, 1 )
			local opts = { draw = self.ShouldDrawPath, maxage = 2 * age, repath = 1, timeout = .5, tolerance = self.MeleeDistance/2 }--/2
			
			self:MoveToPos( enemy:GetPos(), opts ) 
			self:BreakableRoutine()
			self:EnemyRoutine()
			
		else
			self.Alert = false			
			if math.random(1,100) > 90 then
				self:PlayActivity(ACT_WALK)
				self.loco:SetDesiredSpeed( math.random(self.MoveSpeed/10, self.MoveSpeed/8) ) -- default: self.MoveSpeed/3
				self.loco:SetAcceleration(5)
				self:MoveToPos( self:GetPos() + Vector( math.Rand( -100, 100 ), math.Rand( -100, 100 ), 0 ) * 2 )
			else
				self:PlayActivity(ACT_IDLE)
			end			
		end		

        coroutine.yield()
		
    end
	
end

local _AllowedToMove = true
function ENT:StopMovingToPos( )

	_AllowedToMove = false
	
end	
	
function ENT:MoveToPos( pos, options )

	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 1000 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end
	-- We just called this function so of course we want to move
	_AllowedToMove = true
	-- While the path is still valid and the bot is allowed to move
	while ( path:IsValid() and _AllowedToMove ) do
		path:Update( self )
		-- Draw the path (only visible on listen servers or single player)
		if ( options.draw ) then
			path:Draw()
		end
		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck();
			return "stuck"
		end
		-- If they set maxage on options then make sure the path is younger than it
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end
		-- If they set repath then rebuild the path every x seconds
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end
		coroutine.yield()
	end
	return "ok"
	
end