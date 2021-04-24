require "MeowCore";

local Vector3 = MeowCore.derive(
	"Shared/Math/Geometry/Vector3",
	"Shared/Math/Geometry/Vector2",
	{ x=0, y=0, z=0 }
);



function Vector3:constructor_number_number_number(x, y, z)
	self.x = x; self.y = y; self.z = z;
end

function Vector3:constructor_IsoGridSquare(square)
	self:constructorXYZ(square:getX(), square:getY(), square:getZ());
end


function Vector3.zero()
	return Vector3:new(0, 0, 0);
end

function Vector3:copy ()
	return Vector3:new(self.x, self.y, self.z);
end

function Vector3:__tostring ()
	return string.format("<Vector3 %f, %f, %f>", self.x, self.y, self.z);
end

function Vector3:__eq (other)
	return self.x == other.x and self.y == other.y and self.z == other.z;
end

function Vector3:__add (other)
	return Vector3:new(self.x + other.x, self.y + other.y, self.z + other.z);
end

function Vector3:__sub (other)
	return Vector3:new(self.x - other.x, self.y - other.y, self.z - other.z);
end

function Vector3:__mul (value)
	return Vector3:new(self.x * value, self.y * value, self.z * value);
end

function Vector3:__div (value)
	return Vector3:new(self.x / value, self.y / value, self.z / value);
end

function Vector3:getX ()
	return self.x;
end
function Vector3:getY ()
	return self.y;
end
function Vector3:getZ ()
	return self.z;
end

function Vector3:isZero ()
	return self.x == 0 and self.y == 0 and self.z == 0;
end

function Vector3:length ()
	return math.sqrt((self.x ^ 2) + (self.y ^ 2) + (self.z ^ 2));
end

function Vector3:lengthSq ()
	return (self.x ^ 2) + (self.y ^ 2) + (self.z ^ 2);
end

function Vector3:normalize ()
	local length = self:length();
	if length > 0 then
		self.x = self.x / length;
		self.y = self.y / length;
		self.z = self.z / length;
	end
end
