-- Xavier is a butthurt scrub.

print("loaded char")

net.Receive("CharSelect", function(len)
	GUI_Select_Model()
end)

PlayMusicOnce = 1
--------------------------------------------------------------------------------------------------------------

-- THIS CODE WILL BE RELEASED AS A PART OF STEEZE_LIB
-- A library for drawing shapes and effects.

function draw.Hexagon( xpos, ypos, hex_radius, hexcol )

 	local hexagon_table = {

	{ x = xpos + (math.cos(math.rad(30)) * hex_radius), y = ypos + (math.sin(math.rad(30)) * hex_radius) },
	{ x = xpos + (math.cos(math.rad(90)) * hex_radius), y = ypos + (math.sin(math.rad(90)) * hex_radius) },
	{ x = xpos + (math.cos(math.rad(150)) * hex_radius), y = ypos + (math.sin(math.rad(150)) * hex_radius) },
	{ x = xpos + (math.cos(math.rad(210)) * hex_radius), y = ypos + (math.sin(math.rad(210)) * hex_radius) },
	{ x = xpos + (math.cos(math.rad(270)) * hex_radius), y = ypos + (math.sin(math.rad(270)) * hex_radius) },
	{ x = xpos + (math.cos(math.rad(330)) * hex_radius), y = ypos + (math.sin(math.rad(330)) * hex_radius) },

	}

	surface.SetDrawColor( hexcol )
	draw.NoTexture()
	surface.DrawPoly( hexagon_table )


end



--------------------------------------------------------------------------------------------------------------

local function wrap(current, step, min, max)
	current = current + step;
	if (current > max) then
		current = min;
	elseif (current < min) then
		current = max;
	end
	return current;
end

local btnMarginRight = 120;
local btnMarginLeft = 170;
local Outfit, Head = 1, 1;
local Gender = 0;
local UsingCustomModel = false;
local PlayerModels = MaleModels;

local IsInitialized = false
local ShouldSelectModel = false
local function SelectModelWait()
	GUI_ReadyToPlay()
	IsInitialized = true
	if (ShouldSelectModel) then
		GUI_Select_Model()
	end
	
	
end
hook.Add("InitPostEntity", "SelectModelWait", SelectModelWait)

local cyb_mouseover = Color(172,0,0,80)
local cyb_cat_mouseover = Color(220,220,220,10)
local cyb_cat_mouseover_text = Color(140,140,140,150)

function GUI_Select_Model()

	if not (IsInitialized) then
		ShouldSelectModel = true
		return
	end



	PlayerModels = PlayerModels or MaleModels;

	GUI_Model_Frame = vgui.Create("DFrame")
	GUI_Model_Frame:SetTitle("")
	GUI_Model_Frame:SetSize(ScrW(), ScrH())
	GUI_Model_Frame:Center()
	GUI_Model_Frame:SetDraggable(false)

		GUI_Model_Frame.Paint = function()
			local background = {}			
			background.origin = Vector(0, 0, 100)
			background.x = 0
			background.y = 0
			background.w = ScrW()
			background.h = ScrH()
			background.angles = Angle( 0, 0, 0 )	
			render.RenderView(background)
			draw.RoundedBox( 0, 0, 0, ScrW(), 150, Color( 0, 0, 0, 255 ) )
			draw.RoundedBox( 0, 0, ScrH() - 150, ScrW(), 150, Color( 0, 0, 0, 255 ) )
		end

	GUI_Model_Frame:MakePopup()
	GUI_Model_Frame:ShowCloseButton(false)

	surface.CreateFont( "char_title", { font = "Segoe UI Bold", size = 48, antialias = true })
	surface.CreateFont( "char_options", { font = "Segoe UI Bold", size = 48, antialias = true, shadow = true, outline = true })

	GUI_Model_Content = vgui.Create("DPanel", GUI_Model_Frame)
	GUI_Model_Content:SetSize(ScrW(), ScrH())
	GUI_Model_Content:SetPos(0,0)

		GUI_Model_Content.Paint = function()
		
			draw.SimpleText("SELECT YOUR CHARACTER", "ScoreboardHeader",ScrW() / 2, 100, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
		end

	GUI_Model_Cat_Body = vgui.Create("DPanel", GUI_Model_Content)
	GUI_Model_Cat_Body:SetSize( ScrW(), (ScrH() / 3) - 150)
	GUI_Model_Cat_Body:SetPos( 0 , 150 )

		GUI_Model_Cat_Body.Paint = function(self)

			if self.Hovered then

				surface.SetDrawColor(cyb_cat_mouseover)
				surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
				surface.DrawRect( 0, 0, 100, self:GetTall() )
				surface.DrawRect( ScrW() -100, 0, 100, self:GetTall() )

			end

			draw.SimpleText("HEAD", "char_options", self:GetWide() / 3, self:GetTall() / 2, cyb_cat_mouseover_text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			draw.SimpleText((!UsingCustomModel and  "("..Head.."/"..#PlayerModels[Outfit]..")" or ""), "char_options", self:GetWide() - (self:GetWide() / 3), self:GetTall() / 2, cyb_cat_mouseover_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)


		end

	GUI_Model_Cat_Clothes = vgui.Create("DPanel", GUI_Model_Content)
	GUI_Model_Cat_Clothes:SetSize( ScrW(), ScrH() / 3 )
	GUI_Model_Cat_Clothes:SetPos( 0 , ScrH() / 3 )

		GUI_Model_Cat_Clothes.Paint = function(self)

			if self.Hovered then

				surface.SetDrawColor(cyb_cat_mouseover)
				surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
				surface.DrawRect( 0, 0, 100, self:GetTall() )
				surface.DrawRect( ScrW() -100, 0, 100, self:GetTall() )

			end

			draw.SimpleText("CLOTHES", "char_options", self:GetWide() / 3, self:GetTall() / 2, cyb_cat_mouseover_text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			draw.SimpleText((!UsingCustomModel and  "("..Outfit.."/"..#PlayerModels..")" or "") , "char_options", self:GetWide() - (self:GetWide() / 3), self:GetTall() / 2, cyb_cat_mouseover_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)


		end

	GUI_Model_Cat_Sex = vgui.Create("DPanel", GUI_Model_Content)
	GUI_Model_Cat_Sex:SetSize( ScrW(), ScrH() / 3 -150)
	GUI_Model_Cat_Sex:SetPos( 0 , (ScrH() - (ScrH() / 3)) )

		GUI_Model_Cat_Sex.Paint = function(self)

			if self.Hovered then

				surface.SetDrawColor(cyb_cat_mouseover)
				surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
				surface.DrawRect( 0, 0, 100, self:GetTall() )
				surface.DrawRect( ScrW() -100, 0, 100, self:GetTall() )

			end

			draw.SimpleText("GENDER", "char_options", self:GetWide() / 3, self:GetTall() / 2, cyb_cat_mouseover_text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			draw.SimpleText((!UsingCustomModel and  "("..(Gender == 1 and "Female" or "Male")..")" or ""), "char_options", self:GetWide() - (self:GetWide() / 3), self:GetTall() / 2, cyb_cat_mouseover_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)


		end







-------------------------------------------------------------------------------------
	
	GUI_Player_Model = vgui.Create( "DModelPanel", GUI_Model_Frame )
	GUI_Player_Model:SetModel(PlayerModels[Outfit][Head] )


	GUI_Player_Model:SetSize( 300, ScrH() * 0.8 )
	GUI_Player_Model:SetPos( ScrW()/2-150, ScrH()/2 - GUI_Player_Model:GetTall()/2)
	GUI_Player_Model:SetCamPos( Vector( 47, 0, 35 ) )
	GUI_Player_Model:SetLookAt( Vector( 0, 0, 35 ) )	
	GUI_Player_Model:SetFOV(43200/ScrH())	
	
	function GUI_Player_Model:LayoutEntity( Entity )
		self:SetCamPos(Vector(47, 0, 35))
		self:SetLookAt(Vector(0,0,35))		
	end	
	
	local GUI_HeadLeft_Button = vgui.Create( "DButton")
	GUI_HeadLeft_Button:SetParent(GUI_Model_Frame)	
	GUI_HeadLeft_Button:SetSize( 100, (ScrH() / 3) -150 )
	GUI_HeadLeft_Button:SetPos( 0, 150)
	GUI_HeadLeft_Button:SetText( "" )

		GUI_HeadLeft_Button.Paint = function(self)

			if GUI_HeadLeft_Button.Hovered then

				surface.SetDrawColor(cyb_mouseover)
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

			end

			draw.SimpleText("<", "char_title", self:GetWide() / 2, self:GetTall() / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
								
	local GUI_HeadRight_Button = vgui.Create( "DButton")
	GUI_HeadRight_Button:SetParent(GUI_Model_Frame)	
	GUI_HeadRight_Button:SetSize( 100, (ScrH() / 3)-150 )
	GUI_HeadRight_Button:SetPos( ScrW() - 100, 150)
	GUI_HeadRight_Button:SetText( "" )

		GUI_HeadRight_Button.Paint = function(self)

			if GUI_HeadRight_Button.Hovered then

				surface.SetDrawColor(cyb_mouseover)
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

			end

			draw.SimpleText(">", "char_title", self:GetWide() / 2, self:GetTall() / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end

	local GUI_GenderLeft_Button = vgui.Create( "DButton")
	GUI_GenderLeft_Button:SetParent(GUI_Model_Frame)	
	GUI_GenderLeft_Button:SetSize( 100, (ScrH() / 3) - 150)
	GUI_GenderLeft_Button:SetPos( 0, ScrH() - ( ScrH() / 3 ) )
	GUI_GenderLeft_Button:SetText( "" )

		GUI_GenderLeft_Button.Paint = function(self)

			if GUI_GenderLeft_Button.Hovered then

				surface.SetDrawColor(cyb_mouseover)
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

			end

			draw.SimpleText("<", "char_title", self:GetWide() / 2, self:GetTall() / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end
								
	local GUI_GenderRight_Button = vgui.Create( "DButton")
	GUI_GenderRight_Button:SetParent(GUI_Model_Frame)	
	GUI_GenderRight_Button:SetSize( 100, (ScrH() / 3) - 150 )
	GUI_GenderRight_Button:SetPos( ScrW() - 100, ScrH() - ( ScrH() / 3) )
	GUI_GenderRight_Button:SetText( "" )

		GUI_GenderRight_Button.Paint = function(self)

			if GUI_GenderRight_Button.Hovered then

				surface.SetDrawColor(cyb_mouseover)
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

			end

			draw.SimpleText(">", "char_title", self:GetWide() / 2, self:GetTall() / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end
								
	local GUI_OutfitLeft_Button = vgui.Create( "DButton")
	GUI_OutfitLeft_Button:SetParent(GUI_Model_Frame)	
	GUI_OutfitLeft_Button:SetSize( 100, ScrH() / 3 )
	GUI_OutfitLeft_Button:SetPos( 0, ScrH() /3 )
	GUI_OutfitLeft_Button:SetText( "" )

		GUI_OutfitLeft_Button.Paint = function(self)

			if GUI_OutfitLeft_Button.Hovered then

				surface.SetDrawColor(cyb_mouseover)
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

			end

			draw.SimpleText("<", "char_title", self:GetWide() / 2, self:GetTall() / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end

	local GUI_OutfitRight_Button = vgui.Create( "DButton")
	GUI_OutfitRight_Button:SetParent(GUI_Model_Frame)	
	GUI_OutfitRight_Button:SetSize( 100, ScrH() / 3 )
	GUI_OutfitRight_Button:SetPos( ScrW() -100, ScrH() / 3 )
	GUI_OutfitRight_Button:SetText( "" )

	GUI_OutfitRight_Button.Paint = function(self)

			if GUI_OutfitRight_Button.Hovered then

				surface.SetDrawColor(cyb_mouseover)
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

			end

			draw.SimpleText(">", "char_title", self:GetWide() / 2, self:GetTall() / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end
								
	local GUI_ConfirmChoice_Button = vgui.Create( "DButton")
	GUI_ConfirmChoice_Button:SetParent(GUI_Model_Frame)	
	GUI_ConfirmChoice_Button:SetSize( 300, 50 )
	GUI_ConfirmChoice_Button:SetPos( (ScrW() / 2) - 150, ScrH() - 100 )
	GUI_ConfirmChoice_Button:SetText( "" )

		GUI_ConfirmChoice_Button.Paint = function(self)

			if self.Hovered then

				surface.SetDrawColor( cyb_mouseover )
				surface.DrawRect( 0, 0, self:GetWide(), self:GetTall())

			else

				surface.SetDrawColor( cyb_cat_mouseover )
				surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

			end

			draw.SimpleText("CONFIRM", "ScoreboardHeader", self:GetWide() / 2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)

		end


	GUI_HeadLeft_Button.DoClick = function()
			UsingCustomModel = false
			Head = wrap(Head, -1, 1, #PlayerModels[Outfit])
			GUI_Player_Model:SetModel(PlayerModels[Outfit][Head])
		end

	GUI_HeadRight_Button.DoClick = function()
			UsingCustomModel = false
			Head = wrap(Head, 1, 1, #PlayerModels[Outfit])
			GUI_Player_Model:SetModel(PlayerModels[Outfit][Head])
		end

	GUI_GenderLeft_Button.DoClick = function()
			UsingCustomModel = false
			Gender = wrap(Gender, -1, 0, 1)
			Outfit, Head = 1, 1;
			PlayerModels = Gender == 0 and MaleModels or FemaleModels
			GUI_Player_Model:SetModel(PlayerModels[Outfit][Head])
		end

	GUI_GenderRight_Button.DoClick = function()
			UsingCustomModel = false
			Gender = wrap(Gender, 1, 0, 1)
			Outfit, Head = 1, 1;
			PlayerModels = Gender == 0 and MaleModels or FemaleModels
			GUI_Player_Model:SetModel(PlayerModels[Outfit][Head])
		end

	GUI_OutfitLeft_Button.DoClick = function()
			UsingCustomModel = false
			Outfit = wrap(Outfit, -1, 1, #PlayerModels)
			Head = math.Clamp(Head, 1, #PlayerModels[Outfit])
			GUI_Player_Model:SetModel(PlayerModels[Outfit][Head])
		end

	GUI_OutfitRight_Button.DoClick = function()
			UsingCustomModel = false
			Outfit = wrap(Outfit, 1, 1, #PlayerModels)
			Head = math.Clamp(Head, 1, #PlayerModels[Outfit])
			GUI_Player_Model:SetModel(PlayerModels[Outfit][Head])
		end

	GUI_ConfirmChoice_Button.DoClick = function()
			if (UsingCustomModel) then
				RunConsoleCommand("UpdateCustomModel", Outfit)--Yep, that's right
				RunConsoleCommand("ConfirmCharacter")
			else
				RunConsoleCommand("UpdateCharModel", Outfit, Head, Gender)
				RunConsoleCommand("ConfirmCharacter")
			end
			timer.Simple(1,function()
				GUI_Model_Frame:Remove()
			end)
		end
end

function GUI_ReadyToPlay()
	surface.CreateFont( "game_title", { font = "Segoe UI Bold", size = 196, antialias = true })
	surface.CreateFont( "game_present", { font = "Segoe UI Bold", size = 32, antialias = true })
	local ConfirmWindow = vgui.Create("DFrame")
	ConfirmWindow:SetTitle("")
	ConfirmWindow:SetSize(ScrW() ,ScrH())
	ConfirmWindow:Center()
	ConfirmWindow:SetDraggable(false)
	ConfirmWindow.Paint = function()
		--if BackGroundLoaded == true then
			local background = {}			
			background.origin = Vector(5321,-5927,70)
			background.x = 0
			background.y = 0
			background.w = ScrW()
			background.h = ScrH()
			background.angles = Angle( 0, -75, 0 )	
			render.RenderView(background)
			draw.RoundedBox( 0, 0, 0, ScrW(), 150, Color( 0, 0, 0, 255 ) )
			draw.RoundedBox( 0, 0, ScrH() - 150, ScrW(), 150, Color( 0, 0, 0, 255 ) )	
			--draw.RoundedBox(0,0,0,ConfirmWindow:GetWide(),ConfirmWindow:GetTall(),Color( 0, 0, 0, 10 ))
			draw.DrawText("Are you ready to brave the hordes?", "ScoreboardHeader", ScrW()/2, ScrH() - 95, Color(255, 255, 255, 100),TEXT_ALIGN_CENTER)
			draw.DrawText("presents", "game_present", (ScrW()/5)*3.15, ScrH()/3, Color(255, 255, 255, 50),TEXT_ALIGN_CENTER)
			draw.DrawText("DayZ", "game_title", (ScrW()/5)*3.1, (ScrH()/5)*2, Color(255, 255, 255, 50),TEXT_ALIGN_CENTER)
		--end
	end
	
	local DIconTripsTown = vgui.Create("DImage")
	DIconTripsTown:SetParent(ConfirmWindow)
	DIconTripsTown:SetPos( (ScrW()/5)*3,ScrH()/5)
	DIconTripsTown:SetImage("vgui/logo_tripstown")
	DIconTripsTown:SetSize(128,128)
	
	local DcButton = vgui.Create("DButton")
	DcButton:SetParent(ConfirmWindow)
	DcButton:SetSize( btnMarginLeft*2, 50 )
	DcButton:SetPos( ((ScrW()/4)*3) - btnMarginLeft, ScrH() - 100 )
	DcButton:SetText(" ")
	DcButton:SetTextColor( Color(255,255,255,255) )
	DcButton.Paint = function(self)
		if self.Hovered then
			surface.SetDrawColor(cyb_mouseover)
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall())
		else
			surface.SetDrawColor(cyb_cat_mouseover)
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall())
		end
		draw.SimpleText("No (Disconnect)", "ScoreboardHeader", self:GetWide() / 2, 5, Color(255,255,255,100), TEXT_ALIGN_CENTER)
	end
	DcButton.DoClick = function()
			RunConsoleCommand("disconnect")
			ConfirmWindow:Remove()
	end
	
	local ConfirmButton = vgui.Create( "DButton")
	ConfirmButton:SetParent(ConfirmWindow)
	ConfirmButton:SetSize( btnMarginLeft*2, 50 )
	ConfirmButton:SetPos( ScrW()/4 - btnMarginLeft, ScrH() - 100 )
	ConfirmButton:SetText( " " )
	ConfirmButton:SetTextColor( Color(255,255,255,255) )
	ConfirmButton.Paint = function(self)
		if self.Hovered then
			surface.SetDrawColor(cyb_mouseover)
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall())
		else
			surface.SetDrawColor(cyb_cat_mouseover)
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall())
		end
		draw.SimpleText("Yes (Join Game)", "ScoreboardHeader", self:GetWide() / 2, 5, Color(255,255,255,100), TEXT_ALIGN_CENTER)
	end

	ConfirmButton.DoClick = function()
			RunConsoleCommand("ReadyCharacter")
			timer.Simple(1,function()
				ConfirmWindow:Remove() 
			end)
		end

	ConfirmWindow:MakePopup()
	ConfirmWindow:ShowCloseButton(false)
	
	
end