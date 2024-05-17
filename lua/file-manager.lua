local function listdirs(dir)
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
				if mode == "directory" then
					coroutine.yield(entry)
				end
			end
		end
		popen:close()
	end

	return coroutine.wrap(function()
		yieldtree(dir)
	end)
end

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

return {
	dirtree = dirtree,
	listdirs = listdirs,
}
