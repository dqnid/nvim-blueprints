require("lfs")

function dirtree(dir)
	assert(dir and dir ~= "", "Please pass directory parameter")
	if string.sub(dir, -1) == "/" then
		dir = string.sub(dir, 1, -2)
	end

	local function yieldtree(dir)
		for entry in lfs.dir(dir) do
			if entry ~= "." and entry ~= ".." then
				entry = dir .. "/" .. entry
				local attr = lfs.attributes(entry)
				coroutine.yield(entry, attr)
				if attr.mode == "directory" then
					yieldtree(entry)
				end
			end
		end
	end

	return coroutine.wrap(function()
		yieldtree(dir)
	end)
end

local standard_expression = "{{__camel__}}"

local function copyDirTree(origin, destiny, name)
	lfs.mkdir(destiny)
	for filename, attr in dirtree(origin) do
		print(attr.mode, filename)
		if attr.mode == "directory" then
			lfs.mkdir(destiny .. filename:sub(2):gsub(standard_expression, name))
		else
			os.execute(
				"sed 's/"
					.. standard_expression
					.. "/"
					.. name
					.. "/g' "
					.. filename
					.. " > "
					.. destiny
					.. filename:sub(2):gsub(standard_expression, name)
			)
		end
	end
end

copyDirTree(".", "../destiny", "prueba")
