return function(timeInSeconds: number): string
	local minutes = timeInSeconds // 60
	local hours = minutes // 60
	local days = hours // 24
	local weeks = days // 7

	local secsLeft = timeInSeconds % 60
	local minsLeft = minutes % 60
	local hoursLeft = hours % 24
	local daysLeft = days % 7

	local parts = {}

	if weeks > 0 then
		table.insert(parts, weeks .. "w")
	end
	if daysLeft > 0 then
		table.insert(parts, daysLeft .. "d")
	end
	if hoursLeft > 0 then
		table.insert(parts, hoursLeft .. "h")
	end
	if minsLeft > 0 then
		table.insert(parts, minsLeft .. "m")
	end
	if secsLeft > 0 or #parts == 0 then -- always show something
		table.insert(parts, secsLeft .. "s")
	end

	return table.concat(parts, " ")
end
