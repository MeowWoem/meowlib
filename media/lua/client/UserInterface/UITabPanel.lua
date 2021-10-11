require "MeowCore";


local UIPanel = MeowCore.require("Client/UserInterface/UIPanel");

local UITabPanel = MeowCore.derive("Client/UserInterface/UITabPanel", "Client/UserInterface/UIPanel", {
	tabs = {},
	elms = {
		tabsbar = nil;
		mainView = nil
	}
});

function UITabPanel:createChildren()

	self.tabsbar = UIPanel:new(0, 0, self.width, 10);
	self.mainView = UIPanel:new(0, 8, self.width, self.height - 10);

end
