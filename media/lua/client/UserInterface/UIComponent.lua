require "MeowCore";
require "Theme";
require "ISUI/ISUIElement"

MeowCore.namespace("Client/UserInterface");

local UIComponentEventsManager = MeowCore.require("Client/UserInterface/Events/UIComponentEventsManager");
local UIMouseClickEvent = MeowCore.require("Client/UserInterface/Events/UIMouseClickEvent");
local UIRectStruct = MeowCore.require("Client/UserInterface/UIRectStruct");
local Color = MeowCore.require("Shared/Types/Color");
local UIStyle = MeowCore.require("Client/UserInterface/UIStyle");

local Parent = ISUIElement;
local UIComponent = Parent:derive("UIComponent");

UIComponent.__type = "UIComponent";

local properties = {
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
}

local function getRectData(parX, parY, parW, parH, parA, parR, parG, parB)
	local x, y, w, h, a, r, g, b = 0;
	if(isctype("Rect2D", parX)) then
		x = parX.x; y = parX.y;
		w = parX.w; h = parX.h;
		if(isctype("Color", parY)) then
			a = parY.a; r = parY.r; g = parY.g; b = parY.b;
		elseif(isctype("float", parY)) then
			a = parY; r = typed('float', parW);
			b = typed('float', parH); g = typed('float', parA);
		end
	elseif(isctype("integer", parX)) then
		x = parX; y = typed('integer', parY);
		w = typed('integer', parW); h = typed('integer', parH);
		if(isctype("Color", parA)) then
			a = parA.a; r = parA.r; g = parA.g; b = parA.b;
		elseif(isctype("float", parA)) then
			a = parA; r = typed('float', parR);
			b = typed('float', parB); g = typed('float', parG);
		end
	end
	return x, y, w, h, a, r, g, b;
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
	Parent.initialise(self);
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

function UIComponent:new(props)
	props = props or {};
	props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
	local o = Parent:new(props.x, props.y, props.width, props.height);
	o = MeowCore.extend({}, o, props);
	setmetatable(o, self);
	self.__index = self;
	return o;
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


function UIComponent:drawRectStatic(parX, parY, parW, parH, parA, parR, parG, parB)
	local x, y, w, h, a, r, g, b = getRectData(parX, parY, parW, parH, parA, parR, parG, parB);
	Parent.drawRectStatic(self, x, y, w, h, a, r, g, b);
end

function UIComponent:drawRect(parX, parY, parW, parH, parA, parR, parG, parB)
	local x, y, w, h, a, r, g, b = getRectData(parX, parY, parW, parH, parA, parR, parG, parB);
	Parent.drawRect(self, x, y, w, h, a, r, g, b);
end

function UIComponent:drawUIRectStructStatic(uirect)

	local backgroundWithOffset = uirect:getRectWithOffset();

	-- # 	DRAWING
	-- #	Background
	self:drawRectStatic(
		backgroundWithOffset,
		uirect.color
	);

	if(uirect.borders.t.thickness > 0) then
		self:drawRectStatic(
			uirect:getBorderTopRect(),
			uirect.borders.t.color
		);
	end
	if(uirect.borders.l.thickness > 0) then
		self:drawRectStatic(
			uirect:getBorderLeftRect(),
			uirect.borders.l.color
		);
	end
	if(uirect.borders.b.thickness > 0) then
		self:drawRectStatic(
			uirect:getBorderBottomRect(),
			uirect.borders.b.color
		);
	end
	if(uirect.borders.r.thickness > 0) then
		self:drawRectStatic(
			uirect:getBorderRightRect(),
			uirect.borders.r.color
		);
	end

end

function UIComponent:drawUIRectStruct(uirect)

	local backgroundWithOffset = uirect:getRectWithOffset();

	-- # 	DRAWING
	-- #	Background
	self:drawRect(
		backgroundWithOffset,
		uirect.color
	);

	if(uirect.borders.t.thickness > 0) then
		self:drawRect(
			uirect:getBorderTopRect(),
			uirect.borders.t.color
		);
	end
	if(uirect.borders.l.thickness > 0) then
		self:drawRect(
			uirect:getBorderLeftRect(),
			uirect.borders.l.color
		);
	end
	if(uirect.borders.b.thickness > 0) then
		self:drawRect(
			uirect:getBorderBottomRect(),
			uirect.borders.b.color
		);
	end
	if(uirect.borders.r.thickness > 0) then
		self:drawRect(
			uirect:getBorderRightRect(),
			uirect.borders.r.color
		);
	end

end

function UIComponent:drawRectBorderStatic(
		parX, parY, parW, parH,
		parA, parR, parG, parB,
		parWT, parWR, parWB, parWL
	) ---------------------------------
	local x, y, w, h, a, r, g, b = getRectData(parX, parY, parW, parH, parA, parR, parG, parB);
	local wt = typed('integer', parWT or -1);
	local wr = typed('integer', parWR or -1);
	local wb = typed('integer', parWB or -1);
	local wl = typed('integer', parWL or -1);
	--------------
	Dump(a, r, g, b);
	wt = wt > -1 and wt or 1;
	wr = wr > -1 and wr or wt;
	wb = wb > -1 and wb or wt;
	wl = wl > -1 and wl or wl;

	local offsetY = 0;
	local offsetH = 0;

	if(wt > 0) then
		self:drawRect(x, y, w, wt, a, r, g, b);
		offsetY = offsetY + wt;
	end

	if(wb > 0) then
		self:drawRectStatic(x, h - wb, w, wb, a, r, g, b);
		offsetH = offsetH + wb;
	end

	if(wl > 0) then
		self:drawRectStatic(x, y + offsetY, wl, h - offsetH, a, r, g, b);
	end

	if(wr > 0) then
		self:drawRectStatic(w - wr, y + offsetY, wr, h - offsetH, a, r, g, b);
	end

end

function UIComponent:drawRectBorder(
		parX, parY, parW, parH,
		parA, parR, parG, parB,
		parWT, parWR, parWB, parWL
	) ---------------------------------
	local x, y, w, h, a, r, g, b = getRectData(parX, parY, parW, parH, parA, parR, parG, parB);
	local wt = typed('integer', parWT or -1);
	local wr = typed('integer', parWR or -1);
	local wb = typed('integer', parWB or -1);
	local wl = typed('integer', parWL or -1);
	--------------
	Dump(a, r, g, b);
	wt = wt > -1 and wt or 1;
	wr = wr > -1 and wr or wt;
	wb = wb > -1 and wb or wt;
	wl = wl > -1 and wl or wl;

	local offsetY = 0;
	local offsetH = 0;

	if(wt > 0) then
		self:drawRect(x, y, w, wt, a, r, g, b);
		offsetY = offsetY + wt;
	end

	if(wb > 0) then
		self:drawRect(x, h - wb, w, wb, a, r, g, b);
		offsetH = offsetH + wb;
	end

	if(wl > 0) then
		self:drawRect(x, y + offsetY, wl, h - offsetH, a, r, g, b);
	end

	if(wr > 0) then
		self:drawRect(w - wr, y + offsetY, wr, h - offsetH, a, r, g, b);
	end

end



MeowCore.Client.UserInterface.UIComponent = UIComponent;
