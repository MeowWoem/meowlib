require "MeowCore";

MeowCore.namespace("Shared/Events");

local Event = MeowCore.class(
	"Event",
	{ preventDefault = false }
);



MeowCore.Shared.Events.Event = Event;
