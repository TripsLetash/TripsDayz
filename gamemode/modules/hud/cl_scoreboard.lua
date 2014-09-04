
function GM:HUDDrawScoreboard()
		local grad = Material("gui/gradient")
		local tagmat = Material("gui/icon_cyb_64_red.png")
		local edgemat = Material("gui/icon_cyb_64_orange.png")
		local safemat = Material("gui/icon_cyb_64_blue.png")
		local tw,th = 1088,52
		local gw,gh = 52,52


	if LocalPlayer():IsAdmin() then
		GUI_AdminSB_Button = vgui.Create( "DButton")
		--GUI_AdminSB_Button:SetParent(GUI_Model_Frame)	
		GUI_AdminSB_Button:SetSize( 170, 25 )
		GUI_AdminSB_Button:SetPos( ScrW()/2-GUI_AdminSB_Button:GetWide()/2, 75 )
		GUI_AdminSB_Button:SetText( "Admin Options" )
		GUI_AdminSB_Button:SetTextColor( Color(255,255,255,255) )
		GUI_AdminSB_Button.Paint = function()
			--surface.SetDrawColor(0,0,0,202)
			--surface.DrawRect( (GUI_ScoreBoard_Frame:GetWide()/2 - ScrW()-200/2), 0, ScrW()-200, 60 ) -- middle part
			--draw.RoundedBox(2,0,0,GUI_AdminSB_Button:GetWide(),GUI_AdminSB_Button:GetTall(),Color( 0, 0, 0, 255 ))	
			--draw.RoundedBox(2,1,1,GUI_AdminSB_Button:GetWide()-2,GUI_AdminSB_Button:GetTall()-2,Color( 139, 133, 97, 55 ))
			
			surface.SetDrawColor(0,0,0,202)
			
			surface.DrawRect( (GUI_AdminSB_Button:GetWide()/2 - 39), 0, GUI_AdminSB_Button:GetWide()/2-10, 30 ) -- middle part
			surface.SetMaterial( grad )
						
			surface.DrawTexturedRect( GUI_AdminSB_Button:GetWide()-49, 0 , gw, gh) -- right side
			surface.DrawTexturedRectRotated( 20, gh/2 , gw, gh, 180) -- LEFT SIDE
			
		end
		GUI_AdminSB_Button.DoClick = function() AdminMenu()	end	
	end
	
	GUI_ScoreBoard_Frame = vgui.Create( "DPanel" )
	GUI_ScoreBoard_Frame:SetTall( 740 )
	GUI_ScoreBoard_Frame:SetWide( 1180 )
	GUI_ScoreBoard_Frame:SetVisible( true )
	GUI_ScoreBoard_Frame:SetPos(ScrW()/2-GUI_ScoreBoard_Frame:GetWide()/2, 100)
	GUI_ScoreBoard_Frame.Paint = function()

						
		surface.SetDrawColor(0,0,0,202)
		surface.DrawRect( (GUI_ScoreBoard_Frame:GetWide()/2 - tw/2), 0, tw, th ) -- middle part
		surface.SetMaterial( grad )
						
		surface.DrawTexturedRect( GUI_ScoreBoard_Frame:GetWide()-46, 0 , gw, gh) -- right side
		surface.DrawTexturedRectRotated( (20), gh/2 , gw, gh, 180) -- LEFT SIDE
						
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial( safemat )
		surface.DrawTexturedRect( 346, 0, 64, 64)
							
		draw.DrawText("erGmod DayZ - Version "..PHDayZ.Version, "SafeZone_NAME", GUI_ScoreBoard_Frame:GetWide()/2, 10, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		draw.DrawText("A Gamemode by the CyberGmod Team", "Cyb_HudTEXTSmall", 52, 0, Color(255, 255, 255, 150),TEXT_ALIGN_LEFT)	
							--draw.DrawText("Visit us at http://www.centrifugegaming.com", "SubScoreboardHeader", 400, 60, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)								
		draw.DrawText("Since Fudsine sold stolen code from OCRP, Credits go to Jake, Noobulator & Crap-Head", "Cyb_HudTEXTSmall", GUI_ScoreBoard_Frame:GetWide()-52, 0, Color(255, 255, 255, 150),TEXT_ALIGN_RIGHT)
							--draw.DrawText("Visit us at http://www.centrifugegaming.org", "ScoreboardContent", 5, 0, Color(200, 200, 200, 150),TEXT_ALIGN_LEFT)							
	end
		
	local SList = vgui.Create( "DPanelList", GUI_ScoreBoard_Frame )
	SList:SetPos( 3, 66 )					
	SList:SetTall( 640 )
	SList:SetWide( 1180 )
	SList.Paint = function() return false end
	SList:SetSpacing( 1 )
	SList:EnableHorizontal( true )
	SList:EnableVerticalScrollbar( true )
	
	
	for k, v in pairs( player.GetAll() ) do
		if !IsValid(v) then continue end
		
		local teamclr = team.GetColor( v:Team() )
		local PList = vgui.Create( "DPanelList" )
		PList:SetPos( 0, 0 )
		PList:SetWide( 1172/3 )
		PList:SetTall( 35 )
		PList.Paint = function()
							
							surface.SetDrawColor(0,0,0,202)
							surface.DrawRect( (PList:GetWide() - tw/2), 0, tw, th ) -- middle part
		
							--draw.RoundedBox(2,0,0,390,35,Color(0, 0, 0, 150))				
							--draw.RoundedBox(0,0,0,390,1,Color(0, 0, 0, 255))
							--draw.RoundedBox(0,0,34,390,1,Color(0, 0, 0, 255))
							--draw.RoundedBox(0,0,0,1,35,Color(0, 0, 0, 255))
							--draw.RoundedBox(0,389,0,1,35,Color(0, 0, 0, 255))
							
							if v:IsValid() then
							
								if v:IsSuperAdmin() then
									draw.RoundedBox(4,1,1,34,34,Color(0, 255, 0, 150))
								elseif v:IsVIP() then
									draw.RoundedBox(4,1,1,34,34,Color(0, 0, 255, 150))							
								else
									draw.RoundedBox(4,1,1,34,34,Color(0, 0, 0, 0))							
								end
								
								if v:Ping() < 100 then
									draw.RoundedBox(0,370,28,4,4,Color(0, 255, 0, 255))
									draw.RoundedBox(0,375,24,4,8,Color(0, 255, 0, 255))
									draw.RoundedBox(0,380,20,4,12,Color(0, 255, 0, 255))
								elseif v:Ping() < 225 then
									draw.RoundedBox(0,370,28,4,4,Color(255, 255, 0, 255))
									draw.RoundedBox(0,375,24,4,8,Color(255, 255, 0, 255))
									draw.RoundedBox(0,380,20,4,12,Color(155, 155, 155, 255))
								else 
									draw.RoundedBox(0,370,28,4,4,Color(255, 0, 0, 255))
									draw.RoundedBox(0,375,24,4,8,Color(155, 155, 155, 255))
									draw.RoundedBox(0,380,20,4,12,Color(155, 155, 155, 255))
								end
							
							end
							

							
						end
		PList:EnableHorizontal( true )
		PList:SetSpacing( 2 )
		
		local Avatar = vgui.Create( "AvatarImage", PList )
		Avatar:SetPos( 2, 2 )
		Avatar:SetSize( 32, 32 )
		Avatar:SetPlayer( v )
		
		local Name = vgui.Create( "DLabel", PList )
		Name:SetPos( 40, 7 )
		Name:SetText( " " )
		Name.Paint = function()
			if v:IsValid() then
				if v:SteamID() == "STEAM_0:1:21073736" then
					surface.SetTextColor( Color(255, 127, 0, 255) )		
				elseif v:SteamID() == "STEAM_0:1:40306371" then
					surface.SetTextColor( Color(0, 255, 0, 255) )		
				elseif v:IsUserGroup("owner") then
					surface.SetTextColor( Color(255, 0, 0, 255) )		
				elseif v:IsUserGroup("superadmin") then
					surface.SetTextColor( Color(0, 255, 0, 255) )		
				elseif v:IsUserGroup("admin") then	
					surface.SetTextColor( Color(0, 200, 255, 255) )
				elseif v:IsUserGroup("vipadmin") then	
					surface.SetTextColor( Color(0, 200, 255, 255) )
				elseif v:IsUserGroup("vip") then	
					surface.SetTextColor( Color(0, 0, 255, 255) )
				else
					surface.SetTextColor( Color(255, 255, 255, 255) )			
				end							
			else
				return
			end
			surface.SetTextPos( 0, -2 )
			surface.SetFont( "Cyb_HudTEXT" )
			if string.len( v:Nick() ) > 20 then
				TheName = string.sub(v:Nick(), 1, 17).."..."
				surface.DrawText(TheName)
			else
				surface.DrawText(v:Nick())
			end
			--surface.DrawText( v:Nick() )
		end

		Name:SetSize( 200, 40 )
		
		local Rank = vgui.Create( "DLabel", PList )
		Rank:SetFont( "ScoreboardContent" )
		if v:IsUserGroup("owner") then
			Rank:SetText("Founder")
			Rank:SetColor( Color(255, 0, 0, 255) )		
		elseif v:IsUserGroup("superadmin") then
			Rank:SetText("Super Admin")
			Rank:SetColor( Color(0, 255, 0, 255) )		
		elseif v:IsUserGroup("admin") then	
			Rank:SetText("Admin")
			Rank:SetColor( Color(0, 200, 255, 255) )
		elseif v:IsUserGroup("vipadmin") then	
			Rank:SetText("VIPAdmin")
			Rank:SetColor( Color(0, 200, 255, 255) )
		elseif v:IsUserGroup("vip") then	
			Rank:SetText("VIP")
			Rank:SetColor( Color(0, 0, 255, 255) )
		elseif v:IsUserGroup("member") then
			Rank:SetText("Member")	
			Rank:SetColor( Color(255, 255, 255, 255) )			
		else
			Rank:SetText("Guest")	
			Rank:SetColor( Color(255, 255, 255, 255) )			
		end
		Rank:SizeToContents()		
		Rank:SetPos( PList:GetWide()-(Rank:GetWide()+5), 2 )

		local Ping = vgui.Create( "DLabel", PList )
		--Ping:SetFont( "ScoreboardContent" )
		Ping:SetColor( Color(255, 255, 255, 255) )
		Ping:SetText("")
		Ping.Paint = function() 
			if v:IsValid() then
				draw.DrawText(v:Ping().."ms", "Cyb_HudTEXTSmall", 28, 3, Color(255, 255, 255, 150),TEXT_ALIGN_RIGHT)	
			end
		end
		Ping:SetSize(50,50)
		Ping:SetPos( PList:GetWide()-50, 18 )

		local Status = vgui.Create( "DLabel", PList )
		Status:SetPos( 200, 10 )
		Status:SetFont( "ScoreboardContent" )

		if v:Frags() >= PHDayZ.KillsToBeBounty then
			Status:SetText("[BOUNTY]")	
			Status:SetColor( Color(255, 0, 0, 255) )
		elseif v:Frags() > PHDayZ.KillsToBeBandit then
			Status:SetText("[BANDIT]")	
			Status:SetColor( Color(200, 0, 0, 255) )
		elseif v:GetNWBool("friendly") and v:Frags() < PHDayZ.KillsToBeBandit then
			Status:SetText("[HERO]")	
			Status:SetColor( Color(0, 200, 0, 255) )		
		else
			Status:SetText("[NEUTRAL]")
			Status:SetColor( Color(255, 255, 255, 255) )			
		end
		Status:SizeToContents()

		
		SList:AddItem( PList )	
	end	
	return true	
	
end

/*---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
---------------------------------------------------------*/
function GM:ScoreboardShow()
	if ( scoreboard == nil ) then
		GAMEMODE:HUDDrawScoreboard()
	else
		GUI_ScoreBoard_Frame:SetVisible( true )
		if GUI_AdminSB_Button then		
		GUI_AdminSB_Button:SetVisible( true )	
		end
	end
	gui.EnableScreenClicker(true)
	LocalPlayer().ScoreBoard = true
end

/*---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
---------------------------------------------------------*/
function GM:ScoreboardHide()
	if INTRO then
		return
	end
	GUI_ScoreBoard_Frame:SetVisible( false )
	if GUI_AdminSB_Button then
	GUI_AdminSB_Button:SetVisible( false )	
	end
	gui.EnableScreenClicker(false)
	LocalPlayer().ScoreBoard = false
end