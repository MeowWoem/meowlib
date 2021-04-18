MeowCore = {};

local _required = {};

function MeowCore:namespace(str, root)
	root = root or MeowCore;
	local obj = root;
	local lastObj = root;
	for _, v in ipairs(luautils.split(str, "/")) do
		obj = obj[v];
		if(obj == nil) then
			obj = {};
		end
		lastObj[v] = obj;
		lastObj = obj;
	end

	return obj;
end

function MeowCore:derive(str)
	local obj = MeowCore:require(str);
	if(obj ~= nil) then
		return obj:new();
	end
end

function MeowCore:require(str)
	local path = str;
	local i, l = path:find("Client/");
	if(i == 1) then
		path = path:sub(i + l);
	else
		i, l = path:find("Shared/");
		if(i == 1) then
			path = path:sub(i + l);
		else
			i, l = path:find("Server/");
			if(i == 1) then
				path = path:sub(i + l);
			end
		end
	end



	if(_required[str] ~= true) then

		print("Require : " .. str);

		_required[str] = true;
		require (path);
	end
	local obj = MeowCore;

	for _, v in ipairs(luautils.split(str, "/")) do
		if(obj == nil) then
			return nil;
		end
		obj = obj[v];
	end

	if(obj == nil) then
		print("Module : " .. str .. " not found in shared!");
		--obj = MeowServer:require(str);
	end

	if(obj == nil) then
		--print("Module : " .. str .. " Not exists in server!");
		--obj = LifeClient:require(str);
	end

	if(obj == nil or obj == MeowCore) then
		print("Module : " .. str .. " Not exists in client!");
		return nil;
	end
	return obj;
end


local function _dump(o)
	if type(o) == 'table' then
		local s = '{ \n';
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. _dump(v) .. ',';
		end
		return (s .. '\n} ');
	else
		return (tostring(o));
	end
end

function Dump(o)
	print(_dump(o));
end
