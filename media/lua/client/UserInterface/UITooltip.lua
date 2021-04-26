require "MeowCore";

local UIRichTextPanel = MeowCore.require("Client/UserInterface/UIRichTextPanel");

local UITooltip = MeowCore.derive("Client/UserInterface/UITooltip", "Client/UserInterface/UIPanel", {
	text = "",
	owner = nil,
	followMouse = true
});

function UITooltip:constructor()
	UITooltip:super().constructor(self);
	self.text = '';
	self.descriptionPanel = UIRichTextPanel:new(0, 0, 0, 0);
	self.descriptionPanel:initialise();
	self.descriptionPanel:instantiate();
	self.owner = nil;
	self.followMouse = true;
end

function UITooltip:constructor_string(text)
	self:constructor();
	self.text = text;
end


function UITooltip:setName(name)
	self.name = name;
end

function UITooltip:setContextMenu(contextMenu)
	self.contextMenu = contextMenu;
end

function UITooltip:setTexture(textureName)
	self.texture = getTexture(textureName);
end

function UITooltip:onMouseDown(x, y)
	return false;
end

function UITooltip:onMouseUp(x, y)
	return false;
end

function UITooltip:onRightMouseDown(x, y)
	return false;
end

function UITooltip:onRightMouseUp(x, y)
	return false;
end

function UITooltip:prerender()
	if self.owner and not self.owner:isReallyVisible() then
		self:removeFromUIManager();
		self:setVisible(false);
		return;
	end
	self:doLayout()
	UITooltip:super().prerender(self);
end


--************************************************************************--
--** ISPanel:render
--**
--************************************************************************--
function UITooltip:render()

	local mx = getMouseX() + 32
	local my = getMouseY() + 10
	if not self.followMouse then
		mx = self:getX()
		my = self:getY()
	end
	if self.desiredX and self.desiredY then
		mx = self.desiredX
		my = self.desiredY
	end
	self:setX(mx)
	self:setY(my)

	if self.contextMenu and self.contextMenu.joyfocus then
		local playerNum = self.contextMenu.player
		self:setX(getPlayerScreenLeft(playerNum) + 60);
		self:setY(getPlayerScreenTop(playerNum) + 60);
	elseif self.contextMenu and self.contextMenu.currentOptionRect then
		if self.contextMenu.currentOptionRect.height > 32 then
			self:setY(my + self.contextMenu.currentOptionRect.height)
		end
		self:adjustPositionToAvoidOverlap(self.contextMenu.currentOptionRect)
	elseif self.owner and self.owner.isButton then
		local ownerRect = { x = self.owner:getAbsoluteX(), y = self.owner:getAbsoluteY(), width = self.owner.width, height = self.owner.height }
		self:adjustPositionToAvoidOverlap(ownerRect)
	end

	-- big rectangle (our background)
	--self:drawRect(0, 0, self.width, self.height, 0.7, 0.05, 0.05, 0.05)
	--self:drawRectBorder(0, 0, self.width, self.height, 0.5, 0.9, 0.9, 1)

	-- render texture
	if self.texture then
		local widthTexture = self.texture:getWidth()
		local heightTexture = self.texture:getHeight()
		self:drawTextureScaled(self.texture, 8, 35, widthTexture, heightTexture, 1, 1, 1, 1)
	end

	-- render name
	if self.name then
		self:drawText(self.name, 8, 5, 1, 1, 1, 1, UIFont.Medium)
	end

	self:renderContents()

	-- render a how to rotate message at the bottom if needed
	if self.footNote then
		local fontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
		self:drawTextCentre(self.footNote, self:getWidth() / 2, self:getHeight() - fontHgt - 4, 1, 1, 1, 1, UIFont.Small)
	end
end

function UITooltip:doLayout()
	local textX = 10
	local textY = 0
	local textWidth;
	local textHeight;

	local textureX = 8;
	local textureY = 0;
	local textureWidth;
	local textureHeight = 0;
	if self.texture then
		textureWidth = self.texture:getWidth()
		textureHeight = self.texture:getHeight() + 5
		textX = textureX + textureWidth + 2
	end

	local nameX = 8
	local nameWidth = 0
	local nameHeight = 0
	if self.name then
		nameWidth = getTextManager():MeasureStringX(UIFont.Medium, self.name) + 50
		nameHeight = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
		textureY = 35
		textY = 25
	end

	textWidth, textHeight = self:layoutContents(textX, textY)

	local myWidth = 220
	local myHeight = math.max(nameHeight, math.max(textureY + textureHeight, textY + textHeight))

	if myWidth < textX + textWidth then
		myWidth = textX + textWidth
    end
	if myWidth < nameWidth then
		myWidth = nameWidth
	end

--	if self.texture and myHeight < textureHeight + 40 then
--		myHeight = textureHeight + 40
--	end

	if self.footNote then
		local noteWidth = getTextManager():MeasureStringX(UIFont.Small, self.footNote)
		if myWidth < noteWidth then myWidth = noteWidth end
		local fontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
		myHeight = myHeight + fontHgt + 4
	end

	self:setWidth(myWidth + 20)
	self:setHeight(myHeight)
	self.backgroundRect.rect.w = myWidth + 20;
	self.backgroundRect.rect.h = myHeight;
end

function UITooltip:layoutContents(x, y)
	local textWidth = 0
	local textHeight = 0

	if self.text ~= "" then
		self.descriptionPanel.defaultFont = UIFont.NewSmall
		if getCore():getOptionTooltipFont() == "Large" then
			self.descriptionPanel.defaultFont = UIFont.Large
		elseif getCore():getOptionTooltipFont() == "Medium" then
			self.descriptionPanel.defaultFont = UIFont.Medium
		end
		self.descriptionPanel.text = self.text
		local widthScale = getTextManager():getFontHeight(self.descriptionPanel.defaultFont) / 15
		if self.maxLineWidth then
			self.descriptionPanel.maxLineWidth = self.maxLineWidth * widthScale
			self.descriptionPanel:setWidth(self.descriptionPanel.style.margin.left + self.descriptionPanel.style.margin.right)
		else
			self.descriptionPanel:setWidth(180 * widthScale)
		end
		self.descriptionPanel:paginate()

		local maxLineWidth = 0
		for _,v in ipairs(self.descriptionPanel.lines) do
			local lineWidth = getTextManager():MeasureStringX(self.descriptionPanel.defaultFont, v);
			if lineWidth > maxLineWidth then
				maxLineWidth = lineWidth
			end
		end
		local panelWidth = maxLineWidth + self.descriptionPanel.style.margin.left + self.descriptionPanel.style.margin.right
		if panelWidth > self.descriptionPanel:getWidth() then
			self.descriptionPanel:setWidth(panelWidth)
			self.descriptionPanel:paginate()
--		elseif panelWidth < self.descriptionPanel:getWidth() then
--			self.descriptionPanel:setWidth(panelWidth)
--			self.descriptionPanel:paginate()
		end

		textWidth = self.descriptionPanel:getWidth()
		textHeight = self.descriptionPanel:getHeight()
	end

	return textWidth, textHeight
end

function UITooltip:renderContents()
	if self.text ~= "" then
		if self.texture then
			self.descriptionPanel:setX(self:getAbsoluteX() + 10 + self.texture:getWidth());
		else
			self.descriptionPanel:setX(self:getAbsoluteX() + 10);
		end
		local y = 0
		if self.name then
			y = 25
		end
		self.descriptionPanel:setY(self:getAbsoluteY() + y)
		self.descriptionPanel:prerender()
		self.descriptionPanel:render()
	end
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

function UITooltip:adjustPositionToAvoidOverlap(avoidRect)
	local myRect = { x = self.x, y = self.y, width = self.width, height = self.height }
	if self:overlaps(myRect, avoidRect) then
		local r = self:placeRight(myRect, avoidRect)
		if self:overlaps(r, avoidRect) then
			r = self:placeAbove(myRect, avoidRect)
			if self:overlaps(r, avoidRect) then
				r = self:placeLeft(myRect, avoidRect)
			end
		end
		self:setX(r.x)
		self:setY(r.y)
	end
end

function UITooltip:overlaps(r1, r2)
	return r1.x + r1.width > r2.x and r1.x < r2.x + r2.width and
			r1.y + r1.height > r2.y and r1.y < r2.y + r2.height
end

function UITooltip:placeLeft(r1, r2)
	local r = r1
	r.x = math.max(0, r2.x - r.width - 8)
	return r
end

function UITooltip:placeRight(r1, r2)
	local r = r1
	r.x = r2.x + r2.width + 8
	r.x = math.min(r.x, getCore():getScreenWidth() - r.width)
	return r
end

function UITooltip:placeAbove(r1, r2)
	local r = r1
	r.y = r2.y - r.height - 8
	r.y = math.max(0, r.y)
	return r
end

function UITooltip:setOwner(ui)
	self.owner = ui
end
