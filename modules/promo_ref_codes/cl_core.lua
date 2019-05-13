

surface.CreateFont("promo_ref_header",
{
	font = "Arial",
	size = 37,
	outline = true
})

surface.CreateFont("promo_ref_desc",
{
	font = "Arial",
	size = 26,
	outline = true
})

surface.CreateFont("promo_ref_input",
{
	font = "Arial",
	size = 23,
	outline = true
})





local w,h = ScrW(),ScrH()

local function ShowMenu()

	local menu = vgui.Create("DFrame")
	menu:SetSize(650,450)
	menu:SetPos(w/2 - 325, h/2 - 225)
	menu:SetTitle("Promo-Ref Menu")
	menu:SetDraggable(false)
	menu:MakePopup()
	menu.Paint = 
	function()

		draw.RoundedBox(0,0,0,650,450,Color(35,35,35,254))
		draw.RoundedBox(0,0,25,650,3,Color(230,230,230))

	end

	menu.promoHeader = vgui.Create("DLabel", menu)
	menu.promoHeader:SetText("Promo-Referral Codes")
	menu.promoHeader:SetFont("promo_ref_header")
	menu.promoHeader:SizeToContents()
	menu.promoHeader:SetTextColor(Color(255,255,255))
	local x,y = menu.promoHeader:GetSize() -- Centering the text
	menu.promoHeader:SetPos(325 - x/2, 50)


	menu.promoDesc = vgui.Create("DLabel", menu)
	menu.promoDesc:SetText("You can reedem your promo and referral codes here.")
	menu.promoDesc:SetFont("promo_ref_desc")
	menu.promoDesc:SetTextColor(Color(200,200,200))
	menu.promoDesc:SizeToContents()
	local x,y = menu.promoDesc:GetSize()
	menu.promoDesc:SetPos(325 - x/2, 100)

	menu.promoInputText = vgui.Create("DLabel", menu)
	menu.promoInputText:SetPos(15,180)
	menu.promoInputText:SetText("Promo Code:")
	menu.promoInputText:SetFont("promo_ref_input")
	menu.promoInputText:SetColor(Color(255,255,255))
	menu.promoInputText:SizeToContents()

	menu.promoInput = vgui.Create("DTextEntry", menu)
	menu.promoInput:SetPos(160,180)
	menu.promoInput:SetSize(300,25)

	menu.promoEnter = vgui.Create("DButton", menu)
	menu.promoEnter:SetPos(480,180)
	menu.promoEnter:SetSize(100,25)
	menu.promoEnter:SetText("Submit")
	menu.promoEnter.DoClick = function() LocalPlayer():ConCommand("say /activatepromo "..menu.promoInput:GetValue()) end

	menu.referalDesc = vgui.Create("DLabel", menu)
	menu.referalDesc:SetText("Share your referral code with your friends to earn rewards!")
	menu.referalDesc:SetFont("promo_ref_input")
	menu.referalDesc:SetPos(15,260)
	menu.referalDesc:SetColor(Color(230,230,230))
	menu.referalDesc:SizeToContents()

	menu.referalCode = vgui.Create("DLabel", menu)
	menu.referalCode:SetText("Your referral code: "..LocalPlayer():SteamID())
	menu.referalCode:SetFont("promo_ref_input")
	menu.referalCode:SetPos(15,290)
	menu.referalCode:SetColor(Color(230,230,230))
	menu.referalCode:SizeToContents()

	menu.referalCopy = vgui.Create("DButton", menu)
	menu.referalCopy:SetPos(400,290)
	menu.referalCopy:SetText("Copy")
	menu.referalCopy.DoClick = function() SetClipboardText(LocalPlayer():SteamID()) end

	menu.referalInputText = vgui.Create("DLabel", menu)
	menu.referalInputText:SetPos(15,360)
	menu.referalInputText:SetText("Referral Code:")
	menu.referalInputText:SetFont("promo_ref_input")
	menu.referalInputText:SetColor(Color(255,255,255))
	menu.referalInputText:SizeToContents()

	menu.referalInput = vgui.Create("DTextEntry", menu)
	menu.referalInput:SetPos(160,360)
	menu.referalInput:SetSize(300,25)

	menu.referalEnter = vgui.Create("DButton", menu)
	menu.referalEnter:SetPos(480,360)
	menu.referalEnter:SetSize(100,25)
	menu.referalEnter:SetText("Submit")
	menu.referalEnter.DoClick = function () LocalPlayer():ConCommand("say /activateref "..menu.referalInput:GetValue()) end

end

local function ShowMessage()


end


net.Receive("promo_ref_showMenu", ShowMenu)
net.Receive("promo_ref_showMessage",ShowMessage)