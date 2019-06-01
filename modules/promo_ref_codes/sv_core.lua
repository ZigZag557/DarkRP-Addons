
local ply = FindMetaTable("Player")

local charset = {"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h",
				"j","k","l","z","x","c","v","b","n","m","Q","W","E","R","T","Y","U",
				"I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N",
				"M","1","2","3","4","5","6","7","8","9","0"}





util.AddNetworkString("promo_ref_showMenu")
util.AddNetworkString("promo_ref_showMessage")

local function RandomPromoCode()

	local c = "p_"
	math.randomseed(os.time())

	for i=1,10 do
		c = c..charset[math.random(62)]
	end

	return c
end


local function CreatePromoCode(ply, args)

	local reward = args

	if not ply:IsSuperAdmin() then return end
	if reward == nil then ply:ChatPrint("Please provide a reward.") return end


	if string.sub(reward,1,3) ~= "vip" and
	   string.sub(reward,1,5)  ~= "money" and
	   string.sub(reward,1,4) ~= "time" and
	   string.sub(reward,1,5) ~= "admin" then
	   ply:ChatPrint("Invalid argument!")
	   return ""
	end

	local promo = RandomPromoCode() 

	sql.Query("INSERT INTO ActivePromoCodes VALUES('"..promo.."', '"..reward.."')")

	ply:ChatPrint("You have created promo code: '"..promo.."' with reward: "..reward..".")
	return "" 

end

local function ShowMessage(ply, msg)

	net.Start("promo_ref_showMessage")
	net.WriteString(msg)
	net.Send(ply)

end



local function GivePromoReward(ply, reward)

	if string.sub(reward, 1,3) == "vip" then
		local time = tonumber(string.sub(reward, 3 - #reward)) 
		if time == nil then return end
		RunConsoleCommand("ulx", "tempadduser", ply:GetName(), "vip", time)
		DarkRP.notify(ply,0,3,"You are now a vip for "..time.." minutes!")
	end

	if string.sub(reward,1,5)  == "money" then
		local amount = tonumber(string.sub(reward, 5 - #reward))
		if amount == nil then return end
		ply:addMoney(amount)
		DarkRP.notify(ply,0,3,"You have earned $"..amount.." by using the promo code!")
	end

	if string.sub(reward,1,4) == "time" then
		local time = tonumber(string.sub(reward, 4 - #reward))
		if time == nil then return end
		local utime = ply:GetUTimeTotalTime()
		ply:SetUTime(utime + (time * 60))
		DarkRP.notify(ply,0,3,"You have earned "..time.." minutes game time!")
	end

	if string.sub(reward,1,5) == "admin" then
		local time = tonumber(string.sub(reward, 5 - #reward))
		if time == nil then return end 
		RunConsoleCommand("ulx", "tempadduser", ply:GetName(), "admin", time)
		DarkRP.notify(ply,0,3,"You are now an admin for "..time.." minutes!")
	end

	return ""
end


local function ActivateSpecialPromo(ply, code)

	local reward = sql.QueryValue("SELECT Reward FROM SpecialPromoCodes WHERE Code = "..code)
	if reward == nil then DarkRP.notify(ply,0,3,"Invalid promo code.") return "" end


	local t = sql.QueryValue("SELECT Steam FROM SpecialPromoCodeUsers WHERE Code = "..code)
	if t ~= nil then DarkRP.notify(ply,0,3,"You can not use this promo code more than once!") return "" end

	local attempt = sql.Query("INSERT INTO SpecialPromoCodeUsers VALUES('"..ply:SteamID().."', "..code..")")
	if type(attempt) == "boolean" then ply:ChatPrint("Please contact an admin!") return "" end
	
	GivePromoReward(ply, reward)
	return ""
end

local function ActivatePromoCode(ply,args)

	if args == "" then ply:ChatPrint("Enter the promo code please.") return "" end
	local args = sql.SQLStr(args)

	if string.sub(args, 1, 3) ~= "'p_" then
		local t = ActivateSpecialPromo(ply,args)
		return t
	end

	local value = sql.QueryValue("SELECT Reward FROM ActivePromoCodes WHERE Code = "..args)
	if value == false or value == nil then DarkRP.notify(ply,0,3,"Invalid or used promo code!") return "" end
	local reward = tostring(value)

	GivePromoReward(ply, reward)

	sql.Query("DELETE FROM ActivePromoCodes WHERE Code = "..args)
	print("[PromoCodes] A promo code "..args.." has been used by "..ply:GetName()..".")
	return ""
end

local function RewardRefs(ply)

	ply:addMoney(RefRewards.money)

	local utime = ply:GetUTimeTotalTime()
	ply:SetUTime(utime + (RefRewards.time))

end


local function ActivateRef(ply, args)

	if args == "" then DarkRP.notify(ply,0,3,"Enter the Steam ID of who suggested you to this server please!") return "" end
	local argsSql = sql.SQLStr(args)

	if ply:SteamID() == args then
		DarkRP.notify(ply,0,3,"You can not set yourself as the referral!")
		return ""
	end

	local isUsedCode = sql.QueryValue("SELECT RefUsed FROM PlayerRefList WHERE Steam = '"..ply:SteamID().."'")
	local isPlayer = sql.QueryValue("SELECT Steam FROM PlayerRefList WHERE Steam = "..argsSql)

	if isPlayer == nil or isPlayer == false then DarkRP.notify(ply,0,3,"Either invalid SteamID or player has never played in this server.") return "" end
	if isUsedCode == nil then DarkRP.notify(ply,0,3,"Please contact an admin!") return end
	
	if isUsedCode == "0" then
		DarkRP.notify(ply,0,3,"You have used the referral code successfully!") 
		sql.Query("UPDATE PlayerRefList SET RefUsed = 1 WHERE Steam = '"..ply:SteamID().."'")

		RewardRefs(ply)
		DarkRP.notify(refPly,0,3, "Your referral code has been used by "..ply:Name().." ! You have earned money and game time!")

		-- Increase ref amount of player
		sql.Query("UPDATE PlayerRefList SET RefAmount = RefAmount + 1 WHERE Steam = "..argsSql)
		local refPly = player.GetBySteamID(args)
		----


		if not (refPly == nil) then
			RewardRefs(refPly)
			DarkRP.notify(refPly,0,3, "Your referral code has been used by "..ply:Name().." ! You have earned money and game time!")
		else
			sql.Query("UPDATE PlayerRefList SET RefToReward = RefToReward + 1 WHERE Steam = "..argsSql)
		end
	else
		DarkRP.notify(ply,0,3,"You can't use multiple referral codes!") 
		return ""

	end

end


local function ShowPromoMenu(ply)

	net.Start("promo_ref_showMenu")
	net.Send(ply)

end



local function TryGiveRefRewards(ply)

	local c = sql.QueryValue("SELECT RefToReward FROM PlayerRefList WHERE Steam = '"..ply:SteamID().."'")
	if c == nil or c == 0 then return end

	for i=1,c do
		RewardRefs(ply)
	end
	
	DarkRP.notify(ply,0,3,c.." players have used your referral key, you have earned money and play time!")
	sql.Query("UPDATE PlayerRefList SET RefToReward = 0 WHERE Steam = '"..ply:SteamID().."'")

end


local function AddSQLOnSpawn(ply)
	local t = sql.Query("SELECT Steam FROM PlayerRefList WHERE Steam = '"..ply:SteamID().."'")

	if t == false then print("[PromoCodes] SQL table is not valid!") end
	if t == nil then
		sql.Query("INSERT INTO PlayerRefList VALUES('"..ply:SteamID().."', '0', '0', '0')")
		print("[PromoCodes] Added newcomer ".. ply:GetName().." to the database.")
	end

	TryGiveRefRewards(ply)
end

local function SpecialPromoCodes(ply,args)

	if not ply:IsSuperAdmin() then return "" end
	if args == "" then return "" end

	local values = string.Explode(" ", args)
	if #values ~= 3 then return "" end

	local code = values[1]
	local reward = values[2]
	local expirationDays = values[3]

	expiration = os.time() + (expirationDays * 86400)

	if string.sub(reward,1,3) ~= "vip" and
	   string.sub(reward,1,5)  ~= "money" and
	   string.sub(reward,1,4) ~= "time" and
	   string.sub(reward,1,5) ~= "admin" then
	   ply:ChatPrint("Invalid reward!")
	   return ""
	end

	if #code < 3 then ply:ChatPrint("Promo code name is too short!") return "" end

	local t = sql.Query("INSERT INTO SpecialPromoCodes VALUES('"..code.."', '"..reward.."', "..expiration..")")
	if type(t) == "boolean" then
		ply:ChatPrint("There was a problem with the promocode.")
	else
		ply:ChatPrint("Promocode: '"..code.."' has been successfully added to the database!")
		print("[PromoCodes] Promocode '"..code.."' has been added to the database, it will expire in "..expirationDays.." days!")
	end

	return ""

end



DarkRP.defineChatCommand("createpromo", CreatePromoCode)
DarkRP.defineChatCommand("activatepromo", ActivatePromoCode)
DarkRP.defineChatCommand("activateref", ActivateRef)
DarkRP.defineChatCommand("promomenu", ShowPromoMenu)
DarkRP.defineChatCommand("specialpromo", SpecialPromoCodes)

hook.Add("PlayerInitialSpawn","addtosqlonspawn_promoref", AddSQLOnSpawn)