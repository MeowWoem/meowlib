require "MeowCore";

local typed = MeowCore.Typed("typed");

local Color = MeowCore.require("Shared/Types/Color");

local UIRectBorderStruct = MeowCore.class(
	"Client/UserInterface/UIRectBorderStruct", {
		thickness = 0,
		color = Color.transparent()
	}
);


function UIRectBorderStruct:constructor_integer_Color(thickness, color)
	self.thickness = thickness;
	self.color = typed("Color", color);
end
