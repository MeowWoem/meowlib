require "MeowCore";
require "ISUI/ISUIElement"

MeowCore:namespace("Client/UserInterface");

local UIStyle = MeowCore:require("Client/UserInterface/UIStyle");

local Parent = ISUIElement;
local UIComponent = Parent:derive("UIComponent");

UIComponent.__type = "UIComponent";

local properties = {
	anchorLeft = true,
	anchorRight = false,
	anchorTop = true,
	anchorBottom = false,
	style = UIStyle:new()
}

function UIComponent:initialise()
	Parent.initialise(self);
end

function UIComponent:derive(str)
	local c = Parent.derive(self, str);
	c.__type = str;
	return c;
end

function UIComponent:new(x, y, width, height)
	local o = Parent:new(x, y, width, height);
	MeowCore.extend(o, properties);
	setmetatable(o, self);
	self.__index = self;
	o.x = x;
	o.y = y;
	o.width = width;
	o.height = height;
	return o;
end

function UIComponent:prerender()
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
	if style.background then
		self:drawRectStatic(bgOffsetX, bgOffsetY, self.width + bgOffsetW, self.height + bgOffsetH, style.background.a, style.background.r, style.background.g, style.background.b);
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
