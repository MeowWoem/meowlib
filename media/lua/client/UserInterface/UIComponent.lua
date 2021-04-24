require "MeowCore";
require "Theme";



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
	height = 0,
	anchorLeft = true,
	anchorRight = false,
	anchorTop = true,
	anchorBottom = false,
	style = nil,
    fade = UITransition.new(),
	backgroundRect = nil,
	events = UIComponentEventsManager:new()
});

function UIComponent:constructor_integer_integer_integer_integer(x, y, width, height)
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
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

function UIComponent:initialise()
	UIComponent.__super.initialise(self);
	self:loadStyle();

	local bg = UIRectStruct:new();
	bg.rect.x = 0;
	bg.rect.y = 0;
	bg.rect.w = self.width;
	bg.rect.h = self.height;
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



-- Mouse Handling
function UIComponent:onMouseMove(dx, dy)
	if not self:getIsVisible() then
		return;
	end
	local event = UIMouseClickEvent:new({x=dx,y=dy});
	self.mouseOver = self:isMouseOver();
	self.events:trigger(self, "MouseMove", event);
	return event;
end

function UIComponent:onMouseMoveOutside(dx, dy)
	if not self:getIsVisible() then
		return;
	end
	local event = UIMouseClickEvent:new({x=dx,y=dy});
	self.mouseOver = false;
	self.events:trigger(self, "MouseMoveOutside", event);
	return event;
end

function UIComponent:onMouseDown(dx, dy)
	if not self:getIsVisible() then
		return;
	end
	local event = UIMouseClickEvent:new({x=dx,y=dy});
	self.events:trigger(self, "MouseDown", event);
	return event;
end

function UIComponent:onMouseUp(dx, dy)
	if not self:getIsVisible() then
		return;
	end
	local event = UIMouseClickEvent:new({x=dx,y=dy});
	self.events:trigger(self, "MouseUp", event);
	return event;
end

function UIComponent:onMouseUpOutside(dx, dy)
	if not self:getIsVisible() then
		return;
	end
	local event = UIMouseClickEvent:new({x=dx,y=dy});
	self.events:trigger(self, "MouseUpOutside", event);
	return event;
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
