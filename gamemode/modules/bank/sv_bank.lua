util.AddNetworkString( "UpdateBank" )
util.AddNetworkString( "UpdateBankFull" )
util.AddNetworkString( "UpdateBankWeight" )

Banks = {}

function SpawnTheBank()
	print( "Calling InitPostEntity->Bank Creation!" )

	Bank_Box = ents.Create( "bank" )
	Bank_Box:SetPos( Vector(4999,-8900,110) )
	Bank_Box:SetAngles( Angle( 0.000, 90.000, -0.000 ) )
	Bank_Box:Spawn()
end
hook.Add( "InitPostEntity", "SpawnBanks", SpawnTheBank )

function PMETA:UpdateBank( item, amount )
	if item != nil and amount != nil then
		item = tonumber(item) or item
		
		net.Start( "UpdateBank" )
			net.WriteUInt( item, 16 )
			net.WriteFloat( amount )
		net.Send( self )
	else
		net.Start( "UpdateBankFull" )
			net.WriteTable( self.BankTable )	
		net.Send( self )
	end
	
	self:AddWeight()
end

function PMETA:Deposit( item, amount )
	if item == nil and amount == nil then return false end
	
	item = tonumber(item) or item

	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end

	if ItemTable == nil then return false end

	if !self.BankWeightCur then return false end

	amount = math.Round( amount )
	if amount < 1 then return false end
	
	if self.BankWeightCur + ( ItemTable.Weight * amount ) > ( MaxBankWeight[ self:GetUserGroup() ] + self:GetNWInt( "extraslots" ) ) then
		self:ChatPrint( "Your bank can't carry anymore." )

		return false
	end

	if !self:TakeItem( item, amount ) then return false end
	
	local BankCurItemAmount = ( self.BankTable[ ItemKey ] and self.BankTable[ ItemKey ] ) or 0
	local BankNewItemAmount = BankCurItemAmount + amount

	if BankCurItemAmount > 0 then
		PLib:QuickQuery( "UPDATE `players_bank` SET `amount` = " .. BankNewItemAmount .. " WHERE `user_id` = " .. self.ID .. " AND `item` = " .. ItemKey .. ";" )
	else
		PLib:QuickQuery( "INSERT INTO `players_bank` ( `user_id`, `item`, `amount` ) VALUES ( " .. self.ID .. ", " .. ItemKey .. ", " .. amount .. " );" )
	end

	self.BankTable[ ItemKey ] = BankNewItemAmount
	self:UpdateBank( ItemKey, BankNewItemAmount )
end
concommand.Add( "DepositItem", function( ply, cmd, args ) 
	ply:Deposit( args[ 1 ], args[ 2 ] ) 
end )

function PMETA:Withdraw( item, amount )
	if item == nil and amount == nil then return false end
	
	item = tonumber(item) or item
		
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end

	if ItemTable == nil then return false end

	if !self.WeightCur then	return false end

	amount = math.Round( amount )
	if amount < 0 then return false end
		
	local CurItemAmount = ( self.BankTable[ ItemKey ] and self.BankTable[ ItemKey ] ) or 0
	if CurItemAmount < 1 then return false end
	
	if amount > CurItemAmount then amount = CurItemAmount end
		
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
		
	local NewItemAmount = CurItemAmount - amount

	if NewItemAmount < 1 then
		self.BankTable[ ItemKey ] = nil

		PLib:QuickQuery( "DELETE FROM `players_bank` WHERE `user_id` = " .. self.ID .. " AND `item` = " .. ItemKey .. ";" )
		PLib:QuickQuery( "ALTER TABLE `players_bank` AUTO_INCREMENT = 1;" )
	else
		self.BankTable[ ItemKey ] = NewItemAmount

		PLib:QuickQuery( "UPDATE `players_bank` SET `amount` = " .. NewItemAmount .. " WHERE `user_id` = " .. self.ID .. " AND `item` = " .. ItemKey .. ";" )
	end

	self:GiveItem( ItemKey, amount )
	self:UpdateBank( ItemKey, NewItemAmount )
end
concommand.Add( "WithdrawItem", function( ply, cmd, args ) 
	ply:Withdraw( args[ 1 ], args[ 2 ] ) 
end )