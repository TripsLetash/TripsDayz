
local SlotPos = {}
SlotPos[1] = Vector(8575,3218,-210)
SlotPos[2] = Vector(8525,3218,-210)
SlotPos[3] = Vector(8478,3218,-210)
SlotPos[4] = Vector(8425,3218,-210)
SlotPos[5] = Vector(8375,3218,-210)
SlotPos[6] = Vector(8325,3218,-210)

function SetupCasino()
	print("Calling InitPostEntity->SetupCasino")
	
	for k, v in pairs(SlotPos) do
		local casino = ents.Create("slotmachine")
		casino:SetPos(v)		
		casino:Spawn()
	end
	
	/*local piano = ents.Create("gmt_instrument_piano")
	piano:SetPos( Vector(-3249.000000, -11204.000000, -255.089996) )
	piano:Spawn()
	piano:SetMoveType(MOVETYPE_NONE)
	if IsValid(piano:GetPhysicsObject()) then
		piano:GetPhysicsObject():EnableMotion(false)
	end*/
	
end
hook.Add("InitPostEntity", "SetupCasino", SetupCasino)