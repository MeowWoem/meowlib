require "MeowCore";


local UIPanel = MeowCore.require("Client/UserInterface/UIPanel");
local UIButton = MeowCore.require("Client/UserInterface/UIButton");
local UILayoutGrid = MeowCore.require("Client/UserInterface/Layouts/UILayout");

local UITabPanel = MeowCore.derive("Client/UserInterface/UITabPanel", "Client/UserInterface/UIPanel", {
	tabCurIndex = 0,
	tabs = {},
	elms = {
		tabsbar = nil;
		mainView = nil
	}
});

function UITabPanel:createChildren()

	self.elms.tabsbar = UIPanel:new(0, 0, self.width, 20);

	function self.elms.tabsbar:onMouseWheel(del)
		--Dump(del);
		self:setXScroll(self:getXScroll() - (del*18));
		--panel:setX(panel:getXScroll());
		self:updateScrollbars();
		return true;
	end

	self.elms.tabsbar:initialise();
	self.elms.tabsbar:createLayout(UILayoutGrid);

	self.elms.tabsbar:addHorizontalScrollbar();
	self.elms.tabsbar:setScrollChildren(true);

	self:addToLayout(self.elms.tabsbar);

	--self.mainView = UIPanel:new(0, 20, self.width, self.height - 20);

end

function UITabPanel:addTab(title, content)

	local panel = self;
	local btn1 = UIButton:new(title);

	btn1:initialise();
	btn1:setHeight(20);
	--btn1.tooltipText = "<H1>Test " .. i .. " <LINE> <RESET>TEST " .. i .. " <TEXT>TEST " .. i .. " <META>TEST " .. i;
	btn1.events:addEventListener('MouseDown', function()
		panel.elms.tabsbar:removeFromLayout(btn1);
		Dump("REMOVE " .. title)

		panel:recalcTabsLayout();
	end)
	self.elms.tabsbar:addToLayout(btn1);

	self.tabs[self.tabCurIndex] = {
		tab = btn1,
		panel = nil
	};

	self.tabCurIndex = self.tabCurIndex + 1;
	return self.tabCurIndex - 1;
end

function UITabPanel:recalcTabsLayout()
	self.elms.tabsbar.layout:recalcLayout();
	self.elms.tabsbar:setScrollWidth(self.elms.tabsbar.layout.size.w);

	self.layout:recalcLayout();
end
