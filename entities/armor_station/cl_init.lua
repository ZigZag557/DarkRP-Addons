include("shared.lua")



function ENT:Draw()
    self:DrawModel()
    local price = self:GetNWInt("Price")
    local offset = Vector( 0, 0, 40 )
    local pos = self:GetPos() + offset
    local ang = self:GetAngles()

    cam.Start3D2D(pos, Angle( 0, ang.y + 90 , 90), 0.25)
        draw.DrawText("Armor yourself up!", "customent_priceFont",0,0,Color(255,255,255), TEXT_ALIGN_CENTER)
        draw.DrawText("Price: $"..price, "customent_priceFont",2,25,Color(255,255,255), TEXT_ALIGN_CENTER)
    cam.End3D2D()

     cam.Start3D2D(pos, Angle( 180, ang.y + 90 , 270), 0.25)
        draw.DrawText("Armor yourself up!", "customent_priceFont",0,0,Color(255,255,255), TEXT_ALIGN_CENTER)
        draw.DrawText("Price: $"..price, "customent_priceFont",2,25,Color(255,255,255), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

