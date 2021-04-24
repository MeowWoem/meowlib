require "MeowCore";

local UITooltip = MeowCore.derive("Client/UserInterface/UITooltip", "Client/UserInterface/UIPanel", {
	text = "",
	owner = nil
});

function UITooltip:constructor()
	self.text = '';
end

function UITooltip:setOwner(ui)
	self.owner = ui
end

function UITooltip:setDesiredPosition(x, y)
	self.desiredX = x
	self.desiredY = y
	if not x or not y then return end
	self:setX(x)
	self:setY(y)
	if self.owner and self.owner.isButton then
		local ownerRect = { x = self.owner:getAbsoluteX(), y = self.owner:getAbsoluteY(), width = self.owner.width, height = self.owner.height }
		self:adjustPositionToAvoidOverlap(ownerRect)
	end
end

function UITooltip:constructor_string(text)
	self:constructor();
	self.text = text;
end
