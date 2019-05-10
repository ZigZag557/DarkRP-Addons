


local music
local oldPath

local function StartMusic(musicPath)

	if music == nil or not (musicPath == oldPath) then
		if LocalPlayer() == nil or musicPath == nil then return end
		music = CreateSound(LocalPlayer(), musicPath)
		music:Play()
		oldPath = musicPath
	end

	if not music:IsPlaying() then
		music:Play()
	end
end

local function StopMusic(musicPath)
	if not (music == nil) then
		music:FadeOut(1.5)
		oldPath = nil
		music = nil
	end
end



net.Receive("ml_musicStart",function() StartMusic(net.ReadString()) end)
net.Receive("ml_musicStop",function() StopMusic(net.ReadString()) end)