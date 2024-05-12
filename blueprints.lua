local function run_jest()
	local file = vim.fn.expand("%:p")
	print("My file is " .. file)
	vim.cmd("vsplit | terminal")
	local command = ':call jobsend(b:terminal_job_id, "echo hello world\\n")'
	vim.cmd(command)
end

return {
	run_jest = run_jest,
}
