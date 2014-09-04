local EMETA = FindMetaTable( "Entity" )

EMETA.oIsNPC = EMETA.oIsNPC or EMETA.IsNPC

function EMETA:IsNPC() 
	if !self:IsValid() then return false end
	
	if self:GetClass() == "npc_nb_common" then 
		return true
	else 
		self:oIsNPC() 
	end
end

function HackyInit()
	hook.Remove( "PlayerTick", "TickWidgets" )
end
hook.Add( "Initialize", "HackyInit", HackyInit )

GM.Util = {}

function GM.Util:GetItemByID( ID )
	for Key = 1, #GAMEMODE.DayZ_Items do
		local Item = GAMEMODE.DayZ_Items[ Key ]

		if not ( Item.ID == ID ) then continue end

		return Item, Key
	end
end