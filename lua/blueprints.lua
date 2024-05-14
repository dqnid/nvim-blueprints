-- This code will only be executed when is required somewhere

local augroup = vim.api.nvim_create_augroup("Blueprints", { clear = true })

local srcDir = "~/Documents/Proyectos/Training/nvim-blueprints/blueprints"

local function openterm()
	local file = vim.fn.expand("%:p")
	print("My file is " .. file)
	vim.cmd("vsplit | terminal")
	local command = ':call jobsend(b:terminal_job_id, "echo hello world\\n")'
	vim.cmd(command)
end

local function executeSed()
	local sedCommand = "sed 's/information/stuff/g' " .. srcDir .. "/file.txt"
	local value = os.execute(sedCommand)
	os.execute("pwd")
	print(value / 256) -- Return values are 256 multiples
	vim.notify("value: " .. value, vim.log.levels.INFO)
end

local function setup()
	vim.api.nvim_create_autocmd(
		"VimEnter",
		{ group = augroup, desc = "Creates a file structure with base code", once = true, callback = openterm } -- FIXME: not working
	)
end

return {
	setup = setup,
	openterm = openterm,
	executeSed = executeSed,
}

-- NOTE:
-- vim.log.levels.DEBUG vim.log.levels.ERROR vim.log.levels.INFO vim.log.levels.TRACE vim.log.levels.WARN vim.log.levels.OFF
--
-- ls -LR
-- ls -L .
