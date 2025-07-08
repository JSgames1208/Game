local Class = {}

function Class.Extend(base)
	local derived = {}
	derived.__index = derived
	setmetatable(derived, { __index = base })
	derived.super = base
	return derived
end

return Class
