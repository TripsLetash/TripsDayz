AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.UpdatePhys = 0
ENT.TopRotorOldVel = 0
ENT.TopRotorHealth = 100
ENT.TopRotorDestabilizer = nil
ENT.TopRotor = nil
ENT.TopWasRemoved = false
ENT.TopRotorConstraint = NULL
ENT.TopRotorForce = 300
ENT.RearRotor = nil
ENT.RearWasRemoved = false
ENT.RearRotorConstraint = NULL
ENT.RearRotorForce = 50
ENT.KeepUpRightConstraint = NULL

ENT.LaserSprite = nil
ENT.LaserPos = Vector(0,0,0)
ENT.UseDelay = 0

ENT.LampDel = CurTime() 

--Weapons
ENT.PlyAim = Vector(0,0,0)
ENT.Seats = {}
ENT.SeatPos = {
Vector(28,-14.5,-14),
Vector(28,14.5,-14),
Vector(-10,10,-14),
Vector(-10,-10,-14)
}
ENT.SeatExitPos = {
Vector(28,50,-40),
Vector(28,-50,-40),
Vector(-10,50,-40),
Vector(-10,-50,-40)
}

ENT.StartDelayTime = CurTime()
ENT.StartDelay = 5
ENT.AboutToTurnOn = false
ENT.IsOn = false
ENT.Sounds = {}
ENT.MinorAlarmDel = CurTime()
ENT.LowhealthAlarm = CurTime()
ENT.CrashAlarm = CurTime()

ENT.WashEffect = nil
ENT.PropEvent = 0
ENT.OldVel = 0
ENT.SpeedDelta = 0
ENT.DamageEffect = NULL
ENT.FireEffect = nil
ENT.LightSprite = nil
ENT.RtLight = nil
ENT.LampState = false
ENT.LampPos = Vector(50,0,-40)
--HP
ENT.DrainHpDel = CurTime()
ENT.MaxHP = 300
ENT.HpStage = 0
ENT.Destroyed = false
ENT.SoundDel = CurTime()


--Base
ENT.TopRotorPos = Vector(0,0,50)
ENT.RearRotorPos = Vector(-185,-3,13)
ENT.EngineDefaultPower = 20000
ENT.EnginePower = 15000
ENT.MaxHeightDiff = 200
ENT.WantedHeight = 0
--ENT.YawForce = 2
ENT.YawForce = 4
--ENT.RollForce = 30
ENT.RollForce = 30
--ENT.PitchForce = 10
ENT.PitchForce = 10
--ENT.ForwardForce = 3000
ENT.ForwardForce = 6000
--ENT.RightForce = 1500
ENT.RightForce = 1500
ENT.DefaultMass = 400
ENT.KeepUp = 5

--Base
ENT.TopRotorPos = Vector(0,0,50)
ENT.RearRotorPos = Vector(-185,-3,13)


function ENT:SpawnFunction( ply, tr )

    if ( !tr.Hit ) then return end
    
    local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,100)
    
    local ent = ents.Create( ClassName )
        ent:SetPos( SpawnPos )
    ent:Spawn()
    ent:Activate()
    
    return ent
    
end

function ENT:Initialize()

    if ( SERVER ) then
        
        self.Entity:SetModel("models/military2/air/air_h500.mdl")
        self.Entity:SetOwner(self.Owner)
        self.Entity:PhysicsInit(SOLID_VPHYSICS)
        self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
        self.Entity:SetSolid(SOLID_VPHYSICS)
        
        self.Entity:SetSolid(SOLID_VPHYSICS)    
        local phys = self.Entity:GetPhysicsObject()
        if(phys:IsValid()) then phys:Wake() end
        
        self.Seats = {}
        self.Sounds = {}
        self:GetPhysicsObject():SetMass(self.DefaultMass)
        self:CreateSeats()
        self:CreateRotors()
        self:LoadSounds()
		
		self:SetHealth(300)
        
        self:SetNetworkedBool("IsOn", false)
            
    end
    
end

function ENT:LoadSounds()
    self.Sounds.Start = CreateSound(self.Entity,"HelicopterVehicle/HeliStart.mp3")
    self.Sounds.Stop = CreateSound(self.Entity,"HelicopterVehicle/HeliStop.mp3")
    self.Sounds.Exterior = CreateSound(self.Entity,"HelicopterVehicle/HeliLoopExt.wav")
    self.Sounds.Interior = CreateSound(self.Entity,"HelicopterVehicle/HeliLoopInt.wav")    
    self.Sounds.RotorAlarm = CreateSound(self.Entity,"HelicopterVehicle/MinorAlarm.mp3")
    self.Sounds.LowHealthAlarm = CreateSound(self.Entity,"HelicopterVehicle/LowHealth.mp3")
    self.Sounds.CrashAlarm = CreateSound(self.Entity,"HelicopterVehicle/CrashAlarm.mp3")
    self.Sounds.ShootSound = CreateSound(self.Entity,"HelicopterVehicle/Shooting.mp3")
    self.Sounds.StopShootSound = CreateSound(self.Entity,"HelicopterVehicle/StopShooting.mp3")
end

function ENT:CreateSeats()
    
    for k,v in ipairs(self.SeatPos) do
        self.Seats[k] = ents.Create("prop_vehicle_prisoner_pod")
        self.Seats[k]:SetModel("models/nova/airboat_seat.mdl")
        self.Seats[k]:SetPos(self:GetPos() + (self:GetForward() * self.SeatPos[k].x) + (self:GetRight() * self.SeatPos[k].y) + (self:GetUp() * self.SeatPos[k].z))
        self.Seats[k]:SetAngles(self:GetAngles() + Angle(0,-90,0))
        self.Seats[k].SeatNum = k
        self.Seats[k]:Spawn()
        self.Seats[k]:GetPhysicsObject():EnableGravity(false)
        self.Seats[k]:GetPhysicsObject():SetMass(1)
        self.Seats[k]:SetNotSolid( true )
        self.Seats[k]:GetPhysicsObject():EnableDrag(false)    
        self.Seats[k]:DrawShadow( false )
        self.Seats[k]:SetParent(self.Entity)
        self.Seats[k]:SetKeyValue("limitview","0")
		--self.Seats[k]:SetNoDraw( true )
		self.Seats[k]:SetColor(Color(255,255,255,0))	
		self.Seats[k].IsHeliSeat = true
		self.Seats[k].SeatOwner = self
		self.Seats[k]:SetNetworkedEntity( "AirVehicleParent" , self)
    end
end

function ENT:CreateRotors()

    self.TopRotor = ents.Create( "prop_physics" )
    self.TopRotor:SetModel("models/military2/air/air_h500_r.mdl")        
    self.TopRotor:SetPos(self:GetPos() + (self:GetForward() * self.TopRotorPos.x) + (self:GetRight() * self.TopRotorPos.y) + (self:GetUp() * self.TopRotorPos.z))    
    self.TopRotor:Spawn()
    self.TopRotor:GetPhysicsObject():SetMass(100)
    self.TopRotor:GetPhysicsObject():EnableGravity(false)
	--self.TopRotor:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    
    self.RearRotor = ents.Create( "prop_physics" )
    self.RearRotor:SetModel("models/military2/air/air_h500_sr.mdl")        
    self.RearRotor:SetPos(self.Entity:GetPos() + (self:GetForward() * self.RearRotorPos.x) + (self:GetRight() * self.RearRotorPos.y) + (self:GetUp() * self.RearRotorPos.z) )    
    self.RearRotor:Spawn()        
    self.RearRotor:GetPhysicsObject():SetMass(20)
    self.RearRotor:GetPhysicsObject():EnableDrag(false)
    self.RearRotor:GetPhysicsObject():EnableGravity(false)
	--self.RearRotor:SetCollisionGroup(COLLISION_GROUP_WEAPON)


    self.TopRotorConstraint = constraint.Axis( self.Entity, self.TopRotor, 0, 0, Vector(0,0,-1) , self.TopRotorPos, 0, 0, 0, 1 )
    self.RearRotorConstraint = constraint.Axis( self.Entity, self.RearRotor, 0, 0, Vector(-185,-3,13) , Vector(0,0,0), 0, 0, 1, 1 )
end

-------------------------------------------USE
function ENT:Use( activator, caller )
	activator.LstEntr = activator.LstEntr or 0
	
    if (activator.LstEntr < CurTime() ) and self.Destroyed == false && activator:IsPlayer() then
		self.UseDelay = CurTime() + 1
        
		if !(activator:IsAdmin() or activator:IsUserGroup("vip") or activator:IsUserGroup("vipadmin")) then
			activator:ChatPrint("Only VIPs can fly helicopters. You have been assigned a passenger seat.")
		end
		
		local seatNum = 0
		for k, v in pairs(self.Seats) do
			if IsValid(v) then
				if !(activator:IsAdmin() or activator:IsUserGroup("vip") or activator:IsUserGroup("vipadmin")) and k == 1 then 
					continue 
				end
				
				seatNum = self:GetNextEmptySeat( k, activator )
			end
		end
				
		if seatNum != 0 then
			local eyeAng = activator:GetAimVector():Angle()

			activator:EnterVehicle( self.Seats[seatNum] )   
			activator.LstEntr = CurTime() + 1
			activator.SwapDel = CurTime() + 0.5
			
			activator.AirVeh_ThirdPersonView = false
			activator:SetNetworkedBool( "UseAirVehicleThirdPersonView", 0 )

			eyeAng.r = 0
			local vehAng = activator:GetVehicle():GetAngles()
			vehAng.r = 0
			activator:SetEyeAngles( eyeAng - vehAng )
		end
	end
	
end

-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys )
    ent = data.HitEntity
    local difference = data.OurOldVelocity:Length() - phys:GetVelocity():Length()
    
    
    if difference > 100 then
        local ranSound = math.random(1,4)    
        self:SetHealth(self:Health() - difference / 50)
        
        if difference < 300 then
            self.Entity:EmitSound("vehicles/v8/vehicle_impact_medium"..ranSound..".wav",80,math.random(80,120))
        elseif difference >= 300 then
            self.Entity:EmitSound("vehicles/v8/vehicle_impact_heavy"..ranSound..".wav",80,math.random(80,120))            
        end
        
        
        
        local dmg = difference / 10
        
        for k,v in ipairs(self.Seats) do
            local driver = self.Seats[k]:GetDriver()
            if driver != NULL && IsValid(driver) && driver:InVehicle() then
                local health = driver:Health() - dmg
                driver:Fire("sethealth", ""..health.."", 0)                
            end
        end                
    end
end
-------------------------------------------PHYSICS =D
function ENT:PhysicsUpdate( physics )
    if self.Destroyed == false && self.TopRotorConstraint != NULL then

        //About to get ready
        if self.AboutToTurnOn == true then
            local percent = (1 - ((self.StartDelayTime - CurTime()) / self.StartDelay))
			percent = math.Clamp(percent, 0, 1)
            self.Sounds.Exterior:ChangeVolume(percent * 100, 0)
            self.Sounds.Exterior:ChangePitch(percent * 100, 0)
            self.Sounds.Interior:ChangeVolume(percent * 30, 0)
            self.Sounds.Interior:ChangePitch(percent * 100, 0)            
            self.Sounds.Start:ChangeVolume( 100 - (percent * 100), 0)
            
            self:GetPhysicsObject():ApplyForceCenter(self:GetUp() * self.EngineDefaultPower * percent )
            
            if IsValid(self.TopRotor) then
                self.TopRotor:GetPhysicsObject():AddAngleVelocity( Vector(0,0, (self.TopRotorForce * percent) ) )
            end
            
            if IsValid(self.RearRotor) && self.RearRotorConstraint != NULL then
                self.RearRotor:GetPhysicsObject():AddAngleVelocity( Vector(0, (self.RearRotorForce * percent),0 ) )    
            else
                self:GetPhysicsObject():AddAngleVelocity(Vector(0,0,20 * percent))        
            end            
        end
        
        if self.KeepUpRightConstraint == NULL && self:GetDriver() != nil then
            self.KeepUpRightConstraint = constraint.Keepupright( self.TopRotor, Angle(0,0,0), 0, self.KeepUp )
        elseif self.KeepUpRightConstraint != NULL && self:GetDriver() == nil then
            self.KeepUpRightConstraint:Remove()
            self.KeepUpRightConstraint = NULL
        end

        if self.IsOn == true && self:GetDriver() != nil then

            if !self.Sounds.Exterior:IsPlaying() or self.SoundDel < CurTime() then
                self.Sounds.Exterior:Play()
                self.Sounds.Interior:Play()
                self.SoundDel = CurTime() + 3
            end    
        
            local entphys = self:GetPhysicsObject()
            local driver = self:GetDriver()

			
			
            if     driver:KeyDown( IN_FORWARD ) then
                entphys:AddAngleVelocity( Vector(0,self.PitchForce,0 ) )    
                entphys:ApplyForceCenter( self.Entity:GetForward() * self.ForwardForce )
            end
        
            if     driver:KeyDown( IN_BACK ) then
                entphys:AddAngleVelocity( Vector(0,-self.PitchForce,0 ) )
                entphys:ApplyForceCenter( self.Entity:GetForward() * -self.ForwardForce )            
            end    
            
            if     driver:KeyDown( IN_MOVELEFT ) then
                entphys:AddAngleVelocity( Vector(-self.RollForce,0,self.YawForce ) )
                entphys:ApplyForceCenter( self.Entity:GetRight() * -self.RightForce )    
            elseif driver:KeyDown( IN_MOVERIGHT ) then
                entphys:AddAngleVelocity( Vector(self.RollForce,0,-self.YawForce ) )    
                entphys:ApplyForceCenter( self.Entity:GetRight() * self.RightForce )
            else
                local angVel = entphys:GetAngleVelocity()
                angVel = angVel * -0.05
                entphys:AddAngleVelocity( Vector(0,0,angVel.z ) )
            end        
            
            --Increase throttle
            if driver:KeyDown( IN_JUMP ) then    
                self.WantedHeight = self.WantedHeight + 5
            end

            --Decrease Throttle
            if driver:KeyDown( IN_WALK ) then
                self.WantedHeight = self.WantedHeight - 5
            end    
            
            local curHeight = self:GetPos().z
            local diff = self.WantedHeight - curHeight
            
            if diff > self.MaxHeightDiff then
                self.WantedHeight = curHeight + self.MaxHeightDiff
                diff = self.MaxHeightDiff
            elseif diff < (self.MaxHeightDiff * -1) then
                self.WantedHeight = curHeight - self.MaxHeightDiff
                diff = (self.MaxHeightDiff * -1)        
            end
            
            local pow = diff / self.MaxHeightDiff

            self.Sounds.Exterior:ChangePitch(100 + 20 * pow, 0)
			self.Sounds.Interior:ChangePitch(100 + 20 * pow, 0)

            if pow < 0 then
                pow = pow * pow * -1
            else    
                pow = pow * pow
            end
                
        
            if IsValid(self.TopRotor) && self.TopRotorConstraint != NULL then
                self.TopRotor:GetPhysicsObject():AddAngleVelocity( Vector(0,0, self.TopRotorForce ) )
                
                local force = (self.EngineDefaultPower + self.EnginePower * pow)
                local forceVec = self:GetUp() * force
                local t = 1

                t = force / forceVec.z
                
                if t < 0 then t = -t end                
                if t > 5 then t = 5 end
                
                
                entphys:ApplyForceCenter( self:GetUp() * (self.EngineDefaultPower + self.EnginePower * pow) * t)
            end
            
            if IsValid(self.RearRotor) then
                self.RearRotor:GetPhysicsObject():AddAngleVelocity( Vector(0,self.RearRotorForce,0 ) )
            end    
            
            if !IsValid(self.RearRotor) or self.RearRotorConstraint == NULL then
                entphys:AddAngleVelocity(Vector(0,0,20))
                entphys:ApplyForceCenter( self:GetForward() * 1000)
            end        
        end
        
        if self:GetDriver() != nil then
    
            local driver = self:GetDriver()

            
            --Update lamp
            if self.LampState then
                self:UpdateLamp(driver)
            end            
            


            if self.LampDel < CurTime() and driver:KeyDown( IN_ATTACK )  then
				self.LampDel = CurTime() + 0.5
				if self.LampState then
					self:LampOff()
				else
					self:LampOn()
				end
			end
  
    
        end
    end
end
-------------------------------------------DAMAGE
function ENT:OnTakeDamage(dmg)

	if dmg:GetAttacker():IsPlayer() and dmg:GetAttacker().SafeZoneEdge then return end
	
    local Damage = 0

    if dmg:IsExplosionDamage() then
        Damage = dmg:GetDamage()
    else
        Damage = (dmg:GetDamage()) / 4
    end

    self:SetHealth(self:Health() - Damage)
    self.TopRotorHealth = self.TopRotorHealth - (Damage / 4)

end
-------------------------------------------THINK
ENT.NextFuel = CurTime() + 5
function ENT:Think()
    --self.UpdatePhys = RealTime() + 0.5
    if (SERVER) then
	
	if self.NextFuel < CurTime() then 
		self.NextFuel = CurTime() + 5
		
		if !self.IsOn then return end
		
		if self:GetNWInt("fuel") == 0 then return end
		
		self:SetNWInt("fuel", self:GetNWInt("fuel") - 1)
	end
    
    self:GetPhysicsObject():Wake()
    
    --Fixes so you can't enter the vehicle while trying to exit it.
    for k,v in pairs(self.Seats) do
            local driver = v:GetDriver()
        
        if driver != NULL && IsValid(driver) && driver:InVehicle() then
            driver.LstEntr = CurTime() + 1
        end
    end
    
    --In case a minge unattatches the top rotor we have to fix some settings
    if self.TopRotorConstraint == NULL then
        self:RemoveTopRotor()
    end
    
    if self.RearRotorConstraint == NULL then
        self:RemoveRearRotor()
    end    
	
	if self:GetNWInt("fuel") <= 0 then
		self.IsOn = false 	
		self.AboutToTurnOn = false
	end	

    --Someone is using the helicopter
    if self:GetDriver() != nil && self.Destroyed == false && self.Entity:WaterLevel() <= 1 && self.TopRotorConstraint != NULL then
		self.UseDelay = CurTime() + 1
        //Starting the helicopter
        if self.IsOn == false && self.AboutToTurnOn == false then
            self.StartDelayTime = CurTime() + self.StartDelay
            self.AboutToTurnOn = true
            
            self.Sounds.Start:Play()
            self.Sounds.Exterior:Play()
            self.Sounds.Interior:Play()

            self.Sounds.Stop:Stop()
            self.Sounds.Exterior:ChangeVolume(0, 0)
            self.Sounds.Interior:ChangeVolume(0, 0)
            self.SoundDel = CurTime()
            self:SetNetworkedBool("IsOn", true)
        end
        
        //The helicopter is ready to go
        if self.AboutToTurnOn == true && self.StartDelayTime < CurTime() then
            self.IsOn = true
            self.AboutToTurnOn = false
            self.Sounds.Start:Stop()
            self.WantedHeight = self:GetPos().z
            
            self.WashEffect = ents.Create("env_rotorwash_emitter")
            self.WashEffect:SetPos(self.Entity:GetPos())
            self.WashEffect:SetParent(self.Entity)
            self.WashEffect:Activate()            
        end
        
    else
    
        //Turning it off
        if self.IsOn == true or self.AboutToTurnOn == true then
            self.IsOn = false
            self.AboutToTurnOn = false
            self.StartDelayTime = 0

            self.Sounds.RotorAlarm:Stop()
            self.Sounds.LowHealthAlarm:Stop()
            self.Sounds.CrashAlarm:Stop()            
            self.Sounds.Start:Stop()
            self.Sounds.Exterior:Stop()
            self.Sounds.Interior:Stop()            
            self.Sounds.Stop:Stop()
            self.Sounds.Stop:Play()
            self.Sounds.ShootSound:Stop()
            self:LampOff()
            self:SetNetworkedBool("IsOn", false)
            self.ShouldFire = false
            
            if IsValid( self.WashEffect ) then
                self.WashEffect:Remove()
            end
            
            if IsValid( self.LaserSprite ) then
                self.LaserSprite:Remove()
            end            
            
        end
    end
    
    self:HpAdjustments()
   
    self:CheckSwapToNextSeat()
end
end

function ENT:HpAdjustments()

    --HP adjustments
    --Water is bad. Water will drain the helicopters health
    if self:WaterLevel() > 0 then
        self:SetHealth( self:Health() - 10 )   
    end    
    
    local hpPercent = self:Health() / self.MaxHP
    
    --If the health is below 50 it will start to drain health
    if self.DrainHpDel < CurTime() && hpPercent < 0.3 then
        self.DrainHpDel = CurTime() + 0.5
        self:SetHealth( self:Health() - 2 )
        
        --When the health is below 50 there will be 3 types of events
        --1 Loosing power ( all rotors still on)
        --2 Lost top rotor
        --3 Lost rear rotor
        if self.PropEvent == 0 then
            self.PropEvent = math.random(1,3)

            if self.PropEvent == 1 then
                self.EngineDefaultPower = self.EngineDefaultPower / 2
                self.EnginePower = self.EnginePower / 2            
            elseif self.PropEvent == 2 then
                if self.TopRotorConstraint != NULL then
                    self:RemoveTopRotor()
                end
                
                if self.KeepUpRightConstraint != NULL then
                    self.KeepUpRightConstraint:Remove()
                    self.KeepUpRightConstraint = NULL
                end
            elseif self.PropEvent == 3 then
                if self.RearRotorConstraint != NULL then
                    self:RemoveRearRotor()
                end        
                self.EngineDefaultPower = self.EngineDefaultPower / 2
                self.EnginePower = self.EnginePower / 2                        
            end
            
        end        
    end    

    --Using the top rotor speed delta to detect if it hit something
    if self.IsOn == true && IsValid(self.TopRotor) && IsValid( self.TopRotorConstraint ) then
        local SpeedD = ( self.TopRotor:GetPhysicsObject():GetAngleVelocity():Length() ) - self.TopRotorOldVel
        self.TopRotorOldVel = self.TopRotor:GetPhysicsObject():GetAngleVelocity():Length()
        
        if SpeedD > -1500 and SpeedD < -300 then
            self.Entity:EmitSound("physics/metal/metal_box_impact_bullet"..math.random(1,3)..".wav")

			self:SetHealth(self:Health() - 20)
			self.TopRotorHealth = self.TopRotorHealth - 10
		end    
    end

    if IsValid(self.TopRotor) && self.TopRotorConstraint != NULL && self.TopRotorHealth < 50 then
        local mass = 60 * (1 - (self.TopRotorHealth / 60))
        
        --Creating the destabilizer prop if it doesn't excist
        if !IsValid(self.TopRotorDestabilizer) then
            self.TopRotorDestabilizer = ents.Create( "prop_physics" )
            self.TopRotorDestabilizer:SetModel("models/props_junk/PopCan01a.mdl")        
            self.TopRotorDestabilizer:SetPos(self.TopRotor:GetPos() + (self.TopRotor:GetRight() * 100))    
            self.TopRotorDestabilizer:SetRenderMode(1)
            self.TopRotorDestabilizer:SetColor(Color(255,255,255,0))
            self.TopRotorDestabilizer:Spawn()
            constraint.Weld( self.TopRotor, self.TopRotorDestabilizer, 0, 0, 0, true )
        end
        
        self.TopRotorDestabilizer:GetPhysicsObject():SetMass(mass)

        if self.IsOn == true && self.MinorAlarmDel < CurTime() then
            self.Sounds.RotorAlarm:Stop()
            self.Sounds.RotorAlarm:Play()
            self.MinorAlarmDel = CurTime() + 14
        end
        
    end
    
    --Releasing the top rotor
    if self.TopRotorHealth <= 10 && IsValid(self.TopRotor) && self.TopRotorConstraint != NULL then
        self:RemoveTopRotor()
    end        
	
	
	if self.DrainHpDel < CurTime() and self.TopRotorConstraint == NULL then
		self.DrainHpDel = CurTime() + 0.5
		self:SetHealth( self:Health() - 2 )
	end
    
    --If the hp is below 50 we will damage the player is the heli collides with something
    if hpPercent < 0.2 then

        local CurSpeed = self:GetPhysicsObject():GetVelocity():Length()
        self.SpeedDelta = self.OldVel - CurSpeed
        self.OldVel = CurSpeed
    
        if self.SpeedDelta > 300 then
    
            local dmg = self.SpeedDelta / 10
            
            for k,v in ipairs(self.Seats) do
                local driver = self.Seats[k]:GetDriver()
                if driver != NULL && IsValid(driver) && driver:InVehicle() then
                    local health = driver:Health() - dmg
                    driver:Fire("sethealth", ""..health.."", 0)                
                end
            end            
        end
    end
    
    --HP Effects
    if hpPercent < 0.7 && self.HpStage == 0 then
        self.HpStage = 1
        self:PrepareSmokeEffect()
        self.DamageEffect:SetKeyValue("rendercolor", "170 170 170")
        self.DamageEffect:Spawn()
        self.DamageEffect:SetParent(self.Entity)
        self.DamageEffect:Activate()
    elseif hpPercent < 0.35 && self.HpStage == 1 then
        self.HpStage = 2
        self:PrepareSmokeEffect()
        self.DamageEffect:SetKeyValue("rendercolor", "10 10 10")
        self.DamageEffect:Spawn()
        self.DamageEffect:SetParent(self.Entity)
        self.DamageEffect:Activate()    
    elseif hpPercent < 0.17 && self.HpStage == 2 then
        self.HpStage = 3
        
        self.DamageEffect:Remove()
        self.DamageEffect = NULL
            
        self.FireEffect = ents.Create( "env_fire_trail" )
        self.FireEffect:SetPos(self:GetPos() + (self:GetUp() * 30) + (self:GetForward() * -60))
        self.FireEffect:Spawn()
        self.FireEffect:SetParent(self.Entity)        
    end


    
    
    
    --The helicopter is destroyed
    if self.Destroyed == false && self:Health() <= 0 then
        self.Destroyed = true
        self.HpStage = 0
        
        
        --Killing all users
        for k,v in ipairs(self.Seats) do
            local driver = self.Seats[k]:GetDriver()
            if driver != NULL && IsValid(driver) && driver:InVehicle() then
                driver:ExitVehicle()
                driver:Kill()
            end
        end        
        
        local expl = ents.Create("env_explosion")
        expl:SetKeyValue("spawnflags",128)
        expl:SetPos(self.Entity:GetPos())
        expl:Spawn()
        expl:Fire("explode","",0)
    
        local FireExp = ents.Create("env_physexplosion")
        FireExp:SetPos(self.Entity:GetPos())
        FireExp:SetParent(self.Entity)
        FireExp:SetKeyValue("magnitude", 500)
        FireExp:SetKeyValue("radius", 500)
        FireExp:SetKeyValue("spawnflags", "1")
        FireExp:Spawn()
        FireExp:Fire("Explode", "", 0)
        FireExp:Fire("kill", "", 5)
        util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 500, 500)  

		timer.Simple(10, function()
		    local expl = ents.Create("env_explosion")
			expl:SetKeyValue("spawnflags",128)
			expl:SetPos(self.Entity:GetPos())
			expl:Spawn()
			expl:Fire("explode","",0)
		
			local FireExp = ents.Create("env_physexplosion")
			FireExp:SetPos(self.Entity:GetPos())
			FireExp:SetParent(self.Entity)
			FireExp:SetKeyValue("magnitude", 500)
			FireExp:SetKeyValue("radius", 500)
			FireExp:SetKeyValue("spawnflags", "1")
			FireExp:Spawn()
			FireExp:Fire("Explode", "", 0)
			FireExp:Fire("kill", "", 5)
			util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 500, 500)   
		
			self:Remove()
		end)
		
    end
    
    --Sound:IsPlaying() not workign!?
    if self.IsOn == true && self.HpStage >= 3 && self.CrashAlarm < CurTime() then
        self.Sounds.CrashAlarm:Stop()
        self.Sounds.CrashAlarm:Play()
        self.CrashAlarm = CurTime() + 15
    end
    
    if self.IsOn == true && self.HpStage >= 2 && self.LowhealthAlarm < CurTime() then
        self.Sounds.LowHealthAlarm:Stop()
        self.Sounds.LowHealthAlarm:Play()
        self.LowhealthAlarm = CurTime() + 4
    end    

end

function ENT:OnRemove()
   
    for k,v in ipairs(self.Seats) do
        local driver = v:GetDriver()
        if driver != NULL && IsValid(driver) && driver:InVehicle() then
            driver:ExitVehicle( v )
        end
    end       
	
	TotalVehiclesHeli = TotalVehiclesHeli - 1
    
    for k,v in ipairs(self.Seats) do
        if IsValid(v) then
            v:Remove()
        end
    end
    
    if IsValid(self.TopRotor) then
        self.TopRotor:Remove()
    end

    if IsValid(self.RearRotor) then
        self.RearRotor:Remove()
    end

    if IsValid(self.TopRotorDestabilizer) then
        self.TopRotorDestabilizer:Remove()
    end    

    for k,v in pairs(self.Sounds) do
        v:Stop()
    end
    
    if IsValid( self.LaserSprite ) then
        self.LaserSprite:Remove()
    end    
    
end

function ENT:HasDriver()

    local driver = self.Seats[1]:GetDriver()
    if driver != NULL && IsValid(driver) && driver:InVehicle() && (driver:IsAdmin() or driver:IsUserGroup("vip") or driver:IsUserGroup("vipadmin")) then
        return true
    end
    
    return false
end

function ENT:GetDriver()

    if IsValid(self.Seats[1]) then
        local driver = self.Seats[1]:GetDriver()
        
        if driver != NULL && IsValid(driver) && driver:InVehicle() && (driver:IsAdmin() or driver:IsUserGroup("vip") or driver:IsUserGroup("vipadmin")) then
            return driver
        end    
    end
    return nil
end

function ENT:GetNextEmptySeat( start, ply )

	for i = start, (4 + start) do
		local slot = i % (4 + 1)
		
		if !(ply:IsAdmin() or ply:IsUserGroup("vip") or ply:IsUserGroup("vipadmin")) and slot == 1 then slot = slot + 1 end
		
		if slot != 0 && IsValid( self.Seats[slot] ) && self.Seats[slot]:GetDriver() == NULL then
			return slot
		end
	end

	return 0	
end

function ENT:CheckSwapToNextSeat()

    for k,v in pairs(self.Seats) do
        if IsValid(v) then
            local driver = self.Seats[k]:GetDriver()
            if driver != NULL && IsValid(driver) && driver:InVehicle() then
			
	
				self:CheckForViewChange( driver )		
	
				if driver:KeyDown( IN_ATTACK2 ) and driver.SwapDel < CurTime() then
					driver.SwapDel = CurTime() + 0.5  
					
					local seatNum = self:GetNextEmptySeat( k, driver )
										
					if seatNum != 0 then
						local eyeAng = driver:GetAimVector():Angle()
						driver:ExitVehicle()
						driver:EnterVehicle( self.Seats[seatNum] )   
						eyeAng.r = 0
						local vehAng = driver:GetVehicle():GetAngles()
						vehAng.r = 0
						driver:SetEyeAngles( eyeAng - vehAng )
					end
				end
            end
        end
    end

end



function ENT:PrepareSmokeEffect()
    
    if self.DamageEffect != NULL then
        self.DamageEffect:Remove()
    end    
    
    self.DamageEffect = ents.Create("env_smokestack")
    self.DamageEffect:SetPos(self:GetPos() + (self:GetUp() * 30) + (self:GetForward() * -60))
    self.DamageEffect:SetKeyValue("InitialState", "1")
    self.DamageEffect:SetKeyValue("WindAngle", "0 0 0")
    self.DamageEffect:SetKeyValue("WindSpeed", "0")
    self.DamageEffect:SetKeyValue("rendercolor", "170 170 170")
    self.DamageEffect:SetKeyValue("renderamt", "170")
    self.DamageEffect:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
    self.DamageEffect:SetKeyValue("BaseSpread", "10")
    self.DamageEffect:SetKeyValue("SpreadSpeed", "5")
    self.DamageEffect:SetKeyValue("Speed", "100")
    self.DamageEffect:SetKeyValue("StartSize", "50")
    self.DamageEffect:SetKeyValue("EndSize", "10" )
    self.DamageEffect:SetKeyValue("roll", "10" )
    self.DamageEffect:SetKeyValue("Rate", "10" )
    self.DamageEffect:SetKeyValue("JetLength", "50" )
    self.DamageEffect:SetKeyValue("twist", "5" )
end

function ENT:RemoveTopRotor()

    if self.TopWasRemoved == false then
        self.TopWasRemoved = true
        
        if IsValid(self.TopRotor) then
            self.TopRotor:GetPhysicsObject():EnableGravity(true)
        end
        
        if self.TopRotorConstraint != NULL then
            self.TopRotorConstraint:Remove()
        end
        
        if IsValid(self.TopRotorDestabilizer) then
            self.TopRotorDestabilizer:Remove()
        end        
    end
end

function ENT:RemoveRearRotor()

    if self.RearWasRemoved == false then
        self.RearWasRemoved = true
        
        if IsValid(self.RearRotor) then
            self.RearRotor:GetPhysicsObject():EnableGravity(true)
        end
        
        if self.RearRotorConstraint != NULL then
            self.RearRotorConstraint:Remove()
        end
        
    end
end


function ENT:UpdateLamp(ply)
    if IsValid( self.RtLight ) then
    
    self.PlyAim = ply:GetAimVector()
    local entDir = self.Entity:GetForward()
    
        //Limiting the angles when using the turret
        
        if self.PlyAim.z > (entDir.z + 0.2) then
            self.PlyAim.z = entDir.z + 0.2
        end
        
        if self.PlyAim.y > (entDir.y + 0.8) then
            self.PlyAim.y = (entDir.y + 0.8)
        end
        
        if self.PlyAim.y < (entDir.y - 0.8) then
            self.PlyAim.y = (entDir.y - 0.8)
        end

        if self.PlyAim.x > (entDir.x + 0.8) then
            self.PlyAim.x = (entDir.x + 0.8)
        end
        
        if self.PlyAim.x < (entDir.x - 0.8) then
            self.PlyAim.x = (entDir.x - 0.8)
        end
        
        self.RtLight:SetAngles( self.PlyAim:Angle() )
    end
end

function ENT:UpdateLaser(ply, bounds)
    if !IsValid( self.LaserSprite ) then
        self.LaserSprite = ents.Create("env_sprite");
        self.LaserSprite:SetPos( self:GetPos() );
        self.LaserSprite:SetKeyValue( "renderfx", "14" )
        self.LaserSprite:SetKeyValue( "model", "sprites/glow1.vmt")
        self.LaserSprite:SetKeyValue( "scale","0.5")
        self.LaserSprite:SetKeyValue( "spawnflags","1")
        self.LaserSprite:SetKeyValue( "angles","0 0 0")
        self.LaserSprite:SetKeyValue( "rendermode","9")
        self.LaserSprite:SetKeyValue( "renderamt","255")
        self.LaserSprite:SetKeyValue( "rendercolor", "255 0 0" )                
        self.LaserSprite:Spawn()
    end            

    self.PlyAim = ply:GetAimVector()
    local entDir = self.Entity:GetForward()
    
    //Limiting the angles when using the turret
	if bounds then
		if self.PlyAim.z > entDir.z then
			self.PlyAim.z = entDir.z
		end
		
		if self.PlyAim.y > (entDir.y + 0.6) then
			self.PlyAim.y = (entDir.y + 0.6)
		end
		
		if self.PlyAim.y < (entDir.y - 0.6) then
			self.PlyAim.y = (entDir.y - 0.6)
		end

		if self.PlyAim.x > (entDir.x + 0.6) then
			self.PlyAim.x = (entDir.x + 0.6)
		end
		
		if self.PlyAim.x < (entDir.x - 0.6) then
			self.PlyAim.x = (entDir.x - 0.6)
		end
	end
    
    local trace = {}
    trace.start = self.Entity:GetPos() + ( self.Entity:GetForward() * 60 ) + ( self.Entity:GetUp() * -30 )  
    trace.endpos = trace.start + (self.PlyAim * 50000)
    trace.filter = { self, self.TopRotor, self.RearRotor, self.Seats }
    local tr = util.TraceLine( trace )

	self.LaserPos = tr.HitPos
    self.LaserSprite:SetPos( self.LaserPos )
end

function ENT:LampOn()

    self.LampState = true
    self:EmitSound("buttons/button1.wav")
    
    if IsValid( self.LightSprite ) then
        self.LightSprite:Remove()
    end
    
    if IsValid( self.RtLight ) then
        self.RtLight:Remove()
    end
        
    self.LightSprite = ents.Create("env_sprite")
    self.LightSprite:SetParent( self )    
    self.LightSprite:SetLocalPos( self.LampPos  )    
    self.LightSprite:SetKeyValue( "renderfx", "14" )
    self.LightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
    self.LightSprite:SetKeyValue( "scale","1.0")
    self.LightSprite:SetKeyValue( "spawnflags","1")
    self.LightSprite:SetKeyValue( "angles","0 0 0")
    self.LightSprite:SetKeyValue( "rendermode","9")
    self.LightSprite:SetKeyValue( "renderamt", "255")
    self.LightSprite:SetKeyValue( "rendercolor", "240 240 170" )                
    self.LightSprite:Spawn()
    

    self.RtLight = ents.Create( "env_projectedtexture" )
    self.RtLight:SetParent( self )
    self.RtLight:SetLocalPos( self.LampPos  )
    self.RtLight:SetLocalAngles( Angle(10,0,0) )
    self.RtLight:SetKeyValue( "enableshadows", 1 )
    self.RtLight:SetKeyValue( "LightWorld", 1 )        
    self.RtLight:SetKeyValue( "farz", 4096 )
    self.RtLight:SetKeyValue( "nearz", 4 )
    self.RtLight:SetKeyValue( "lightfov", 25 )
    self.RtLight:SetKeyValue( "lightcolor", "255 255 255" )
    self.RtLight:Spawn()
    self.RtLight:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )                
end

function ENT:LampOff()

    if self.LampState == true then
        self:EmitSound("buttons/lightswitch2.wav")
    end

    self.LampState = false
    
    
    if IsValid( self.LightSprite ) then
        self.LightSprite:Remove()
    end
    
    if IsValid( self.RtLight ) then
        self.RtLight:Remove()
    end        
end

function ENT:Shoot(BulletNum,Origin,Dir,Spread,GunUser)

    // Make a muzzle flash
    local effectdata = EffectData()
    effectdata:SetOrigin( Origin )
    effectdata:SetAngles( Dir:Angle() )
    effectdata:SetScale( 1 )
    util.Effect( "MuzzleEffect", effectdata )


    // Shoot a bullet
    local bullet = {}
        bullet.Num             = BulletNum
        bullet.Src             = Origin
        bullet.Dir             = Dir
        bullet.Spread         = Spread
        bullet.Tracer        = 1
        bullet.TracerName    = "Tracer"
        bullet.Force        = 10
        bullet.Damage        = 30
        bullet.Attacker     = GunUser        
    self.Entity:FireBullets( bullet )
end

function ENT:KillGuidedMissile()
	self.GuidedMissile = NULL
	self.IsGuiding = false
	self.GuidedCurDelay = CurTime() + self.GuidedDelay		
end


function ENT:CheckForViewChange( ply )
	if ply:KeyDown( IN_RELOAD ) and (ply.AirVeh_ThirdPersonViewDel == nil or ply.AirVeh_ThirdPersonViewDel < CurTime()) then
		ply.AirVeh_ThirdPersonViewDel = CurTime() + 0.5
		if ply.AirVeh_ThirdPersonView then
			ply.AirVeh_ThirdPersonView = false
			ply:SetNetworkedBool( "UseAirVehicleThirdPersonView", 0)	
		else
			ply.AirVeh_ThirdPersonView = true
			ply:SetNetworkedBool( "UseAirVehicleThirdPersonView", 1)
		end
	end		
end