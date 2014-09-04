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

	OwnerBack = Entity(self:GetNWInt("owner"))

	if OwnerBack:IsPlayer() and OwnerBack:IsValid() and OwnerBack:Alive() then
		self.BoneIndex = OwnerBack:LookupBone("ValveBiped.Bip01_Spine4");
		if self.BoneIndex then
			if OwnerBack:GetBonePosition( self.BoneIndex ) then
				self.BonePos , self.BoneAng = OwnerBack:GetBonePosition( self.BoneIndex )
			else
				return false
			end
		else
			return false
		end
		if self:GetModel() == "models/weapons/w_rif_ak47.mdl" then
			local WepPos = self.BonePos;
			local WepAng = self.BoneAng;
			local WepNewPos = WepPos + (WepAng:Forward() * -10) + (WepAng:Right() * 2) + (WepAng:Up() * -8);
			self:SetPos(WepNewPos)
			self:SetAngles(WepAng)
			if OwnerBack:GetActiveWeapon():IsValid() and OwnerBack:GetActiveWeapon():GetModel() == "models/weapons/w_rif_ak47.mdl" then
				NoDraw = true
			else
				NoDraw = false
			end
		elseif self:GetModel() == "models/weapons/w_rif_m4a1.mdl" then
			local WepPos = self.BonePos;
			local WepAng = self.BoneAng + Angle(0,0,180);
			local WepNewPos = WepPos + (WepAng:Forward() * -10) + (WepAng:Right() * -2) + (WepAng:Up() * -8);
			self:SetPos(WepNewPos)
			self:SetAngles(WepAng)
			if OwnerBack:GetActiveWeapon():IsValid() and OwnerBack:GetActiveWeapon():GetModel() == "models/weapons/w_rif_m4a1.mdl" then
				NoDraw = true
			else
				NoDraw = false
			end
	
		elseif self:GetModel() == "models/weapons/w_shot_m3super90.mdl" then
			local WepPos = self.BonePos;
			local WepAng = self.BoneAng + Angle(0,60,-35);
			local WepNewPos = WepPos + (WepAng:Forward() * -1) + (WepAng:Right() * 7) + (WepAng:Up() * 2);
			self:SetPos(WepNewPos)
			self:SetAngles(WepAng)
			if OwnerBack:GetActiveWeapon():IsValid() and OwnerBack:GetActiveWeapon():GetModel() == "models/weapons/w_shot_m3super90.mdl" then
				NoDraw = true
			else
				NoDraw = false
			end	
		elseif self:GetModel() == "models/weapons/w_rif_famas.mdl" then
			local WepPos = self.BonePos;
			local WepAng = self.BoneAng + Angle(0,60,-35);
			local WepNewPos = WepPos + (WepAng:Forward() * -10) + (WepAng:Right() * 7) + (WepAng:Up() * 2);
			self:SetPos(WepNewPos)
			self:SetAngles(WepAng)
			if OwnerBack:GetActiveWeapon():IsValid() and OwnerBack:GetActiveWeapon():GetModel() == "models/weapons/w_shot_m3super90.mdl" then
				NoDraw = true
			else
				NoDraw = false
			end					
		elseif self:GetModel() == "models/weapons/w_snip_awp.mdl" then
			local WepPos = self.BonePos;
			local WepAng = self.BoneAng + Angle(0,60,-35);
			local WepNewPos = WepPos + (WepAng:Forward() * -10) + (WepAng:Right() * 7) + (WepAng:Up() * 2);
			self:SetPos(WepNewPos)
			self:SetAngles(WepAng)
			if OwnerBack:GetActiveWeapon():IsValid() and OwnerBack:GetActiveWeapon():GetModel() == "models/weapons/w_shot_m3super90.mdl" then
				NoDraw = true
			else
				NoDraw = false
			end					
		end
	end
		
	if NoDraw == true then

	else
		if LocalPlayer():GetNetworkedInt("thirdperson") == 1 or OwnerBack != LocalPlayer() then
			self.Entity:DrawModel()	
		end
	end
end

