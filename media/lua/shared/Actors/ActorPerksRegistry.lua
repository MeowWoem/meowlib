require "MeowCore";

local ActorPerk = MeowCore.require('Shared/Actors/ActorPerk');

local ActorPerksRegistry = MeowCore.class(
	"Shared/Actors/ActorPerksRegistry", {
		perks = {}
	}
);

function ActorPerksRegistry:constructor()
	local perks = {};
	-- we start to fetch all our perks
	for i = 0, PerkFactory.PerkList:size() - 1 do
		local perk = PerkFactory.PerkList:get(i);
		-- we only add in our list the child perk
		-- here we just display the active skill, not the passive ones (they are in another tab)
		if perk:getParent() ~= Perks.None then
			-- we take the longest skill's name as width reference
			if not perks[perk:getParent()] then
				perks[perk:getParent()] = {};
			end
			table.insert(perks[perk:getParent()], ActorPerk:new(perk));
		end
	end
	self.perks = perks;
end
