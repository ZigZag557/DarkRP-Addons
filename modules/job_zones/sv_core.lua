

local function IsPlayerInBox(ply,pos1,pos2)
	local ents = ents.FindInBox(pos1,pos2)
	for i=1,#ents do
		if ents[i] == ply then
			return true
		end
	end

	return false
end

local function canPlayerChangeTeam(ply,job)
	local t = JobZones
	local team = team.GetName(job)
	local pos = ply:GetPos()

	if table.HasValue(t.Jobs, team) then
		for i,v in ipairs(t.Zones) do
			if table.HasValue(v.jobs, team) then
				if not IsPlayerInBox(ply,v.pos1,v.pos2) then
					return false
				end
			end
		end
	end

	return true
end


hook.Add("playerCanChangeTeam","shouldChangeTeam_isinZone", 
	function(ply,team,force) 
		if not canPlayerChangeTeam(ply,team) then
			return false,"You can not change your job here!"
		end end)
