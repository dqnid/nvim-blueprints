-- This code will only be executed when is required somewhere

local parser = require("./parser")
local selectors = require("./selectors")
local augroup = vim.api.nvim_create_augroup("Blueprints", { clear = true })

local srcDir = "~/Documents/Proyectos/Training/nvim-blueprints/blueprints"

local function setup()
	vim.api.nvim_create_autocmd(
		"VimEnter",
		{ group = augroup, desc = "Creates a file structure with base code", once = true } -- FIXME: not working
	)
end

-- parser.parseBlueprint("../blueprints/react", "..", "alba")

return {
	setup = setup,
	createFromTemplate = parser.parseBlueprint,
	selectTemplate = selectors.blueprints,
}

-- NOTE:
-- vim.log.levels.DEBUG vim.log.levels.ERROR vim.log.levels.INFO vim.log.levels.TRACE vim.log.levels.WARN vim.log.levels.OFF
--
