require "MeowCore";
require "ISUI/ISMouseDrag";

MeowCore.namespace("Client/UserInterface");

local UIPanel = MeowCore.derive("UIPanel", "Client/UserInterface/UIComponent", {
	moveWithMouse = false
});


function UIPanel:prerender()
	UIPanel:super().prerender(self);
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
		return event;
	end
    if not self.moveWithMouse then return event; end
    if not self:getIsVisible() then
        return event;
    end

    self.moving = false;
    if ISMouseDrag.tabPanel then
        ISMouseDrag.tabPanel:onMouseUp(x,y);
    end

    ISMouseDrag.dragView = nil;
	return event;
end

function UIPanel:onMouseUpOutside(x, y)
	local event = UIPanel:super().onMouseUpOutside(self, x, y);
	if(event ~= nil and event.preventDefault) then
		return event;
	end
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return event;
    end

    self.moving = false;
    ISMouseDrag.dragView = nil;
        return event;
end

function UIPanel:onMouseDown(x, y)
	local event = UIPanel:super().onMouseDown(self, x, y);
	if(event ~= nil and event.preventDefault) then
		return event;
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
    return event;
end

function UIPanel:onMouseMoveOutside(dx, dy)
	local event = UIPanel:super().onMouseMoveOutside(self, dx, dy);
	if(event ~= nil and event.preventDefault) then
		return event;
	end
    if not self.moveWithMouse then return event; end

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
	return event;
end

function UIPanel:onMouseMove(dx, dy)
	local event = UIPanel:super().onMouseMove(self, dx, dy);
	if(event ~= nil and event.preventDefault) then
		return event;
	end
    if not self.moveWithMouse then return event; end

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
	return event;
end

MeowCore.Client.UserInterface.UIPanel = UIPanel;
