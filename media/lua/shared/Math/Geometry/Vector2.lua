require "MeowCore";

MeowCore:namespace("Shared/Math/Geometry");


local Vector2 = {};
Vector2.__type = "Vector2";

local properties = {
	x=0, y=0
}

function Vector2:new(props, y)
	props = props or {};
	local obj = {};
	if(instanceof(props, "IsoGridSquare")) then
		obj.x = props:getX();
		obj.y = props:getY();
	elseif(type(props) == "number" and y ~= nil) then
		obj.x = props;
		obj.y = y;
	else
		obj = props;
	end

	local o = MeowCore.extend({}, properties, obj);

	setmetatable(o, self);
	self.__index = self;

	return o;
end



MeowCore.Shared.Math.Geometry.Vector2 = Vector2;
