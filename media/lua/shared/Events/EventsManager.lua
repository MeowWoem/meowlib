require "MeowCore";

MeowCore.namespace("Shared/Events");

local EventsManager = MeowCore.class(
	"EventsManager",
	{ events = {} }
);


function EventsManager:addEventListener(eventType, listener)
	if(self.events[eventType] == nil) then self.events[eventType] = {} end
	self.events[eventType][tostring(listener)] = listener;
end

function EventsManager:removeEventListener(eventType, listener)
	if(self.events[eventType] == nil) then return end
	self.events[eventType][tostring(listener)] = nil;
end

function EventsManager:trigger(elm, eventType, eventData)
	if(self.events[eventType]) then
		for _, v in pairs(self.events[eventType]) do
			v(elm, eventData);
		end
	end
end

MeowCore.Shared.Events.EventsManager = EventsManager;
