---- Weapon switching
local function ForceWeaponSwitch(ply, cmd, args)
   -- Turns out even SelectWeapon refuses to switch to empty guns, gah.
   -- Worked around it by giving every weapon a single Clip2 round.
   -- Works because no weapon uses those.
   local wepname = args[1]
   local wep = ply:GetWeapon(wepname)
   if IsValid(wep) then
      -- Weapons apparently not guaranteed to have this
      if wep.SetClip2 then
         wep:SetClip2(1)
      end
      ply:SelectWeapon(wepname)
   end
end
concommand.Add("wepswitch", ForceWeaponSwitch)
