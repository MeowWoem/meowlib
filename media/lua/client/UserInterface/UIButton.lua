require "MeowCore";

local Color = MeowCore.require("Shared/Types/Color");
local UITooltip = MeowCore.require("Client/UserInterface/UITooltip");



local UIButton = MeowCore.derive("Client/UserInterface/UIButton", "Client/UserInterface/UIPanel", {
	enable = true,
	pressed = false,
	allowMouseUpProcessing = false,
	target = nil,
	isJoypad = false,
	joypadFocused = false,
	title = "",
	overlayText = nil,
    forcedWidthImage = nil,
    forcedHeightImage = nil,
	tooltip = UITooltip:new(),
	tooltipText = "",
});


function UIButton:constructor_string(title)
	self:constructor();
	self.title = title;
end

function UIButton:initialise()

	self.tooltip = UITooltip:new();
	self.tooltip:initialise();
	self.tooltip.initialised = false;

	local tm = getTextManager();
	if self.width < (tm:MeasureStringX(self.style.font, self.title) + 10) then
        self.width = tm:MeasureStringX(self.style.font, self.title) + 10;
    end
	if self.height < (tm:MeasureStringY(self.style.font, self.title) + 10) then
        self.height = tm:MeasureStringY(self.style.font, self.title) + 10;
    end

    UIButton:super().initialise(self);

end


function UIButton:setImage(image)
	self.image = image;
end

function UIButton:setJoypadFocused(focused)
    self.joypadFocused = focused;
end

function UIButton:setJoypadButton(texture)
    self.isJoypad = true;
    self.joypadTexture = texture;
end

function UIButton:onMouseUp(x, y)
	local event = UIButton:super().onMouseUp(self, x, y);

	if(type(event) == "table" and event.preventDefault) then
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
	if(type(event) == "table" and event.preventDefault) then
		return event;
	end
end

function UIButton:onMouseDown(x, y)
	local event = UIButton:super().onMouseDown(self, x, y);
	if(type(event) == "table" and event.preventDefault) then
		return event;
	end
	if not self:getIsVisible() then
		return;
	end
    self.pressed = true;
    if self.onmousedown == nil or not self.enable then
		return;
    end
	--self.onmousedown(self.target, self, x, y);
end

function UIButton:onMouseDoubleClick(x, y)
	return self:onMouseDown(x, y)
end

function UIButton:forceClick()
    if not self:getIsVisible() or not self.enable then
        return;
    end
    if self.repeatWhilePressedFunc then
		return self.repeatWhilePressedFunc(self.target, self)
    end
	-- Click event
end

function UIButton:setRepeatWhilePressed(func)
	self.repeatWhilePressedFunc = func
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

	if self:isMouseOver() then
		if(not self.tooltip.initialised) then
			self.tooltip:setOwner(self);
			self.tooltip:setVisible(false);
			self.tooltip:setAlwaysOnTop(true);
			self.tooltip.initialised = true;
		end
		if not self.tooltip:getIsVisible() then
			if string.contains(self.tooltip.text, "\n") then
				self.tooltip.maxLineWidth = 1000 -- don't wrap the lines
			else
				self.tooltip.maxLineWidth = 300
			end
			self.tooltip:addToUIManager()
			self.tooltip:setVisible(true)
		end
		self.tooltip.text = self.tooltipText;
		self.tooltip:setDesiredPosition(getMouseX(), self:getAbsoluteY() + self:getHeight() + 8)
	else
		if self.tooltip and self.tooltip:getIsVisible() then
			self.tooltip:setVisible(false)
			self.tooltip:removeFromUIManager()
		end
    end
end

function UIButton:render()
	--Dump((getTimestamp() - last));
	local height = getTextManager():MeasureStringY(self.style.font, self.title)

	if self.image ~= nil then
--        print("btn:image")

        if self.forcedWidthImage and self.forcedHeightImage then

            self:drawTextureScaledAspect(
				self.image,
				(self.width / 2) - (self.forcedWidthImage / 2),
				(self.height / 2) - (self.forcedHeightImage / 2),
				self.forcedWidthImage, self.forcedHeightImage,
				self.style.textureColor.a, self.style.textureColor.r, self.style.textureColor.g, self.style.textureColor.b
			);

		elseif self.image:getWidthOrig() <= self.width and self.image:getHeightOrig() <= self.height then

            self:drawTexture(
				self.image,
				(self.width / 2) - (self.image:getWidthOrig() / 2),
				(self.height / 2) - (self.image:getHeightOrig() / 2),
				self.style.textureColor.a, self.style.textureColor.r, self.style.textureColor.g, self.style.textureColor.b
			);

        else

            self:drawTextureScaledAspect(
				self.image, 0, 0, self.width, self.height,
				self.style.textureColor.a, self.style.textureColor.r, self.style.textureColor.g, self.style.textureColor.b
			);

		end
	end

	-- Text

	if self.enable then
		self:drawTextCentre(
			self.title, self.width / 2, (self.height / 2) - (height/2),
			self.style.color.r, self.style.color.g, self.style.color.b, self.style.color.a, self.style.font
		);
	elseif self.displayBackground and not self.isJoypad and self.joypadFocused then
		self:drawTextCentre(
			self.title, self.width / 2, (self.height / 2) - (height/2),
			self.style.color.r, self.style.color.g, self.style.color.b, self.style.color.a, self.style.font
		);
	else
		self:drawTextCentre(
			self.title, self.width / 2, (self.height / 2) - (height/2),
			self.style.color.r, self.style.color.g, self.style.color.b, self.style.color.a, self.style.font
		);
	end
	if self.overlayText then
		self:drawTextRight(self.overlayText, self.width, self.height - height, 1, 1, 1, 0.5, UIFont.Small);
	end

end


function UIButton:update()
    breakpoint();


	ISUIElement.update(self)
	if self.enable and self.pressed and self.target and self.repeatWhilePressedFunc then
		if not self.pressedTime then
			self.pressedTime = getTimestampMs()
			self.repeatWhilePressedFunc(self.target, self)
		else
			local ms = getTimestampMs()
			if ms - self.pressedTime > 500 then
				self.pressedTime = ms
				self.repeatWhilePressedFunc(self.target, self)
			end
		end
	else
		self.pressedTime = nil
	end
end
