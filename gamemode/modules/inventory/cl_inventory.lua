local vgui = vgui
local draw = draw
local surface = surface
local gradient = Material("gui/gradient")

Local_Character = Local_Character or {}
Local_Inventory = Local_Inventory or {}

--------------------------------
net.Receive("UpdateItem", function(len)
	local item = net.ReadUInt(16)
	local amt = net.ReadFloat()
	Local_Inventory[item] = amt
end)

net.Receive("UpdateItemFull", function(len)
	Local_Inventory = net.ReadTable()
end)

net.Receive("UpdateCharFull", function(len)
	Local_Character = net.ReadTable()
end)

net.Receive("UpdateWeight", function(len)
	TotalWeight = math.Round(net.ReadFloat(), 1)
end)

function Rebuild_Backup(len)
	GUI_Rebuild_Inv(GUI_Inv_tab_Panel)
end
net.Receive( "net_UpdateInventory", Rebuild_Backup );

function UpdateCharItems(parent, item)	
	if !IsValid(parent) then return end
	
	if IsValid(InvPlayerModel) then
		InvPlayerModel:SetModel(LocalPlayer():GetModel())
	end
	
	if Local_Character[item] == nil then return end
	
	local GUI_Inv_Item_Panel = vgui.Create("DPanelList", parent)
	GUI_Inv_Item_Panel:SetSize(95,95)
	GUI_Inv_Item_Panel:SetPos(2,2)
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
		local x2, y2 = GUI_Inven_Panel_List:LocalToScreen( 0, 0 )
		local w2, h2 = GUI_Inven_Panel_List:GetSize()
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
	
	GUI_Inv_Item_Icon:SetModel(GAMEMODE.DayZ_Items[item].Model)
	Inv_Icon_ent:SetModel(GAMEMODE.DayZ_Items[item].Model)
	GUI_Inv_Item_Icon:SetColor(GAMEMODE.DayZ_Items[item].Color or Color(255, 255, 255))
	if GAMEMODE.DayZ_Items[item].Material then Inv_Icon_ent:SetMaterial(GAMEMODE.DayZ_Items[item].Material) GUI_Inv_Item_Icon:SetMaterial(GAMEMODE.DayZ_Items[item].Material) end
	
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
	
	if Local_Character[item] then
		local GUI_Inv_Item_Amt = vgui.Create("DLabel")
		GUI_Inv_Item_Amt:SetColor(Color(255,255,255,255))
		GUI_Inv_Item_Amt:SetFont("Cyb_Inv_Label")
		GUI_Inv_Item_Amt:SetText("1")
		GUI_Inv_Item_Amt:SizeToContents()
		GUI_Inv_Item_Amt:SetParent(GUI_Inv_Item_Panel)
								
		--GUI_Inv_Item_Amt:SetPos(120 - x/2,25-y/2)
		GUI_Inv_Item_Amt:SetPos(5,78)
	end

end

function GUI_Rebuild_Inv(parent)

	if (GUI_Loot_Frame and GUI_Loot_Frame:IsValid()) then
		GUI_Loot_Frame:Remove()
	end
	
	if !IsValid(parent) then return end

	Inv_Icon_ent = ents.CreateClientProp("prop_physics")
	Inv_Icon_ent:SetPos(Vector(0,0,-500))
	Inv_Icon_ent:SetNoDraw(true)
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
	
	if GUI_Inv_Item_Panel != nil and GUI_Inv_Item_Panel:IsValid() then
		GUI_Inv_Item_Panel:Clear()
	end
		
	GUI_Inv_Panel_List = vgui.Create("DPanelList", parent)
	GUI_Inv_Panel_List:SetSize(210,505)
	GUI_Inv_Panel_List:SetPos(0,0)
	GUI_Inv_Panel_List.Paint = function()
		draw.RoundedBox(8,0,0,GUI_Inv_Panel_List:GetWide(),GUI_Inv_Panel_List:GetTall(),Color( 30, 30, 30, 0 ))
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
		timer.Simple(1, function() UpdateInv() end)
		RunConsoleCommand("Dequipitem", tbl[1].ItemClass)
    end )
	
	RightPanel = vgui.Create("DPanelList", parent)
	RightPanel:SetSize(520, 510)
	RightPanel:SetPos(215, 0)
	RightPanel.Paint = function()
		draw.RoundedBox(8,0,0,RightPanel:GetWide(),RightPanel:GetTall(),Color( 30, 30, 30, 100 ))
	end
	
	local Splitter = vgui.Create("DPanel", RightPanel)
	Splitter:SetPos(109, 0)
	Splitter:SetSize(1, RightPanel:GetWide()-18)
			
	-- Add inventory slots
	--local icon = vgui.Create( "DImageButton", self.tabs )
		
	Num2 = vgui.Create("DImageButton", RightPanel)
	Num2:SetImage("cyb_mat/cyb_eat.png")
	Num2:SetColor(Color(41, 128, 185))
	Num2:SetPos(25, 25)
	Num2:SetSize(60,60)
	
	Num3 = vgui.Create("DImageButton", RightPanel)
	Num3:SetImage("cyb_mat/cyb_analyse.png")
	Num3:SetColor(Color(41, 128, 185))
	Num3:SetPos(25, 225)
	Num3:SetSize(60,60)
	
	Num4 = vgui.Create("DImageButton", RightPanel)
	Num4:SetImage("cyb_mat/cyb_decompile.png")
	Num4:SetColor(Color(41, 128, 185))
	Num4:SetPos(25, 325)
	Num4:SetSize(60,60)
	
	Num5 = vgui.Create("DImageButton", RightPanel)
	Num5:SetImage("cyb_mat/cyb_clip.png")
	Num5:SetColor(Color(41, 128, 185))
	Num5:SetPos(25, 425)
	Num5:SetSize(60,60)
	
	Num6 = vgui.Create("DImageButton", RightPanel)
	Num6:SetImage("cyb_mat/cyb_drop.png")
	Num6:SetColor(Color(41, 128, 185))
	Num6:SetPos(25, 125)
	Num6:SetSize(60,60)

			
	Slot2 = vgui.Create("DPanel", RightPanel)
	Slot2:SetSize(100,100)
	Slot2:SetPos(5,5)
	Slot2:SetTooltip("Eat an item by dragging it onto this!")
	Slot2.Paint = function()
		draw.RoundedBox(8,0,0,Slot2:GetWide(),Slot2:GetTall(),Color( 255, 255, 255, 3 ))
	end
		
	Slot2:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == Slot2 then return end
		if table.Count(Slot2:GetChildren()) > 0 then return end

		if GAMEMODE.DayZ_Items[tbl[1].ItemClass].EatFunction != nil or GAMEMODE.DayZ_Items[tbl[1].ItemClass].DrinkFunction != nil then
			tbl[1]:SetSize(95,95)
			tbl[1]:SetPos(2,2)
			tbl[1]:GetChild(1):SetSize(90,90)
					
			tbl[1]:SetParent(pnl)
			
			RunConsoleCommand("Eatitem",tbl[1].ItemClass)
			timer.Simple(1, function() UpdateInv() ClearSlot(pnl) end)
		end
	end )
	
	Slot3 = vgui.Create("DPanel", RightPanel)
	Slot3:SetSize(100,100)
	Slot3:SetPos(5,205)
	Slot3:SetTooltip("Analyze an item by dragging it onto this!")
	Slot3.Paint = function()
		draw.RoundedBox(8,0,0,Slot3:GetWide(),Slot3:GetTall(),Color( 255, 255, 255, 3 ))
	end
	Slot3:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == Slot3 then return end
		if table.Count(Slot3:GetChildren()) > 0 then return end
		
		if GAMEMODE.DayZ_Items[tbl[1].ItemClass].Craftable != nil then
			tbl[1]:SetSize(95,95)
			tbl[1]:SetPos(2,2)
			tbl[1]:GetChild(1):SetSize(90,90)
			
			tbl[1]:SetParent(pnl)
			
			RunConsoleCommand("BPitem",tbl[1].ItemClass)
			timer.Simple(1, function() UpdateInv() ClearSlot(pnl) end)
		end
	end )

	Slot4 = vgui.Create("DPanel", RightPanel)
	Slot4:SetSize(100,100)
	Slot4:SetPos(5,305)
	Slot4:SetTooltip("Decompile an item by dragging it onto this!")
	Slot4.Paint = function()
		draw.RoundedBox(8,0,0,Slot4:GetWide(),Slot4:GetTall(),Color( 255, 255, 255, 3 ))
	end	
	Slot4:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == Slot4 then return end
		if table.Count(Slot4:GetChildren()) > 0 then return end
		
		if GAMEMODE.DayZ_Items[tbl[1].ItemClass].Decompiles != nil then
			tbl[1]:SetSize(95,95)
			tbl[1]:SetPos(2,2)
			tbl[1]:GetChild(1):SetSize(90,90)
			
			tbl[1]:SetParent(pnl)
			
			RunConsoleCommand("Decompileitem",tbl[1].ItemClass)
			timer.Simple(1, function() UpdateInv() ClearSlot(pnl) end)
		end
	end )
		
	Slot5 = vgui.Create("DPanel", RightPanel)
	Slot5:SetSize(100,100)
	Slot5:SetPos(5,405)
	Slot5:SetTooltip("Empty the clip on your weapon by dragging it into this!")
	Slot5.Paint = function()
		draw.RoundedBox(8,0,0,Slot5:GetWide(),Slot5:GetTall(),Color( 255, 255, 255, 3 ))
	end
	Slot5:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == Slot5 then return end
		if table.Count(Slot5:GetChildren()) > 0 then return end
		
		if (GAMEMODE.DayZ_Items[tbl[1].ItemClass].Weapon) then
			tbl[1]:SetSize(94,94)
			tbl[1]:SetPos(2, 2)
			tbl[1]:GetChild(1):SetSize(90,90)
			
			tbl[1]:SetParent(pnl)

			RunConsoleCommand("emptyclip", GAMEMODE.DayZ_Items[tbl[1].ItemClass].Weapon)
			timer.Simple(1, function() UpdateInv() end)
		end
	end )
	
	Slot6 = vgui.Create("DPanel", RightPanel)
	Slot6:SetSize(100,100)
	Slot6:SetPos(5,105)
	Slot6:SetTooltip("Drop an item by dragging it onto this!")
	Slot6.Paint = function()
		draw.RoundedBox(8,0,0,Slot6:GetWide(),Slot6:GetTall(),Color( 255, 255, 255, 3 ))
	end
		
	Slot6:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == Slot6 then return end
		if table.Count(Slot6:GetChildren()) > 0 then return end

		tbl[1]:SetSize(95,95)
		tbl[1]:SetPos(2,2)
		tbl[1]:GetChild(1):SetSize(90,90)
					
		tbl[1]:SetParent(pnl)
			
		RunConsoleCommand("Dropitem", tbl[1].ItemClass, 1)
	end )
	
	CharPanel = vgui.Create("DPanelList", RightPanel)
	CharPanel:SetPos(114, 5)
	CharPanel:SetSize(400, 500)
	CharPanel.Paint = function() end

	InvPlayerModel = vgui.Create("DModelPanel", CharPanel)
	InvPlayerModel:SetModel(LocalPlayer():GetModel())
	InvPlayerModel:SetSize(500,500)
	InvPlayerModel:SetPos(-50,-50)
	InvPlayerModel.LayoutEntity = function() end

	Num1 = vgui.Create("DImageButton", RightPanel)
	Num1:SetImage("cyb_mat/cyb_use.png")
	Num1:SetColor(Color(41, 128, 185))
	Num1:SetPos(135, 22)
	Num1:SetSize(60,60)
	
	Slot1 = vgui.Create("DPanel", RightPanel)
	Slot1:SetSize(100,100)
	Slot1:SetPos(115,5)
	Slot1:SetTooltip("Use an item by dragging it onto this!")
	Slot1.Paint = function()
		draw.RoundedBox(8,0,0,Slot1:GetWide(),Slot1:GetTall(),Color( 255, 255, 255, 3 ))
	end
	Slot1:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == Slot1 then return end
		if table.Count(Slot1:GetChildren()) > 0 then return end

		if GAMEMODE.DayZ_Items[ tbl[1].ItemClass ].Function != nil then
			tbl[1]:SetSize(95,95)
			tbl[1]:SetPos(2,2)
			tbl[1]:GetChild(1):SetSize(90,90)
			
			tbl[1]:SetParent(pnl)
			
			RunConsoleCommand("Useitem",tbl[1].ItemClass)
		end
	end )

	CharSlot1 = vgui.Create("DPanel", CharPanel)
	CharSlot1:SetSize(100,100)
	CharSlot1:SetPos(145,70)
	CharSlot1:SetTooltip("Hats")
	CharSlot1.Paint = function()
		draw.RoundedBox(8,0,0,CharSlot1:GetWide(),CharSlot1:GetTall(),Color( 255, 255, 255, 3 ))
	end
	CharSlot1:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == CharSlot1 then return end
		if table.Count(CharSlot1:GetChildren()) > 0 then return end

		if GAMEMODE.DayZ_Items[tbl[1].ItemClass].Hat != nil then
			if GAMEMODE.DayZ_Items[tbl[1].ItemClass].VIP and !LocalPlayer():IsVIP() then chat.AddText(Color(0,255,0,255), "[Inventory] ", Color(255,255,255,255), "This Hat is VIP Only! Sorry!") return end
			tbl[1]:SetSize(94,94)
			tbl[1]:SetPos(2,2)
			tbl[1]:GetChild(1):SetSize(90,90)
			
			tbl[1]:SetParent(pnl)
			RunConsoleCommand("Equipitem",tbl[1].ItemClass)
			timer.Simple(1, function() UpdateInv() end)
		else
			chat.AddText(Color(0,255,0,255), "[Inventory] ", Color(255,255,255,255), "Hat's go in this slot!")
		end
	end )
	
	CharSlot2 = vgui.Create("DPanel", CharPanel)
	CharSlot2:SetSize(100,100)
	CharSlot2:SetPos(145,175)
	CharSlot2:SetTooltip("Clothing")
	CharSlot2.Paint = function()
		draw.RoundedBox(8,0,0,CharSlot2:GetWide(),CharSlot2:GetTall(),Color( 255, 255, 255, 3 ))
	end
	CharSlot2:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == CharSlot2 then return end
		if table.Count(CharSlot2:GetChildren()) > 0 then return end

		if GAMEMODE.DayZ_Items[tbl[1].ItemClass].Body != nil then
			tbl[1]:SetSize(94,94)
			tbl[1]:SetPos(2,2)
			tbl[1]:GetChild(1):SetSize(90,90)
			
			tbl[1]:SetParent(pnl)
			RunConsoleCommand("Equipitem",tbl[1].ItemClass)
			timer.Simple(1, function() UpdateInv() end)
		else
			chat.AddText(Color(0,255,0,255), "[Inventory] ", Color(255,255,255,255), "Clothes go in this slot!")
		end
	end )

	CharSlot3 = vgui.Create("DPanel", CharPanel) -- Primary Weapon
	CharSlot3:SetSize(100,100)
	CharSlot3:SetPos(250,175)
	CharSlot3:SetTooltip("Primary Weapons")
	CharSlot3.Paint = function()
		draw.RoundedBox(8,0,0,CharSlot3:GetWide(),CharSlot3:GetTall(),Color( 255, 255, 255, 3 ))
	end
	CharSlot3:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == CharSlot3 then return end
		if table.Count(CharSlot3:GetChildren()) > 0 then return end

		if GAMEMODE.DayZ_Items[tbl[1].ItemClass].Primary != nil then
			tbl[1]:SetSize(94,94)
			tbl[1]:SetPos(2,2)
			tbl[1]:GetChild(1):SetSize(90,90)
			
			tbl[1]:SetParent(pnl)
			RunConsoleCommand("Equipitem",tbl[1].ItemClass)
			timer.Simple(1, function() UpdateInv() end)
		else
			chat.AddText(Color(0,255,0,255), "[Inventory] ", Color(255,255,255,255), "Primary Weapons go in this slot!")
		end
	end )
	
	
	CharSlot4 = vgui.Create("DPanel", CharPanel) -- Secondary Weapon
	CharSlot4:SetSize(100,100)
	CharSlot4:SetPos(250,280)
	CharSlot4:SetTooltip("Secondary Weapons")
	CharSlot4.Paint = function()
		draw.RoundedBox(8,0,0,CharSlot4:GetWide(),CharSlot4:GetTall(),Color( 255, 255, 255, 3 ))
	end
	CharSlot4:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == CharSlot4 then return end
		if table.Count(CharSlot4:GetChildren()) > 0 then return end

		if GAMEMODE.DayZ_Items[tbl[1].ItemClass].Secondary != nil then
			tbl[1]:SetSize(94,94)
			tbl[1]:SetPos(2,2)
			tbl[1]:GetChild(1):SetSize(90,90)
			
			tbl[1]:SetParent(pnl)
			RunConsoleCommand("Equipitem",tbl[1].ItemClass)
			timer.Simple(1, function() UpdateInv() end)

		else
			chat.AddText(Color(0,255,0,255), "[Inventory] ", Color(255,255,255,255), "Secondary Weapons go in this slot!")
		end
	end )
	
	CharSlot5 = vgui.Create("DPanel", CharPanel) -- Melee Weapon
	CharSlot5:SetSize(100,100)
	CharSlot5:SetPos(40,175)
	CharSlot5:SetTooltip("Melee Weapons")
	CharSlot5.Paint = function()
		draw.RoundedBox(8,0,0,CharSlot5:GetWide(),CharSlot5:GetTall(),Color( 255, 255, 255, 3 ))
	end
	CharSlot5:Receiver( "invslot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == CharSlot5 then return end
		if table.Count(CharSlot5:GetChildren()) > 0 then return end

		if GAMEMODE.DayZ_Items[tbl[1].ItemClass].Melee != nil then
			tbl[1]:SetSize(94,94)
			tbl[1]:SetPos(2,2)
			tbl[1]:GetChild(1):SetSize(90,90)
			
			tbl[1]:SetParent(pnl)
			RunConsoleCommand("Equipitem",tbl[1].ItemClass)
			timer.Simple(1, function() UpdateInv() end)

		else
			chat.AddText(Color(0,255,0,255), "[Inventory] ", Color(255,255,255,255), "Melee Weapons go in this slot!")
		end
	end )

	for k, item in pairs(Local_Character) do
		if GAMEMODE.DayZ_Items[k].Hat then
			UpdateCharItems(CharSlot1, k)		
		elseif GAMEMODE.DayZ_Items[k].Body then
			UpdateCharItems(CharSlot2, k)
		elseif GAMEMODE.DayZ_Items[k].Primary then
			UpdateCharItems(CharSlot3, k)
		elseif GAMEMODE.DayZ_Items[k].Secondary then
			UpdateCharItems(CharSlot4, k)
		elseif GAMEMODE.DayZ_Items[k].Melee then
			UpdateCharItems(CharSlot5, k)
		end
	end
	
	function UpdateInv()
		if !IsValid(GUI_Inv_Panel_List) then return end
		
		if IsValid(InvPlayerModel) then
			InvPlayerModel:SetModel(LocalPlayer():GetModel())
		end
		
		GUI_Inv_Panel_List:Clear(true)
		
		for item,amount in pairs(Local_Inventory) do
		
			if amount > 0  then
			
				local GUI_Inv_Item_Panel = vgui.Create("DPanelList", GUI_Inv_Panel_List)
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
					local x2, y2 = parent:LocalToScreen( 0, 0 )
					local w2, h2 = parent:GetSize()
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
				if GAMEMODE.DayZ_Items[item].Material then GUI_Inv_Item_Icon:GetEntity():SetMaterial(GAMEMODE.DayZ_Items[item].Material) end

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
					GUI_Inv_Desc_Panel:SetPos( 115, 405 )	
					
				end
				GUI_Inv_Item_Icon.OnCursorExited = function()
					if GUI_Inv_Desc_Panel != nil && GUI_Inv_Desc_Panel:IsValid() then
						GUI_Inv_Desc_Panel:Remove()
					end
				end	
				GUI_Inv_Item_Icon.DoClick = function()
					if (GAMEMODE.DayZ_Items[item].Function != nil) then
						RunConsoleCommand("Useitem",item)
						timer.Simple( 0.3, UpdateInv)
					end
				end

				GUI_Inv_Item_Icon.DoRightClick = function()
					ItemMENU = DermaMenu()
					
					local amts = {1, 5, 10, 25, 50, 100}
					for k, v in ipairs(amts) do
						ItemMENU:AddOption("Drop "..v, 	function()
							RunConsoleCommand("DropItem",item,v)
							timer.Simple( 0.3, UpdateInv)
						end )
					end

					ItemMENU:AddOption("Drop All", function()
						RunConsoleCommand("DropItem",item,amount)
					end)

					ItemMENU:AddOption("Drop X", function()
						GUI_Amount_Popup(item)
					end)
					
					if (GAMEMODE.DayZ_Items[item].Weapondata) then
						ItemMENU:AddOption("Empty Clip", function()
							RunConsoleCommand("emptyclip", GAMEMODE.DayZ_Items[item].Weapondata.Weapon)
						end)
					end

					if GAMEMODE.DayZ_Items[item].Function != nil then
						ItemMENU:AddOption("Use Item", 	function()
							RunConsoleCommand("Useitem",item)
							timer.Simple( 0.3, UpdateInv)
						end)													
					end
					
					if GAMEMODE.DayZ_Items[item].EatFunction != nil then
						ItemMENU:AddOption("Eat Item", 	function()
							RunConsoleCommand("Eatitem",item)
							timer.Simple( 0.3, UpdateInv)
						end)													
					end
					
					if GAMEMODE.DayZ_Items[item].DrinkFunction != nil then
						ItemMENU:AddOption("Drink Item", function()
							RunConsoleCommand("Eatitem",item)
							timer.Simple( 0.3, UpdateInv)
						end)													
					end
					
					if GAMEMODE.DayZ_Items[item].Craftable != nil then
						ItemMENU:AddOption("Analyse Item", function()
							RunConsoleCommand("BPItem",item)
							timer.Simple( 0.3, UpdateInv)
						end)
					end
					
					if GAMEMODE.DayZ_Items[item].Decompiles != nil then
						ItemMENU:AddOption("Decompile Item", function()
							RunConsoleCommand("Decompileitem",item)
							timer.Simple( 0.3, UpdateInv)
						end)													
					end									

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
	UpdateInv()

	GUI_Weight_Bar = vgui.Create("DPanelList", CharPanel)
	GUI_Weight_Bar:SetSize(780,25)
	GUI_Weight_Bar:SetPos(-190,469)
	GUI_Weight_Bar.Paint = function()
		if TotalWeight then
			if LocalPlayer():GetNWBool("Perk2") == true then
				draw.RoundedBoxEx(4, GUI_Weight_Bar:GetWide() /4 ,0, GUI_Weight_Bar:GetWide() /2, GUI_Weight_Bar:GetTall(), Color(255,255,255,255), true, true, true, true)
				draw.RoundedBoxEx(4, GUI_Weight_Bar:GetWide() /4 +1 ,1, GUI_Weight_Bar:GetWide() /2 -2, GUI_Weight_Bar:GetTall() -2, Color(40,40,40,255), true, true, true, true)
				draw.RoundedBoxEx(4, GUI_Weight_Bar:GetWide() /4 +1 ,1, (GUI_Weight_Bar:GetWide()/2-4)*(TotalWeight/200), GUI_Weight_Bar:GetTall() -2, Color(12,75,129,255), true, true, true, true)
				draw.RoundedBoxEx(4, GUI_Weight_Bar:GetWide() /4 +1 ,1, (GUI_Weight_Bar:GetWide()/2-4)*(TotalWeight/200), GUI_Weight_Bar:GetTall()/2 -2, Color(59,138,206,255), true, true, false, false)
				draw.DrawText("BACKPACK WEIGHT:", "Cyb_Inv_Bar", GUI_Weight_Bar:GetWide()/4 +10, GUI_Weight_Bar:GetTall()-22, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(TotalWeight.."/200", "Cyb_Inv_Bar", GUI_Weight_Bar:GetWide()/2 +180, GUI_Weight_Bar:GetTall()-22, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)									
			else
				draw.RoundedBoxEx(4, GUI_Weight_Bar:GetWide() /4 ,0, GUI_Weight_Bar:GetWide() /2, GUI_Weight_Bar:GetTall(), Color(255,255,255,255), true, true, true, true)
				draw.RoundedBoxEx(4, GUI_Weight_Bar:GetWide() /4 +1 ,1, GUI_Weight_Bar:GetWide() /2 -2, GUI_Weight_Bar:GetTall() -2, Color(40,40,40,255), true, true, true, true)
				draw.RoundedBoxEx(4, GUI_Weight_Bar:GetWide() /4 +1 ,1, (GUI_Weight_Bar:GetWide()/2-4)*(TotalWeight/100), GUI_Weight_Bar:GetTall() -2, Color(12,75,129,255), true, true, true, true)
				draw.RoundedBoxEx(4, GUI_Weight_Bar:GetWide() /4 +1 ,1, (GUI_Weight_Bar:GetWide()/2-4)*(TotalWeight/100), GUI_Weight_Bar:GetTall()/2 -2, Color(59,138,206,255), true, true, false, false)
				draw.DrawText("BACKPACK WEIGHT:", "Cyb_Inv_Bar", GUI_Weight_Bar:GetWide()/4 +10, GUI_Weight_Bar:GetTall()-22, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(TotalWeight.."/100", "Cyb_Inv_Bar", GUI_Weight_Bar:GetWide()/2 +180, GUI_Weight_Bar:GetTall()-22, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
			end
		end
	end
	GUI_Weight_Bar:SetPadding(7.5)
	GUI_Weight_Bar:SetSpacing(2)
	GUI_Weight_Bar:EnableHorizontal(3)
	GUI_Weight_Bar:EnableVerticalScrollbar(true)

	
end

function ClearSlot(pnl)
	if !IsValid(pnl) then return end
	if pnl:GetChildren()[1] then pnl:GetChildren()[1]:Remove() end
end

function GUI_Amount_Popup(item)
	if GUI_Amount_Frame != nil && GUI_Amount_Frame:IsValid() then GUI_Amount_Frame:Remove() end
	local GUI_Amount_Frame = vgui.Create("DFrame")
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
								RunConsoleCommand("Dropitem",item,GUI_Amount_slider:GetValue())
								GUI_Amount_Frame:Remove()
								timer.Simple( 0.3, Rebuild_Backup)
							end
end