local DecorModels = {

	{ -- Car Block. Fuck bulb19uk.
		mdl = "models/props/cs_assault/pylon.mdl",
		pos = Vector(5248,-8224,0),
		ang = Angle(0.062, 89.394, 0.189),
	},
	{ -- Car Block. Fuck bulb19uk.
		mdl = "models/props/cs_assault/pylon.mdl",
		pos = Vector(3586,-8718,0),
		ang = Angle(0.062, 89.394, 0.189),
	}

}

local function SpawnDecor()
	print("Calling InitPostEntity->Decor Creation!")
	for k, v in pairs(DecorModels) do
		local prop = ents.Create("prop_physics")
		prop:SetModel(v.mdl)
		prop:SetPos(v.pos)
		prop:SetAngles(v.ang)
		if v.col then
			prop:SetRenderMode(1)
			prop:SetColor(v.col)
		end
		if v.mat then
			prop:SetMaterial(v.mat)
		end
		prop:Spawn()
		prop:SetMoveType(MOVETYPE_NONE)
		if IsValid(prop:GetPhysicsObject()) then
			prop:GetPhysicsObject():EnableMotion(false)
		end
	end	
	
end
hook.Add("InitPostEntity", "SpawnDecor", SpawnDecor)