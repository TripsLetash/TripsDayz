print("Loaded levels.lua!")

util.AddNetworkString( "net_XPAward" )
util.AddNetworkString( "net_LevelUp" )
util.AddNetworkString( "net_AddUnlock" )

function PMETA:GetLevel()
	return self:GetNWInt( "lvl" )
end

function PMETA:XPAward( amount )
	amount = tonumber( amount )

	if amount != nil and amount > 0 then
		local OldLevel = self:GetLevel()

		self:SetNWInt( "xp", self:GetNWInt( "xp" ) + amount )
		
		net.Start( "net_XPAward" )
			net.WriteFloat( amount )
		net.Send( self )
		
		if self:GetNWInt( "xp" ) >= 1000 then
			self:SetNWInt( "lvl", self:GetNWInt( "lvl" ) + 1 )
			self:SetNWInt( "xp", 0 )
		end
		
		-- LEVEL UP!
		local NewLevel = self:GetLevel()
		if NewLevel > OldLevel then
			self:LevelUp()
		end
		
	end
end

function PMETA:LevelUp()

	print( self:Nick() .. " levelled up!" )

	net.Start( "net_LevelUp" )
	net.Send( self )
	
	self:GiveCredits( 5 )
			
	self:EmitSound( "smb3_powerup.wav", 35, 100 )

	for k, v in pairs(GAMEMODE.DayZ_Unlocks) do
		if self:GetLevel() == v.LvlReq then
			self:AddUnlock(k)
		end
	end
	
end

function PMETA:CheckUnlocks()
	for k, v in pairs(GAMEMODE.DayZ_Unlocks) do
		if ( self:GetLevel() > v.LvlReq ) or ( self:GetLevel() == v.LvlReq ) then
			self:AddUnlock(k)
		end
	end
end

function PMETA:CheckUnlocksSilent()
	for k, v in pairs(GAMEMODE.DayZ_Unlocks) do
		if ( self:GetLevel() > v.LvlReq ) or ( self:GetLevel() == v.LvlReq ) then
			self:AddUnlockSilent(k)
		end
	end
end

function PMETA:AddUnlockSilent(id)
	if GAMEMODE.DayZ_Unlocks[id].Function != nil then GAMEMODE.DayZ_Unlocks[id].Function(self) end
end

function PMETA:AddUnlock(id)
	
	self:ChatPrint(GAMEMODE.DayZ_Unlocks[id].Desc)
	
	net.Start("net_AddUnlock")
		net.WriteString(GAMEMODE.DayZ_Unlocks[id].Desc)
	net.Send(self)

	if GAMEMODE.DayZ_Unlocks[id].Function != nil then GAMEMODE.DayZ_Unlocks[id].Function(self) end
end


