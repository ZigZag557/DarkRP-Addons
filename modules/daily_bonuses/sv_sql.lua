


if not sql.TableExists("DailyRewards") then
	local t = sql.Query([[
	CREATE TABLE DailyRewards (
		Steam Varchar(18),
		NextDaily int,
		NextHP int,
		NextArmor int,
		NextUnjail int
	)]])
end

