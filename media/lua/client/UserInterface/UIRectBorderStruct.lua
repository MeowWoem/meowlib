require "MeowCore";

MeowCore.namespace("Client/UserInterface");

local Color = MeowCore.require("Shared/Types/Color");

local UIRectBorderStruct = {};
UIRectBorderStruct.__type = "UIRectBorderStruct";

local properties = {
	thickness = 0,
	color = Color.transparent()
}

function UIRectBorderStruct:new(props, color)
	props = props or {};
	local obj = {};
	if(isctype("integer", props)) then
		obj.thickness = props;
		obj.color = typed("Color", color);
	else
		obj = props;
	end

	local o = MeowCore.extend({}, DeepCopyRecursive(properties), obj);

	setmetatable(o, self);
	self.__index = self;

	return o;
end

MeowCore.Client.UserInterface.UIRectBorderStruct = UIRectBorderStruct;
