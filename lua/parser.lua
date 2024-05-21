local files = require("./file-manager")

-- TODO: accept multiple expressions on a table and loop through them
local camel_expression = "{{__camel__}}"
local pascal_expression = "{{__pascal__}}"

-- FIXME: this return nil or name sometimes
local function parseName(name, expression)
	if expression == pascal_expression then
		local firstChar = name:sub(1, 1)
		local rest = name:sub(2)
		rest = rest:gsub("%u", function(c)
			return "-" .. string.lower(c)
		end)
		name = firstChar .. rest
		return name:lower():gsub(" ", "-"):gsub("%-%-", "-"):gsub("%-%-%-", "-")
	elseif expression == camel_expression then
		return name:gsub("-", " ")
			:gsub("_", " ")
			:gsub(" (%l)", function(c)
				return " " .. c:upper()
			end)
			:gsub(" ", "")
			:gsub("^%l", string.upper)
	else
		return name
	end
end

local function parseBlueprint(origin, destiny, name)
	local camel_name = parseName(name, camel_expression)
	local pascal_name = parseName(name, pascal_expression)
	for filename, attr in files.dirtree(origin) do
		local parsed_filename = filename
			:gsub(origin:gsub("%p", "%%%1"), "")
			:gsub(camel_expression, camel_name)
			:gsub(pascal_expression, pascal_name)
		if attr.mode == "directory" then
			os.execute("mkdir " .. destiny .. parsed_filename)
		else
			local sed_command = "sed -e 's/"
				.. camel_expression
				.. "/"
				.. parseName(name, camel_expression)
				.. "/g' "
				.. "-e 's/"
				.. pascal_expression
				.. "/"
				.. parseName(name, pascal_expression)
				.. "/g' "
				.. filename
				.. " > "
				.. destiny
				.. parsed_filename
			os.execute(sed_command)
		end
	end
end

return {
	parseBlueprint = parseBlueprint,
}

-- local lfs = require("lfs")
--
-- local function dirtree(dir)
-- 	assert(dir and dir ~= "", "Please pass directory parameter")
-- 	if string.sub(dir, -1) == "/" then
-- 		dir = string.sub(dir, 1, -2)
-- 	end
--
-- 	local function yieldtree(dir)
-- 		for entry in lfs.dir(dir) do
-- 			if entry ~= "." and entry ~= ".." then
-- 				entry = dir .. "/" .. entry
-- 				local attr = lfs.attributes(entry)
-- 				coroutine.yield(entry, attr)
-- 				if attr.mode == "directory" then
-- 					yieldtree(entry)
-- 				end
-- 			end
-- 		end
-- 	end
--
-- 	return coroutine.wrap(function()
-- 		yieldtree(dir)
-- 	end)
-- end
