local vgui = vgui
local draw = draw
local surface = surface
local gradient = Material("gui/gradient")

CyBConf = {}
CyBConf.InvKey = CreateClientConVar("cyb_invkey", KEY_Q, true, false)
CyBConf.MinimapEnabled = CreateClientConVar("cyb_minimap", 1, true, false)
CyBConf.MapShowZombies = CreateClientConVar("cyb_mapshowzomb", 0, true, false)
CyBConf.CombatMusic = CreateClientConVar("cyb_combatmusic", 1, true, false)

function GUI_MainMenu()
	if LocalPlayer():InVehicle() then return end
	if !LocalPlayer():Alive() then return end
	if GUI_Bank_Frame != nil && GUI_Bank_Frame:IsValid() then GUI_Bank_Frame:Remove() end
	if GUI_Donate_Frame != nil && GUI_Donate_Frame:IsValid() then GUI_Donate_Frame:Remove() end
	
	GUI_Main_Frame = vgui.Create("DFrame")
	GUI_Main_Frame:SetTitle("")
	GUI_Main_Frame:SetSize(860 ,610)
	GUI_Main_Frame:Center()
	GUI_Main_Frame:SetDraggable(false)
	GUI_Main_Frame.Paint = function()
		surface.SetDrawColor(0,0,0,145)
		surface.DrawRect(64,0, GUI_Main_Frame:GetWide()-128, GUI_Main_Frame:GetWide()-2,GUI_Main_Frame:GetTall())


		surface.SetMaterial( gradient )
		surface.DrawTexturedRect(GUI_Main_Frame:GetWide() -64, 0, 64, GUI_Main_Frame:GetTall())
		surface.DrawTexturedRectRotated(32, GUI_Main_Frame:GetTall() /2, 64, GUI_Main_Frame:GetTall(), 180)


		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect(64,0,GUI_Main_Frame:GetWide()-128,2)
		surface.DrawRect(64,GUI_Main_Frame:GetTall() -2,GUI_Main_Frame:GetWide()-128,2)
		surface.DrawTexturedRectRotated(32, 1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Main_Frame:GetWide()-64, 0, 64, 2)
		surface.DrawTexturedRectRotated(32, GUI_Main_Frame:GetTall()-1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Main_Frame:GetWide()-64, GUI_Main_Frame:GetTall()-2, 64, 2)
		
		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect(64,60,GUI_Main_Frame:GetWide()-128,2)
		surface.DrawRect(64,GUI_Main_Frame:GetTall() -2,GUI_Main_Frame:GetWide()-128,2)
		surface.DrawTexturedRectRotated(32, 61, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Main_Frame:GetWide()-64, 60, 64, 2)
		surface.DrawTexturedRectRotated(32, GUI_Main_Frame:GetTall()-1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Main_Frame:GetWide()-64, GUI_Main_Frame:GetTall()-2, 64, 2)

		local logo_l = Material("gui/cybr_L.png")
		local logo_r = Material("gui/cybr_R.png")

		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial( logo_l )
		surface.DrawTexturedRect( 10, 0, 64, 64)
		surface.SetMaterial( logo_r )
		surface.DrawTexturedRect( 74, 0, 64, 64)
		
	end

	GUI_Main_Frame:MakePopup()
	GUI_Main_Frame:ShowCloseButton(false)
	
	local GUI_Property_Sheet = vgui.Create("DVerticalPropertySheet", GUI_Main_Frame)
	GUI_Property_Sheet:SetPos(22,22)
	GUI_Property_Sheet:SetSize(778,585)
	GUI_Property_Sheet.Paint = function() 
								end
								
	GUI_Inv_tab_Panel = vgui.Create("DPanel")
	GUI_Inv_tab_Panel:SetSize(756,585)
	GUI_Inv_tab_Panel:SetPos(11,22)
	GUI_Inv_tab_Panel.Paint = function()
								end
																
	GUI_Craft_tab_Panel = vgui.Create("DPanel")
	GUI_Craft_tab_Panel:SetSize(756,585)
	GUI_Craft_tab_Panel:SetPos(11,22)
	GUI_Craft_tab_Panel.Paint = function()
								end	

	GUI_Level_tab_Panel = vgui.Create("DPanel")
	GUI_Level_tab_Panel:SetSize(756,585)
	GUI_Level_tab_Panel:SetPos(11,22)
	GUI_Level_tab_Panel.Paint = function()
								end	
								
	GUI_Squad_tab_Panel = vgui.Create("DPanel")
	GUI_Squad_tab_Panel:SetSize(756,585)
	GUI_Squad_tab_Panel:SetPos(11,22)
	GUI_Squad_tab_Panel.Paint = function()
								end	
								
	GUI_Donate_tab_Panel = vgui.Create("DPanel")
	GUI_Donate_tab_Panel:SetSize(756,585)
	GUI_Donate_tab_Panel:SetPos(11,22)
	GUI_Donate_tab_Panel.Paint = function()
								end	

--[[ 	GUI_Advert_tab_Panel = vgui.Create("DPanel")
	GUI_Advert_tab_Panel:SetSize(756,480)
	GUI_Advert_tab_Panel:SetPos(11,22)
	GUI_Advert_tab_Panel.Paint = function()
								end	 ]]	

	GUI_Settings_tab_Panel = vgui.Create("DPanel")
	GUI_Settings_tab_Panel:SetSize(756,480)
	GUI_Settings_tab_Panel:SetPos(11,22)
	GUI_Settings_tab_Panel.Paint = function()
								end									


	local GUI_MainMenu_DonateButtonText = vgui.Create("DButton", GUI_Main_Frame)
	GUI_MainMenu_DonateButtonText:SetColor(Color(255,255,255,255))
	GUI_MainMenu_DonateButtonText:SetFont("Cyb_Inv_Bar")
	GUI_MainMenu_DonateButtonText:SetText("Click here to help the server by purchasing VIP, credits and more!")
	GUI_MainMenu_DonateButtonText.Paint = function() end
	GUI_MainMenu_DonateButtonText:SetSize(390,32)
	GUI_MainMenu_DonateButtonText:SetPos(GUI_Main_Frame:GetWide()/2-GUI_MainMenu_DonateButtonText:GetWide()/2, 34)
	GUI_MainMenu_DonateButtonText.DoClick = function() if GUI_Main_Frame:IsValid() then GUI_Main_Frame:Close() end gui.OpenURL(PHDayZ.DonateURL) end

	local GUI_MainMenu_DonateButton = vgui.Create("DImageButton", GUI_Main_Frame)
	GUI_MainMenu_DonateButton:SetColor(Color(255,255,255,255))
	GUI_MainMenu_DonateButton:SetFont("Cyb_Inv_Bar")
	GUI_MainMenu_DonateButton:SetImage("icon16/heart.png")
	GUI_MainMenu_DonateButton.Paint = function() end
	GUI_MainMenu_DonateButton:SetSize(16,16)
	GUI_MainMenu_DonateButton:SetPos(GUI_Main_Frame:GetWide()/2-GUI_MainMenu_DonateButtonText:GetWide()/2-15, 42)
	GUI_MainMenu_DonateButton.DoClick = function() if GUI_Main_Frame:IsValid() then GUI_Main_Frame:Close() end gui.OpenURL(PHDayZ.DonateURL) end
	
	local GUI_MainMenu_DonateButton = vgui.Create("DImageButton", GUI_Main_Frame)
	GUI_MainMenu_DonateButton:SetColor(Color(255,255,255,255))
	GUI_MainMenu_DonateButton:SetFont("Cyb_Inv_Bar")
	GUI_MainMenu_DonateButton:SetImage("icon16/heart.png")
	GUI_MainMenu_DonateButton.Paint = function() end
	GUI_MainMenu_DonateButton:SetSize(16,16)
	GUI_MainMenu_DonateButton:SetPos(GUI_Main_Frame:GetWide()/2+GUI_MainMenu_DonateButtonText:GetWide()/2, 42)
	GUI_MainMenu_DonateButton.DoClick = function() if GUI_Main_Frame:IsValid() then GUI_Main_Frame:Close() end gui.OpenURL(PHDayZ.DonateURL) end

	
	local GUI_MainMenu_CloseButton = vgui.Create("DButton", GUI_Main_Frame)
	GUI_MainMenu_CloseButton:SetColor(Color(255,255,255,255))
	GUI_MainMenu_CloseButton:SetFont("Cyb_Inv_Bar")
	GUI_MainMenu_CloseButton:SetText("X")
	GUI_MainMenu_CloseButton.Paint = function() end
	GUI_MainMenu_CloseButton:SetSize(32,32)
	GUI_MainMenu_CloseButton:SetPos(GUI_Main_Frame:GetWide()-80, 0)
	GUI_MainMenu_CloseButton.DoClick = function() if GUI_Main_Frame:IsValid() then GUI_Main_Frame:Close() end end
										
	GUI_Property_Sheet:AddSheet( "Inventory", GUI_Inv_tab_Panel, "cyb_mat/cyb_backpack.png", true, true, "Items in your inventory." )
	GUI_Property_Sheet:AddSheet( "Crafting", GUI_Craft_tab_Panel, "cyb_mat/cyb_crafting.png", true, true, "Craft new weapons, food and more!" )
	GUI_Property_Sheet:AddSheet( "Levelling", GUI_Level_tab_Panel, "cyb_mat/cyb_level.png", true, true, "View your character level perks." )

	--GUI_Property_Sheet:AddSheet( "Help", GUI_Advert_tab_Panel, "cyb_mat/cyb_help.png", true, true, "View the controls, content pack, guide and more!." )	
	GUI_Property_Sheet:AddSheet( "Settings", GUI_Settings_tab_Panel, "cyb_mat/cyb_settings.png", true, true, "Change your ingame settings!" )	
	
	GUI_Rebuild_Inventory(GUI_Inv_tab_Panel)
	GUI_Rebuild_Crafting(GUI_Craft_tab_Panel)
	GUI_Rebuild_Levels(GUI_Level_tab_Panel)
	--GUI_Rebuild_ContentPack(GUI_Advert_tab_Panel)	
	GUI_Rebuild_Settings(GUI_Settings_tab_Panel)	

	end

concommand.Add( "MainMenu", GUI_MainMenu )

function GUI_Rebuild_Levels(parent)
	if GUI_Level_Panel_List != nil && GUI_Level_Panel_List:IsValid() then
		GUI_Level_Panel_List:Clear()
	else

		GUI_Level_Panel_List = vgui.Create("DPanelList", parent)
		GUI_Level_Panel_List:SetSize(739,495)
		GUI_Level_Panel_List:SetPos(0,50)
		GUI_Level_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Level_Panel_List:GetWide(),GUI_Level_Panel_List:GetTall(),Color( 30, 30, 30, 0 ))
									end
		GUI_Level_Panel_List:SetPadding(7.5)
		GUI_Level_Panel_List:SetSpacing(2)
		GUI_Level_Panel_List:EnableHorizontal(3)
		GUI_Level_Panel_List:EnableVerticalScrollbar(true)
		
		GUI_Rebuild_Level_Items(GUI_Level_Panel_List)	
	end
end

function GUI_Rebuild_Inventory(parent)
	if GUI_Inven_Panel_List != nil && GUI_Inven_Panel_List:IsValid() then
		GUI_Inven_Panel_List:Clear()
	else

		GUI_Inven_Panel_List = vgui.Create("DPanelList", parent)
		GUI_Inven_Panel_List:SetSize(739,525)
		GUI_Inven_Panel_List:SetPos(0,50)
		GUI_Inven_Panel_List.Paint = function()
			draw.RoundedBox(8,0,0,GUI_Inven_Panel_List:GetWide(),GUI_Inven_Panel_List:GetTall(),Color( 30, 30, 30, 0 ))
		end
		GUI_Inven_Panel_List:SetPadding(7.5)
		GUI_Inven_Panel_List:SetSpacing(2)
		GUI_Inven_Panel_List:EnableHorizontal(3)
		GUI_Inven_Panel_List:EnableVerticalScrollbar(true)
		
		GUI_Rebuild_Inv(GUI_Inven_Panel_List)	
	end
end

function GUI_Rebuild_Crafting(parent)
	if GUI_Craft_Panel_List != nil && GUI_Craft_Panel_List:IsValid() then
		GUI_Craft_Panel_List:Clear()
	else

		GUI_Craft_Panel_List = vgui.Create("DPanelList", parent)
		GUI_Craft_Panel_List:SetSize(739,495)
		GUI_Craft_Panel_List:SetPos(0,50)
		GUI_Craft_Panel_List.Paint = function()
			draw.RoundedBox(8,0,0,GUI_Craft_Panel_List:GetWide(),GUI_Craft_Panel_List:GetTall(),Color( 30, 30, 30, 0 ))
		end
		GUI_Craft_Panel_List:SetPadding(7.5)
		GUI_Craft_Panel_List:SetSpacing(2)
		GUI_Craft_Panel_List:EnableHorizontal(3)
		GUI_Craft_Panel_List:EnableVerticalScrollbar(true)
		
		GUI_Rebuild_Craft_Items(GUI_Craft_Panel_List)	
	end
end


function GUI_Rebuild_Settings(parent)
	if GUI_Settings_Panel_List != nil && GUI_Settings_Panel_List:IsValid() then
	else
		GUI_Settings_Panel_List = vgui.Create("DPanel", parent)
		GUI_Settings_Panel_List:SetSize(756,460)
		GUI_Settings_Panel_List:SetPos(0,55)
		GUI_Settings_Panel_List.Paint = function() end
				
		local GUI_InvBinder_Label = vgui.Create("DLabel", parent)
		GUI_InvBinder_Label:SetText("Inventory Key:")
		GUI_InvBinder_Label:SizeToContents()
		GUI_InvBinder_Label:SetPos(10, 56)

		local GUI_InvBinder = vgui.Create("DBinder", parent)
		GUI_InvBinder:SetSize(60,30)
		GUI_InvBinder:SetPos(85, 56)
		GUI_InvBinder:SetConVar("cyb_invkey")
		
		local MiniMapCheckBox = vgui.Create("DCheckBoxLabel", parent)
		MiniMapCheckBox:SetText("Minimap Enabled?")
		MiniMapCheckBox:SetConVar("cyb_minimap")
		MiniMapCheckBox:SetPos(10, 96)
		MiniMapCheckBox:SizeToContents()
		
		local ZombieCheckBox = vgui.Create("DCheckBoxLabel", parent)
		ZombieCheckBox:SetText("Show zombies on Minimap?")
		ZombieCheckBox:SetConVar("cyb_mapshowzomb")
		ZombieCheckBox:SetPos(10, 116)
		ZombieCheckBox:SizeToContents()
		
		local CombatCheckBox = vgui.Create("DCheckBoxLabel", parent)
		CombatCheckBox:SetText("Enable combat music?")
		CombatCheckBox:SetConVar("cyb_combatmusic")
		CombatCheckBox:SetPos(10, 136)
		CombatCheckBox:SizeToContents()
				
	end
end

function GUI_Rebuild_Donate(parent)
	if GUI_Don_Panel_List != nil && GUI_Don_Panel_List:IsValid() then
	else
	
		GUI_Don_Panel_List = vgui.Create("DPanel", parent)
		GUI_Don_Panel_List:SetSize(756,460)
		GUI_Don_Panel_List:SetPos(0,55)
		GUI_Don_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Don_Panel_List:GetWide(),GUI_Don_Panel_List:GetTall(),Color( 50, 50, 50, 50 ))
									--draw.DrawText("Loading..", "TargetIDLarge", GUI_Don_Panel_List:GetWide()/2,170, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
									end
	ServerRulesHTML = vgui.Create("HTML", GUI_Don_Panel_List)
	ServerRulesHTML:SetPos(0,0)
	ServerRulesHTML:SetSize(756, 420)
	ServerRulesHTML:OpenURL(PHDayZ.DonateURL)
	
	local GUI_ServerRules_Button2 = vgui.Create( "DButton")
	GUI_ServerRules_Button2:SetParent(GUI_Don_Panel_List)	
	GUI_ServerRules_Button2:SetSize( 250, 20 )
	GUI_ServerRules_Button2:SetPos( 100, 430 )
	GUI_ServerRules_Button2:SetText( "Click Here for Donation Benefits and Information" )
	GUI_ServerRules_Button2:SetTextColor( Color(255,255,255,255) )
	GUI_ServerRules_Button2.Paint = function()
								draw.RoundedBox(2,0,0,GUI_ServerRules_Button2:GetWide(),GUI_ServerRules_Button2:GetTall(),Color( 0, 0, 0, 255 ))	
								draw.RoundedBox(2,1,1,GUI_ServerRules_Button2:GetWide()-2,GUI_ServerRules_Button2:GetTall()-2,Color( 139, 133, 97, 55 ))
								end		
	
	local GUI_SteamID_Display = vgui.Create("DLabel", GUI_Don_Panel_List)
	GUI_SteamID_Display:SetPos(375,432) // Position
	GUI_SteamID_Display:SetColor(Color(255,255,255,255)) // Color
	GUI_SteamID_Display:SetFont("Trebuchet18")
	GUI_SteamID_Display:SetText("To purchase, login on steam-linked forum account!") // Text
	GUI_SteamID_Display:SizeToContents() // make the control the same size as the text.	

	GUI_ServerRules_Button2.DoClick = function()
		GUI_Donate_Info()
	end			
	
	end
end

hook.Add("Initialize", "InitKeys", function()
	GUI_InputInvKey = CyBConf.InvKey:GetInt() or KEY_Q
end)

local function UpdateInvKey(str, old, new)
	GUI_InputInvKey = math.floor(new)
end
cvars.AddChangeCallback(CyBConf.InvKey:GetName(), UpdateInvKey)

local function MMKeyPress()
	--print(vgui.GetKeyboardFocus())
	if LocalPlayer():IsTyping() or (IsValid(vgui.GetKeyboardFocus()) and vgui.GetKeyboardFocus():GetClassName( ) == "TextEntry") or gui.IsGameUIVisible() or gui.IsConsoleVisible()  then return end

	if input.IsKeyDown(KEY_M) then -- Q is pressed
		ShouldDrawMap = true
	else
		ShouldDrawMap = false
	end
	
	if input.IsKeyDown(GUI_InputInvKey) then
			if Qpress == false then
				mmuser_CantUse = false
			else
				mmuser_CantUse = true		
			end
		Qpress = true
			if mmuser_CantUse then return end
			
			if GUI_Inv_Panel_List != nil && GUI_Inv_Panel_List:IsValid() then
				GUI_Inv_Panel_List:Remove()
				GUI_Main_Frame:Remove()	-- Menu exists remove it
				if ItemMENU !=nil and ItemMENU:IsValid() then
					ItemMENU:Remove()
				end
			else
				GUI_MainMenu() // Create menu
			end
	else -- Q is not pressed
		Qpress = false
		--end
	end
end
hook.Add("Think","mmkeypress",MMKeyPress)

function PaintBoxToScreen()
	if DrawMap == true then
		local BoxSize = 1024;
		local Offset = BoxSize / 2;
	
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 225 ) )
		surface.SetDrawColor( 255, 255, 255, 255 );
		surface.SetTexture( surface.GetTextureID("gui/map") );
		surface.DrawTexturedRect( ( ScrW() / 2 ) - Offset, ( ScrH() / 2 ) - Offset, BoxSize, BoxSize );	
		
		draw.RoundedBox( 0, ( ScrW() / 2 ) - Offset, (BoxSize/5), BoxSize, 1, Color( 255, 255, 255, 225 ) )
		draw.RoundedBox( 0, ( ScrW() / 2 ) - Offset, (BoxSize/5)*2, BoxSize, 1, Color( 255, 255, 255, 225 ) )	
		draw.RoundedBox( 0, ( ScrW() / 2 ) - Offset, (BoxSize/5)*3, BoxSize, 1, Color( 255, 255, 255, 225 ) )	
		draw.RoundedBox( 0, ( ScrW() / 2 ) - Offset, (BoxSize/5)*4, BoxSize, 1, Color( 255, 255, 255, 225 ) )	

		draw.RoundedBox( 0, ( ScrW() / 2 ) - Offset + (BoxSize/5), ( ScrH() / 2 ) - Offset, 1, BoxSize, Color( 255, 255, 255, 225 ) )
		draw.RoundedBox( 0, ( ScrW() / 2 ) - Offset + (BoxSize/5)*2, ( ScrH() / 2 ) - Offset, 1, BoxSize, Color( 255, 255, 255, 225 ) )	
		draw.RoundedBox( 0, ( ScrW() / 2 ) - Offset + (BoxSize/5)*3, ( ScrH() / 2 ) - Offset, 1, BoxSize, Color( 255, 255, 255, 225 ) )	
		draw.RoundedBox( 0, ( ScrW() / 2 ) - Offset + (BoxSize/5)*4, ( ScrH() / 2 ) - Offset, 1, BoxSize, Color( 255, 255, 255, 225 ) )	
		
	end
end
hook.Add( "HUDPaint", "PaintBoxToScreen", PaintBoxToScreen );

function GUI_Controls_Info()

	local GUI_ControlPanel = vgui.Create( "DFrame" )
	GUI_ControlPanel:SetPos( 0,0 )
	GUI_ControlPanel:SetSize( 500, 450 )
	GUI_ControlPanel:Center()
	GUI_ControlPanel:SetTitle( "" ) 
	GUI_ControlPanel:SetVisible( true )
	GUI_ControlPanel:SetDraggable( true ) 
	GUI_ControlPanel:MakePopup()
	GUI_ControlPanel:ShowCloseButton(true)
	GUI_ControlPanel.Paint = function()
								draw.RoundedBox(0,1,1,GUI_ControlPanel:GetWide()-2,GUI_ControlPanel:GetTall()-2,Color( 100, 90, 80, 255 ))
								draw.RoundedBox(0,1,1,GUI_ControlPanel:GetWide()-2,25,Color( 77, 67, 57, 255 ))
								draw.RoundedBox(0,1,1,GUI_ControlPanel:GetWide()-2,2,Color( 0, 0, 0, 255 ))
								draw.RoundedBox(0,1,25,GUI_ControlPanel:GetWide()-2,2,Color( 0, 0, 0, 255 ))
						
							end	
	
	GUI_Info_Panel = vgui.Create("DPanel", GUI_ControlPanel)
	GUI_Info_Panel:SetSize(480,410)
	GUI_Info_Panel:SetPos(10,30)
	GUI_Info_Panel.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Info_Panel:GetWide(),GUI_Info_Panel:GetTall(),Color( 88, 77, 67, 255 ))
								end
								
	local GUI_Info_Label = vgui.Create("DLabel")
	GUI_Info_Label:SetColor(Color(255,255,255,255))
	GUI_Info_Label:SetText("Player Controls")
	GUI_Info_Label:SetPos(5,2)
	GUI_Info_Label:SetFont("TargetIDMedium")
	GUI_Info_Label:SizeToContents()
	GUI_Info_Label:SetParent(GUI_ControlPanel)
	
	local GUI_Benfit_Info_Label = vgui.Create("DLabel")
	GUI_Benfit_Info_Label:SetColor(Color(255,255,255,255))
	GUI_Benfit_Info_Label:SetText("Basic Default Controls:\nQ - Main Menu\nM - Map\nF4 - Third person\nF2 - Safe Zone Menu\nF - Flaslight (Must be in your inventory)\n\nHelicopter Controls:\nSpace - Ascend\nAlt - Descend\n\nMain Menu Controls:\nTo eat, drink or use an item left click on it in your inventory screen and then click use\nitem, you can also drop the item if your inventory is full or you want to trade with\nanother player.")
	GUI_Benfit_Info_Label:SetPos(5,5)
	GUI_Benfit_Info_Label:SetFont("TargetIDSmall")
	GUI_Benfit_Info_Label:SizeToContents()
	GUI_Benfit_Info_Label:SetParent(GUI_Info_Panel)	
end