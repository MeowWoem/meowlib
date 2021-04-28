require "MeowCore";
require "Theme";
require "ISUI/ISUIElement"

MeowCore.namespace("Client/UserInterface");


local isctype, typed = MeowCore.Typed("isctype, typed");

local ISUIBridge = ISUIElement:derive("ISUIBridge");
ISUIBridge.__type = "ISUIBridge";
ISUIBridge.__super = ISUIElement;

local properties = {
	theme = nil,
	x = 0,
	y = 0,
	width = 0,
	height = 0
}

local function getRectData(parX, parY, parW, parH, parA, parR, parG, parB)
	local x, y, w, h, a, r, g, b = 0;
	if(isctype("Rect2D", parX)) then
		x = parX.x; y = parX.y;
		w = parX.w; h = parX.h;
		if(isctype("Color", parY)) then
			a = parY.a; r = parY.r; g = parY.g; b = parY.b;
		elseif(isctype("float", parY)) then
			a = parY; r = typed('float', parW);
			b = typed('float', parH); g = typed('float', parA);
		end
	elseif(isctype("number", parX)) then
		x = parX; y = typed('number', parY);
		w = typed('number', parW); h = typed('number', parH);
		if(isctype("Color", parA)) then
			a = parA.a; r = parA.r; g = parA.g; b = parA.b;
		elseif(isctype("float", parA)) then
			a = parA; r = typed('float', parR);
			b = typed('float', parB); g = typed('float', parG);
		end
	end
	return x, y, w, h, a, r, g, b;
end

function ISUIBridge:new(props)
	props = props or {};
	props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
	local o = ISUIBridge.__super:new(0, 0, 0, 0);
	o = MeowCore.extend({}, o, props);
	setmetatable(o, self);
	self.__index = self;
	return o;
end



function ISUIBridge:drawRectStatic(parX, parY, parW, parH, parA, parR, parG, parB)
	local x, y, w, h, a, r, g, b = getRectData(parX, parY, parW, parH, parA, parR, parG, parB);
	ISUIBridge.__super.drawRectStatic(self, x, y, w, h, a, r, g, b);
end

function ISUIBridge:drawRect(parX, parY, parW, parH, parA, parR, parG, parB)
	local x, y, w, h, a, r, g, b = getRectData(parX, parY, parW, parH, parA, parR, parG, parB);
	ISUIBridge.__super.drawRect(self, x, y, w, h, a, r, g, b);
end

function ISUIBridge:drawUIRectStructStatic(uirect)

	local backgroundWithOffset = uirect:getRectWithOffset();

	-- # 	DRAWING
	-- #	Background
	self:drawRectStatic(
		backgroundWithOffset,
		uirect.color
	);

	if(uirect.borders.t.thickness > 0) then
		self:drawRectStatic(
			uirect:getBorderTopRect(),
			uirect.borders.t.color
		);
	end
	if(uirect.borders.l.thickness > 0) then
		self:drawRectStatic(
			uirect:getBorderLeftRect(),
			uirect.borders.l.color
		);
	end
	if(uirect.borders.b.thickness > 0) then
		self:drawRectStatic(
			uirect:getBorderBottomRect(),
			uirect.borders.b.color
		);
	end
	if(uirect.borders.r.thickness > 0) then
		self:drawRectStatic(
			uirect:getBorderRightRect(),
			uirect.borders.r.color
		);
	end

end

function ISUIBridge:drawUIRectStruct(uirect)

	local backgroundWithOffset = uirect:getRectWithOffset();

	-- # 	DRAWING
	-- #	Background
	self:drawRect(
		backgroundWithOffset,
		uirect.color
	);

	if(uirect.borders.t.thickness > 0) then
		self:drawRect(
			uirect:getBorderTopRect(),
			uirect.borders.t.color
		);
	end
	if(uirect.borders.l.thickness > 0) then
		self:drawRect(
			uirect:getBorderLeftRect(),
			uirect.borders.l.color
		);
	end
	if(uirect.borders.b.thickness > 0) then
		self:drawRect(
			uirect:getBorderBottomRect(),
			uirect.borders.b.color
		);
	end
	if(uirect.borders.r.thickness > 0) then
		self:drawRect(
			uirect:getBorderRightRect(),
			uirect.borders.r.color
		);
	end

end

function ISUIBridge:drawRectBorderStatic(
		parX, parY, parW, parH,
		parA, parR, parG, parB,
		parWT, parWR, parWB, parWL
	) ---------------------------------
	local x, y, w, h, a, r, g, b = getRectData(parX, parY, parW, parH, parA, parR, parG, parB);
	local wt = typed('integer', parWT or -1);
	local wr = typed('integer', parWR or -1);
	local wb = typed('integer', parWB or -1);
	local wl = typed('integer', parWL or -1);
	--------------
	wt = wt > -1 and wt or 1;
	wr = wr > -1 and wr or wt;
	wb = wb > -1 and wb or wt;
	wl = wl > -1 and wl or wl;

	local offsetY = 0;
	local offsetH = 0;

	if(wt > 0) then
		self:drawRect(x, y, w, wt, a, r, g, b);
		offsetY = offsetY + wt;
	end

	if(wb > 0) then
		self:drawRectStatic(x, h - wb, w, wb, a, r, g, b);
		offsetH = offsetH + wb;
	end

	if(wl > 0) then
		self:drawRectStatic(x, y + offsetY, wl, h - offsetH, a, r, g, b);
	end

	if(wr > 0) then
		self:drawRectStatic(w - wr, y + offsetY, wr, h - offsetH, a, r, g, b);
	end

end

function ISUIBridge:drawRectBorder(
		parX, parY, parW, parH,
		parA, parR, parG, parB,
		parWT, parWR, parWB, parWL
	) ---------------------------------
	local x, y, w, h, a, r, g, b = getRectData(parX, parY, parW, parH, parA, parR, parG, parB);
	local wt = typed('integer', parWT or -1);
	local wr = typed('integer', parWR or -1);
	local wb = typed('integer', parWB or -1);
	local wl = typed('integer', parWL or -1);
	--------------
	wt = wt > -1 and wt or 1;
	wr = wr > -1 and wr or wt;
	wb = wb > -1 and wb or wt;
	wl = wl > -1 and wl or wl;

	local offsetY = 0;
	local offsetH = 0;

	if(wt > 0) then
		self:drawRect(x, y, w, wt, a, r, g, b);
		offsetY = offsetY + wt;
	end

	if(wb > 0) then
		self:drawRect(x, y + h - wb, w, wb, a, r, g, b);
		offsetH = offsetH + wb;
	end

	if(wl > 0) then
		self:drawRect(x, y + offsetY, wl, h - offsetH, a, r, g, b);
	end

	if(wr > 0) then
		self:drawRect(x + w - wr, y + offsetY, wr, h - offsetH, a, r, g, b);
	end

end



MeowCore.Client.UserInterface.ISUIBridge = ISUIBridge;
