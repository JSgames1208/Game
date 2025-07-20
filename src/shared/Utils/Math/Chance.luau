return function(chance, total)
	local roll = math.random(1, total)
	return roll <= chance
end
