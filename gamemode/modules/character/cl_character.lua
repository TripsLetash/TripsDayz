-- Xavier is a butthurt scrub.

print("loaded char")

net.Receive("CharSelect", function(len)
	GUI_Select_Model()
end)

net.Receive("CharReady", function(len)
	GUI_ReadyToPlay()
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
	IsInitialized = true
	if (ShouldSelectModel) then
		GUI_Select_Model()
	end
end
hook.Add("InitPostEntity", "SelectModelWait", SelectModelWait)

local cyb_mouseover = Color(41,128,185,80)
local cyb_cat_mouseover = Color(220,220,220,10)
local cyb_cat_mouseover_text = Color(140,140,140,40)

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

		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawRect( 0, 0, ScrW(), ScrH() )


		end

	GUI_Model_Frame:MakePopup()
	GUI_Model_Frame:ShowCloseButton(false)

-------------------------------------------------------------------------------------
-- * Makes the Background * - One Day Soon

	cyb_animated_bg = vgui.Create("DPanel", GUI_Model_Frame)
	cyb_animated_bg:SetSize( ScrW(), ScrH() )
	cyb_animated_bg:SetPos(0, 0 - ScrH() )
	

	cyb_animated_bg:MoveTo( 0 , ScrH(), 60, 0, -1, nil)


		cyb_animated_bg.Paint = function()

			local upmat = Material("gui/gradient_up")
			local downmat = Material("gui/gradient_down")

			surface.SetDrawColor(Color(41,128,185,80))
			surface.SetMaterial( upmat )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() / 2)
			surface.SetMaterial( downmat )
			surface.DrawTexturedRect( 0, ScrH() /2, ScrW(), ScrH() / 2)

		end


-- CybGmod.net Takes Hexagons to a whole new level. Special thanks to Kamshak for
-- pointing my non mathmatical ass in the right direction and looter for telling
-- my ass to use derma.

	cyb_Hexagons = vgui.Create("DIconLayout", GUI_Model_Frame)
	cyb_Hexagons:SetSize(ScrW() +100, ScrH() + 100)
	cyb_Hexagons:SetPos(-50,-50)
	cyb_Hexagons:SetSpaceX( 0 )
	cyb_Hexagons:SetSpaceY( 80 )

	x_Hexagons = vgui.Create("DIconLayout", GUI_Model_Frame)
	x_Hexagons:SetSize(ScrW() +100, ScrH() + 100)
	x_Hexagons:SetPos(0,40)
	x_Hexagons:SetSpaceX( 0 )
	x_Hexagons:SetSpaceY( 80 )

	for i = 1, 150 do

		cyb_hex = cyb_Hexagons:Add("DPanel")
		cyb_hex:SetSize(100,100)

			cyb_hex.Paint = function()

				draw.Hexagon( 50, 50, 50, Color(0,0,0,255) )

			end

		x_hex = x_Hexagons:Add("DPanel")
		x_hex:SetSize(100,100)

			x_hex.Paint = function()

				draw.Hexagon( 50, 50, 50, Color(0,0,0,255) )

			end

	end





-------------------------------------------------------------------------------------
--STEEZE SLICES THE CAKE... BITCH - *Chucks the Old Shit in Some Derma for Later*

	surface.CreateFont( "char_title", { font = "Segoe UI Bold", size = 48, antialias = true })
	surface.CreateFont( "char_options", { font = "Segoe UI Bold", size = 48, antialias = true, shadow = true, outline = true })

	GUI_Model_Content = vgui.Create("DPanel", GUI_Model_Frame)
	GUI_Model_Content:SetSize(ScrW(), ScrH())
	GUI_Model_Content:SetPos(0,0)

		GUI_Model_Content.Paint = function()

			draw.SimpleText("SELECT YOUR CHARACTER", "char_title", ScrW() / 2, 50, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			--draw.DrawText("Body Type "..(!UsingCustomModel and  "("..Head.."/"..#PlayerModels[Outfit]..")" or ""), "ScoreboardContent", ScrW()/2-btnMarginLeft-10, ScrH()*0.15+15, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
			--draw.DrawText("Gender "..(!UsingCustomModel and  "("..(Gender == 1 and "Female" or "Male")..")" or ""), "ScoreboardContent", ScrW()/2-btnMarginLeft-10, ScrH()*0.55+15, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
			--draw.DrawText("Clothes "..(!UsingCustomModel and  "("..Outfit.."/"..#PlayerModels..")" or "") , "ScoreboardContent", ScrW()/2-btnMarginLeft-10, ScrH()*0.35+15, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)

		end

	GUI_Model_Cat_Body = vgui.Create("DPanel", GUI_Model_Content)
	GUI_Model_Cat_Body:SetSize( ScrW(), ScrH() / 3 )
	GUI_Model_Cat_Body:SetPos( 0 , 0 )

		GUI_Model_Cat_Body.Paint = function(self)

			if self.Hovered then

				surface.SetDrawColor(cyb_cat_mouseover)
				surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
				surface.DrawRect( 0, 0, 100, self:GetTall() )
				surface.DrawRect( ScrW() -100, 0, 100, self:GetTall() )

			end

			draw.SimpleText("BODY", "char_options", self:GetWide() / 3, self:GetTall() / 2, cyb_cat_mouseover_text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

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
	GUI_Model_Cat_Sex:SetSize( ScrW(), ScrH() / 3 )
	GUI_Model_Cat_Sex:SetPos( 0 , ScrH() - (ScrH() / 3) )

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
	GUI_HeadLeft_Button:SetSize( 100, ScrH() / 3 )
	GUI_HeadLeft_Button:SetPos( 0, 0)
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
	GUI_HeadRight_Button:SetSize( 100, ScrH() / 3 )
	GUI_HeadRight_Button:SetPos( ScrW() - 100, 0)
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
	GUI_GenderLeft_Button:SetSize( 100, ScrH() / 3 )
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
	GUI_GenderRight_Button:SetSize( 100, ScrH() / 3 )
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
	GUI_ConfirmChoice_Button:SetSize( 300, 60 )
	GUI_ConfirmChoice_Button:SetPos( (ScrW() / 2) - 150, ScrH() - 120 )
	GUI_ConfirmChoice_Button:SetText( "" )

		GUI_ConfirmChoice_Button.Paint = function(self)

			if self.Hovered then

				surface.SetDrawColor( cyb_mouseover )
				surface.DrawRect( 0, 0, self:GetWide(), self:GetTall())

			else

				surface.SetDrawColor( cyb_cat_mouseover )
				surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

			end

			draw.SimpleText("CONFIRM", "char_title", self:GetWide() / 2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)

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
			GUI_Model_Frame:Remove()
		end
end


function GUI_ReadyToPlay()
	local ConfirmWindow = vgui.Create("DFrame")
	ConfirmWindow:SetTitle("")
	ConfirmWindow:SetSize(ScrW() ,ScrH())
	ConfirmWindow:Center()
	ConfirmWindow:SetDraggable(false)
	ConfirmWindow.Paint = function()
			draw.RoundedBox(0,0,0,ConfirmWindow:GetWide(),ConfirmWindow:GetTall(),Color( 0, 0, 0, 255 ))
			draw.DrawText("Do you wish to continue where you left off?", "ScoreboardHeader", ScrW()/2, ScrH() / 2 - 25, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		end
	local ConfirmButton = vgui.Create( "DButton")
	ConfirmButton:SetParent(ConfirmWindow)	
	ConfirmButton:SetSize( btnMarginLeft*2, 50 )
	ConfirmButton:SetPos( ScrW()/2-btnMarginLeft, ScrH()/2+25 )
	ConfirmButton:SetText( "Yes" )
	ConfirmButton:SetTextColor( Color(255,255,255,255) )
	ConfirmButton.Paint = function(self)
			surface.SetDrawColor(cyb_mouseover)
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall())
		end

	ConfirmButton.DoClick = function()
			RunConsoleCommand("ConfirmCharacter")
			ConfirmWindow:Remove()
		end

	ConfirmWindow:MakePopup()
	ConfirmWindow:ShowCloseButton(false)
end