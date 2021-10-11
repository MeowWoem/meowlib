require "MeowCore";

local Vector2 = MeowCore.require("Shared/Math/Geometry/Vector2");
local Dimension2 = MeowCore.require("Shared/Math/Geometry/Dimension2");

local UILayout = MeowCore.class(
	"Client/UserInterface/Layouts/UILayout", {
		root = nil,
		gap = Vector2:new(5, 5),
		expandChilds = false,
		minimumChildWidth = 'auto',
		fixedColumns = false,
		reverse = false,
		current = Vector2:new(0, 0),
		size = Dimension2:new(0, 0),
		childrens = {},
		isDirty = false
	}
);

function UILayout:constructor(root)
	self.root = root;
	self:calcInitialPos();
end

function UILayout:calcInitialPos()
	if(self.reverse) then -- Reverse
		self.current.x = self.root.width;
		self.current.y = 0;
	else
		self.current.x = 0;
		self.current.y = 0;
	end
	self.size.w = 0;
	self.size.h = 0;
end

function UILayout:recalcLayout()
	self:calcInitialPos();
	for _, child in ipairs(self.childrens) do
		self:calcPos(child);
	end
	self.size.w = self.size.w - self.gap.x;
	self.isDirty = false;
end

function UILayout:calcPos(child)

	if(self.fixedColumns ~= false) then
		child:setWidth((
			self.root.width / self.fixedColumns
		) - (
			((self.fixedColumns - 1) * self.gap.x) / self.fixedColumns
		));
	end

	if(self.expandChilds == true) then
		child.minimumWidth = self.minimumChildWidth == 'auto' and child.width or self.minimumChildWidth;
		local childrenCount = #self.childrens;
		child:setWidth((
			self.root.width / childrenCount
		) - (
			((childrenCount - 1) * self.gap.x) / childrenCount
		));
	end

	if(self.reverse) then -- Reverse

		child:setX(self.current.x - math.max(child.width, child.minimumWidth));
		child:setY(self.current.y);

	else	-- Normal
		child:setX(self.current.x);
		child:setY(self.current.y);
	end

	if(self.reverse) then -- Reverse
		self.current.x = child.x - self.gap.x;
	else	-- Normal
		self.current.x = child.x + math.max(child.width, child.minimumWidth) + self.gap.x;
	end

	self.size.w = self.size.w + math.max(child.width, child.minimumWidth) + self.gap.x;

	if(self.size.h < child:getHeight()) then
		self.size.h = child:getHeight();
	end

end

function UILayout:addChild(child)
	self.isDirty = true;
	self:calcPos(child);
	self.root:addChild(child);
	table.insert(self.childrens, child);
end

function UILayout:removeChild(child)
	local test = table.removeByValue(self.childrens, child);
	Dump(test);
	if(test) then
		self.isDirty = true;
		self.root:removeChild(child);
	end
end
