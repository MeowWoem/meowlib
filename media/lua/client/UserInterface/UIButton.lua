require "MeowCore";

MeowCore.namespace("Client/UserInterface");

local Color = MeowCore.require("Shared/Types/Color");

local UIButton = MeowCore.derive("UIButton", "Client/UserInterface/UIPanel");
MeowCore.interface(UIButton, "Client/UserInterface/Interfaces/IUITooltip");

local properties = {
	enable = true,
	pressed = false,
	allowMouseUpProcessing = false,
	target = nil,
	joypadFocused = false,
	title = "Button"
}

function UIButton:new(props)
	props = props or {};
	props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
	local o = UIButton:super():new(props);
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

    UIButton:super().initialise(self);

end

function UIButton:setJoypadFocused(focused)
    self.joypadFocused = focused;
end

function UIButton:onMouseUp(x, y)
	local event = UIButton:super().onMouseUp(self, x, y);

	if(event ~= nil and event.preventDefault) then
		return event;
	end
    if not self:getIsVisible() then
        return;
    end
    local process = false;
    if self.pressed == true then
        process = true;
    end
    self.pressed = false;

    if self.enable and (process or self.allowMouseUpProcessing) then
		-- TODO: On click
    end

	return event;
end

function UIButton:onMouseUpOutside(x, y)
    self.pressed = false;
	local event = UIButton:super().onMouseUpOutside(self, x, y);
	if(event ~= nil and event.preventDefault) then
		return event;
	end
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
	self:drawTextCentre(
		self.title, self.width / 2, (self.height / 2) - (height/2),
		self.style.color.r, self.style.color.g, self.style.color.b, self.style.color.a, self.style.font
	);

end


MeowCore.Client.UserInterface.UIButton = UIButton;
