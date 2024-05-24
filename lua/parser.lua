local files = require("./file-manager")

-- MUST REMAIN IN THIS ORDER
--  every index matches the parseName expression switch
local filename_expressions = {
	"__name__",
	"__upperCase_name__",
	"__lowerCase_name__",
	"__camelCase_name__",
	"__pascalCase_name__",
	"__snakeCase_name__",
	"__upperSnakeCase_name__",
	"__kebabCase_name__",
	"__lowerDotCase_name__",
}

local template_expressions = {
	"{{name}}",
	"{{upperCase name}}",
	"{{lowerCase name}}",
	"{{camelCase name}}",
	"{{pascalCase name}}",
	"{{snakeCase name}}",
	"{{upperSnakeCase name}}",
	"{{kebabCase name}}",
	"{{lowerDotCase name}}",
}

local function parseName(name, expression_index)
	local expressions_cases = {
		[1] = function()
			return name
		end,
		[2] = function()
			return name:upper()
		end,
		[3] = function()
			return name:lower()
		end,
		[4] = function()
			return name:gsub("-", " ")
				:gsub("_", " ")
				:gsub(" (%l)", function(c)
					return " " .. c:upper()
				end)
				:gsub(" ", "")
				:gsub("^%l", string.lower)
		end,
		[5] = function()
			return name:gsub("-", " ")
				:gsub("_", " ")
				:gsub(" (%l)", function(c)
					return " " .. c:upper()
				end)
				:gsub(" ", "")
				:gsub("^%l", string.upper)
		end,
		[6] = function()
			local firstChar = name:sub(1, 1)
			local rest = name:sub(2)
			rest = rest:gsub("%u", function(c)
				return "_" .. string.lower(c)
			end)
			name = firstChar .. rest
			return name:lower():gsub(" ", "_"):gsub("%_%_%_", "_"):gsub("%_%_", "_")
		end,
		[7] = function()
			local firstChar = name:sub(1, 1)
			local rest = name:sub(2)
			rest = rest:gsub("%u", function(c)
				return "_" .. string.upper(c)
			end)
			name = firstChar .. rest
			return name:upper():gsub(" ", "_"):gsub("%_%_%_", "_"):gsub("%_%_", "_")
		end,
		[8] = function()
			local firstChar = name:sub(1, 1)
			local rest = name:sub(2)
			rest = rest:gsub("%u", function(c)
				return "-" .. string.lower(c)
			end)
			name = firstChar .. rest
			return name:lower():gsub(" ", "-"):gsub("%-%-%-", "-"):gsub("%-%-", "-")
		end,
		[9] = function()
			local firstChar = name:sub(1, 1)
			local rest = name:sub(2)
			rest = rest:gsub("%u", function(c)
				return "." .. string.lower(c)
			end)
			name = firstChar .. rest
			return name:lower():gsub(" ", "."):gsub("%.%.%.", "."):gsub("%.%.", ".")
		end,
	}
	local result = expressions_cases[expression_index]
	if result then
		return result()
	else
		return name
	end
end

local function parseBlueprint(origin, destiny, name)
	for filename, attr in files.dirtree(origin) do
		local parsed_filename = filename:gsub(origin:gsub("%p", "%%%1"), "")
		for index, expression in ipairs(filename_expressions) do
			local parsed_name = parseName(name, index)
			parsed_filename = parsed_filename:gsub(expression, parsed_name)
		end
		if attr.mode == "directory" then
			os.execute('mkdir "' .. destiny .. parsed_filename .. '"')
		else
			local sed_command = "sed "
			for index, expression in ipairs(template_expressions) do
				sed_command = sed_command .. "-e 's/" .. expression .. "/" .. parseName(name, index) .. "/g' "
			end
			sed_command = sed_command .. filename .. ' > "' .. destiny .. parsed_filename .. '"'
			os.execute(sed_command)
		end
	end
end

return {
	parseBlueprint = parseBlueprint,
}
