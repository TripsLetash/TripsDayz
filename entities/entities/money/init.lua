AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.AddNetworkString("net_Money")

function ENT:Initialize()
	self:SetModel("models/props/cs_assault/money.mdl")	

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

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

		net.Start("net_Money")
			net.WriteFloat(self.Money)
		net.Send(activator)
		
		activator:EmitSound("items/itempickup.wav",110,100)
		self:Remove()
		
		activator:GiveMoney(self.Money)
		
end

