include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.DisplayItemName = false
	timer.Simple(1, function()	
		self.DisplayItemName = true
	end)
end

function ENT:Draw()
    if ( self:GetRenderOrigin() == Vector(0, 0, 0) ) or ( self:GetPos() == Vector(0, 0, 0) ) then return end
    self:DrawModel()
end
