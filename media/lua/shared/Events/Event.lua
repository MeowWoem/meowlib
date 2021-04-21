require "MeowCore";

MeowCore.namespace("Shared/Events");


local Event = {};
Event.__type = "Event";

local properties = {
	preventDefault = false
}

function Event:new(props)
	props = props or {};
	props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
	local o = {};
	o = MeowCore.extend({}, o, props);
	setmetatable(o, self);
	self.__index = self;
	return o;
end



MeowCore.Shared.Events.Event = Event;
