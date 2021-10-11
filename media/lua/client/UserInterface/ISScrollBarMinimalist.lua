require "ISUI/ISUIElement"

local ISScrollBarMinimalist = ISUIElement:derive("ISScrollBarMinimalist");


--************************************************************************--
--** ISScrollBarMinimalist:initialise
--**
--************************************************************************--

function ISScrollBarMinimalist:initialise()
	ISUIElement.initialise(self);
end

function ISScrollBarMinimalist:onMouseDown(x, y)

	self.scrolling = false;
	if self.barwidth == 0 or self.barheight == 0 then
		return false
	end
	if (x >= self.barx and x <= self.barx + self.barwidth) then

		if (y >= self.bary and y <= self.bary + self.barheight) then
			self.scrolling = true;
			self:setCapture(true)
		end

	end
end

function ISScrollBarMinimalist:onMouseUp(x, y)
	self.scrolling = false;
	self:setCapture(false)
end

function ISScrollBarMinimalist:refresh()
	if self.vertical then
		local sh = self.parent:getScrollHeight();

		if(sh > self.parent:getScrollAreaHeight()) then

			--print(-self.parent:getYScroll());
			--print(sh - self.parent:getHeight());
			if -self.parent:getYScroll() > sh - self.parent:getScrollAreaHeight() then
				self.parent:setYScroll(-(sh - self.parent:getScrollAreaHeight()));
			end
		end
	else
		local sw = self.parent:getScrollWidth()
		if sw > self.parent:getScrollAreaWidth() then
			if -self.parent:getXScroll() > sw - self.parent:getScrollAreaWidth() then
				self.parent:setXScroll(-(sw - self.parent:getScrollAreaWidth()))
			end
		end
	end
end

function ISScrollBarMinimalist:onMouseUpOutside(x, y)
	self.scrolling = false;
	self:setCapture(false)
end

function ISScrollBarMinimalist:onMouseMoveOutside(dx, dy)
	self:onMouseMove(dx, dy);
end

function ISScrollBarMinimalist:updatePos()
	if self.vertical then
		local sh = self.parent:getScrollHeight();

		if(sh and self.parent and sh > self.parent:getScrollAreaHeight()) then

			local dif = self.parent:getScrollAreaHeight();

			local yscroll = -self.parent:getYScroll();

			--self.parent:setYScroll(-(self.pos * (sh - self.parent:getHeight())));
			self.pos = yscroll / (sh - dif);

			if(self.pos < 0) then
				self.pos = 0;
			end
			if(self.pos > 1) then
				self.pos = 1;
			end
		end
	else
		local sw = self.parent:getScrollWidth()
		if self.parent and sw > self.parent:getScrollAreaWidth() then
			local parentWidth = self.parent:getScrollAreaWidth()
			local xscroll = -self.parent:getXScroll()
			self.pos = xscroll / (sw - parentWidth)
			if self.pos < 0 then
				self.pos = 0
			end
			if self.pos > 1 then
				self.pos = 1
			end
		end
	end
end

function ISScrollBarMinimalist:onMouseMove(dx, dy)
	if self.scrolling then
		if self.vertical then
			local sh = self.parent:getScrollHeight();

			if(sh > self.parent:getScrollAreaHeight()) then

				local del = self:getHeight() / sh;

				local boxheight = del * (self:getHeight()- (20 * 2));

				local dif = self:getHeight() - (20 * 2) - boxheight ;
				self.pos = self.pos + (dy / dif);

				if(self.pos < 0) then
					self.pos = 0;
				end
				if(self.pos > 1) then
					self.pos = 1;
				end
				self.parent:setYScroll(-(self.pos * (sh - self.parent:getScrollAreaHeight())));

			end
		else
			local sw = self.parent:getScrollWidth()
			if sw > self.parent:getScrollAreaWidth() then
				local del = self:getWidth() / sw
				local boxheight = del * (self:getWidth()- (20 * 2))
				local dif = self:getWidth() - (20 * 2) - boxheight
				self.pos = self.pos + (dx / dif)
				if self.pos < 0 then
					self.pos = 0
				end
				if self.pos > 1 then
					self.pos = 1
				end
				self.parent:setXScroll(-(self.pos * (sw - self.parent:getScrollAreaWidth())))
			end
		end
	end
end

--************************************************************************--
--** ISScrollBarMinimalist:instantiate
--**
--************************************************************************--
function ISScrollBarMinimalist:instantiate()
	--self:initialise();
	self.javaObject = UIElement.new(self);
	if self.vertical then
		self.anchorLeft = false;
		self.anchorRight = true;
		self.anchorBottom = true;
		self.x = self.parent.width - 16; -- FIXME, width is 17
		self.y = 0;
		self.width = 17;
		self.height = self.parent.height;
	else
		self.anchorTop = false
		self.anchorRight = true
		self.anchorBottom = true
		self.x = 0
		self.y = self.parent.height - 2 -- FIXME, height is 17
		self.width = self.parent.width
		self.height = 2
	end

	self.javaObject:setX(self.x);
	self.javaObject:setY(self.y);
	self.javaObject:setHeight(self.height);
	self.javaObject:setWidth(self.width);
	self.javaObject:setAnchorLeft(self.anchorLeft);
	self.javaObject:setAnchorRight(self.anchorRight);
	self.javaObject:setAnchorTop(self.anchorTop);
	self.javaObject:setAnchorBottom(self.anchorBottom);
    self.javaObject:setScrollWithParent(false);
end

function ISScrollBarMinimalist:render()

	if self.vertical then
		local sh = self.parent:getScrollHeight();

		if(sh > self:getHeight()) then

			if self.doSetStencil then
				self:setStencilRect(0, 0, self.width, self.height)
			end
            if self.background then
			    self:drawRect(4, 0, self.width - 4 - 1, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
            end

			local del = self:getHeight() / sh;

			local boxheight = del * (self:getHeight() - (16 * 2));
			boxheight = math.max(boxheight, 8)

			local dif = self:getHeight() - (16 * 2) - boxheight ;
			dif = dif * self.pos;

			self.barx = 4;
			self.bary = 16 + dif;
			self.barwidth = 8;
			self.barheight = boxheight;

            self:drawRect( 2+3, self.bary+2, 9, self.barheight-4, 1, 1, 1, 1);


			if self.doSetStencil then
				self:clearStencilRect()
			end
			if self.doRepaintStencil then
--				self:repaintStencilRect(0, 0, self.width, self.height)
			end
        else
			self.barx = 0;
			self.bary = 0;
			self.barwidth = 0;
			self.barheight = 0;
		end
	else
		local sw = self.parent:getScrollWidth()
		if sw > self:getWidth() then
			if self.doSetStencil then
				self:setStencilRect(0, 0, self.width, self.height)
			end
			if self.background then
				--self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
			end

			local del = self:getWidth() / sw
			local boxwidth = del * (self:getWidth() - (16 * 2))
			boxwidth = math.max(boxwidth, 8)

			local dif = self:getWidth() - boxwidth
			dif = dif * self.pos

			self.barx = dif
			self.bary = 4
			self.barwidth = boxwidth
			self.barheight = 8

			self:drawRect(self.barx, 0, self.barwidth, 2, 1, 1, 1, 1)

			if self.doSetStencil then
				self:clearStencilRect()
			end
			if self.doRepaintStencil then
--				self:repaintStencilRect(0, 0, self.width, self.height)
			end
		else
			self.barx = 0
			self.bary = 0
			self.barwidth = 0
			self.barheight = 0
		end
	end
end
--************************************************************************--
--** ISPanel:new
--**
--************************************************************************--
function ISScrollBarMinimalist:new (parent, vertical)
	local o = {}
	--o.data = {}
	o = ISUIElement:new(0, 0, 0, 0);
	setmetatable(o, self)
	self.__index = self

	o.backgroundColor = {r=0, g=0, b=0, a=1.0};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};

    o.anchorLeft = true;
	o.anchorRight = false;
	o.anchorTop = true;
	o.anchorBottom = false;
	o.parent = parent;
	o.vertical = vertical;
	o.pos = 0;
	o.scrolling = false;
	if vertical then
		o.uptex = getTexture("media/ui/Panel_VScroll_ButtonUp.png");
		o.downtex = getTexture("media/ui/Panel_VScroll_ButtonDown.png");
		o.toptex = getTexture("media/ui/Panel_VScroll_BarTop.png");
		o.midtex = getTexture("media/ui/Panel_VScroll_BarMid.png");
		o.bottex = getTexture("media/ui/Panel_VScroll_BarBot.png");
	else
		o.uptex = getTexture("media/ui/Panel_HScroll_ButtonLeft.png");
		o.downtex = getTexture("media/ui/Panel_HScroll_ButtonRight.png");
		o.toptex = getTexture("media/ui/Panel_HScroll_BarLeft.png");
		o.midtex = getTexture("media/ui/Panel_HScroll_BarMid.png");
		o.bottex = getTexture("media/ui/Panel_HScroll_BarRight.png");
	end
    o.background = true;
	return o
end

return ISScrollBarMinimalist;
