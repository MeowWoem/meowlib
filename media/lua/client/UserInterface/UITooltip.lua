require "MeowCore";

MeowCore.namespace("Client/UserInterface");


local UITooltip = MeowCore.derive("UITooltip", "Client/UserInterface/UIPanel", {
	text = ""
});



function UITooltip:constructor_string(title)
	self.title = title;
end


function UITooltip:render()

end


MeowCore.Client.UserInterface.UITooltip = UITooltip;
