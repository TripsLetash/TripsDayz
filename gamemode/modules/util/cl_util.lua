function PMETA:EntVisible( ent )
    local tracedata = {}
    tracedata.start = LocalPlayer():EyePos()
    tracedata.endpos = ent:GetPos()
	tracedata.filter = self
	local tr = util.TraceLine( tracedata )
	
	if tr.Entity:IsValid() then
		local Class = ent:GetNWInt( "Class" )
		
		if !Class then
			return false
		end
		
		local ItemTable = GAMEMODE.DayZ_Items[ Class ]
		
		if tr.Entity == ent then
			return true
		elseif ItemTable.LootType == "Weapon" then
			return true
		elseif ItemTable.ID == "item_knife" then
			return true
		else
			return false
		end
	end
end

function GM:PostDrawViewModel( vm, ply, weapon )
	if ( weapon.UseHands || !weapon:IsScripted() ) then
		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end
	end
end

function GM:Tick()
	local client = LocalPlayer()

	if IsValid( client ) then
		if client:Alive() then
			WSWITCH:Think()
		end
	end
end

local function SendWeaponDrop()
   RunConsoleCommand( "cyb_dropweapon" )

   -- Turn off weapon switch display if you had it open while dropping, to avoid
   -- inconsistencies.
   WSWITCH:Disable()
end

function GM:PlayerBindPress( ply, bind, pressed )
	if not IsValid( ply ) then return end

	if bind == "invnext" and pressed then
		WSWITCH:SelectNext()
		
		return true
	elseif bind == "invprev" and pressed then
		WSWITCH:SelectPrev()
		
		return true
	elseif bind == "+attack" then
		if WSWITCH.Show then
			if not pressed then
				WSWITCH:ConfirmSelection()
			end

			return true
		end
	elseif string.sub( bind, 1, 4 ) == "slot" and pressed then
		local idx = tonumber( string.sub( bind, 5, -1 ) ) or 1

		WSWITCH:SelectSlot( idx )
		
		return true
	end
end