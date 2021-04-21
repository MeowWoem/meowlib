require "MeowCore";

MeowCore.namespace("Shared/Math/Geometry");
local Vector2 = MeowCore.require("Shared/Math/Geometry/Vector2");

local Vector3 = Vector2:new();
Vector3.__type = "Vector3";

local properties = {
	x=0, y=0, z=0
}

function Vector3:new(props, y, z)
	props = props or {};
	local obj = {};
	if(instanceof(props, "IsoGridSquare")) then
		obj.x = props:getX();
		obj.y = props:getY();
		obj.z = props:getZ();
	elseif(type(props) == "number" and y ~= nil and z ~= nil) then
		obj.x = props;
		obj.y = y;
		obj.z = z;
	else
		obj = props;
	end

	props = MeowCore.extend({}, DeepCopyRecursive(properties), obj);
	local o = Vector2:new(props);

	setmetatable(o, self);
	self.__index = self;

	return o;
end


function Vector3.zero()
	return Vector3:new({x=0,y=0,z=0});
end

function Vector3:copy ()
	return Vector3:new({x=self.x, y=self.y, z=self.z});
end

function Vector3:__tostring ()
	return string.format("<Vector3 %f, %f, %f>", self.x, self.y, self.z);
end

function Vector3:__eq (other)
	return self.x == other.x and self.y == other.y and self.z == other.z;
end

function Vector3:__add (other)
	return Vector3:new({x=(self.x + other.x), y=(self.y + other.y), z=(self.z + other.z)});
end

function Vector3:__sub (other)
	return Vector3:new({x=(self.x - other.x), y=(self.y - other.y), z=(self.z - other.z)});
end

function Vector3:__mul (value)
	return Vector3:new({x=(self.x * value), y=(self.y * value), z=(self.z * value)});
end

function Vector3:__div (value)
	return Vector3:new({x=(self.x / value), y=(self.y / value), z=(self.z / value)});
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


MeowCore.Shared.Math.Geometry.Vector3 = Vector3;
