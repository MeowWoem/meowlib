require "MeowCore";
require "ISUI/ISUIElement"

MeowCore:namespace("Client/UserInterface");

local UIStyle = MeowCore:require("Client/UserInterface/UIStyle");

local Parent = ISUIElement;
local UIComponent = Parent:derive("UIComponent");

UIComponent.__type = "UIComponent";

local properties = {
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	anchorLeft = true,
	anchorRight = false,
	anchorTop = true,
	anchorBottom = false,
	style = UIStyle:new(),
    fade = UITransition.new(),
	currentBackground = nil
}

function UIComponent:initialise()
	Parent.initialise(self);
end

function UIComponent:derive(str)
	local c = Parent.derive(self, str);
	c.__type = str;
	return c;
end

function UIComponent:new(props)
	props = MeowCore.extend({}, properties, props);
	local o = Parent:new(props.x, props.y, props.width, props.height);
	o = MeowCore.extend({}, o, props);
	setmetatable(o, self);
	self.__index = self;
	o.currentBackground = o.style.background;
	return o;
end

-- Mouse Handling
function UIComponent:onMouseMove(dx, dy)
	self.mouseOver = self:isMouseOver();
end

function UIComponent:onMouseMoveOutside(dx, dy)
	self.mouseOver = false;
end

function UIComponent:prerenderHover()
	if(self.style.hover.background) then
		self.fade:setFadeIn((self.mouseOver and self:isMouseOver()) or false);
		self.fade:update();
		local f = self.fade:fraction();
		self.currentBackground = Color:new({
			r=self.style.hover.background.r * f + self.style.background.r * (1 - f),
			g=self.style.hover.background.g * f + self.style.background.g * (1 - f),
			b=self.style.hover.background.b * f + self.style.background.b * (1 - f),
			a=self.style.hover.background.a * f + self.style.background.a * (1 - f),
		});
	end
end

function UIComponent:prerender()
	
	self:prerenderHover();

	local style = self.style;
	local bgOffsetW = 0; local bgOffsetH = 0; local bgOffsetX = 0; local bgOffsetY = 0;
	local borderOffsetW = 0; local borderOffsetH = 0; local borderOffsetX = 0; local borderOffsetY = 0;
	-- # 	PREPARE
	-- ## 	Prepare background offset
	-- #### Borders
	if style.border then
		if(style.border.all or style.border.top) then
			local b = style.border.all or style.border.top;
			bgOffsetY = bgOffsetY + b.width;
			bgOffsetH = bgOffsetH - b.width;
		end
		if(style.border.all or style.border.left) then
			local b = style.border.all or style.border.left;
			bgOffsetX = bgOffsetX + b.width;
			bgOffsetW = bgOffsetW - b.width;
		end
		if(style.border.all or style.border.bottom) then
			local b = style.border.all or style.border.bottom;
			bgOffsetH = bgOffsetH - b.width;
		end
		if(style.border.all or style.border.right) then
			local b = style.border.all or style.border.right;
			bgOffsetW = bgOffsetW - b.width;
		end
	end

	-- # 	DRAWING
	-- #	Background
	if self.currentBackground then
		self:drawRectStatic(bgOffsetX, bgOffsetY, self.width + bgOffsetW, self.height + bgOffsetH, self.currentBackground.a, self.currentBackground.r, self.currentBackground.g, self.currentBackground.b);
	end

	if style.border then
		if(style.border.all or style.border.top) then
			local b = style.border.all or style.border.top;
			if(b.width > 0) then
				self:drawRectStatic(0, 0, self.width, b.width, b.color.a, b.color.r, b.color.g, b.color.b);
			end
		end
		if(style.border.all or style.border.left) then
			local b = style.border.all or style.border.left;
			if(b.width > 0) then
				self:drawRectStatic(0, bgOffsetY, b.width, self.height + bgOffsetH, b.color.a, b.color.r, b.color.g, b.color.b);
			end
		end
		if(style.border.all or style.border.bottom) then
			local b = style.border.all or style.border.bottom;
			if(b.width > 0) then
				self:drawRectStatic(0, self.height - b.width, self.width, b.width, b.color.a, b.color.r, b.color.g, b.color.b);
			end
		end
		if(style.border.all or style.border.right) then
			local b = style.border.all or style.border.right;
			if(b.width > 0) then
				local y = 0;
				if((style.border.all or style.border.top) ~= nil) then
					local bTop = style.border.all or style.border.top;
					y = bTop.width;
				end
				self:drawRectStatic(self.width - b.width, y, b.width, self.height + bgOffsetH, b.color.a, b.color.r, b.color.g, b.color.b);
			end
		end

	end

end

MeowCore.Client.UserInterface.UIComponent = UIComponent;
