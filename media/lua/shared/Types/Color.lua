require "MeowCore";

MeowCore:namespace("Shared/Types");

local Color = {}

local properties = {
	r = 0,
	g = 0,
	b = 0,
	a = 0
}

function Color:new(o)
	o = o or DeepCopy(properties);
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function Color:toColorInfo()
	return ColorInfo:new(self.r, self.g, self.b, self.a);
end

function Color:parse(c)

	if(type(c) == "string") then
		if(c == "transparent") then
			self.r = 0;
			self.g = 0;
			self.b = 0;
			self.a = 0;
		elseif(c:sub(1, 1) == "#") then
			local hex = c:sub(2);
			local l = hex:len();
			if(l == 3) then
				local hexR = hex:sub(1,1)
				local hexG = hex:sub(2,2)
				local hexB = hex:sub(3,3)
				self.r = tonumber(hexR..hexR)/255;
				self.b = tonumber(hexB..hexB)/255;
				self.g = tonumber(hexG..hexG)/255;
				self.a = 1;
			elseif(l == 6) then
				local hexR = hex:sub(1,2)
				local hexG = hex:sub(3,4)
				local hexB = hex:sub(5,6)
				self.r = tonumber(hexR, 16)/255;
				self.b = tonumber(hexB, 16)/255;
				self.g = tonumber(hexG, 16)/255;
				self.a = 1;
			elseif(l == 8) then
				local hexR = hex:sub(1,2)
				local hexG = hex:sub(3,4)
				local hexB = hex:sub(5,6)
				local hexA = hex:sub(7,8)
				self.r = tonumber(hexR, 16)/255;
				self.b = tonumber(hexB, 16)/255;
				self.g = tonumber(hexG, 16)/255;
				self.a = tonumber(hexA, 16)/255;
			end
		end
	elseif(type(c) == "userdata" and c:getClass():getName() == "zombie.core.textures.ColorInfo") then
		self.r = c:getR();
		self.g = c:getG();
		self.b = c:getB();
		self.a = c:getA();
	else
		Dump(c);
	end

end


MeowCore.Shared.Types.Color = Color;
