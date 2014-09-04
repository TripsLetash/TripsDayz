AddCSLuaFile()
ENT.Type 			= "anim"
ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT
ENT.SZClipZone			= true

local cyb_mat = Material("cyb_mat/cyb_noentry")

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate2x6.mdl")
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	
	self:SetRenderMode(1)
	
	self:SetColor( Color( 255, 255, 255, 1 ) )
		
	if SERVER then 
		self:SetTrigger( true )
	end
end

function ENT:GetRotatedVec(vec)
	local v = self:WorldToLocal(vec)
	v:Rotate(self:GetAngles())
	return self:LocalToWorld( v )
end

function ENT:ShouldCollide(ply)
	if ply:IsPlayer() then
		if ( ( ply:GetNWInt("TagTime") > CurTime() ) or !ply:IsVIP()) then
			return true
		else
			return false
		end
	end
	return true
end

-- get velocity of player, and double it.
function ENT:StartTouch(ply)
	if self:ShouldCollide(ply) then
		ply:SetVelocity( ply:GetVelocity() * -8 )
		ply.SZTipTime = ply.SZTipTime or 0
		
		if ply.SZTipTime > CurTime() then return end
		ply.SZTipTime = CurTime() + 5
		ply:Tip(3, "This Area is VIP Only! Consider upgrading your account on our website!", Color(255, 255, 0))
	end
end

function ENT:Draw()
	--self:DrawModel()
	self:DestroyShadow()

	local pl = LocalPlayer()
	
	if (not self:ShouldCollide(pl) and not IsValid(LocalPlayer():GetVehicle())) then return end
	
	local pos = self:GetRotatedVec(self.Entity:GetPos() + self.Entity:GetUp() * 54 + self.Entity:GetRight() * -32)
	local dir = self.Entity:GetForward()

	local mins, maxs = self:GetCollisionBounds()

	local w = math.floor(math.max(maxs.x, maxs.y) / 32)
	
	for i = 1, w, 1 do
		if (w == 1) then
			i = 1.15
		end

		local pos = self.Entity:GetPos() + self.Entity:GetUp() * 2
		render.SetMaterial(cyb_mat)
		render.DrawQuadEasy(
			pos,
			self.Entity:GetUp(),
			32, 32,
			Color( 255, 255, 255, 255 ),
			180
		)

		render.SetMaterial(cyb_mat)
		render.DrawQuadEasy(
			pos,
			self.Entity:GetUp()*-1,
			32, 32,
			Color( 255, 255, 255, 255 ),
			180
		)
	end
end