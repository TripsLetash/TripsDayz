util.AddNetworkString( "UpdateItem" )
util.AddNetworkString( "UpdateItemFull" )
util.AddNetworkString( "UpdateWeight" )

function ChangeShop()
	GAMEMODE.DayZ_Shops[ "shop_buy" ] = {}

	for k, v in RandomPairs( GAMEMODE.DayZ_Items ) do
		if !v.Price or v.AmmoType or v.Hat then continue end
		
		table.insert( GAMEMODE.DayZ_Shops[ "shop_buy" ], v.ID )

		if #GAMEMODE.DayZ_Shops[ "shop_buy" ] > 9 then break end
	end
	
	net.Start( "ShopTable" )
		net.WriteTable( GAMEMODE.DayZ_Shops[ "shop_buy" ] )
	net.Broadcast()
	
	TipAll( 3, "The SafeZone Trader has restocked his wares!" )
end
timer.Create( "ChangeShop", 600, 0, ChangeShop )

function PMETA:AddWeight()
	local weight = 0

	for k, v in pairs( self.InvTable ) do
		if GAMEMODE.DayZ_Items[ k ].Weight then
			weight = weight + GAMEMODE.DayZ_Items[ k ].Weight * v
		end
	end

	self.WeightCur = weight

	net.Start( "UpdateWeight" )
		net.WriteFloat( weight )
	net.Send( self )

	local bweight = 0

	for k, v in pairs( self.BankTable ) do
		if GAMEMODE.DayZ_Items[ k ].Weight then
			bweight = bweight + GAMEMODE.DayZ_Items[ k ].Weight * v
		end
	end

	self.BankWeightCur = bweight

	net.Start( "UpdateBankWeight" )
		net.WriteFloat( bweight )
	net.Send( self )
end

function PMETA:UpdateItem( item, amount )
	if item != nil and amount != nil then
		item = tonumber(item) or item
		
		net.Start( "UpdateItem" )
			net.WriteUInt( item, 16 )
			net.WriteFloat( amount )
		net.Send( self )
	else
		net.Start( "UpdateItemFull" )
			net.WriteTable( self.InvTable )
		net.Send( self )
	end

	self:AddWeight()
	self:UpdateAmmoCount()
end
concommand.Add( "Update", function( ply, cmd, args ) 
	ply:UpdateItem()
end )

function PMETA:UpdateHat( item )
	if item == nil then return false end

	item = tonumber(item) or item

	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end

	if ItemTable.VIP != nil and !self:IsVIP() then return false end
		
	if !IsValid( self.hat ) then
		self.hat = ents.Create( "hat" )
	end

	self.hat:SetPos( Vector( self:GetPos() ) + Vector( 0, 0, 40 ) )
	self.hat:SetNWInt( "Owner", self:EntIndex() )
	self.hat:SetModel( ItemTable.Model )
	
	if !IsValid( self.hat ) then
		self.hat:Spawn()
	end
end

function PMETA:UpdateWeapons( item )
	if self:IsWepBanned() then return false end

	if IsValid( self.hat ) then
		self.hat:Remove()
		self.hat = nil
	end
	
	if item then
		if !self.CharTable[item] then
			if GAMEMODE.DayZ_Items[item].Weapon then
				self:StripWeapon(GAMEMODE.DayZ_Items[item].Weapon)
			end
		end
	end
	
	for k, _ in pairs( self.CharTable ) do
		local ItemTable = GAMEMODE.DayZ_Items[ k ]
		
		if !self.CharTable[ k ] then 
			self:StripWeapon( ItemTable.Weapon )
		end 
		
		if ItemTable.VIP != nil and !self:IsVIP() then continue end

		if ItemTable.Weapon != nil then
			self:Give( ItemTable.Weapon )
		end
		
		if ItemTable.Body != nil then
			self.oPModel = self:GetModel()
			self:SetModel( ItemTable.BodyModel )
		end
		
		if ItemTable.Hat != nil then
			self:UpdateHat( k )
		end
	end
end

function PMETA:UpdateAmmoCount()
	self:StripAmmo()

	for k, v in pairs( self.InvTable ) do
		local ItemTable = GAMEMODE.DayZ_Items[ k ]

		if ItemTable.AmmoType != nil then
			self:GiveAmmo( v, ItemTable.AmmoType, true )
		end
	end
end

function PMETA:HasItem( item )
	if item == nil then return false end

	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end

	if self.InvTable[ ItemKey ] == nil then	return false end
	if self.InvTable[ ItemKey ] > 0 then return true end
end

function PMETA:HasItemAmount( item, amount )
	if item == nil and amount == nil then return false end
	
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end

	if self.InvTable[ ItemKey ] == nil then	return false end
	if self.InvTable[ ItemKey ] >= tonumber( amount ) then return true end
end

function PMETA:GiveItem( item, amount )
	if item == nil and amount == nil then return false end

	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end

	amount = math.Round( amount )
	if amount < 1 then return false end

	local CurItemAmount = ( self.InvTable[ ItemKey ] and self.InvTable[ ItemKey ] ) or 0
	local NewItemAmount = CurItemAmount + amount
	
	if CurItemAmount > 0 then
		PLib:QuickQuery( "UPDATE `players_inventory` SET `amount` = " .. NewItemAmount .. " WHERE `user_id` = " .. self.ID .. " AND `item` = " .. ItemKey .. ";" )
	else
		PLib:QuickQuery( "INSERT INTO `players_inventory` ( `user_id`, `item`, `amount` ) VALUES ( " .. self.ID .. ", " .. ItemKey .. ", " .. amount .. " );" )
	end

	self.InvTable[ ItemKey ] = NewItemAmount
	self:UpdateItem( ItemKey, NewItemAmount )
	
end

function PMETA:SetItem( item, amount )
	if item == nil and amount == nil then return false end

	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end

	amount = tonumber( amount )
	if amount < 1 then return false end

	self:GiveItem( ItemKey, amount )
end

function PMETA:TakeCharItem( item )
	if item == nil then return false end
		
	item = tonumber(item) or item
		
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
		
	if ItemTable == nil then return false end
	if !self.CharTable[ ItemKey ] then return false end
		
	self.CharTable[ ItemKey ] = nil
		
	PLib:QuickQuery( "DELETE FROM `players_character` WHERE `user_id` = " .. self.ID .. " AND `item` = " .. ItemKey .. ";" )
	PLib:QuickQuery( "ALTER TABLE `players_character` AUTO_INCREMENT = 1;" )

	self:UpdateChar( ItemKey )
		
	return true
end

function PMETA:TakeItem( item, amount )
	if item == nil and amount == nil then return false end

	item = tonumber(item) or item
	
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end

	amount = tonumber( amount )
	if amount < 1 then return false end
		
	local CurItemAmount = ( self.InvTable[ ItemKey ] and self.InvTable[ ItemKey ] ) or 0
	local NewItemAmount = CurItemAmount - amount
	
	if amount > CurItemAmount then return false end

	if NewItemAmount < 1 then
		self.InvTable[ ItemKey ] = nil

		PLib:QuickQuery( "DELETE FROM `players_inventory` WHERE `user_id` = " .. self.ID .. " AND `item` = " .. ItemKey .. ";" )
		PLib:QuickQuery( "ALTER TABLE `players_inventory` AUTO_INCREMENT = 1;" )
	else
		self.InvTable[ ItemKey ] = NewItemAmount

		PLib:QuickQuery( "UPDATE `players_inventory` SET `amount` = " .. NewItemAmount .. " WHERE `user_id` = " .. self.ID .. " AND `item` = " .. ItemKey .. ";" )
	end

	self:UpdateItem( ItemKey, NewItemAmount )
	
	if self.BackWeapons != nil then
		for _, weapon in pairs( self.BackWeapons ) do
			if ItemTable.OnBack == true then
				table.remove( self.BackWeapons, _ )

				weapon:Remove()

				break
			end
		end
	end
	
	return true
end

function PMETA:UseItem( item )
	if item == nil then return false end

	item = tonumber(item) or item

	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end

	if ItemTable == nil then return false end

	self.NextUseItem = self.NextUseItem or 0

	if !self:Alive() then return false end
	if !self:HasItem( ItemKey ) then return false end
	if self:InVehicle() then return false end
	if self.NextUseItem > CurTime() then return false end
	
	if ItemTable.Condition != nil then
		if ItemTable.Condition( self, ItemTable.ID ) then
			ItemTable.Function( self, ItemTable.ID )
			self:TakeItem( ItemKey, 1 )
			self:SendLua( [[ UpdateInv() ClearSlot(Slot1) ]] )
		end
	else
		ItemTable.Function( self, ItemTable.ID )
		self:TakeItem( ItemKey, 1 )
		self:SendLua( [[ UpdateInv() ClearSlot(Slot1) ]] )
	end
	
	if !self:IsSuperAdmin() then
		self.NextUseItem = CurTime() + 5 
	else
		self.NextUseItem = CurTime() + 1
	end
end
concommand.Add( "Useitem", function( ply, command, args )
	ply:UseItem( args[ 1 ] )
end )

function PMETA:EatItem( item )
	if item == nil then return false end

	item = tonumber(item) or item
	
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
		
	if ItemTable == nil then return false end

	self.NextUseItem = self.NextUseItem or 0

	if !self:Alive() then return false end
	if !self:HasItem( ItemKey ) then return false end
	if self:InVehicle() then return false end
	if self.NextUseItem > CurTime() then return false end
		
	if !isfunction( ItemTable.EatFunction ) then
		ItemTable.DrinkFunction( self, ItemTable.ID )
	else
		ItemTable.EatFunction( self, ItemTable.ID )
	end

	self:TakeItem( ItemKey, 1 )
	self.NextUseItem = CurTime() + 1
	
	self:SendLua( [[ UpdateInv() ClearSlot(Slot2) ]] )
end
concommand.Add( "Eatitem", function( ply, command, args )
	ply:EatItem( args[ 1 ] )
end )

function PMETA:GivePerk( perk )
	if perk == nil then return false end

	local ItemTable, ItemKey
	if isnumber( perk ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ perk ], perk
	elseif ( isstring( perk ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( perk )
	end
	
	if ItemTable == nil then return false end

	PLib:RunPreparedQuery({ sql = "Default", "SELECT `id` FROM `players_perks` WHERE `user_id` = " .. self.ID .. " AND `perk` = " .. ItemKey .. ";", 
	callback = function( data )
		if !data[ 1 ] then
			MySQL:Query( "Default", "INSERT INTO `players_perks` ( `user_id`, `perk` ) VALUES ( " .. self.ID .. ", " .. ItemKey .. " );" )
			self:ChatPrint( "You have unlocked the " .. ItemTable.Name .. " perk" )
			self:UpdatePerks()
		end
	end })
end

function PMETA:DropItem( item, amount )
	if item == nil and amount == nil then return false end

	item = tonumber(item) or item
	
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end
	
	amount = tonumber( amount )
	if amount < 1 then return false end
		
	if !self:TakeItem( ItemKey, amount ) then return false end

	local tr = self:GetEyeTrace()
	local DropedEnt = ents.Create( "base_item" )
	DropedEnt:SetNWInt( "Class", ItemKey )
	DropedEnt.Amount = amount
	DropedEnt.Dropped = true

	if self:Health() > 0 then
		DropedEnt:SetPos( self:EyePos() + ( self:GetAimVector() * 30 ) )
		DropedEnt:SetAngles( Angle( 0, self:EyeAngles().y, 0 ) )
		DropedEnt.Dead = false
	else
		DropedEnt:SetPos( self:GetPos() + Vector( math.Rand( -23, 23 ), math.Rand( -23, 23 ), 4 ) )
		DropedEnt:SetAngles( Angle( 0, self:EyeAngles().y, 0 ) )	
		DropedEnt.Dead = true
	end

	DropedEnt:Spawn()

	if DropedEnt:GetPhysicsObject():IsValid() and self:Alive() then
		DropedEnt:GetPhysicsObject():ApplyForceCenter( self:GetAimVector() * 120 )
	end
	
	if self.BackWeapons != nil then
		for _,weapon in pairs( self.BackWeapons ) do
			if ItemTable.OnBack == true then
				table.remove( self.BackWeapons, _ )

				weapon:Remove()

				break
			end
		end
	end

	self:SendLua( [[ UpdateInv() ClearSlot(Slot6) ]] )
end
concommand.Add( "DropItem", function( ply, cmd, args ) 
	ply:DropItem( args[ 1 ], args[ 2 ] ) 
end )

function PMETA:Drink( amount )
	if amount == nil then return false end
	if amount < 0 then return false end

	if self.Thirst + amount > 100 then
		self.Thirst = 100
		self:EmitSound( "drink.wav", 50, 100 )		
	else
		self.Thirst = self.Thirst + amount
		self:EmitSound( "drink.wav", 50, 100 )
	end
	
	net.Start( "Thirst" )
		net.WriteUInt( self.Thirst, 8 )
	net.Send( self )
end

function PMETA:Eat( amount )
	if amount == nil then return false end
	if amount < 0 then return false end

	if self.Hunger + amount > 100 then
		self.Hunger = 100
		self:EmitSound( "eat.wav", 50, 100 )
	else
		self.Hunger = self.Hunger + amount
		self:EmitSound( "eat.wav", 50, 100 )
	end
	
	net.Start( "Hunger" )
		net.WriteUInt( self.Hunger, 8 )
	net.Send( self )
end

function PMETA:EatHurt( heal, hurt )
	if heal == nil then return false end
	if heal < 0 then return false end

	if !hurt then hurt = heal end

	if self.Hunger + heal > 100 then
		self.Hunger = 100
		self:EmitSound( "eat.wav", 50, 100 )		
	else
		self.Hunger = self.Hunger + heal
		self:EmitSound( "eat.wav", 50, 100 )
	end
	
	net.Start( "Hunger" )
		net.WriteUInt( self.Hunger, 8 )
	net.Send( self )

	if !self.IronStomach then
		self:SetHealth(self:Health() - hurt)
	end
	
	if self:Health() <= 0 then 
		self:Kill()
	end	
end

function PMETA:DrinkHurt( heal, hurt )
	if heal == nil then return false end
	if heal < 0 then return false end

	if !hurt then hurt = heal end

	if self.Thirst + heal > 100 then
		self.Thirst = 100
		self:EmitSound( "drink.wav", 50, 100 )		
	else
		self.Thirst = self.Thirst + heal
		self:EmitSound( "drink.wav", 50, 100 )
	end
	
	net.Start( "Thirst" )
		net.WriteUInt( self.Thirst, 8 )
	net.Send( self )

	if !self.IronStomach then
		self:SetHealth(self:Health() - hurt)
	end
	
	if self:Health() <= 0 then 
		self:Kill()
	end
end

function PMETA:Heal( amount )
	if amount == nil then return false end
	if amount < 0 then return false end

	if self:Health() + amount > 100 then
		self:SetHealth( 100 )
		self:EmitSound( "heal.wav", 50, 100 )
	else
		self:SetHealth( self:Health() + amount )
		self:EmitSound( "heal.wav", 50, 100 )
	end
end

concommand.Add( "EmptyClip", function( ply, cmd, args )
	local weapon = ply:GetActiveWeapon()

	if not IsValid( weapon ) then return false end
	
	if weapon.Primary.ClipSize > 0 && weapon:Clip1() > 0 then
		ply:GetActiveWeapon():EmptyClip()
	end
	
	ply:SendLua( [[ UpdateInv() ]] )
end )

function PMETA:DequipItem( item )
	if item == nil then return false end

	item = tonumber(item) or item
		
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end

	if !self.CharTable[ ItemKey ] then return false end
	
	self:GiveItem( ItemKey, 1 )
	self:TakeCharItem( ItemKey )
end
concommand.Add( "DequipItem", function( ply, cmd, args )
	ply:DequipItem( args[ 1 ] )
end )

function PMETA:EquipItem( item )
	if item == nil then return false end

	item = tonumber(item) or item
	
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end
	if self.CharTable[ ItemKey ] then return false end

	local CurDItemAmount = ( self.InvTable[ ItemKey ] and self.InvTable[ ItemKey ] ) or 0	
	if CurDItemAmount < 1 then return false end
	
	if ItemTable.VIP != nil and !self:IsVIP() then
		self:ChatPrint( "[Inventory] VIP Only Equippable!" )
		timer.Simple( 1, function() self:SendLua( [[UpdateInv()]] ) end )

		return false 
	end
	
	local notallowed = false
	for k, _ in pairs( self.CharTable ) do
		local CharItem = GAMEMODE.DayZ_Items[ k ]

		if CharItem.Hat and ItemTable.Hat then notallowed = true break end
		if CharItem.Body and ItemTable.Body then notallowed = true break end
		if CharItem.Primary and ItemTable.Primary then notallowed = true break end
		if CharItem.Secondary and ItemTable.Secondary then notallowed = true break end
		if CharItem.Melee and ItemTable.Melee then notallowed = true break end
	end
	
	if notallowed then
		self:ChatPrint( "[Inventory] Item type already equipped!" )
		timer.Simple( 1, function() self:SendLua( [[UpdateInv()]] ) end )

		return false
	end

	self:TakeItem( ItemKey, 1 )
	
	if ItemTable.ID == "item_grenade" then
		self.CharTable[ ItemKey ] = true
		self:UpdateChar()
		
		return true
	end

	self.CharTable[ ItemKey ] = true
	self:UpdateChar( item )

	PLib:QuickQuery( "INSERT INTO `players_character` ( `user_id`, `item` ) VALUES ( " .. self.ID .. ", " .. ItemKey .. " );" )
end
concommand.Add( "EquipItem", function( ply, cmd, args )
	ply:EquipItem( args[ 1 ] )
end )