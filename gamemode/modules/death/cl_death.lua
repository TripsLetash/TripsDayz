local function ZombiePModel()
	local zombie = net.ReadEntity()
	local zmodel = net.ReadString()
	
	zombie.mdl = ClientsideModel(zmodel)
	zombie.mdl:SetPos(zombie:GetPos())
	zombie.mdl:SetParent(zombie)
	zombie.mdl:AddEffects(EF_BONEMERGE)
	
end
net.Receive("ZombiePModel", ZombiePModel)

local function RZombiePModel()
	local zombie = net.ReadEntity()
		
	if IsValid(zombie.mdl) then
		zombie.mdl:Remove()
	end
end
net.Receive("RZombiePModel", RZombiePModel)