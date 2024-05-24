# Neovim blueprints

Simple plain text template manager for Neovim.

![small-blueprints](https://github.com/dqnid/nvim-blueprints/assets/85947178/7ab74345-fbe4-4e2a-9519-3a88b03f58af)

## Dependencies

This plugin requires basic Unix system commands, since most of the functionality supports itself on them. This way we can get rid of some `Lua` dependencies with the downside of not being Windows friendly.

#### Linux utilities that must be accessible

- `sed`
- `mkdir`
- `ls`

#### Neovim plugin dependencies

- `telescope` (optional): for template selection and ease of use

## Lazy-vim Installation

```lua
"dqnid/nvim-blueprints"
```

### Configuration

The user wide default `blueprints` directory is the only configuration parameter. It's done by setting up a global vim variable `vim.g.blueprintsDir`, the setup function of the plugin provides an easy way to get it done:

```lua
{
	"dqnid/nvim-blueprints",
	name = "blueprints",
	init = function()
		require("blueprints").setup({ blueprintsDir = "/home/danih/.config/nvim/blueprints" })
	end,
},
```

## Usage

Create project or system-wide file templates.

### Easy way (telescope dependant)

The plugin provides a function `createFromTemplateTelescope`, which reads the 2 possible template sources (`./.blueprints` and the configured directory) and asks for a destiny where to create the files and a name that will replace the _variables_ inserted inside the templates.
This can be called directly on the Neovim command:

- `lua require('blueprints').createFromTemplateTelescope()`

But it is easier to create a simple mapping, here's what I'm currently doing inside my NvChad installation:

```lua
M.blueprints = {
	plugin = false,

	n = {
		["<leader>ct"] = {
			function()
				vim.cmd("lua require('blueprints').createFromTemplateTelescope()")
			end,
			"Create from template",
		},
	},
}

return M
```
