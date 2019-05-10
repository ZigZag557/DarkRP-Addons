




local teamSettings =
{
	["Citizen"] = {"Hobo","Medic"}, -- If citizen kills hobo or medic, he will earn money.
	["Medic"] = {"Hobo", "Citizen"} -- If medic kills citizen or hobo, he will earn money.

}





local settings = 
{
	killerMessage = "You have earned %d by killing %s.", -- %d is money earned, %s is victim's name. (you have to put %d before %s )
	moneyForKiller = 100 -- Money for killing.
}



local function PlayerDeath(victim,n,killer)

	local victimTeam = team.GetName(victim:Team())
	local killerTeam = team.GetName(killer:Team())

	if teamSettings[killerTeam] == nil then return end
	if not table.HasValue(teamSettings[killerTeam], victimTeam) then return end
	
	local money = settings.moneyForKiller
	killer:addMoney(money)
	local msg = string.format(settings.killerMessage, money, killer:GetName())
	DarkRP.notify(killer,0,3,msg)
end


hook.Add("PlayerDeath","player_death_givemoney",function(victim,t,killer) PlayerDeath(victim,nil,killer) end)