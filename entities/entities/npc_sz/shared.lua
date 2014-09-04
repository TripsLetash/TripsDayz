 ENT.Base = "base_ai"
 ENT.Type = "ai"
  
 ENT.AutomaticFrameAdvance = true
   
 ENT.Spawnable = false
 ENT.AdminSpawnable = false
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
 
	self.AutomaticFrameAdvance = bUsingAnim
 
end
