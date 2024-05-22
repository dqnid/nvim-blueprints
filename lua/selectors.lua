local files = require("./file-manager")
local parser = require("./parser")

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local blueprints = function(blueprints_dir)
	local opts = {}

	local blueprint_list = {}
	for filename in files.listdirs(blueprints_dir) do
		table.insert(blueprint_list, filename)
	end
	pickers
		.new(opts, {
			prompt_title = "Blueprints",
			finder = finders.new_table({
				results = blueprint_list,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()

					local pwd = os.getenv("PWD") or io.popen("cd"):read()
					local dir = vim.fn.input("Target: " .. pwd .. "/")
					local name = vim.fn.input("Name: ")
					parser.parseBlueprint(selection[1], pwd .. "/" .. dir, name)
				end)
				return true
			end,
		})
		:find()
end

return {
	blueprints = blueprints,
}
