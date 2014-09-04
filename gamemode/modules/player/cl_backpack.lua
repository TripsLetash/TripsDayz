local playerBackpackModel = {}
local backpackModel = "models/Fallout 3/Campish_Pack.mdl"

hook.Add("PostPlayerDraw", 'DayZ_DrawPlayerBackpack', function(ply)
	if not ply:Alive() then return end
	if ply == LocalPlayer() and GetViewEntity():GetClass() == "player" then return end -- check for third person too
	if not playerBackpackModel[ply] then
		playerBackpackModel[ply] = ClientsideModel(backpackModel, RENDERGROUP_OPAQUE)
		playerBackpackModel[ply]:SetNoDraw(true)
	return end

	local model = playerBackpackModel[ply]
	local BoneIndex = ply:LookupBone("valvebiped.bip01_pelvis")
	local BonePos
	local BoneAng
	
	if BoneIndex then
		if ply:GetBonePosition(BoneIndex) then
			BonePos, BoneAng = ply:GetBonePosition(BoneIndex)
		else return end
	else return end
		
	local pos = BonePos
	local ang = BoneAng
	local NewPos = pos + (ang:Right() * -6) + (ang:Up() * -10) + (ang:Forward() * -2)- Vector(0,0,16)
	model:SetRenderOrigin(NewPos)
	model:SetRenderAngles(ang+Angle(0,90,-90))
	model:SetupBones()
	model:DrawModel()
	model:SetRenderOrigin()
	model:SetRenderAngles()
end)