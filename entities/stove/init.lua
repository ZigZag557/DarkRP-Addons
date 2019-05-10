AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


local Settings = 

{
	MinCost = 100, --The minimum price of the food which cook can set.
	MaxCost = 10000, --The maximum price of the food which cook can set.
	DefaultCost = 100, -- Default cost of the food.
	CostForOwner = 100, --The price, owner of the stove can buy food from.
	FoodToBeSpawned = "noodles class name here!" -- The entity that gets spawned when player's pay the price.
}


util.AddNetworkString("stove_priceChanged")

function ENT:Initialize()

	self:SetModel( "models/props_c17/furnitureStove001a.mdl" )
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

	if self:Getowning_ent() == nil then return end

	if activator == self:Getowning_ent() then

		if activator:canAfford(Settings.CostForOwner) then
			activator:addMoney(-Settings.CostForOwner)
			DarkRP.notify(activator,0,3,"You have bought food for $"..tostring(Settings.CostForOwner).."!")
			self:SpawnNoodles()
			return
		else
			DarkRP.notify(activator,0,3,"You don't have enough money to buy food!")
			return
		end
	end

	if IsValid(activator) and activator:IsPlayer() then
		if activator:canAfford(price) then
			activator:addMoney(-price)
			local owner = self:Getowning_ent()
			owner:addMoney(price)
			DarkRP.notify(activator,0,3,"You have bought food for $"..price.."!")
			DarkRP.notify(owner,0,3,"Somebody has bought some food from your stove for $"..price.."!")
			self:SpawnNoodles()
		else
			DarkRP.notify(activator,0,3,"You don't have enough money to buy food!")
		end
	end
end

function ENT:SpawnNoodles()
	local food = ents.Create(Settings.FoodToBeSpawned)
	food:SetPos(self:GetPos() + Vector(0,0,35) )
	food:Spawn()
end

local function ChangeStovePrice(ply, args)
	if args == "" or not tonumber(args) then return "" end

	local eyeEnt = ply:GetEyeTrace().Entity

	if not (eyeEnt:GetClass() == "stove") then
		DarkRP.notify(ply,0,3,"You need to look at your stove!")
		return ""
	end

	if not(eyeEnt:Getowning_ent() == ply) then
		DarkRP.notify(ply,0,3,"This is not your stove!")
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

DarkRP.defineChatCommand("setfoodprice", ChangeStovePrice)

hook.Add("OnPlayerChangedTeam", "RemovingStoves", function(ply, oldTeam)
	if oldTeam == TEAM_COOK then
		for i,v in ipairs(ents.FindByClass("stove")) do
			if(v:Getowning_ent() == ply) then
				v:Remove()
			end
		end
	end
end)