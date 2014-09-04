include( 'shared.lua' )

-- Load modules..
local function LoadModules()
	local root = GM.FolderName.."/gamemode/modules/"

	local _, folders = file.Find(root.."*", "LUA")

	for _, folder in SortedPairs(folders, true) do

		for _, File in SortedPairs(file.Find(root .. folder .."/sh_*.lua", "LUA"), true) do
			include(root.. folder .. "/" ..File)
			Msg( "[CyB] DayZ - Loading SHARED file: " .. File .. "\n" )
		end
		for _, File in SortedPairs(file.Find(root .. folder .."/cl_*.lua", "LUA"), true) do
			include(root.. folder .. "/" ..File)
			Msg( "[CyB] DayZ - Loading CLIENT file: " .. File .. "\n" )
		end
	end
end

LoadModules()
print("[CyB] DayZ - Loaded cl_init.lua!")