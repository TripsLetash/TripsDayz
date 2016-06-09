local COLOR_WHITE = Color(255, 255, 255);
local COLOR_BLACK = Color(0, 0, 0);
local COLOR_GREY = Color(210, 210, 210);
local navcol = Color(41, 128, 185, 200);
local zomb = Color(0,255,0,255);
local youblip = Color(41, 128, 185, 225);
local hardRed = Color(180, 70, 70, 255);
local hardOrange = Color(180, 120, 70, 255);
local hardGroup = Color(180, 120, 70, 255);

BountyTable = BountyTable or {}

local CyBMapEnabled = 1
local CyBMapShowZomb = 0
function UpdateCyBMapEnabled(str, old, new)
	CyBMapEnabled = math.floor(new)
end
cvars.AddChangeCallback(CyBConf.MinimapEnabled:GetName(), UpdateCyBMapEnabled)

function UpdateCyBMapShowZomb(str, old, new)
	CyBMapShowZomb = math.floor(new)
end
cvars.AddChangeCallback(CyBConf.MapShowZombies:GetName(), UpdateCyBMapShowZomb)

hook.Add("Initialize", "InitCyBMapEnabled", function()
	CyBMapEnabled = CyBConf.MinimapEnabled:GetInt() or 1
	CyBMapShowZomb = CyBConf.MapShowZombies:GetInt() or 0
end)

local CyBMapMatParams = {
	["$basetexture"] = "hud_trips_dayz/minimap/dz_necro_forest_tripstown",
	["$nodecal"] = 1,
	["$model"] = 1,
	["$additive"] = 1,
	["$nocull"] = 1,
	["$smooth"] = 1
}

local Map = {--Overview: scale 20.00, pos_x -17756, pos_y 9477

	Origin = Vector(-11042, 9140, 0),
	Scale = 20,
	Material = Material("hud_trips_dayz/minimap/dz_necro_forest_tripstown.png", "smooth"),
	Size = 720,
	Cursor = Material("cyb_mat/minimap/cursor.png", "smooth"),
	CursorW = 190,
	CursorH = 190,
	MiniCursor =  Material("cyb_mat/minimap/blip.png", "smooth,nocull"),
	MiniCursorW = 14,
	MiniCursorH = 14,
	RenderMaterial = CreateMaterial("MapMaterial","UnlitGeneric", CyBMapMatParams),
	Target = GetRenderTarget("MapTarget", 720, 720, false)
}

local CyBMap = {
	w = 190,
	h = 190,
	x = ScrW() - 192,
	y = 2,
	InnerRadius = 81,
	Outline = Material("cyb_mat/minimap/minimap_o4.png", "smooth"),
	Background = Material("cyb_mat/minimap/minimap2.png"),
	Cursor =  Material("cyb_mat/minimap/cursor.png", "smooth"),
	Buttons = Material("cyb_mat/minimap/buttons.png", "smooth"),
	CursorArrow = Material("cyb_mat/minimap/cursor_arr.png", "smooth"),
	Material = CreateMaterial("CyBMapMaterial","UnlitGeneric", CyBMapMatParams),
	Target = GetRenderTarget("CyBMapTarget", Map.Size, Map.Size, false)
}

CyBMap.Material:SetTexture("$basetexture", CyBMap.Target)
timer.Simple(0, function() CyBMap.Material:SetTexture("$basetexture", CyBMap.Target) end)
timer.Simple(5, function() CyBMap.Material:SetTexture("$basetexture", CyBMap.Target) end)

Map.RenderMaterial:SetTexture("$basetexture", Map.Target)
timer.Simple(0, function() Map.RenderMaterial:SetTexture("$basetexture", Map.Target) end)
timer.Simple(5, function() Map.RenderMaterial:SetTexture("$basetexture", Map.Target) end)

local function InitPostEntityStupidTextures()
	CyBMap.Material:SetTexture("$basetexture", CyBMap.Target)
	timer.Simple(0, function() CyBMap.Material:SetTexture("$basetexture", CyBMap.Target) end)
	timer.Simple(5, function() CyBMap.Material:SetTexture("$basetexture", CyBMap.Target) end)

	Map.RenderMaterial:SetTexture("$basetexture", Map.Target)
	timer.Simple(0, function() Map.RenderMaterial:SetTexture("$basetexture", Map.Target) end)
	timer.Simple(5, function() Map.RenderMaterial:SetTexture("$basetexture", Map.Target) end)
end
hook.Add("InitPostEntity", "InitPostEntityStupidTextures?", InitPostEntityStupidTextures)

local LineI = 6;
local LineO = 8;

Map.Size2 = Map.Size/2

--Just in case
local math = math
local surface, render, draw, cam = surface, render, draw, cam

local Vector = Vector
local Color = Color
local sqrt = math.sqrt
local STENCIL_ALWAYS, STENCIL_REPLACE, STENCIL_EQUAL = STENCIL_ALWAYS, STENCIL_REPLACE, STENCIL_EQUAL
local deg = math.deg
local atan2 = math.atan2
local Round = math.Round
local Distance = math.Distance
local EyeAngles = EyeAngles

local function WorldToMap(WorldPos)
	local MapPos = Vector(WorldPos.x - Map.Origin.x, WorldPos.y - Map.Origin.y, 0)

	MapPos.x = MapPos.x / Map.Scale
	MapPos.y = MapPos.y / -Map.Scale

	return MapPos
end

local function MapToPanel(MapPos, w, h)
	local panelPos = Vector()

	local offset = Vector()
	offset.x = MapPos.x - 1024/2
	offset.y = MapPos.y - 1024/2

	local scale = 1 / 1024

	offset.x = offset.x * scale
	offset.y = offset.y * scale

	panelPos.x = Map.Size2 + (Map.Size * offset.x) + (w-Map.Size)/3
	panelPos.y = Map.Size2 + (Map.Size * offset.y) + (h-Map.Size)/2

	return panelPos
end

local function MapToMiniPanel(MapPos, w, h)
	local panelPos = Vector()

	local offset = Vector()
	offset.x = MapPos.x - 1024/2
	offset.y = MapPos.y - 1024/2

	local scale = 1 / 1024

	offset.x = offset.x * scale
	offset.y = offset.y * scale

	panelPos.x = Map.Size2 + (Map.Size * offset.x)
	panelPos.y = Map.Size2 + (Map.Size * offset.y)

	return panelPos
end

local function GetPixelOffset(scale)
	local pos2 = WorldToMap(Vector(scale, 0, 0))
	pos2 = MapToPanel(pos2)

	local pos3 = WorldToMap(Vector())
	pos3 = MapToPanel(pos3)

	local a = pos2.y - pos3.y
	local b = pos2.x - pos3.x

	return sqrt((a*a)+(b*b))
end

local lastBandit = 0

local function getBanditRed()
	return Color(hardRed.r, hardRed.g, hardRed.b, lastBandit)
end

function DrawMap()
	local w, h = ScrW(), ScrH()

	surface.SetDrawColor(COLOR_BLACK)
	surface.DrawRect(0, 0, w, h)
	
	local oldRT = render.GetRenderTarget()
	render.SetRenderTarget(Map.Target)
		render.SetViewPort(0, 0, h < Map.Size and h or Map.Size, h < Map.Size and h or Map.Size)	
		render.Clear(0, 0, 0, 255, true) // Floodfill with black color
	 
			cam.Start2D()

			local c = 255 * (CL_Light or 1)
			surface.SetDrawColor(Color(c, c, c))
			surface.SetMaterial(Map.Material)
			surface.DrawTexturedRect(0, 0, h < Map.Size and h or Map.Size, h < Map.Size and h or Map.Size)

			local pos = MapToPanel(WorldToMap(LocalPlayer():GetPos()), h < Map.Size and h or Map.Size, h < Map.Size and h or Map.Size)

			/*
			surface.DrawLine(pos.x-LineO, pos.y-LineO, pos.x+LineO, pos.y+LineO)
			surface.DrawLine(pos.x+LineO, pos.y-LineO, pos.x-LineO, pos.y+LineO)
			surface.SetDrawColor(COLOR_BLACK)
			surface.DrawLine(pos.x-LineI, pos.y-LineI, pos.x+LineI, pos.y+LineI)
			surface.DrawLine(pos.x+LineI, pos.y-LineI, pos.x-LineI, pos.y+LineI)*/

			surface.SetMaterial(Map.Cursor)

			
			if CyBMapShowZomb == 1 then 
				for k, v in pairs( ents.FindInBox(LocalPlayer():GetPos()-Vector(1000, 1000, 100), LocalPlayer():GetPos()+Vector(1000, 1000, 100) ) ) do
					if v:GetClass() == "npc_nb_common" then
						local pos = MapToPanel(WorldToMap( v:GetPos() ), h < Map.Size and h or Map.Size, h < Map.Size and h or Map.Size)
						surface.SetDrawColor(zomb)
						surface.DrawTexturedRect(pos.x - Map.CursorW/2, pos.y - Map.CursorH/2, Map.CursorW, Map.CursorH, v:EyeAngles().yaw-90)
					end
				end
			end
			
			local banditRed = getBanditRed()
			for k, v in pairs(BountyTable) do
				if (v.pid == LocalPlayer():UserID()) then continue end
				local pos = MapToPanel(WorldToMap( v.pos ), h < Map.Size and h or Map.Size, h < Map.Size and h or Map.Size)
				surface.SetDrawColor(banditRed)
				surface.DrawTexturedRect(pos.x - Map.CursorW/2, pos.y - Map.CursorH/2, Map.CursorW, Map.CursorH, v.eyeangles.yaw-90)
			end
						
			surface.SetDrawColor(navcol)
			surface.DrawTexturedRectRotated(pos.x, pos.y, Map.CursorW, Map.CursorH, EyeAngles().yaw-90)
			
			surface.SetMaterial(Map.Material)
			cam.End2D()
		render.SetViewPort(0, 0, w, h)
	render.SetRenderTarget(oldRT)

	if (h < Map.Size) then
		local m = Map.Size / h
		local dw = w / m
		local wmid = (w-dw)/2
		surface.SetDrawColor(COLOR_WHITE)
		surface.SetMaterial(Map.RenderMaterial)
		surface.DrawTexturedRect(dw/2, 0, h, h)
	else
		local wmid = (w-(h < Map.Size and h or Map.Size))/2
		local hmid = (h-(h < Map.Size and h or Map.Size))/2
		surface.SetDrawColor(COLOR_WHITE)
		surface.SetMaterial(Map.RenderMaterial)
		surface.DrawTexturedRect(wmid, hmid, Map.Size, Map.Size)
	end

	/*surface.SetDrawColor(COLOR_WHITE)
	surface.SetMaterial(Map.RenderMaterial)
	local pos = MapToMiniPanel(WorldToMap(LocalPlayer():GetPos()), w, h)
	local mapX, mapY = x2, y2
	DrawRotatedTexture(mapX, mapY, Map.Size, Map.Size, -(EyeAngles().yaw-90), pos.x, pos.y)*/

end

local sin, cos, rad = math.sin, math.cos, math.rad
function GenerateCircle(x ,y, radius, quality)
    local circle = {}
    local tmp = 0
    for i=1, quality do
        tmp = rad(i*360)/quality
        circle[i] = {x = x + cos(tmp)*radius,y = y + sin(tmp)*radius}
    end
    return circle
end

local function DrawRotatedTexture(x, y, w, h, angle, cx, cy, off)
	local off = off or 0
	local vec = Vector(w/2-cx, cy-h/2, 0)
	vec:Rotate(Angle(180, angle, 180))
	surface.DrawTexturedRectRotated(x-vec.x, y+vec.y, w, h, angle)
end

local resCRC = 0
local maskCircle
local function DrawCyBMap()	
	local oldRT = render.GetRenderTarget()
	local w, h = ScrW(), ScrH()
	
	local x2, y2 = CyBMap.x + CyBMap.w/2, CyBMap.y + CyBMap.w/2
	local newResCRC = w * h
	if (newResCRC != resCRC) then
		maskCircle = GenerateCircle(x2, y2, CyBMap.InnerRadius, 50)
	end

	surface.SetDrawColor(COLOR_BLACK)
	surface.DrawPoly(maskCircle)

	surface.SetDrawColor(navcol)
	surface.SetMaterial(CyBMap.Outline)
	surface.DrawTexturedRectRotated(x2, y2, CyBMap.w, CyBMap.h, -EyeAngles().yaw + 90)
	
	render.SetRenderTarget(CyBMap.Target)
	 
		render.SetViewPort(0, 0, h < Map.Size and h or Map.Size, h < Map.Size and h or Map.Size)	
		render.Clear(0, 0, 0, 255, true) // Floodfill with black color
	 
			cam.Start2D()
				local c = 255 * (CL_Light or 1)

				surface.SetDrawColor(Color(c, c, c))
				surface.SetMaterial(Map.Material)
				surface.DrawTexturedRect(0, 0, Map.Size, Map.Size)

				surface.SetMaterial(Map.MiniCursor)
				
				if CyBMapShowZomb == 1 then 
					for k, v in pairs( ents.FindInBox(LocalPlayer():GetPos()-Vector(1000, 1000, 100), LocalPlayer():GetPos()+Vector(1000, 1000, 100) ) ) do
						if v:GetClass() == "npc_nb_common" then
							local pos = MapToMiniPanel(WorldToMap( v:GetPos() ), w, h)
							surface.SetDrawColor(zomb)
							surface.DrawTexturedRect(pos.x - Map.MiniCursorW/2, pos.y - Map.MiniCursorH/2, Map.MiniCursorW, Map.MiniCursorH)
						end
					end
				end
			
				local banditRed = getBanditRed()
				for k, v in pairs(BountyTable) do
					if ( v.pid == LocalPlayer():UniqueID() ) then continue end

					local pos = MapToMiniPanel(WorldToMap( v.pos ), w, h)
					surface.SetDrawColor(banditRed)
					surface.DrawTexturedRect(pos.x - Map.MiniCursorW/2, pos.y - Map.MiniCursorH/2, Map.MiniCursorW, Map.MiniCursorH)
				end
							
				surface.SetMaterial(Map.Material)
			cam.End2D()
	 
		render.SetViewPort(0, 0, w, h)
	 
	render.SetRenderTarget(oldRT)


	render.ClearStencil();
	render.SetStencilEnable(true);
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)
	render.SetStencilReferenceValue(1)
	surface.SetDrawColor(COLOR_BLACK)
	surface.DrawPoly(maskCircle)


	render.SetStencilCompareFunction(STENCIL_EQUAL)

	surface.SetDrawColor(COLOR_WHITE)
	surface.SetMaterial(CyBMap.Material)
	local pos = MapToMiniPanel(WorldToMap(LocalPlayer():GetPos()), w, h)
	local mapX, mapY = x2, y2

	local yoff = h < Map.Size and -(Map.Size-h)/2 or 0

	DrawRotatedTexture(mapX, mapY, Map.Size, Map.Size, -(EyeAngles().yaw-90), pos.x, pos.y, yoff)

	render.SetStencilEnable(false)

	surface.SetMaterial(CyBMap.Cursor)
	surface.SetDrawColor(youblip)
	surface.DrawTexturedRect(CyBMap.x, CyBMap.y, CyBMap.w, CyBMap.h)
	
	surface.SetMaterial(CyBMap.CursorArrow)
	local banditRed = getBanditRed()

	for k, v in pairs(BountyTable) do
		if (v.pid == LocalPlayer():UserID()) then continue end
		local pos1 = MapToMiniPanel(WorldToMap(LocalPlayer():GetPos()))
		local pos2 = MapToMiniPanel(WorldToMap( v.pos ))

		local dist = Round(Distance(pos1.x, pos1.y, pos2.x, pos2.y), 2)

		if (dist >= 85) then
			local ang = deg(atan2(pos2.x - pos1.x, -pos2.y + pos1.y))

			surface.SetDrawColor(banditRed)
			surface.DrawTexturedRectRotated(CyBMap.x + CyBMap.w/2, CyBMap.y + CyBMap.h/2, 14, 190, -(EyeAngles().yaw-90) - ang)--, CyBMap.x, CyBMap.y)
		end
	end
	
end

local LastTableUpdate = 0
local function PaintMap()
	lastBandit = lastBandit - (FrameTime() * 255 / 6)

	if LastTableUpdate < CurTime() then 
	
		BountyTable = {}
		for k, v in pairs(player.GetAll()) do
			if !v:IsValid() then continue end
			if v == LocalPlayer() then continue end
			
			if v:Frags() >= PHDayZ.KillsToBeBounty then
				table.insert(BountyTable, {pid=v:UserID(), pos=v:GetPos(), eyeangles=v:EyeAngles()})
			end
		end
		
		LastTableUpdate = CurTime() + 30
	end
	
	if (not LocalPlayer():Alive()) then return end
	if LocalPlayer().ConnectScreen == true then return end
	if (ShouldDrawMap) then
		DrawMap()
	elseif (CyBMapEnabled == 1) then
		DrawCyBMap()
	end
end
hook.Add("HUDPaint", "PaintMap", PaintMap)