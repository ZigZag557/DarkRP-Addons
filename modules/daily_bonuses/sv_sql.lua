

sql.Query("DROP TABLE DailyRewards")
if not sql.TableExists("DailyRewards") then
	local t = sql.Query([[
	CREATE TABLE DailyRewards (
		Steam Varchar(18),
		NextMoney int,
		NextTime int,
		NextHP int,
		NextArmor int,
		NextUnjail int,
		NextWep int
	)]])
end

