function GUI_Rebuild_Level_Items(parent)
	local Inv_Icon_ent = ents.CreateClientProp("prop_physics")
	Inv_Icon_ent:SetPos(Vector(0,0,-500))
	Inv_Icon_ent:SetNoDraw(true)
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
	
	if GUI_Inv_Item_Panel != nil and GUI_Inv_Item_Panel:IsValid() then
		GUI_Inv_Item_Panel:Clear()
	end
	
		for _, item in pairs(GAMEMODE.DayZ_Unlocks) do
						
			local GUI_Inv_Item_Panel = vgui.Create("DPanelList")
			GUI_Inv_Item_Panel:SetParent(parent)
			
			GUI_Inv_Item_Panel:SetSize(720,130)
			
			GUI_Inv_Item_Panel:SetPos(0,50)
			GUI_Inv_Item_Panel:SetSpacing(5)
			GUI_Inv_Item_Panel.Paint = function()

				draw.RoundedBoxEx(4,0,0,GUI_Inv_Item_Panel:GetWide(),GUI_Inv_Item_Panel:GetTall(),Color( 255, 255, 255, 255 ), true, true, true, true)
				draw.RoundedBoxEx(4,1,1,GUI_Inv_Item_Panel:GetWide()-2,GUI_Inv_Item_Panel:GetTall()-2,Color( 0, 0, 0, 255 ), true, true, true, true) 

				--	draw.RoundedBox(0,0,GUI_Inv_Item_Panel:GetTall()-1,GUI_Inv_Item_Panel:GetWide(),1,Color(0, 0, 0, 100 ))
			--	draw.RoundedBox(0,GUI_Inv_Item_Panel:GetWide()-1,0,1,GUI_Inv_Item_Panel:GetTall(),Color(0, 0, 0, 100 ))										
				
				--draw.RoundedBox(0,1,1,GUI_Inv_Item_Panel:GetWide()-2,GUI_Inv_Item_Panel:GetTall()-2,Color( 255, 133, 97, 55 )) -- inside
			end
		
			local GUI_Inv_Item_Icon = vgui.Create("DModelPanel")
			GUI_Inv_Item_Icon:SetParent(GUI_Inv_Item_Panel)
			GUI_Inv_Item_Icon:SetPos(5,5)
			GUI_Inv_Item_Icon:SetSize(120,120)
			local PaintModel = GUI_Inv_Item_Icon.Paint
			function GUI_Inv_Item_Icon:Paint()
				draw.RoundedBoxEx(4,0,0,GUI_Inv_Item_Icon:GetWide(),GUI_Inv_Item_Icon:GetTall(),Color( 255, 255, 255, 255 ), true, true, true, true)
				draw.RoundedBoxEx(4,1,1,GUI_Inv_Item_Icon:GetWide()-2,GUI_Inv_Item_Icon:GetTall()-2,Color( 0, 0, 0, 255 ), true, true, true, true) 
				
				local spotlight = Material("gui/spotlight.png")
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial( spotlight)
				surface.DrawTexturedRect(0, 0, 128,128)	

			
				local x2, y2 = parent:LocalToScreen( 0, 0 )
				local w2, h2 = parent:GetSize()
				render.SetScissorRect( x2, y2, x2 + w2, y2 + h2, true )

				PaintModel( self )
				
				render.SetScissorRect( 0, 0, 0, 0, false )
				
			end
			GUI_Inv_Item_Panel.ModelPanel = GUI_Inv_Item_Icon


			GUI_Inv_Item_Icon:SetModel(item.Model)
			
			if LocalPlayer():GetNWInt("lvl") >= item.LvlReq then
				GUI_Inv_Item_Icon:SetColor(item.Color or Color(255,255,255,255))
			else
				GUI_Inv_Item_Icon:SetColor(Color(0,0,0,255))
			end
			Inv_Icon_ent:SetModel(item.Model)
			
			if item.Angle != nil then
				GUI_Inv_Item_Icon:GetEntity():SetAngles(item.Angle)
			end
			
			local center = Inv_Icon_ent:OBBCenter()
			local dist = Inv_Icon_ent:BoundingRadius()*1.2
			GUI_Inv_Item_Icon:SetLookAt(center)
			GUI_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
			
			local GUI_Inv_Item_Name = vgui.Create("DLabel", GUI_Inv_Item_Icon)
			GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
			GUI_Inv_Item_Name:SetFont("Cyb_Inv_Label")
			GUI_Inv_Item_Name:SetText(item.Name)
			GUI_Inv_Item_Name:SizeToContents()
				
			GUI_Inv_Item_Name:SetPos(5,100)
			
			if item.Desc != nil then
				local GUI_Inv_Item_Desc = vgui.Create("DLabel")
				GUI_Inv_Item_Desc:SetColor(Color(255,255,255,255))
				GUI_Inv_Item_Desc:SetFont("Cyb_Inv_Bar")			
				GUI_Inv_Item_Desc:SetText(item.Desc)
				GUI_Inv_Item_Desc:SizeToContents()
				GUI_Inv_Item_Desc:SetParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_Desc:SetPos(130 ,30)
			end
			
			local GUI_Inv_Item_LvlReq = vgui.Create("DLabel")
			GUI_Inv_Item_LvlReq:SetColor(Color(255,255,255,255))
			GUI_Inv_Item_LvlReq:SetFont("Cyb_Inv_Bar")			
			GUI_Inv_Item_LvlReq:SetText("Level Req: "..item.LvlReq)
			GUI_Inv_Item_LvlReq:SizeToContents()
			GUI_Inv_Item_LvlReq:SetParent(GUI_Inv_Item_Panel)
			GUI_Inv_Item_LvlReq:SetPos(130 ,80)


							
			parent:AddItem(GUI_Inv_Item_Panel)
			
		end	

	
	Inv_Icon_ent:Remove()
end