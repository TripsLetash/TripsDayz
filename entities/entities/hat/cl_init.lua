include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Initialize()
	--self:SetRenderBounds( Vector(-10000,-10000,-10000), Vector(10000,10000,10000) )
end

function ENT:Think()
	self.Entity:DrawModel()	
end

function ENT:Draw()

	OwnerBack = Entity(self:GetNWInt("Owner"))

	if !IsValid(OwnerBack) then return false end
	if !OwnerBack:Alive() then return false end
	
	if OwnerBack:GetMoveType() != MOVETYPE_WALK then return false end
	
	if OwnerBack:IsPlayer() then
		self.BoneIndex = OwnerBack:LookupBone("ValveBiped.Bip01_Head1");
		if self.BoneIndex then
			if OwnerBack:GetBonePosition( self.BoneIndex ) then
				self.BonePos , self.BoneAng = OwnerBack:GetBonePosition( self.BoneIndex )
			else
				return false
			end
		else
			return false
		end
				
		if self:GetModel() == "models/props_interiors/pot02a.mdl" then
			
            local WepNewPos = self.BonePos +(self.BoneAng:Forward() * 7) + self.BoneAng:Right() * -3 + self.BoneAng:Up() * 4
			self.BoneAng:RotateAroundAxis(self.BoneAng:Right(), 90)
			self.BoneAng:RotateAroundAxis(self.BoneAng:Up(), 135)
			self:SetPos(WepNewPos)
			self:SetAngles(self.BoneAng)
			
		elseif self:GetModel() == "models/props/cs_office/snowman_hat.mdl" then
			
			self:SetModelScale(0.79, 0)
		
            local WepNewPos = self.BonePos +((self.BoneAng:Forward() *6.5) + (self.BoneAng:Right() * 1) + self.BoneAng:Up() * -0.1)
			self.BoneAng:RotateAroundAxis(self.BoneAng:Right(), -95)
			self.BoneAng:RotateAroundAxis(self.BoneAng:Forward(), -10)
			self.BoneAng:RotateAroundAxis(self.BoneAng:Up(), 180)
			self:SetPos(WepNewPos)
			self:SetAngles(self.BoneAng)
			
		elseif self:GetModel() == "models/props_junk/metalbucket01a.mdl" then
			
			self:SetModelScale(0.6, 0)
			
			local WepNewPos = self.BonePos +((self.BoneAng:Forward() * 9.5) + (self.BoneAng:Right() * 0.9))
			self.BoneAng:RotateAroundAxis(self.BoneAng:Right(), 90)
			self:SetPos(WepNewPos)
			self:SetAngles(self.BoneAng)
			
		elseif self:GetModel() == "models/props_c17/metalpot001a.mdl" then
		
			self:SetModelScale(0.6, 0)
		
            local WepNewPos = self.BonePos +((self.BoneAng:Forward() *8.5) + (self.BoneAng:Right() * 1))
			self.BoneAng:RotateAroundAxis(self.BoneAng:Right(), 90)
			self:SetPos(WepNewPos)
			self:SetAngles(self.BoneAng)
			
		elseif string.lower(self:GetModel()) == "models/props_junk/trafficcone001a.mdl" then
			
			self:SetModelScale(0.5, 0)
			
			local WepNewPos = self.BonePos +((self.BoneAng:Forward() *14.4) + (self.BoneAng:Right() * 1))
			self.BoneAng:RotateAroundAxis(self.BoneAng:Right(), 270)
			self.BoneAng:RotateAroundAxis(self.BoneAng:Up(), 270)
			self:SetPos(WepNewPos)
			self:SetAngles(self.BoneAng)	
							
		end
		
	end
		
	if LocalPlayer():GetNetworkedInt("thirdperson") == 1 or OwnerBack != LocalPlayer() then
		self.Entity:DrawModel()	
	end
end

