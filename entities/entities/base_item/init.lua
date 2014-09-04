AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	local Class = self:GetNWInt( "Class" )
	if Class == nil then
		self:Remove()
	end
	
	local ItemTable = GAMEMODE.DayZ_Items[ Class ]
	self.ItemTable = ItemTable

	self:SetModel( ItemTable.Model )
	
	if ItemTable.Color then
		self:SetColor( ItemTable.Color )
	end
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self:GetPhysicsObject()
	
	if self.Dropped == true then
		timer.Simple( 300, function() 
			if IsValid( self ) then
				self:Remove()
			end
		end )		
	end
	
	phys:Wake()
end

function ENT:Use( activator, caller )
	if !activator:IsPlayer() then return end
	if activator.CantUse then return end
	activator.CantUse = true
	
	timer.Simple( 1, function()
		activator.CantUse = false
	end )
	
	if activator.Noclip == true then
		activator:Tip( 1, "You cannot loot while in noclip." )	
		
		return false	
	end
		
	if !activator.WeightCur then
		return false
	end
		
	if activator:GetNWBool( "Perk2" ) == false then
		if activator.WeightCur + ( self.ItemTable.Weight * self.Amount ) > 100 then
			activator:Tip( "You cant carry anymore!" )
			
			return false
		end
	elseif activator:GetNWBool( "Perk2" ) == true then
		if activator.WeightCur + ( self.ItemTable.Weight * self.Amount ) > 200 then
			activator:Tip( 1, "You cant carry anymore!" )
			
			return false
		end	
	end		
		
	if self.SpawnLoot == true then
		TotalSpawnedLoot = TotalSpawnedLoot - 1
	end
	
	if self.ItemTable.ID == "item_flashlight" then
		activator:Tip( 3, "Press [F] to use the flashlight" )
	end
	
	if self.ItemTable.ID == "item_binoculars" then
		activator:Tip( 3, "Hold [LMB] to zoom in and hold [RMB] to zoom out." )
	end	
	
	if self.ItemTable.Gun != nil then
		activator:Tip( 3, "Remember to unload your gun before logging out to avoid losing the clip!" )
	end		
	
	activator:EmitSound( "items/itempickup.wav", 110, 100 )
	activator:GiveItem( self.ItemTable.ID, self.Amount )

	self:Remove()
end