require "MeowCore";

MeowCore:namespace("Shared/Utils");

local DS = getFileSeparator();
local INIUtils = {};

INIUtils.DS = DS;
INIUtils.DIR_SEP = DS;

function INIUtils.TableToINI(modid, filename, content, fd, parentCat, fdTypeMap)
	if(fd == nil) then
		fd = getFileWriter(modid .. DS .. filename, true, false);
	end
	if(fdTypeMap == nil) then
		fdTypeMap = getFileWriter(modid .. DS .. filename .. ".typemap", true, false);
	end

  if not fd then return false end;
  local category = "";
	for catK, catV in pairs(content) do
		if parentCat then
      category = parentCat.."/"..catK;
		else
			category = catK;
		end
		fd:write("["..category.."]\n");
		fdTypeMap:write("["..category.."]\n");

		for k,v in pairs(catV) do
			if type(v) == "table" then
				local categoryTable = {};
				categoryTable[k] = v;
				INIUtils.TableToINI(modid, filename, categoryTable, fd, category, fdTypeMap);
			else
				fd:write(tostring(k).."="..tostring(v).."\n");
				fdTypeMap:write(tostring(k).."="..type(v).."\n");
			end
		end
	end
  fd:close();
  fdTypeMap:close();
end

function INIUtils.INIToTable(modid, filename)
	local retVal = {};
	local retTypes = {};
	local rvptr = retVal;
	local f = getFileReader(modid .. DS .. filename, false);
	local f2 = getModFileReader(modid, "media".. DS ..".typemaps" .. DS .. filename .. ".typemap", false);
	if not f or not f2 then return retVal end;

	local line = "1";
	local line2 = "1";
	local currentCat = "unknown";

	while line2 do
		line2 = f2:readLine();
		if line2 then
			if luautils.stringStarts(line2, "[") then
				currentCat = string.match(line2, "[a-zA-Z0-9/]+");
			else
				local kv = string.split(line2, "=");
				retTypes[currentCat .. "/" .. kv[1]] = kv[2];
			end
		end
	end

	while line do
		line = f:readLine();
		if line then
			if luautils.stringStarts(line, "[") then
				currentCat = string.match(line, "[a-zA-Z0-9/]+");
				rvptr = retVal;
				for _, cat in ipairs(string.split(currentCat, "/")) do
					if not rvptr[cat] then rvptr[cat] = {} end
					rvptr = rvptr[cat];
				end
			else
				local kv = string.split(line, "=");
        local vtype = retTypes[currentCat .. "/" .. kv[1]];
        local v = kv[2];
        if(vtype == "number") then
          v = tonumber(v);
        elseif(vtype == "boolean") then
          v = v == "true";
        end

				rvptr[kv[1]] = v;
			end
		end
	end
	return retVal;
end

MeowCore.Shared.Utils.INIUtils = INIUtils;
