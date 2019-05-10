include("shared.lua")

surface.CreateFont("customent_priceFont",
{
    font = "Arial",
    size = 30,
    shadow = true
})


function ENT:Draw()
    self:DrawModel()
    local price = self:GetNWInt("Price")

    local offset = Vector( 0, 0, 55 )
    local ang = LocalPlayer():EyeAngles()
    local pos = self:GetPos() + offset + ang:Up()

    ang:RotateAroundAxis( ang:Forward(), 90 )
    ang:RotateAroundAxis( ang:Right(), 90 )

    cam.Start3D2D(pos, Angle( 0, ang.y, 90 ), 0.25)
        draw.DrawText("Food for sale!", "customent_priceFont",0,0,Color(255,255,255), TEXT_ALIGN_CENTER)
        draw.DrawText("Price: $"..price, "customent_priceFont",2,25,Color(255,255,255), TEXT_ALIGN_CENTER)
    cam.End3D2D()

end

