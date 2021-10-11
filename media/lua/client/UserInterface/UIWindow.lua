require "MeowCore";

local UIPanel = MeowCore.require("Client/UserInterface/UIPanel");

local UIWindow = MeowCore.derive("Client/UserInterface/UIWindow", "Client/UserInterface/UIPanel", {
	widgetTextureColor = {r = 1, g = 1, b = 1, a = 1},
	titlebarbkg = getTexture("media/ui/Panel_TitleBar.png"),
	statusbarbkg = getTexture("media/ui/Panel_StatusBar.png"),
	resizeimage = getTexture("media/ui/Panel_StatusBar_Resize.png"),
	invbasic = getTexture("media/ui/Icon_InventoryBasic.png"),
	closeButtonTexture = getTexture("media/ui/Dialog_Titlebar_CloseIcon.png"),
	collapseButtonTexture = getTexture("media/ui/Panel_Icon_Collapse.png"),
	pinButtonTexture = getTexture("media/ui/Panel_Icon_Pin.png"),
	infoBtn = getTexture("media/ui/Panel_info_button.png"),
	pin = true,
	isCollapsed = false,
	collapseCounter = 0,
	title = "",
	viewList = {},
	resizable = true,
	drawFrame = true,
	clearStentil = true,
	titleFont = UIFont.Small,
	titleFontHgt = nil
});

function UIWindow:constructor()
	UIWindow:super().constructor(self);
	self.titleFontHgt = getTextManager():getFontHeight(self.titleFont);
end


function UIWindow:setTitle(title)
	self.title = title;
end

function UIWindow:getTitle()
	return self.title;
end

function UIWindow:createChildren()

	local rh = self:resizeWidgetHeight()
	local th = self:titleBarHeight()

	self.bodyPanel = UIPanel:new(0, th, self.width, self.height-th-rh);
	self.bodyPanel:initialise();
	self:addChild(self.bodyPanel);

	-- Do corner x + y widget
	local resizeWidget = ISResizeWidget:new(self.width-rh, self.height-rh, rh, rh, self);
	resizeWidget:initialise();
	resizeWidget:setVisible(self.resizable)
	self:addChild(resizeWidget);

	self.resizeWidget = resizeWidget;

	-- Do bottom y widget
	resizeWidget = ISResizeWidget:new(0, self.height-rh, self.width-rh, rh, self, true);
    resizeWidget.anchorLeft = true;
	resizeWidget.anchorRight = true;
	resizeWidget:initialise();
	resizeWidget:setVisible(self.resizable)
	--self:addChild(resizeWidget);

	self.resizeWidget2 = resizeWidget;

	self.closeButton = ISButton:new(3, 0, th, th, "", self, self.close);
	self.closeButton:initialise();
	self.closeButton.borderColor.a = 0.0;
	self.closeButton.backgroundColor.a = 0;
	self.closeButton.backgroundColorMouseOver.a = 0;
	self.closeButton:setImage(self.closeButtonTexture);
	self:addChild(self.closeButton);

    self.infoButton = ISButton:new(self.closeButton:getRight() + 1, 0, th, th, "", self, ISCollapsableWindow.onInfo);
    self.infoButton:initialise();
    self.infoButton.borderColor.a = 0.0;
    self.infoButton.backgroundColor.a = 0.0;
    self.infoButton.backgroundColorMouseOver.a = 0.7;
    self.infoButton:setImage(self.infoBtn);
    self:addChild(self.infoButton);
    self.infoButton:setVisible(false);

	--  --print("adding pin button");
	self.pinButton = ISButton:new(self.width - th - 3, 0, th, th, "", self, ISCollapsableWindow.pin);
	self.pinButton.anchorRight = true;
	self.pinButton.anchorLeft = false;
	--  --print("initialising pin button");
	self.pinButton:initialise();
	self.pinButton.borderColor.a = 0.0;
	self.pinButton.backgroundColor.a = 0;
	self.pinButton.backgroundColorMouseOver.a = 0;
	-- --print("setting pin button image");
	self.pinButton:setImage(self.pinButtonTexture);
	--  --print("adding pin button to panel");
	self:addChild(self.pinButton);
	--  --print("set pin button invisible.");
	self.pinButton:setVisible(false);

	-- --print("adding collapse button");
	self.collapseButton = ISButton:new(self.width - th - 3, 0, th, th, "", self, ISCollapsableWindow.collapse);
	self.collapseButton.anchorRight = true;
	self.collapseButton.anchorLeft = false;
	self.collapseButton:initialise();
	self.collapseButton.borderColor.a = 0.0;
	self.collapseButton.backgroundColor.a = 0;
	self.collapseButton.backgroundColorMouseOver.a = 0;
	self.collapseButton:setImage(self.collapseButtonTexture);
	self:addChild(self.collapseButton);
end

function UIWindow:setInfo(text)
    if text then
        self.infoButton:setVisible(true);
        self.infoText = text;
        if self.infoRichText then
            self.infoRichText.chatText.text = text;
            self.infoRichText.chatText:paginate();
            self.infoRichText:setHeight(self.infoRichText.chatText:getHeight() + 40);
            self.infoRichText:ignoreHeightChange()
            self.infoRichText:setY(getCore():getScreenHeight()/2-(self.infoRichText:getHeight()/2));
            self.infoRichText:updateButtons();
        end
    else
        self.infoButton:setVisible(false);
    end
end

function UIWindow:onInfo()
    if not self.infoRichText then
        self.infoRichText = ISModalRichText:new(getCore():getScreenWidth()/2-400,getCore():getScreenHeight()/2-300,600,600,self.infoText, false);
        self.infoRichText:initialise();
        self.infoRichText.style.background = {r=0, g=0, b=0, a=0.9};
        self.infoRichText.alwaysOnTop = true;
        self.infoRichText.chatText:paginate();
        self.infoRichText:setHeightToContents()
        self.infoRichText:ignoreHeightChange()
        self.infoRichText:setY(getCore():getScreenHeight()/2-(self.infoRichText:getHeight()/2));
        self.infoRichText:setVisible(true);
        self.infoRichText:addToUIManager();
    elseif self.infoRichText:isReallyVisible() then
        self.infoRichText:removeFromUIManager()
    else
        self.infoRichText:setVisible(true);
        self.infoRichText:addToUIManager()
    end
end

function UIWindow:close()
	self:setVisible(false);
end

function UIWindow:collapse()
	self.pin = false;
	self.collapseButton:setVisible(false);
	self.pinButton:setVisible(true);
	self.pinButton:bringToTop();
end

function UIWindow:pin()
	self.pin = true;
	self.collapseButton:setVisible(true);
	self.pinButton:setVisible(false);
	self.collapseButton:bringToTop();
end

function UIWindow:prerender()
	local height = self:getHeight();
	local th = self:titleBarHeight()
	if self.isCollapsed then
		height = th;
    end
    if self.drawFrame then
        self:drawRect(0, 0, self:getWidth(), th, self.style.background.a, self.style.background.r, self.style.background.g, self.style.background.b);
        self:drawTextureScaled(self.titlebarbkg, 2, 1, self:getWidth() - 4, th - 2, 1, 1, 1, 1);
        --self:drawRectBorder(0, 0, self:getWidth(), th, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    end
    if self.background and not self.isCollapsed then
		local rh = self:resizeWidgetHeight()
		if not self.resizable or not self.resizeWidget:getIsVisible() then rh = 0 end
        self:drawRect(0, th, self:getWidth(), self.height - th - rh, self.style.background.a, self.style.background.r, self.style.background.g, self.style.background.b);
    end

	if self.clearStentil then
		self:setStencilRect(0,0,self.width, height);
	end

	if self.title ~= nil and self.drawFrame then
		self:drawTextCentre(self.title, self:getWidth() / 2, 1, 1, 1, 1, 1, self.titleBarFont);
	end
end


function UIWindow:render()

	local height = self:getHeight();
	local th = self:titleBarHeight()
	if self.isCollapsed then
		height = th;
	end
	if not self.isCollapsed and self.resizable and self.drawFrame and self.resizeWidget:getIsVisible() then
		local rh = self:resizeWidgetHeight()
		--self:drawRectBorder(0, height-rh-1, self:getWidth(), rh+1, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
		local r, g, b, a = self.widgetTextureColor.r, self.widgetTextureColor.g, self.widgetTextureColor.b, self.widgetTextureColor.a;
		self:drawTextureScaled(self.statusbarbkg, 2,  height-rh, self:getWidth() - 4, rh-1, a, r, g, b);
		self:drawTexture(self.resizeimage, self:getWidth()-9, height-rh, a, r, g, b);
	end

	if self.clearStentil then
		self:clearStencilRect();
	end
    if self.drawFrame then
	    --self:drawRectBorder(0, 0, self:getWidth(), height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    end

	if self.drawJoypadFocus then
		self:drawRectBorder(0, 0, self:getWidth(), self:getHeight(), 0.4, 0.2, 1.0, 1.0);
		self:drawRectBorder(1, 1, self:getWidth()-2, self:getHeight()-2, 0.4, 0.2, 1.0, 1.0);
	end
end

--************************************************************************--
--** UIButton:onMouseMove
--**
--************************************************************************--
function UIWindow:onMouseMove(dx, dy)
	self.mouseOver = true;

	if self.moving then
		self:setX(self.x + dx);
		self:setY(self.y + dy);
		self:bringToTop();
		--ISMouseDrag.dragView = self;
	end
    if not isMouseButtonDown(0) and not isMouseButtonDown(1) and not isMouseButtonDown(2) then
		self:uncollapse();
    end
end

function UIWindow:uncollapse()
	self.collapseCounter = 0;
	if self.isCollapsed and self:getMouseY() < self:titleBarHeight() then
		self.isCollapsed = false;
		self:clearMaxDrawHeight();
		self.collapseCounter = 0;
	end
end
function UIWindow:onResize()

	local rh = self:resizeWidgetHeight();
	local th = self:titleBarHeight();
	self.bodyPanel.backgroundRect.rect.x = 0;
	self.bodyPanel.backgroundRect.rect.y = 0;
	self.bodyPanel.backgroundRect.rect.w = self.width;
	self.bodyPanel.backgroundRect.rect.h = self.height-rh;
	self.bodyPanel:setY(th);
	self.bodyPanel:setWidth(self.width);
	self.bodyPanel:setHeight(self.height-th-rh);
	UIWindow:super().onResize(self);

end

--************************************************************************--
--** UIButton:onMouseMoveOutside
--**
--************************************************************************--
function UIWindow:onMouseMoveOutside(dx, dy)
	self.mouseOver = false;

	if self.moving then
		self:setX(self.x + dx);
		self:setY(self.y + dy);
		self:bringToTop();
	end

	if 	not self.pin and (
		self:getMouseX() < 0 or self:getMouseY() < 0 or
		self:getMouseX() > self:getWidth() or self:getMouseY() > self:getHeight()
	) then
		self.collapseCounter = self.collapseCounter + 1;

		local bDo = true;

		if self.collapseCounter > 20 and not self.isCollapsed and bDo then

			self.isCollapsed = true;
			self:setMaxDrawHeight(self:titleBarHeight());

		end
	end
end


--************************************************************************--
--** UIButton:onMouseUp
--**
--************************************************************************--
function UIWindow:onMouseUp(x, y)
	if not self:getIsVisible() then
		return;
	end

	self.moving = false;
	if ISMouseDrag.tabPanel then
		ISMouseDrag.tabPanel:onMouseUp(x,y);
	end

	ISMouseDrag.dragView = nil;
end

function UIWindow:onMouseUpOutside()
	if not self:getIsVisible() then
		return;
	end

	self.moving = false;
	ISMouseDrag.dragView = nil;
end
function UIWindow:onMouseDown(x, y)

	if not self:getIsVisible() then
		return;
	end

	self.downX = x;
	self.downY = y;
	self.moving = true;
	self:bringToTop();
end

function UIWindow:addView(view)
	view:setX(0);
	view:setY(self:titleBarHeight()); -- below title bar
--	view:initialise();
	self:addChild(view);
	view:setVisible(true);
	table.insert(self.viewList, view);
end

function UIWindow:getViews()
	return self.viewList;
end

function UIWindow:titleBarHeight()
	return math.max(16, self.titleFontHgt + 1)
end

function UIWindow:resizeWidgetHeight()
	return 8;
end

function UIWindow:setResizable(resizable)
	self.resizable = resizable
	if self.resizeWidget then
		self.resizeWidget:setVisible(resizable)
	end
	if self.resizeWidget2 then
		self.resizeWidget2:setVisible(resizable)
	end
end

function UIWindow:RestoreLayout(name, layout)
    ISLayoutManager.DefaultRestoreWindow(self, layout)
    if layout.pin == 'true' then
        UIWindow.pin(self)
    end
end

function UIWindow:SaveLayout(name, layout)
    ISLayoutManager.DefaultSaveWindow(self, layout)
    if self.pin then layout.pin = 'true' else layout.pin = 'false' end
end

function UIWindow:setDrawFrame(visible)
	self.background = visible
	self.drawFrame = visible
	if self.closeButton then
		self.closeButton:setVisible(visible)
		self.pinButton:setVisible(visible and not self.pin)
		self.collapseButton:setVisible(visible and self.pin)
	end
end
