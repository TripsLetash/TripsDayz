AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.AddNetworkString("UpdateBackpack")
util.AddNetworkString("UpdateBackpackChar")

util.AddNetworkString("net_CloseLootMenu")
util.AddNetworkString("net_LootMenu")

function ENT:Initialize()
	self:SetModel("models/Fallout 3/Campish_Pack.mdl")	

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	--self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		
	--self:SetAngles(Angle(90,0,0))
	
	--self:SetPos(self:GetPos()+Vector(0,0,5))
	
	self:GetPhysicsObject():Wake()
		
end

function ENT:OnTakeDamage(dmginfo)
end
function ENT:Detach()
end
function ENT:StartTouch(ent) 
end
function ENT:EndTouch(ent)
end
function ENT:AcceptInput(name,activator,caller)
end
function ENT:KeyValue(key,value)
end
function ENT:OnRemove()
end
function ENT:OnRestore()
end
function ENT:Touch(hitEnt) 
end
function ENT:Use(activator,caller)

	if !activator:IsPlayer() then return end
	if activator.CantUse then return end
	activator.CantUse = true
	
	timer.Simple(1, function() activator.CantUse = false end)
	
	SendBackpack(self,activator)
	
end

function SendBackpack(backpack, player)
	local Total = 0
	
	backpack.ItemTable = backpack.ItemTable or {}
	backpack.CharTable = backpack.CharTable or {}
	
	for k, v in pairs(backpack.ItemTable) do
		Total = Total + v
	end
	
	for k, v in pairs(backpack.CharTable) do
		Total = Total + v
	end
	
	net.Start("UpdateBackpack")
		net.WriteTable(backpack.ItemTable)		
	net.Send(player)		
	
	net.Start("UpdateBackpackChar")
		net.WriteTable(backpack.CharTable)		
	net.Send(player)	

	if Total == 0 then
		--backpack:Remove()
		
		player:ChatPrint("This bag is empty.")
		--umsg.Start("CloseLootMenu", player)
		--umsg.End()		
		net.Start("net_CloseLootMenu")
		net.Send(player)
		
		player.LootingBackpack = nil
		
		return false
	end
	
	--umsg.Start("LootMenu", player)
		--umsg.Float(tonumber(backpack:EntIndex()))
	--umsg.End()
	
	net.Start("net_LootMenu")
		net.WriteFloat(tonumber(backpack:EntIndex()))
	net.Send(player)
	
	player.LootingBackpack = backpack:EntIndex()
end

function SendBackpackFromCon(ply)
	SendBackpack(Entity(ply.LootingBackpack), ply)
end

concommand.Add("SendBackpack",function(ply, cmd, args) 
	SendBackpackFromCon(ply) 
end)

