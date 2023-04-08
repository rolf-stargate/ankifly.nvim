local curl = require("plenary.curl")

local URL = "localhost:8765"

local function request(res)
	local decoded = vim.fn.json_decode(res.body)
	if decoded.error == vim.NIL then
		return decoded.result
	else
		error("AnkiConnect Error: " .. decoded.error)
	end
end

local API = {}

-- ### Post #######################################################################
API.Post = function(body)
	body = vim.fn.json_encode(body)
	return request(curl.post(URL, { body = body, headers = { content_type = "application/json" } }))
end

-- ### Get Deck Names #############################################################
API.GetDeckNames = function()
	return API.Post({ action = "deckNames", version = 6 })
end

-- ### Create Deck ################################################################
API.CreateDeck = function(deck_name)
	return API.Post({ action = "createDeck", version = 6, params = { deck = deck_name } })
end

-- ### Get Model Names ############################################################
API.GetModelNames = function()
	return API.Post({ action = "modelNames", version = 6 })
end

-- ### Get Model Field Names ######################################################
API.GetModelFieldNames = function(model_name)
	return API.Post({ action = "modelFieldNames", version = 6, params = { modelName = model_name } })
end

-- ### Add Card ###################################################################
API.AddCard = function(deck_name, model_name, fields)
	local body = {
		action = "addNote",
		version = 6,
		params = {
			note = {
				deckName = deck_name,
				modelName = model_name,
				fields = fields,
				options = {
					allowDuplicate = false,
					duplicateScope = "deck",
					duplicateScopeOptions = {
						deckName = deck_name,
						checkChildren = false,
						checkAllModels = false,
					},
				},
			},
		},
	}
	return API.Post(body)
end

return API
