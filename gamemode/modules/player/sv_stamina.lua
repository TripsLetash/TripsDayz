function PMETA:GiveStamina(num)
	local Stamina = self:GetNWInt("Stamina")
	self:SetNWInt("Stamina", Stamina + num)
	if ( Stamina + num ) > 100 then
		self:SetNWInt("Stamina", 100)
	end
end

function PMETA:TakeStamina(num)
	local Stamina = self:GetNWInt("Stamina")
	self:SetNWInt("Stamina", Stamina - num )
	if ( Stamina - num ) < 1 then
		self:SetNWInt("Stamina", 0)
	end
end

function PMETA:SetStamina(num)
	self:SetNWInt("Stamina", num)
end

function PMETA:GetStamina()
	return self:GetNWInt("Stamina")
end

function SprintDecay(ply, data)
	if ply:KeyPressed(IN_JUMP) && ply:OnGround() then
		ply:TakeStamina(5)
	end
	
	if ply:KeyDown(IN_SPEED) && ply:OnGround() then
		if math.abs(data:GetForwardSpeed()) > 0 || math.abs(data:GetSideSpeed()) > 0 then
			data:SetMoveAngles(data:GetMoveAngles())
			
			if data:GetSideSpeed() > 0 or data:GetSideSpeed() < 0 then
			
			end
			
			if ply:GetStamina() > 0 then
				ply:SetRunSpeed( 350 )
			else
				--data:SetForwardSpeed(-100)
				if ply.KenyanLegs then
					ply:SetRunSpeed( 280 )
				else
					ply:SetRunSpeed( 250 )
				end
			end
			
			if ply:GetStamina() > 0 && ply.ChargeInt <= CurTime() && ply.Perk1 == true  then
				ply:TakeStamina(1)
				ply.ChargeInt = CurTime() + 0.2
			elseif ply:GetStamina() > 0 && ply.ChargeInt <= CurTime()  then
				ply:TakeStamina(2)
				ply.ChargeInt = CurTime() + 0.2			
			end
			
		end
	else
	
		if ply:GetStamina() < 100 && ply.ChargeInt <= CurTime() then
			ply:GiveStamina(1)
			ply.ChargeInt = CurTime() + 0.4
		end
		
	end
	
	if ply:GetStamina() > 0 && !ply.CanSprint then
		if ply.KenyanLegs then
			ply:SetRunSpeed( 280 )
		else
			ply:SetRunSpeed( 250 )
		end
		ply.CanSprint = true
	elseif ply:GetStamina() <= 0 && ply.CanSprint then
		ply:SetRunSpeed(100)
		ply.CanSprint = false
		ply.ChargeInt = CurTime() + 5
	end
	
end
hook.Add("Move", " SprintDecay",  SprintDecay)

local function SprintExploit(ply, key)
	if !ply:InVehicle() and key == IN_SPEED then
		ply:TakeStamina(2)
	end
end
hook.Add("KeyPress", "SprintDecay", SprintExploit)