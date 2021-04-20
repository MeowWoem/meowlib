require "MeowCore";

MeowCore:namespace("Client/UserInterface");

local Color = MeowCore:require("Shared/Types/Color");
local Rect2D = MeowCore:require("Shared/Math/Geometry/Rect2D");
local UIRectBorderStruct = MeowCore:require("Client/UserInterface/UIRectBorderStruct");

local UIRectStruct = {};
UIRectStruct.__type = "UIRectStruct";

local properties = {
	rect = Rect2D.zero(),
	color = Color.white(),
	borders = {
		t = UIRectBorderStruct:new(),
		r = UIRectBorderStruct:new(),
		b = UIRectBorderStruct:new(),
		l = UIRectBorderStruct:new()
	}
}

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

function UIRectStruct:new(props, color)
	props = props or {};
	local obj = {};
	if(isctype("Rect2D", props)) then
		obj.rect = props;
		obj.color = typed("Color", color);
	else
		obj = props;
	end

	local o = MeowCore.extend({}, properties, obj);

	setmetatable(o, self);
	self.__index = self;

	return o;
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

MeowCore.Shared.Math.Geometry.UIRectStruct = UIRectStruct;
