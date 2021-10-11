require "MeowCore";

local Dimension2 = MeowCore.require("Shared/Math/Geometry/Dimension2");

local UILayoutGrid = MeowCore.derive(
	"Client/UserInterface/Layouts/UILayoutGrid",
	"Client/UserInterface/Layouts/UILayout", {
		fixedColumns = false,
		currentRowSize = Dimension2:new(0, 0)
	}
);


function UILayoutGrid:calcInitialPos()
	self.current.x = 0;
	self.current.y = 0;
	self.size.w = 0;
	self.size.h = 0;
	self.currentRowSize.w = 0;
	self.currentRowSize.h = 0;
end

function UILayoutGrid:recalcLayout()
	self:calcInitialPos();
	for _, child in ipairs(self.childrens) do
		self:calcPos(child);
	end
	self.root:setHeight(self.size.h);
	Dump(self.size);
	self.isDirty = false;
end

function UILayoutGrid:calcPos(child)

	if(self.fixedColumns ~= false) then
		local gap = (self.fixedColumns - 1) * self.gap.x;
		child:setWidth((self.root.width - gap) / self.fixedColumns);
	end

	child.minimumWidth = self.minimumChildWidth == 'auto' and child.width or self.minimumChildWidth;

	if(self.current.x + math.max(child.width, child.minimumWidth) > self.root.width) then
		self.current.x = 0;

		if(self.currentRowSize.w - self.gap.x > self.size.w) then
			self.size.w = self.currentRowSize.w - self.gap.x;
		end
		self.current.y = self.current.y + self.currentRowSize.h + self.gap.y;

		self.currentRowSize.w = 0;
		self.currentRowSize.h = 0;
	elseif(self.size.w < self.current.x + math.max(child.width, child.minimumWidth)) then
		if(self.current.x + math.max(child.width, child.minimumWidth) > self.size.w) then
			self.size.w = self.current.x + math.max(child.width, child.minimumWidth);
		end
	end

	child:setX(self.current.x);
	child:setY(self.current.y);



	self.current.x = child.x + math.max(child.width, child.minimumWidth) + self.gap.x;


	-- TODO : Calc sizing

	self.currentRowSize.w = self.currentRowSize.w + math.max(child.width, child.minimumWidth) + self.gap.x;

	if(self.currentRowSize.h < child.height) then
		self.currentRowSize.h = child.height;
	end

	if(self.size.h < self.current.y + child.height) then
		self.size.h = self.current.y + child.height;
	end


end
