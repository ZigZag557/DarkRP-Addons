AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


local Settings = 

{
	SodaPrice = 20, --Cost of buying a soda.
	MoneyPerRefill = 10, -- Money, refiller earns per missing unit (If refiller refills 20 soda then he will earn 20*MoneyPerRefill)
	MaxStorage = 50, --Maximum amount of soda can be hold in the machine.
	FoodToBeSpawned = "entity class here" -- The entity that gets spawned.
}

function ENT:Initialize()

	self:SetModel( "models/props_interiors/VendingMachineSoda01a.mdl" )
	DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 	self:SetUseType( SIMPLE_USE )
 	self:SetNWInt("Price",Settings.SodaPrice)
 	self:SetNWInt("SodaLeft",Settings.MaxStorage)
    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use(activator)
	local price = self:GetNWInt("Price")
	local soda = self:GetNWInt("SodaLeft")

	if( soda == 0) and not (activator:Team() == TEAM_REFUELER) then
		DarkRP.notify(activator,0,3,"Sorry, out of soda.")
		return
	end

	if IsValid(activator) and activator:IsPlayer() then
		if (soda == Settings.MaxStorage) then
			if (activator:canAfford(price)) then
				activator:addMoney(-price)
				DarkRP.notify(activator,0,3,"You have bought soda for $"..price.."!")
				self:SetNWInt("SodaLeft", soda - 1)
				self:SpawnSoda()
				return
			else
				DarkRP.notify(activator,0,3,"You don't have enough money to buy soda!")
				return
			end
		end

		if activator:Team() == TEAM_REFUELER then
			local moneyEarned = (Settings.MaxStorage - soda) * Settings.MoneyPerRefill
			activator:addMoney(moneyEarned)
			DarkRP.notify(activator,0,3,"You have earned $"..moneyEarned.." by refilling the soda machine!")
			self:SetNWInt("SodaLeft",Settings.MaxStorage)
			return
		end


		if activator:canAfford(price) then
			activator:addMoney(-price)
			DarkRP.notify(activator,0,3,"You have bought soda for $"..price.."!")
			self:SetNWInt("SodaLeft", soda - 1)
			self:SpawnSoda()
		else
			DarkRP.notify(activator,0,3,"You don't have enough money to buy soda!")
		end
	end
end

function ENT:SpawnSoda()
	local food = ents.Create(Settings.FoodToBeSpawned)
	food:SetPos(self:GetPos() + self:GetForward() * 28 + Vector(0,3,-20) )
	food:Spawn()
end