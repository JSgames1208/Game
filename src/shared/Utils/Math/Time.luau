local Time = {}

function Time.GetTimeUntilNext5MinMark()
	local timeNow = os.time()
	local s = timeNow % 60
	local m = math.floor(timeNow / 60)
	local minutesUntilNext = 5 - (m % 5)

	local totalWait = (minutesUntilNext * 60) - s
	return totalWait
end

return Time
