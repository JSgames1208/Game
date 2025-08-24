local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage:FindFirstChild("Assets")

return function(itemId: string): (Part | Model | MeshPart)?
	for _, f: Folder in Assets:GetChildren() do
		if f:HasTag("ItemFolder") then
			local found = f:FindFirstChild(itemId)
			if found then
				if found:IsA("Model") or found:IsA("Part") or found:IsA("MeshPart") then
					return found
				end
			end
		end
	end

	return Assets.Blocks.undefined
end
