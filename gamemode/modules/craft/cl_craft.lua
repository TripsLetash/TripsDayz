local vgui = vgui
local draw = draw
local surface = surface
local gradient = Material("gui/gradient")
local CanCrafts = {}

function GUI_Rebuild_Craft_Items(parent)
	Inv_Icon_ent = ents.CreateClientProp("prop_physics")
	Inv_Icon_ent:SetPos(Vector(0,0,-500))
	Inv_Icon_ent:SetNoDraw(true)
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
	
	if GUI_Inv_Item_Panel != nil and GUI_Inv_Item_Panel:IsValid() then
		GUI_Inv_Item_Panel:Clear()
	end
		
	local InvHolder = vgui.Create("DPanelList", parent)
	InvHolder:SetSize(210,495)
	InvHolder:SetPos(0,0)
	InvHolder.Paint = function()
		draw.RoundedBox(8,0,0,InvHolder:GetWide(),InvHolder:GetTall(),Color( 30, 30, 30, 0 ))
	end
	InvHolder:SetPadding(7.5)
	InvHolder:SetSpacing(2)
	InvHolder:EnableHorizontal(3)
	InvHolder:EnableVerticalScrollbar(true)
	InvHolder:Receiver( "slot", function( pnl, tbl, dropped, menu, x, y )
    	if ( !dropped ) then return end
		if tbl[1]:GetParent() == InvHolder then return end

		tbl[1]:SetSize(60,60)
		tbl[1]:GetChild(1):SetSize(50,50)

		InvHolder:AddItem(tbl[1])
		RepopulateCrafts()
    end )
	
	function UpdateCraftInv()
		InvHolder:Clear(true)
		
		for item, amount in pairs(Local_Inventory) do

			if amount > 0 then
			
				if amount == 1 and IsValid(Slot1:GetChildren()[1]) and Slot1:GetChildren()[1].ItemClass == item then continue end
				if amount == 1 and IsValid(Slot2:GetChildren()[1]) and Slot2:GetChildren()[1].ItemClass == item then continue end
				if amount == 1 and IsValid(Slot3:GetChildren()[1]) and Slot3:GetChildren()[1].ItemClass == item then continue end
				if amount == 1 and IsValid(Slot4:GetChildren()[1]) and Slot4:GetChildren()[1].ItemClass == item then continue end
				if amount == 1 and IsValid(Slot5:GetChildren()[1]) and Slot5:GetChildren()[1].ItemClass == item then continue end
			
				if !GAMEMODE.DayZ_Items[item].UsedInCrafting then continue end
				
				local GUI_Inv_Item_Panel = vgui.Create("DPanelList", InvHolder)
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
				GUI_Inv_Item_Panel:Droppable("slot")
				GUI_Inv_Item_Panel.ItemClass = GAMEMODE.DayZ_Items[item].ID
				
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
														
				local GUI_Inv_Item_Name = vgui.Create("DLabel", GUI_Inv_Item_Panel)
				GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
				GUI_Inv_Item_Name:SetText(GAMEMODE.DayZ_Items[item].Name)
				GUI_Inv_Item_Name:SetFont("Cyb_Inv_Label")
				GUI_Inv_Item_Name:SizeToContents()
				GUI_Inv_Item_Icon:SetDragParent(GUI_Inv_Item_Panel)
				
				local x,y = surface.GetTextSize(" "..GAMEMODE.DayZ_Items[item].Name.." ")
				
				GUI_Inv_Item_Name:SetPos(5,5)
					
				InvHolder:AddItem(GUI_Inv_Item_Panel)

			end
		end
	end
	UpdateCraftInv()

	local RightPanel = vgui.Create("DPanel", parent)
	RightPanel:SetSize(529, 495)
	RightPanel:SetPos(220, 0)
	RightPanel:SetZPos(1000)
	RightPanel.Paint = function()
		draw.RoundedBox(8,0,0,RightPanel:GetWide(),RightPanel:GetTall(),Color( 30, 30, 30, 0 ))
	end
	
	-- Add inventory slots
	
	Num1 = vgui.Create("DLabel", RightPanel)
	Num1:SetFont("SafeZone_EXCLAMATION")
	Num1:SetText("1")
	Num1:SetPos(25, 5)
	Num1:SetSize(50,90)
	
	Num2 = vgui.Create("DLabel", RightPanel)
	Num2:SetFont("SafeZone_EXCLAMATION")
	Num2:SetText("2")
	Num2:SetPos(125, 5)
	Num2:SetSize(50,90)
	
	Num3 = vgui.Create("DLabel", RightPanel)
	Num3:SetFont("SafeZone_EXCLAMATION")
	Num3:SetText("3")
	Num3:SetPos(225, 5)
	Num3:SetSize(50,90)
	
	Num4 = vgui.Create("DLabel", RightPanel)
	Num4:SetFont("SafeZone_EXCLAMATION")
	Num4:SetText("4")
	Num4:SetPos(325, 5)
	Num4:SetSize(50,90)
	
	Num5 = vgui.Create("DLabel", RightPanel)
	Num5:SetFont("SafeZone_EXCLAMATION")
	Num5:SetText("5")
	Num5:SetPos(425, 5)
	Num5:SetSize(50,90)
	
	Slot1 = vgui.Create("DPanel", RightPanel)
	Slot1:SetSize(100,100)
	Slot1:SetPos(5,5)
	Slot1.Paint = function()
		draw.RoundedBox(8,0,0,Slot1:GetWide(),Slot1:GetTall(),Color( 30, 30, 30, 200 ))
	end
	Slot1:Receiver( "slot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == Slot1 then return end
		if table.Count(Slot1:GetChildren()) > 0 then return end

		tbl[1]:SetSize(95,95)
		tbl[1]:SetPos(2,2)
		tbl[1]:GetChild(1):SetSize(90,90)
		
		tbl[1]:SetParent(Slot1)
		RepopulateCrafts()
	end )
		
	Slot2 = vgui.Create("DPanel", RightPanel)
	Slot2:SetSize(100,100)
	Slot2:SetPos(105,5)
	Slot2.Paint = function()
		draw.RoundedBox(8,0,0,Slot2:GetWide(),Slot2:GetTall(),Color( 30, 30, 30, 200 ))
	end
		
	Slot2:Receiver( "slot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == Slot2 then return end
		if table.Count(Slot2:GetChildren()) > 0 then return end

		tbl[1]:SetSize(95,95)
		tbl[1]:SetPos(2,2)
		tbl[1]:GetChild(1):SetSize(90,90)
				
		tbl[1]:SetParent(Slot2)
		RepopulateCrafts()
	end )
	
	Slot3 = vgui.Create("DPanel", RightPanel)
	Slot3:SetSize(100,100)
	Slot3:SetPos(205,5)
	Slot3.Paint = function()
		draw.RoundedBox(8,0,0,Slot3:GetWide(),Slot3:GetTall(),Color( 30, 30, 30, 200 ))
	end
	Slot3:Receiver( "slot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == Slot3 then return end
		if table.Count(Slot3:GetChildren()) > 0 then return end
		
		tbl[1]:SetSize(95,95)
		tbl[1]:SetPos(2,2)
		tbl[1]:GetChild(1):SetSize(90,90)
		
		tbl[1]:SetParent(Slot3)
		RepopulateCrafts()
	end )

	Slot4 = vgui.Create("DPanel", RightPanel)
	Slot4:SetSize(100,100)
	Slot4:SetPos(305,5)
	Slot4.Paint = function()
		draw.RoundedBox(8,0,0,Slot4:GetWide(),Slot4:GetTall(),Color( 30, 30, 30, 200 ))
	end	
	Slot4:Receiver( "slot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == Slot4 then return end
		if table.Count(Slot4:GetChildren()) > 0 then return end
	
		tbl[1]:SetSize(95,95)
		tbl[1]:SetPos(2,2)
		tbl[1]:GetChild(1):SetSize(90,90)
		
		tbl[1]:SetParent(Slot4)
		RepopulateCrafts()
	end )
		
	Slot5 = vgui.Create("DPanel", RightPanel)
	Slot5:SetSize(100,100)
	Slot5:SetPos(405,5)
	Slot5.Paint = function()
		draw.RoundedBox(8,0,0,Slot5:GetWide(),Slot5:GetTall(),Color( 30, 30, 30, 200 ))
	end
	Slot5:Receiver( "slot", function( pnl, tbl, dropped, menu, x, y )
		if ( !dropped ) then return end
		if tbl[1]:GetParent() == Slot5 then return end
		if table.Count(Slot5:GetChildren()) > 0 then return end
		
		tbl[1]:SetSize(95,95)
		tbl[1]:SetPos(2,2)
		tbl[1]:GetChild(1):SetSize(90,90)
		
		tbl[1]:SetParent(Slot5)
		RepopulateCrafts()
	end )
	
	local Splitter = vgui.Create("DPanel", RightPanel)
	Splitter:SetPos(0, 111)
	Splitter:SetSize(RightPanel:GetWide()-18, 2)
	
	CraftPanel = vgui.Create("DPanelList", RightPanel)
	CraftPanel:SetPos(0, 120)
	CraftPanel:SetSize(RightPanel:GetWide()-18, 375)
	CraftPanel.Paint = function()
		draw.RoundedBox(8,0,0,CraftPanel:GetWide(),CraftPanel:GetTall(),Color( 30, 30, 30, 200 ))
	end
	CraftPanel:EnableVerticalScrollbar(true)
	
end

function ResetSlots()
	if Slot1:GetChildren()[1] then Slot1:GetChildren()[1]:Remove() end
	if Slot2:GetChildren()[1] then Slot2:GetChildren()[1]:Remove() end
	if Slot3:GetChildren()[1] then Slot3:GetChildren()[1]:Remove() end
	if Slot4:GetChildren()[1] then Slot4:GetChildren()[1]:Remove() end
	if Slot5:GetChildren()[1] then Slot5:GetChildren()[1]:Remove() end
end

function RepopulateCrafts()

	CraftPanel:Clear(true)
	CanCrafts = {}
	
	UpdateCraftInv()

	for k, v in pairs(GAMEMODE.DayZ_Items) do
		local cancraft = true
		if v.Craftable and v.ReqCraft then	
				
			if v.ReqCraft.Slot1 != nil then
				if !Slot1:GetChildren()[1] then cancraft = false continue end
				if !(v.ReqCraft.Slot1 == Slot1:GetChildren()[1].ItemClass) then cancraft = false end
			end
			
			if v.ReqCraft.Slot2 != nil then
				if !Slot2:GetChildren()[1] then cancraft = false continue end
				if !(v.ReqCraft.Slot2 == Slot2:GetChildren()[1].ItemClass) then cancraft = false end
			end
			
			if v.ReqCraft.Slot3 != nil then
				if !Slot3:GetChildren()[1] then cancraft = false continue end
				if !(v.ReqCraft.Slot3 == Slot3:GetChildren()[1].ItemClass) then cancraft = false end
			end
			
			if v.ReqCraft.Slot4 != nil then
				if !Slot4:GetChildren()[1] then cancraft = false continue end
				if !(v.ReqCraft.Slot4 == Slot4:GetChildren()[1].ItemClass) then cancraft = false end
			end
			
			if v.ReqCraft.Slot5 != nil then
				if !Slot5:GetChildren()[1] then cancraft = false continue end
				if !(v.ReqCraft.Slot5 == Slot5:GetChildren()[1].ItemClass) then cancraft = false end
			end

			if cancraft then
				table.insert(CanCrafts, k)
			end
		end
	end

	if #CanCrafts > 0 then
		
		for _, craftable in pairs(CanCrafts) do 			
			
			local CraftableItemPanel = vgui.Create("DPanel", CraftPanel)
			CraftableItemPanel:SetSize(94, 94)
			CraftableItemPanel.Paint = function() end
					
			local CraftableItemModelPanel = vgui.Create("DModelPanel", CraftableItemPanel)
			CraftableItemModelPanel:SetSize(90,90)
			CraftableItemModelPanel:SetPos(2,2)
			local PaintModel = CraftableItemModelPanel.Paint
			
			function CraftableItemModelPanel:Paint()
				draw.RoundedBoxEx(4,0,0,CraftableItemModelPanel:GetWide(),CraftableItemModelPanel:GetTall(),Color( 255, 255, 255, 255 ), true, true, true, true)
				draw.RoundedBoxEx(4,1,1,CraftableItemModelPanel:GetWide()-2,CraftableItemModelPanel:GetTall()-2,Color( 0, 0, 0, 255 ), true, true, true, true) 
				
				local spotlight = Material("gui/spotlight.png")
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial( spotlight)
				surface.DrawTexturedRect(0, 0, 97,97)	

			
				local x2, y2 = CraftPanel:LocalToScreen( 0, 0 )
				local w2, h2 = CraftPanel:GetSize()
				render.SetScissorRect( x2, y2, x2 + w2, y2 + h2, true )

				PaintModel( self )
				
				render.SetScissorRect( 0, 0, 0, 0, false )
				
			end
			
			CraftableItemModelPanel:SetModel( GAMEMODE.DayZ_Items[craftable].Model )
			Inv_Icon_ent:SetModel(GAMEMODE.DayZ_Items[craftable].Model)
			--if GAMEMODE.DayZ_Items[item].Material then CraftableItemModelPanel:GetEntity():SetMaterial(GAMEMODE.DayZ_Items[item].Material) end
			CraftableItemModelPanel:SetColor( GAMEMODE.DayZ_Items[craftable].Color or Color(255,255,255,255) )
		
			local center = Inv_Icon_ent:OBBCenter()
			local dist = Inv_Icon_ent:BoundingRadius()*1.2
			CraftableItemModelPanel:SetLookAt(center)
			CraftableItemModelPanel:SetCamPos(center+Vector(dist,dist,0))	
			
			local ItemName = vgui.Create("DLabel", CraftableItemPanel)
			ItemName:SetColor(Color(255,255,255,255))
			ItemName:SetFont("Cyb_Inv_Bar")
			ItemName:SetText(GAMEMODE.DayZ_Items[craftable].Name)
			ItemName:SizeToContents()
			ItemName:SetPos(100,10)
			
			local Description = vgui.Create("DLabel", CraftableItemPanel)
			Description:SetColor(Color(255,255,255,255))
			Description:SetFont("Cyb_Inv_Label")
			Description:SetText(GAMEMODE.DayZ_Items[craftable].Desc)
			Description:SizeToContents()
			Description:SetPos(100,30)
					
			local DoCraft = vgui.Create("DButton", CraftableItemPanel)
			--DoCraft.Paint = function() end
			DoCraft:SetFont("SafeZone_INFO")
			DoCraft:SetText("CRAFT!")
			DoCraft:SetSize(200,40)
			DoCraft:SetPos(100,50)
			DoCraft.DoClick = function()
				
				RunConsoleCommand("CraftItem", craftable)
				
				ResetSlots()
				timer.Simple(0.5, function() -- Wat... Next Frame pls!
					RepopulateCrafts()
					UpdateCraftInv()
					
					UpdateInv()
				end)
				
			end
			
			CraftPanel:AddItem(CraftableItemPanel)
		
		end
	end
end	
