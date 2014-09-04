CyB_ShopToggle = CreateClientConVar("cyb_credshoptoggle", 0, true, false)

local CyBCreditMode = 0
function UpdateCyBCreditMode(str, old, new)
	CyBCreditMode = math.floor(new)
	UpdateShopInv()
	UpdateShopLocalInv()
end
cvars.AddChangeCallback(CyB_ShopToggle:GetName(), UpdateCyBCreditMode)

hook.Add("Initialize", "InitCyB_ShopToggle", function()
	CyBCreditMode = CyB_ShopToggle:GetInt() or 1
end)

net.Receive("ShopTable", function(len)
	local tab = net.ReadTable()
	GAMEMODE.DayZ_Shops["shop_buy"] = tab
end)

function GUI_Rebuild_Shop_Items(parent,shoptype)
	local Inv_Icon_ent = ents.CreateClientProp("prop_physics")
	Inv_Icon_ent:SetPos(Vector(0,0,-500))
	Inv_Icon_ent:SetNoDraw(true)
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
	
	if GUI_Inv_Item_Panel != nil and GUI_Inv_Item_Panel:IsValid() then
		GUI_Inv_Item_Panel:Clear()
	end
	
	if shoptype == "shop_buy" then
	
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
			
			if CyBCreditMode == 1 then
				RunConsoleCommand("BuyItemCredits", tbl[1].ItemClass, 1)
			else			
				RunConsoleCommand("BuyItemMoney", tbl[1].ItemClass, 1)
			end
			
			InvHolder:AddItem(tbl[1])
			timer.Simple(0.5, function() UpdateShopLocalInv() UpdateShopInv() end)
		end )
		
		local ShopHolder = vgui.Create("DPanelList", parent)
		ShopHolder:SetSize(495,210)
		ShopHolder:SetPos(220,0)
		ShopHolder.Paint = function()
			draw.RoundedBox(8,0,0,ShopHolder:GetWide(),ShopHolder:GetTall(),Color( 30, 30, 30, 0 ))
		end
		ShopHolder:SetPadding(7.5)
		ShopHolder:SetSpacing(2)
		ShopHolder:EnableHorizontal(3)
		ShopHolder:EnableVerticalScrollbar(true)

		function UpdateShopLocalInv()
			if !IsValid(InvHolder) then return end
			
			InvHolder:Clear(true)
			
			for item,amount in pairs(Local_Inventory) do
			
				if amount > 0  then
									
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
					GUI_Inv_Item_Panel:Droppable("sellslot")
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
						
					InvHolder:AddItem(GUI_Inv_Item_Panel)

				end
			end
		end
		UpdateShopLocalInv()
		
		function UpdateShopInv()
			if !IsValid(ShopHolder) then return end
			
			ShopHolder:Clear(true)
			
			for _,item in pairs(GAMEMODE.DayZ_Shops["shop_buy"]) do
				local ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
			
				if ItemTable == nil then continue end

				local GUI_Inv_Item_Panel = vgui.Create("DPanelList", ShopHolder)
				GUI_Inv_Item_Panel:SetSize(90,90)
				GUI_Inv_Item_Panel:SetPos(0,0)
				GUI_Inv_Item_Panel:SetSpacing(5)
				GUI_Inv_Item_Panel.Paint = function()

					draw.RoundedBoxEx(4,0,0,GUI_Inv_Item_Panel:GetWide(),GUI_Inv_Item_Panel:GetTall(),Color( 255, 255, 255, 255 ), true, true, true, true)
					draw.RoundedBoxEx(4,1,1,GUI_Inv_Item_Panel:GetWide()-2,GUI_Inv_Item_Panel:GetTall()-2,Color( 0, 0, 0, 255 ), true, true, true, true) 

					local spotlight = Material("gui/spotlight.png")
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial( spotlight )
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
				GUI_Inv_Item_Panel.ItemClass = ItemKey
				
				GUI_Inv_Item_Icon:SetModel(ItemTable.Model)
				Inv_Icon_ent:SetModel(ItemTable.Model)
				if ItemTable.Material then GUI_Inv_Item_Icon:GetEntity():SetMaterial(ItemTable.Material) end
				GUI_Inv_Item_Icon:SetColor(ItemTable.Color or Color(255, 255, 255))
				
				if ItemTable.Angle != nil then
					GUI_Inv_Item_Icon:GetEntity():SetAngles(ItemTable.Angle)
				end

				local center = Inv_Icon_ent:OBBCenter()
				local dist = Inv_Icon_ent:BoundingRadius()*1.2
				
				GUI_Inv_Item_Icon:SetLookAt(center)
				GUI_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))
														
				local GUI_Inv_Item_Name = vgui.Create("DLabel", GUI_Inv_Item_Panel)
				GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
				GUI_Inv_Item_Name:SetText(ItemTable.Name)
				GUI_Inv_Item_Name:SetFont("Cyb_Inv_Label")
				GUI_Inv_Item_Name:SizeToContents()
				GUI_Inv_Item_Icon:SetDragParent(GUI_Inv_Item_Panel)
				
				local x,y = surface.GetTextSize(" "..ItemTable.Name.." ")
				
				GUI_Inv_Item_Name:SetPos(5,5)
				
				
				if CyBCreditMode == 0 then 
					local GUI_Inv_Item_WithMoney = vgui.Create("DLabel")
					GUI_Inv_Item_WithMoney:SetColor(Color(255,255,255,200))
					GUI_Inv_Item_WithMoney:SetFont("Cyb_Inv_Label")
					if ItemTable.Price then
						GUI_Inv_Item_WithMoney:SetText("Buy with $"..ItemTable.Price)
					else
						GUI_Inv_Item_WithMoney:SetText("Why am I for sale?")
					end
					GUI_Inv_Item_WithMoney:SizeToContents()
					GUI_Inv_Item_WithMoney:SetParent(GUI_Inv_Item_Panel)
					GUI_Inv_Item_WithMoney:SetPos(5 ,75)	
				
				else
					
					local GUI_Inv_Item_WithCredits = vgui.Create("DLabel")
					GUI_Inv_Item_WithCredits:SetColor(Color(255,255,255,200))
					GUI_Inv_Item_WithCredits:SetFont("Cyb_Inv_Label")			
					if ItemTable.Credits then
						GUI_Inv_Item_WithCredits:SetText("Buy with ¢"..ItemTable.Credits)
					else
						GUI_Inv_Item_WithCredits:SetText("Unavailable")
					end
					GUI_Inv_Item_WithCredits:SizeToContents()
					GUI_Inv_Item_WithCredits:SetParent(GUI_Inv_Item_Panel)
					GUI_Inv_Item_WithCredits:SetPos(5 ,75)	
				end
									
				ShopHolder:AddItem(GUI_Inv_Item_Panel)

			end
		end
		UpdateShopInv()
			
		local Slot = vgui.Create("DPanel", parent)
		Slot:SetSize(100,100)
		Slot:SetPos(405,245)
		Slot.Paint = function()
			draw.RoundedBox(8,0,0,Slot:GetWide(),Slot:GetTall(),Color( 255, 255, 255, 3 ))
		end	
		Slot:Receiver( "sellslot", function( pnl, tbl, dropped, menu, x, y )
			if ( !dropped ) then return end
			if tbl[1]:GetParent() == Slot then return end
			if table.Count(Slot:GetChildren()) > 0 then return end
			
			if GAMEMODE.DayZ_Items[tbl[1].ItemClass].Price != nil then
				tbl[1]:SetSize(95,95)
				tbl[1]:SetPos(2,2)
				tbl[1]:GetChild(1):SetSize(90,90)
				
				tbl[1]:SetParent(pnl)
				
				RunConsoleCommand("SellItemMoney", tbl[1].ItemClass, 1)
				timer.Simple(0.2, function() UpdateShopLocalInv() Slot:GetChildren()[1]:Remove() end)
			end
		end )
		
		local Num1 = vgui.Create("DImageButton", parent)
		Num1:SetImage("cyb_mat/cyb_profit.png")
		Num1:SetColor(Color(41, 128, 185))
		Num1:SetZPos(-1000)
		Num1:SetPos(425, 265)
		Num1:SetSize(60,60)

		local Checkbox = vgui.Create( "DCheckBoxLabel", parent )
		Checkbox:SetPos( 227, 195 )
		Checkbox:SetText( "Buy with Credits?" ) 
		Checkbox:SetConVar( "cyb_credshoptoggle" )
		Checkbox:SizeToContents()       
	
		return
	end
	
	for _,item in pairs(GAMEMODE.DayZ_Shops[shoptype]) do
		local ItemTable, ItemKey = GAMEMODE.Util:GetItemByID( item )
	
		if ItemTable == nil then continue end
		
		local GUI_Inv_Item_Panel = vgui.Create("DPanelList")
		GUI_Inv_Item_Panel:SetParent(parent)
		
		GUI_Inv_Item_Panel:SetSize(720,120)
		
		GUI_Inv_Item_Panel:SetPos(0,0)
		GUI_Inv_Item_Panel:SetSpacing(5)
		GUI_Inv_Item_Panel.Paint = function()

			draw.RoundedBoxEx(4,0,0,GUI_Inv_Item_Panel:GetWide(),GUI_Inv_Item_Panel:GetTall(),Color( 255, 255, 255, 255 ), true, true, true, true)
			draw.RoundedBoxEx(4,1,1,GUI_Inv_Item_Panel:GetWide()-2,GUI_Inv_Item_Panel:GetTall()-2,Color( 0, 0, 0, 255 ), true, true, true, true) 

			local spotlight = Material("gui/spotlight.png")
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial( spotlight)
			surface.DrawTexturedRect(0, 0, 128,128)	
			
		--	draw.RoundedBox(0,0,GUI_Inv_Item_Panel:GetTall()-1,GUI_Inv_Item_Panel:GetWide(),1,Color(0, 0, 0, 100 ))
		--	draw.RoundedBox(0,GUI_Inv_Item_Panel:GetWide()-1,0,1,GUI_Inv_Item_Panel:GetTall(),Color(0, 0, 0, 100 ))										
			
			--draw.RoundedBox(0,1,1,GUI_Inv_Item_Panel:GetWide()-2,GUI_Inv_Item_Panel:GetTall()-2,Color( 255, 133, 97, 55 )) -- inside
		end

		local GUI_Inv_Item_Icon = vgui.Create("DModelPanel")
		GUI_Inv_Item_Icon:SetParent(GUI_Inv_Item_Panel)
		GUI_Inv_Item_Icon:SetPos(0,0)
		GUI_Inv_Item_Icon:SetSize(120,120)
		local PaintModel = GUI_Inv_Item_Icon.Paint
		function GUI_Inv_Item_Icon:Paint()
			local x2, y2 = parent:LocalToScreen( 0, 0 )
			local w2, h2 = parent:GetSize()
			render.SetScissorRect( x2, y2, x2 + w2, y2 + h2, true )

			PaintModel( self )
			
			render.SetScissorRect( 0, 0, 0, 0, false )

		end
		GUI_Inv_Item_Panel.ModelPanel = GUI_Inv_Item_Icon

		GUI_Inv_Item_Icon:SetModel(ItemTable.Model)
		
		GUI_Inv_Item_Icon:SetColor(ItemTable.Color or Color(255,255,255,255))
		Inv_Icon_ent:SetModel(ItemTable.Model)
		
		if ItemTable.Angle != nil then
			GUI_Inv_Item_Icon:GetEntity():SetAngles(ItemTable.Angle)
		end
		
		local center = Inv_Icon_ent:OBBCenter()
		local dist = Inv_Icon_ent:BoundingRadius()*1.2
		GUI_Inv_Item_Icon:SetLookAt(center)
		GUI_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
				
		local GUI_Inv_Item_Name = vgui.Create("DLabel")
		GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
		GUI_Inv_Item_Name:SetFont("Cyb_Inv_Bar")			
		GUI_Inv_Item_Name:SetText(ItemTable.Name)
		GUI_Inv_Item_Name:SizeToContents()
		GUI_Inv_Item_Name:SetParent(GUI_Inv_Item_Panel)
		GUI_Inv_Item_Name:SetPos(125 ,10)	
		
		
		if ItemTable.Desc != nil then
			local GUI_Inv_Item_Desc = vgui.Create("DLabel")
			GUI_Inv_Item_Desc:SetColor(Color(255,255,255,255))
			GUI_Inv_Item_Desc:SetFont("Cyb_Inv_Label")			
			GUI_Inv_Item_Desc:SetText(ItemTable.Desc)
			GUI_Inv_Item_Desc:SizeToContents()
			GUI_Inv_Item_Desc:SetParent(GUI_Inv_Item_Panel)
			GUI_Inv_Item_Desc:SetPos(125 ,30)
		end
		
		if ItemTable.ClipSize != nil then
			local GUI_Inv_Item_Clip = vgui.Create("DLabel")
			GUI_Inv_Item_Clip:SetColor(Color(150,0,0,255))
			GUI_Inv_Item_Clip:SetFont("Cyb_Inv_Label")			
			GUI_Inv_Item_Clip:SetText("Clip Size: "..ItemTable.ClipSize)
			GUI_Inv_Item_Clip:SizeToContents()
			GUI_Inv_Item_Clip:SetParent(GUI_Inv_Item_Panel)
			GUI_Inv_Item_Clip:SetPos(125 ,45)
		end
		
		if ItemTable.Weight != nil then
			local GUI_Inv_Item_Clip = vgui.Create("DLabel")
			GUI_Inv_Item_Clip:SetColor(Color(255,255,255,255))
			GUI_Inv_Item_Clip:SetFont("Cyb_Inv_Label")			
			GUI_Inv_Item_Clip:SetText("Weight: "..ItemTable.Weight)
			GUI_Inv_Item_Clip:SizeToContents()
			GUI_Inv_Item_Clip:SetParent(GUI_Inv_Item_Panel)
			GUI_Inv_Item_Clip:SetPos(125 ,65)
		end
						
		if ItemTable.Price != nil then
			if (ItemTable.ClipSize and !LocalPlayer():IsVIP()) then 
				local GUI_Inv_Item_VIPOnly = vgui.Create("DLabel")
				GUI_Inv_Item_VIPOnly:SetColor(Color(255,255,255,200))
				GUI_Inv_Item_VIPOnly:SetFont("Cyb_Inv_Label")			
				GUI_Inv_Item_VIPOnly:SetText("Purchasing Ammo is VIP Only!")
				GUI_Inv_Item_VIPOnly:SizeToContents()
				GUI_Inv_Item_VIPOnly:SetParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_VIPOnly:SetPos(545 ,95)		
			else
				local GUI_Inv_Item_WithMoney = vgui.Create("DLabel")
				GUI_Inv_Item_WithMoney:SetColor(Color(255,255,255,200))
				GUI_Inv_Item_WithMoney:SetFont("Cyb_Inv_Label")			
				GUI_Inv_Item_WithMoney:SetText("Buy with $"..ItemTable.Price..":")
				GUI_Inv_Item_WithMoney:SizeToContents()
				GUI_Inv_Item_WithMoney:SetParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_WithMoney:SetPos(585 ,50)	
				
				local GUI_Inv_Item_Buy_Money = vgui.Create("DImageButton")
				GUI_Inv_Item_Buy_Money:SetParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_Buy_Money:SetPos(680,35)
				GUI_Inv_Item_Buy_Money:SetSize(32,32)
				GUI_Inv_Item_Buy_Money:SetImage("cyb_mat/cyb_cart.png")
				
				GUI_Inv_Item_Buy_Money.Think = function()
					if GUI_Inv_Item_Buy_Money.Hovered then
						GUI_Inv_Item_Buy_Money:SetColor(CyB.iconHighlight)
					else
						GUI_Inv_Item_Buy_Money:SetColor(CyB.iconNormal)
					end
				end
				

				GUI_Inv_Item_Buy_Money.DoClick = function()
					RunConsoleCommand("BuyItemMoney", ItemKey, 1)
				end
				
				if Local_Inventory[ItemKey] != nil and Local_Inventory[ItemKey] > 0 then
					local SGUI_Inv_Item_WithMoney = vgui.Create("DLabel")
					SGUI_Inv_Item_WithMoney:SetColor(Color(255,255,255,200))
					SGUI_Inv_Item_WithMoney:SetFont("Cyb_Inv_Label")			
					SGUI_Inv_Item_WithMoney:SetText("Sell for $"..(math.Round(ItemTable.Price/10))..":")
					SGUI_Inv_Item_WithMoney:SizeToContents()
					SGUI_Inv_Item_WithMoney:SetParent(GUI_Inv_Item_Panel)
					SGUI_Inv_Item_WithMoney:SetPos(125 ,100)	
					
					local GUI_Inv_Item_Sell_Money = vgui.Create("DImageButton")
					GUI_Inv_Item_Sell_Money:SetParent(GUI_Inv_Item_Panel)
					GUI_Inv_Item_Sell_Money:SetPos(206,80)
					GUI_Inv_Item_Sell_Money:SetSize(32,32)
					GUI_Inv_Item_Sell_Money:SetImage("cyb_mat/cyb_cart.png")
					
					GUI_Inv_Item_Sell_Money.Think = function()
						if GUI_Inv_Item_Sell_Money.Hovered then
							GUI_Inv_Item_Sell_Money:SetColor(CyB.iconHighlight)
						else
							GUI_Inv_Item_Sell_Money:SetColor(CyB.iconNormal)
						end
					end
						
					GUI_Inv_Item_Sell_Money.DoClick = function()
						RunConsoleCommand("SellItemMoney", ItemKey, 1)
					end
				end
				
			end
		end
				
		
		if ItemTable.Credits != nil then							
				local GUI_Inv_Item_WithCredits = vgui.Create("DLabel")
				GUI_Inv_Item_WithCredits:SetColor(Color(255,255,255,200))
				GUI_Inv_Item_WithCredits:SetFont("Cyb_Inv_Label")			
				GUI_Inv_Item_WithCredits:SetText("Buy with ¢"..ItemTable.Credits..":")
				GUI_Inv_Item_WithCredits:SizeToContents()
				GUI_Inv_Item_WithCredits:SetParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_WithCredits:SetPos(585 ,95)	

			
				local GUI_Inv_Item_Buy_Credits = vgui.Create("DImageButton")
				GUI_Inv_Item_Buy_Credits:SetParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_Buy_Credits:SetPos(680,80)
				GUI_Inv_Item_Buy_Credits:SetSize(32,32)
				GUI_Inv_Item_Buy_Credits:SetText("")
				GUI_Inv_Item_Buy_Credits:SetImage("cyb_mat/cyb_cartfull.png")
				GUI_Inv_Item_Buy_Credits.Think = function()
					if GUI_Inv_Item_Buy_Credits.Hovered then
						GUI_Inv_Item_Buy_Credits:SetColor(CyB.iconHighlight)
					else
						GUI_Inv_Item_Buy_Credits:SetColor(CyB.iconNormal)
					end
				end
				
											
				GUI_Inv_Item_Buy_Credits.DoClick = function()
					RunConsoleCommand("BuyItemCredits", ItemKey, 1)
				end					
								
		end
		parent:AddItem(GUI_Inv_Item_Panel)

	end	
end