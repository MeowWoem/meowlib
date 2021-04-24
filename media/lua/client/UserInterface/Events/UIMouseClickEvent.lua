require "MeowCore";

MeowCore.namespace("Client/UserInterface/Events");
local UIMouseClickEvent = MeowCore.derive(
	"Client/UserInterface/Events//UIMouseClickEvent",
	"Client/UserInterface/Events/UIEvent", {
		x = 0, y = 0
	}
);



MeowCore.Client.UserInterface.Events.UIMouseClickEvent = UIMouseClickEvent;
