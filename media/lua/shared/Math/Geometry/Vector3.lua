require "MeowCore";

MeowCore:namespace("Shared/Math/Geometry");
local Vector2 = MeowCore:require("Shared/Math/Geometry/Vector2");

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

	props = MeowCore.extend({}, properties, obj);
	local o = Vector2:new(props);

	setmetatable(o, self);
	self.__index = self;

	return o;
end



MeowCore.Shared.Math.Geometry.Vector3 = Vector3;
