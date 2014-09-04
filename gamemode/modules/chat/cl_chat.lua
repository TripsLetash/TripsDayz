net.Receive("OOCChat", function(len)
	ChatPlayer = player.GetByID(net.ReadFloat())
	
	if !ChatPlayer:IsValid() then return end
	
	chat.PlaySound()
	
	local color = Color(150, 0, 0)
	if ChatPlayer:IsUserGroup("vip") then
		color = Color(0, 0, 255) 
	elseif ChatPlayer:IsAdmin() then
		color = Color(0, 255, 0)
	end

	
	chat.AddText( color, ChatPlayer, Color( 125, 125, 125 ), "[Global]", Color( 200,200,200 ), ": " .. net.ReadString())
end)

net.Receive("LocalChat", function(len)
	ChatPlayer = player.GetByID(net.ReadFloat())
	
	if !ChatPlayer:IsValid() then return end
		
	chat.PlaySound()
		
	local color = Color(150, 0, 0)
	if ChatPlayer:IsUserGroup("vip") then
		color = Color(0, 0, 255) 
	elseif ChatPlayer:IsAdmin() then
		color = Color(0, 255, 0)
	end
	
	chat.AddText( color, ChatPlayer, Color( 255, 255, 255 ), "[Proximity]", Color( 200,200,200 ), ": " .. net.ReadString())
end)

net.Receive("TradeChat", function(len)
	ChatPlayer = player.GetByID(net.ReadFloat())
	
	if !ChatPlayer:IsValid() then return end
		
	chat.PlaySound()
		
	local color = Color(150, 0, 0)
	if ChatPlayer:IsUserGroup("vip") then
		color = Color(0, 0, 255) 
	elseif ChatPlayer:IsAdmin() then
		color = Color(0, 255, 0)
	end
	
	chat.AddText( color, ChatPlayer, Color( 255, 150, 50 ), "[Trade]", Color( 200,200,200 ), ": " .. net.ReadString())
end)