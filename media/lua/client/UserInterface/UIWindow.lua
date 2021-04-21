require "MeowCore";
--[[
MeowCore.namespace("Client/UserInterface");
local UIPanel = MeowCore.require("Client/UserInterface/UIPanel");
local Parent = UIPanel;
local UIWindow = Parent:derive("UIWindow");

function UIWindow:initialise()
	Parent.initialise(self);
end

function UIWindow:new(x, y, width, height)
	local o = Parent:new(x, y, width, height);
	setmetatable(o, self);
	self.__index = self;
    o.moveWithMouse = false;
	o.anchorLeft = true;
	o.anchorRight = false;
	o.anchorTop = true;
	o.anchorBottom = false;
	o.widgetTextureColor = {r = 1, g = 1, b = 1, a = 1};
	o.titlebarbkg = getTexture("media/ui/Panel_TitleBar.png");
	o.statusbarbkg = getTexture("media/ui/Panel_StatusBar.png");
	o.resizeimage = getTexture("media/ui/Panel_StatusBar_Resize.png");
	o.invbasic = getTexture("media/ui/Icon_InventoryBasic.png");
	o.closeButtonTexture = getTexture("media/ui/Dialog_Titlebar_CloseIcon.png");
	o.collapseButtonTexture = getTexture("media/ui/Panel_Icon_Collapse.png");
	o.pinButtonTexture = getTexture("media/ui/Panel_Icon_Pin.png");
    o.infoBtn = getTexture("media/ui/Panel_info_button.png");
	o.pin = true;
	o.isCollapsed = false;
	o.collapseCounter = 0;
	o.title = nil;
    o.viewList = {}
    o.resizable = true
    o.drawFrame = true
	o.clearStentil = true;
	o.titleFont = UIFont.Small
	o.titleFontHgt = getTextManager():getFontHeight(o.titleFont)
	return o;
end


MeowCore.Client.UserInterface.UIWindow = UIWindow;

]]--
