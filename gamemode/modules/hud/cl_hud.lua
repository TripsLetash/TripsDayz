PHDayZ = PHDayZ or {}

LocalPlayer().ScoreBoard = false

InSafeZone = false
InSafeZoneEdge = false
visible = 250

local CombatMusic = 1

function UpdateCombatMusic(str, old, new)
	CombatMusic = math.floor(new)
end
cvars.AddChangeCallback(CyBConf.CombatMusic:GetName(), UpdateCombatMusic)

hook.Add("Initialize", "InitCombatMusic", function()
	CombatMusic = CyBConf.CombatMusic:GetInt() or 1
end)

net.Receive( "net_DeathMessage", function( len )
	
	DeathMessage = net.ReadString()
	surface.PlaySound( "music/death.wav" )
	DeathMessage2 = ""
	
	if LocalPlayer():IsVIP() then
		CurDeathTime = (CurTime()+PHDayZ.VIPDeathTime)
	else
		CurDeathTime = (CurTime()+PHDayZ.DeathTime)
	end
	
end)

local LastHungerReceived = LastHungerReceived or 100
local LastThirstReceived = LastThirstReceived or 100
local LastHungerReceivedTime = LastHungerReceivedTime or CurTime()
local LastThirstReceivedTime = LastThirstReceivedTime or CurTime()

net.Receive("Hunger", function(len)
	LastHungerReceived = net.ReadUInt(8)
	LastHungerReceivedTime = CurTime()
end)

net.Receive("Thirst", function(len)
	LastThirstReceived = net.ReadUInt(8)
	LastThirstReceivedTime = CurTime()
end)

local function GetHungerValue()
	return math.Round( LastHungerReceived - ( ( CurTime() - LastHungerReceivedTime ) / 14 ) )
end

local function GetThirstValue()
    return math.Round( LastThirstReceived - ( ( CurTime() - LastThirstReceivedTime ) / 12 ) )
end

net.Receive("net_DeathMessage2", function( len )
	DeathMessage2 = "Press LMB to create a new character"
end)

net.Receive( "net_SafeZone", function( len )
	if util.tobool(net.ReadBit()) then
		InSafeZoneEdge = util.tobool(net.ReadBit())
	else
		InSafeZone = util.tobool(net.ReadBit())
	end
end)

function GM:DrawDeathNotice(x, y)
	return
end

function HideThings( name )
    if (name == "CHudDamageIndicator" ) then
		return false
    end
end
hook.Add( "HUDShouldDraw", "HideThings", HideThings )

function GM:HUDShouldDraw(Name)
	if InSafeZone == true && Name == "CHudWeaponSelection" then
		return false
	end
	return true
end

local grad = Material("gui/gradient")
local tagmat = Material("gui/icon_cyb_64_red.png")
local edgemat = Material("gui/icon_cyb_64_orange.png")
local safemat = Material("gui/icon_cyb_64_blue.png")
local function statuspopup()
	if popup != true then return end

	local SW,SH = ScrW(),ScrH()
	local tw,th = 400,64
	local gw,gh = 64,64
	
	if InSafeZone or InSafeZoneEdge then
		surface.SetDrawColor(0,0,0,102)
		surface.DrawRect( (SW/2 - tw/2), 0, tw, th )
		surface.SetMaterial( grad )
		surface.DrawTexturedRect( (SW/2 + tw/2), 0 , gw, gh)
		surface.DrawTexturedRectRotated( (SW/2 - tw/2 - gw/2), gh/2 , gw, gh, 180)
	
	
		if ( InSafeZoneEdge ) then
			surface.SetDrawColor(255,255,255,255)
			if LocalPlayer():GetNWBool("TagTime") < CurTime() then
				surface.SetMaterial( edgemat )
				text = "Safe-Zone Edge"
			else
				surface.SetMaterial( tagmat )
				text = "You are Vulnerable"
			end
			surface.DrawTexturedRect( (SW/2 + tw/2 ), 0, 64,64)
			surface.DrawTexturedRect( (SW/2 - tw/2 -64), 0, 64,64)
			draw.DrawText(text, "SafeZone_POPUP", SW/2, 8, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	
		else
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial( safemat )
			surface.DrawTexturedRect( (SW/2 + tw/2 ), 0, 64,64)
			surface.DrawTexturedRect( (SW/2 - tw/2 -64), 0, 64,64)
			draw.DrawText("Safe-Zone", "SafeZone_POPUP", SW/2, 8, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	
		end

	end	
	
end

local function safezonebox()

	local SW,SH = ScrW(),ScrH()
	local w,h = 600,150 -- Width and Height of New Safe Zone Warning
	local ew,eh = 100,150 -- Width and Height of the Edges
	local dw,dh = 400,2 -- The Height of the Diamond Inspired Accents
	
	
	surface.SetDrawColor(0,0,0,102) -- Box Color
	surface.DrawRect((SW/2) - (w/2), (SH - h*2), w, h) -- Middle Box
	surface.SetMaterial( grad ) -- Edge Texture
	surface.DrawTexturedRect( (SW/2) + (w/2), (SH - h*2), ew, eh) -- Right Side as the Texture Goes Left to Right
	surface.DrawTexturedRectRotated( (SW/2) - (w/2) - (ew/2) , (SH - h*2) + (eh/2), ew, eh, 180) -- Flip it around and put it on the Left of the middle box.
	surface.SetDrawColor(255,255,255,255) -- Outlines Nigguh
	surface.DrawTexturedRect( (SW/2), (SH - h*2) -2, dw, dh) -- Top Right
	surface.DrawTexturedRectRotated( (SW/2) - (dw/2) , (SH - h*2) -1, dw, dh, 180) -- Top Left
	surface.DrawTexturedRect( (SW/2), (SH - h), dw, dh) -- Bottom Right
	surface.DrawTexturedRectRotated( (SW/2) - (dw/2) , (SH - h) +1, dw, dh, 180) -- Top Left

end

local soundplaying = false
local hex = Material("gui/hexagon.png")
local function showsafezone()

	local szcountdown = math.Round(LocalPlayer():GetNWInt("TagTime") - CurTime())
	if szcountdown <= 0 then
		szcountdown = 0
	end
	
	if CombatMusic == 1 then
		if szcountdown > 0 then
			if !soundplaying then
				soundplaying = true
				surface.PlaySound("music/combat3.wav")
				timer.Simple(szcountdown, function() soundplaying = false end)
			end
		end
	end
	
	if popup != false then return end

	local SW,SH = ScrW(),ScrH()
	local w,h = 600,150 -- Width and Height of New Safe Zone Warning
	local ew,eh = 100,150 -- Width and Height of the Edges
	local dw,dh = 400,2 -- The Height of the Diamond Inspired Accents
			
	if ( InSafeZoneEdge ) and LocalPlayer().ScoreBoard == false and !ShouldDrawMap then
			
		safezonebox() -- Function which draws the background
			
		if LocalPlayer():GetNWInt("TagTime") > CurTime() then
		
			surface.SetDrawColor(255,0,0,255)
			surface.SetMaterial( hex )
			surface.DrawTexturedRect( (SW/2 - dw), (SH - h*2) +12, 128, 128)
			
			draw.DrawText("!", "SafeZone_EXCLAMATION", SW/2 - 353, (SH - h*2) +5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			
			draw.DrawText("YOU ARE TAGGED", "SafeZone_NAME", SW/2, (SH - h*2) -2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			
			draw.DrawText("You WILL take damage from others!", "SafeZone_INFO", SW/2 -270, (SH - h*2) +30, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			draw.DrawText("Access to the Bank SafeZone is denied.", "SafeZone_INFO", SW/2 -270, (SH - h*2) +55, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			draw.DrawText("You will be protected in "..tostring(szcountdown).." seconds!", "SafeZone_INFO", SW/2 -270, (SH - h*2) +80, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

		else
			
			surface.SetDrawColor(232,126,4,255)
			surface.SetMaterial( hex )
			surface.DrawTexturedRect( (SW/2 - dw), (SH - h*2) +12, 128, 128)
			
			draw.DrawText("!", "SafeZone_EXCLAMATION", SW/2 - 353, (SH - h*2) +5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			
			draw.DrawText("SAFE-ZONE EDGE WARNING", "SafeZone_NAME", SW/2, (SH - h*2) -2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			
			draw.DrawText("You won't take damage from others!", "SafeZone_INFO", SW/2 -270, (SH - h*2) +30, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			draw.DrawText("Enter the SafeZone to access the Bank/Shop.", "SafeZone_INFO", SW/2 -270, (SH - h*2) +80, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)											
			
		end

	end
		
	if ( InSafeZone and !InSafeZoneEdge ) and LocalPlayer().ScoreBoard == false and !ShouldDrawMap then
	
		safezonebox()
		
		if LocalPlayer():GetNWInt("TagTime") > CurTime() then
		
			surface.SetDrawColor(255,0,0,255)
			surface.SetMaterial( hex )
			surface.DrawTexturedRect( (SW/2 - dw), (SH - h*2) +12, 128, 128)
			
			draw.DrawText("!", "SafeZone_EXCLAMATION", SW/2 - 353, (SH - h*2) +5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			
			draw.DrawText("YOU ARE TAGGED", "SafeZone_NAME", SW/2, (SH - h*2) -2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			
			draw.DrawText("You WILL take damage from others!", "SafeZone_INFO", SW/2 -270, (SH - h*2) +30, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			draw.DrawText("Access to the Bank SafeZone is denied.", "SafeZone_INFO", SW/2 -270, (SH - h*2) +55, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			draw.DrawText("You will be protected in "..tostring(szcountdown).." seconds!", "SafeZone_INFO", SW/2 -270, (SH - h*2) +80, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

		else	

			surface.SetDrawColor(38,127,180,255)
			surface.SetMaterial( hex )
			surface.DrawTexturedRect( (SW/2 - dw), (SH - h*2) +12, 128, 128)
				
			draw.DrawText("!", "SafeZone_EXCLAMATION", SW/2 - 353, (SH - h*2) +5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			draw.DrawText("SAFE-ZONE WARNING", "SafeZone_NAME", SW/2, (SH - h*2) -2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("You will not take damage from others.", "SafeZone_INFO", SW/2 -270, (SH - h*2) +30, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			draw.DrawText("Access to XP, Money and Credits currently available.", "SafeZone_INFO", SW/2 -270, (SH - h*2) +55, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		
		end

	end
		
	if InSafeZone or InSafeZoneEdge then
		local mcount = 0
		local ccount = 0
		if Local_Inventory[ 1 ] != nil and Local_Inventory[ 1 ] > 0 then
			mcount = Local_Inventory[ 1 ]
		end
		if Local_Inventory[ 2 ] != nil and Local_Inventory[ 2 ] > 0 then
			ccount = Local_Inventory[ 2 ]
		end
		draw.RoundedBox(4,SW/2-150,0,300,40,Color( 0,0, 0, 155 ))				
		draw.DrawText("$"..mcount, "TargetIDMedium", SW/2-100, 8, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)			
		draw.DrawText("XP:"..LocalPlayer():GetNWInt("xp"), "TargetIDMedium", SW/2+100, 8, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)				
		draw.DrawText("Credits:"..ccount, "TargetIDMedium", SW/2, 8, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)	
	end
	
end

local function swapper()

	if ( InSafeZoneEdge ) then
		popup = false
		showsafezone()
		timer.Create( "Edge", 5, 1, function() popup = true  end)
		statuspopup()

	end
	
	if ( InSafeZone ) then
		popup = false
		showsafezone()
		timer.Create( "Safe", 5, 1, function() popup = true end)
		statuspopup()
 
	end

end

local function drawxp()
	local plyxp = LocalPlayer():GetNWInt("xp")
	local SW,SH = ScrW(),ScrH()
	
	XPBarLength = plyxp/1000
	
	LocalPlayer().CL_Level = LocalPlayer():GetNWInt("lvl") or 1
	-- XP Bar Start
	draw.RoundedBox(4,13,SH-92,384,15,Color( 255, 255, 255, 255 )) -- Black Background
	draw.RoundedBox(4,14,SH-91,382,13,Color( 50, 50, 50, 255 )) -- Grey

	draw.DrawText("Level "..LocalPlayer().CL_Level, "Cyb_HudTEXT", 13, SH-118, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT) -- LEVEL		
	
	if XPBarLength != 0 then 
		draw.RoundedBox(2,14,SH-87,384*XPBarLength,9,Color( 38, 127, 180, 255 )) -- Dark Blue
		draw.RoundedBox(2,14,SH-91,384*XPBarLength,6,Color( 92, 183, 237, 255 )) -- Light Blue		
	end
	
	draw.RoundedBox(0,404/4,SH-92,1,15,Color( 255, 255, 255, 255 ))	-- Black Bar 1
	draw.RoundedBox(0,404/4*2,SH-92,1,15,Color( 255, 255, 255, 255 ))	-- Black Bar 2
	draw.RoundedBox(0,404/4*3,SH-92,1,15,Color( 255, 255, 255, 255 ))	-- Black Bar 3

end

local function HUDPaint( )

	local SW,SH = ScrW(),ScrH()
	
--	showsafezone()
	swapper()

		
	if LocalPlayer():Alive() then
		if LocalPlayer().ConnectScreen == true then return end
		drawleftbg()
		drawxp()
		DrawHealth()
		DrawHunger()		
		DrawThirst()
		DrawStamina()		
		makelogo()
		drawvehiclehud()
		
		WSWITCH:Draw(LocalPlayer())
	end
		
	if LocalPlayer():Health() <= 0 and DeathMessage then
	
		local deathcountdown = math.Round(CurDeathTime - CurTime())
		if deathcountdown <= 0 then
			deathcountdown = 0
		end
		
		local DeadBoxW = 600
		local DeadBoxH = 150
		
		draw.RoundedBox(0,SW/2-(DeadBoxW/2),SH/2-(DeadBoxH/2),DeadBoxW,DeadBoxH,Color( 0,0, 0, 200 ))
		

		draw.RoundedBox(0,SW/2-(DeadBoxW/2),SH/2-(DeadBoxH/2),DeadBoxW,2,Color( 255,255, 255, 255 ))	
		draw.RoundedBox(0,SW/2-(DeadBoxW/2),SH/2+(DeadBoxH/2),DeadBoxW,2,Color( 255,255, 255, 255 ))
		draw.RoundedBox(0,SW/2-(DeadBoxW/2),SH/2-(DeadBoxH/2),2,DeadBoxH,Color( 255,255, 255, 255 ))	
		draw.RoundedBox(0,SW/2+(DeadBoxW/2),SH/2-(DeadBoxH/2),2,DeadBoxH,Color( 255,255, 255, 255 ))		
		
		draw.DrawText("You are Dead.", "TargetIDLarge", SW/2, SH/2-50, Color(255, 0, 0, 255),TEXT_ALIGN_CENTER)										
		draw.DrawText(DeathMessage, "TargetIDMedium", SW/2, SH/2, Color(150, 150, 150, 255),TEXT_ALIGN_CENTER)	
		if DeathMessage2 != "" then
			draw.DrawText(DeathMessage2, "TargetIDMedium", SW/2, SH/2+30, Color(150, 150, 150, 255),TEXT_ALIGN_CENTER)	
			return
		end

		draw.DrawText("Wait "..deathcountdown.." seconds!", "TargetIDMedium", SW/2, SH/2+30, Color(150, 150, 150, 255),TEXT_ALIGN_CENTER)	
		
	end
			
	local intAmmoInMag = 0 
	local intAmmoOutMag = 0
	if LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():IsWeapon() then
		intAmmoInMag = LocalPlayer():GetActiveWeapon():Clip1()
		intAmmoOutMag = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
	end
		
		-- Ammo
		
	if !WSWITCH.Show and LocalPlayer():GetActiveWeapon():IsValid() && LocalPlayer():GetActiveWeapon():Clip1() >= 0 && LocalPlayer():GetActiveWeapon():GetClass() != "weapon_physcannon" then
		--draw.RoundedBox(10,SW - 201,SH -81,151,72,Color( 50, 50, 50, 255 ))
		
		draw.RoundedBox(6,SW - 200,SH -70,250,100,Color( 0, 0, 0, 200 )) -- Small Ammo Box

		
		surface.SetDrawColor(255,255,255,255)
		
		surface.SetTextColor(Color(255,255,255))
		surface.SetFont("AmmoType1")
		local x,y = surface.GetTextSize( intAmmoInMag)
		surface.SetTextPos(SW-140-x/2,SH-35-y/2)
		surface.DrawText( intAmmoInMag)
		
		surface.SetTextColor(Color(150,0,0))
		surface.SetFont("AmmoType2")
		local x,y = surface.GetTextSize( intAmmoOutMag)
		surface.SetTextPos(SW-90-x/2,SH-25-y/2)
		surface.DrawText( "x "..intAmmoOutMag)
	end	
		
	traceRes=LocalPlayer():GetEyeTrace()
		
	if traceRes.Entity:IsPlayer() then
		if traceRes.Entity:GetMoveType() != MOVETYPE_NOCLIP and traceRes.Entity:Alive() then 
			local TrgPos = traceRes.Entity:GetPos()+Vector(0,0,64)
			local ScrPos = (TrgPos + Vector( 0, 0, 10 )):ToScreen()	
			local Distance = TrgPos:Distance( LocalPlayer():GetPos() )	
		
			if Distance < 500 then
				local alp =  255 * (math.abs((Distance-500))/600)
				draw.RoundedBox( 4, ScrPos.x-75, ScrPos.y-30, 150, 60, Color( 0, 0, 0, alp ) )
				draw.DrawText(traceRes.Entity:Nick(), "TargetIDWeighted", ScrPos.x, ScrPos.y-15, Color(255, 255, 255, alp),TEXT_ALIGN_CENTER)				
				if traceRes.Entity:GetNWInt("kills") >= PHDayZ.KillsToBeBounty-1 then
					draw.DrawText("[BOUNTY]", "TargetIDSmall", ScrPos.x, ScrPos.y+5, Color(255, 0, 0, alp),TEXT_ALIGN_CENTER)	
				elseif traceRes.Entity:GetNWInt("kills") > PHDayZ.KillsToBeBandit then
					draw.DrawText("[BANDIT]", "TargetIDSmall", ScrPos.x, ScrPos.y+5, Color(200, 0, 0, alp),TEXT_ALIGN_CENTER)	
				elseif traceRes.Entity:GetNWBool("friendly") == true and traceRes.Entity:GetNWInt("kills") < PHDayZ.KillsToBeBandit then
					draw.DrawText("[HERO]", "TargetIDSmall", ScrPos.x, ScrPos.y+5, Color(0, 255, 0, alp),TEXT_ALIGN_CENTER)					
				else
					draw.DrawText("[NEUTRAL]", "TargetIDSmall", ScrPos.x, ScrPos.y+5, Color(255, 255, 255, alp),TEXT_ALIGN_CENTER)	
				end
			end
		end
	end
	
end
hook.Add( "HUDPaint", "PaintOurHud", HUDPaint );

function hidehud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo",  })do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "HideOurHud:D", hidehud)

function GM:HUDDrawTargetID()
	local tr = util.GetPlayerTrace(LocalPlayer(),LocalPlayer():GetAimVector())
	local trace = util.TraceLine(tr)
	local OurPos = LocalPlayer():GetPos() + Vector(0, 0, 64);
	if SpecEnt then OurPos = SpecEnt:GetPos() + Vector(0,0,64) end
	
	if trace.HitPos and LocalPlayer():Alive() then
		for _, ent in pairs(ents.FindInSphere(trace.HitPos,15)) do
			if ent:GetClass() == "base_item" and ent.DisplayItemName == true and LocalPlayer():EntVisible(ent) == true then
				if ent:GetPos():Distance(LocalPlayer():GetPos()) < 125 and ent:IsValid() then	
					local entPos = ent:LocalToWorld(trace.Entity:OBBCenter()):ToScreen();
					draw.RoundedBox( 40, entPos.x-40, entPos.y-40, 80, 80, Color( 0, 0, 0, 150 ) )
					draw.RoundedBox( 30, entPos.x-30, entPos.y-30, 60, 60, Color( 150, 0, 0, 255 ) )
				
					draw.RoundedBox( 4, entPos.x+40, entPos.y-40, 180, 25, Color( 0, 0, 0, 200 ) )
					draw.RoundedBox( 4, entPos.x+40, entPos.y-10, 180, 40, Color( 50, 50, 50, 200 ) )
					
					if ent:IsValid() then
						local Class = ent:GetNWInt( "Class" )
						if Class then
							local ItemTable = GAMEMODE.DayZ_Items[ Class ]
							
							if ItemTable != nil then
								if ItemTable.Name then
									draw.DrawText(ItemTable.Name, "TargetIDMedium", entPos.x+40, entPos.y-40, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
									draw.DrawText("Press [E] to pickup", "TargetIDMedium", entPos.x+40, entPos.y-10, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)										
								end
							end
						end
					end
					
					local struc = {}
					struc.pos = {}
					struc.pos[1] = entPos.x -- x pos
					struc.pos[2] = entPos.y -- y pos
					struc.color = Color(255,255,255,255) -- Red
					struc.text = "E" -- Text
					struc.font = "TargetIDLarge" -- Font
					struc.xalign = TEXT_ALIGN_CENTER -- Horizontal Alignment
					struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
					draw.Text( struc )
					break
				end
			elseif ent:GetClass() == "money" then
				if ent:GetPos():Distance(LocalPlayer():GetPos()) < 125 then	
					local entPos = ent:LocalToWorld(trace.Entity:OBBCenter()):ToScreen();
					draw.RoundedBox( 40, entPos.x-40, entPos.y-40, 80, 80, Color( 0, 0, 0, 150 ) )
					draw.RoundedBox( 30, entPos.x-30, entPos.y-30, 60, 60, Color( 150, 0, 0, 255 ) )
				
					draw.RoundedBox( 4, entPos.x+40, entPos.y-40, 180, 25, Color( 0, 0, 0, 200 ) )
					draw.RoundedBox( 4, entPos.x+40, entPos.y-10, 180, 40, Color( 50, 50, 50, 200 ) )
					draw.DrawText("Money", "TargetIDMedium", entPos.x+40, entPos.y-40, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
					draw.DrawText("Press [E] to pickup", "TargetIDMedium", entPos.x+40, entPos.y-10, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)										
				
					local struc = {}
					struc.pos = {}
					struc.pos[1] = entPos.x -- x pos
					struc.pos[2] = entPos.y -- y pos
					struc.color = Color(255,255,255,255) -- Red
					struc.text = "E" -- Text
					struc.font = "TargetIDLarge" -- Font
					struc.xalign = TEXT_ALIGN_CENTER -- Horizontal Alignment
					struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
					draw.Text( struc )
					break
				end
			elseif ent:GetClass() == "backpack" and ent:GetPos():Distance(LocalPlayer():GetPos()) < 125 then
				local entPos = ent:LocalToWorld(trace.Entity:OBBCenter()):ToScreen();
				draw.RoundedBox( 40, entPos.x-40, entPos.y-40, 80, 80, Color( 0, 0, 0, 150 ) )
				draw.RoundedBox( 30, entPos.x-30, entPos.y-30, 60, 60, Color( 0, 150, 0, 255 ) )
			
				draw.RoundedBox( 4, entPos.x+40, entPos.y-40, 180, 25, Color( 0, 0, 0, 200 ) )
				draw.RoundedBox( 4, entPos.x+40, entPos.y-10, 180, 40, Color( 50, 50, 50, 200 ) )
				draw.DrawText(ent:GetNWString("OwnerNick").."'s Backpack", "TargetIDMedium", entPos.x+40, entPos.y-40, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText("Press [E] to loot", "TargetIDMedium", entPos.x+40, entPos.y-10, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)										
			
				local struc = {}
				struc.pos = {}
				struc.pos[1] = entPos.x -- x pos
				struc.pos[2] = entPos.y -- y pos
				struc.color = Color(255,255,255,255) -- Red
				struc.text = "E" -- Text
				struc.font = "TargetIDLarge" -- Font
				struc.xalign = TEXT_ALIGN_CENTER -- Horizontal Alignment
				struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
				draw.Text( struc )
				break				
			end				
		end
	end

end

local DMGIndicatorAlpha = 0
function ReceieveHurtInfo()
	local TimeH = 0.5
	LocalPlayer().DmgIndicatorTime = CurTime() + TimeH
	DMGIndicatorAlpha = 100
end

net.Receive("HurtInfo", function(len)
	ReceieveHurtInfo()
end)

hook.Add("HUDPaint", "DrawDamageIndicator", function()
	if DMGIndicatorAlpha <= 0 then return end
	
	if LocalPlayer().DmgIndicatorTime and LocalPlayer().DmgIndicatorTime < CurTime() then
		DMGIndicatorAlpha = DMGIndicatorAlpha - FrameTime() * 600
	end	
	
	if DMGIndicatorAlpha > 0 then
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 255, 0, 0, DMGIndicatorAlpha ) )	
	end
end)

local HitIndicatorAlpha = 0
	
local function SendHitInfo()
	local Time = 0.5
	LocalPlayer().HitIndicatorTime = CurTime() + Time
	HitIndicatorAlpha = 255
end
net.Receive("SendHitInfo", function(len)
	SendHitInfo()
end)
	
hook.Add("HUDPaint", "DrawHitIndicator", function()
	if HitIndicatorAlpha <= 0 then return end
	if LocalPlayer().HitIndicatorTime and LocalPlayer().HitIndicatorTime < CurTime() then
		HitIndicatorAlpha = HitIndicatorAlpha - FrameTime() * 600
	end
		
	if HitIndicatorAlpha > 0 then
			
		local x = ScrW() / 2
		local y = ScrH() / 2
			 
		local Lenght = 21 * (HitIndicatorAlpha / 255)
		Lenght = math.Clamp(Lenght, 8, Lenght)
		local Size = 7
			
		surface.SetDrawColor( 0, 0, 0, HitIndicatorAlpha )
			
		surface.DrawLine( x + Size, y - Size, x + Lenght, y - Lenght )
		surface.DrawLine( x - Size, y + Size, x -Lenght, y + Lenght )
			
		surface.DrawLine( x + Size, y + Size, x + Lenght, y + Lenght )
		surface.DrawLine( x - Size, y - Size, x - Lenght, y - Lenght )
			
		surface.SetDrawColor( 225, 225, 225, HitIndicatorAlpha )
		Lenght = 20 * (HitIndicatorAlpha / 255)
		Lenght = math.Clamp(Lenght, 8, Lenght)
		Size = 8
			
		surface.DrawLine( x + Size, y - Size, x + Lenght, y - Lenght )
		surface.DrawLine( x - Size, y + Size, x - Lenght, y + Lenght )
			
		surface.DrawLine( x + Size, y + Size, x + Lenght, y + Lenght )
		surface.DrawLine( x - Size, y - Size, x - Lenght, y - Lenght )
			
	end
	
end)

function drawleftbg()
	local grad = Material("gui/gradient")
	
	surface.SetDrawColor(0,0,0,102)
	surface.SetMaterial( grad )
	surface.DrawRect(74, ScrH() -96, 300, 84)
	surface.DrawRect(74, ScrH() -96, 300, 84)
	surface.SetDrawColor(0,0,0,168)
	surface.DrawTexturedRect( 374, ScrH() -96, 64, 84) -- Bar black gradient right
	surface.DrawTexturedRectRotated( 42, ScrH() -54, 64, 84, 180) -- bar black gradient left
	
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(214, ScrH() -98, 212, 2) -- Bar top white gradient right
	surface.DrawTexturedRectRotated(108, ScrH() -97, 212, 2, 180) -- Bar top white gradient left
	surface.DrawTexturedRect(214, ScrH() -12, 212, 2) -- Bar bottom white gradient right
	surface.DrawTexturedRectRotated(108, ScrH() -11, 212, 2, 180) -- Bar bottom white gradient left

end

function makelogo()
	
	local logo_l = Material(PHDayZ.HUDLogoLeft)
	local logo_r = Material(PHDayZ.HUDLogoRight)
	
	surface.SetDrawColor(255,255,255,255)
	surface.SetMaterial( logo_l )
	surface.DrawTexturedRect( 12, ScrH() -76, 64, 64)
	surface.SetMaterial( logo_r )
	surface.DrawTexturedRect( 76, ScrH() -76, 64, 64)

end

function NoirMode()
	local ply = LocalPlayer()	
		local tab = {}
		tab["$pp_colour_addr"] = 0
		tab["$pp_colour_addg" ] = 0
		tab["$pp_colour_addb" ] = 0
		tab["$pp_colour_brightness" ] = 0
		tab["$pp_colour_contrast" ] = 1
		tab["$pp_colour_colour" ] = (LocalPlayer():Health() / 100) or 0
		tab["$pp_colour_mulr" ] = 0.05
		tab["$pp_colour_mulg" ] = 0.05
		tab["$pp_colour_mulb" ] = 0.05
		DrawColorModify( tab )	
end
hook.Add("RenderScreenspaceEffects", "NoirFunc", NoirMode)

function DrawHealth()	
	local maxlen = ( LocalPlayer():Health() / 100 ) * 250
	
	draw.RoundedBoxEx(4, 145, ScrH() -73, 252, 27, Color(255,255,255,255), true, true, true, true)
	draw.RoundedBoxEx(4, 146, ScrH() -72, 250, 25, Color(50,50,50,255), true, true, true, true)
	
	if LocalPlayer():Health() >15 then
		draw.RoundedBoxEx(4, 146, ScrH() -72, maxlen, 25, Color(4,137,216,255), true, true, true, true)
		draw.RoundedBoxEx(4, 146, ScrH() -72, maxlen, 12, Color(87,192,255,255), true, true, false, false)
	else
		draw.RoundedBoxEx(4, 146, ScrH() -72, maxlen, 25, Color(4,137,216,255), true, false, true, false)
		draw.RoundedBoxEx(4, 146, ScrH() -72, maxlen, 12, Color(87,192,255,255), true, false, false, false)

	end
	
	draw.DrawText("Health", "Cyb_HudTEXT", 150, ScrH() -72, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
	draw.DrawText(LocalPlayer():Health(), "Cyb_HudTEXT", 390, ScrH() -72, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)

	surface.SetMaterial(Material("filmgrain/filmgrain"))
	surface.SetDrawColor(0, 0, 0, (120 - LocalPlayer():Health()) )
	surface.DrawTexturedRectUV(0, 0, ScrW(), ScrH(), 2, 2, 0, 0)
end

function DrawStamina()
	local maxlen = ( LocalPlayer():GetNWInt("Stamina")/100) * 250
	draw.RoundedBoxEx(4, 145, ScrH() -42, 252, 27, Color(255,255,255,255), true, true, true, true)
	draw.RoundedBoxEx(4, 146, ScrH() -41, 250, 25, Color(50,50,50,255), true, true, true, true)
	
	if LocalPlayer():GetNWInt("Stamina") > 5 then
		draw.RoundedBoxEx(4, 146, ScrH() -41, maxlen, 25, Color(1,51,81,255), true, true, true, true)
		draw.RoundedBoxEx(4, 146, ScrH() -41, maxlen, 12, Color(9,117,181,255), true, true, false, false)
	end
	
	draw.DrawText("Stamina", "Cyb_HudTEXT", 150, ScrH() -41, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
	draw.DrawText(LocalPlayer():GetNWInt("Stamina"), "Cyb_HudTEXT", 390, ScrH() -41, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)

end

function drawvehiclehud()
	local fuelmat = Material(PHDayZ.VehFuelMaterial)
	local healthmat = Material(PHDayZ.VehHealthMaterial)		
	local fuel = 0
	local health = 0

	if !(LocalPlayer():InVehicle() and InSafeZone == false) then return end
	
	if LocalPlayer():GetVehicle():GetParent():IsValid() then
		fuel = math.Round(LocalPlayer():GetVehicle():GetParent():GetNWInt("fuel"))
		health = math.Round(LocalPlayer():GetVehicle():GetParent():Health())
	else
		fuel = math.Round(LocalPlayer():GetVehicle():GetNWInt("fuel"))
		health = math.Round(LocalPlayer():GetVehicle():Health())
	end

	if health < 90 then 
	
		surface.SetDrawColor(255,255,255,255)

		if health <= 90 then
			surface.SetDrawColor(201,237,92,255)
		end

		if health <= 80 then
			surface.SetDrawColor(235,237,92,255)
		end

		if health <= 70 then
			surface.SetDrawColor(237,205,92,255)
		end

		if health <= 60 then
			surface.SetDrawColor(237,164,92,255)
		end

		if health <= 50 then
			surface.SetDrawColor(235,90,51,255)
		end

		if health <= 40 then
			surface.SetDrawColor(255,86,40,255)
		end

		if health <= 30 then
			surface.SetDrawColor(255,70,40,255)
		end

		if health <= 20 then
			surface.SetDrawColor(255,40,40,255)
		end

		if health <= 10 then
			surface.SetDrawColor(255,0,0,255)
		end

		surface.SetMaterial( healthmat )
		surface.DrawTexturedRect(265, ScrH() -162, 64,64)	
	
	end
	
	if fuel > 50 then return end
	
	surface.SetDrawColor(255,255,255,255)

	if fuel <= 45 then
		surface.SetDrawColor(201,237,92,255)
	end

	if fuel <= 40 then
		surface.SetDrawColor(235,237,92,255)
	end

	if fuel <= 35 then
		surface.SetDrawColor(237,205,92,255)
	end

	if fuel <= 30 then
		surface.SetDrawColor(237,164,92,255)
	end

	if fuel <= 25 then
		surface.SetDrawColor(235,90,51,255)
	end

	if fuel <= 20 then
		surface.SetDrawColor(255,86,40,255)
	end

	if fuel <= 15 then
		surface.SetDrawColor(255,70,40,255)
	end

	if fuel <= 10 then
		surface.SetDrawColor(255,40,40,255)
	end

	if fuel <= 5 then
		surface.SetDrawColor(255,0,0,255)
	end

	surface.SetMaterial( fuelmat )
	surface.DrawTexturedRect(330, ScrH()-162, 64, 64)	

end

function DrawHunger()
	local hungermat = Material(PHDayZ.HungerMaterial)
	
	if GetHungerValue() == nil then return end
	
	if GetHungerValue() > 50 then return end
	
	surface.SetDrawColor(255,255,255,255)
	
	if GetHungerValue() <= 45 then
		surface.SetDrawColor(201,237,92,255)
	end

	if GetHungerValue() <= 40 then
		surface.SetDrawColor(235,237,92,255)
	end

	if GetHungerValue() <= 35 then
		surface.SetDrawColor(237,205,92,255)
	end

	if GetHungerValue() <= 30 then
		surface.SetDrawColor(237,164,92,255)
	end

	if GetHungerValue() <= 25 then
		surface.SetDrawColor(235,90,51,255)
	end

	if GetHungerValue() <= 20 then
		surface.SetDrawColor(255,86,40,255)
	end

	if GetHungerValue() <= 15 then
		surface.SetDrawColor(255,70,40,255)
	end

	if GetHungerValue() <= 10 then
		surface.SetDrawColor(255,40,40,255)
	end

	if GetHungerValue() <= 5 then
		surface.SetDrawColor(255,0,0,255)
	end
	
	surface.SetMaterial( hungermat )
	surface.DrawTexturedRect(145, ScrH()-164, 64, 64)

end

function DrawThirst() 
	local thirstmat = Material(PHDayZ.ThirstMaterial)
	if GetThirstValue() == nil then return end
	
	if GetThirstValue() > 50 then return end
		
	surface.SetDrawColor(255,255,255,255)
		
	if GetThirstValue() <= 45 then
		surface.SetDrawColor(201,237,92,255)
	end

	if GetThirstValue() <= 40 then
		surface.SetDrawColor(235,237,92,255)
	end

	if GetThirstValue() <= 35 then
		surface.SetDrawColor(237,205,92,255)
	end

	if GetThirstValue() <= 30 then
		surface.SetDrawColor(237,164,92,255)
	end

	if GetThirstValue() <= 25 then
		surface.SetDrawColor(235,90,51,255)
	end

	if GetThirstValue() <= 20 then
		surface.SetDrawColor(255,86,40,255)
	end

	if GetThirstValue() <= 15 then
		surface.SetDrawColor(255,70,40,255)
	end

	if GetThirstValue() <= 10 then
		surface.SetDrawColor(255,40,40,255)
	end

	if GetThirstValue() <= 5 then
		surface.SetDrawColor(255,0,0,255)
	end
			
	surface.SetMaterial( thirstmat )
	surface.DrawTexturedRect(200, ScrH() -162, 64,64)
end