util.AddNetworkString( "OOCChat" )
util.AddNetworkString( "LocalChat" )
util.AddNetworkString( "TradeChat" )

function GM:PlayerSay( ply, text, team, is_dead )
	
	local name = ply:Name()
	local pentid = ply:EntIndex()
	
	if (string.find( string.lower(text),"/g " ) == 1) or (string.find( string.lower(text),"// " ) == 1) then
		
		net.Start("OOCChat")
			net.WriteFloat(pentid)	
			net.WriteString(string.sub(text,4))					
		net.Broadcast()
		
		print("GLOBAL: "..ply:Nick()..": "..string.sub(text,4))
		
	elseif (string.find( string.lower(text),"/t " ) == 1) or (string.find( string.lower(text),"/trade " ) == 1) then
		
		net.Start("TradeChat")
			net.WriteFloat(pentid)	
			net.WriteString(string.sub(text,4))					
		net.Broadcast()
		
		print("TRADE: "..ply:Nick()..": "..string.sub(text,4))
	
	else --local chat / emotes
			
		for k, v in pairs(ents.FindInSphere(ply:GetPos(), 600)) do 
			if !v:IsPlayer() then continue end
			net.Start("LocalChat")
				net.WriteFloat(pentid)	
				net.WriteString(text)
			net.Send(v)
		end
		
		print("Proximity: "..ply:Nick()..": "..text)	
	end
	
	return false
end