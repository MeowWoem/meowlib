require "MeowCore";

local UITooltip = MeowCore.derive("Client/UserInterface/UITooltip", "Client/UserInterface/UIPanel", {
	text = ""
});

function UITooltip:constructor_string(title)
	self.title = title;
end


function UITooltip:render()

end
