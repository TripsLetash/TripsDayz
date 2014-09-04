util.AddNetworkString( "TipSend" )

function PMETA:Tip( icontype, str1, col1, str2, col2 )
	if str1 then
		icontype = icontype or 3
		print(icontype)
		net.Start( "TipSend" )
			net.WriteUInt(icontype, 3)
			net.WriteString( str1 )
			net.WriteTable( col1 or Color(255,255,255,255) )
			net.WriteString( str2 or "" )
			net.WriteTable( col2 or Color(255,255,255,255) )
		net.Send( self )			
	end
end

function TipAll( icontype, str1, col1, str2, col2 )
	if str1 then
		icontype = icontype or 3
		print(icontype)
		net.Start("TipSend")
			net.WriteUInt(icontype, 3)
			net.WriteString( str1 )
			net.WriteTable( col1 or Color(255,255,255,255) )
			net.WriteString( str2 or "" )
			net.WriteTable( col2 or Color(255,255,255,255) )
		net.Broadcast()
	end
end
