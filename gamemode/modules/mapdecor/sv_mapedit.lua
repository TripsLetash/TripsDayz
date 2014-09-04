hook.Add("InitPostEntity", "DayZLockDoors", function()
	for k, v in pairs(ents.GetAll()) do
		if v:MapCreationID() == 4361 then v:Fire("lock", "", 0) end
		if v:MapCreationID() == 1256 then v:Fire("open", "", 0) end
		if v:MapCreationID() == 1257 then v:Fire("open", "", 0) end
		if v:MapCreationID() == 1281 then v:Fire("open", "", 0) end
	end
end)