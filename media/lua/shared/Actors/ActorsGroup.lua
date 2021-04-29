require "MeowCore";

local ActorsGroupMember = MeowCore.require("Shared/Actors/ActorsGroupMember");

local ActorsGroup = MeowCore.class(
	"Shared/Actors/ActorsGroup", {
		uuid = nil,
		name = "My Group";
		leader = nil,
		leaderIsPlayer = false,
		actors = {}
	}
);

function ActorsGroup:constructor_table(tbl)
	self.uuid = tbl.uuid; -- Idea "Loaders" - Format example of tbl.loader is "Namespace/To/MyClass"
	self.leader = ActorsGroupMember:new(tbl.leader);
	self.leaderIsPlayer = tbl.leaderIsPlayer;
	for i,v in ipairs(tbl.actors) do
		tbl.actors[i] = ActorsGroupMember:new(v);
	end
end

function ActorsGroup:constructor_PlayerActor(player)

	self.uuid = MeowCore.uuid();

	self.leader = ActorsGroupMember:new(player);
	self.leader.isLeader = true;
	self.leaderIsPlayer = true;
	self.actors = { self.leader	};

end

function ActorsGroup:getLeaderActor()
	return self.leader:getActor();
end
