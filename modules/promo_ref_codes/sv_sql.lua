

if not sql.TableExists("ActivePromoCodes") then
	sql.Query([[
	CREATE TABLE ActivePromoCodes (
		Code Varchar(12),
		Reward Varchar(20)
	)]])
end


if not sql.TableExists("SpecialPromoCodes") then
	sql.Query([[
	CREATE TABLE SpecialPromoCodes (
		Code Varchar(12),
		Reward Varchar(20),
		Expiration int
	)]])
end


if not sql.TableExists("SpecialPromoCodeUsers") then
	local t = sql.Query([[
	CREATE TABLE SpecialPromoCodeUsers (
		Steam Varchar(20),
		Code Varchar(12)
	)]])
end


if not sql.TableExists("PlayerRefList") then
	sql.Query(
	[[CREATE TABLE PlayerRefList (
		Steam Varchar(20),
		RefUsed BIT,
		RefAmount tinyint,
		RefToReward tinyint
	)]])
end


local function RemoveExpiredPromocodes()
	local codeTimes = sql.Query("SELECT * FROM SpecialPromoCodes")
	local sysTime = os.time()
	
	if codeTimes == nil then return end
	
	for i=1,#codeTimes do
		if sysTime >= tonumber(codeTimes[i].Expiration) then
			sql.Query("DELETE FROM SpecialPromoCodes WHERE Code = '"..tostring(codeTimes[i].Code).."'")
			sql.Query("DELETE FROM SpecialPromoCodeUsers WHERE Code = '"..tostring(codeTimes[i].Code).."'")
			print("[PromoCodes] Code '"..tostring(codeTimes[i].Code).."' has expired.")
		end
	end


end

RemoveExpiredPromocodes() -- Remove expired codes when the server starts.
timer.Create("remove_expired_promocodes", 300, 0, RemoveExpiredPromocodes)

