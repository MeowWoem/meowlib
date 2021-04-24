require "MeowCore";

local PrivatesManager = MeowCore.class(
	"Shared/Core/PrivatesManager", {
		defaults = {},
		privates = {}
	}
);

function PrivatesManager:constructor_table(tbl)
	self.defaults = tbl;
end

function PrivatesManager:getAll(object)
	return self.privates[object.__varAddress] or DeepCopyRecursive(self.defaults);
end

function PrivatesManager:initialise(object)
	return self:getAll(object);
end

function PrivatesManager:get(object, prop)
	self.privates[object.__varAddress] = self:getAll(object);
	return self.privates[object.__varAddress][prop];
end

function PrivatesManager:call(object, func, args)
	func = self:get(object, func);
	args = args or {};
	if(type(func) == 'function') then
		func(object, unpack(args));
	end
end

function PrivatesManager:set(object, prop, value)
	self.privates[object.__varAddress] = self:getAll(object);
	self.privates[object.__varAddress][prop] = value;
end
