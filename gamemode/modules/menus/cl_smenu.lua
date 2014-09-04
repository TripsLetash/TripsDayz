local vgui = vgui
local draw = draw
local surface = surface
local gradient = Material("gui/gradient")

function DonatorMenu(len)
	if GUI_Donate_Frame != nil && GUI_Donate_Frame:IsValid() then GUI_Donate_Frame:Remove() end
	GUI_Donate_Frame = vgui.Create("DFrame")
	GUI_Donate_Frame:SetTitle("")
	GUI_Donate_Frame:SetSize(820 ,600)
	GUI_Donate_Frame:Center()
	GUI_Donate_Frame:SetDraggable(false)
	GUI_Donate_Frame:MakePopup()
	GUI_Donate_Frame:ShowCloseButton(true)
	GUI_Donate_Frame.Paint = function()
		surface.SetDrawColor(0,0,0,145)
		surface.DrawRect(64,0, GUI_Donate_Frame:GetWide()-128, GUI_Donate_Frame:GetWide()-2,GUI_Donate_Frame:GetTall())


		surface.SetMaterial( gradient )
		surface.DrawTexturedRect(GUI_Donate_Frame:GetWide() -64, 0, 64, GUI_Donate_Frame:GetTall())
		surface.DrawTexturedRectRotated(32, GUI_Donate_Frame:GetTall() /2, 64, GUI_Donate_Frame:GetTall(), 180)


		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect(64,0,GUI_Donate_Frame:GetWide()-128,2)
		surface.DrawRect(64,GUI_Donate_Frame:GetTall() -2,GUI_Donate_Frame:GetWide()-128,2)
		surface.DrawTexturedRectRotated(32, 1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Donate_Frame:GetWide()-64, 0, 64, 2)
		surface.DrawTexturedRectRotated(32, GUI_Donate_Frame:GetTall()-1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Donate_Frame:GetWide()-64, GUI_Donate_Frame:GetTall()-2, 64, 2)
		
		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect(64,60,GUI_Donate_Frame:GetWide()-128,2)
		surface.DrawRect(64,GUI_Donate_Frame:GetTall() -2,GUI_Donate_Frame:GetWide()-128,2)
		surface.DrawTexturedRectRotated(32, 61, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Donate_Frame:GetWide()-64, 60, 64, 2)
		surface.DrawTexturedRectRotated(32, GUI_Donate_Frame:GetTall()-1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Donate_Frame:GetWide()-64, GUI_Donate_Frame:GetTall()-2, 64, 2)

		local logo_l = Material("gui/cybr_L.png")
		local logo_r = Material("gui/cybr_R.png")

		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial( logo_l )
		surface.DrawTexturedRect( 10, 0, 64, 64)
		surface.SetMaterial( logo_r )
		surface.DrawTexturedRect( 74, 0, 64, 64)

	end		
	
	GUI_Donate_Frame:MakePopup()
	GUI_Donate_Frame:ShowCloseButton(false)
	
	local PropertySheet = vgui.Create("DVerticalPropertySheet", GUI_Donate_Frame);
	PropertySheet:SetPos(10, 40);
	PropertySheet:SetSize(GUI_Donate_Frame:GetWide() - 20, GUI_Donate_Frame:GetTall() - 50);
	PropertySheet.Paint = function() 
								end	
	
	local PanelSizeX = 746
	local PanelSizeY = 515
	local PanelPosX = 22
	local PanelPosY = 22
	
	GUI_Shop_tab_Panel = vgui.Create("DPanel")
	GUI_Shop_tab_Panel:SetParent(PropertySheet)
	GUI_Shop_tab_Panel:SetSize(PanelSizeX,PanelSizeY)
	GUI_Shop_tab_Panel:SetPos(PanelPosX,PanelPosY)
	GUI_Shop_tab_Panel.Paint = function()
								end
								
	GUI_Perk_tab_Panel = vgui.Create("DPanel")
	GUI_Perk_tab_Panel:SetParent(PropertySheet)
	GUI_Perk_tab_Panel:SetSize(PanelSizeX,PanelSizeY)
	GUI_Perk_tab_Panel:SetPos(PanelPosX,PanelPosY)
	GUI_Perk_tab_Panel.Paint = function()
								end											
	
	GUI_Ammo_tab_Panel = vgui.Create("DPanel")
	GUI_Ammo_tab_Panel:SetParent(PropertySheet)
	GUI_Ammo_tab_Panel:SetSize(PanelSizeX,PanelSizeY)
	GUI_Ammo_tab_Panel:SetPos(PanelPosX,PanelPosY)
	GUI_Ammo_tab_Panel.Paint = function()
								end		
						
								
	PropertySheet:AddSheet("Shop", GUI_Shop_tab_Panel, "cyb_mat/cyb_weapon.png", true, true, "Buyable Weapons.");
	PropertySheet:AddSheet("Character Perks", GUI_Perk_tab_Panel, "cyb_mat/cyb_perks.png", true, true, "Credit store.");
	PropertySheet:AddSheet("Ammo", GUI_Ammo_tab_Panel, "cyb_mat/cyb_bullet.png", true, true, "Credit store.");
	
		local GUI_MainMenu_DonateButtonText = vgui.Create("DButton", GUI_Donate_Frame)
	GUI_MainMenu_DonateButtonText:SetColor(Color(255,255,255,255))
	GUI_MainMenu_DonateButtonText:SetFont("Cyb_Inv_Bar")
	GUI_MainMenu_DonateButtonText:SetText("Click here to help the server by purchasing VIP, credits and more!")
	GUI_MainMenu_DonateButtonText.Paint = function() end
	GUI_MainMenu_DonateButtonText:SetSize(390,32)
	GUI_MainMenu_DonateButtonText:SetPos(GUI_Donate_Frame:GetWide()/2-GUI_MainMenu_DonateButtonText:GetWide()/2, 34)
	GUI_MainMenu_DonateButtonText.DoClick = function() if GUI_Donate_Frame:IsValid() then GUI_Donate_Frame:Close() end gui.OpenURL("http://cybergmod.net/pages/upgrades/") end

	local GUI_MainMenu_DonateButton = vgui.Create("DImageButton", GUI_Donate_Frame)
	GUI_MainMenu_DonateButton:SetColor(Color(255,255,255,255))
	GUI_MainMenu_DonateButton:SetFont("Cyb_Inv_Bar")
	GUI_MainMenu_DonateButton:SetImage("icon16/heart.png")
	GUI_MainMenu_DonateButton.Paint = function() end
	GUI_MainMenu_DonateButton:SetSize(16,16)
	GUI_MainMenu_DonateButton:SetPos(GUI_Donate_Frame:GetWide()/2-GUI_MainMenu_DonateButtonText:GetWide()/2-15, 42)
	GUI_MainMenu_DonateButton.DoClick = function() if GUI_Donate_Frame:IsValid() then GUI_Donate_Frame:Close() end gui.OpenURL("http://cybergmod.net/pages/upgrades/") end
	
	local GUI_MainMenu_DonateButton = vgui.Create("DImageButton", GUI_Donate_Frame)
	GUI_MainMenu_DonateButton:SetColor(Color(255,255,255,255))
	GUI_MainMenu_DonateButton:SetFont("Cyb_Inv_Bar")
	GUI_MainMenu_DonateButton:SetImage("icon16/heart.png")
	GUI_MainMenu_DonateButton.Paint = function() end
	GUI_MainMenu_DonateButton:SetSize(16,16)
	GUI_MainMenu_DonateButton:SetPos(GUI_Donate_Frame:GetWide()/2+GUI_MainMenu_DonateButtonText:GetWide()/2, 42)
	GUI_MainMenu_DonateButton.DoClick = function() if GUI_Donate_Frame:IsValid() then GUI_Donate_Frame:Close() end gui.OpenURL("http://cybergmod.net/pages/upgrades/") end

	
	local GUI_MainMenu_CloseButton = vgui.Create("DButton", GUI_Donate_Frame)
	GUI_MainMenu_CloseButton:SetColor(Color(255,255,255,255))
	GUI_MainMenu_CloseButton:SetFont("Cyb_Inv_Bar")
	GUI_MainMenu_CloseButton:SetText("X")
	GUI_MainMenu_CloseButton.Paint = function() end
	GUI_MainMenu_CloseButton:SetSize(32,32)
	GUI_MainMenu_CloseButton:SetPos(GUI_Donate_Frame:GetWide()-80, 0)
	GUI_MainMenu_CloseButton.DoClick = function() if GUI_Donate_Frame:IsValid() then GUI_Donate_Frame:Close() end end

	
	GUI_Rebuild_Shop(GUI_Shop_tab_Panel)
	GUI_Rebuild_Perks(GUI_Perk_tab_Panel)	
	GUI_Rebuild_Ammo(GUI_Ammo_tab_Panel)	

end
net.Receive( "net_DonatorMenu", DonatorMenu );

function GUI_Rebuild_Shop(parent)
	if GUI_Wep_Panel_List != nil && GUI_Wep_Panel_List:IsValid() then
		GUI_Wep_Panel_List:Clear()
	else

		GUI_Wep_Panel_List = vgui.Create("DPanelList", parent)
		GUI_Wep_Panel_List:SetSize(745,495)
		GUI_Wep_Panel_List:SetPos(0,40)
		GUI_Wep_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Wep_Panel_List:GetWide(),GUI_Wep_Panel_List:GetTall(),Color( 30, 30, 30, 0 ))
									end
		GUI_Wep_Panel_List:SetPadding(7.5)
		GUI_Wep_Panel_List:SetSpacing(2)
		GUI_Wep_Panel_List:EnableHorizontal(3)
		GUI_Wep_Panel_List:EnableVerticalScrollbar(true)
		
		GUI_Rebuild_Shop_Items(GUI_Wep_Panel_List, "shop_buy")		
		

	end
end

function GUI_Rebuild_Perks(parent)
	if GUI_Perk_Panel_List != nil && GUI_Perk_Panel_List:IsValid() then
		GUI_Perk_Panel_List:Clear()
	else

		GUI_Perk_Panel_List = vgui.Create("DPanelList", parent)
		GUI_Perk_Panel_List:SetSize(745,495)
		GUI_Perk_Panel_List:SetPos(0,40)
		GUI_Perk_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Perk_Panel_List:GetWide(),GUI_Perk_Panel_List:GetTall(),Color( 30, 30, 30, 0 ))
									end
		GUI_Perk_Panel_List:SetPadding(7.5)
		GUI_Perk_Panel_List:SetSpacing(2)
		GUI_Perk_Panel_List:EnableHorizontal(3)
		GUI_Perk_Panel_List:EnableVerticalScrollbar(true)
		
		GUI_Rebuild_Shop_Items(GUI_Perk_Panel_List, "shop_perks")	
	end
end

function GUI_Rebuild_Ammo(parent)
	if GUI_Ammo_Panel_List != nil && GUI_Ammo_Panel_List:IsValid() then
		GUI_Ammo_Panel_List:Clear()
	else

		GUI_Ammo_Panel_List = vgui.Create("DPanelList", parent)
		GUI_Ammo_Panel_List:SetSize(745,495)
		GUI_Ammo_Panel_List:SetPos(0,40)
		GUI_Ammo_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Ammo_Panel_List:GetWide(),GUI_Ammo_Panel_List:GetTall(),Color( 30, 30, 30, 0 ))
									end
		GUI_Ammo_Panel_List:SetPadding(7.5)
		GUI_Ammo_Panel_List:SetSpacing(2)
		GUI_Ammo_Panel_List:EnableHorizontal(3)
		GUI_Ammo_Panel_List:EnableVerticalScrollbar(true)
		
		GUI_Rebuild_Shop_Items(GUI_Ammo_Panel_List, "shop_ammo")	
	end
end