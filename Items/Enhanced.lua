-- Enhanced has to be loaded near-last because of Jolly edition

local atlasenhanced = {
    object_type = "Atlas",
    key = "atlasenhanced",
    path = "atlasdeck.png",
    px = 71,
    py = 95
}

packs_to_add = {atlasenhanced}

--[[for i = 1, #typed_decks do
	local deck = typed_decks[i]
	
	local shader = nil
	if deck[6] then
		shader = deck[1] .. '_' .. deck[6]
		if deck.no_prefix then
			shader = deck[6]
		end
	end
	
	local deck_name = deck[3]
	if not deck_name then
		deck_name = deck[4] .. ' Deck'
	end
	
	local deck_internal_name = ''
	if deck[1] == 'cry' then 	-- don't register eg. 'cry-cry-Typhoon Deck'
		deck_internal_name = 'cry-' .. deck_name
	else						-- eg. 'cry-jen-Blood Deck'
		deck_internal_name = 'cry-' .. deck[1] .. '-' .. deck_name
	end
	
	local deck_key = ''
	if deck[1] == 'cry' then
		deck_key = 'cry' .. (deck[5] or deck[4]) .. '_deck'
	else
		deck_key = 'cry' .. deck[1] .. '-' .. (deck[5] or deck[4]) .. '_deck'
	end
	
	local object_key = ''
	if deck[1] == '' or deck.no_prefix then -- vanilla doesn't have a prefix, don't add the _
		object_key = deck[5] or deck[4]
	else
		object_key = deck[1] .. '_' .. (deck[5] or deck[4])
	end
	
	local suit_key = ''
	if deck[1] == '' or deck.no_prefix then
		suit_key = deck[4]
	else
		suit_key = deck[1] .. '_' .. (deck[4])
	end

	if deck[2] == 'Edition' then
		local obj = {object_type = "Back",
			name = deck_internal_name,
			key = deck_key,
			config = {cry_force_edition = object_key, cry_force_edition_shader = shader},
			pos = {x = deck[8], y = deck[9]},
			loc_txt = {
				name = deck_name,
				text = {
					"All cards are {C:dark_edition,T:" .. object_key .. "}" .. deck[4] .. " Cards{}",
					"Cards cannot change editions",
					"{s:0.8,C:inactive}" .. deck[10]
				}
			},
		}
		if deck[7] then 
			obj.atlas = deck[7]
			if string.find(deck[7], "_") then
				obj.prefix_config = {atlas = false}
			end
		end
		if not deck[11] then
			obj.config.cry_no_edition_price = true
		end
		packs_to_add[#packs_to_add + 1] = obj
		
	elseif deck[2] == 'Enhancement' then
		local obj = {object_type = "Back",
			name = deck_internal_name,
			key = deck_key,
			config = {cry_force_enhancement = "m_" .. object_key},
			pos = {x = deck[8], y = deck[9]},
			loc_txt = {
				name = deck_name,
				text = {
					"All {C:attention}playing cards{}",
					"are {C:attention,T:m_" .. object_key .. "}" .. deck[4] .. " Cards{}",
					"Cards cannot change enhancements",
					"{s:0.8,C:inactive}" .. deck[10]
				}
			},
			
		}
		
		if deck[7] then 
			obj.atlas = deck[7]
			if string.find(deck[7], "_") then
				obj.prefix_config = {atlas = false}
			end
		end
		packs_to_add[#packs_to_add + 1] = obj
		
	elseif deck[2] == 'Seal' then

		local obj = {object_type = "Back",
			name = deck_internal_name,
			key = deck_key,
			config = {cry_force_seal = object_key},
			pos = {x = deck[8], y = deck[9]},
			loc_txt = {
				name = deck_name,
				text = {
					"All cards have a {C:dark_edition}" .. deck[4] .. " Seal{}",
					"Cards cannot change seals",
					"{s:0.8,C:inactive}" .. deck[10]
				}
			},
			
		}
		
		if deck[7] then 
			obj.atlas = deck[7]
			if string.find(deck[7], "_") then
				obj.prefix_config = {atlas = false}
			end
		end
		packs_to_add[#packs_to_add + 1] = obj
		
	elseif deck[2] == 'Sticker' then
	
		local obj = {object_type = "Back",
			name = deck_internal_name,
			key = deck_key,
			config = {cry_force_sticker = object_key}, -- stickers DON'T use object_key for SOME reason
			pos = {x = deck[8], y = deck[9]},
			loc_txt = {
				name = deck_name,
				text = {
					"All cards are {C:attention}" .. deck[4] .. "{}",
					"{s:0.8,C:inactive}" .. deck[10]
				}
			},
		}
	
		
		if deck[7] then 
			obj.atlas = deck[7]
			if string.find(deck[7], "_") then
				obj.prefix_config = {atlas = false}
			end
		end
		packs_to_add[#packs_to_add + 1] = obj
	
	elseif deck[2] == 'Suit' then

		local obj = {object_type = "Back",
			name = deck_internal_name,
			key = deck_key,
			config = {cry_force_suit = suit_key, cry_boss_blocked = deck[5] and {'bl_' .. object_key}},
			pos = {x = deck[8], y = deck[9]},
			loc_txt = {
				name = deck_name,
				text = {
					"All playing cards are {C:dark_edition}" .. deck[4] .. "{}",
					"and cannot change suits",
					deck[10] or "{s:0}",
					deck[5] and "{C:attention}The " .. string.upper(string.sub(deck[5], 1, 1)) .. string.sub(deck[5], 2) .. "{} cannot appear", -- UGLY hack
				}
			},
		}

		
		if deck[7] then 
			obj.atlas = deck[7]
			if string.find(deck[7], "_") then
				obj.prefix_config = {atlas = false}
			end
		end
		packs_to_add[#packs_to_add + 1] = obj
			
	end
end=--]]

Cryptid.Enhanced = {}
Cryptid.Enhanced.obj_buffer = {}

local function set_sprites(obj, sprite)
	obj.pos = sprite.pos
	obj.atlas = sprite.atlas
	obj.prefix_config = {atlas = false}
end

--possible arguments for these sorts of decks:
function Cryptid.Enhanced.Suit(suit)
	--issues with name could be fixed by updating the names after steamodded loads
	local name = suit.original_key.." Deck"
	local key = suit.key
	--todo: auto detect suit-generating consumeable, bosses
	obj = {
		name = name,
		cry_setup_name = false,
		cry_enhanced = "Suit",
		key = key,
		config = {cry_force_suit = key, cry_boss_blocked = {}},
		pos = {x = 5, y = 2},
		loc_txt = {
			name = name,
			text = {
				"All playing cards are {C:dark_edition}#1#{}",
				"and cannot change suits",
			}
		},
		loc_vars = function(self, info_queue, center)
			local boss_text = ""
			for i = 1, #self.config.cry_boss_blocked do
				boss_text = boss_text..localize{key = self.config.cry_boss_blocked[i], type = "name_text", set = "Blind"}
				if i < #self.config.cry_boss_blocked then
					boss_text = boss_text..", "
				end
			end
			return {vars = {localize(self.config.cry_force_suit, 'suits_plural'), boss_text}}
		end
	}
	--try to detect a consumable that sets to this suit
	for k, v in pairs(G.P_CENTER_POOLS.Consumeables) do
		if v.config and v.config.suit_conv and v.config.suit_conv == obj.config.cry_force_suit then
			set_sprites(obj, v)
			obj.atlas = "Tarot"
			obj.loc_txt.name = "Deck of "..v.name
			obj.config.name_tarot = k
		end
	end
	for k, v in pairs(SMODS.Centers) do
		if v.config and v.config.suit_conv and v.config.suit_conv == obj.config.cry_force_suit then
			set_sprites(obj, v)
			obj.loc_txt.name = "Deck of "..((v.name ~= v.key) and v.name or v.loc_txt and v.loc_txt.name or v.original_key)
			obj.config.name_tarot = k
		end
	end
	--try to detect blinds that debuff this suit
	local boss_found = false
	for k, v in pairs(G.P_BLINDS) do
		if v.debuff and v.debuff.suit and v.debuff.suit == obj.config.cry_force_suit then
			obj.config.cry_boss_blocked[#obj.config.cry_boss_blocked+1] = k
			if not boss_found then
				boss_found = true
				obj.loc_txt.text[#obj.loc_txt.text+1] = "{C:attention}#2#{} cannot appear"
			end
		end
	end
	for k, v in pairs(SMODS.Blinds) do
		if v.debuff and v.debuff.suit and v.debuff.suit == obj.config.cry_force_suit then
			obj.config.cry_boss_blocked[#obj.config.cry_boss_blocked+1] = k
			if not boss_found then
				boss_found = true
				obj.loc_txt.text[#obj.loc_txt.text+1] = "{C:attention}#2#{} cannot appear"
			end
		end
	end
	Cryptid.Enhanced.obj_buffer[key] = obj
	--[[local obj = {
			name = deck_internal_name,
			key = deck_key,
			config = {cry_force_suit = suit_key, cry_boss_blocked = deck[5] and {'bl_' .. object_key}},
			pos = {x = deck[8], y = deck[9]},
			loc_txt = {
				name = deck_name,
				text = {
					"All playing cards are {C:dark_edition}" .. deck[4] .. "{}",
					"and cannot change suits",
					deck[10] or "{s:0}",
					deck[5] and "{C:attention}The " .. string.upper(string.sub(deck[5], 1, 1)) .. string.sub(deck[5], 2) .. "{} cannot appear", -- UGLY hack
				}
			},
		}

		
	if deck[7] then 
		obj.atlas = deck[7]
		if string.find(deck[7], "_") then
			obj.prefix_config = {atlas = false}
		end
	end
	packs_to_add[#packs_to_add + 1] = obj--]]
end

local function setup_hooks()
	local Backapply_to_runRef = Back.apply_to_run
	function Back.apply_to_run(self)
		Backapply_to_runRef(self)
	
		if self.effect.config.cry_force_enhancement then
			if self.effect.config.cry_force_enhancement ~= 'random' then G.GAME.modifiers.cry_force_enhancement = self.effect.config.cry_force_enhancement end
			G.E_MANAGER:add_event(Event({
				func = function()
					for c = #G.playing_cards, 1, -1 do
						if self.effect.config.cry_force_enhancement == 'random' then
							local enh = {}
							for i = 1, #G.P_CENTER_POOLS.Enhanced do
								enh[#enh+1] = G.P_CENTER_POOLS.Enhanced[i]
							end
							enh[#enh+1] = "CCD"
							local random_enhancement = pseudorandom_element(enh, pseudoseed('cry_ant_enhancement'))
							if random_enhancement.key and G.P_CENTERS[random_enhancement.key] then
								G.playing_cards[c]:set_ability(G.P_CENTERS[random_enhancement.key]);
							else
								G.playing_cards[c]:set_ability(get_random_consumable('cry_ant_ccd'))
							end
						else
							G.playing_cards[c]:set_ability(G.P_CENTERS[self.effect.config.cry_force_enhancement]);
						end
					end
	
					return true
				end
			}))
		end
		if self.effect.config.cry_force_edition then
			if self.effect.config.cry_force_edition ~= 'random' then G.GAME.modifiers.cry_force_edition = self.effect.config.cry_force_edition else G.GAME.modifiers.cry_force_random_edition = true end
			G.E_MANAGER:add_event(Event({
				func = function()
					for c = #G.playing_cards, 1, -1 do
						local ed_table = {}
						if self.effect.config.cry_force_edition == 'random' then
							local random_edition = pseudorandom_element(G.P_CENTER_POOLS.Edition, pseudoseed('cry_ant_edition'))
							while (random_edition.key == "e_base") do
								random_edition = pseudorandom_element(G.P_CENTER_POOLS.Edition, pseudoseed('cry_ant_edition'))
							end
							ed_table[random_edition.key:sub(3)] = true
							G.playing_cards[c]:set_edition(ed_table, true, true);
						else
							ed_table[self.effect.config.cry_force_edition] = true
							G.playing_cards[c]:set_edition(ed_table, true, true);
						end
					end
	
					return true
				end
			}))
		end
		if self.effect.config.cry_force_seal then
			if self.effect.config.cry_force_seal ~= 'random' then G.GAME.modifiers.cry_force_seal = self.effect.config.cry_force_seal end
			G.E_MANAGER:add_event(Event({
				func = function()
					for c = #G.playing_cards, 1, -1 do
						if self.effect.config.cry_force_seal == 'random' then
							local random_seal = pseudorandom_element(G.P_CENTER_POOLS.Seal, pseudoseed('cry_ant_seal'))
							G.playing_cards[c]:set_seal(random_seal.key, true);
						else
							G.playing_cards[c]:set_seal(self.effect.config.cry_force_seal, true);
						end
					end
					return true
				end
			}))
		end
		if self.effect.config.cry_force_sticker then
			G.GAME.modifiers.cry_force_sticker = self.effect.config.cry_force_sticker
			G.E_MANAGER:add_event(Event({
				func = function()
					for c = #G.playing_cards, 1, -1 do
						G.playing_cards[c].config.center.eternal_compat = true
						G.playing_cards[c].config.center.perishable_compat = true
						if SMODS.Stickers[self.effect.config.cry_force_sticker].apply then
							SMODS.Stickers[self.effect.config.cry_force_sticker]:apply(G.playing_cards[c],true);
						else
							   G.playing_cards[c]["set_"..self.effect.config.cry_force_sticker](G.playing_cards[c],true);
						end
					end
					return true
				end
			}))
		end
		if self.effect.config.cry_force_suit then
			G.GAME.modifiers.cry_force_suit = self.effect.config.cry_force_suit
			G.E_MANAGER:add_event(Event({
				func = function()
					for c = #G.playing_cards, 1, -1 do
						G.playing_cards[c]:change_suit(self.effect.config.cry_force_suit)
					end
					return true
				end
			}))
		end
		if self.effect.config.cry_boss_blocked then
			for _, v in pairs(self.effect.config.cry_boss_blocked) do
				G.GAME.bosses_used[v] = 1e308
			end
		end
		if self.effect.config.cry_no_edition_price then
			G.GAME.modifiers.cry_no_edition_price = true
		end
	end
	local sa = Card.set_ability
	function Card:set_ability(center, y, z)
		if center and center.set == "Enhanced" then
			return sa(self, G.GAME.modifiers.cry_force_enhancement and G.P_CENTERS[G.GAME.modifiers.cry_force_enhancement] or center, y, z)
		else
			return sa(self, center, y, z)
		end
	end
	local se = Card.set_edition
	function Card:set_edition(edition, y, z)
		return se(self, G.GAME.modifiers.cry_force_edition and {[G.GAME.modifiers.cry_force_edition]=true} or edition, y, z)
	end
	local ss = Card.set_seal
	function Card:set_seal(seal, y, z)
		return ss(self, G.GAME.modifiers.cry_force_seal or seal, y, z)
	end
	local cs = Card.change_suit
	function Card:change_suit(new_suit)
		return cs(self, G.GAME.modifiers.cry_force_suit or new_suit)
	end
	local sc = Card.set_cost
	function Card:set_cost()
		if self.edition and G.GAME.modifiers.cry_no_edition_price then
			local m = cry_deep_copy(self.edition)
			self.edition = nil
			sc(self)
			self.edition = m
		else
			sc(self)
		end
	end
end

return {name = "Enhanced Decks", 
		delay_init = true,
        init = function()
			setup_hooks()
			for k, v in pairs(SMODS.Suits) do
				print(k)
				print(tprint(v,8))
				Cryptid.Enhanced.Suit(v)
			end
			for k, v in pairs(Cryptid.Enhanced.obj_buffer) do
				SMODS.Back(v)
			end
        end,
        items = packs_to_add}
