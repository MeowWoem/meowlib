require "MeowCore";

MeowCore.namespace("Client/UserInterface/Events");
local UIComponentEventsManager = MeowCore.derive("UIComponentEventsManager", "Shared/Events/EventsManager", {
	events = {
		MouseDown = {},
		MouseDownOutside = {},
		MouseUp = {},
		MouseUpOutside = {},
		MouseMove = {},
		MouseMoveOutside = {},
		MouseWheel = {},
		RightMouseDown = {},
		RightMouseDownOutside = {},
		RightMouseUp = {},
		RightMouseUpOutside = {}
	}
});

function UIComponentEventsManager:addEventListener(eventType, listener)
	UIComponentEventsManager:super().addEventListener(self, eventType, listener);
end

function UIComponentEventsManager:removeEventListener(eventType, listener)
	UIComponentEventsManager:super().removeEventListener(self, eventType, listener);
end

function UIComponentEventsManager:trigger(elm, eventType, eventData)
	UIComponentEventsManager:super().trigger(self, elm, eventType, eventData);
end

MeowCore.Client.UserInterface.Events.UIComponentEventsManager = UIComponentEventsManager;
