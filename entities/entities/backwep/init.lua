AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
end

function ENT:Think()
	if !self.DoNextThink then self.DoNextThink = CurTime() + 2 end
	if self.DoNextThink > CurTime() then return end

	self.DoNextThink = CurTime() + 1

	self.Owner = Entity(self:GetNWInt("owner"))
	
	if !IsValid(self.Owner) then return end
	if self.Owner:Alive() then return end
	
	MsgAll(self.Owner.InvTable[self.itemid])
	
	if self.Owner.InvTable[self.itemid] == nil then MsgAll("removed!") self:Remove() return end
	if self.Owner.InvTable[self.itemid] < 1 then MsgAll("removed!") self:Remove() return end
	
	
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
function ENT:PhysicsCollide(data,physobj)
end
function ENT:PhysicsSimulate(phys,deltatime) 
end
function ENT:PhysicsUpdate(phys) 
end
function ENT:Touch(hitEnt) 
end
function ENT:UpdateTransmitState(Entity)
end
function ENT:Use(activator,caller)
end

