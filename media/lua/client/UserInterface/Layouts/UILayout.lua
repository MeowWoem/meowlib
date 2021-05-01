require "MeowCore";

local typed, ctype = MeowCore.Typed("typed, ctype");
local Vector2 = MeowCore.require("Shared/Math/Geometry/Vector2");

local UILayout = MeowCore.class(
	"Client/UserInterface/Layouts/UILayout", {
		root = nil,
		gap = Vector2:new(5, 5),
		axe = 0,
		expandChilds = false,
		fixedColumns = false,
		reverse = false,
		current = Vector2:new(0, 0),
		childrens = {}
	}
);

UILayout.AXE_X = 0;
UILayout.AXE_Y = 1;
UILayout.AXE_XY = 2;

function UILayout:constructor(root, axe)
	if(axe ~= nil) then
		axe = typed('string', axe);
	end
	self.root = root;
	self.axe = axe or self.axe;
	self:calcInitialPos();
end

function UILayout:calcInitialPos()
	if(self.reverse) then -- Reverse
		if(self.axe == UILayout.AXE_X) then
			self.current.x = self.root.width;
			self.current.y = 0;
		end
	else
		self.current.x = 0;
		self.current.y = 0;
	end
end

function UILayout:recalcLayout()
	self:calcInitialPos();
	for _, child in ipairs(self.childrens) do
		self:calcPos(child);
	end
end

function UILayout:calcPos(child)

	if(self.fixedColumns ~= false and self.axe == UILayout.AXE_XY) then
		child:setWidth((
			self.root.width / self.fixedColumns
		) - (
			((self.fixedColumns - 1) * self.gap.x) / self.fixedColumns
		));
	end

	if(self.expandChilds == true and self.axe == UILayout.AXE_X) then
		child.minimumWidth = 100;
		local childrenCount = #self.childrens;
		child:setWidth((
			self.root.width / childrenCount
		) - (
			((childrenCount - 1) * self.gap.x) / childrenCount
		));
	end

	if(self.reverse) then -- Reverse

		if(self.axe == UILayout.AXE_XY) then
			if(self.current.x - math.max(child.width, child.minimumWidth) < 0) then
				self.current.x = self.root.width;
				self.current.y = self.current.y + self.gap.y + child.height; -- TODO: replace by max last row height
				self.root:setHeight(self.current.y + child.height);
			end
		end

		if(self.axe == UILayout.AXE_X or self.axe == UILayout.AXE_XY) then
			child:setX(self.current.x - math.max(child.width, child.minimumWidth));
			child:setY(self.current.y);
		end

	else	-- Normal

		if(self.axe == UILayout.AXE_XY) then
			if(self.current.x + math.max(child.width, child.minimumWidth) > self.root.width) then
				self.current.x = 0;
				self.current.y = self.current.y + self.gap.y + child.height; -- TODO: replace by max last row height
				self.root:setHeight(self.current.y + child.height);
			end
		end

		child:setX(self.current.x);
		child:setY(self.current.y);
	end

	if(self.reverse) then -- Reverse
		if(self.axe == UILayout.AXE_X or self.axe == UILayout.AXE_XY) then
			self.current.x = child.x - self.gap.x;
		end
	else	-- Normal
		if(self.axe == UILayout.AXE_X or self.axe == UILayout.AXE_XY) then
			self.current.x = child.x + math.max(child.width, child.minimumWidth) + self.gap.x;
		end
	end

end

function UILayout:addChild(child)

	self:calcPos(child);
	self.root:addChild(child);
	table.insert(self.childrens, child);
end
