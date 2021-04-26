require "MeowCore"

local Color = MeowCore.require("Shared/Types/Color");


local UIRichTextPanel = MeowCore.derive("Client/UserInterface/UIRichTextPanel", "Client/UserInterface/UIPanel", {
    contentTransparency = 1.0,
	autosetheight = true,
	text = "",
	textDirty = false,
	clip = false,
	maxLines = 0,
	textColor = Color:red()
});

UIRichTextPanel.drawMargins = false



function UIRichTextPanel:processCommand(command, x, y, lineImageHeight, lineHeight)
    if command == "LINE" then
        x = 0;
        lineImageHeight = 0;
        y = y + lineHeight;

    end
    if command == "BR" then
        x = 0;
        lineImageHeight = 0;
        y = y + lineHeight + lineHeight;

    end
    if command == "RESET" then
        self.orient[self.currentLine] = "left";
        self.rgb[self.currentLine] = self.style.color;
        self.font = self.style.font;
        self.fonts[self.currentLine] = self.font;
    end
    if command == "H1" then
        self.orient[self.currentLine] = "centre";
        self.rgb[self.currentLine] = self.style.richText.H1.color;
        self.font = self.style.richText.H1.font;
        self.fonts[self.currentLine] = self.font;
    end
    if command == "H2" then
        self.orient[self.currentLine] = "left";
        self.rgb[self.currentLine] = self.style.richText.H2.color;
        self.font = self.style.richText.H2.font;
        self.fonts[self.currentLine] = self.font;
    end
    if command == "TEXT" then
        self.orient[self.currentLine] = "left";
        self.rgb[self.currentLine] = self.style.richText.TEXT.color;
        self.font = self.style.richText.TEXT.font;
        self.fonts[self.currentLine] = self.font;
    end
    if command == "META" then
        self.orient[self.currentLine] = "left";
        self.rgb[self.currentLine] = self.style.richText.META.color;
        self.font = self.style.richText.META.font;
        self.fonts[self.currentLine] = self.font;
    end
    if command == "CENTRE" then
        self.orient[self.currentLine] = "centre";
    end

    if command == "LEFT" then
        self.orient[self.currentLine] = "left";
    end

    if command == "RIGHT" then
        self.orient[self.currentLine] = "right";
    end
    if string.find(command, "RGB:") then
		local rgb = string.split(string.sub(command, 5, string.len(command)), ",");
		self.rgb[self.currentLine] = Color:new(unpack(rgb));
    end
    if string.find(command, "RED") then
        self.rgb[self.currentLine] = {};
        self.rgb[self.currentLine].r = 1;
        self.rgb[self.currentLine].g = 0;
        self.rgb[self.currentLine].b = 0;
        self.rgb[self.currentLine].a = 1;
    end
    if string.find(command, "ORANGE") then
        self.rgb[self.currentLine] = {};
        self.rgb[self.currentLine].r = 0.9;
        self.rgb[self.currentLine].g = 0.3;
        self.rgb[self.currentLine].b = 0;
        self.rgb[self.currentLine].a = 1;
    end
    if string.find(command, "GREEN") then
        self.rgb[self.currentLine] = {};
        self.rgb[self.currentLine].r = 0;
        self.rgb[self.currentLine].g = 1;
        self.rgb[self.currentLine].b = 0;
        self.rgb[self.currentLine].a = 1;
    end
    if string.find(command, "SIZE:") then

		local size = string.sub(command, 6);
--~         print(size);
		if(size == "small") then
			self.font = UIFont.NewSmall;
		end
		if(size == "medium") then
			self.font = UIFont.Medium;
		end
		if(size == "large") then
			self.font = UIFont.Large;
		end
		self.fonts[self.currentLine] = self.font;
	end

    if string.find(command, "IMAGE:") ~= nil then
        local w = 0;
        local h = 0;
        if string.find(command, ",") ~= nil then
            local vs = string.split(command, ",");

            command = string.trim(vs[1]);
            w = tonumber(string.trim(vs[2]));
            h = tonumber(string.trim(vs[3]));

        end
        self.images[self.imageCount] = getTexture(string.sub(command, 7));
        if(w==0) then
            w = self.images[self.imageCount]:getWidth();
            h = self.images[self.imageCount]:getHeight();
        end
        if(x + w >= self.width - (self.style.margin.left + self.style.margin.right)) then
            x = 0;
            y = y +  lineHeight;
        end

        if(lineImageHeight < (h / 2) + 8) then
            lineImageHeight = (h / 2) + 8;
        end

        if self.images[self.imageCount] == nil then
            --print("Could not find texture");
        end
        self.imageX[self.imageCount] = x+2;
        self.imageY[self.imageCount] = y;
        self.imageW[self.imageCount] = w;
        self.imageH[self.imageCount] = h;
        self.imageCount = self.imageCount + 1;
        x = x + w + 7;

        local newY = math.max(y + (h / 2) - 7, y)

        local c = 1;
        for i,v in ipairs(self.lines) do
            if self.lineY[c] == y then
                self.lineY[c] = newY;
            end
            c = c + 1;
        end

        y = newY;
    end


    if string.find(command, "IMAGECENTRE:") ~= nil then
        local w = 0;
        local h = 0;
        if string.find(command, ",") ~= nil then
            local vs = string.split(command, ",");

            command = string.trim(vs[1]);
            w = tonumber(string.trim(vs[2]));
            h = tonumber(string.trim(vs[3]));

        end
        self.images[self.imageCount] = getTexture(string.sub(command, 13));
        if(w==0) then
            w = self.images[self.imageCount]:getWidth();
            h = self.images[self.imageCount]:getHeight();
        end
        if(x + w >= self.width - (self.style.margin.left + self.style.margin.right)) then
            x = 0;
            y = y +  lineHeight;
        end

        if(lineImageHeight < (h / 2) + 8) then
            lineImageHeight = (h / 2) + 16;
        end

        if self.images[self.imageCount] == nil then
            --print("Could not find texture");
        end
        local mx = (self.width / 2) - self.style.margin.left;
        self.imageX[self.imageCount] = mx - (w/2);
        self.imageY[self.imageCount] = y;
        self.imageW[self.imageCount] = w;
        self.imageH[self.imageCount] = h;
        self.imageCount = self.imageCount + 1;
        x = x + w + 7;

        local c = 1;
        for i,v in ipairs(self.lines) do
            if self.lineY[c] == y then
                self.lineY[c] = self.lineY[c] + (h / 2);
            end
            c = c + 1;
        end

        y = y + (h / 2);
    end


    return x, y, lineImageHeight;

end

function UIRichTextPanel:onMouseWheel(del)
	self:setYScroll(self:getYScroll() - (del*18));
    return true;
end
--************************************************************************--
--** UIRichTextPanel:paginate
--**
--** Splits multiline text up into seperate lines, and positions images to be
--** rendered
--************************************************************************--
function UIRichTextPanel:paginate()
	local lines = 1;
	self.textDirty = false;
	self.imageCount = 1;
	self.font = self.style.font;
	self.fonts = {};
	self.images = {}
	self.imageX = {}
	self.imageY = {}
	self.rgb = {};
    self.orient = {}

	self.imageW = {}
	self.imageH = {}

	self.lineY = {}
	self.lineX = {}
	self.lines = {}
	local bDone = false;
	local leftText = self.text..' ';
	local cur = 0;
	local y = 0;
	local x = 0;
	local lineImageHeight = 0;
	leftText = leftText:gsub("\n", " <LINE> ")
	if self.maxLines > 0 then
		local lines = leftText:split("<LINE>")
		for i=1,(#lines - self.maxLines) do
			table.remove(lines,1)
		end
		leftText = ' '
		for k,v in ipairs(lines) do
			leftText = leftText..v.." <LINE> "
		end
	end
	local maxLineWidth = self.maxLineWidth or (self.width - self.style.margin.right - self.style.margin.left)
	-- Always go through at least once.
	while not bDone do
		cur = string.find(leftText, " ", cur+1);
		if cur ~= nil then
			local token = string.sub(leftText, 0, cur);
			if string.find(token, "<") and string.find(token, ">") then -- handle missing ' ' after '>'
				cur = string.find(token, ">") + 1;
				token = string.sub(leftText, 0, cur - 1);
			end
			leftText = string.sub(leftText, cur);
			cur = 1
			if string.find(token, "<") and string.find(token, ">") then
				if not self.lines[lines] then
					self.lines[lines] = ''
					self.lineX[lines] = x
					self.lineY[lines] = y
				end
				lines = lines + 1
				local st = string.find(token, "<");
				local en = string.find(token, ">");
				local escSeq = string.sub(token, st+1, en-1);
				local lineHeight = getTextManager():getFontFromEnum(self.font):getLineHeight();
				if lineHeight < 10 then
					lineHeight = 10;
				end
				if lineHeight < lineImageHeight then
					lineHeight = lineImageHeight;
				end
				self.currentLine = lines;
				x, y, lineImageHeight = self:processCommand(escSeq, x, y, lineImageHeight, lineHeight);
			else
				if token:contains("&lt;") then
					token = token:gsub("&lt;", "<")
				end
				if token:contains("&gt;") then
					token = token:gsub("&gt;", ">")
				end
				local chunkText = self.lines[lines] or ''
				local chunkX = self.lineX[lines] or x
				if chunkText == '' then
					chunkText = string.trim(token)
				else
					chunkText = chunkText..' '..string.trim(token)
				end
				local pixLen = getTextManager():MeasureStringX(self.font, chunkText);
				if chunkX + pixLen > maxLineWidth then
					if self.lines[lines] and self.lines[lines] ~= '' then
						lines = lines + 1;
					end
					local lineHeight = getTextManager():getFontFromEnum(self.font):getLineHeight();
					if lineHeight < lineImageHeight then
						lineHeight = lineImageHeight;
					end
					lineImageHeight = 0;
					y = y + lineHeight;
					x = 0;
					self.lines[lines] = string.trim(token)
					self.lineX[lines] = x
					self.lineY[lines] = y
					x = x + getTextManager():MeasureStringX(self.font, self.lines[lines])
				else
					if not self.lines[lines] then
						self.lines[lines] = ''
						self.lineX[lines] = x
						self.lineY[lines] = y
					end
					self.lines[lines] = chunkText
					x = self.lineX[lines] + pixLen
				end
			end
        else
			if string.trim(leftText) ~= '' then
				local str = leftText
				if str:contains("&lt;") then
					str = str:gsub("&lt;", "<")
				end
				if str:contains("&gt;") then
					str = str:gsub("&gt;", ">")
				end
				self.lines[lines] = string.trim(str);
				self.lineX[lines] = x;
				self.lineY[lines] = y;
				local lineHeight = getTextManager():getFontFromEnum(self.font):getLineHeight();
				y = y + lineHeight
			elseif self.lines[lines] and self.lines[lines] ~= '' then
				local lineHeight = getTextManager():getFontFromEnum(self.font):getLineHeight();
				if lineHeight < lineImageHeight then
					lineHeight = lineImageHeight;
				end
				y = y + lineHeight
			end
			bDone = true;
		end
	end
	if(self.autosetheight) then
		self:setHeight(self.style.margin.top + y + self.style.margin.bottom);
    end

    self:setScrollHeight(self.style.margin.top + y + self.style.margin.bottom);
end

function UIRichTextPanel:setContentTransparency(alpha)
    self.contentTransparency = alpha;
end

--************************************************************************--
--** UIRichTextPanel:render
--**
--************************************************************************--
function UIRichTextPanel:render()

    self.textColor.r = self.style.color.r;
    self.textColor.g = self.style.color.g;
    self.textColor.b = self.style.color.b;
    self.textColor.a = self.style.color.a;

	if self.lines == nil then
		return;
	end
	if self.clip then self:setStencilRect(0, 0, self.width, self.height) end
--	print "render";
	if self.textDirty then
		self:paginate();
	end
    local y = 0;
	--ISPanel.render(self);
    local c = 1;
    for i,v in ipairs(self.images) do
        if v == nil then

            --print("Tried to draw non-existant texture");
        end

        local h = self.imageY[c] + self.style.margin.top + self.imageH[c];
        if(h > y) then
            y = h;
        end
        self:drawTextureScaled(v, self.imageX[c] + self.style.margin.left, self.imageY[c] + self.style.margin.top, self.imageW[c], self.imageH[c], self.contentTransparency, 1, 1, 1);
        c = c + 1;
    end
	c = 1;
    local orient = "left";
	y = 0;
	--self.font = UIFont.NewSmall
	for i,v in ipairs(self.lines) do

		if self.lineY[c] + self.style.margin.top + self:getYScroll() >= self:getHeight() then
			break
		end

		if self.rgb[c] then

			self.textColor.r = self.rgb[c].r;
			self.textColor.g = self.rgb[c].g;
			self.textColor.b = self.rgb[c].b;
			self.textColor.a = self.rgb[c].a;

		end

		if self.orient[c] then
			orient = self.orient[c];
		end

		if self.fonts[c] then
			self.font = self.fonts[c];
		end

		if i == #self.lines or (self.lineY[c+1] + self.style.margin.top + self:getYScroll() > 0) then

			local r = self.textColor.r;
			local b = self.textColor.b;
			local g = self.textColor.g;
			local a = self.textColor.a;

			if v:contains("&lt;") then
				v = v:gsub("&lt;", "<")
			end
			if v:contains("&gt;") then
				v = v:gsub("&gt;", ">")
			end

			if string.trim(v) ~= "" then
				if orient == "centre" then
					self:drawTextCentre(
						string.trim(v), self.width / 2 , self.lineY[c] + self.style.margin.top,
						r, g, b, a, self.font
					);
				elseif orient == "right" then
					self:drawTextLeft(
						string.trim(v), self.lineX[c] + self.style.margin.left, self.lineY[c] + self.style.margin.top,
						r, g, b, a, self.font
					);
				else
					self:drawText(
						string.trim(v), self.lineX[c] + self.style.margin.left, self.lineY[c] + self.style.margin.top,
						r, g, b, a, self.font
					);
				end
			end

		end

		local h = self.lineY[c] + self.style.margin.top + 32;
		if(h > y) then
			y = h;
		end
		c = c + 1;
	end

	if UIRichTextPanel.drawMargins then
		self:drawRectBorder(0, 0, self.width, self:getScrollHeight(), 0.5,1,1,1)
		self:drawRect(self.style.margin.left, 0, 1, self:getScrollHeight(), 1,1,1,1)
		local maxLineWidth = self.maxLineWidth or (self.width - self.style.margin.right - self.style.margin.left)
		self:drawRect(self.style.margin.left + maxLineWidth, 0, 1, self:getScrollHeight(), 1,1,1,1)
		self:drawRect(0, self.style.margin.top, self.width, 1, 1,1,1,1)
		self:drawRect(0, self:getScrollHeight() - self.style.margin.bottom, self.width, 1, 1,1,1,1)
	end

	if self.clip then self:clearStencilRect() end
	--self:setScrollHeight(y);
end

function UIRichTextPanel:onResize()
  --  ISUIElement.onResize(self);
	self.width = self:getWidth();
	self.height = self:getHeight();
    self.textDirty = true;
end

function UIRichTextPanel:setMargins(left, top, right, bottom)
	self.style.margin.left = left
	self.style.margin.top = top
	self.style.margin.right = right
	self.style.margin.bottom = bottom
end
