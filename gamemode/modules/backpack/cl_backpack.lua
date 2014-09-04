local vgui = vgui
local draw = draw
local surface = surface
local gradient = Material("gui/gradient")

Local_Backpack = {}
Local_Backpack_Char = {}

--[[function CL_UpdateBackpack( umsg )
	local item = umsg:ReadString()
	local amount = umsg:ReadFloat()
	Local_Backpack[tostring(item)] = tonumber(amount)
end
usermessage.Hook( "UpdateBackpack", CL_UpdateBackpack );]]

net.Receive("UpdateBackpack", function(len)
	Local_Backpack = net.ReadTable()
end)

net.Receive("UpdateBackpackChar", function(len)
	Local_Backpack_Char = net.ReadTable()
end)

net.Receive("net_CloseLootMenu", function(len)
	if (GUI_Loot_Frame and GUI_Loot_Frame:IsValid()) then
		GUI_Loot_Frame:Remove()
	end
end)

net.Receive("net_LootMenu", function(len)
	local backpack = net.ReadFloat()
	GUI_Loot_Menu(backpack)
end)

function UpdateCharItemsBP(parent, item)	

	if Local_Backpack_Char[item] < 1 then return end
	
	local GUI_Inv_Item_Panel = vgui.Create("DPanelList", parent)
	GUI_Inv_Item_Panel:SetSize(95,95)
	GUI_Inv_Item_Panel:SetPos(5,2)
	GUI_Inv_Item_Panel:SetSpacing(5)
	GUI_Inv_Item_Panel.Paint = function()

		draw.RoundedBoxEx(4,0,0,GUI_Inv_Item_Panel:GetWide(),GUI_Inv_Item_Panel:GetTall(),Color( 255, 255, 255, 255 ), true, true, true, true)
		draw.RoundedBoxEx(4,1,1,GUI_Inv_Item_Panel:GetWide()-2,GUI_Inv_Item_Panel:GetTall()-2,Color( 0, 0, 0, 255 ), true, true, true, true) 

		local spotlight = Material("gui/spotlight.png")
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial( spotlight)
		surface.DrawTexturedRect(0, 0, GUI_Inv_Item_Panel:GetWide()+4,GUI_Inv_Item_Panel:GetTall()+4)	
		
	end

	local GUI_Inv_Item_Icon = vgui.Create("DModelPanel", GUI_Inv_Item_Panel)
	local PaintModel = GUI_Inv_Item_Icon.Paint
	function GUI_Inv_Item_Icon:Paint()
		local x2, y2 = parent:LocalToScreen( 0, 0 )
		local w2, h2 = parent:GetSize()
		render.SetScissorRect( x2, y2, x2 + w2, y2 + h2, true )

		PaintModel( self )
		
		render.SetScissorRect( 0, 0, 0, 0, false )

	end
	--GUI_Inv_Item_Panel.ModelPanel = GUI_Inv_Item_Icon
	GUI_Inv_Item_Icon:SetPos(5,5)
	GUI_Inv_Item_Icon:SetSize(85,85)
	GUI_Inv_Item_Icon:SetDragParent(GUI_Inv_Item_Panel)
	GUI_Inv_Item_Panel:Droppable("invslot")
	GUI_Inv_Item_Panel.ItemClass = item
	GUI_Inv_Item_Panel.Slot = parent
	GUI_Inv_Item_Panel.CharTable = true
	
	GUI_Inv_Item_Icon:SetModel(GAMEMODE.DayZ_Items[item].Model)
	Inv_Icon_ent:SetModel(GAMEMODE.DayZ_Items[item].Model)
	GUI_Inv_Item_Icon:SetColor(GAMEMODE.DayZ_Items[item].Color or Color(255, 255, 255))
	
	if GAMEMODE.DayZ_Items[item].Angle != nil then
		GUI_Inv_Item_Icon:GetEntity():SetAngles(GAMEMODE.DayZ_Items[item].Angle)
	end

	local center = Inv_Icon_ent:OBBCenter()
	local dist = Inv_Icon_ent:BoundingRadius()*1.2
	
	GUI_Inv_Item_Icon:SetLookAt(center)
	GUI_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))

	local GUI_Inv_Item_Name = vgui.Create("DLabel", GUI_Inv_Item_Panel)
	GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
	GUI_Inv_Item_Name:SetText(GAMEMODE.DayZ_Items[item].Name)
	GUI_Inv_Item_Name:SetFont("Cyb_Inv_Label")
	GUI_Inv_Item_Name:SizeToContents()
	GUI_Inv_Item_Icon:SetDragParent(GUI_Inv_Item_Panel)
	
	local x,y = surface.GetTextSize(" "..GAMEMODE.DayZ_Items[item].Name.." ")
	
	GUI_Inv_Item_Name:SetPos(5,5)
	
	if Local_Backpack_Char[item] and Local_Backpack_Char[item] > 0 then
		local GUI_Inv_Item_Amt = vgui.Create("DLabel")
		GUI_Inv_Item_Amt:SetColor(Color(255,255,255,255))
		GUI_Inv_Item_Amt:SetFont("Cyb_Inv_Label")
		GUI_Inv_Item_Amt:SetText(Local_Backpack_Char[item])
		GUI_Inv_Item_Amt:SizeToContents()
		GUI_Inv_Item_Amt:SetParent(GUI_Inv_Item_Panel)
								
		--GUI_Inv_Item_Amt:SetPos(120 - x/2,25-y/2)
		GUI_Inv_Item_Amt:SetPos(5,78)
	end

end

function DoLootItem(item, amount, backpack, char)
	amount = amount or 1
	net.Start( "LootItem" )
		net.WriteString( item )
		net.WriteInt( amount, 32 )
		net.WriteInt( backpack, 32 )
		net.WriteBit( char )
	net.SendToServer()
end

function GUI_Loot_Menu(backpack)	
	
	if GUI_Loot_Frame != nil and GUI_Loot_Frame:IsValid() then
		GUI_Loot_Frame:Remove()
	end

	if GUI_Loot_Frame != nil && GUI_Loot_Frame:IsValid() then GUI_Loot_Frame:Remove() end

	Inv_Icon_ent = ents.CreateClientProp("prop_physics")
	Inv_Icon_ent:SetPos(Vector(0,0,-500))
	Inv_Icon_ent:SetNoDraw(true)
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
	
	GUI_Loot_Frame = vgui.Create("DFrame")
	GUI_Loot_Frame:SetSize(860 ,610)
	GUI_Loot_Frame:MakePopup()
	GUI_Loot_Frame:SetTitle("")
	GUI_Loot_Frame:Center()	
	GUI_Loot_Frame.Paint = function()
		surface.SetDrawColor(0,0,0,145)
		surface.DrawRect(64,0, GUI_Loot_Frame:GetWide()-128, GUI_Loot_Frame:GetWide()-2,GUI_Loot_Frame:GetTall())

		surface.SetMaterial( gradient )
		surface.DrawTexturedRect(GUI_Loot_Frame:GetWide() -64, 0, 64, GUI_Loot_Frame:GetTall())
		surface.DrawTexturedRectRotated(32, GUI_Loot_Frame:GetTall() /2, 64, GUI_Loot_Frame:GetTall(), 180)

		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect(64,0,GUI_Loot_Frame:GetWide()-128,2)
		surface.DrawRect(64,GUI_Loot_Frame:GetTall() -2,GUI_Loot_Frame:GetWide()-128,2)
		surface.DrawTexturedRectRotated(32, 1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Loot_Frame:GetWide()-64, 0, 64, 2)
		surface.DrawTexturedRectRotated(32, GUI_Loot_Frame:GetTall()-1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Loot_Frame:GetWide()-64, GUI_Loot_Frame:GetTall()-2, 64, 2)
		
		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect(64,60,GUI_Loot_Frame:GetWide()-128,2)
		surface.DrawRect(64,GUI_Loot_Frame:GetTall() -2,GUI_Loot_Frame:GetWide()-128,2)
		surface.DrawTexturedRectRotated(32, 61, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Loot_Frame:GetWide()-64, 60, 64, 2)
		surface.DrawTexturedRectRotated(32, GUI_Loot_Frame:GetTall()-1, 64, 2, 180)
		surface.DrawTexturedRect(GUI_Loot_Frame:GetWide()-64, GUI_Loot_Frame:GetTall()-2, 64, 2)

		local logo_l = Material("gui/cybr_L.png")
		local logo_r = Material("gui/cybr_R.png")

		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial( logo_l )
		surface.DrawTexturedRect( 10, 0, 64, 64)
		surface.SetMaterial( logo_r )
		surface.DrawTexturedRect( 74, 0, 64, 64)
	end
	
	if GUI_Inv_Item_Panel != nil and GUI_Inv_Item_Panel:IsValid() then
		GUI_Inv_Item_Panel:Clear()
	end
		
	GUI_Inv_Panel_List = vgui.Create("DPanelList", GUI_Loot_Frame)
	GUI_Inv_Panel_List:SetSize(210,510)
	GUI_Inv_Panel_List:SetPos(60,75)
	GUI_Inv_Panel_List.Paint = function()
		draw.RoundedBox(8,0,0,GUI_Inv_Panel_List:GetWide(),GUI_Inv_Panel_List:GetTall(),Color( 30, 30, 30, 200 ))
	end
	GUI_Inv_Panel_List:SetPadding(7.5)
	GUI_Inv_Panel_List:SetSpacing(2)
	GUI_Inv_Panel_List:EnableHorizontal(3)
	GUI_Inv_Panel_List:EnableVerticalScrollbar(true)
	GUI_Inv_Panel_List:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
    	if ( !dropped ) then return end
		if tbl[1]:GetParent() == GUI_Inv_Panel_List then return end

		tbl[1]:SetSize(60,60)
		tbl[1]:GetChild(1):SetSize(50,50)

		GUI_Inv_Panel_List:AddItem(tbl[1])
		
		if tbl[1].CharTable != nil then
			DoLootItem( tbl[1].ItemClass, Local_Backpack[tbl[1].ItemClass], backpack, true )
		else
			DoLootItem( tbl[1].ItemClass, Local_Backpack[tbl[1].ItemClass], backpack)
		end
		timer.Simple(1, function() if GUI_Loot_Frame:IsValid() then UpdateInv_BP() UpdateInv_BP() if IsValid(tbl[1].Slot) then UpdateCharItemsBP(tbl[1].Slot, tbl[1].ItemClass) end end end)
    end )
	
	GUI_Inv_Panel_List_BP = vgui.Create("DPanelList", GUI_Loot_Frame)
	GUI_Inv_Panel_List_BP:SetSize(210,510)
	GUI_Inv_Panel_List_BP:SetPos(275,75)
	GUI_Inv_Panel_List_BP.Paint = function()
		draw.RoundedBox(8,0,0,GUI_Inv_Panel_List_BP:GetWide(),GUI_Inv_Panel_List_BP:GetTall(),Color( 30, 30, 30, 200 ))
	end
	GUI_Inv_Panel_List_BP:SetPadding(7.5)
	GUI_Inv_Panel_List_BP:SetSpacing(2)
	GUI_Inv_Panel_List_BP:EnableHorizontal(3)
	GUI_Inv_Panel_List_BP:EnableVerticalScrollbar(true)
	
	RightPanel = vgui.Create("DPanelList", GUI_Loot_Frame)
	RightPanel:SetSize(320, 510)
	RightPanel:SetPos(490, 75)
	RightPanel.Paint = function()
		draw.RoundedBox(8,0,0,RightPanel:GetWide(),RightPanel:GetTall(),Color( 30, 30, 30, 100 ))
	end
	
	local PlayerModel = vgui.Create("DModelPanel", RightPanel)
	PlayerModel:SetModel(LocalPlayer():GetModel())
	PlayerModel:SetSize(500,500)
	PlayerModel:SetPos(-100,-30)
	PlayerModel.LayoutEntity = function() end

	CharSlot1 = vgui.Create("DPanel", RightPanel)
	CharSlot1:SetSize(100,100)
	CharSlot1:SetPos(110,70)
	CharSlot1.Paint = function()
		draw.RoundedBox(8,0,0,CharSlot1:GetWide(),CharSlot1:GetTall(),Color( 255, 255, 255, 3 ))
	end
	
	CharSlot2 = vgui.Create("DPanel", RightPanel)
	CharSlot2:SetSize(100,100)
	CharSlot2:SetPos(110,175)
	CharSlot2.Paint = function()
		draw.RoundedBox(8,0,0,CharSlot2:GetWide(),CharSlot2:GetTall(),Color( 255, 255, 255, 3 ))
	end

	CharSlot3 = vgui.Create("DPanel", RightPanel) -- Primary Weapon
	CharSlot3:SetSize(100,100)
	CharSlot3:SetPos(215,175)
	CharSlot3.Paint = function()
		draw.RoundedBox(8,0,0,CharSlot3:GetWide(),CharSlot3:GetTall(),Color( 255, 255, 255, 3 ))
	end	
	
	CharSlot4 = vgui.Create("DPanel", RightPanel) -- Secondary Weapon
	CharSlot4:SetSize(100,100)
	CharSlot4:SetPos(215,280)
	CharSlot4.Paint = function()
		draw.RoundedBox(8,0,0,CharSlot4:GetWide(),CharSlot4:GetTall(),Color( 255, 255, 255, 3 ))
	end
	
	CharSlot5 = vgui.Create("DPanel", RightPanel) -- Melee Weapon
	CharSlot5:SetSize(105,100)
	CharSlot5:SetPos(0,175)
	CharSlot5.Paint = function()
		draw.RoundedBox(8,0,0,CharSlot5:GetWide(),CharSlot5:GetTall(),Color( 255, 255, 255, 3 ))
	end

	for k, item in pairs(Local_Backpack_Char) do
		if GAMEMODE.DayZ_Items[k].Hat then
			UpdateCharItemsBP(CharSlot1, k)		
		elseif GAMEMODE.DayZ_Items[k].Body then
			UpdateCharItemsBP(CharSlot2, k)
		elseif GAMEMODE.DayZ_Items[k].Primary then
			UpdateCharItemsBP(CharSlot3, k)
		elseif GAMEMODE.DayZ_Items[k].Secondary then
			UpdateCharItemsBP(CharSlot4, k)
		elseif GAMEMODE.DayZ_Items[k].Melee then
			UpdateCharItemsBP(CharSlot5, k)
		end
	end
	
	function UpdateInv_BP()
		if !IsValid(GUI_Inv_Panel_List) then return end
		
		GUI_Inv_Panel_List:Clear(true)
		
		for item,amount in pairs(Local_Inventory) do
		
			if amount > 0  then
			
				GUI_Inv_Item_Panel = vgui.Create("DPanelList", GUI_Inv_Panel_List)
				GUI_Inv_Item_Panel:SetSize(60,60)
				GUI_Inv_Item_Panel:SetPos(0,0)
				GUI_Inv_Item_Panel:SetSpacing(5)
				GUI_Inv_Item_Panel.Paint = function()

					draw.RoundedBoxEx(4,0,0,GUI_Inv_Item_Panel:GetWide(),GUI_Inv_Item_Panel:GetTall(),Color( 255, 255, 255, 255 ), true, true, true, true)
					draw.RoundedBoxEx(4,1,1,GUI_Inv_Item_Panel:GetWide()-2,GUI_Inv_Item_Panel:GetTall()-2,Color( 0, 0, 0, 255 ), true, true, true, true) 

					local spotlight = Material("gui/spotlight.png")
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial( spotlight)
					surface.DrawTexturedRect(0, 0, GUI_Inv_Item_Panel:GetWide()+4,GUI_Inv_Item_Panel:GetTall()+4)	
					
				end
			
				local GUI_Inv_Item_Icon = vgui.Create("DModelPanel", GUI_Inv_Item_Panel)
				local PaintModel = GUI_Inv_Item_Icon.Paint
				function GUI_Inv_Item_Icon:Paint()
					local x2, y2 = GUI_Inv_Panel_List:LocalToScreen( 0, 0 )
					local w2, h2 = GUI_Inv_Panel_List:GetSize()
					render.SetScissorRect( x2, y2, x2 + w2, y2 + h2, true )

					PaintModel( self )
					
					render.SetScissorRect( 0, 0, 0, 0, false )

				end
				--GUI_Inv_Item_Panel.ModelPanel = GUI_Inv_Item_Icon
				GUI_Inv_Item_Icon:SetPos(5,5)
				GUI_Inv_Item_Icon:SetSize(GUI_Inv_Item_Panel:GetWide()-10,GUI_Inv_Item_Panel:GetTall()-10)
				GUI_Inv_Item_Icon:SetDragParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_Panel:Droppable("invslot")
				GUI_Inv_Item_Panel.ItemClass = item
				
				GUI_Inv_Item_Icon:SetModel(GAMEMODE.DayZ_Items[item].Model)
				Inv_Icon_ent:SetModel(GAMEMODE.DayZ_Items[item].Model)
				GUI_Inv_Item_Icon:SetColor(GAMEMODE.DayZ_Items[item].Color or Color(255, 255, 255))
				
				if GAMEMODE.DayZ_Items[item].Angle != nil then
					GUI_Inv_Item_Icon:GetEntity():SetAngles(GAMEMODE.DayZ_Items[item].Angle)
				end

				local center = Inv_Icon_ent:OBBCenter()
				local dist = Inv_Icon_ent:BoundingRadius()*1.2
				
				GUI_Inv_Item_Icon:SetLookAt(center)
				GUI_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))
				GUI_Inv_Item_Icon.OnCursorEntered = function()
					if GUI_Inv_Desc_Panel != nil and GUI_Inv_Desc_Panel:IsValid() then
						return false
					end
					
					GUI_Inv_Desc_Panel = vgui.Create("DPanel", RightPanel)
					GUI_Inv_Desc_Panel.Paint = function()
						surface.SetDrawColor(0,0,0,255)
						surface.DrawRect(64,0, GUI_Inv_Desc_Panel:GetWide()-128,GUI_Inv_Desc_Panel:GetTall()) 
						surface.SetMaterial( gradient )
						surface.DrawTexturedRect(GUI_Inv_Desc_Panel:GetWide()-64,0, 64,GUI_Inv_Desc_Panel:GetTall() )
						surface.DrawTexturedRectRotated(32,32, 64,GUI_Inv_Desc_Panel:GetTall(),180 )
						surface.SetDrawColor(255,255,255,255)
						surface.DrawRect(64,0, GUI_Inv_Desc_Panel:GetWide()-128,2)
						surface.DrawRect(64,GUI_Inv_Desc_Panel:GetTall() -2, GUI_Inv_Desc_Panel:GetWide()-128,2) 

						surface.DrawTexturedRectRotated(32, 1, 64, 2, 180)
						surface.DrawTexturedRect(GUI_Inv_Desc_Panel:GetWide()-64, 0, 64, 2)
						surface.DrawTexturedRectRotated(32, GUI_Inv_Desc_Panel:GetTall()-1, 64, 2, 180)
						surface.DrawTexturedRect(GUI_Inv_Desc_Panel:GetWide()-64, GUI_Inv_Desc_Panel:GetTall()-2, 64, 2)
					end
					
					local GUI_Inv_Desc_Panel_Label = vgui.Create("DLabel", GUI_Inv_Desc_Panel)
					GUI_Inv_Desc_Panel_Label:SetPos(5,9)
					GUI_Inv_Desc_Panel_Label:SetColor(Color(255,255,255,255))

					if GAMEMODE.DayZ_Items[item].Weight then
						GUI_Inv_Desc_Panel_Label:SetText("Name: "..GAMEMODE.DayZ_Items[item].Name.."\nDescription: "..GAMEMODE.DayZ_Items[item].Desc.."\nWeight: "..GAMEMODE.DayZ_Items[item].Weight)
					else
						GUI_Inv_Desc_Panel_Label:SetText("Name: "..GAMEMODE.DayZ_Items[item].Name.."\nDescription: "..GAMEMODE.DayZ_Items[item].Desc)
					end
					
					GUI_Inv_Desc_Panel_Label:SetFont("Cyb_Inv_ToolTip")
					GUI_Inv_Desc_Panel_Label:SizeToContents()
					
					local num = 10
					local num1 = GUI_Inv_Desc_Panel_Label:GetWide()
					
					if GAMEMODE.DayZ_Items[item].Weight then												
						GUI_Inv_Desc_Panel:SetSize(num1 + 20,num + 55)
					else
						GUI_Inv_Desc_Panel:SetSize(num1 + 20,num + 40)
					end		
					
					local x,y = GUI_Inv_Panel_List:CursorPos()
					
					if (x-GUI_Inv_Desc_Panel_Label:GetWide()/2) <= 0 then x = 0 end
					GUI_Inv_Desc_Panel:SetPos( 5, 5 )	
					
				end
				GUI_Inv_Item_Icon.OnCursorExited = function()
					if GUI_Inv_Desc_Panel != nil && GUI_Inv_Desc_Panel:IsValid() then
						GUI_Inv_Desc_Panel:Remove()
					end
				end	
				GUI_Inv_Item_Icon.DoClick = function()
					if (GAMEMODE.DayZ_Items[item].Function != nil) then
						RunConsoleCommand("Useitem",item)
						timer.Simple( 0.3, UpdateInv_BP)
					end
				end

				GUI_Inv_Item_Icon.DoRightClick = function()
					ItemMENU = DermaMenu()
					
					local amts = {1, 5, 10, 25, 50, 100}
					for k, v in ipairs(amts) do
						ItemMENU:AddOption("Drop "..v, 	function()
							RunConsoleCommand("DropItem",item,v)
							timer.Simple( 0.3, UpdateInv_BP)
						end )
					end

					ItemMENU:AddOption("Drop All", function()
						RunConsoleCommand("DropItem",item,amount)
						timer.Simple( 0.3, UpdateInv_BP)
					end)
			
					ItemMENU:Open( gui.MousePos() )	
				end		
	
				--timer.Simple(0.08, function()		
					local GUI_Inv_Item_Name = vgui.Create("DLabel", GUI_Inv_Item_Panel)
					GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
					GUI_Inv_Item_Name:SetText(GAMEMODE.DayZ_Items[item].Name)
					GUI_Inv_Item_Name:SetFont("Cyb_Inv_Label")
					GUI_Inv_Item_Name:SizeToContents()
					GUI_Inv_Item_Icon:SetDragParent(GUI_Inv_Item_Panel)
					
					local x,y = surface.GetTextSize(" "..GAMEMODE.DayZ_Items[item].Name.." ")
					
					GUI_Inv_Item_Name:SetPos(5,5)
					
					if amount > 0 then
						local GUI_Inv_Item_Amt = vgui.Create("DLabel")
						GUI_Inv_Item_Amt:SetColor(Color(255,255,255,255))
						GUI_Inv_Item_Amt:SetFont("Cyb_Inv_Label")
						GUI_Inv_Item_Amt:SetText(amount)
						GUI_Inv_Item_Amt:SizeToContents()
						GUI_Inv_Item_Amt:SetParent(GUI_Inv_Item_Panel)
												
						--GUI_Inv_Item_Amt:SetPos(120 - x/2,25-y/2)
						GUI_Inv_Item_Amt:SetPos(5,43)
					end

				--end )
				
				GUI_Inv_Panel_List:AddItem(GUI_Inv_Item_Panel)

			end
		end
	end
	UpdateInv_BP()
	
	function UpdateInv_BP2()
		if !IsValid(GUI_Inv_Panel_List_BP) then return end
		
		GUI_Inv_Panel_List_BP:Clear(true)
		
		for item, amount in pairs(Local_Backpack) do
		
			if amount > 0  then
			
				local GUI_Inv_Item_Panel_BP = vgui.Create("DPanelList", GUI_Inv_Panel_List_BP)
				GUI_Inv_Item_Panel_BP:SetSize(60,60)
				GUI_Inv_Item_Panel_BP:SetPos(0,0)
				GUI_Inv_Item_Panel_BP:SetSpacing(5)
				GUI_Inv_Item_Panel_BP.Paint = function()

					draw.RoundedBoxEx(4,0,0,GUI_Inv_Item_Panel_BP:GetWide(),GUI_Inv_Item_Panel_BP:GetTall(),Color( 255, 255, 255, 255 ), true, true, true, true)
					draw.RoundedBoxEx(4,1,1,GUI_Inv_Item_Panel_BP:GetWide()-2,GUI_Inv_Item_Panel_BP:GetTall()-2,Color( 0, 0, 0, 255 ), true, true, true, true) 

					local spotlight = Material("gui/spotlight.png")
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial( spotlight)
					surface.DrawTexturedRect(0, 0, GUI_Inv_Item_Panel_BP:GetWide()+4,GUI_Inv_Item_Panel_BP:GetTall()+4)	
					
				end
			
				local GUI_Inv_Item_Icon = vgui.Create("DModelPanel", GUI_Inv_Item_Panel_BP)
				local PaintModel = GUI_Inv_Item_Icon.Paint
				function GUI_Inv_Item_Icon:Paint()
					local x2, y2 = GUI_Inv_Panel_List_BP:LocalToScreen( 0, 0 )
					local w2, h2 = GUI_Inv_Panel_List_BP:GetSize()
					render.SetScissorRect( x2, y2, x2 + w2, y2 + h2, true )

					PaintModel( self )
					
					render.SetScissorRect( 0, 0, 0, 0, false )

				end
				--GUI_Inv_Item_Panel.ModelPanel = GUI_Inv_Item_Icon
				GUI_Inv_Item_Icon:SetPos(5,5)
				GUI_Inv_Item_Icon:SetSize(GUI_Inv_Item_Panel_BP:GetWide()-10,GUI_Inv_Item_Panel_BP:GetTall()-10)
				GUI_Inv_Item_Icon:SetDragParent(GUI_Inv_Item_Panel_BP)
				GUI_Inv_Item_Panel_BP:Droppable("invslot")
				GUI_Inv_Item_Panel_BP.ItemClass = item
				
				GUI_Inv_Item_Icon:SetModel(GAMEMODE.DayZ_Items[item].Model)
				Inv_Icon_ent:SetModel(GAMEMODE.DayZ_Items[item].Model)
				GUI_Inv_Item_Icon:SetColor(GAMEMODE.DayZ_Items[item].Color or Color(255, 255, 255))
				
				if GAMEMODE.DayZ_Items[item].Angle != nil then
					GUI_Inv_Item_Icon:GetEntity():SetAngles(GAMEMODE.DayZ_Items[item].Angle)
				end

				local center = Inv_Icon_ent:OBBCenter()
				local dist = Inv_Icon_ent:BoundingRadius()*1.2
				
				GUI_Inv_Item_Icon:SetLookAt(center)
				GUI_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))
				GUI_Inv_Item_Icon.OnCursorEntered = function()
					if GUI_Inv_Desc_Panel != nil and GUI_Inv_Desc_Panel:IsValid() then
						return false
					end
					
					GUI_Inv_Desc_Panel = vgui.Create("DPanel", RightPanel)
					GUI_Inv_Desc_Panel.Paint = function()
						surface.SetDrawColor(0,0,0,255)
						surface.DrawRect(64,0, GUI_Inv_Desc_Panel:GetWide()-128,GUI_Inv_Desc_Panel:GetTall()) 
						surface.SetMaterial( gradient )
						surface.DrawTexturedRect(GUI_Inv_Desc_Panel:GetWide()-64,0, 64,GUI_Inv_Desc_Panel:GetTall() )
						surface.DrawTexturedRectRotated(32,32, 64,GUI_Inv_Desc_Panel:GetTall(),180 )
						surface.SetDrawColor(255,255,255,255)
						surface.DrawRect(64,0, GUI_Inv_Desc_Panel:GetWide()-128,2)
						surface.DrawRect(64,GUI_Inv_Desc_Panel:GetTall() -2, GUI_Inv_Desc_Panel:GetWide()-128,2) 

						surface.DrawTexturedRectRotated(32, 1, 64, 2, 180)
						surface.DrawTexturedRect(GUI_Inv_Desc_Panel:GetWide()-64, 0, 64, 2)
						surface.DrawTexturedRectRotated(32, GUI_Inv_Desc_Panel:GetTall()-1, 64, 2, 180)
						surface.DrawTexturedRect(GUI_Inv_Desc_Panel:GetWide()-64, GUI_Inv_Desc_Panel:GetTall()-2, 64, 2)
					end
					
					local GUI_Inv_Desc_Panel_Label = vgui.Create("DLabel", GUI_Inv_Desc_Panel)
					GUI_Inv_Desc_Panel_Label:SetPos(5,9)
					GUI_Inv_Desc_Panel_Label:SetColor(Color(255,255,255,255))

					if GAMEMODE.DayZ_Items[item].Weight then
						GUI_Inv_Desc_Panel_Label:SetText("Name: "..GAMEMODE.DayZ_Items[item].Name.."\nDescription: "..GAMEMODE.DayZ_Items[item].Desc.."\nWeight: "..GAMEMODE.DayZ_Items[item].Weight)
					else
						GUI_Inv_Desc_Panel_Label:SetText("Name: "..GAMEMODE.DayZ_Items[item].Name.."\nDescription: "..GAMEMODE.DayZ_Items[item].Desc)
					end
					
					GUI_Inv_Desc_Panel_Label:SetFont("Cyb_Inv_ToolTip")
					GUI_Inv_Desc_Panel_Label:SizeToContents()
					
					local num = 10
					local num1 = GUI_Inv_Desc_Panel_Label:GetWide()
					
					if GAMEMODE.DayZ_Items[item].Weight then												
						GUI_Inv_Desc_Panel:SetSize(num1 + 20,num + 55)
					else
						GUI_Inv_Desc_Panel:SetSize(num1 + 20,num + 40)
					end		
					
					local x,y = GUI_Inv_Panel_List:CursorPos()
					
					if (x-GUI_Inv_Desc_Panel_Label:GetWide()/2) <= 0 then x = 0 end
					GUI_Inv_Desc_Panel:SetPos( 5, 5 )	
					
				end
				GUI_Inv_Item_Icon.OnCursorExited = function()
					if GUI_Inv_Desc_Panel != nil && GUI_Inv_Desc_Panel:IsValid() then
						GUI_Inv_Desc_Panel:Remove()
					end
				end	
			
				GUI_Inv_Item_Icon.DoRightClick = function()
					ItemMENU = DermaMenu()
					
					local amts = {1, 5, 10, 25, 50, 100}
					for k, v in ipairs(amts) do
						ItemMENU:AddOption("Loot "..v, 	function()
							DoLootItem( item, v, backpack)
							timer.Simple( 0.3, UpdateInv_BP2)
							timer.Simple( 0.3, UpdateInv_BP)
						end )
					end

					ItemMENU:AddOption("Loot All", function()
						DoLootItem( item, amount, backpack)
						timer.Simple( 0.3, UpdateInv_BP2)
						timer.Simple( 0.3, UpdateInv_BP)
					end)
				    
					ItemMENU:Open( gui.MousePos() )	
				end		
	
				--timer.Simple(0.08, function()		
					local GUI_Inv_Item_Name = vgui.Create("DLabel", GUI_Inv_Item_Panel_BP)
					GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
					GUI_Inv_Item_Name:SetText(GAMEMODE.DayZ_Items[item].Name)
					GUI_Inv_Item_Name:SetFont("Cyb_Inv_Label")
					GUI_Inv_Item_Name:SizeToContents()
					GUI_Inv_Item_Icon:SetDragParent(GUI_Inv_Item_Panel_BP)
					
					local x,y = surface.GetTextSize(" "..GAMEMODE.DayZ_Items[item].Name.." ")
					
					GUI_Inv_Item_Name:SetPos(5,5)
					
					if amount > 0 then
						local GUI_Inv_Item_Amt = vgui.Create("DLabel")
						GUI_Inv_Item_Amt:SetColor(Color(255,255,255,255))
						GUI_Inv_Item_Amt:SetFont("Cyb_Inv_Label")
						GUI_Inv_Item_Amt:SetText(amount)
						GUI_Inv_Item_Amt:SizeToContents()
						GUI_Inv_Item_Amt:SetParent(GUI_Inv_Item_Panel_BP)
												
						--GUI_Inv_Item_Amt:SetPos(120 - x/2,25-y/2)
						GUI_Inv_Item_Amt:SetPos(5,43)
					end

				--end )
				
				GUI_Inv_Panel_List_BP:AddItem(GUI_Inv_Item_Panel_BP)

			end
		end
	end
	UpdateInv_BP2()

	
end
