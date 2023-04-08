local API = require("api")
local Buffer = require("buffer")
Anki = {}

-- ### Entry Point ################################################################
Anki.Run = function(type)
	-- get deck names
	local deck_names = API.GetDeckNames()
	-- get model names
	local model_names = API.GetModelNames()
	-- add "Add Deck" option
	deck_names[#deck_names + 1] = "Add Deck"

	-- start callback hell :|
	Anki.SelectDeck(deck_names, model_names, type)
end

-- selects a deck or adds a new one --> callback Anki.SelectModel
Anki.SelectDeck = function(deck_names, model_names, type)
	vim.ui.select(deck_names, {
		prompt = "Choose a deck:",
	}, function(choice)
		if choice == "Add Deck" then
			vim.ui.input({
				prompt = "Enter deck name:",
			}, function(name)
				if name then
					API.CreateDeck(name)
					Anki.SelectModel(model_names, name, type)
				end
			end)
		else
			if choice then
				Anki.SelectModel(model_names, choice, type)
			end
		end
	end)
end

-- selects a model --> callback Buffer.OpenWindow (opens the model window)
Anki.SelectModel = function(model_names, selected_deck, type)
	if not type then
		vim.ui.select(model_names, {
			prompt = "Choose a model:",
		}, function(choice)
			if choice then
				Buffer.OpenWindow(selected_deck, choice)
			end
		end)
	else
		Buffer.OpenWindow(selected_deck, type)
	end
end

return { Anki = Anki, Buffer = Buffer }
