require "MeowCore";

local typed	= MeowCore.Typed("typed");

local Color = MeowCore.require("Shared/Types/Color");
local Rect2D = MeowCore.require("Shared/Math/Geometry/Rect2D");
local UIRectBorderStruct = MeowCore.require("Client/UserInterface/UIRectBorderStruct");


local UIRectStruct = MeowCore.class(
	"Client/UserInterface/UIRectStruct", {
		rect = Rect2D.zero(),
		color = Color.white(),
		borders = {
			t = UIRectBorderStruct:new(),
			r = UIRectBorderStruct:new(),
			b = UIRectBorderStruct:new(),
			l = UIRectBorderStruct:new()
		}
	}
);


local function setBorderProp(instance, border, prop, value)
	instance.borders[border][prop] = value;
end

local function setBorderThickness(instance, border, thickness)
	thickness = typed("integer", thickness);
	setBorderProp(instance, border, 'thickness', thickness);
end

local function setBorderColor(instance, border, color)
	color = typed("Color", color);
	setBorderProp(instance, border, 'color', color);
end

function UIRectBorderStruct:constructor_Rect2D_Color(rect, color)
	self.rect = rect;
	self.color = typed("Color", color);
end

function UIRectStruct:setBorder(thickness, color)
	self:setBorderThickness(thickness);
	self:setBorderColor(color);
end

function UIRectStruct:setBorderThickness(thickness)
	self:setBorderTopThickness(thickness);
	self:setBorderRightThickness(thickness);
	self:setBorderBottomThickness(thickness);
	self:setBorderLeftThickness(thickness);
end

function UIRectStruct:setBorderTop(thickness, color)
	self:setBorderTopThickness(thickness);
	self:setBorderTopColor(color);
end

function UIRectStruct:setBorderRight(thickness, color)
	self:setBorderRightThickness(thickness);
	self:setBorderRightColor(color);
end

function UIRectStruct:setBorderBottom(thickness, color)
	self:setBorderBottomThickness(thickness);
	self:setBorderBottomColor(color);
end

function UIRectStruct:setBorderLeft(thickness, color)
	self:setBorderLeftThickness(thickness);
	self:setBorderLeftColor(color);
end

function UIRectStruct:setBorderTopThickness(thickness)
	setBorderThickness(self, 't', thickness);
end

function UIRectStruct:setBorderRightThickness(thickness)
	setBorderThickness(self, 'r', thickness);
end

function UIRectStruct:setBorderBottomThickness(thickness)
	setBorderThickness(self, 'b', thickness);
end

function UIRectStruct:setBorderLeftThickness(thickness)
	setBorderThickness(self, 'l', thickness);
end

function UIRectStruct:setBorderColor(color)
	self:setBorderTopColor(color);
	self:setBorderRightColor(color);
	self:setBorderBottomColor(color);
	self:setBorderLeftColor(color);
end

function UIRectStruct:setBorderTopColor(color)
	setBorderColor(self, 't', color);
end

function UIRectStruct:setBorderRightColor(color)
	setBorderColor(self, 'r', color);
end

function UIRectStruct:setBorderBottomColor(color)
	setBorderColor(self, 'b', color);
end

function UIRectStruct:setBorderLeftColor(color)
	setBorderColor(self, 'l', color);
end

function UIRectStruct:getRectOffset()
	return Rect2D:new(
		self.borders.t.thickness, self.borders.l.thickness,
		self.borders.r.thickness, self.borders.b.thickness
	);
end

function UIRectStruct:getRectWithOffset()
	local offset = self:getRectOffset();
	return Rect2D:new(
		self.rect.x + offset.x, self.rect.y + offset.y,
		self.rect.w - offset.w - offset.x, self.rect.h - offset.h - offset.y
	);
end

function UIRectStruct:getBorderTopRect()
	return Rect2D:new(
		self.rect.x, self.rect.y,
		self.rect.w, self.borders.t.thickness
	);
end

function UIRectStruct:getBorderLeftRect()
	local offset = self:getRectOffset();
	return Rect2D:new(
		self.rect.x, self.rect.y + offset.y,
		self.borders.l.thickness, self.rect.h - offset.h - offset.y
	);
end

function UIRectStruct:getBorderBottomRect()
	return Rect2D:new(
		self.rect.x, self.rect.h - self.borders.b.thickness,
		self.rect.w, self.borders.b.thickness
	);
end

function UIRectStruct:getBorderRightRect()
	local offset = self:getRectOffset();
	return Rect2D:new(
		self.rect.w - self.borders.r.thickness, self.rect.y + offset.y,
		self.borders.t.thickness, self.rect.h - offset.h - offset.y
	);
end
