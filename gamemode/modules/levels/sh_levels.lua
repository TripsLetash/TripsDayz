print("Loaded Shared Level")
GM.DayZ_Unlocks = {}

GM.DayZ_Unlocks[1] = {
	Name = "Kenyan Legs",
	LvlReq = 3,
	Model = "models/props/cs_assault/money.mdl",
	Color = Color(255,0,0,255),
	Desc = "You can run faster and jump higher.",
	Function = 
		function(ply)
			ply:SetRunSpeed( 280 )
			ply:SetWalkSpeed( 230 )
			ply:SetJumpPower( 280 )
		end,
}

GM.DayZ_Unlocks[2] = {
	Name = "Pickpocket",
	LvlReq = 5,
	Model = "models/props/cs_assault/money.mdl",
	Color = Color(255,0,0,255),
	Desc = "Undead more likely to drop money.",
	Function = 
		function(ply)
			ply.Pickpocket = true
		end,
}

GM.DayZ_Unlocks[3] = {
	Name = "Iron Stomach",
	LvlReq = 7,
	Model = "models/props/cs_assault/money.mdl",
	Color = Color(255,0,0,255),
	Desc = "Ability to eat objects that would normally harm you.",
	Function = 
		function(ply)
			ply.IronStomach = true
		end,
}

GM.DayZ_Unlocks[4] = {
	Name = "Undead Slayer",
	LvlReq = 8,
	Model = "models/props/cs_assault/money.mdl",
	Color = Color(255,0,0,255),
	Desc = "You deal an extra 10% damage to the undead.",
	Function = 
		function(ply)
			ply.UndeadSlayer = true
		end,
}
