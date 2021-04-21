require "MeowCore";

MeowCore:namespace("Client/UserInterface");

local UIComponent = MeowCore:require("Client/UserInterface/UIComponent");

local UIPanel = UIComponent:new();
UIPanel.__type = 'UIPanel';

local properties = {
	moveWithMouse = false
}

function UIPanel:new(props)
	props = props or {};
	props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
	local o = UIComponent:new(props);
	o = MeowCore.extend({}, o, props);
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function UIPanel:prerender()
	UIComponent.prerender(self);
	-- Code, Cred1, Cred2, Dialogue, Intro, Large, MainMenu1, MainMenu2, Massive, Medium, MediumNew, NewLarge, NewMedium, NewSmall, Small
	--self:drawText("UI PANEL", 0, 0, .5, .3, .3, 1, UIFont.Small);
end

function UIPanel:close()
	self:setVisible(false);
end

function UIPanel:onMouseUp(x, y)
	local event = UIComponent.onMouseUp(self, x, y);
	if(event.preventDefault) then
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
	local event = UIComponent.onMouseUpOutside(self, x, y);
	if(event.preventDefault) then
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
	local event = UIComponent.onMouseDown(self, x, y);
	if(event.preventDefault) then
		return event;
	end
    if not self.moveWithMouse then return true; end
    if not self:getIsVisible() then
        return event;
    end
    if not self:isMouseOver() then
        return event; -- this happens with setCapture(true)
    end

    self.downX = x;
    self.downY = y;
    self.moving = true;
    self:bringToTop();
    return event;
end

function UIPanel:onMouseMoveOutside(dx, dy)
	local event = UIComponent.onMouseMoveOutside(self, dx, dy);
	if(event.preventDefault) then
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
	local event = UIComponent.onMouseMove(self, dx, dy);
	if(event.preventDefault) then
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
