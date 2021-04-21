require "MeowCore";

MeowCore:namespace("Client/UserInterface");

local UIPanel = MeowCore:require("Client/UserInterface/UIPanel");
local Color = MeowCore:require("Shared/Types/Color");

local Parent = UIPanel;
local UIButton = Parent:new();
UIButton.__type = "UIButton";
local properties = {
	enable = true,
	joypadFocused = false,
	title = "Button"
}

function UIButton:new(props)
	props = props or {};
	props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
	local o = Parent:new(props);
	o = MeowCore.extend({}, o, props);
	setmetatable(o, self);
	self.__index = self;



	return o;
end

function UIButton:initialise()

	self:loadStyle();

	local tm = getTextManager();
	if self.width < (tm:MeasureStringX(self.style.font, self.title) + 10) then
        self.width = tm:MeasureStringX(self.style.font, self.title) + 10;
    end
	if self.height < (tm:MeasureStringY(self.style.font, self.title) + 10) then
        self.height = tm:MeasureStringY(self.style.font, self.title) + 10;
    end

    Parent.initialise(self);

end
function UIButton:setJoypadFocused(focused)
    self.joypadFocused = focused;
end

function UIButton:prerenderHover()
	if(self.style.hover.background) then
		self.fade:setFadeIn(self.enable and ((self.mouseOver and self:isMouseOver()) or self.joypadFocused) or false);
		self.fade:update();
		local f = self.fade:fraction();
		self.backgroundRect.color = Color:new({
			r=self.style.hover.background.r * f + self.style.background.r * (1 - f),
			g=self.style.hover.background.g * f + self.style.background.g * (1 - f),
			b=self.style.hover.background.b * f + self.style.background.b * (1 - f),
			a=self.style.hover.background.a * f + self.style.background.a * (1 - f),
		});
	end
end

function UIButton:render()
	local height = getTextManager():MeasureStringY(self.style.font, self.title)
	self:drawTextCentre(self.title, self.width / 2, (self.height / 2) - (height/2), self.style.color.r, self.style.color.g, self.style.color.b, self.style.color.a, self.style.font);

end


MeowCore.Client.UserInterface.UIButton = UIButton;
