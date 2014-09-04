util.AddNetworkString( "LootItem" )

local TYPE_BASIC = 1
local TYPE_FOOD = 2
local TYPE_INDUSTRIAL = 3
local TYPE_MEDICAL = 4
local TYPE_WEAPON = 5
local TYPE_HAT = 6

local TotalAllowedLoot = 200
TotalSpawnedLoot = TotalSpawnedLoot or 0

local LootVectors = {
	[ "rp_necro_forest_a1_trips" ] = {
		[ TYPE_BASIC ] = {
			Vector(930,1564,96),
			Vector(1044,1762,100),
			Vector(908,1665,74),
			Vector(959,2037,106),
			Vector(842,2078,103),
			Vector(947,2597,87),
			Vector(2542,256,32),
			Vector(-406,272,81),
			Vector(-390,-104,81),
			Vector(-390,-104,81),
			Vector(-612,36,124),
			Vector(-614,145,124),
			Vector(-507,88,124),
			Vector(1285,2273,67),
			Vector(5296,1334,50),
			Vector(5298,1279,32),
			Vector(4901,1660,71),
			Vector(4900,1712,71),
			Vector(5632,1372,65),
			Vector(5600,1371,65),
			Vector(4956,-1020,24),
			Vector(8706,-2388,38),
			Vector(8854,-2377,48),
			Vector(8839,-2334,49),
			Vector(9316,-1655,55),
			Vector(9322,-2090,16),
			Vector(9331,-2353,16),
			Vector(9491,-1976,41),
			Vector(9529,-1976,41),
			Vector(9588,-2163,37),
			Vector(9584,-2189,37),
			Vector(9576,-2389,50),
			Vector(9541,-2392,50),
			Vector(9507,-2344,55),
			Vector(9656,-2212,16),
			Vector(9633,-2307,55),
			Vector(9660,-2385,37),
			Vector(9776,-2440,16),
			Vector(9888,-2485,50),
			Vector(9844,-2487,50),
			Vector(9562,-1911,159),
			Vector(9354,-672,26),
			Vector(9393,-671,26),
			Vector(9435,-668,26),
			Vector(9433,-671,58),
			Vector(9395,-668,58),
			Vector(9351,-672,58),
			Vector(9361,-1074,15),
			Vector(9580,-667,21),
			Vector(9615,-671,21),
			Vector(9660,-671,21),
			Vector(9567,-668,53),
			Vector(9622,-670,53),
			Vector(9661,-668,53),
			Vector(10092,1755,0),
			Vector(10212,1640,0),
			Vector(10134,1626,0),
			Vector(766,-8268,8),
			Vector(1125,-8490,-7),
			Vector(1220,-8238,29),
			Vector(1564,-8274,17),
			Vector(1862,-8175,0),
			Vector(1984,-8520,0),
			Vector(5940,-7635,16),
			Vector(5887,-7581,16),
			Vector(5946,-7497,16),
			Vector(5648,-7636,16),
			Vector(5592,-7202,16),
			Vector(4562,-7436,0),
			Vector(4679,-7335,0),
			Vector(4517,-7703,2),
			Vector(4697,-7576,0),
			Vector(5187,-6791,57),
			Vector(5207,-6695,34),
			Vector(5445,-5788,35),
			Vector(5463,-5839,35),
			Vector(5333,-5628,64),
			Vector(5015,-6285,40),
			Vector(5068,-6223,40),
			Vector(5501,-6331,0),
			Vector(5167,-6373,0)
		},

		[ TYPE_FOOD ] = { 	
			Vector(1398,2019,64),
			Vector(1499,2159,103),
			Vector(1304,2159,103),
			Vector(1461,1980,103),
			Vector(870,2573,82),
			Vector(913,2547,32),
			Vector(-535,-181,122),
			Vector(-547,417,116),
			Vector(4959,1538,32),
			Vector(9626,-2005,171),
			Vector(7403,1459,31),
			Vector(7453,1476,30),
			Vector(7443,1369,32),
			Vector(7318,1358,37)
		},

		[ TYPE_INDUSTRIAL ] = {
			Vector(-477,-1475,114),
			Vector(4580,2034,44),
			Vector(4571,1925,41),
			Vector(5044,1870,32),
			Vector(5108,1850,32),
			Vector(4947,1794,50),
			Vector(4874,1777,50),
			Vector(4898,1813,49),
			Vector(4450,1901,4),
			Vector(4884,-945,27),
			Vector(4290,-2885,0),
			Vector(9803,-1720,16),
			Vector(9771,-1841,16),
			Vector(9562,-1911,159),
			Vector(9636,-2216,174),
			Vector(9154,-2504,0)
		},

		[ TYPE_MEDICAL ] = { 
			Vector(916,2091,64),
			Vector(1136,2115,101),
			Vector(-773,419,80),
			Vector(5423,845,2),
			Vector(5457,1889,32),
			Vector(5445,1780,32),
			Vector(5513,1798,35),
			Vector(5705,1874,32),
			Vector(5700,1785,32),
			Vector(9973,-2280,18),
			Vector(10039,-2300,54),
			Vector(9980,-2431,16),
			Vector(10037,-2342,16),
			Vector(9880,-2072,16),
			Vector(8069,3393,-192),
			Vector(8169,3250,-192)
		},

		[ TYPE_WEAPON ] = {
			Vector(864,1225,73),
			Vector(2627,240,32),
			Vector(-479,667,122),
			Vector(-811,166,124),
			Vector(-629,-154,80),
			Vector(-589,-573,87),
			Vector(-564,-594,87),
			Vector(4669,2061,10),
			Vector(5082,1469,71),
			Vector(5003,1475,71),
			Vector(5705,1714,32),
			Vector(4920,-838,0),
			Vector(5856,-2287,82),
			Vector(5912,-2226,54),
			Vector(5825,-2234,26),
			Vector(6139,-1604,37),
			Vector(6220,-1638,78),
			Vector(6168,-1684,0),
			Vector(8760,-2375,38),
			Vector(9642,-1722,52),
			Vector(9706,-1716,52),
			Vector(9843,-1724,46),
			Vector(9893,-1732,46),
			Vector(9459,-2041,159),
			Vector(7391,1429,33),
			Vector(7410,1363,35),
			Vector(7315,1510,27),
			Vector(10187,1727,0),
			Vector(10102,1671,0),
			Vector(5594,-6277,1),
			Vector(5554,-6053,40),
			Vector(5548,-6154,3),
			Vector(5577,-6197,4),
			Vector(5544,-5996,3)
		},

		[ TYPE_HAT ] = { 
			Vector(657,2003,96),			
			Vector(787,1862,64),
			Vector(-711,9,80),
			Vector(5258,1625,42),
			Vector(5336,1697,32),
			Vector(5362,-167,5),
			Vector(9872,-2304,129),
			Vector(9668,-2382,161),
			Vector(10026,-2390,129),
			Vector(9862,-2478,168),
			Vector(9430,-2123,161),
			Vector(7341,1460,31)
		}
	}
}

LootItems = {
	[ "Basic" ] = {},
	[ "Food" ] = {},
	[ "Industrial" ] = {},
	[ "Medical" ] = {},
	[ "Weapon" ] = {},
	[ "Hat" ] = {}
}

local LootDebug = false
local LootRadius = Vector( 10, 10, 10 )

function LoadLootSystem() 
	print( "Calling InitPostEntity->LootSystem" )
	
	for Key = 1, #GAMEMODE.DayZ_Items do
		local Item = GAMEMODE.DayZ_Items[ Key ]

		for _, Type in pairs( Item.LootType ) do
			if !Type or Type == "None" then continue end -- Why the fuck did I put "None" when I could have nilled the system.
			
			table.insert( LootItems[ Type ], Key )
		end
	end
		
	timer.Create( "LootSpawnTimer", 2, 0, function()
		SpawnSomeLoot()
	end )
end
hook.Add( "InitPostEntity", "LoadLootSystem", LoadLootSystem )

function SpawnSomeLoot()
	-- Choose type of loot to spawn
	local num = math.random( 1, 300 )
	local itemtype = TYPE_BASIC
		
	if num > 140 and num < 190 then
		itemtype = TYPE_FOOD
	elseif num > 190 and num < 230 then
		itemtype = TYPE_INDUSTRIAL
	elseif num > 230 and num < 280 then
		itemtype = TYPE_MEDICAL
	elseif num > 285 then
		itemtype = TYPE_WEAPON
	end
		
	local pos = table.Random( LootVectors[ string.lower( game.GetMap() ) ][ itemtype ] )
		
	local nearitem = false
	for _, ent in pairs( ents.FindInBox( pos + LootRadius, pos - LootRadius ) ) do
		if IsValid( ent ) and ( ent:GetClass() == "base_item" or ent:IsPlayer() ) then
			nearitem = true

			break
		end
	end
	
	if nearitem then
		if LootDebug then 
			MsgAll( "Not spawning loot. Near other loot!" ) 
		end 
		
		return 
	end

	local ItemTable, ItemKey = table.Random( GAMEMODE.DayZ_Items )
	if math.random( 0, 100 ) > tonumber( ItemTable.SpawnChance ) then return end
	if TotalSpawnedLoot > TotalAllowedLoot then return end
	
	local itement = ents.Create( "base_item" )
	itement:SetNWInt( "Class", ItemKey )
	itement:SetPos( pos + ItemTable.SpawnOffset )
	
	itement.Amount = ItemTable.ClipSize or 1
	
	if ItemTable.SpawnAngle then
		itement:SetAngles( ItemTable.SpawnAngle )
	end
	
	itement:Spawn()
	TotalSpawnedLoot = TotalSpawnedLoot + 1
	itement.SpawnLoot = true

	if LootDebug then
		MsgAll( "The item " .. ItemTable.ID .. " has Spawned!" )
	end
end

function PMETA:LootItem( item, amount, backpack, char )

	item = tonumber(item) or item

	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end

	if !self:Alive() then return false end
	
	if !self.WeightCur then
		return false
	end
	
	amount = tonumber( amount )

	local backpack_ent = Entity( self.LootingBackpack ) 
	if !IsValid( backpack_ent ) then return false end

	if self:GetPos():Distance( backpack_ent:GetPos() ) > 200 then
		net.Start( "net_CloseLootMenu" )
		net.Send( self )

		return
	end
	
	if self:GetNWBool( "Perk2" ) == false then
		if self.WeightCur + ( ItemTable.Weight * amount ) > 100 then
			self:ChatPrint( 1, "You cant carry anymore!" )
			
			return false
		end
	elseif self:GetNWBool( "Perk2" ) == true then
		if self.WeightCur + ( ItemTable.Weight * amount ) > 200 then
			self:Tip( 1, "You cant carry anymore!" )
			
			return false
		end	
	end		
		
	if ItemTable.ID == "item_flashlight" then
		self:Tip( 3, "Press [F] to use the flashlight" )
	end
	
	if ItemTable.ID == "item_binoculars" then
		self:Tip( 3, "Hold [LMB] to zoom in and hold [RMB] to zoom out." )
	end	
	
	if ItemTable.Gun != nil then
		self:Tip( 3, "Remember to unload your gun before logging out to avoid losing the clip!" )
	end
	
	if char == 1 then
		local CurItemAmount = ( backpack_ent.CharTable[ ItemKey ] and backpack_ent.CharTable[ ItemKey ] ) or 0
		if CurItemAmount < amount then return false end
		
		if backpack_ent.CharTable[ ItemKey ] and backpack_ent.CharTable[ ItemKey ] > 0 then
			backpack_ent.CharTable[ ItemKey ] = backpack_ent.CharTable[ ItemKey ] - math.Round( amount )
		end
	else
		local CurItemAmount = ( backpack_ent.ItemTable[ ItemKey ] and backpack_ent.ItemTable[ ItemKey ] ) or 0
		if CurItemAmount < amount then return false end
	
		if backpack_ent.ItemTable[ ItemKey ] and backpack_ent.ItemTable[ ItemKey ] > 0 then
			backpack_ent.ItemTable[ ItemKey ] = backpack_ent.ItemTable[ ItemKey ] - math.Round( amount )
		end
	end
	
	self:EmitSound( "items/itempickup.wav", 110, 100 )
	self:GiveItem( item, math.Round( amount ) )
	
	net.Start( "UpdateBackpack" )
		net.WriteTable( backpack_ent.ItemTable )		
	net.Send( player )
	
	net.Start( "UpdateBackpackChar" )
		net.WriteTable( backpack_ent.CharTable )
	net.Send( player )
	
	self:ConCommand( "SendBackpack" )
end
concommand.Add( "LootItem", function( ply, cmd, args ) 
	ply:LootItem( args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ] ) 
end )

net.Receive( "LootItem", function( len, ply )
	local item = net.ReadString()
	local amount = net.ReadInt( 32 )
	local backpack = net.ReadInt( 32 )
	local char = net.ReadBit()
	
	ply:LootItem( item, amount, backpack, char )
end )