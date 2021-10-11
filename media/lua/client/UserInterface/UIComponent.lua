require "MeowCore";
require "Theme";

local ctype = MeowCore.Typed("ctype");

local UIComponentEventsManager,
	UIMouseClickEvent,
	UIRectStruct,
	Color,
	UIStyle = MeowCore.require(
	"Client/UserInterface/Events/UIComponentEventsManager",
	"Client/UserInterface/Events/UIMouseClickEvent",
	"Client/UserInterface/UIRectStruct",
	"Shared/Types/Color",
	"Client/UserInterface/UIStyle"
);

local UIComponent = MeowCore.derive("Client/UserInterface/UIComponent", "Client/UserInterface/ISUIBridge", {
	theme = nil,
	x = 0,
	y = 0,
	width = 0,
	minimumWidth = 10,
	height = 0,
	minimumHeight = 8,
	anchorLeft = true,
	anchorRight = false,
	anchorTop = true,
	anchorBottom = false,
	style = nil,
	layout = nil,
    fade = UITransition.new(),
	backgroundRect = nil,
	events = UIComponentEventsManager:new()
});

function UIComponent:constructor()
	self:loadStyle();
	self.fade = UITransition.new();
end

function UIComponent:constructor_integer_integer_integer_integer(x, y, width, height)
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	self:constructor();
end

function UIComponent:constructor_Rect2D(rect)
	self:constructor_integer_integer_integer_integer(rect.x, rect.y, rect.w, rect.h);
end

function UIComponent:constructor_integer_integer_Vector2(x, y, dim)
	self:constructor_integer_integer_integer_integer(x, y, dim.x, dim.y);
end

function UIComponent:constructor_Vector2_integer_integer(pos, width, height)
	self:constructor_integer_integer_integer_integer(pos.x, pos.y, width, height);
end

function UIComponent:constructor_Vector2_Vector2(pos, dim)
	self:constructor_integer_integer_integer_integer(pos.x, pos.y, dim.x, dim.y);
end

function UIComponent:loadStyle()
	if(self.theme ~= nil) then
		self.style = MeowCore.Client.Theme[self.theme];
	end
	if(self.theme == nil or self.style == nil) then
		self.style = MeowCore.Client.Theme[ctype(self)];
	end
	if(self.style == nil) then
		self.style = UIStyle:new();
	end
end

function UIComponent:createLayout(layoutType)
	self.layout = layoutType:new(self);
end

function UIComponent:setLayout(layout)
	self.layout = layout;
end

function UIComponent:addToLayout(child)
	if(not self.layout) then return end
	self.layout:addChild(child);
end

function UIComponent:removeFromLayout(child)
	if(not self.layout) then return end
	self.layout:removeChild(child);
end

function UIComponent:setX(x)
	UIComponent:super().setX(self, x);
end

function UIComponent:setY(y)
	UIComponent:super().setY(self, y);
end

function UIComponent:setWidth(w)
   UIComponent:super().setWidth(self, w);
   self.backgroundRect.rect.w = math.max(self.width, self.minimumWidth);
end

function UIComponent:setHeight(h)
   UIComponent:super().setHeight(self, h);
   self.backgroundRect.rect.h = math.max(self.height, self.minimumHeight);
end

function UIComponent:initialise()
	UIComponent.__super.initialise(self);
	local bg = UIRectStruct:new();
	bg.rect.x = 0;
	bg.rect.y = 0;
	bg.rect.w = math.max(self.width, self.minimumWidth);
	bg.rect.h = math.max(self.height, self.minimumHeight);
	bg.color = self.style.background;
	self.backgroundRect = bg;

	local sb = self.style.border;

	if(sb.top or sb.all) then
		local b = sb.top or sb.all;
		bg:setBorderTop(b.width, b.color);
	end
	if(sb.right or sb.all) then
		local b = sb.right or sb.all;
		bg:setBorderRight(b.width, b.color);
	end
	if(sb.bottom or sb.all) then
		local b = sb.bottom or sb.all;
		bg:setBorderBottom(b.width, b.color);
	end
	if(sb.left or sb.all) then
		local b = sb.left or sb.all;
		bg:setBorderLeft(b.width, b.color);
	end

	return self;
end

function ISUIElement:setXScroll(x)
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

function UIComponent:updateScrollbars()

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

-- Mouse Handling
function UIComponent:onMouseMove(dx, dy)
	if not self:getIsVisible() then
		return;
	end
	local event = UIMouseClickEvent:new({x=dx,y=dy});
	self.mouseOver = self:isMouseOver();
	self.events:trigger(self, "MouseMove", event);
	--return event;
end

function UIComponent:onMouseMoveOutside(dx, dy)
	if not self:getIsVisible() then
		return;
	end
	local event = UIMouseClickEvent:new({x=dx,y=dy});
	self.mouseOver = false;
	self.events:trigger(self, "MouseMoveOutside", event);
	--return event;
end

function UIComponent:onMouseDown(dx, dy)
	if not self:getIsVisible() then
		return;
	end
	local event = UIMouseClickEvent:new({x=dx,y=dy});
	self.events:trigger(self, "MouseDown", event);
	--return event;
end

function UIComponent:onMouseUp(dx, dy)
	if not self:getIsVisible() then
		return;
	end
	local event = UIMouseClickEvent:new({x=dx,y=dy});
	self.events:trigger(self, "MouseUp", event);
	--return event;
end

function UIComponent:onMouseUpOutside(dx, dy)
	if not self:getIsVisible() then
		return;
	end
	local event = UIMouseClickEvent:new({x=dx,y=dy});
	self.events:trigger(self, "MouseUpOutside", event);
	--return event;
end

function UIComponent:prerenderHover()
	if(self.style.hover.background) then
		self.fade:setFadeIn((self.mouseOver and self:isMouseOver()) or false);
		self.fade:update();
		local f = self.fade:fraction();
		self.backgroundRect.color = Color:new({
			r=self.style.hover.background.r * f + self.style.background.r * (1 - f),
			g=self.style.hover.background.g * f + self.style.background.g * (1 - f),
			b=self.style.hover.background.b * f + self.style.background.b * (1 - f),
			a=self.style.hover.background.a * f + self.style.background.a * (1 - f),
		});
	end
end

function UIComponent:prerender()

	self:prerenderHover();
	self:drawUIRectStructStatic(self.backgroundRect);

end
