local ZombieSpawns = {}
local ZombieTypes = {}
ZombieTbl = {}

ZombieSpawns["rp_necro_forest_a1_trips"] = {
	Vector(-493,-1289,64),
	Vector(7049,-2539,0),
	Vector(7275,-1077,0),
	Vector(8766,-1136,0),
	Vector(4740,-5841,4),
	Vector(9334,1077,0),
	Vector(10158,3014,0),
	Vector(4711,645,2),
	Vector(613,909,38),
	Vector(7926,569,0)
}

ZombieTypes["rp_necro_forest_a1_trips"] = {
	"npc_nb_common"
	--"npc_nextbot_metrocop"
}

function ZombieLoad()
	print("Calling InitPostEntity->Zombie Creation!")
	timer.Create( "SpawnTheZombies", 1, 0, function()
		SpawnAZombie()
	end)
end
hook.Add("InitPostEntity", "ZombieLoad", ZombieLoad)

DayZ_NextZombie = DayZ_NextZombie or 2
DayZ_NightTime = true

function SpawnAZombie()
	local DoSpawn = true
	
	local pos = table.Random(ZombieSpawns[string.lower(game.GetMap())])
		
	local vec2 = Vector(50, 50, 50) -- Enough to stop them spawning inside one another.
	for _, ent in pairs( ents.FindInBox( pos - vec2, pos + vec2 ) ) do
		if ent.IsZombie then 
			DoSpawn = false
			break
		end
	end
		
	if !DoSpawn then return end
	
	if #ZombieTbl <= 50 then

		--MsgAll("Making a Zombie!")
	
		local newzombie = ents.Create( table.Random( ZombieTypes[game.GetMap()] ) )
		newzombie:SetPos( pos+Vector(0,0,30) )
		newzombie:Spawn()
		
		table.insert(ZombieTbl, newzombie)
	end
end