require "MeowCore";

MeowCore:namespace("Shared/Types");

local Color = {}

local properties = {
	r = 0,
	g = 0,
	b = 0,
	a = 0
}

function Color:new(o, g, b, a)
	local r = nil;
	if(type(o) == "number") then
		r = o;
		o = {r=r,g=g,b=b,a=a or 1};
	end
	o = MeowCore.extend({}, DeepCopyRecursive(properties), o);
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

Color.paleturquoise = function() return Color:new({r=0.68627450980392,g=0.93333333333333,b=0.93333333333333,a=1 });end
Color.skyblue = function() return Color:new({r=0.52941176470588,g=0.8078431372549,b=0.92156862745098,a=1 });end
Color.lime = function() return Color:new({r=0,g=1,b=0,a=1 });end
Color.lightslategray = function() return Color:new({r=0.46666666666667,g=0.53333333333333,b=0.6,a=1 });end
Color.greenyellow = function() return Color:new({r=0.67843137254902,g=1,b=0.1843137254902,a=1 });end
Color.darkgreen = function() return Color:new({r=0,g=0.3921568627451,b=0,a=1 });end
Color.lightslategrey = function() return Color:new({r=0.46666666666667,g=0.53333333333333,b=0.6,a=1 });end
Color.peru = function() return Color:new({r=0.80392156862745,g=0.52156862745098,b=0.24705882352941,a=1 });end
Color.blue = function() return Color:new({r=0,g=0,b=1,a=1 });end
Color.navajowhite = function() return Color:new({r=1,g=0.87058823529412,b=0.67843137254902,a=1 });end
Color.dimgrey = function() return Color:new({r=0.41176470588235,g=0.41176470588235,b=0.41176470588235,a=1 });end
Color.papayawhip = function() return Color:new({r=1,g=0.93725490196078,b=0.83529411764706,a=1 });end
Color.darkgrey = function() return Color:new({r=0.66274509803922,g=0.66274509803922,b=0.66274509803922,a=1 });end
Color.lightgray = function() return Color:new({r=0.82745098039216,g=0.82745098039216,b=0.82745098039216,a=1 });end
Color.tomato = function() return Color:new({r=1,g=0.38823529411765,b=0.27843137254902,a=1 });end
Color.slateblue = function() return Color:new({r=0.4156862745098,g=0.35294117647059,b=0.80392156862745,a=1 });end
Color.fuchsia = function() return Color:new({r=1,g=0,b=1,a=1 });end
Color.mediumvioletred = function() return Color:new({r=0.78039215686275,g=0.082352941176471,b=0.52156862745098,a=1 });end
Color.blueviolet = function() return Color:new({r=0.54117647058824,g=0.16862745098039,b=0.88627450980392,a=1 });end
Color.darkorchid = function() return Color:new({r=0.6,g=0.19607843137255,b=0.8,a=1 });end
Color.red = function() return Color:new({r=1,g=0,b=0,a=1 });end
Color.mediumspringgreen = function() return Color:new({r=0,g=0.98039215686275,b=0.60392156862745,a=1 });end
Color.lightsteelblue = function() return Color:new({r=0.69019607843137,g=0.76862745098039,b=0.87058823529412,a=1 });end
Color.darkred = function() return Color:new({r=0.54509803921569,g=0,b=0,a=1 });end
Color.tan = function() return Color:new({r=0.82352941176471,g=0.70588235294118,b=0.54901960784314,a=1 });end
Color.rosybrown = function() return Color:new({r=0.73725490196078,g=0.56078431372549,b=0.56078431372549,a=1 });end
Color.springgreen = function() return Color:new({r=0,g=1,b=0.49803921568627,a=1 });end
Color.dimgray = function() return Color:new({r=0.41176470588235,g=0.41176470588235,b=0.41176470588235,a=1 });end
Color.green = function() return Color:new({r=0,g=0.50196078431373,b=0,a=1 });end
Color.navy = function() return Color:new({r=0,g=0,b=0.50196078431373,a=1 });end
Color.darkslateblue = function() return Color:new({r=0.28235294117647,g=0.23921568627451,b=0.54509803921569,a=1 });end
Color.seashell = function() return Color:new({r=1,g=0.96078431372549,b=0.93333333333333,a=1 });end
Color.darkslategrey = function() return Color:new({r=0.1843137254902,g=0.30980392156863,b=0.30980392156863,a=1 });end
Color.lawngreen = function() return Color:new({r=0.48627450980392,g=0.98823529411765,b=0,a=1 });end
Color.moccasin = function() return Color:new({r=1,g=0.89411764705882,b=0.70980392156863,a=1 });end
Color.gray = function() return Color:new({r=0.50196078431373,g=0.50196078431373,b=0.50196078431373,a=1 });end
Color.darkgoldenrod = function() return Color:new({r=0.72156862745098,g=0.52549019607843,b=0.043137254901961,a=1 });end
Color.darkturquoise = function() return Color:new({r=0,g=0.8078431372549,b=0.81960784313725,a=1 });end
Color.azure = function() return Color:new({r=0.94117647058824,g=1,b=1,a=1 });end
Color.mediumorchid = function() return Color:new({r=0.72941176470588,g=0.33333333333333,b=0.82745098039216,a=1 });end
Color.grey = function() return Color:new({r=0.50196078431373,g=0.50196078431373,b=0.50196078431373,a=1 });end
Color.linen = function() return Color:new({r=0.98039215686275,g=0.94117647058824,b=0.90196078431373,a=1 });end
Color.bisque = function() return Color:new({r=1,g=0.89411764705882,b=0.76862745098039,a=1 });end
Color.khaki = function() return Color:new({r=0.94117647058824,g=0.90196078431373,b=0.54901960784314,a=1 });end
Color.brown = function() return Color:new({r=0.64705882352941,g=0.16470588235294,b=0.16470588235294,a=1 });end
Color.chartreuse = function() return Color:new({r=0.49803921568627,g=1,b=0,a=1 });end
Color.mediumseagreen = function() return Color:new({r=0.23529411764706,g=0.70196078431373,b=0.44313725490196,a=1 });end
Color.darksalmon = function() return Color:new({r=0.91372549019608,g=0.58823529411765,b=0.47843137254902,a=1 });end
Color.powderblue = function() return Color:new({r=0.69019607843137,g=0.87843137254902,b=0.90196078431373,a=1 });end
Color.steelblue = function() return Color:new({r=0.27450980392157,g=0.50980392156863,b=0.70588235294118,a=1 });end
Color.lavenderblush = function() return Color:new({r=1,g=0.94117647058824,b=0.96078431372549,a=1 });end
Color.whitesmoke = function() return Color:new({r=0.96078431372549,g=0.96078431372549,b=0.96078431372549,a=1 });end
Color.blanchedalmond = function() return Color:new({r=1,g=0.92156862745098,b=0.80392156862745,a=1 });end
Color.lightyellow = function() return Color:new({r=1,g=1,b=0.87843137254902,a=1 });end
Color.darkolivegreen = function() return Color:new({r=0.33333333333333,g=0.41960784313725,b=0.1843137254902,a=1 });end
Color.gainsboro = function() return Color:new({r=0.86274509803922,g=0.86274509803922,b=0.86274509803922,a=1 });end
Color.lightgrey = function() return Color:new({r=0.82745098039216,g=0.82745098039216,b=0.82745098039216,a=1 });end
Color.lightcyan = function() return Color:new({r=0.87843137254902,g=1,b=1,a=1 });end
Color.burlywood = function() return Color:new({r=0.87058823529412,g=0.72156862745098,b=0.52941176470588,a=1 });end
Color.palevioletred = function() return Color:new({r=0.85882352941176,g=0.43921568627451,b=0.57647058823529,a=1 });end
Color.aqua = function() return Color:new({r=0,g=1,b=1,a=1 });end
Color.lightgoldenrodyellow = function() return Color:new({r=0.98039215686275,g=0.98039215686275,b=0.82352941176471,a=1 });end
Color.antiquewhite = function() return Color:new({r=0.98039215686275,g=0.92156862745098,b=0.84313725490196,a=1 });end
Color.honeydew = function() return Color:new({r=0.94117647058824,g=1,b=0.94117647058824,a=1 });end
Color.lightseagreen = function() return Color:new({r=0.12549019607843,g=0.69803921568627,b=0.66666666666667,a=1 });end
Color.lavender = function() return Color:new({r=0.90196078431373,g=0.90196078431373,b=0.98039215686275,a=1 });end
Color.aquamarine = function() return Color:new({r=0.49803921568627,g=1,b=0.83137254901961,a=1 });end
Color.orangered = function() return Color:new({r=1,g=0.27058823529412,b=0,a=1 });end
Color.coral = function() return Color:new({r=1,g=0.49803921568627,b=0.31372549019608,a=1 });end
Color.salmon = function() return Color:new({r=0.98039215686275,g=0.50196078431373,b=0.44705882352941,a=1 });end
Color.floralwhite = function() return Color:new({r=1,g=0.98039215686275,b=0.94117647058824,a=1 });end
Color.goldenrod = function() return Color:new({r=0.85490196078431,g=0.64705882352941,b=0.12549019607843,a=1 });end
Color.mediumblue = function() return Color:new({r=0,g=0,b=0.80392156862745,a=1 });end
Color.mediumslateblue = function() return Color:new({r=0.48235294117647,g=0.4078431372549,b=0.93333333333333,a=1 });end
Color.aliceblue = function() return Color:new({r=0.94117647058824,g=0.97254901960784,b=1,a=1 });end
Color.darkorange = function() return Color:new({r=1,g=0.54901960784314,b=0,a=1 });end
Color.cadetblue = function() return Color:new({r=0.37254901960784,g=0.61960784313725,b=0.62745098039216,a=1 });end
Color.teal = function() return Color:new({r=0,g=0.50196078431373,b=0.50196078431373,a=1 });end
Color.forestgreen = function() return Color:new({r=0.13333333333333,g=0.54509803921569,b=0.13333333333333,a=1 });end
Color.yellowgreen = function() return Color:new({r=0.60392156862745,g=0.80392156862745,b=0.19607843137255,a=1 });end
Color.gold = function() return Color:new({r=1,g=0.84313725490196,b=0,a=1 });end
Color.violet = function() return Color:new({r=0.93333333333333,g=0.50980392156863,b=0.93333333333333,a=1 });end
Color.lightskyblue = function() return Color:new({r=0.52941176470588,g=0.8078431372549,b=0.98039215686275,a=1 });end
Color.turquoise = function() return Color:new({r=0.25098039215686,g=0.87843137254902,b=0.8156862745098,a=1 });end
Color.white = function() return Color:new({r=1,g=1,b=1,a=1 });end
Color.ghostwhite = function() return Color:new({r=0.97254901960784,g=0.97254901960784,b=1,a=1 });end
Color.darkgray = function() return Color:new({r=0.66274509803922,g=0.66274509803922,b=0.66274509803922,a=1 });end
Color.wheat = function() return Color:new({r=0.96078431372549,g=0.87058823529412,b=0.70196078431373,a=1 });end
Color.palegoldenrod = function() return Color:new({r=0.93333333333333,g=0.90980392156863,b=0.66666666666667,a=1 });end
Color.yellow = function() return Color:new({r=1,g=1,b=0,a=1 });end
Color.thistle = function() return Color:new({r=0.84705882352941,g=0.74901960784314,b=0.84705882352941,a=1 });end
Color.oldlace = function() return Color:new({r=0.9921568627451,g=0.96078431372549,b=0.90196078431373,a=1 });end
Color.darkseagreen = function() return Color:new({r=0.56078431372549,g=0.73725490196078,b=0.56078431372549,a=1 });end
Color.sandybrown = function() return Color:new({r=0.95686274509804,g=0.64313725490196,b=0.37647058823529,a=1 });end
Color.darkblue = function() return Color:new({r=0,g=0,b=0.54509803921569,a=1 });end
Color.silver = function() return Color:new({r=0.75294117647059,g=0.75294117647059,b=0.75294117647059,a=1 });end
Color.deepskyblue = function() return Color:new({r=0,g=0.74901960784314,b=1,a=1 });end
Color.seagreen = function() return Color:new({r=0.18039215686275,g=0.54509803921569,b=0.34117647058824,a=1 });end
Color.slategrey = function() return Color:new({r=0.43921568627451,g=0.50196078431373,b=0.56470588235294,a=1 });end
Color.cyan = function() return Color:new({r=0,g=1,b=1,a=1 });end
Color.mintcream = function() return Color:new({r=0.96078431372549,g=1,b=0.98039215686275,a=1 });end
Color.maroon = function() return Color:new({r=0.50196078431373,g=0,b=0,a=1 });end
Color.saddlebrown = function() return Color:new({r=0.54509803921569,g=0.27058823529412,b=0.074509803921569,a=1 });end
Color.lightgreen = function() return Color:new({r=0.56470588235294,g=0.93333333333333,b=0.56470588235294,a=1 });end
Color.purple = function() return Color:new({r=0.50196078431373,g=0,b=0.50196078431373,a=1 });end
Color.darkslategray = function() return Color:new({r=0.1843137254902,g=0.30980392156863,b=0.30980392156863,a=1 });end
Color.pink = function() return Color:new({r=1,g=0.75294117647059,b=0.79607843137255,a=1 });end
Color.peachpuff = function() return Color:new({r=1,g=0.85490196078431,b=0.72549019607843,a=1 });end
Color.deeppink = function() return Color:new({r=1,g=0.07843137254902,b=0.57647058823529,a=1 });end
Color.palegreen = function() return Color:new({r=0.59607843137255,g=0.9843137254902,b=0.59607843137255,a=1 });end
Color.orchid = function() return Color:new({r=0.85490196078431,g=0.43921568627451,b=0.83921568627451,a=1 });end
Color.lightblue = function() return Color:new({r=0.67843137254902,g=0.84705882352941,b=0.90196078431373,a=1 });end
Color.chocolate = function() return Color:new({r=0.82352941176471,g=0.41176470588235,b=0.11764705882353,a=1 });end
Color.magenta = function() return Color:new({r=1,g=0,b=1,a=1 });end
Color.olive = function() return Color:new({r=0.50196078431373,g=0.50196078431373,b=0,a=1 });end
Color.mistyrose = function() return Color:new({r=1,g=0.89411764705882,b=0.88235294117647,a=1 });end
Color.midnightblue = function() return Color:new({r=0.098039215686275,g=0.098039215686275,b=0.43921568627451,a=1 });end
Color.dodgerblue = function() return Color:new({r=0.11764705882353,g=0.56470588235294,b=1,a=1 });end
Color.lemonchiffon = function() return Color:new({r=1,g=0.98039215686275,b=0.80392156862745,a=1 });end
Color.royalblue = function() return Color:new({r=0.25490196078431,g=0.41176470588235,b=0.88235294117647,a=1 });end
Color.mediumpurple = function() return Color:new({r=0.57647058823529,g=0.43921568627451,b=0.85882352941176,a=1 });end
Color.lightsalmon = function() return Color:new({r=1,g=0.62745098039216,b=0.47843137254902,a=1 });end
Color.olivedrab = function() return Color:new({r=0.41960784313725,g=0.55686274509804,b=0.13725490196078,a=1 });end
Color.limegreen = function() return Color:new({r=0.19607843137255,g=0.80392156862745,b=0.19607843137255,a=1 });end
Color.mediumaquamarine = function() return Color:new({r=0.4,g=0.80392156862745,b=0.66666666666667,a=1 });end
Color.darkviolet = function() return Color:new({r=0.58039215686275,g=0,b=0.82745098039216,a=1 });end
Color.indigo = function() return Color:new({r=0.29411764705882,g=0,b=0.50980392156863,a=1 });end
Color.lightcoral = function() return Color:new({r=0.94117647058824,g=0.50196078431373,b=0.50196078431373,a=1 });end
Color.lightpink = function() return Color:new({r=1,g=0.71372549019608,b=0.75686274509804,a=1 });end
Color.firebrick = function() return Color:new({r=0.69803921568627,g=0.13333333333333,b=0.13333333333333,a=1 });end
Color.mediumturquoise = function() return Color:new({r=0.28235294117647,g=0.81960784313725,b=0.8,a=1 });end
Color.orange = function() return Color:new({r=1,g=0.64705882352941,b=0,a=1 });end
Color.ivory = function() return Color:new({r=1,g=1,b=0.94117647058824,a=1 });end
Color.indianred = function() return Color:new({r=0.80392156862745,g=0.36078431372549,b=0.36078431372549,a=1 });end
Color.cornflowerblue = function() return Color:new({r=0.3921568627451,g=0.5843137254902,b=0.92941176470588,a=1 });end
Color.hotpink = function() return Color:new({r=1,g=0.41176470588235,b=0.70588235294118,a=1 });end
Color.sienna = function() return Color:new({r=0.62745098039216,g=0.32156862745098,b=0.17647058823529,a=1 });end
Color.plum = function() return Color:new({r=0.86666666666667,g=0.62745098039216,b=0.86666666666667,a=1 });end
Color.snow = function() return Color:new({r=1,g=0.98039215686275,b=0.98039215686275,a=1 });end
Color.darkcyan = function() return Color:new({r=0,g=0.54509803921569,b=0.54509803921569,a=1 });end
Color.darkmagenta = function() return Color:new({r=0.54509803921569,g=0,b=0.54509803921569,a=1 });end
Color.darkkhaki = function() return Color:new({r=0.74117647058824,g=0.71764705882353,b=0.41960784313725,a=1 });end
Color.crimson = function() return Color:new({r=0.86274509803922,g=0.07843137254902,b=0.23529411764706,a=1 });end
Color.slategray = function() return Color:new({r=0.43921568627451,g=0.50196078431373,b=0.56470588235294,a=1 });end
Color.cornsilk = function() return Color:new({r=1,g=0.97254901960784,b=0.86274509803922,a=1 });end
Color.beige = function() return Color:new({r=0.96078431372549,g=0.96078431372549,b=0.86274509803922,a=1 });end
Color.black = function() return Color:new({r=0,g=0,b=0,a=1 });end
Color.transparent = function() return Color:new({r=0,g=0,b=0,a=0 }); end

MeowCore.Shared.Types.Color = Color;
