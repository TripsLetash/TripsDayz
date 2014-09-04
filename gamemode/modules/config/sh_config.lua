PHDayZ = PHDayZ or {}

PHDayZ.Version = "3.02"

PHDayZ.LogoPath = ""

PHDayZ.VehHealthMaterial = "gui/icon_cyb_64_fuel.png"
PHDayZ.VehFuelMaterial = "gui/icon_cyb_64_fuel.png"
PHDayZ.HungerMaterial = "gui/icon_cyb_64_hunger.png"
PHDayZ.ThirstMaterial = "gui/icon_cyb_64_thirst.png"

PHDayZ.HUDLogoLeft = "gui/cybr_L.png"
PHDayZ.HUDLogoRight = "gui/cybr_R.png"

PHDayZ.TipIcons = {}
PHDayZ.TipIcons[1] = Material("cyb_mat/cyb_red.png")
PHDayZ.TipIcons[2] = Material("cyb_mat/cyb_orange.png")
PHDayZ.TipIcons[3] = Material("cyb_mat/cyb_blue.png")
PHDayZ.TipIcons[4] = Material("cyb_mat/cyb_green.png")

PHDayZ.KillsToBeBounty = 10
PHDayZ.KillsToBeBandit = 3

PHDayZ.WebsiteURL = "http://tripstown.net/"
PHDayZ.DonateURL = "http://tripstown.net/donate/"

PHDayZ.DeathTime = 45
PHDayZ.VIPDeathTime = 30

PHDayZ.TagTime = 60
PHDayZ.VIPTagTime = 45

MaxBankWeight = {}
MaxBankWeight[ "guest" ] = 275
MaxBankWeight[ "user" ] = 275
MaxBankWeight[ "member" ]	= 300
MaxBankWeight[ "vip" ] = 425
MaxBankWeight[ "vipadmin" ] = 425
MaxBankWeight[ "admin" ] = 425
MaxBankWeight[ "superadmin" ] = 425
MaxBankWeight[ "founder" ] = 425

PMETA = FindMetaTable("Player")

function PMETA:IsVIP()
return (self:IsUserGroup("vip") or self:IsAdmin() or self:IsSuperAdmin())
end

