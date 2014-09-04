local ver = "1.064"
local showInitialMessage = true
local White, Green, Blue = Color(255, 255, 255, 255), Color(150, 255, 150, 255), Color(114, 222, 255, 255)

local function SWB_InitPostEntity()
	if showInitialMessage then
		--timer.Simple(10, function()
			local ply = LocalPlayer()
			chat.AddText(White, "This server is using ", Green, "Sleek Weapon Base ", White, "version ", Blue, ver, White, ".")
			
			if ply:IsAdmin() then
				chat.AddText(White, "In case you're the server owner - be sure to check the coderhire page once in a while for updates.")
			end
		--end)
	end
end

hook.Add("InitPostEntity", "SWB_InitPostEntity", SWB_InitPostEntity)