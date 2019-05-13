

local w,h = ScrW(),ScrH()
local function ShowMenu()

local menu = vgui.Create("DFrame")
	menu:SetSize(650,450)
	menu:SetPos(w/2 - 325, h/2 - 225)
	menu:SetTitle("Daily Bonuses")
	menu:SetDraggable(false)
	menu:MakePopup()
	menu.Paint = 
	function()
		draw.RoundedBox(0,0,0,650,450,Color(35,35,35,254))
		draw.RoundedBox(0,0,25,650,3,Color(230,230,230))
	end

	menu.dailyHeader = vgui.Create("DLabel", menu)
	menu.dailyHeader:SetText("Daily Bonuses")
	menu.dailyHeader:SetFont("promo_ref_header")
	menu.dailyHeader:SizeToContents()
	menu.dailyHeader:SetTextColor(Color(255,255,255))
	local x,y = menu.dailyHeader:GetSize() -- Centering the text
	menu.dailyHeader:SetPos(325 - x/2, 50)

	menu.dailyDesc = vgui.Create("DLabel", menu)
	menu.dailyDesc:SetText("You can use the abilites seperately bellow once a day!")
	menu.dailyDesc:SetFont("promo_ref_desc")
	menu.dailyDesc:SetTextColor(Color(200,200,200))
	menu.dailyDesc:SizeToContents()
	local x,y = menu.dailyDesc:GetSize()
	menu.dailyDesc:SetPos(325 - x/2, 100)

	menu.timeMoney = vgui.Create("DLabel", menu)
	menu.timeMoney:SetPos(120,180)
	menu.timeMoney:SetText("Get $"..DailyBonusesRewards.money.." and "..DailyBonusesRewards.time.." minutes game time.")
	menu.timeMoney:SetFont("promo_ref_input")
	menu.timeMoney:SetColor(Color(255,255,255))
	menu.timeMoney:SizeToContents()

	menu.timeMoneyB = vgui.Create("DButton", menu)
	menu.timeMoneyB:SetPos(480,180)
	menu.timeMoneyB:SetSize(100,25)
	menu.timeMoneyB:SetText("Activate")
	menu.timeMoneyB.DoClick = function() LocalPlayer():ConCommand("say /dailybonus NextDaily") end

	menu.health = vgui.Create("DLabel", menu)
	menu.health:SetPos(120,230)
	menu.health:SetText("Fill your health bar!")
	menu.health:SetFont("promo_ref_input")
	menu.health:SetColor(Color(255,255,255))
	menu.health:SizeToContents()

	menu.healthB = vgui.Create("DButton", menu)
	menu.healthB:SetPos(480,230)
	menu.healthB:SetSize(100,25)
	menu.healthB:SetText("Activate")
	menu.healthB.DoClick = function() LocalPlayer():ConCommand("say /dailybonus NextHp") end

	menu.armor = vgui.Create("DLabel", menu)
	menu.armor:SetPos(120,280)
	menu.armor:SetText("Fill your armor bar!")
	menu.armor:SetFont("promo_ref_input")
	menu.armor:SetColor(Color(255,255,255))
	menu.armor:SizeToContents()

	menu.armorB = vgui.Create("DButton", menu)
	menu.armorB:SetPos(480,280)
	menu.armorB:SetSize(100,25)
	menu.armorB:SetText("Activate")
	menu.armorB.DoClick = function() LocalPlayer():ConCommand("say /dailybonus NextArmor") end


	menu.unjail = vgui.Create("DLabel", menu)
	menu.unjail:SetPos(120,330)
	menu.unjail:SetText("Get out of the jail!")
	menu.unjail:SetFont("promo_ref_input")
	menu.unjail:SetColor(Color(255,255,255))
	menu.unjail:SizeToContents()

	menu.unjailB = vgui.Create("DButton", menu)
	menu.unjailB:SetPos(480,330)
	menu.unjailB:SetSize(100,25)
	menu.unjailB:SetText("Activate")
	menu.unjailB.DoClick = function() LocalPlayer():ConCommand("say /dailybonus NextUnjail") end

end



net.Receive("daily_showMenu", ShowMenu)