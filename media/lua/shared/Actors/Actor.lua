require "MeowCore";

MeowCore:namespace("Shared/Actors");

local Actor = {

}

function Actor:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;
	return o;
end


MeowCore.Shared.Actors.Actor = Actor;
