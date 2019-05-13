

util.AddNetworkString("daily_showMenu")

local function AddToSQL(ply)

	local v = sql.QueryValue("SELECT Steam FROM DailyRewards WHERE Steam = '"..ply:SteamID().."'")

	if v == nil then
		local t = os.time() + 86400 -- 24h

		local k = sql.Query("INSERT INTO DailyRewards VALUES('"..ply:SteamID().."', "..t..", "..t..", "..t..", "..t..")")
		print("[DailyRewards] A newcomer ".. ply:GetName().." has been added into the database.")
	end

end


local function GetNextRewardTime(ply,arg)

	local t = sql.QueryValue("SELECT "..arg.. " FROM DailyRewards WHERE Steam = '"..ply:SteamID().."'")
	if t == nil then ply:ChatPrint("Error on GetNextRewardTime() -- Contact an admin please!") return end

	local timeLeft = (t - os.time())

	if timeLeft <= 0 then
		return -1
	else
		return timeLeft
	end

end



local function ApplyReward(ply, action)

	if action == "NextDaily" then
		ply:addMoney(DailyBonusesRewards.money)

		local utime = ply:GetUTimeTotalTime()
		ply:SetUTime(utime + (time * 60))
		DarkRP.notify("You have used your daily money and time bonus!")
	elseif action == "NextHp" then

		ply:SetHealth(ply:GetMaxHealth())
		DarkRP.notify("You have used your daily health bonus!")
	elseif action == "NextArmor" then

		ply:SetArmor(100)
		DarkRP.notify("You have used your daily armor bonus!")
	elseif action == "NextUnjail" then

		ply:unArrest()
		DarkRP.notify("You have used your daily get out of jail bonus!")
	end

end



local function TryGetReward(ply, arg)

	if  arg ~= "NextDaily" and
		arg ~= "NextHp" and
		arg ~= "NextArmor" and
		arg ~= "NextUnjail" then
			ply:ChatPrint("Invalid arguments!")
			return ""
	end

	if arg == "NextUnjail" then
		if not ply:isArrested() then
			DarkRP.notify(ply,0,3,"You can not get out of jail while you are not in jail!")
			return ""
		end
	end


	local time = GetNextRewardTime(ply,arg)
	if time == nil then DarkRP.notify(ply,0,3,"Please contact an admin!") return "" end


	if time == -1 then
		local nxt = os.time() + 86400
		local t = sql.Query("UPDATE DailyRewards SET NextReward = "..nxt.." WHERE Steam = '"..ply:SteamID().."'")

		if t == false then DarkRP.notify(ply,0,3,"Please contact an admin!") return "" end
		ApplyReward(ply, arg)
		return ""
	end

	if time >= 3600 then
		DarkRP.notify(ply,0,3,"You have to wait "..(math.floor(time / 3600) + 1).." hours to claim that bonus!")
	elseif time >= 60 then
		DarkRP.notify(ply,0,3,"You have to wait "..(math.floor(time / 60) + 1).." minutes to claim that bonus!")
	else
		DarkRP.notify(ply,0,3,"You have to wait "..time.." seconds to claim that bonus!")
	end

	return ""
end


local function ShowMenu(ply)

	net.Start("daily_showMenu")
	net.Send(ply)

end

hook.Add("PlayerInitialSpawn","addtosqlonspqn_dailybonus",AddToSQL)

DarkRP.defineChatCommand("dailybonus", TryGetReward)
DarkRP.defineChatCommand("bonusmenu", ShowMenu )