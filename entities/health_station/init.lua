AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


local Settings = 

{
	MinCost = 100, --The minimum price of health which medic can set.
	MaxCost = 10000, --The maximum price of health which medic can set.
	DefaultCost = 100, -- Default cost of health.
	CostForOwner = 100, --The price, owner of the station can buy health from.
}


util.AddNetworkString("health_priceChanged")

function ENT:Initialize()

	self:SetModel( "models/props_combine/health_charger001.mdl" )
	DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 	self:SetUseType( SIMPLE_USE )
 	self:SetNWInt("Price",Settings.DefaultCost)
    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"owning_ent")
end

function ENT:Use(activator)
	local price = self:GetNWInt("Price")

	if(activator:GetMaxHealth() == activator:Health()) then
		DarkRP.notify(activator,0,3,"You don't need to be healed!")
		return
	end

	if self:Getowning_ent() == nil then return end

	if activator == self:Getowning_ent() then

		if activator:canAfford(Settings.CostForOwner) then
			activator:addMoney(-Settings.CostForOwner)
			DarkRP.notify(activator,0,3,"You have healed yourself for $"..tostring(Settings.CostForOwner).."!")
			activator:SetHealth(activator:GetMaxHealth())
			return
		else
			DarkRP.notify(activator,0,3,"You don't have enough money to heal yourself!")
			return
		end
	end

	if IsValid(activator) and activator:IsPlayer() then
		if activator:canAfford(price) then
			activator:addMoney(-price)
			local owner = self:Getowning_ent()
			owner:addMoney(price)
			DarkRP.notify(activator,0,3,"You have healed yourself for $"..price.."!")
			DarkRP.notify(owner,0,3,"Somebody has healed himself for $"..price.." using your health station!")
			activator:SetHealth(activator:GetMaxHealth())
		else
			DarkRP.notify(activator,0,3,"You don't have enough money to get healed!")
		end
	end
end

local function ChangeHealthPrice(ply, args)
	if args == "" or not tonumber(args) then return "" end

	local eyeEnt = ply:GetEyeTrace().Entity

	if not (eyeEnt:GetClass() == "healthstation") then
		DarkRP.notify(ply,0,3,"You need to look at your health station!")
		return ""
	end

	if not(eyeEnt:Getowning_ent() == ply) then
		DarkRP.notify(ply,0,3,"This is not your health station!")
		return ""
	end

	local newPrice = tonumber(args)
	if newPrice >= Settings.MaxCost then
		DarkRP.notify(ply,0,3,"The price you set is too high!")
		return ""
	end

	if newPrice <= Settings.MinCost then
		DarkRP.notify(ply,0,3,"The price you set is too low!")
		return ""
	end

	eyeEnt:SetNWInt("Price",newPrice)
	DarkRP.notify(ply,0,3,"You have changed it's price to $"..args.."!")


	return ""
end

DarkRP.defineChatCommand("sethealthprice", ChangeHealthPrice)

hook.Add("OnPlayerChangedTeam", "RemovingHealthStations", function(ply, oldTeam)
	if oldTeam == TEAM_MEDIC then
		for i,v in ipairs(ents.FindByClass("health_station")) do
			if(v:Getowning_ent() == ply) then
				v:Remove()
			end
		end
	end
end)