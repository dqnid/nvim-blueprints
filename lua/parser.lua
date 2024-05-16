local function dirtree(dir)
	assert(dir and dir ~= "", "Please pass directory parameter")
	if string.sub(dir, -1) == "/" then
		dir = string.sub(dir, 1, -2)
	end

	local function yieldtree(dir)
		local popen = io.popen('ls -1 "' .. dir .. '"')
		if not popen then
			return
		end
		for entry in popen:lines() do
			if entry ~= "." and entry ~= ".." then
				entry = dir .. "/" .. entry
				local mode = (io.open(entry, "a")) and "file" or "directory"
				local attr = { mode = mode }
				coroutine.yield(entry, attr)
				if mode == "directory" then
					yieldtree(entry)
				end
			end
		end
		popen:close()
	end

	return coroutine.wrap(function()
		yieldtree(dir)
	end)
end

-- TODO: accept multiple expressions and adapt the text to it
local standard_expression = "{{__camel__}}"

local function parseBlueprint(origin, destiny, name)
	for filename, attr in dirtree(origin) do
		if attr.mode == "directory" then
			local new_dir = destiny .. filename:gsub(origin, ""):gsub(standard_expression, name)
			os.execute("mkdir " .. new_dir)
		else
			local sed_command = "sed 's/"
				.. standard_expression
				.. "/"
				.. name
				.. "/g' "
				.. filename
				.. " > "
				.. destiny
				.. filename:gsub(origin, ""):gsub(standard_expression, name)
			os.execute(sed_command)
		end
	end
end

parseBlueprint("../blueprints/react", "..", "alba")

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
