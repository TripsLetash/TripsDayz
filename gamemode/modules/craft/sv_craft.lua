function PMETA:CraftItem( item, amount )
	if item == nil and amount == nil then return false end
	
	item = tonumber(item) or item
	
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end

	amount = math.Round( amount )
	if amount < 1 then return false end
				
	local hasitems = true
	for _, v in pairs( ItemTable.ReqCraft ) do
		local v_itemtable, v_key = GAMEMODE.Util:GetItemByID( v )
		local CurDItemAmount = ( self.InvTable[ v_key ] and self.InvTable[ v_key ] ) or 0	

		if CurDItemAmount < 1 then hasitems = false end
	end
		
	if !hasitems then self:ChatPrint( "You don't have the required materials!" ) return false end
		
	for _, v in pairs( ItemTable.ReqCraft ) do
		local v_itemtable, v_key = GAMEMODE.Util:GetItemByID( v )
		
		self:TakeItem( v_key, amount )
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

	self:GiveItem( ItemKey, amount )

	self:ChatPrint( "You have crafted: " .. ItemTable.Name )
	
	self:XPAward( 10 )
	
	self:EmitSound( "physics/metal/metal_sheet_impact_bullet1.wav", 75, 100 )
end
concommand.Add( "CraftItem", function( ply, cmd, args )
	ply:CraftItem( args[ 1 ], 1 )
end )

function PMETA:BPItem( item, amount )
	if item == nil and amount == nil then return false end
	
	item = tonumber(item) or item
	
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end
	if self.InvTable[ ItemKey ] < 1 then return end

	amount = math.Round( amount )
	if amount < 1 then return false end
	
	if !self:HasItem( "item_toolkit" ) then self:ChatPrint( "You need a Tool Kit to analyse things!" ) return false end
	
	local itemlist = ""
	for _, v in pairs( ItemTable.ReqCraft ) do
		local v_itemtable, v_key = GAMEMODE.Util:GetItemByID( v )

		itemlist = itemlist .. v_itemtable.Name .. " & "
	end

	itemlist = string.TrimRight( string.Trim( itemlist ), "&" )
	
	self:TakeItem( ItemKey, amount )

	self:ChatPrint( "You Analysed: " .. ItemTable.Name )
	self:ChatPrint( itemlist )
	
	self:SendLua( [[ UpdateInv() ClearSlot(Slot3) ]] )
end
concommand.Add( "BPItem", function( ply, cmd, args )
	ply:BPItem( args[ 1 ], 1 )
end )

function PMETA:DecompileItem( item, amount )
	if item == nil and amount == nil then return false end
	
	item = tonumber(item) or item
	
	local ItemTable, ItemKey
	if isnumber( item ) then
		ItemTable, ItemKey = GAMEMODE.DayZ_Items[ item ], item
	elseif ( isstring( item ) ) then
		ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	end
	
	if ItemTable == nil then return false end
	if self.InvTable[ ItemKey ] < 1 then return end

	amount = math.Round( amount )
	if amount < 1 then return false end
	
	if !self:HasItem( "item_toolkit" ) then self:ChatPrint( "You need a Tool Kit to decompile things!" ) return false end
	
	for _, v in pairs( ItemTable.Decompiles ) do
		local v_itemtable, v_key = GAMEMODE.Util:GetItemByID( v )

		self:GiveItem( v_key, amount )
	end
		
	if self:GetNWBool( "Perk2" ) == false then
		if self.WeightCur + ( GAMEMODE.DayZ_Items[ item ].Weight * amount ) > 100 then
			self:ChatPrint( "You can't carry anymore." )

			return false
		end
	elseif self:GetNWBool( "Perk2" ) == true then
		if self.WeightCur + ( GAMEMODE.DayZ_Items[ item ].Weight * amount ) > 200 then
			self:ChatPrint( "You can't carry anymore." )

			return false
		end	
	end

	self:TakeItem( ItemKey, amount )

	self:SendLua( [[ UpdateInv() ClearSlot(Slot4) ]] )
	
	self:ChatPrint( "You decompiled: " .. ItemTable.Name )
	self:EmitSound( "item_craft.wav", 75, 100 )
end
concommand.Add( "DecompileItem", function( ply, cmd, args )
	ply:DecompileItem( args[ 1 ], 1 )
end )