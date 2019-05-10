AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
util.AddNetworkString("jobnpc_superadmin_menu")
util.AddNetworkString("jobnpc_savechanges")
util.AddNetworkString("jobnpc_player_menu")
util.AddNetworkString("jobnpc_prepareTest")
util.AddNetworkString("jobnpc_prepareTest_request")
util.AddNetworkString("jobnpc_lockdownJob")
util.AddNetworkString("jobnpc_showmessage")
util.AddNetworkString("jobnpc_checkanswers")




local settings =

{
	LockdownTime = 5 -- Seconds until player can take the test again on fail.
}








function ENT:Initialize()

	self:SetModel("models/Humans/Group03m/male_09.mdl")
	self:SetHullType( HULL_HUMAN );
	self:SetHullSizeNormal();
	self:SetSolid( SOLID_BBOX ) 
	self:SetMoveType( MOVETYPE_STEP )
	self:SetUseType(SIMPLE_USE)
	self:CapabilitiesAdd( bit.bor( CAP_ANIMATEDFACE, CAP_TURN_HEAD ) )
	self:SetMaxYawSpeed( 90 )	

	self:SetNWString("Header", "Employer")

	self.Jobs = {}
	self.AvailableJobs = {}
	self:UpdateList()

end

function ENT:UpdateList()

	self.AvailableJobs = {}

	for k,v in pairs(JobNPCQuestions) do
		if not table.HasValue(self.Jobs, k) then
			table.insert(self.AvailableJobs, k)
		end
	end
end

local function RemovedTestedJobs(ply,jobs)
	local rTable = table.Copy(jobs)
	local plyJobs = ply:GetTestedJobs()
	if plyJobs == nil or plyJobs == {} then return jobs end


	for i=1,#plyJobs do
		table.RemoveByValue(rTable, plyJobs[i])
	end

	return rTable

end

function ENT:AcceptInput(_,act)

	if act:KeyDown(IN_WALK) and act:IsSuperAdmin() then
		net.Start("jobnpc_superadmin_menu")
		net.WriteTable(self.Jobs)
		net.WriteTable(self.AvailableJobs)
		net.WriteEntity(self)
		net.Send(act)
	else
		net.Start("jobnpc_player_menu")
		net.WriteTable(RemovedTestedJobs(act, self.Jobs))
		net.WriteEntity(self)
		net.Send(act)
	end
end

function ENT:PermaPropSpawn(name,model,jobs)
	print("1")
	self:SetModel(model)
	self:SetNWString("Header", name)
	self.Jobs = jobs
	self:UpdateList()

end


local function SaveChanges(listL,ent,header,path, ply)

	if not ply:IsSuperAdmin() then
		ply:ChatPrint("You don't have the required permissions.")
		return
	end
	
	ent.Jobs = listL
	ent:SetNWString("Header", header)
	if not file.Exists(path, "GAME") and not util.IsValidModel( path )  then
		ply:ChatPrint("Couldn't save model path because couldn't find it!")
		ent:UpdateList()
		return
	end

	ent:SetModel(path)

	ent:UpdateList()
	ply:ChatPrint("Settings are successfully saved!")

end

local function LockdownJob(job,ply)

	if (ply.JobNPCLockedJobs == nil) then
		ply.JobNPCLockedJobs = {}
	end 

	if (table.HasValue(ply.JobNPCLockedJobs, job)) then return end
	table.insert(ply.JobNPCLockedJobs, job)

	timer.Simple(settings.LockdownTime, function()
		if IsValid(ply) and table.HasValue(ply.JobNPCLockedJobs, job) then
			for i=1,#ply.JobNPCLockedJobs do
				if (ply.JobNPCLockedJobs[i] == job) then
					ply.JobNPCLockedJobs[i] = nil
				end
			end
		end 
	end)


end


local function isJobOnLockdown(ply,job)
	if ply.JobNPCLockedJobs == nil then return false end
	return table.HasValue(ply.JobNPCLockedJobs,job)
end	

local function CheckAnswers(ply,job,answers)
	if job == nil then return end
	if answers == nil or answers == {} then return end

	local jobTable = JobNPCQuestions[job]

	for k,v in pairs(jobTable) do
		for i=1,#answers do
			if answers[i][1] == v.question then
				if not v.answers[answers[i][2]] then
					net.Start("jobnpc_showmessage")
					net.WriteString("You have failed the test!")
					net.Send(ply)
					LockdownJob(job, ply)
					return 
				end
			end
		end
	end

	net.Start("jobnpc_showmessage")
	net.WriteString("You have passed the test.")
	net.Send(ply)
	DarkRP.notify(ply,0,4,"If you have bought the job "..job.." then you can now have that job now!")

	ply:JobTestsAddSQL(job)

end


net.Receive("jobnpc_savechanges",function(len,ply) SaveChanges(net.ReadTable(), net.ReadEntity(), net.ReadString(), net.ReadString(), ply) end)

net.Receive("jobnpc_prepareTest_request", function(len,ply) 
	local job = net.ReadString()
	if job == nil then return end
	if isJobOnLockdown(ply, job) then 
		ply:ChatPrint("You cannot take this test yet!") 
	else 
		net.Start("jobnpc_prepareTest")
		net.WriteString(job)
		net.Send(ply)
	end end)

net.Receive("jobnpc_lockdownJob",function(len,ply) LockdownJob(net.ReadString(), ply, settings.LockdownTime) end )
net.Receive("jobnpc_checkanswers", function(len,ply) CheckAnswers(ply,net.ReadString(), net.ReadTable()) end)