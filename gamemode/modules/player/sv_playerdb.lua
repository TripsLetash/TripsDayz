util.AddNetworkString( "CharSelect" )
util.AddNetworkString( "ShopTable" )

local function SetUpBackgrounds(ply)
	AddOriginToPVS( Vector(0, 0, 100) )
	AddOriginToPVS( Vector(5321,-5927,70) )
end
hook.Add("SetupPlayerVisibility", "SetUpBackgrounds", SetUpBackgrounds)

function PMETA:UpdatePerks( ignoresql )
	self.Perk1 = false
	self.Perk2 = false
	self:SetNWBool( "Perk2", self.Perk2 )

	self.Perk3 = false
	self.Perk4 = false
	self.Perk5 = false
	self.Perk6 = false
	
	if ignoresql then return end
	
	PLib:RunPreparedQuery({ sql = "SELECT `perk` FROM `players_perks` WHERE `user_id` = " .. self.ID .. ";", callback = function( data )
		for i = 1, #data do
			local perkid = data[ i ][ 1 ]
			
			if perkid == 80 then self.Perk1 = true end

			if perkid == 81 then -- Strong back perk
				self.Perk2 = true
				self:SetNWBool( "Perk2", self.Perk2 )
			end

			-- Cheetah == 80
			-- Strongback == 81
			-- DeadMans Luck == 82
			-- Violent background == 83 
			-- ZombieSlayer == 84
			-- Enlightenment == 85
			
			if perkid == 82 then	self.Perk3 = true end
			if perkid == 83 then self.Perk4 = true end
			if perkid == 84 then	self.Perk5 = true end
			if perkid == 85 then self.Perk6 = true end
		end
	end })
end

function PHDayZ_SetupDatabase()
	PLib:RunPreparedQuery({ sql = [[
		CREATE TABLE IF NOT EXISTS `players` (
			`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
			`steamid` varchar(64) NOT NULL,
			`gender` tinyint(1) unsigned NOT NULL,
			`face` smallint(3) unsigned NOT NULL,
			`hat` smallint(3) unsigned NOT NULL,
			`clothes` smallint(3) unsigned NOT NULL,
			`alive` tinyint(1) unsigned NOT NULL,
			`health` smallint(4) unsigned NOT NULL,
			`thirst` smallint(4) unsigned NOT NULL,
			`hunger` smallint(4) unsigned NOT NULL,
			`xpos` int(10) NOT NULL,
			`ypos` int(10) NOT NULL,
			`zpos` int(10) NOT NULL,
			`mapindex` tinyint(3) unsigned NOT NULL,
			`xp` smallint(4) unsigned NOT NULL,
			`lvl` tinyint(3) unsigned NOT NULL,
			`kills` smallint(3) unsigned NOT NULL,
			`credits` int(10) unsigned NOT NULL,
			`extraslots` tinyint(3) unsigned NOT NULL,
			PRIMARY KEY (`id`),
			KEY `steamid` (`steamid`)
		)
	ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
	]]})

	PLib:RunPreparedQuery({ sql = [[
		CREATE TABLE IF NOT EXISTS `players_bank` (
			`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
			`user_id` int(10) unsigned NOT NULL,
			`item` smallint(4) unsigned NOT NULL,
			`amount` smallint(5) unsigned NOT NULL,
			PRIMARY KEY (`id`),
			KEY `user_id` (`user_id`)
		)
	ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
	]] })

	PLib:RunPreparedQuery({ sql = [[
		CREATE TABLE IF NOT EXISTS `players_character` (
			`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
			`user_id` int(10) unsigned NOT NULL,
			`item` smallint(4) unsigned NOT NULL,
			PRIMARY KEY (`id`),
			KEY `user_id` (`user_id`)
		)
	ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
	]] })
	
	PLib:RunPreparedQuery({ sql = [[
		CREATE TABLE IF NOT EXISTS `players_inventory` (
			`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
			`user_id` int(10) unsigned NOT NULL,
			`item` smallint(4) unsigned NOT NULL,
			`amount` smallint(5) unsigned NOT NULL,
			PRIMARY KEY (`id`),
			KEY `user_id` (`user_id`)
		)
	ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
	]] })

	PLib:RunPreparedQuery({ sql = [[
		CREATE TABLE IF NOT EXISTS `players_perks` (
			`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
			`user_id` int(10) unsigned NOT NULL,
			`perk` smallint(4) unsigned NOT NULL,
			PRIMARY KEY (`id`)
		)
	ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
	]] })
end

local function get_stats( ply )
	local mapindex = 5
	--for k, v in pairs( MapIndex ) do
	--	if v == string.lower( game.GetMap() ) then
	--		mapindex = tonumber( k )
	--		break
	--	end
	--end

	local alive = 1
	if ply.Dead == true then
		alive = 0
	end

	return {
		ply:GetNWInt( "gender" ),
		ply:GetNWInt( "face" ),
		ply:GetNWInt( "hat" ),
		ply:GetNWInt( "clothes" ),
		ply:Health(),
		ply.Thirst,
		ply.Hunger,
		alive,
		ply:GetPos(),
		mapindex,
		ply:GetNWInt( "xp" ),
		ply:GetNWInt( "lvl" ),
		ply:Frags(),
		ply:GetNWInt( "credits" ),
		ply:GetNWInt( "extraslots" )
	}
end

function save_player( ply, func )
	if ply.New or !ply.ID then return false end

	local stats = get_stats( ply )
	PLib:RunPreparedQuery({ sql = "UPDATE `players` SET `gender` = " .. stats[ 1 ] .. ", `face` = " .. stats[ 2 ] .. ", `hat` = " .. stats[ 3 ] .. ", `clothes` = " .. stats[ 4 ] .. ", `health` = " .. stats[ 5 ] .. ", `thirst` = " .. stats[ 6 ] .. ", `hunger` = " .. stats[ 7 ] .. ", `alive` = " .. stats[ 8 ] .. ", `xpos` = " .. stats[ 9 ].x .. ", `ypos` = " .. stats[ 9 ].y .. ", `zpos` = " .. stats[ 9 ].z .. ", `mapindex` = " .. stats[ 10 ] .. ", `xp` = " .. stats[ 11 ] .. ", `lvl` = " .. stats[ 12 ] .. ", `kills` = " .. stats[ 13 ] .. ", `credits` = " .. stats[ 14 ] .. ", `extraslots` = " .. stats[ 15 ] .. " WHERE `id` = " .. ply.ID .. ";", 
	callback = function( data )
		if isfunction( func ) then
			func()
		end
	end })
end

local function save_players()
	for k, v in pairs( player.GetAll() ) do
		if IsValid( v ) then
			save_player( v )
		end
	end
end

local function new_player( ply, func )
	local stats = get_stats( ply )
	PLib:RunPreparedQuery({ sql = "INSERT INTO `players` ( `steamid`, `gender`, `face`, `hat`, `clothes`, `health`, `thirst`, `hunger`, `alive`, `xpos`, `ypos`, `zpos`, `mapindex`, `xp`, `lvl`, `kills`, `credits`, `extraslots` ) VALUES ( '" .. ply:SteamID() .. "', " .. stats[ 1 ] .. ", " .. stats[ 2 ] .. ", " .. stats[ 3 ] .. ", " .. stats[ 4 ] .. ", " .. stats[ 5 ] .. ", " .. stats[ 6 ] .. ", " .. stats[ 7 ] .. ", " .. stats[ 8 ] .. ", " .. stats[ 9 ].x .. ", " .. stats[ 9 ].y .. ", " .. stats[ 9 ].z .. ", " .. stats[ 10 ] .. ", " .. stats[ 11 ] .. ", " .. stats[ 12 ] .. ", " .. stats[ 13 ] .. ", " .. stats[ 14 ] .. ", " .. stats[ 15 ] .. " );", 
	callback = function( data )
		ply.ID = data
		ply.New = nil

		if isfunction( func ) then
			func()
		end
	end })
end

function player_defaults( ply, reset )
	ply.Loading = true

	ply:SetHealth( 100 )
	ply.Thirst = 100
	ply.Hunger = 100
	
	ply:SetPos( Vector(0,0,-1000) )
	ply:SetModel( "models/player/group01/male_01.mdl" )

	if reset then
		ply:SetNWInt( "xp", 0 )
	else	
		if ply:IsVIP() then
			ply:SetNWInt( "xp", ply:GetNWInt( "xp" ) / 2 )
		else
			ply:SetNWInt( "xp", 0 )
		end
	end
		
	if reset or ply:GetNWInt( "lvl", 0 ) == 0 then
		ply:SetNWInt( "lvl", 0 )
	end
	
	if reset or ply:GetNWInt( "extraslots", 0 ) == 0 then
		ply:SetNWInt( "extraslots", 0 )
	end
	
	ply:SetFrags( 0 )
	
	if reset or ply:GetNWInt( "credits", 0 ) == 0 then
		ply:SetNWInt( "credits", 0 )
	end
	
	if not reset then
		SetUpBackgrounds(ply)
		net.Start( "CharSelect" )
		net.Send( ply )
	end
end

local function load_player( ply )
	ply.InvTable = {}
	ply.CharTable = {}
	ply.BackWeapons = {}
	ply.BankTable = {}
	local mapindex = table.KeyFromValue( MapIndex, 	string.lower(game.GetMap()) )
	PLib:RunPreparedQuery({ sql = "SELECT * FROM `players` WHERE `steamid` = '" .. ply:SteamID() .. "';", 
	callback = function( data )
		if data[ 1 ] == nil then
			ply.New = true
			player_defaults( ply )
		else
			data = data[ 1 ]

			ply.ID = data[ 1 ]

			ply:SetNWInt( "lvl", tonumber( data[ 16 ] ) )
			ply:SetNWInt( "extraslots", tonumber( data[ 19 ] ) )
			
			if tonumber( data[ 7 ] ) == 0 then
				player_defaults( ply )
			else
				ply:Spectate( OBS_MODE_NONE )
				ply:Spawn()

				if MapIndex[ data[ 10 ] ] != string.lower( game.GetMap() ) then
					ply:SetPos( table.Random( Spawns[ string.lower( game.GetMap() ) ] ) + Vector( 0, 0, 30 ) )
				else
					ply:SetPos( Vector( tonumber( data[ 11 ] ), tonumber( data[ 12 ] ), tonumber( data[ 13 ] ) ) )
				end
				
				local gender = tonumber( data[ 3 ] )
				ply:SetNWInt( "gender", gender )

				local face = tonumber( data[ 4 ] )
				ply:SetNWInt( "face", face )
				ply:SetNWInt( "hat", tonumber( data[ 5 ] ) )

				local clothes = tonumber( data[ 6 ] )
				ply:SetNWInt( "clothes", clothes )

				ply:SetHealth( data[ 8 ] )
				ply.Thirst = tonumber( data[ 9 ] )
				ply.Hunger = tonumber( data[ 10 ] )

				ply:SetNWInt( "xp", tonumber( data[ 15 ] ) )
				ply:SetFrags( tonumber( data[ 17 ] ) )
				
				if ply:Frags() < 0 then
					ply:SetNWBool( "friendly", true )
				end
				
				ply:SetNWInt( "credits", tonumber( data[ 18 ] ) )
				ply:Give( "weapon_EmptyHands" )
				--ply:UpdateCharModel( face, clothes, gender )
				timer.Simple(1, function()
					ply:UpdateCharModel(tonumber( data[ 4 ] ),tonumber( data[ 6 ] ),tonumber( data[ 3 ] ))
				end)
				net.Start( "Thirst" )
					net.WriteUInt( ply.Thirst, 8 )		
				net.Send( ply )
				
				net.Start( "Hunger" )
					net.WriteUInt( ply.Hunger, 8 )		
				net.Send( ply )
			end

			PLib:RunPreparedQuery({ sql = "SELECT `item`, `amount` FROM `players_inventory` WHERE `user_id` = " .. ply.ID .. ";", 
			callback = function( data )
				for i = 1, #data do
					local item = data[ i ]
					local item_key = item[ 1 ]
					local item_amount = item[ 2 ]
					local item_table = GAMEMODE.DayZ_Items[ item_key ]

					if item_table != nil then
						ply.InvTable[ item_key ] = tonumber( item_amount )
					end
				end

				ply:UpdateItem()
			end })

			PLib:RunPreparedQuery({ sql = "SELECT `item`, `amount` FROM `players_bank` WHERE `user_id` = " .. ply.ID .. ";", 
			callback = function( data )
				for i = 1, #data do
					local item = data[ i ]
					local item_key = item[ 1 ]
					local item_amount = item[ 2 ]
					local item_table = GAMEMODE.DayZ_Items[ item_key ]

					if item_table != nil then
						ply.BankTable[ item_key ] = tonumber( item_amount )
					end
				end

				ply:UpdateBank()
			end })
			
			PLib:RunPreparedQuery({ sql = "SELECT `item` FROM `players_character` WHERE `user_id` = " .. ply.ID .. ";", 
			callback = function( data )
				for i = 1, #data do
					local item = data[ i ]
					local item_key = item[ 1 ]
					local item_table = GAMEMODE.DayZ_Items[ item_key ]

					if item_table != nil then					
						ply.CharTable[ item_key ] = true
					end
				end

				ply:UpdateChar()
			end })

			ply:UpdatePerks()
			ply:CheckUnlocksSilent()
			--ply.Loading = nil
		end
	end })
end

local function spawn_defaults( ply )
	ply:Spectate( OBS_MODE_NONE )
	ply:Spawn()
	ply:SetPos( ply.SpawnPos )

	ply.SpawnPos = nil

	ply:Give( "weapon_EmptyHands" )

	ply:GiveItem( "item_drink1", 1 )
	ply:GiveItem( "item_food2", 1 )
	ply:GiveItem( "item_medic1", 1 )

	if ply.Perk4 == true then
		ply:GiveItem( "item_crowbar", 1 )
	end

	if ply.Perk6 == true then
		ply:GiveItem( "item_flashlight", 1 )
	end	
end

local function confirm_player( ply, cmd, args )
	ply:SetNWInt( "TagTime", 0 )	
	ply:SetTeam( 1 )
	ply.ConnectScreen = nil
	ply:Freeze(false)
	ply:SetKeyValue( "rendermode", RENDERMODE_NORMAL )
	ply:SetKeyValue( "renderamt", "255" )
	ply:SetCollisionGroup(COLLISION_GROUP_NONE)
	ply:DrawShadow(true)
	if ply.Loading == true then
		ply.SpawnPos = table.Random( Spawns[ string.lower( game.GetMap() ) ] ) + Vector( 0, 0, 30 )		
		ply:SetPos( ply.SpawnPos )		

		if ply.New == true then
			new_player( ply, function()	
				spawn_defaults( ply )
			end )
		else
			save_player( ply, function()
				spawn_defaults( ply )
			end )
		end
	end	
end
concommand.Add( "ConfirmCharacter", confirm_player )

local function ready_player( ply, cmd, args )
	ply:SetNWInt( "TagTime", 0 )	
	ply:SetTeam( 1 )
	ply.ConnectScreen = nil
	load_player( ply )
end
concommand.Add( "ReadyCharacter", ready_player )

function reset_ent( ply )
	ply:StripWeapons()	

	PLib:QuickQuery( "DELETE FROM `players_perks` WHERE `user_id` = " .. ply.ID .. ";" )
	PLib:QuickQuery( "Default", "ALTER TABLE `players_perks` AUTO_INCREMENT = 1;" )
	ply:UpdatePerks( true )

	ply.InvTable = {}
	ply.BackWeapons = {}
	PLib:QuickQuery( "DELETE FROM `players_inventory` WHERE `user_id` = " .. ply.ID .. ";" )
	PLib:QuickQuery( "ALTER TABLE `players_inventory` AUTO_INCREMENT = 1;" )
	ply:UpdateItem()
	
	ply.BankTable = {}
	PLib:QuickQuery( "DELETE FROM `players_bank` WHERE `user_id` = " .. ply.ID .. ";" )
	PLib:QuickQuery( "ALTER TABLE `players_bank` AUTO_INCREMENT = 1;" )
	ply:UpdateBank()

	ply.CharTable = {}	
	PLib:QuickQuery( "DELETE FROM `players_character` WHERE `user_id` = " .. ply.ID ..";" )
	PLib:QuickQuery( "ALTER TABLE `players_character` AUTO_INCREMENT = 1;" )
	ply:UpdateChar()

	player_defaults( ply, true )

	--ply.SpawnPos = table.Random( Spawns[ string.lower( game.GetMap() ) ] ) + Vector( 0, 0, 30 )
	ply.SpawnPos = table.Random( Spawns["PlayerSpawns"] ) + Vector( 0, 0, 30 )

	save_player( ply, function()
		spawn_defaults( ply )
	end )
end

local function reset_all_ent()
	for k, v in pairs( player.GetAll() ) do
		reset_ent( v )
	end
end

function reset_steamid( steamid )
	PLib:RunPreparedQuery({ sql = "SELECT `id` FROM `players` WHERE `steamid` = '" .. steamid .. "';", 
	callback = function( data )
		if data[ 1 ] then
			local id = data[ 1 ][ 1 ]

			MySQL:Query( "Default", "UPDATE `players` SET `health` = 100, `alive` = 0, `xp` = 0, `lvl` = 0, `kills` = 0, `credits` = 0 WHERE `id` = " .. id .. ";" )

			MySQL:Query( "Default", "DELETE FROM `players_perks` WHERE `user_id` = " .. id .. ";" )
			MySQL:Query( "Default", "ALTER TABLE `players_perks` AUTO_INCREMENT = 1;" )

			MySQL:Query( "Default", "DELETE FROM `players_inventory` WHERE `user_id` = " .. id .. ";" )
			MySQL:Query( "Default", "ALTER TABLE `players_inventory` AUTO_INCREMENT = 1;" )

			MySQL:Query( "Default", "DELETE FROM `players_bank` WHERE `user_id` = " .. id .. ";" )
			MySQL:Query( "Default", "ALTER TABLE `players_bank` AUTO_INCREMENT = 1;" )

			MySQL:Query( "Default", "DELETE FROM `players_character` WHERE `user_id` = " .. id ..";" )
			MySQL:Query( "Default", "ALTER TABLE `players_character` AUTO_INCREMENT = 1;" )
		end
	end })
end

function GM:PlayerInitialSpawn( ply )
	SetUpBackgrounds(ply)
	ply:Spectate( OBS_MODE_ROAMING )
	ply.ConnectScreen = true
	--net.Start("CharReady")
	--net.Send(ply)
	net.Start( "ShopTable" )
		net.WriteTable( GAMEMODE.DayZ_Shops[ "shop_buy" ] )
	net.Send( ply )
end

function GM:PlayerSpawn( ply )
	if ply.ConnectScreen == true then
		ply:Spectate( OBS_MODE_ROAMING )
		ply:Freeze(true) 
		ply:SetPos( Vector(0,0,-1000) )		
	else
		ply:SetKeyValue( "rendermode", RENDERMODE_NORMAL )
		ply:SetKeyValue( "renderamt", "255" )
		ply:SetCollisionGroup(COLLISION_GROUP_NONE)
		ply:DrawShadow(true)
		ply:Freeze(false)
	end
	ply:SetRunSpeed( 250 )
	ply:SetWalkSpeed( 200 )
	ply:SetJumpPower( 250 )
	ply.ChargeInt = 0
	ply:SetNWInt( "Stamina", 100 )
	
	ply.IronStomach = ply.IronStomach or false
	ply.Pickpocket = ply.Pickpocket or false
	ply.UndeadSlayer = ply.UndeadSlayer or false
		
	ply:SetNWInt( "TagTime", 0 )
	ply:SetNWBool( "friendly", false )
		
	if ply.Dead == true then
		player_defaults( ply )

		ply.Dead = nil
	elseif ply.Loading == true then
		ply:Tip( "Press [Q] to open your inventory." )

		timer.Create( "Content_Tip", 8, 1, function()
			if IsValid( ply ) then
				ply:Tip( 3, "Errors? Missing Content? Grab the content pack from our forums!", Color(255, 255, 0) )
			end
		end )
		
		timer.Create( "Donate_Tip", 16, 1, function()
			if IsValid( ply ) then
				ply:Tip( 3, "Donate and gain extra in-game benefits and credits! See our forums for more information!", Color(255, 255, 0) )	
			end
		end )

		ply.Loading = nil
	end

	if ply.ConnectScreen then return end		
	ply:CheckUnlocksSilent()
	ply:SetupHands()
	ply:SetFrags( 0 )

	net.Start( "Thirst" )
		net.WriteUInt( ply.Thirst or 100, 8 )		
	net.Send( ply )
	
	net.Start( "Hunger" )
		net.WriteUInt( ply.Hunger or 100, 8 )		
	net.Send( ply )
end

function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

function GM:PlayerAuthed( ply )
	ply:Spectate( OBS_MODE_ROAMING )
	ply:SetKeyValue("rendermode", RENDERMODE_TRANSTEXTURE)
	ply:SetKeyValue("renderamt", "0")
	ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	ply:DrawShadow(false)
	ply:Freeze(true)
	ply:SetNWInt( "TagTime", 0 )	
	ply.ConnectScreen = true

end

local function SaveStats( ply )
	if ply.NextDataSave and ( ply.NextDataSave > CurTime() ) then return end
	ply.NextDataSave = CurTime() + 300
	
	if ply.Dead == true then return end -- Don't save if they're dead!
	
	save_player( ply )
end
hook.Add( "PlayerTick", "SaveStats", SaveStats )

local function DisconSave( ply )
	if !ply:IsValid() then return end
	save_player( ply )
end
hook.Add( "PlayerDisconnected", "SaveStats", DisconSave )