util.AddNetworkString( "UpdateCharFull" )

function PMETA:UpdateCharModel( face, clothes, gender )	
	face = face or 1
	clothes = clothes or 1
	gender = gender or 0
	
	if face == 99 then
		face = math.random( 1, 4 )
	end
	
	if tonumber( gender ) == 0 then
		self:SetModel( MaleModels[ tonumber( face ) ][ tonumber( clothes ) ] )
	else
		self:SetModel( FemaleModels[ tonumber( face ) ][ tonumber( clothes ) ] )
	end

	self:GodDisable() -- character created disable godmode
	self:UpdateHat()

	self:SetNWInt( "gender", tonumber( gender ) )
	self:SetNWInt( "face", tonumber( face ) )
	self:SetNWInt( "clothes", tonumber( clothes ) )
	
	self.oPModel = self:GetModel()
end
concommand.Add( "UpdateCharModel", function( ply, cmd, args ) 
	ply:UpdateCharModel( args[ 1 ], args[ 2 ], args[ 3 ] )
end )

function PMETA:UpdateChar( item )
	
	if item then
		self:UpdateWeapons(item)
	else
		self:UpdateWeapons()
	end

	net.Start( "UpdateCharFull" )
		net.WriteTable( self.CharTable )
	net.Send( self )
	
	self:AddWeight()	
end

function PMETA:BuyItemMoney( item, amount )
	if item == nil and amount == nil then return false end

	item = tonumber( item ) or item
	
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end

	local npc = false
	for k, v in pairs( ents.FindInSphere( self:GetPos(), 128 ) ) do
		if v:GetClass() == "npc_sz" then
			npc = true
		end
	end
	
	amount = math.Round( amount )
	if amount < 1 then return false end
		
	if !npc then
		self:ChatPrint( "Nice try. Go to the NPC to buy stuff." )

		return false
	end
	
	local ammo = false
	if string.find( string.lower( ItemTable.ID ), "ammo" ) then
		ammo = true
	end
	
	if !ammo and !table.HasValue( GAMEMODE.DayZ_Shops[ "shop_buy" ], ItemTable.ID ) then return false end
	
	if ammo and !self:IsVIP() then
		self:ChatPrint( "Buying ammo is VIP only!" )

		return false
	end

	local CurMoneyAmount = ( self.InvTable[ 1 ] and self.InvTable[ 1 ] ) or 0 // item_money
		
	if amount * ItemTable.Price > CurMoneyAmount then
		self:ChatPrint( "You can't afford that." )

		return false
	end
	
	if self:GetNWBool( "Perk2" ) == false then
		if self.WeightCur + ( ItemTable.Weight * amount ) > 100 then
			self:ChatPrint( "You can't carry anymore." )

			return false
		end
	elseif self:GetNWBool( "Perk2" ) == true then
		if self.WeightCur + ( ItemTable.Weight * amount ) > 200 then
			self:ChatPrint( "You can't carry anymore." )

			return false
		end	
	end
	
	self:TakeItem( 1, math.Round( amount * ItemTable.Price ) ) // take item_money
	
	if ItemTable.ClipSize then
		amount = ItemTable.ClipSize
	end

	self:GiveItem( ItemKey, amount )

	self:ChatPrint( "You bought: " .. ItemTable.Name .. " for $" .. math.Round( ItemTable.Price ) )
	self:EmitSound( "item_buy.wav", 75, 100 )
end
concommand.Add( "BuyItemMoney", function( ply, cmd, args )
	ply:BuyItemMoney( args[ 1 ], 1 )
end )

function PMETA:SellItemMoney( item, amount )
	if item == nil and amount == nil then return false end

	item = tonumber( item ) or item
	
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end

	local npc = false
	for k, v in pairs( ents.FindInBox( self:GetPos()+Vector(250,250,250), self:GetPos()-Vector(250,250,250) ) ) do
		if v:GetClass() == "npc_sz" then
			npc = true
			break
		end
	end
	
	if !npc then
		self:ChatPrint( "Nice try. Go to the NPC to sell stuff." )
		return false
	end
	
	if !self:HasItem( ItemKey ) then return false end

	if ItemTable.ClipSize then
		amount = ItemTable.ClipSize
	end
	
	if !self:HasItemAmount( ItemKey, amount) then return false end
	
	self:GiveItem( 1, math.Round( amount * ( ( ItemTable.Price / amount ) / 10 ) ) ) // give item_money
	self:TakeItem( ItemKey, amount )

	self:ChatPrint( "You sold '" .. ItemTable.Name .. "' for $" .. math.Round( amount * ( ( ItemTable.Price / amount ) / 10 ) ) )
	self:EmitSound( "item_buy.wav", 75, 100 )
end
concommand.Add( "SellItemMoney", function( ply, cmd, args )
	ply:SellItemMoney( args[ 1 ], 1 )
end )

function PMETA:BuyItemCredits( item, amount )
	if item == nil and amount == nil then return false end

	item = tonumber( item ) or item
	
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end
	if !ItemTable.Credits then return false end

	local npc = false
	for _, v in pairs( ents.FindInSphere( self:GetPos(), 128 ) ) do
		if v:GetClass() == "npc_sz" then
			npc = true
		end
	end
	
	if !npc then
		self:ChatPrint( "Nice try. Go to the NPC to sell stuff." )

		return false
	end

	amount = math.Round( amount )
	if amount < 1 then return false end
	
	local CurCredAmount = ( self.InvTable[ 2 ] and self.InvTable[ 2 ] ) or 0 // item_credits
	if CurCredAmount <= 0 then return false end
	
	if amount * ItemTable.Credits > CurCredAmount then
		self:ChatPrint( "You can't afford that, you need to get more credits." )

		return false
	end
	
	if self:GetNWBool( "Perk2" ) == false then
		if self.WeightCur + ( ItemTable.Weight * amount ) > 100 then
			self:ChatPrint( "You can't carry anymore." )

			return false
		end
	elseif self:GetNWBool( "Perk2" ) == true then
		if self.WeightCur + ( ItemTable.Weight * amount ) > 200 then
			self:ChatPrint( "You can't carry anymore." )

			return false
		end
	end

	self:TakeItem( 2, math.Round( amount * ItemTable.Credits ) ) // take item_credits

	if ItemTable.ClipSize then
		amount = ItemTable.ClipSize
	end

	self:GiveItem( ItemKey, amount )

	self:ChatPrint( "You bought " .. ItemTable.Name )
	self:EmitSound( "item_buy.wav", 75, 100 )
end
concommand.Add( "BuyItemCredits", function( ply, cmd, args )
	ply:BuyItemCredits( args[ 1 ], 1 ) 
end )

function PMETA:GiveMoney( amount )
	if tonumber( amount ) < 0 then
		return false
	end

	self:GiveItem( 1, math.Round( amount ) ) // item_money
end

function PMETA:GiveCredits( amount )
	if tonumber( amount ) < 0 then
		return false
	end

	self:GiveItem( 2, math.Round( amount ) ) // item_credits
end