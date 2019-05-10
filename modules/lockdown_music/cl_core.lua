

local music
local musicPath = "music/HL2_song33.mp3"


timer.Create("lockdownCheckTimer",1,0,
	function() 
		if LocalPlayer() == nil then return end
		if GetGlobalBool("DarkRP_LockDown") then
			if music == nil or not music:IsPlaying() then music = CreateSound(LocalPlayer(), musicPath ) music:Play() end
		else
			if music ~= nil then music:FadeOut(1.5) music = nil end
		end
	end)