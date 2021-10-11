require "MeowCore";


local Dimension2 = MeowCore.class(
	"Shared/Math/Geometry/Dimension2",
	{ w=0, h=0 }
);

function Dimension2:constructor_number_number(w, h)
	self.w = w; self.h = h;
end

function Dimension2:constructor_IsoGridSquare(square)
	self:constructorXY(square:getX(), square:getY());
end


function Dimension2.zero()
	return Dimension2:new(0, 0);
end

function Dimension2:copy ()
	return Dimension2:new(self.w, self.h)
end

function Dimension2:toString ()
	return string.format("<Dimension2 %f, %f>", self.w, self.h)
end

function Dimension2:__eq (other)
	return self.w == other.w and self.h == other.h
end

function Dimension2:__add (other)
	return Dimension2:new(self.w + other.w, self.h + other.h)
end

function Dimension2:__sub (other)
	return Dimension2:new(self.w - other.w, self.h - other.h)
end

function Dimension2:__mul (value)
	return Dimension2:new(self.w * value, self.h * value)
end

function Dimension2:__div (value)
	return Dimension2:new(self.w / value, self.h / value)
end

function Dimension2:getWidth()
	return self.w;
end

function Dimension2:getHeight()
	return self.h;
end

function Dimension2:isZero()
	return self.w == 0 and self.h == 0
end

function Dimension2:square()
	return self.w * self.h;
end
