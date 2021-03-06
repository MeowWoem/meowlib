require "MeowCore";


local Vector2 = MeowCore.class(
	"Shared/Math/Geometry/Vector2",
	{ x=0, y=0 }
);

function Vector2:constructor_number_number(x, y)
	self.x = x; self.y = y;
end

function Vector2:constructor_IsoGridSquare(square)
	self:constructorXY(square:getX(), square:getY());
end


function Vector2.zero()
	return Vector2:new(0, 0);
end

function Vector2:copy ()
	return Vector2:new(self.x, self.y)
end

function Vector2:toString ()
	return string.format("<Vector2 %f, %f>", self.x, self.y)
end

function Vector2:__eq (other)
	return self.x == other.x and self.y == other.y
end

function Vector2:__add (other)
	return Vector2:new(self.x + other.x, self.y + other.y)
end

function Vector2:__sub (other)
	return Vector2:new(self.x - other.x, self.y - other.y)
end

function Vector2:__mul (value)
	return Vector2:new(self.x * value, self.y * value)
end

function Vector2:__div (value)
	return Vector2:new(self.x / value, self.y / value)
end

function Vector2:getX ()
	return self.x;
end

function Vector2:getY ()
	return self.y;
end

function Vector2:isZero ()
	return self.x == 0 and self.y == 0
end

function Vector2:length ()
	return math.sqrt((self.x ^ 2) + (self.y ^ 2))
end

function Vector2:lengthSq ()
	return (self.x ^ 2) + (self.y ^ 2)
end

function Vector2:normalize ()
	local length = self:length()
	if length > 0 then
		self.x = self.x / length
		self.y = self.y / length
	end
end

function Vector2:angle (a, b)
	if(b == nil) then
		b = a;
		a = self;
	end
	return math.acos(math.clamp(a:dot(b), -1, 1)) * 57.29578;
end

function Vector2:dot (a, b)
	if(b == nil) then
		b = a;
		a = self;
	end
	return (a.x * b.x) + (a.y * b.y)
end

function Vector2:perp()
	return Vector2:new(-self.y, self.x)
end

function Vector2:distance(a, b)
	if(b == nil) then
		b = a;
		a = self;
	end
	local v1 = a.x - b.x
	local v2 = a.y - b.y;
	return math.sqrt((v1 * v1) + (v2 * v2));
end
