local vgui = vgui
local draw = draw
local surface = surface
local gradient = Material("gui/gradient")

Local_Bank = Local_Bank or {}

net.Receive("UpdateBankFull", function(len)
	Local_Bank = net.ReadTable()
end)

net.Receive("UpdateBank", function(len)
	local item = net.ReadUInt(16)
	local amt = net.ReadFloat()
	Local_Bank[item] = amt
end)

net.Receive("UpdateBankWeight", function(len)
	TotalBankWeight = math.Round(net.ReadFloat(), 1)
end)

function GUI_Bank_Menu()
	if GUI_Bank_Frame != nil && GUI_Bank_Frame:IsValid() then GUI_Bank_Frame:Remove() end
	GUI_Bank_Frame = vgui.Create("DFrame")
	GUI_Bank_Frame:SetSize(800,575)
	GUI_Bank_Frame:MakePopup()
	GUI_Bank_Frame:SetTitle("")
	GUI_Bank_Frame:Center()	
	GUI_Bank_Frame.Paint = function()

		surface.SetDrawColor(0,0,0,145)
		surface.DrawRect(64,0, GUI_Bank_Frame:GetWide()-128, GUI_Bank_Frame:GetWide()-2,GUI_Bank_Frame:GetTall())


		surface.SetMaterial( gradient )
		surface.DrawTexturedRect(GUI_Bank_Frame:GetWide() -64, 0, 64, GUI_Bank_Frame:GetTall())
		surface.DrawTexturedRectRotated(32, GUI_Bank_Frame:GetTall() /2, 64, GUI_Bank_Frame:GetTall(), 180)


		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect(64,0,GUI_Bank_Frame:GetWide()-128,2)
		surface.DrawRect(64,GUI_Bank_Frame:GetTall() -2,GUI_Bank_Frame:GetWide()-128,2)
		surface.DrawTexturedRectRotated(32, 1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Bank_Frame:GetWide()-64, 0, 64, 2)
		surface.DrawTexturedRectRotated(32, GUI_Bank_Frame:GetTall()-1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Bank_Frame:GetWide()-64, GUI_Bank_Frame:GetTall()-2, 64, 2)
		
		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect(64,60,GUI_Bank_Frame:GetWide()-128,2)
		surface.DrawRect(64,GUI_Bank_Frame:GetTall() -2,GUI_Bank_Frame:GetWide()-128,2)
		surface.DrawTexturedRectRotated(32, 61, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Bank_Frame:GetWide()-64, 60, 64, 2)
		surface.DrawTexturedRectRotated(32, GUI_Bank_Frame:GetTall()-1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Bank_Frame:GetWide()-64, GUI_Bank_Frame:GetTall()-2, 64, 2)

		local logo_l = Material("gui/cybr_L.png")
		local logo_r = Material("gui/cybr_R.png")

		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial( logo_l )
		surface.DrawTexturedRect( 10, 0, 64, 64)
		surface.SetMaterial( logo_r )
		surface.DrawTexturedRect( 74, 0, 64, 64)
															
	end
	GUI_Bank_Frame:MakePopup()
	GUI_Bank_Frame:ShowCloseButton(false)
	
	local GUI_MainMenu_CloseButton = vgui.Create("DButton", GUI_Bank_Frame)
	GUI_MainMenu_CloseButton:SetColor(Color(255,255,255,255))
	GUI_MainMenu_CloseButton:SetFont("Cyb_Inv_Bar")
	GUI_MainMenu_CloseButton:SetText("X")
	GUI_MainMenu_CloseButton.Paint = function() end
	GUI_MainMenu_CloseButton:SetSize(32,32)
	GUI_MainMenu_CloseButton:SetPos(GUI_Bank_Frame:GetWide()-80, 0)
	GUI_MainMenu_CloseButton.DoClick = function() if GUI_Bank_Frame:IsValid() then GUI_Bank_Frame:Close() end end

							
	GUI_Inv_Panel_List = vgui.Create("DPanelList", GUI_Bank_Frame)
	GUI_Inv_Panel_List:SetSize(390,440)
	GUI_Inv_Panel_List:SetPos(10,65)
	GUI_Inv_Panel_List.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Inv_Panel_List:GetWide(),GUI_Inv_Panel_List:GetTall(),Color( 30, 30, 30, 0 ))
								end
								
	local GUI_YourInv_Label_toggle = vgui.Create("DLabel")
	GUI_YourInv_Label_toggle:SetColor(Color(255,255,255,255))
	GUI_YourInv_Label_toggle:SetText("Your Backpack")
	GUI_YourInv_Label_toggle:SetPos(152,42)
	GUI_YourInv_Label_toggle:SetFont("Cyb_Inv_Bar")
	GUI_YourInv_Label_toggle:SizeToContents()
	GUI_YourInv_Label_toggle:SetParent(GUI_Bank_Frame)

	local GUI_BankInv_Label_toggle = vgui.Create("DLabel")
	GUI_BankInv_Label_toggle:SetColor(Color(255,255,255,255))
	GUI_BankInv_Label_toggle:SetText("Your Bank")
	GUI_BankInv_Label_toggle:SetPos(557,42)
	GUI_BankInv_Label_toggle:SetFont("Cyb_Inv_Bar")
	GUI_BankInv_Label_toggle:SizeToContents()
	GUI_BankInv_Label_toggle:SetParent(GUI_Bank_Frame)				

	
	GUI_Inv_Panel_List:SetPadding(7.5)
	GUI_Inv_Panel_List:SetSpacing(2)
	GUI_Inv_Panel_List:EnableHorizontal(3)
	GUI_Inv_Panel_List:EnableVerticalScrollbar(true)
	
	GUI_Bank_Panel_List = vgui.Create("DPanelList", GUI_Bank_Frame)
	GUI_Bank_Panel_List:SetSize(390,440)
	GUI_Bank_Panel_List:SetPos(400,65)
	GUI_Bank_Panel_List.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Bank_Panel_List:GetWide(),GUI_Bank_Panel_List:GetTall(),Color( 30, 30, 30, 0 ))
								end
	GUI_Bank_Panel_List:SetPadding(7.5)
	GUI_Bank_Panel_List:SetSpacing(2)
	GUI_Bank_Panel_List:EnableHorizontal(3)
	GUI_Bank_Panel_List:EnableVerticalScrollbar(true)	

	----------------------------------
	if !IsValid(Inv_Icon_ent) then
		Inv_Icon_ent = ents.CreateClientProp("prop_physics")
		Inv_Icon_ent:SetPos(Vector(0,0,-500))
		Inv_Icon_ent:SetNoDraw(true)
		Inv_Icon_ent:Spawn()
		Inv_Icon_ent:Activate()	
	end

	for item,amount in pairs(Local_Inventory) do
		if amount > 0  then
			local GUI_Inv_Item_Panel = vgui.Create("DPanel", GUI_Inv_Panel_List)
			GUI_Inv_Item_Panel:SetSize(120,120)
			GUI_Inv_Item_Panel:SetPos(0,0)
			GUI_Inv_Item_Panel.Paint = function(self)

				draw.RoundedBoxEx(4,0,0,GUI_Inv_Item_Panel:GetWide(),GUI_Inv_Item_Panel:GetTall(),Color( 255, 255, 255, 255 ), true, true, true, true)
				draw.RoundedBoxEx(4,1,1,GUI_Inv_Item_Panel:GetWide()-2,GUI_Inv_Item_Panel:GetTall()-2,Color( 0, 0, 0, 255 ), true, true, true, true) 

				local spotlight = Material("gui/spotlight.png")
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial( spotlight)
				surface.DrawTexturedRect(0, 0, 128,128)	
			end

				local GUI_Inv_Item_Icon = vgui.Create("DModelPanel")
				GUI_Inv_Item_Icon:SetParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_Icon:SetPos(0,0)
				GUI_Inv_Item_Icon:SetSize(120,120)
				local PaintModel = GUI_Inv_Item_Icon.Paint
				function GUI_Inv_Item_Icon:Paint()
					local x2, y2 = GUI_Inv_Panel_List:LocalToScreen( 0, 0 )
					local w2, h2 = GUI_Inv_Panel_List:GetSize()
					render.SetScissorRect( x2, y2, x2 + w2, y2 + h2, true )

					PaintModel( self )
					
					render.SetScissorRect( 0, 0, 0, 0, false )

				end
				GUI_Inv_Item_Panel.ModelPanel = GUI_Inv_Item_Icon


				GUI_Inv_Item_Icon:SetModel(GAMEMODE.DayZ_Items[item].Model)
				
				GUI_Inv_Item_Icon:SetColor(GAMEMODE.DayZ_Items[item].Color or Color(255,255,255,255))
				Inv_Icon_ent:SetModel(GAMEMODE.DayZ_Items[item].Model)
				
				if GAMEMODE.DayZ_Items[item].Angle != nil then
					GUI_Inv_Item_Icon:GetEntity():SetAngles(GAMEMODE.DayZ_Items[item].Angle)
				end
				
				local center = Inv_Icon_ent:OBBCenter()
				local dist = Inv_Icon_ent:BoundingRadius()*1.2
				GUI_Inv_Item_Icon:SetLookAt(center)
				GUI_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	


			GUI_Inv_Item_Icon.DoClick = function()
				RunConsoleCommand("DepositItem",item,1)
				timer.Simple( 0.3, function() GUI_Bank_Frame:Remove() GUI_Bank_Menu() end)
			end

			GUI_Inv_Item_Icon.DoRightClick = function()
				ItemMENU = DermaMenu()

				local amts = {1, 5, 10, 25, 50, 100}
				for k, v in ipairs(amts) do
					ItemMENU:AddOption("Deposit "..v, 	function()
						RunConsoleCommand("DepositItem",item,v)
						timer.Simple( 0.3, function() GUI_Bank_Frame:Remove() GUI_Bank_Menu() end)
					end )
				end

				ItemMENU:AddOption("Deposit All", 	function()
					RunConsoleCommand("DepositItem",item,amount)
					timer.Simple( 0.3, function() GUI_Bank_Frame:Remove() GUI_Bank_Menu() end)
				end)

				ItemMENU:AddOption("Deposit X", function()
					GUI_Deposit_Amount_Popup(item)
				end)

				ItemMENU:Open(gui.MousePos())
			end	
								
			local GUI_Inv_Item_Name = vgui.Create("DLabel")
			GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
			GUI_Inv_Item_Name:SetText(GAMEMODE.DayZ_Items[item].Name)
			GUI_Inv_Item_Name:SizeToContents()
			GUI_Inv_Item_Name:SetParent(GUI_Inv_Item_Panel)
			local x,y = surface.GetTextSize(" "..GAMEMODE.DayZ_Items[item].Name.." ")
			--GUI_Inv_Item_Name:SetPos(100 - x/2,10-y/2)
			GUI_Inv_Item_Name:SetPos(5,5)
			if amount > 0 then
				local GUI_Inv_Item_Amt = vgui.Create("DLabel")
				GUI_Inv_Item_Amt:SetColor(Color(255,255,255,255))
				GUI_Inv_Item_Amt:SetText("Quantity: "..amount)
				GUI_Inv_Item_Amt:SizeToContents()
				GUI_Inv_Item_Amt:SetParent(GUI_Inv_Item_Panel)
				local x,y = surface.GetTextSize("Quantity: "..amount)
				--GUI_Inv_Item_Amt:SetPos(100 - x/2,25-y/2)
				GUI_Inv_Item_Amt:SetPos(5,20)				
			end
			GUI_Inv_Panel_List:AddItem(GUI_Inv_Item_Panel)
		end
	end
	----------------------------------							
	if !IsValid(Inv_Icon_ent) then
		Inv_Icon_ent = ents.CreateClientProp("prop_physics")
		Inv_Icon_ent:SetPos(Vector(0,0,-500))
		Inv_Icon_ent:SetNoDraw(true)
		Inv_Icon_ent:Spawn()
		Inv_Icon_ent:Activate()	
	end

	for item,amount in pairs(Local_Bank) do
		if amount > 0  then
			local B_GUI_Inv_Item_Panel = vgui.Create("DPanel")
			B_GUI_Inv_Item_Panel:SetParent(GUI_Bank_Panel_List)
			B_GUI_Inv_Item_Panel:SetSize(120,120)
			B_GUI_Inv_Item_Panel:SetPos(0,0)
			B_GUI_Inv_Item_Panel.Paint = function(self)

				draw.RoundedBoxEx(4,0,0,B_GUI_Inv_Item_Panel:GetWide(),B_GUI_Inv_Item_Panel:GetTall(),Color( 255, 255, 255, 255 ), true, true, true, true)
				draw.RoundedBoxEx(4,1,1,B_GUI_Inv_Item_Panel:GetWide()-2,B_GUI_Inv_Item_Panel:GetTall()-2,Color( 0, 0, 0, 255 ), true, true, true, true) 

				local spotlight = Material("gui/spotlight.png")
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial( spotlight)
				surface.DrawTexturedRect(0, 0, 128,128)	
			end
			local B_GUI_Inv_Item_Icon = vgui.Create("DModelPanel")
			B_GUI_Inv_Item_Panel.ModelPanel = B_GUI_Inv_Item_Icon
			B_GUI_Inv_Item_Icon:SetParent(B_GUI_Inv_Item_Panel)
			B_GUI_Inv_Item_Icon:SetPos(10,10)
			B_GUI_Inv_Item_Icon:SetSize(100,100)
			B_GUI_Inv_Item_Icon:SetModel(GAMEMODE.DayZ_Items[item].Model)
			Inv_Icon_ent:SetModel(GAMEMODE.DayZ_Items[item].Model)

			B_GUI_Inv_Item_Icon:SetColor(GAMEMODE.DayZ_Items[item].Color or Color(255, 255, 255))
			
			local center = Inv_Icon_ent:OBBCenter()
			local dist = Inv_Icon_ent:BoundingRadius()*1.2
			B_GUI_Inv_Item_Icon:SetLookAt(center)
			B_GUI_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0) + (GAMEMODE.DayZ_Items[item].Pos or Vector(0, 0, 0)))
			local PaintModel = B_GUI_Inv_Item_Icon.Paint
			function B_GUI_Inv_Item_Icon:Paint()
				local x2, y2 = self:GetParent():GetParent():GetParent():LocalToScreen( 0, 0 )
				local w2, h2 = self:GetParent():GetParent():GetParent():GetSize()
				render.SetScissorRect( x2, y2, x2 + w2, y2 + h2, true )

				PaintModel( self )
				
				render.SetScissorRect( 0, 0, 0, 0, false )

			end
			B_GUI_Inv_Item_Icon.DoClick = function()
				RunConsoleCommand("WithdrawItem",item,1)
				timer.Simple( 0.3, function() GUI_Bank_Frame:Remove() GUI_Bank_Menu() end)
			end

			B_GUI_Inv_Item_Icon.DoRightClick = function()
				ItemMENU = DermaMenu()

				local amts = {1, 5, 10, 25, 50, 100}
				for k, v in ipairs(amts) do
					ItemMENU:AddOption("Withdraw "..v, 	function()
						RunConsoleCommand("WithdrawItem",item,v)
						timer.Simple( 0.3, function() GUI_Bank_Frame:Remove() GUI_Bank_Menu() end)
					end )
				end

				ItemMENU:AddOption("Withdraw All", 	function()
					RunConsoleCommand("WithdrawItem",item,amount)
					timer.Simple( 0.3, function() GUI_Bank_Frame:Remove() GUI_Bank_Menu() end)
				end)

				ItemMENU:AddOption("Withdraw X", function()
					GUI_Withdraw_Amount_Popup(item)
				end)

				ItemMENU:Open(gui.MousePos())
			end

			local B_GUI_Inv_Item_Name = vgui.Create("DLabel")
			B_GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
			B_GUI_Inv_Item_Name:SetText(GAMEMODE.DayZ_Items[item].Name)
			B_GUI_Inv_Item_Name:SizeToContents()
			B_GUI_Inv_Item_Name:SetParent(B_GUI_Inv_Item_Panel)
			local x,y = surface.GetTextSize(GAMEMODE.DayZ_Items[item].Name)
			--B_GUI_Inv_Item_Name:SetPos(100 - x/2,10-y/2)
			B_GUI_Inv_Item_Name:SetPos(5,5)			
			if amount > 0 then
				local B_GUI_Inv_Item_Amt = vgui.Create("DLabel")
				B_GUI_Inv_Item_Amt:SetColor(Color(255,255,255,255))
				B_GUI_Inv_Item_Amt:SetText("Quantity: "..amount)
				B_GUI_Inv_Item_Amt:SizeToContents()
				B_GUI_Inv_Item_Amt:SetParent(B_GUI_Inv_Item_Panel)
				local x,y = surface.GetTextSize("Quantity: "..amount)
				--B_GUI_Inv_Item_Amt:SetPos(100 - x/2,25-y/2)
				B_GUI_Inv_Item_Amt:SetPos(5,20)
			end
			GUI_Bank_Panel_List:AddItem(B_GUI_Inv_Item_Panel)
		end
	end

	GUI_Bank_Inv_Weight_Bar = vgui.Create("DPanelList", GUI_Bank_Frame)
	GUI_Bank_Inv_Weight_Bar:SetSize(750,25)
	GUI_Bank_Inv_Weight_Bar:SetPos(0,520)
	GUI_Bank_Inv_Weight_Bar.Paint = function()
		if TotalWeight then
			if LocalPlayer():GetNWBool("Perk2") == true then
				draw.RoundedBoxEx(4, 20 ,0, GUI_Bank_Inv_Weight_Bar:GetWide() /2, GUI_Bank_Inv_Weight_Bar:GetTall(), Color(255,255,255,255), true, true, true, true)
				draw.RoundedBoxEx(4, 20 +1 ,1, GUI_Bank_Inv_Weight_Bar:GetWide() /2 -2, GUI_Bank_Inv_Weight_Bar:GetTall() -2, Color(40,40,40,255), true, true, true, true)
				draw.RoundedBoxEx(4, 20 +1 ,1, (GUI_Bank_Inv_Weight_Bar:GetWide()/2-4)*(TotalWeight/200), GUI_Bank_Inv_Weight_Bar:GetTall() -2, Color(12,75,129,255), true, true, true, true)
				draw.RoundedBoxEx(4, 20 +1 ,1, (GUI_Bank_Inv_Weight_Bar:GetWide()/2-4)*(TotalWeight/200), GUI_Bank_Inv_Weight_Bar:GetTall()/2 -2, Color(59,138,206,255), true, true, false, false)
				draw.DrawText("WEIGHT:", "Cyb_Inv_Bar", 20+10, GUI_Bank_Inv_Weight_Bar:GetTall()-22, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(TotalWeight.."/200", "Cyb_Inv_Bar", GUI_Bank_Inv_Weight_Bar:GetWide()/2, GUI_Bank_Inv_Weight_Bar:GetTall()-22, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)									
			else
				draw.RoundedBoxEx(4, 20 ,0, GUI_Bank_Inv_Weight_Bar:GetWide() /2, GUI_Bank_Inv_Weight_Bar:GetTall(), Color(255,255,255,255), true, true, true, true)
				draw.RoundedBoxEx(4, 20 +1 ,1, GUI_Bank_Inv_Weight_Bar:GetWide() /2 -2, GUI_Bank_Inv_Weight_Bar:GetTall() -2, Color(40,40,40,255), true, true, true, true)
				draw.RoundedBoxEx(4, 20 +1 ,1, (GUI_Bank_Inv_Weight_Bar:GetWide()/2-4)*(TotalWeight/100), GUI_Bank_Inv_Weight_Bar:GetTall() -2, Color(12,75,129,255), true, true, true, true)
				draw.RoundedBoxEx(4, 20 +1 ,1, (GUI_Bank_Inv_Weight_Bar:GetWide()/2-4)*(TotalWeight/100), GUI_Bank_Inv_Weight_Bar:GetTall()/2 -2, Color(59,138,206,255), true, true, false, false)
				draw.DrawText("WEIGHT:", "Cyb_Inv_Bar", 20+10, GUI_Bank_Inv_Weight_Bar:GetTall()-22, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(TotalWeight.."/100", "Cyb_Inv_Bar", GUI_Bank_Inv_Weight_Bar:GetWide()/2, GUI_Bank_Inv_Weight_Bar:GetTall()-22, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
			end
		end
	end
	GUI_Bank_Inv_Weight_Bar:SetPadding(7.5)
	GUI_Bank_Inv_Weight_Bar:SetSpacing(2)
	GUI_Bank_Inv_Weight_Bar:EnableHorizontal(3)
	GUI_Bank_Inv_Weight_Bar:EnableVerticalScrollbar(true)

	
	--[[ GUI_Bank_Inv_Weight_Bar = vgui.Create("DPanel", GUI_Bank_Frame)
	GUI_Bank_Inv_Weight_Bar:SetSize(390,20)
	GUI_Bank_Inv_Weight_Bar:SetPos(0,490)
	GUI_Bank_Inv_Weight_Bar.Paint = function()
		if TotalWeight then
				draw.RoundedBox(6,GUI_Bank_Inv_Weight_Bar:GetWide()/4,GUI_Bank_Inv_Weight_Bar:GetTall()-21,GUI_Bank_Inv_Weight_Bar:GetWide()/2,20,Color( 60, 60, 60, 155 ))
				draw.RoundedBox(6,GUI_Bank_Inv_Weight_Bar:GetWide()/4+3,GUI_Bank_Inv_Weight_Bar:GetTall()-18,(GUI_Bank_Inv_Weight_Bar:GetWide()/2-21)*(TotalWeight/200)+15,14,Color( 90, 80, 70, 155 ))
				draw.DrawText("Weight: "..TotalWeight.." / "..(LocalPlayer():GetNWBool("Perk2") and 200 or 100), "Trebuchet18", GUI_Bank_Inv_Weight_Bar:GetWide()/2, GUI_Bank_Inv_Weight_Bar:GetTall()-19, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)										
		end
	end ]]
--[[ 
	GUI_Bank_Weight_Bar = vgui.Create("DPanel", GUI_Bank_Frame)
	GUI_Bank_Weight_Bar:SetSize(390,20)
	GUI_Bank_Weight_Bar:SetPos(400,490)
	GUI_Bank_Weight_Bar.Paint = function()
		if TotalBankWeight then
				draw.RoundedBox(6,GUI_Bank_Weight_Bar:GetWide()/4,GUI_Bank_Weight_Bar:GetTall()-21,GUI_Bank_Weight_Bar:GetWide()/2,20,Color( 60, 60, 60, 155 ))
				draw.RoundedBox(6,GUI_Bank_Weight_Bar:GetWide()/4+3,GUI_Bank_Weight_Bar:GetTall()-18,(GUI_Bank_Weight_Bar:GetWide()/2-21)*(TotalBankWeight/MaxBankWeight[LocalPlayer():GetUserGroup()])+15,14,Color( 90, 80, 70, 155 ))
				draw.DrawText("Weight: "..TotalBankWeight.." / "..MaxBankWeight[LocalPlayer():GetUserGroup()], "Trebuchet18", GUI_Bank_Weight_Bar:GetWide()/2, GUI_Bank_Weight_Bar:GetTall()-19, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)										
		end
	end ]]
	
	GUI_Bank_Weight_Bar = vgui.Create("DPanelList", GUI_Bank_Frame)
	GUI_Bank_Weight_Bar:SetSize(750,25)
	GUI_Bank_Weight_Bar:SetPos(390,520)
	GUI_Bank_Weight_Bar.Paint = function()
		if TotalWeight then
			draw.RoundedBoxEx(4, 20 ,0, GUI_Bank_Inv_Weight_Bar:GetWide() /2, GUI_Bank_Inv_Weight_Bar:GetTall(), Color(255,255,255,255), true, true, true, true)
			draw.RoundedBoxEx(4, 20 +1 ,1, GUI_Bank_Inv_Weight_Bar:GetWide() /2 -2, GUI_Bank_Inv_Weight_Bar:GetTall() -2, Color(40,40,40,255), true, true, true, true)
			draw.RoundedBoxEx(4, 20 +1 ,1, (GUI_Bank_Inv_Weight_Bar:GetWide()/2-4)*(TotalBankWeight/(MaxBankWeight[LocalPlayer():GetUserGroup()]+LocalPlayer():GetNWInt("extraslots"))), GUI_Bank_Inv_Weight_Bar:GetTall() -2, Color(12,75,129,255), true, true, true, true)
			draw.RoundedBoxEx(4, 20 +1 ,1, (GUI_Bank_Inv_Weight_Bar:GetWide()/2-4)*(TotalBankWeight/(MaxBankWeight[LocalPlayer():GetUserGroup()]+LocalPlayer():GetNWInt("extraslots"))), GUI_Bank_Inv_Weight_Bar:GetTall()/2 -2, Color(59,138,206,255), true, true, false, false)
			draw.DrawText("WEIGHT:", "Cyb_Inv_Bar", 20+10, GUI_Bank_Inv_Weight_Bar:GetTall()-22, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
			draw.DrawText(TotalBankWeight.."/"..(MaxBankWeight[LocalPlayer():GetUserGroup()]+LocalPlayer():GetNWInt("extraslots")), "Cyb_Inv_Bar", GUI_Bank_Inv_Weight_Bar:GetWide()/2, GUI_Bank_Inv_Weight_Bar:GetTall()-22, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
		end
	end
	GUI_Bank_Weight_Bar:SetPadding(7.5)
	GUI_Bank_Weight_Bar:SetSpacing(2)
	GUI_Bank_Weight_Bar:EnableHorizontal(3)
	GUI_Bank_Weight_Bar:EnableVerticalScrollbar(true)
	
end
net.Receive( "net_BankMenu", GUI_Bank_Menu );

function GUI_Deposit_Amount_Popup(item)
	if GUI_Amount_Frame != nil && GUI_Amount_Frame:IsValid() then GUI_Amount_Frame:Remove() end
	GUI_Amount_Frame = vgui.Create("DFrame")
	GUI_Amount_Frame:Center()
	GUI_Amount_Frame:SetSize(200,100)
	GUI_Amount_Frame:MakePopup()
	GUI_Amount_Frame:SetTitle("Amount")
	GUI_Amount_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Amount_Frame:GetWide()-2,GUI_Amount_Frame:GetTall()-2,Color( 46, 36, 26, 255 ))
							end
	local GUI_Amount_slider = vgui.Create("DNumSlider", GUI_Amount_Frame)
	--GUI_Amount_slider:SetParent(GUI_Amount_Frame)
	GUI_Amount_slider:SetWide(270)
	GUI_Amount_slider:SetPos(-80,25)
	GUI_Amount_slider:SetText("")
	GUI_Amount_slider:SetMin(1)
	GUI_Amount_slider:SetMax(Local_Inventory[item])
	GUI_Amount_slider:SetDecimals(0)
	GUI_Amount_slider:SetValue(1)	
	
	local GUI_Drop_Button = vgui.Create("DButton")
	GUI_Drop_Button:SetParent(GUI_Amount_Frame)
	GUI_Drop_Button:SetPos(10,70)
	GUI_Drop_Button:SetSize(180,15)
	GUI_Drop_Button:SetText("")
	GUI_Drop_Button.Paint = function()
							draw.RoundedBox(4,0,0,GUI_Drop_Button:GetWide(),GUI_Drop_Button:GetTall(),Color( 0, 0, 0, 255 ))
							draw.RoundedBox(4,1,1,GUI_Drop_Button:GetWide()-2,GUI_Drop_Button:GetTall()-2,Color( 139, 133, 97, 55))
											
							local struc = {}
							struc.pos = {}
							struc.pos[1] = 90 -- x pos
							struc.pos[2] = 7 -- y pos
							struc.color = Color(255,255,255,255) -- Red
							struc.text = "Confirm" -- Text
							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
							draw.Text( struc )
							end
										
	GUI_Drop_Button.DoClick = function()
								RunConsoleCommand("DepositItem",item,GUI_Amount_slider:GetValue())
								GUI_Amount_Frame:Remove()
								timer.Simple( 0.5, function()
								GUI_Bank_Frame:Remove()
								GUI_Bank_Menu()
								end)
							end
end

function GUI_Withdraw_Amount_Popup(item)
	if GUI_Amount_Frame != nil && GUI_Amount_Frame:IsValid() then GUI_Amount_Frame:Remove() end
	GUI_Amount_Frame = vgui.Create("DFrame")
	GUI_Amount_Frame:Center()
	GUI_Amount_Frame:SetSize(200,100)
	GUI_Amount_Frame:MakePopup()
	GUI_Amount_Frame:SetTitle("Amount")
	GUI_Amount_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Amount_Frame:GetWide()-2,GUI_Amount_Frame:GetTall()-2,Color( 46, 36, 26, 255 ))
							end
	local GUI_Amount_slider = vgui.Create("DNumSlider", GUI_Amount_Frame)
	--GUI_Amount_slider:SetParent(GUI_Amount_Frame)
	GUI_Amount_slider:SetWide(270)
	GUI_Amount_slider:SetPos(-80,25)
	GUI_Amount_slider:SetText("")
	GUI_Amount_slider:SetMin(1)
	GUI_Amount_slider:SetMax(Local_Bank[item])
	GUI_Amount_slider:SetDecimals(0)
	GUI_Amount_slider:SetValue(1)	
	
	local GUI_Drop_Button = vgui.Create("DButton")
	GUI_Drop_Button:SetParent(GUI_Amount_Frame)
	GUI_Drop_Button:SetPos(10,70)
	GUI_Drop_Button:SetSize(180,15)
	GUI_Drop_Button:SetText("")
	GUI_Drop_Button.Paint = function()
							draw.RoundedBox(4,0,0,GUI_Drop_Button:GetWide(),GUI_Drop_Button:GetTall(),Color( 0, 0, 0, 255))
							draw.RoundedBox(4,1,1,GUI_Drop_Button:GetWide()-2,GUI_Drop_Button:GetTall()-2,Color( 139, 133, 97, 55 ))
											
							local struc = {}
							struc.pos = {}
							struc.pos[1] = 90 -- x pos
							struc.pos[2] = 7 -- y pos
							struc.color = Color(255,255,255,255) -- Red
							struc.text = "Confirm" -- Text
							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
							draw.Text( struc )
							end
										
	GUI_Drop_Button.DoClick = function()
								RunConsoleCommand("WithdrawItem",item,GUI_Amount_slider:GetValue())
								GUI_Amount_Frame:Remove()
								timer.Simple( 0.5, function()
								GUI_Bank_Frame:Remove()
								GUI_Bank_Menu()
								end)
							end
end