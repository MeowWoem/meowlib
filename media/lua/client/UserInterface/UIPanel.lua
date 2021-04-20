require "MeowCore";

MeowCore:namespace("Client/UserInterface");

local UIComponent = MeowCore:require("Client/UserInterface/UIComponent");
local Parent = UIComponent;
local UIPanel = Parent:derive("UIPanel");

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
	Parent.prerender(self);
	self:drawText("UI PANEL", 0, 0, .5, .3, .3, 1, UIFont.Medium);
end

function UIPanel:close()
	self:setVisible(false);
end

function UIPanel:onMouseUp(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    if ISMouseDrag.tabPanel then
        ISMouseDrag.tabPanel:onMouseUp(x,y);
    end

    ISMouseDrag.dragView = nil;
end

function UIPanel:onMouseUpOutside(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    ISMouseDrag.dragView = nil;
end

function UIPanel:onMouseDown(x, y)

    if not self.moveWithMouse then return true; end
    if not self:getIsVisible() then
        return;
    end
    if not self:isMouseOver() then
        return -- this happens with setCapture(true)
    end

    self.downX = x;
    self.downY = y;
    self.moving = true;
    self:bringToTop();
end

function UIPanel:onMouseMoveOutside(dx, dy)
	Parent.onMouseMoveOutside(self, dx, dy);
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
    end
end

function UIPanel:onMouseMove(dx, dy)
	Parent.onMouseMove(self, dx, dy);
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
end

MeowCore.Client.UserInterface.UIPanel = UIPanel;
