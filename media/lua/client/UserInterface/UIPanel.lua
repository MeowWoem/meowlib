require "MeowCore";
require "ISUI/ISMouseDrag";

local ISScrollBarMinimalist = require "UserInterface/ISScrollBarMinimalist"

local UIPanel = MeowCore.derive("Client/UserInterface/UIPanel", "Client/UserInterface/UIComponent", {
	moveWithMouse = false
});

function UIPanel:prerender()
	UIPanel:super().prerender(self);
	if(self.mouseOver and self.hscroll and not self.hscroll:getIsVisible()) then
		self.hscroll:setVisible(true);
	elseif(not self.mouseOver and self.hscroll and self.hscroll:getIsVisible()) then
		self.hscroll:setVisible(false);
	end
	-- Code, Cred1, Cred2, Dialogue, Intro, Large, MainMenu1, MainMenu2, Massive, Medium, MediumNew,
	-- NewLarge, NewMedium, NewSmall, Small
	--self:drawText("UI PANEL", 0, 0, .5, .3, .3, 1, UIFont.Small);
end

function UIPanel:close()
	self:setVisible(false);
end

function UIPanel:onMouseUp(x, y)
	local event = UIPanel:super().onMouseUp(self, x, y);
	if(event ~= nil and event.preventDefault) then
		return;
	end
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    if ISMouseDrag.tabPanel then
        ISMouseDrag.tabPanel:onMouseUp(x,y);
    end

    ISMouseDrag.dragView = nil;
	--return event;
end

function UIPanel:onMouseUpOutside(x, y)
	local event = UIPanel:super().onMouseUpOutside(self, x, y);
	if(event ~= nil and event.preventDefault) then
		return;
	end
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    ISMouseDrag.dragView = nil;
        return;
end

function UIPanel:onMouseDown(x, y)
	local event = UIPanel:super().onMouseDown(self, x, y);
	if(event ~= nil and event.preventDefault) then
		return;
	end
    if not self.moveWithMouse then return true; end
    if not self:getIsVisible() then
        return;
    end
    if not self:isMouseOver() then
        return; -- this happens with setCapture(true)
    end

    self.downX = x;
    self.downY = y;
    self.moving = true;
    self:bringToTop();
    return;
end

function UIPanel:onMouseMoveOutside(dx, dy)
	local event = UIPanel:super().onMouseMoveOutside(self, dx, dy);
	if(event ~= nil and event.preventDefault) then
		return;
	end
    if not self.moveWithMouse then return end

    if self.moving then
        if self.parent then
            self.parent:setX(self.parent.x + dx);
            self.parent:setY(self.parent.y + dy);
        else
            self:setX(self.x + dx);
            self:setY(self.y + dy);
            self:bringToTop();
        end
    end
	return;
end

function UIPanel:onMouseMove(dx, dy)
	local event = UIPanel:super().onMouseMove(self, dx, dy);
	if(event ~= nil and event.preventDefault) then
		return;
	end
    if not self.moveWithMouse then return; end

    if self.moving then
        if self.parent then
            self.parent:setX(self.parent.x + dx);
            self.parent:setY(self.parent.y + dy);
        else
            self:setX(self.x + dx);
            self:setY(self.y + dy);
            self:bringToTop();
        end
        --ISMouseDrag.dragView = self;
    end
	return;
end


-- TODO : Fix a viewport bug when a scrollbar is added.
--			The right edge of panel can't receive mouse events even if the vertical scrollbar is not visible.
function UIPanel:addScrollBars(addHorizontal)
	self.vscroll = ISScrollBarMinimalist:new(self, true);
	self.vscroll:initialise();
	self:addChild(self.vscroll);
	self.vscroll:bringToTop();
	if addHorizontal then
		self:addHorizontalScrollbar();
	end
end

function UIPanel:addHorizontalScrollbar()
	self.hscroll = ISScrollBarMinimalist:new(self, false)
	self.hscroll:initialise()
	self:addChild(self.hscroll)
	self.hscroll:setVisible(false);
	self.hscroll:bringToTop();
end

function UIPanel:setXScroll(x)
	if self.javaObject == nil then
		return;
	end
    if -x > self:getScrollWidth() - (self:getScrollAreaWidth()) then
        x = -(self:getScrollWidth() - (self:getScrollAreaWidth()));
    end
    if -x < 0 then
        x = 0;
    end
	self.javaObject:setXScroll(x);
end

function UIPanel:updateScrollbars()

    if self.vscroll ~= nil then
        self.vscroll:updatePos();
    end

    if self.hscroll ~= nil then
        self.hscroll:updatePos();
    end

    local y = self.javaObject:getYScroll();

    if -y > self:getScrollHeight() - (self:getScrollAreaHeight()) then
        y = -(self:getScrollHeight() - (self:getScrollAreaHeight()));
    end
    if -y < 0 then
        y = 0;
    end

    self.javaObject:setYScroll(y);

end
