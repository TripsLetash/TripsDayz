local DecorModels = {
	{ -- Food pile behind safezone vendor.
		mdl = "models/props_junk/food_pile02.mdl",
		pos = Vector(-2874.583252, -9688.693359, 40),
		ang = Angle(0, 90, 0)
	},
	
	{ -- Safezone CyberGmod Logo
		mdl = "models/freeman/cyb_hexagon_large.mdl",
		pos = Vector(-2811.000000, -9855.000000, 192.000000),
		ang = Angle(0.000, 180.000, 0.000),
		col = Color(41, 128, 185),
	},
}

local function SpawnDecor()
	print("Calling InitPostEntity->Decor Creation!")
	
	for k, v in pairs(DecorModels) do
		local ent = ClientsideModel(v.mdl, RENDERGROUP_BOTH)
		ent:SetPos(v.pos)
		ent:SetAngles(v.ang)
		if v.col then
			ent:SetRenderMode(1)
			ent:SetColor(v.col)
		end
		if v.mat then
			ent:SetMaterial(v.mat)
		end
		
	end
end
hook.Add("InitPostEntity", "SpawnDecor", SpawnDecor)