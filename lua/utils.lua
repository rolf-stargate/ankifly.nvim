local Utils = {}

Utils.GetFieldsFromBuff = function(buf, fields)
	local extracted_fields = {}

	for _, field in pairs(fields) do
		extracted_fields[field] = Utils.ExtractField(buf, field)
	end

	for key, field in pairs(extracted_fields) do
		extracted_fields[key] = Utils.CheckForCodeBlocks(field)
	end

	for key, field in pairs(extracted_fields) do
		extracted_fields[key] = Utils.replaceBrTagInCodeBlock(field)
	end

	return extracted_fields
end

Utils.ExtractField = function(buf, field)
	local save = false
	local text = ""
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	for _, line in ipairs(lines) do
		if save and string.match(line, "^# ") then
			save = false
		elseif string.match(line, "^# " .. field) then
			save = true
		elseif save then
			text = text .. line .. "\n"
		end
	end
	text = string.gsub(text, "\n", "<br>")
	return text
end

Utils.CheckForCodeBlocks = function(text)
	local match = string.match(text, "```")
	while match do
		local language = string.match(text, "```%s*(%w+)")
		if language then
			text = string.gsub(text, language, "", 1)
			text = string.gsub(
				text,
				"```",
				'<pre style="display:flex; justify-content:center;"><code class="language-' .. language .. '"><br>',
				1
			)
			text = string.gsub(text, "```", "</code></pre><br><br>", 1)
			match = string.match(text, "```")
		else
			print("Error in code block!")
			print("string to parse was: " .. text)
			break
		end
	end

	return text
end

Utils.replaceBrTagInCodeBlock = function(text)
	local codeBlockContent = string.match(text, '<code class=".-"><br><br>(.-)</code>')
	if codeBlockContent then
		local parsedCodeBlockContent = string.gsub(codeBlockContent, "<br>", "\n")
		print(parsedCodeBlockContent)
		text = string.gsub(
			text,
			'<code class=".-"><br><br>.-</code>',
			'<code class=".-"><br>' .. parsedCodeBlockContent .. "</code>"
		)
	end

	return text
end

return Utils
