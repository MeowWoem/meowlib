require "MeowCore";

MeowCore:namespace("Shared/Math/Geometry");


local Rect2D = {};
Rect2D.__type = "Rect2D";

local properties = {
	x=0, y=0, w=0, h=0
}

function Rect2D:new(props, y, w, h)
	props = props or {};
	local obj = {};
	if(type(props) == "number" and y ~= nil and w ~= nil and h ~= nil) then
		obj.x = props;
		obj.y = y;
		obj.w = w;
		obj.h = h;
	else
		obj = props;
	end

	local o = MeowCore.extend({}, properties, obj);

	setmetatable(o, self);
	self.__index = self;

	return o;
end

function Rect2D:calculateArea()
	return self.w * self.h;
end

function Rect2D:overlap(a, b)
	if(b == nil) then
		b = a;
		a = self;
	end
	return a.x < b.x + b.w and
		a.x + a.w > b.x and
		a.y > b.y + b.h and
		a.y + a.h < b.h;
end

function Rect2D:getX1()
	return self.x;
end

function Rect2D:getY1()
	return self.y;
end

function Rect2D:getX2()
	return self.x + self.w;
end

function Rect2D:getY2()
	return self.y + self.h;
end

function Rect2D:getX()
	return self:getX1();
end

function Rect2D:getY()
	return self:getY1();
end

function Rect2D:getWidth()
	return self.w;
end

function Rect2D:getHeight()
	return self.h;
end

MeowCore.Shared.Math.Geometry.Rect2D = Rect2D;
