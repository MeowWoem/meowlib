require "MeowCore";

MeowCore.namespace("Shared/Math/Geometry");


local Rect2D = MeowCore.class(
	"Rect2D",
	{ x=0, y=0, w=0, h=0 }
);


function Rect2D:constructor_number_number_number_number(x, y, w, h)
	self.x = x;
	self.y = y;
	self.w = w;
	self.h = h;
end

function Rect2D:constructor_Vector2_number_number(pos, w, h)
	self:constructor_number_number_number_number(pos.x, pos.y, w, h);
end

function Rect2D:constructor_number_number_Vector2(x, y, dim)
	self:constructor_number_number_number_number(x, y, dim.x, dim.y);
end

function Rect2D:constructor_Vector2_Vector2(pos, dim)
	self:constructor_number_number_number_number(pos.x, pos.y, dim.x, dim.y);
end

function Rect2D.zero() return Rect2D:new(0,0,0,0) end

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
