CarSpawns = {}
HeliSpawns = {}

CarSpawns["dz_tripstown_necro_forest"] = {
	--Vector(4657,1725,0)
	/*Vector(8569,12308,0),
	Vector(12200,-7890,-4),*/
}

HeliSpawns["dz_tripstown_necro_forest"] = {
	Vector(-627,215,272)
}

TotalVehicles = TotalVehicles or 0
TotalVehiclesHeli = TotalVehiclesHeli or 0

function AddCars()
	print("Calling InitPostEntity->Car Creation!")
	
	timer.Create( "Car_Respawn", 60, 0, function()
		if TotalVehicles < 4 then
			local pos = table.Random(CarSpawns[string.lower(game.GetMap())])

			SpawnCar(pos)
		end
	end)
	
	timer.Create( "Heli_Respawn", 5, 0, function()	
		if TotalVehiclesHeli == 0 then
			SpawnHelicopter(table.Random(HeliSpawns[string.lower(game.GetMap())]),Angle(0,90,0))
		end		
	end)
	
end

hook.Add("InitPostEntity", "CarLoad", AddCars)

function SpawnHelicopter(Location,HAngle)
	
	--MsgAll("Creating a Helicopter!")

	local HeliCopter = ents.Create("sent_sakariashelicopter")
	HeliCopter:SetPos(Location)
	HeliCopter:SetAngles(HAngle)
	HeliCopter:Spawn()
	TotalVehiclesHeli = TotalVehiclesHeli + 1
	
	HeliCopter.Seats[1].FuelCheck = 0				
			
	HeliCopter.Seats[1].Think = function()
				if HeliCopter.Seats[1].FuelCheck <= CurTime() then
					GAMEMODE:DoFuelCheck(HeliCopter.Seats[1])
				end
				if HeliCopter:IsValid() then
					timer.Simple(1,function() 
						if HeliCopter.Seats[1]:IsValid() then 
							HeliCopter.Seats[1]:Think() 
						end 
					end)
				end
			end			
	HeliCopter.Seats[1]:Think() 		
		
end


function SpawnCar(Location)
	/*local foundcar = false
	
	for k, v in pairs( ents.FindInBox( Location+Vector(100, 100, 100), Location-Vector(100, 100, 100) ) ) do
		if v:IsVehicle() then 
			foundcar = true
		end
	end
	
	if foundcar then return end		
	
	--MsgAll("Creating a Car!")
	
	local TheCar = ents.Create( "prop_vehicle_jeep_old" )
	TheCar:SetModel( "models/buggy.mdl" )
	TheCar.MaxHP = 100
	TheCar.HpStage = 0
	TheCar.DamageEffect = NULL
	TheCar.FireEffect = nil
	TheCar:SetKeyValue( "vehiclescript", "scripts/vehicles/jeep_test.txt" )		
	TheCar:SetPos( Location )		
	TheCar:SetHealth(TheCar.MaxHP)
	TheCar:SetNWInt("fuel", 0)
	
	TheCar.Seats = {}
	TheCar.Seats2 = {}
	
	TheCar.FrontSeatPos = {
		Vector(-35,20,20),
	}
	
	TheCar.BackSeatPos = {
		Vector(-110,10,20),
		Vector(-110,-10,20),
	}
	
	
	for k,v in ipairs(TheCar.FrontSeatPos) do
		TheCar.Seats[k] = ents.Create("prop_vehicle_prisoner_pod")
		TheCar.Seats[k]:SetModel("models/nova/jeep_seat.mdl")
		TheCar.Seats[k]:SetPos(TheCar:GetPos() + (TheCar:GetForward() * TheCar.FrontSeatPos[k].x) + (TheCar:GetRight() * TheCar.FrontSeatPos[k].y) + (TheCar:GetUp() * TheCar.FrontSeatPos[k].z))
		TheCar.Seats[k]:SetAngles(TheCar:GetAngles() + Angle(0,0,0))
		TheCar.Seats[k].SeatNum = k
		TheCar.Seats[k]:Spawn()
		TheCar.Seats[k]:GetPhysicsObject():EnableGravity(false)
		TheCar.Seats[k]:GetPhysicsObject():SetMass(1)
		TheCar.Seats[k]:SetNotSolid( false )
		TheCar.Seats[k]:GetPhysicsObject():EnableDrag(false)    
		TheCar.Seats[k]:DrawShadow( false )
		TheCar.Seats[k]:SetParent(TheCar)
		TheCar.Seats[k]:SetKeyValue("limitview","0")
		--TheCar.Seats[k]:SetNoDraw( true )
		TheCar.Seats[k]:SetColor(Color(255,255,255,0))	
	end
	
	for k,v in ipairs(TheCar.BackSeatPos) do
		TheCar.Seats2[k] = ents.Create("prop_vehicle_prisoner_pod")
		TheCar.Seats2[k]:SetModel("models/nova/jeep_seat.mdl")
		TheCar.Seats2[k]:SetPos(TheCar:GetPos() + (TheCar:GetForward() * TheCar.BackSeatPos[k].x) + (TheCar:GetRight() * TheCar.BackSeatPos[k].y) + (TheCar:GetUp() * TheCar.BackSeatPos[k].z))
		TheCar.Seats2[k]:SetAngles(TheCar:GetAngles() + Angle(0,180,0))
		TheCar.Seats2[k].SeatNum = k
		TheCar.Seats2[k].DriveBy = true
		TheCar.Seats2[k]:Spawn()
		TheCar.Seats2[k]:GetPhysicsObject():EnableGravity(false)
		TheCar.Seats2[k]:GetPhysicsObject():SetMass(1)
		TheCar.Seats2[k]:SetNotSolid( false )
		TheCar.Seats2[k]:GetPhysicsObject():EnableDrag(false)    
		TheCar.Seats2[k]:DrawShadow( false )
		TheCar.Seats2[k]:SetParent(TheCar)
		TheCar.Seats2[k]:SetKeyValue("limitview","0")
		--TheCar.Seats[k]:SetNoDraw( true )
		TheCar.Seats2[k]:SetColor(Color(255,255,255,0))	
	end

	TheCar:Spawn()
	TheCar:Activate()
	TotalVehicles = TotalVehicles + 1
		
	TheCar.FuelCheck = 0	

	TheCar.PrepareSmokeEffect = function()
    
		if TheCar.DamageEffect != NULL then
			TheCar.DamageEffect:Remove()
		end    
		
		TheCar.DamageEffect = ents.Create("env_smokestack")
		TheCar.DamageEffect:SetPos(TheCar:GetPos() + (TheCar:GetUp() * 30) + (TheCar:GetForward() * -60))
		TheCar.DamageEffect:SetKeyValue("InitialState", "1")
		TheCar.DamageEffect:SetKeyValue("WindAngle", "0 0 0")
		TheCar.DamageEffect:SetKeyValue("WindSpeed", "0")
		TheCar.DamageEffect:SetKeyValue("rendercolor", "170 170 170")
		TheCar.DamageEffect:SetKeyValue("renderamt", "170")
		TheCar.DamageEffect:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
		TheCar.DamageEffect:SetKeyValue("BaseSpread", "10")
		TheCar.DamageEffect:SetKeyValue("SpreadSpeed", "5")
		TheCar.DamageEffect:SetKeyValue("Speed", "100")
		TheCar.DamageEffect:SetKeyValue("StartSize", "50")
		TheCar.DamageEffect:SetKeyValue("EndSize", "10" )
		TheCar.DamageEffect:SetKeyValue("roll", "10" )
		TheCar.DamageEffect:SetKeyValue("Rate", "10" )
		TheCar.DamageEffect:SetKeyValue("JetLength", "50" )
		TheCar.DamageEffect:SetKeyValue("twist", "5" )
	end	
	
		
	TheCar.Think = function()
		if TheCar:WaterLevel() > 1 then
			TheCar:SetHealth(TheCar:Health() - 5)
		end
		
		local hpPercent = TheCar:Health() / TheCar.MaxHP
							
		--HP Effects
		if hpPercent >= 0.7 then
			TheCar.HpStage = 0							
		elseif hpPercent < 0.7 and hpPercent >= 0.35 then
			TheCar.HpStage = 1
		elseif hpPercent < 0.35 and hpPercent >= 0.17 then
			TheCar.HpStage = 2
		elseif hpPercent < 0.17 then
			TheCar.HpStage = 3
		end						
		
		if TheCar.HpStage == 0 then
			if IsValid(TheCar.DamageEffect) then
				TheCar.DamageEffect:Remove()
				TheCar.DamageEffect = NULL
			end
		elseif TheCar.HpStage == 1 and !IsValid(TheCar.DamageEffect) then
			TheCar:PrepareSmokeEffect()
										
			TheCar.DamageEffect:SetKeyValue("rendercolor", "170 170 170")
			TheCar.DamageEffect:Spawn()
			TheCar.DamageEffect:SetParent(TheCar.Entity)
			TheCar.DamageEffect:Activate()
		elseif TheCar.HpStage == 2 then
	
			TheCar.DamageEffect:SetKeyValue("rendercolor", "10 10 10")

		elseif TheCar.HpStage == 3 and !IsValid(TheCar.FireEffect) then							
			if IsValid(TheCar.DamageEffect) then
				TheCar.DamageEffect:Remove()
				TheCar.DamageEffect = NULL
			end
				
			TheCar.FireEffect = ents.Create( "env_fire_trail" )
			TheCar.FireEffect:SetPos(TheCar:GetPos() + (TheCar:GetUp() * 30) + (TheCar:GetForward() * -60))
			TheCar.FireEffect:Spawn()
			TheCar.FireEffect:SetParent(TheCar.Entity)        
		end
		
		if TheCar.HpStage == 3 then	
			TheCar:SetHealth(TheCar:Health() - 2)
		end
		
		if TheCar:Health() <= 0 then 
			TheCar:Fire("turnoff", "", 0)										
			CarExplode(TheCar)
			TheCar:Remove()
		end
		

		if TheCar.FuelCheck <= CurTime() then
			GAMEMODE:DoFuelCheck(TheCar)
		end	
							
		timer.Simple(1,function() if TheCar:IsValid() then TheCar:Think() end end)
	end
	TheCar:Think() */		
end

function CarExplode(Car)

	local OwnerEnt = Car
	if IsValid(Car:GetDriver()) then
		OwnerEnt = Car:GetDriver()
	end
	
	local effectdata = EffectData()
	effectdata:SetOrigin( Car:GetPos() )
	util.Effect( "HelicopterMegaBomb", effectdata )	 -- Big flame
	
	local explo = ents.Create( "env_explosion" )
		explo:SetOwner( OwnerEnt )
		explo:SetPos( Car:GetPos() )
		explo:SetKeyValue( "iMagnitude", "150" )
		explo:Spawn()
		explo:Activate()
		explo:Fire( "Explode", "", 0 )
	
	util.BlastDamage(OwnerEnt, Car.Entity, Car:GetPos(), 250, 250)

	local shake = ents.Create( "env_shake" )
		shake:SetOwner( OwnerEnt )
		shake:SetPos( Car:GetPos() )
		shake:SetKeyValue( "amplitude", "2000" )	-- Power of the shake
		shake:SetKeyValue( "radius", "900" )	-- Radius of the shake
		shake:SetKeyValue( "duration", "2.5" )	-- Time of shake
		shake:SetKeyValue( "frequency", "255" )	-- How har should the screenshake be
		shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
		shake:Spawn()
		shake:Activate()
		shake:Fire( "StartShake", "", 0 )
	
	local ar2Explo = ents.Create( "env_ar2explosion" )
		ar2Explo:SetOwner( OwnerEnt )
		ar2Explo:SetPos( Car:GetPos() )
		ar2Explo:Spawn()
		ar2Explo:Activate()
		ar2Explo:Fire( "Explode", "", 0 )

	TotalVehicles = TotalVehicles - 1
end

function OEnterVehicle( Player, Vehicle )
	if Vehicle:IsVehicle() then
		if Player:IsVIP() and Vehicle.DriveBy then
			Player:SetAllowWeaponsInVehicle(true)
		else
			Player:SetAllowWeaponsInVehicle(false)
		end
	end
end
hook.Add("PlayerUse", "GetInCar", OEnterVehicle);

function GM:DoFuelCheck(Vehicle)
	if Vehicle.FuelCheck <= CurTime() then
		local speed = 0
		if Vehicle:GetParent():IsValid() then
			speed = math.Round( (( Vehicle:GetParent():OBBCenter() - Vehicle:GetParent():GetVelocity() ):Length() / 17.6 )/2)		
		else
			speed = math.Round( (( Vehicle:OBBCenter() - Vehicle:GetVelocity() ):Length() / 17.6 )/2)
		end
		if speed > 5 then 
			if Vehicle:GetDriver():IsPlayer() == true then
				Vehicle:SetNWInt("fuel", Vehicle:GetNWInt("fuel") - math.Round(speed)/60)
				if Vehicle:GetNWInt("fuel") <= 0 then
					Vehicle:Fire("turnoff", "", 0)
					Vehicle:SetNWInt("fuel", 0)
				end
				Vehicle.FuelCheck = CurTime() + 1
			end
		end
	end
end	 

function EnteredVehicleJ( player, vehicle, role )
	MsgAll(player:Nick().." got in a vehicle!")
	if vehicle:GetNWInt("fuel") == 0 then 
		vehicle:Fire("turnoff", "", 0)
	elseif vehicle:GetNWInt("fuel") > 0 then
		vehicle:Fire("turnon", "", 0)
	end	
end 

hook.Add( "PlayerEnteredVehicle", "EnteredVehicleJ", EnteredVehicleJ );