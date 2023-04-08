local api = vim.api
local cmd = vim.cmd
local API = require("api")
local Utils = require("utils")

Buffer = {}

-- ### Entry Point ################################################################
Buffer.OpenWindow = function(deck, model)
	local buf = api.nvim_create_buf(false, true)

	local win = Buffer.ConfigWindow(buf)
	Buffer.SetDefaultsOptions(buf, win)

	local fields = API.GetModelFieldNames(model)
	Buffer.PopulateFields(buf, fields)

	Buffer.AddSaveKeymap(buf, deck, model, fields)
end

Buffer.ConfigWindow = function(buf)
	local width = 40
	local height = 20
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "single",
	})

	return win
end

-- ### standard options #########################################################
Buffer.SetDefaultsOptions = function(buf, win)
	api.nvim_buf_set_option(buf, "modifiable", true)
	-- Add a mapping to save the card and close the window
	api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>noautocmd q!<CR>", {})
	-- Set the cursor position to the first line of the buffer
	api.nvim_win_set_cursor(win, { 1, 0 })
	-- Set the filetype to markdown
	api.nvim_buf_set_option(buf, "filetype", "markdown")
	-- Set Spell
	api.nvim_command("setlocal spell")
	-- Set wrap
	api.nvim_command("setlocal wrap")
	-- Set textwidth
	api.nvim_command("setlocal textwidth=40")
end

-- ### Add Save Keymap ################################################################
-- Triggered by <S-s>
Buffer.AddSaveKeymap = function(buf, deck, model, fields)
	local params = {
		buf = buf,
		deck = deck,
		fields = fields,
		model = model,
	}
	api.nvim_buf_set_keymap(
		buf,
		"n",
		"<S-s>",
		"<Cmd>lua require('anki').Buffer.Save('" .. vim.fn.json_encode(params) .. "')<CR>",
		{}
	)
end

Buffer.PopulateFields = function(buf, fields)
	for key, value in pairs(fields) do
		api.nvim_buf_set_lines(buf, key - 1, -1, true, { "# " .. value })
	end
end

-- ### Save Callback ##################################################################
Buffer.Save = function(data)
	data = vim.fn.json_decode(data)
	local buf = data.buf
	local deck = data.deck
	local fields = Utils.GetFieldsFromBuff(buf, data.fields)
	local model = data.model

	local res = API.AddCard(deck, model, fields)
	if res then
		api.nvim_command("noautocmd q!")
	end
end

return Buffer
