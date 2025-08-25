local EntityStorage = {}

local storage = {}

function EntityStorage.register(model, entity)
	storage[model] = entity
end

function EntityStorage.get(model: any?)
	if model then
		return storage[model]
	else
		return storage
	end
end

function EntityStorage.remove(model: any)
	if storage[model] then
		storage[model] = nil
	end
end

return EntityStorage
