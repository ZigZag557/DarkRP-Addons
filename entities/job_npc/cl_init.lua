include('shared.lua')


local w,h = ScrW(),ScrH()
local QuestionsTable = JobNPCQuestions
local answers = {}

local mainPanel


function ENT:Initialize()

end

surface.CreateFont("jobnpc_font", 
{
	size = 20,
	font = "Arial",

})

surface.CreateFont("jobnpc_font_big_outline", 
{
	size = 40,
	font = "Arial",
	outline = true
})

surface.CreateFont("jobnpc_font_big", 
{
	size = 30,
	font = "Arial",
})

surface.CreateFont("jobnpc_font_medium", 
{
	size = 22,
	font = "Arial",
})

surface.CreateFont("jobnpc_font_npc", 
{
	size = 27,
	font = "Arial",
	shadow = true
})


function ENT:Draw()
	self:DrawModel()

	local text = self:GetNWString("Header")

    local offset = Vector( 0, 0, 80 )
    local ang = self:GetAngles()
    local pos = self:GetPos() + offset + ang:Up()

    ang:RotateAroundAxis( ang:Forward(), 90 )
    ang:RotateAroundAxis( ang:Right(), 90 )

    cam.Start3D2D(pos, Angle( 0, ang.y - 180, 90 ), 0.25)
        draw.DrawText(text, "jobnpc_font_npc",0,0,Color(255,255,255), TEXT_ALIGN_CENTER)
    cam.End3D2D()

     cam.Start3D2D(pos, Angle( 0, ang.y, 90 ), 0.25)
        draw.DrawText(text, "jobnpc_font_npc",0,0,Color(255,255,255), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end



local function MoveItems(listL,listR, action, ent)

	if action == "TO_RIGHT" then

		if listL:GetSelectedLine() == nil then
			LocalPlayer():ChatPrint("Please select a job from Available Jobs.")
			return
		end

		local index = listL:GetSelectedLine()
		local item = listL:GetLine(index):GetColumnText(1)
		listR:AddLine(item)
		listL:RemoveLine(index)

	end

	if action == "TO_LEFT" then
		if listR:GetSelectedLine() == nil then
			LocalPlayer():ChatPrint("Please select a job from NPC Jobs.")
			return
		end
		local index = listR:GetSelectedLine()
		local item = listR:GetLine(index):GetColumnText(1)
		listL:AddLine(item)
		listR:RemoveLine(index)
	end
end

local function SaveChanges(listL, ent, header, path)

	local listLeft = {}

	for k,v in pairs(listL:GetLines()) do
		table.insert(listLeft, v:GetValue(1))
	end

	net.Start("jobnpc_savechanges")
	net.WriteTable(listLeft)
	net.WriteEntity(ent)
	net.WriteString(header)
	net.WriteString(path)
	net.SendToServer()

end

local function SuperadminMenu(jobs,available, ent)

	local someJobs = {}

	local menu = vgui.Create("DFrame")
	menu:SetSize(450,520)
	menu:SetPos(w/2 - 200, h/2- 200)
	menu:SetTitle("Superadmin Menu")
	menu:MakePopup()

	menu.HeaderText = vgui.Create("DLabel", menu)
	menu.HeaderText:SetPos(30,40)
	menu.HeaderText:SetText("NPC Header: ")
	menu.HeaderText:SetFont("jobnpc_font")
	menu.HeaderText:SizeToContents()

	menu.HeaderBar = vgui.Create("DTextEntry", menu)
	menu.HeaderBar:SetPos(140,40)
	menu.HeaderBar:SetSize(160,18)
	menu.HeaderBar:SetValue(ent:GetNWString("Header"))


	menu.PathText = vgui.Create("DLabel", menu)
	menu.PathText:SetPos(30,75)
	menu.PathText:SetText("NPC Model: ")
	menu.PathText:SetFont("jobnpc_font")
	menu.PathText:SizeToContents()

	menu.Path = vgui.Create("DTextEntry", menu)
	menu.Path:SetPos(130,75)
	menu.Path:SetSize(250,18)
	menu.Path:SetValue(ent:GetModel())

	menu.Jobs = vgui.Create("DListView", menu)
	menu.Jobs:Dock(LEFT)
	menu.Jobs:SetSize(180,0)
	menu.Jobs:DockMargin(2,120,0,50)
	menu.Jobs:AddColumn("NPC Jobs")

	for i=1,#jobs do
		menu.Jobs:AddLine(jobs[i])
	end

	menu.AllJobs = vgui.Create("DListView", menu)
	menu.AllJobs:Dock(RIGHT)
	menu.AllJobs:SetSize(180,0)
	menu.AllJobs:DockMargin(0,120,2,50)
	menu.AllJobs:AddColumn("Available Jobs")

	for i=1,#available do
		menu.AllJobs:AddLine(available[i])
	end


	menu.ToRight = vgui.Create("DButton",menu)
	menu.ToRight:Dock(FILL)
	menu.ToRight:SetSize(80,30)
	menu.ToRight:DockMargin(5,200,5,250)
	menu.ToRight:SetText(">>>")
	menu.ToRight.DoClick = function() MoveItems(menu.Jobs,menu.AllJobs,"TO_RIGHT", ent) menu.Jobs:ClearSelection()  end

	menu.ToLeft = vgui.Create("DButton",menu)
	menu.ToLeft:Dock(FILL)
	menu.ToLeft:SetSize(80,30)
	menu.ToLeft:DockMargin(5,250,5,200)
	menu.ToLeft:SetText("<<<")
	menu.ToLeft.DoClick = function() MoveItems(menu.Jobs,menu.AllJobs,"TO_LEFT", ent) menu.AllJobs:ClearSelection() end

	menu.Save = vgui.Create("DButton",menu)
	menu.Save:Dock(FILL)
	menu.Save:SetSize(80,30)
	menu.Save:DockMargin(5,380,5,70)
	menu.Save:SetText("Save")

	menu.Save.DoClick = function() SaveChanges(menu.Jobs, ent,menu.HeaderBar:GetValue(),menu.Path:GetValue()) menu:Close() end
end

local function GetJobColor(job)
	for i=1,#RPExtraTeams do
		if RPExtraTeams[i].name == job then
			return RPExtraTeams[i].color
		end
	end
end



local function ShowMessage(message)

	local menu = vgui.Create("DFrame")
	menu:SetSize(500,150)
	menu:SetPos(w/2 - 250, h/2 - 75)
	menu:MakePopup()
	menu:SetDraggable(false)
	menu:SetTitle("Attention")
	menu.Paint = function()
		draw.RoundedBox(0,0,0,500,650,Color(40,40,40,255))
		draw.RoundedBox(0,0,30,500,2,Color(200,200,200))
	end

	menu.message = vgui.Create("DLabel", menu)
	menu.message:SetText(message)
	menu.message:SetFont("jobnpc_font_medium")
	menu.message:SetText(message)
	menu.message:SizeToContents()
	menu.message:SetTextColor(Color(255,255,255))
	local w,h = menu.message:GetSize()
	menu.message:SetPos(250 - w/2, 50)

	menu.button = vgui.Create("DButton", menu)
	menu.button:Dock(BOTTOM)
	menu.button:DockMargin(200,0,200,25)
	menu.button:SetSize(0,30)
	menu.button:SetText("OK")
	menu.button.DoClick = function() menu:Close() end

end


local function PrepareTest(job)

	answers = {}
	local questions = QuestionsTable[job]

	local menu = vgui.Create("DFrame")
	menu:SetSize(1000, 600)
	menu:SetPos(w/2 - 500, h/2 - 300)
	menu:MakePopup()
	menu:SetDraggable(false)
	menu:SetTitle(job.." Test")
	menu.Paint = function()
		draw.RoundedBox(0,0,0,1000,1000,Color(70,70,70,252))
		draw.RoundedBox(0,0,30,1000,2,Color(200,200,200))
	end
	menu.scroll = vgui.Create("DScrollPanel",menu)
	menu.scroll:Dock(FILL)
	menu.scroll:DockMargin(0,3,0,10)

	for i,v in ipairs(questions) do

		local qPanel = vgui.Create("DPanel", menu)
		qPanel:Dock(TOP)
		qPanel:DockMargin(0,10,0,40)
		qPanel.Paint = function()
			draw.RoundedBox(0,0,0,1000,1000,Color(85,85,85))
		end

		qPanel.index = vgui.Create("DLabel", qPanel)
		qPanel.index:Dock(TOP)
		qPanel.index:SetText(i..")")
		qPanel.index:SetFont("jobnpc_font_medium")
		qPanel.index:SetTextColor(Color(255,255,255))
		qPanel.index:SizeToContents()
		qPanel.index:DockMargin(10,5,0,0)

		qPanel.question = vgui.Create("DLabel", qPanel)
		qPanel.question:SetMultiline(true)
		qPanel.question:SetText(v.question)
		qPanel.question:SetFont("jobnpc_font_medium")
		qPanel.question:SetTextColor(Color(230,230,230))
		qPanel.question:SizeToContents()
		qPanel.question:SetPos(33,6)
		
		local x,y = qPanel.question:GetSize()
		qPanel:SetSize(700, 60 + y )


		qPanel.answer = vgui.Create("DComboBox", qPanel)
		qPanel.answer:Dock(BOTTOM)
		qPanel.answer:SetSize(300,20)
		qPanel.answer:DockMargin(20,0,20,15)
		qPanel.answer:SetValue("Please select.")
		for t,l in pairs(v.answers) do
			qPanel.answer:AddChoice(t)
		end
		menu.scroll:Add(qPanel)
		local id = qPanel.answer:GetSelectedID()
		table.insert(answers, { qPanel.question:GetValue(), qPanel.answer })


	end

		menu.finish = vgui.Create("DPanel", menu)
		menu.finish:Dock(BOTTOM)
		menu.finish:SetSize(0,50)

		menu.finish.Paint = function() draw.RoundedBox(0,0,0,1000,1000,Color(50,50,50)) end

		menu.finish.submit = vgui.Create("DButton",menu.finish)
		menu.finish.submit:Dock(BOTTOM)
		menu.finish.submit:SetSize(0,30)
		menu.finish.submit:SetText("Finish")
		menu.finish.submit:DockMargin(430,0,430,8)

		menu.finish.submit.DoClick = 

		function()

			for i=1,#answers do
				if answers[i][2]:GetSelectedID() == nil then
					ShowMessage("Please answer all of the questions")
					return
				end
			end

			local answerStr = {}

			for i=1,#answers do
				local id = answers[i][2]:GetSelectedID()
				local answ = answers[i][2]:GetOptionText(id)

				table.insert(answerStr, {answers[i][1], answ  } )
			end

			net.Start("jobnpc_checkanswers")
			net.WriteString(job)
			net.WriteTable(answerStr)
			net.SendToServer()

			menu:Close()
		end
end


local function PlayerMenu(jobs,ent)
	mainPanel = vgui.Create("DFrame")
	mainPanel:SetSize(420,580)
	mainPanel:SetPos(w/2 - 210, h/2 - 290)
	mainPanel:MakePopup()
	mainPanel:SetDraggable(false)
	mainPanel:SetTitle("Employment Panel")
	mainPanel.Paint = function()
		draw.RoundedBox(0,0,0,500,650,Color(70,70,70,252))
		draw.RoundedBox(0,0,30,500,2,Color(200,200,200))
	end

	mainPanel.Header = vgui.Create("DLabel",mainPanel)
	mainPanel.Header:SetFont("jobnpc_font_big_outline")
	mainPanel.Header:SetPos(60,70)
	mainPanel.Header:SetTextColor(Color(240,240,240))
	mainPanel.Header:SetText("Employement Menu")
	mainPanel.Header:SizeToContents()

	mainPanel.Header2 = vgui.Create("DLabel",mainPanel)
	mainPanel.Header2:SetFont("jobnpc_font")
	mainPanel.Header2:SetPos(50,130)
	mainPanel.Header2:SetTextColor(Color(240,240,240))
	mainPanel.Header2:SetText("Choose a job bellow and we will test your skills.")
	mainPanel.Header2:SizeToContents()

	mainPanel.JobList = vgui.Create("DPanel", mainPanel)
	mainPanel.JobList:Dock(FILL)
	mainPanel.JobList:DockMargin(5,200,5,5)
	mainPanel.JobList.Paint = function()
		draw.RoundedBox(0,0,0,1000,1000,Color(150,150,150))
	end

	mainPanel.JobList.Scroll = vgui.Create("DScrollPanel", mainPanel.JobList)
	mainPanel.JobList.Scroll:Dock(FILL)

	for i=1,#jobs do
		local job = vgui.Create("DButton",mainPanel.JobList)
		job:Dock(TOP)
		job:SetText("")
		job:SetSize(0,50)
		job:SetTextColor(Color(0,0,0))
		job.DoClick = function() 

		 net.Start("jobnpc_prepareTest_request")
		 net.WriteString(jobs[i])
		 net.SendToServer()

		end

		job.label = vgui.Create("DLabel", job)
		job.label:SetPos(10,10)
		job.label:SetText(jobs[i])
		job.label:SetFont("jobnpc_font_big")
		job.label:SetTextColor(GetJobColor(jobs[i]))
		job.label:SizeToContents()

		mainPanel.JobList.Scroll:Add(job)


	end


end

net.Receive("jobnpc_superadmin_menu", function() SuperadminMenu(net.ReadTable(), net.ReadTable(), net.ReadEntity()) end)
net.Receive("jobnpc_player_menu",function() PlayerMenu(net.ReadTable(), net.ReadEntity())  end)
net.Receive("jobnpc_prepareTest", function() PrepareTest(net.ReadString()) if not (mainPanel == nil) then mainPanel:Close() end end)
net.Receive("jobnpc_showmessage", function() ShowMessage(net.ReadString()) end)