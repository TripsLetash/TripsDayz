AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
end

function ENT:Think()
	OwnerBack = Entity(self:GetNWInt("owner"))
	if !OwnerBack:IsValid() or !OwnerBack:Alive() then
		self:Remove()
	end
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

