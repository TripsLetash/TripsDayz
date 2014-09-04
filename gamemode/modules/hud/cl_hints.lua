local XpAddInc = false
local XPPos = 0
local TipPos = 0
local XP_Amount = 0

local MoneyAddInc = false
local MoneyPos = 0
local Money_Amount = 0
local LevelDesc = ""

local LevelUpInc = false
local LevelUpAlpha = 0
local LevelUpAlpha2 = 0

function HINTPaint()
	if LocalPlayer():IsValid() then
	
		if XpAddInc == true then -- XP Awarded
			if XPPos < 200 then
				XPPos = XPPos + 3
			end
		else
			if XPPos > 0 then
				XPPos = XPPos - 3
			end
		end
		
		draw.RoundedBox(0,ScrW()-XPPos,ScrH()/4,200,35,Color( 0, 0, 0, 155 ))	-- XP Award BG	
		draw.DrawText("+"..XP_Amount.."XP Awarded", "Trebuchet24", ScrW()-(XPPos-15), (ScrH()/4)+6, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)		
		
		if MoneyAddInc == true then -- XP Awarded
			if MoneyPos < 255 then
				MoneyPos = MoneyPos + 3
			end
		else
			if MoneyPos > 0 then
				MoneyPos = MoneyPos - 3
			end
		end
		
		draw.RoundedBox(0,0,ScrH()/1.5,200,35,Color( 0, 0, 0, MoneyPos-100 ))	-- XP Award BG	
		draw.DrawText("$"..Money_Amount.." Picked up", "Trebuchet24", 25, (ScrH()/1.5)+6, Color(255, 255, 255, MoneyPos),TEXT_ALIGN_LEFT)

		-- Levelling up.		
		if LevelUpInc == true then -- Level up
			if LevelUpAlpha < 255 then
				LevelUpAlpha = LevelUpAlpha + 1
			end
		else
			if LevelUpAlpha > 0 then
				LevelUpAlpha = LevelUpAlpha - 1
			end
		end
		draw.RoundedBox(0,0,(ScrH()/2)-25,ScrW(),50,Color( 0, 0, 0, LevelUpAlpha-100 ))		
		draw.SimpleTextOutlined( "Level Up!", "TargetIDLarge", ScrW()/2, ScrH()/2, Color(77, 67, 57, LevelUpAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(255,255,255,LevelUpAlpha) )			
	
		if LevelUpInc2 == true then -- Level up
			if LevelUpAlpha2 < 255 then
				LevelUpAlpha2 = LevelUpAlpha2 + 1
			end
		else
			if LevelUpAlpha2 > 0 then
				LevelUpAlpha2 = LevelUpAlpha2 - 1
			end
		end
		draw.RoundedBox(0,0,(ScrH()/2)+25,ScrW(),50,Color( 0, 0, 0, LevelUpAlpha2-100 ))		
		draw.SimpleTextOutlined( "UNLOCKED: "..LevelDesc, "TargetIDLarge", ScrW()/2, ScrH()/2+50, Color(77, 67, 57, LevelUpAlpha2), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(255,255,255,LevelUpAlpha2) )			

		
	end
end
hook.Add( "HUDPaint", "PaintOurHint", HINTPaint );

net.Receive( "net_XPAward", function(len)
	XP_Amount = net.ReadFloat()
	
	XpAddInc = true
	timer.Simple(4, function() 
		XpAddInc = false
	end )		
end)
--usermessage.Hook( "XPAward_CL", XPAward_CL );

function Money_CL(len)
	Money_Amount = net.ReadFloat()
	MoneyAddInc = true
	timer.Simple(4, function() 
		MoneyAddInc = false
	end )		
end
net.Receive("net_Money", Money_CL)

net.Receive( "net_LevelUp", function(len)
	LevelUpInc = true
	timer.Simple(6, function() 
		LevelUpInc = false
	end )		
end)

net.Receive( "net_AddUnlock", function(len)
	LevelDesc = net.ReadString() or ""
	LevelUpInc2 = true
	timer.Simple(6, function() 
		LevelUpInc2 = false
	end )		
end)

local TipPanels = {} -- Stacker table.
net.Receive("TipSend", function(len)
	
	local icontype = net.ReadUInt(3)
	local str1 = net.ReadString()
	local col1 = net.ReadTable()
	local str2 = net.ReadString()
	local col2 = net.ReadTable()

	print( "Notify: "..str1.." "..str2 )

	surface.SetFont("Cyb_HudTEXT")
	local s1 = surface.GetTextSize( str1 )
	local s2 = surface.GetTextSize( str2 )
	
	local tippanel = vgui.Create("DPanel")
	tippanel:SetSize( s1 + s2 + 100, 64 )
	tippanel:SetPos( ScrW() - ( s1 + s2 + 120 ), ScrH() )
	local pos = table.Count(TipPanels) * 70
	tippanel:MoveTo( ScrW() - ( s1 + s2 + 120 ), ScrH() - 150 - pos, 0.5, 0, -10, nil)
	table.insert(TipPanels, tippanel)
	
	tippanel:MoveTo( ScrW(), ScrH() - 150 - pos, 0.5, 5, -1, function(data, self) 
		if IsValid(self) then 
			table.RemoveByValue(TipPanels, self) 
			self:Remove() 
		end 
	end )
	
	tippanel.Paint = function(self)
		col1 = col1 or Color( 255, 255, 255, 255 )
		col2 = col2 or Color( 255, 255, 255, 255 )

		draw.RoundedBox( 8 , 0, 7, self:GetWide(), 50, Color( 48, 49, 54, 155 ) )
		draw.SimpleText( str1, "Cyb_HudTEXT", 80, 32, col1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		if str2 != "" then
			draw.SimpleText( " "..str2, "Cyb_HudTEXT", 80 + s1, 32, col2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
	end
		
	local tipicon = vgui.Create("DImage", tippanel)
	tipicon:SetMaterial(PHDayZ.TipIcons[icontype])
	tipicon:SetSize(64,64)
	
end)
