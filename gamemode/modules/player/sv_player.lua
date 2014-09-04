function GM:PlayerSwitchFlashlight( ply, SwitchOn )
	if ply:HasItem( "item_flashlight" ) then
		return true
	else
		return false
	end
end

-- Taken from DarkRP, credits to FPtje.
local threed = true
local vrad = true
local dynv = true
-- proxy function to take load from PlayerCanHearPlayersVoice, which is called a quadratic amount of times per tick,
-- causing a lagfest when there are many players
local function calcPlyCanHearPlayerVoice(listener)
	if not IsValid(listener) then return end
	listener.DayZCanHear = listener.DayZCanHear or {}
	for _, talker in pairs(player.GetAll()) do
		listener.DayZCanHear[talker] = not vrad or -- Voiceradius is off, everyone can hear everyone
		listener:GetShootPos():DistToSqr(talker:GetShootPos()) < 605000 -- voiceradius is on and the two are within hearing distance
	end
end

-- hook.Add("PlayerInitialSpawn", "DayZCanHearVoice", function(ply)
	-- timer.Create(ply:UserID() .. "DayZCanHearPlayersVoice", 0.5, 0, function() if ply:IsValid() then calcPlyCanHearPlayerVoice(ply) end end)
-- end)

local NextCheck = 0
hook.Add("PlayerTick", "DayZCanHearVoice", function(ply, cmd)

	if NextCheck > CurTime() then return end
	NextCheck = CurTime() + 0.5
	
	if ply:IsValid() then 
		calcPlyCanHearPlayerVoice(ply) 
	end
end)

hook.Add("PlayerDisconnected", "DayZCanHearVoice", function(ply)
	if not ply.DayZCanHear then return end
	for k,v in pairs(player.GetAll()) do
		if not v.DayZCanHear then continue end
		v.DayZCanHear[ply] = nil
	end
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
	local canHear = listener.DayZCanHear and listener.DayZCanHear[talker]
	return canHear, threed
end


