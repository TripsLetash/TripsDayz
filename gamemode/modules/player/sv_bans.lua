DayZ_WeaponBans = {

}

function PMETA:IsWepBanned()
	if table.HasValue(DayZ_WeaponBans, self:SteamID()) then self:ChatPrint("You are banned from using weapons.") return true end
	return false
end
