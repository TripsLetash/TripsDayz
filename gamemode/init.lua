AddCSLuaFile("shared.lua")
include("shared.lua")

-- Load modules...
local fol = GM.FolderName.."/gamemode/modules/"
local files, folders = file.Find(fol .. "*", "LUA")
for k,v in pairs(files) do
	include(fol .. v)
end

for _, folder in SortedPairs(folders, true) do
	if folder == "." or folder == ".." then continue end

	for _, File in SortedPairs(file.Find(fol .. folder .."/sh_*.lua", "LUA"), true) do
		AddCSLuaFile(fol..folder .. "/" ..File)
		include(fol.. folder .. "/" ..File)
		Msg( "[CyB] DayZ - Loading+Pooling SHARED file: " .. File .. "\n" )
	end

	for _, File in SortedPairs(file.Find(fol .. folder .."/sv_*.lua", "LUA"), true) do
		include(fol.. folder .. "/" ..File)
		Msg( "[CyB] DayZ - Loading SERVER file: " .. File .. "\n" )
	end

	for _, File in SortedPairs(file.Find(fol .. folder .."/cl_*.lua", "LUA"), true) do
		AddCSLuaFile(fol.. folder .. "/" ..File)
		Msg( "[CyB] DayZ - Pooling CLIENT file: " .. File .. "\n" )
	end

end

-- Console Commands
RunConsoleCommand("sv_kickerrornum", "0");