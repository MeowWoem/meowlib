require "MeowCore";

MeowCore:namespace("Client/UserInterface/Interfaces");

local IUITooltip = {
	tooltip = nil
};

function IUITooltip:testTooltip()
	Dump(ctype(self));
end

MeowCore.Client.UserInterface.Interfaces.IUITooltip = IUITooltip;
