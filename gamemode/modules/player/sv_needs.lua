local function NeedsSetup(ply)
	if !IsValid(ply) then return end
	if ply.ConnectScreen then return end
	timer.Create(ply:UserID().."_hunger", 14, 0, function()
		if IsValid(ply) then
			if ply.Loading then return end
			if ply.ConnectScreen then return end

			if ply.Hunger > 0 then
				ply.Hunger = ply.Hunger - 1
				--print("lol, lost hunger "..ply:Nick())
			end
			if ply:Alive() and ply.Hunger < 1 then
				local ohealth = ply:Health()
				ply:TakeDamage( 15, ply )
				if ply:Health() == ohealth then	
					ply:SetHealth(ply:Health() - 15)
					if ply:Health() <= 0 then
						ply.DiedOf = "You died from starvation."
						ply:Kill()
					end
				end
				ply:Tip( 1, "You are dying of hunger!", Color(255, 0, 0) )
			end			
		end
	end )
	
	timer.Create(ply:UserID().."_thirst", 12, 0, function()
		if IsValid(ply) then
			if ply.Loading then return end
			if ply.ConnectScreen then return end
	
			if ply.Thirst > 0 then
				ply.Thirst = ply.Thirst - 1
				--print("lol, lost thirst "..ply:Nick())
			end
			if ply:Alive() and ply.Thirst < 1 then
				local ohealth = ply:Health()
				ply:TakeDamage(15, ply)
				if ply:Health() == ohealth then	
					ply:SetHealth(ply:Health() - 15)
					if ply:Health() <= 0 then
						ply.DiedOf = "You died from dehydration."
						ply:Kill()
					end
				end
				ply:Tip( 1, "You are dying of thirst!", Color(255, 0, 0))
			end
		end	
	end)
	
	timer.Create(ply:UserID().."_bleeding", 3, 0, function()
		if IsValid(ply) then
			if ply.Loading then return end
			if ply.ConnectScreen then return end	
			
			if ply:Alive() and ply.Bleed > 0 then
				local ohealth = ply:Health()
				ply:TakeDamage(2, ply)
				if ply:Health() == ohealth then	
					ply:SetHealth(ply:Health() - 2)
					if ply:Health() <= 0 then
						ply.DiedOf = "You bled out."
						ply:Kill()
					end
				end
				if bleedcounter == nil then bleedcounter = 0 end
				bleedcounter = bleedcounter + 1
				if bleedcounter >= 5 then
					ply:Tip( 1, "You are bleeding!", Color(255, 0, 0))
					bleedcounter = 0
				end
			end
		end	
	end)
	
		
end
hook.Add( "PlayerInitialSpawn", "Lower_HungerWater", NeedsSetup )

gameevent.Listen("player_disconnect")
local function RemoveNeedTimers(data)
	timer.Destroy(data.userid.."_hunger")
	timer.Destroy(data.userid.."_thirst")
	timer.Destroy(data.userid.."_bleeding")
end
hook.Add( "player_disconnect", "Remove_HungerThirst_Timers", RemoveNeedTimers )