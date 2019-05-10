include("shared.lua")

surface.CreateFont("customent_priceFont",
{
    font = "Arial",
    size = 30,
    shadow = true
})


function ENT:Draw()
    self:DrawModel()
    local soda = self:GetNWInt("SodaLeft")
    local price = self:GetNWInt("Price")
    local offset = Vector(0,4,20)
    local ang = self:GetAngles()
    local pos = (self:GetPos() + self:GetForward() * 21 + offset)

    cam.Start3D2D(pos, Angle( 0, ang.y + 90, ang.z+90 ), 0.25)
    
            draw.DrawText("Soda for sale!", "customent_priceFont",0,0,Color(255,255,255), TEXT_ALIGN_CENTER)
            draw.DrawText("Price: $"..price, "customent_priceFont",2,25,Color(255,255,255), TEXT_ALIGN_CENTER)

        if(LocalPlayer():Team() == TEAM_REFUELER) then
            draw.DrawText("Remaining: "..soda, "customent_priceFont",0,70,Color(255,255,255), TEXT_ALIGN_CENTER)
        end
    cam.End3D2D()

end

