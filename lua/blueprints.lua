local selectors = require("./selectors")
local parser = require("./parser")

local srcDir = "/home/danih/Documents/Proyectos/nvim-blueprints/blueprints"
vim.g.blueprintsDir = srcDir

local function setup(opts)
	vim.g.blueprintsDir = opts.blueprintsDir
end

local function createFromTemplate(origin, destiny, name)
	parser.parseBlueprint(origin, destiny, name)
end

local function createFromTemplateTelescope()
	selectors.blueprints(vim.g.blueprintsDir)
end

return {
	setup = setup,
	createFromTemplate = createFromTemplate,
	createFromTemplateTelescope = createFromTemplateTelescope,
}

-- NOTE:
-- vim.log.levels.DEBUG vim.log.levels.ERROR vim.log.levels.INFO vim.log.levels.TRACE vim.log.levels.WARN vim.log.levels.OFF
--
