-- we need our own weapon switcher because the hl2 one skips empty weapons

local math = math
local draw = draw
local surface = surface
local table = table

WSWITCH = {}

WSWITCH.Show = false
WSWITCH.Selected = -1
WSWITCH.NextSwitch = -1
WSWITCH.WeaponCache = {}

WSWITCH.cv = {}
WSWITCH.cv.stay = CreateConVar("cyb_weaponswitcher_stay", "0", FCVAR_ARCHIVE)
WSWITCH.cv.fast = CreateConVar("cyb_weaponswitcher_fast", "0", FCVAR_ARCHIVE)

local delay = 0.075
local showtime = 3

local margin = 20
local width = 300
local height = 25

local barcorner = surface.GetTextureID( "gui/corner8" )

local col_active = {
   tip = {
      [1]  = Color(55, 170, 50, 255), -- hero
      [2]   = Color(127, 127, 127, 255), -- neutral
      [3] = Color(255, 127, 0, 255), -- bandit
      [4] = Color(255, 0, 0, 255), -- bounty
   },

   bg = Color(20, 20, 20, 250),

   text_empty = Color(200, 20, 20, 255),
   text = Color(255, 255, 255, 255),

   shadow = 255
};

local col_dark = {
   tip = {
	  [1]  = Color(55, 170, 50, 155), -- hero
      [2]   = Color(127, 127, 127, 155), -- neutral
      [3] = Color(255, 127, 0, 155), -- bandit
      [4] = Color(255, 0, 0, 155), -- bounty
   },

   bg = Color(20, 20, 20, 200),

   text_empty = Color(200, 20, 20, 100),
   text = Color(255, 255, 255, 100),

   shadow = 100
};

-- Draw a bar in the style of the the weapon pickup ones
local round = math.Round
local gradient = Material("gui/gradient")
function WSWITCH:DrawBarBg(x, y, w, h, col, selected)
   local rx = round(x - 4)
   local ry = round(y - (h / 2)-4)
   local rw = round(w + 9)
   local rh = round(h + 8)

   local b = 8 --bordersize
   local bh = b / 2

   local role = 2
   
   if LocalPlayer():Frags() >= PHDayZ.KillsToBeBounty then
		role = 4
   elseif LocalPlayer():Frags() >= PHDayZ.KillsToBeBandit then
		role = 3
   elseif (LocalPlayer():GetNWBool("friendly") and LocalPlayer():Frags() < 1) then
		role = 1 
   end
   
   local diamondcol = Color(255,255,255,20)
   local fullbright = Color(255,255,255,255)
   
   surface.SetMaterial(gradient)
   if selected then
	surface.SetDrawColor(fullbright)
   else
	surface.SetDrawColor(diamondcol)
   end
   
   surface.DrawTexturedRectRotated( (rx+b+h-4) +111, ry-2,  (rw - (h - 4) - b*2) *1.5,  2, 180 )
   surface.DrawTexturedRectRotated( (rx+b+h-4) +111, ry+34,  (rw - (h - 4) - b*2) *1.5,  2, 180 )


   

   surface.SetMaterial(gradient)
    local weps = self.WeaponCache

	c = col.bg
      if selected then
         c = col.tip[role]
      end
   
   
   surface.SetDrawColor(c.r, c.g, c.b, c.a)
   surface.DrawTexturedRectRotated( (rx+b+h-4) +111, ry  +16,  (rw - (h - 4) - b*2) *1.5,  rh, 180 )


end

function WSWITCH:DrawWeapon(x, y, c, wep)
   if not IsValid(wep) then return false end

   local name = (wep.PrintName)
   local cl1, am1 = 0, 0
   if wep:GetClass() == "weapon_physgun" then
		cl1, am1 = -1, -1
		wep.Slot = 0
		wep.PrintName = "Anti-Faggot Gun"
   else
		cl1, am1 =  wep:Clip1(), wep:Ammo1()
   end
   local ammo = false

   -- Clip1 will be -1 if a melee weapon
   -- Ammo1 will be false if weapon has no owner (was just dropped)
   if cl1 != -1 and am1 != false then
      ammo = Format("%i + %02i", cl1, am1)
   end

   -- Slot
   local spec = {text=wep.Slot+1, font="Cyb_HudTEXT", pos={x+4, y}, yalign=TEXT_ALIGN_CENTER, color=c.text}
   draw.TextShadow(spec, 1, c.shadow)

   -- Name
   spec.text  = name
   spec.font  = "Cyb_HudTEXT"
   spec.pos[1] = x + 10 + height
   draw.Text(spec)

   if ammo then
      local col = c.text

      if wep:Clip1() == 0 and wep:Ammo1() == 0 then
         col = c.text_empty
      end

      -- Ammo
      spec.text   = ammo
      spec.pos[1] = (ScrW() - margin*3) +50
      spec.xalign = TEXT_ALIGN_RIGHT
      spec.color  = col
      draw.Text(spec)
   end

   return true
end

function WSWITCH:Draw(client)
   if not self.Show then return end

   local weps = self.WeaponCache

   local x = ScrW() - width - margin*2
   WSWITCH.y = ScrH() - (#weps * (height + margin)) +20
   y = ScrH() - (#weps * (height + margin)) +20

   local col = col_dark
   for k, wep in pairs(weps) do
      if self.Selected == k then
         col = col_active
      else
         col = col_dark
      end

      self:DrawBarBg(x, y, width, height, col, self.Selected == k)
      if not self:DrawWeapon(x, y, col, wep) then
         
         self:UpdateWeaponCache()
         return
      end

      y = y + height + margin
   end
end

local function SlotSort(a, b)
   return a and b and a.Slot and b.Slot and a.Slot < b.Slot
end

local function CopyVals(src, dest)
   table.Empty(dest)
   for k, v in pairs(src) do
      if IsValid(v) then
         table.insert(dest, v)
      end
   end   
end

function WSWITCH:UpdateWeaponCache()
   -- GetWeapons does not always return a proper numeric table it seems
   --   self.WeaponCache = LocalPlayer():GetWeapons()
   -- So copy over the weapon refs
   self.WeaponCache = {}
   CopyVals(LocalPlayer():GetWeapons(), self.WeaponCache)

   table.sort(self.WeaponCache, SlotSort)
end

function WSWITCH:SetSelected(idx)
   self.Selected = idx

   self:UpdateWeaponCache()
end

function WSWITCH:SelectNext()
   if self.NextSwitch > CurTime() then return end
   self:Enable()

   local s = self.Selected + 1
   if s > #self.WeaponCache then
      s = 1
   end

   self:DoSelect(s)

   self.NextSwitch = CurTime() + delay
end

function WSWITCH:SelectPrev()
   if self.NextSwitch > CurTime() then return end
   self:Enable()

   local s = self.Selected - 1
   if s < 1 then
      s = #self.WeaponCache
   end

   self:DoSelect(s)

   self.NextSwitch = CurTime() + delay
end

-- Select by index
function WSWITCH:DoSelect(idx)
   self:SetSelected(idx)

   if self.cv.fast:GetBool() then
      -- immediately confirm if fastswitch is on
      self:ConfirmSelection()
   end   
end

-- Numeric key access to direct slots
function WSWITCH:SelectSlot(slot)
   if not slot then return end

   self:Enable()

   self:UpdateWeaponCache()

   slot = slot - 1

   -- find which idx in the weapon table has the slot we want
   local selectNextMatch, firstInSlot = false, nil
   local toselect = self.Selected
   
   for k, w in ipairs(self.WeaponCache) do
	
      if w.Slot == slot then
		 if self.WeaponCache[self.Selected].Slot == slot then
		     if firstInSlot==nil then firstInSlot = k end --In case our selection is last in the slot, we can revert to the first
			 
			 if k==self.Selected then selectNextMatch = true continue end
		     if selectNextMatch then
			    toselect = k
				break
			 end
		 else
			 toselect = k
			 break
		 end
      end
	  
   end
   
   toselect = toselect==self.Selected and firstInSlot or toselect -- Select firstInSlot if we've got one and still have our current selection marked
   
   self:DoSelect(toselect)

   self.NextSwitch = CurTime() + delay
end

-- Show the weapon switcher
function WSWITCH:Enable()
   if self.Show == false then
      self.Show = true

      local wep_active = LocalPlayer():GetActiveWeapon()

      self:UpdateWeaponCache()

      -- make our active weapon the initial selection
      local toselect = 1
      for k, w in pairs(self.WeaponCache) do
         if w == wep_active then
            toselect = k
            break
         end
      end
      self:SetSelected(toselect)
   end

   -- cache for speed, checked every Think
   self.Stay = self.cv.stay:GetBool()
end

-- Hide switcher
function WSWITCH:Disable()
   self.Show = false
end

-- Switch to the currently selected weapon
function WSWITCH:ConfirmSelection()
   self:Disable()

   for k, w in pairs(self.WeaponCache) do
      if k == self.Selected and IsValid(w) then
         RunConsoleCommand("wepswitch", w:GetClass())
         return
      end
   end   
end

function WSWITCH:Think()
   if (not self.Show) or self.Stay then return end

   -- hide after period of inaction
   if self.NextSwitch < (CurTime() - showtime) then
      self:Disable()
   end
end

-- Instantly select a slot and switch to it, without spending time in menu
function WSWITCH:SelectAndConfirm(slot)
   if not slot then return end
   WSWITCH:SelectSlot(slot)
   WSWITCH:ConfirmSelection()
end

local function QuickSlot(ply, cmd, args)
   if (not IsValid(ply)) or (not args) or #args != 1 then return end

   local slot = tonumber(args[1])
   if not slot then return end

   local wep = ply:GetActiveWeapon()
   if IsValid(wep) then
      if wep.Slot == (slot - 1) then
         RunConsoleCommand("lastinv")
      else
         WSWITCH:SelectAndConfirm(slot)
      end
   end   
end
concommand.Add("cyb_quickslot", QuickSlot)


local function SwitchToEquipment(ply, cmd, args)
   RunConsoleCommand("cyb_quickslot", tostring(7))
end
concommand.Add("cyb_equipswitch", SwitchToEquipment)