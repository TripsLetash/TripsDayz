-- cl_weapondrawing
-- draws weapons on the players

local clientModels = {}
clientModels["melee_knife"] = ClientsideModel("models/weapons/w_knife_t.mdl")
clientModels["melee_bat_dayz"] = ClientsideModel("models/weapons/w_basebt2.mdl")
clientModels["melee_bowie"] = ClientsideModel("models/bowie_knife.mdl")
clientModels["melee_crowbar_dayz"] = ClientsideModel("models/weapons/w_crowbar.mdl")
clientModels["melee_yamato"] = ClientsideModel("models/tiggomods/weapons/dmc4/w_yamato.mdl")
clientModels["swb_primary_ak47"] = ClientsideModel("models/weapons/w_rif_ak47.mdl")
clientModels["swb_primary_awp"] = ClientsideModel("models/weapons/w_snip_awp.mdl")
clientModels["swb_primary_famas"] = ClientsideModel("models/weapons/w_rif_famas.mdl")
clientModels["swb_secondary_deagle"] = ClientsideModel("models/weapons/w_pist_deagle.mdl")
--clientModels["weapon_grenade"] = ClientsideModel("models/weapons/w_eq_fraggrenade.mdl")

hook.Add("PostPlayerDraw","JBDrawWeaponsOnPlayer",function(p)
	local weps = p:GetWeapons()

	for k, v in pairs(weps)do
		local mdl = clientModels[v:GetClass()]
		if mdl and p:GetActiveWeapon() and p:GetActiveWeapon():IsValid() and v:GetClass() != p:GetActiveWeapon():GetClass() then
			if string.Left(v:GetClass(),13) == "swb_secondary" then
				local boneindex = p:LookupBone("ValveBiped.Bip01_R_Thigh")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),90)
					mdl:SetRenderOrigin(pos+(ang:Right()*4.5)+(ang:Up()*-1.5))
					mdl:SetRenderAngles(ang)
					mdl:DrawModel()
				end
			elseif string.Left(v:GetClass(),11) == "swb_primary" and v:GetClass() != p:GetActiveWeapon():GetClass() then
				local boneindex = p:LookupBone("ValveBiped.Bip01_Spine2")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),0)
					mdl:SetRenderOrigin(pos+(ang:Right()*4)+(ang:Forward()*-5))
					ang:RotateAroundAxis(ang:Right(),-15)
					mdl:SetRenderAngles(ang)
					mdl:DrawModel()
				end
			elseif string.Left(v:GetClass(),5) == "melee" and v:GetClass() != p:GetActiveWeapon():GetClass() then
				local boneindex = p:LookupBone("ValveBiped.Bip01_L_Thigh")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),90)
					ang:RotateAroundAxis(ang:Right(),-56)
					mdl:SetRenderOrigin(pos+(ang:Right()*-4.2)+(ang:Up()*2))
					mdl:SetRenderAngles(ang)
					mdl:DrawModel()
				end
			elseif string.Left(v:GetClass(),10) == "weapon_grenade" and v:GetClass() != p:GetActiveWeapon():GetClass() then
				local boneindex = p:LookupBone("ValveBiped.Bip01_L_Thigh")
				if boneindex then
					local pos, ang = p:GetBonePosition(boneindex)

					ang:RotateAroundAxis(ang:Forward(),10)
					ang:RotateAroundAxis(ang:Right(),90)
					mdl:SetRenderOrigin(pos+(ang:Right()*-6.5)+(ang:Up()*-1))
					mdl:SetRenderAngles(ang)
					mdl:DrawModel()
				end
			end
		end	
	end
end)

function GM:CheckWeaponTable(class,model)
	if clientModels[class] then return end

	clientModels[class] = ClientsideModel(model,RENDERGROUP_OPAQUE)
end

function printmodels()
	PrintTable(clientModels)
end