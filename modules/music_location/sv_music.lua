

util.AddNetworkString("ml_musicStart")
util.AddNetworkString("ml_musicStop")

local function ShouldPlayerHear(ply,zone)

	if zone.allowedJobs == nil then return true end
	local plyjob = team.GetName(ply:Team())

	for i,v in ipairs(zone.allowedJobs) do
		if plyjob == v then
			return true
		end
	end
	return false

end


local function FindPlayersInBox( vCorner1, vCorner2, zone )
	local tEntities = ents.FindInBox( vCorner1, vCorner2 )
	local tPlayers = {}

	local iPlayers = 0

	for i = 1, #tEntities do
		if ( tEntities[ i ]:IsPlayer() ) and ShouldPlayerHear(tEntities[i], zone) then
			iPlayers = iPlayers + 1
			tPlayers[ iPlayers ] = tEntities[ i ]
		end
	end

	return tPlayers
end

local function PlayerInTable(table,ply)

	for i,v in ipairs(table) do
		if (v == ply) then
			return true
		end
	end

	return false

end


local function CheckPlyLocations()

	for k,v in ipairs(MusicLocations) do
		local plys = FindPlayersInBox(v.pos1,v.pos2, v)

		for _,c in ipairs(v.playersInside) do

			if not (PlayerInTable(plys,c)) then
				table.remove(v.playersInside, _)
				net.Start("ml_musicStop")
				net.WriteString(v.music)
				net.Send(c)

			end

		end

		for t,l in ipairs(plys) do
			net.Start("ml_musicStart")
			net.WriteString(v.music)
			net.Send(l)

			table.insert(v.playersInside,l)
		end
	end

end


if not (timer.Exists("ml_checkLocations")) then
	timer.Create("ml_checkLocations",1,0, function() CheckPlyLocations() end )
end