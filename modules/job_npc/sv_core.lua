
local ply = FindMetaTable("Player")

if not sql.TableExists("PlayerJobTests") then
	sql.Query([[
	CREATE TABLE PlayerJobTests (
		Steam Varchar(35),
		Job Varchar(50)
	)]])
end


function ply:JobTestsAddSQL(job)


	if sql.Query("SELECT Job FROM PlayerJobTests WHERE Steam = '"..self:SteamID().."' and Job = '"..job.."'") == nil then
		sql.Query("INSERT INTO PlayerJobTests VALUES('"..self:SteamID().."','"..job.."')")
	end
end

function ply:CheckIfCompletedTest(jobID)

	local job = team.GetName(jobID)

	if JobNPCQuestions[job] == nil then return true end

	if sql.Query("SELECT Job FROM PlayerJobTests WHERE Steam = '"..self:SteamID().."' and Job = '"..job.."'") == nil then
		return false
	else
		return true
	end
end

function ply:GetTestedJobs()

	local t = sql.Query("SELECT job FROM PlayerJobTests WHERE Steam = '"..self:SteamID().."'")
	if t == nil then return t end

	local rTable = {}

	for i=1,#t do
		table.insert(rTable, t[i].Job)	
	end
	return rTable
end


local function SQLControl()
	local entries = sql.Query("SELECT Job FROM PlayerJobTests")
	if entries == nil or entries == {} then return end
	PrintTable(entries)


	local jobs = {}

	for i=1,#RPExtraTeams do
		table.insert(jobs,RPExtraTeams[i].name)
	end

	for i,v in ipairs(entries) do
		local value = tostring(v.Job)
		if not table.HasValue(jobs, value) then
			sql.Query("DELETE FROM PlayerJobTests WHERE Job = '"..value.."'")
		end
	end
end



SQLControl()

hook.Add("playerCanChangeTeam","shouldChangeTeam_jobNpc", 

function(ply,job,force)

  	if not ply:CheckIfCompletedTest(job) then
		return false, "You need to take the test first!"
	end
end)
