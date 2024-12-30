-- gameset.lua: functions for gameset UI and logic

-------------------------
------ MODS LIST --------
-------------------------

-- If you plan on adding any new cross-mod content with one of these mods within the Cryptid source,
-- please add the name here so it displays properly in the Disabled message.
-- do it in the format MOD_ID = "MOD_NAME"
Cryptid.cross_mod_names = {
	CardSleeves = "Card Sleeves",
	Cryptid = "Cryptid",
	jen = "Jen's Almanac",
}

-- This is for any content that should override the gameset's default setting for its own default.
-- For instance if something is unstable it could be disabled by default in specific gamesets.
Cryptid.gameset_overrides = {
	modest = {
		e_double_sided = "disabled",
	},
	mainline = {
		e_double_sided = "disabled",
	},
	madness = {
		e_double_sided = "disabled",
	},
}

-------------------------
---- TUTORIAL SYSTEM ----
-------------------------

local gu = Game.update
function Game:update(dt)
	gu(self, dt)
	if not G.PROFILES[G.SETTINGS.profile].cry_intro_complete then
		G.FUNCS.cry_intro_controller()
	end
end

G.FUNCS.cry_intro_controller = function()
	G.PROFILES[G.SETTINGS.profile].cry_intro_progress = G.PROFILES[G.SETTINGS.profile].cry_intro_progress
		or {
			state = "start",
			completed = {},
		}
	if not G.SETTINGS.paused and not G.PROFILES[G.SETTINGS.profile].cry_intro_complete then
		if G.STATE == G.STATES.MENU and not G.PROFILES[G.SETTINGS.profile].cry_intro_progress.completed.start then
			G.PROFILES[G.SETTINGS.profile].cry_intro_progress.section = "start"
			G.FUNCS.cry_intro_part("start")
			G.PROFILES[G.SETTINGS.profile].cry_intro_progress.completed.start = true
			G:save_progress()
		end
	end
end

function create_UIBox_character_button_with_sprite(args)
	local button = args.button or "NONE"
	local func = args.func or nil
	local colour = args.colour or G.C.RED
	local update_func = args.update_func or nil
	local sprite = args.sprite or nil

	local t = --{n=G.UIT.ROOT, config = {align = "cm", padding = 0.1, colour = G.C.CLEAR}, nodes={
		{
			n = G.UIT.C,
			config = {
				align = "tm",
				minw = 2.5,
				padding = 0.2,
				minh = 1.2,
				r = 0.1,
				hover = true,
				colour = colour,
				button = func,
				func = update_func,
				shadow = true,
				maxw = args.maxw,
				id = args.id,
			},
			nodes = {
				{
					n = G.UIT.R,
					config = { align = "cm", padding = 0 },
					nodes = {
						{
							n = G.UIT.T,
							config = {
								text = button,
								scale = 0.55,
								colour = G.C.UI.TEXT_LIGHT,
								focus_args = { button = "x", orientation = "bm" },
								func = "set_button_pip",
							},
						},
					},
				},
				{
					n = G.UIT.R,
					config = { align = "cm", padding = 0 },
					nodes = {
						{ n = G.UIT.O, config = { object = sprite } },
					},
				},
			},
		} --,
	--}}
	return t
end

G.FUNCS.cry_intro_part = function(_part)
	local step = 1
	G.SETTINGS.paused = true
	if _part == "start" then
		G.gateway = Sprite(
			G.ROOM_ATTACH.T.x + G.ROOM_ATTACH.T.w / 2 - 1,
			G.ROOM_ATTACH.T.y + G.ROOM_ATTACH.T.h / 2 - 4,
			G.CARD_W * 1.5,
			G.CARD_H * 1.5,
			G.ASSET_ATLAS["cry_atlasnotjokers"],
			{ x = 2, y = 0 }
		)
		G.gateway.states.visible = false
		G.gateway.states.collide.can = true
		G.gateway.states.focus.can = false
		G.gateway.states.hover.can = true
		G.gateway.states.drag.can = false
		G.gateway.hover = Node.hover
		G.yawetag = Sprite(
			G.ROOM_ATTACH.T.x + G.ROOM_ATTACH.T.w / 2 - 1,
			G.ROOM_ATTACH.T.y + G.ROOM_ATTACH.T.h / 2 - 4,
			G.CARD_W * 1.5,
			G.CARD_H * 1.5,
			G.ASSET_ATLAS["cry_atlasnotjokers"],
			{ x = 6, y = 5 }
		)
		G.yawetag.states.visible = false
		G.yawetag.states.collide.can = true
		G.yawetag.states.focus.can = false
		G.yawetag.states.hover.can = true
		G.yawetag.states.drag.can = false
		G.yawetag.hover = Node.hover
		step = cry_intro_info({
			text_key = "cry_intro_1",
			attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
			step = step,
		})
		step = cry_intro_info({
			text_key = "cry_intro_2",
			attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = -3 } },
			step = step,
		})
		step = cry_intro_info({
			text_key = "cry_intro_3",
			attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = -3 } },
			step = step,
			highlight = {
				G.gateway,
				G.yawetag,
			},
			on_start = function()
				G.gateway.states.visible = true
				G.gateway:set_alignment({ major = G.ROOM_ATTACH, type = "cm", offset = { x = -2.5, y = -3 } })
				G.yawetag.states.visible = true
				G.yawetag:set_alignment({ major = G.ROOM_ATTACH, type = "cm", offset = { x = 2.5, y = -3 } })
			end,
		})
		step = cry_intro_info({
			text_key = "cry_intro_4",
			attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = -3 } },
			step = step,
			highlight = {
				G.gateway,
				G.yawetag,
			},
		})
		local modestSprite = Sprite(0, 0, 1, 1, G.ASSET_ATLAS["cry_gameset"], { x = 0, y = 0 })
		modestSprite:define_draw_steps({
			{ shader = "dissolve", shadow_height = 0.05 },
			{ shader = "dissolve" },
		})
		local mainlineSprite = Sprite(0, 0, 1, 1, G.ASSET_ATLAS["cry_gameset"], { x = 1, y = 0 })
		mainlineSprite:define_draw_steps({
			{ shader = "dissolve", shadow_height = 0.05 },
			{ shader = "dissolve" },
		})
		local madnessSprite = Sprite(0, 0, 1, 1, G.ASSET_ATLAS["cry_gameset"], { x = 2, y = 0 })
		madnessSprite:define_draw_steps({
			{ shader = "dissolve", shadow_height = 0.05 },
			{ shader = "dissolve" },
		})
		--TODO: localize
		G.modestBtn = create_UIBox_character_button_with_sprite({
			sprite = modestSprite,
			button = "Modest",
			id = "modest",
			func = "cry_modest",
			colour = G.C.GREEN,
			maxw = 3,
		})
		G.mainlineBtn = create_UIBox_character_button_with_sprite({
			sprite = mainlineSprite,
			button = "Mainline",
			id = "mainline",
			func = "cry_mainline",
			colour = G.C.RED,
			maxw = 3,
		})
		G.madnessBtn = create_UIBox_character_button_with_sprite({
			sprite = madnessSprite,
			button = "Madness",
			id = "madness",
			func = "cry_madness",
			colour = G.C.CRY_EXOTIC,
			maxw = 3,
		})
		local gamesetUI = create_UIBox_generic_options({
			infotip = false,
			contents = {
				G.modestBtn,
				G.mainlineBtn,
				G.madnessBtn,
			},
			back_label = "Confirm",
			back_colour = G.C.BLUE,
			back_func = "cry_gameset_confirm",
		})
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blocking = false,
			blockable = false,
			func = function()
				G.madnessBtn.config.colour = G.C.CRY_EXOTIC
				return true
			end,
		}))
		gamesetUI.nodes[2] = nil
		gamesetUI.config.colour = G.C.CLEAR
		G.gamesetUI = UIBox({
			definition = gamesetUI,
			config = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 2.5 } },
		})
		G.gamesetUI.states.visible = false
		step = cry_intro_info({
			text_key = "cry_intro_5",
			attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = -3 } },
			step = step,
			highlight = {
				G.gateway,
				G.yawetag,
				G.gamesetUI,
			},
			on_start = function()
				--the scaling should be eased later...
				G.gamesetUI.states.visible = true
				G.gateway:set_alignment({ major = G.ROOM_ATTACH, type = "cm", offset = { x = -4.5, y = 2.2 } })
				G.gateway.T.w = G.gateway.T.w * 3
				G.gateway.T.h = G.gateway.T.h * 3
				G.yawetag:set_alignment({ major = G.ROOM_ATTACH, type = "cm", offset = { x = 4.5, y = 2.2 } })
				G.yawetag.T.w = G.yawetag.T.w * 3
				G.yawetag.T.h = G.yawetag.T.h * 3
			end,
			no_button = true,
		})
	end
	if _part == "modest" or _part == "mainline" or _part == "madness" then
		local desc_length = { --number of times Jolly Joker speaks for each gameset
			modest = 2,
			mainline = 3,
			madness = 3,
		}
		G.E_MANAGER:clear_queue("tutorial")
		if G.OVERLAY_TUTORIAL.content then
			G.OVERLAY_TUTORIAL.content:remove()
		end
		G.OVERLAY_TUTORIAL.Jimbo:remove_button()
		G.OVERLAY_TUTORIAL.Jimbo:remove_speech_bubble()
		G.OVERLAY_TUTORIAL.step = nil
		for i = 1, desc_length[_part] do
			step = cry_intro_info({
				text_key = "cry_" .. _part .. "_" .. i,
				attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = -3 } },
				step = step,
				highlight = {
					G.gamesetUI:get_UIE_by_ID(_part),
				},
			})
		end
		step = cry_intro_info({
			no_button = true,
			attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = -3 } },
			step = step,
			highlight = {
				G.gateway,
				G.yawetag,
				G.gamesetUI,
			},
		})
	end
end

G.FUNCS.cry_modest = function(e)
	G.modestBtn.config.colour = G.C.CRY_SELECTED
	G.mainlineBtn.config.colour = G.C.RED
	G.madnessBtn.config.colour = G.C.CRY_EXOTIC
	G.FUNCS.cry_intro_part("modest")
	G.selectedGameset = "modest"
end
G.FUNCS.cry_mainline = function(e)
	G.modestBtn.config.colour = G.C.GREEN
	G.mainlineBtn.config.colour = G.C.CRY_SELECTED
	G.madnessBtn.config.colour = G.C.CRY_EXOTIC
	G.FUNCS.cry_intro_part("mainline")
	G.selectedGameset = "mainline"
end
G.FUNCS.cry_madness = function(e)
	G.modestBtn.config.colour = G.C.GREEN
	G.mainlineBtn.config.colour = G.C.RED
	G.madnessBtn.config.colour = G.C.CRY_SELECTED
	G.FUNCS.cry_intro_part("madness")
	G.selectedGameset = "madness"
end
G.FUNCS.cry_gameset_confirm = function(e) --WIP
	if G.selectedGameset then
		G.PROFILES[G.SETTINGS.profile].cry_intro_complete = true
		G.PROFILES[G.SETTINGS.profile].cry_gameset = G.selectedGameset
		G.SETTINGS.paused = false
		G.gamesetUI:remove()
		G.gateway:remove()
		G.yawetag:remove()
		G.E_MANAGER:clear_queue("tutorial")
		G.OVERLAY_TUTORIAL.Jimbo:remove()
		if G.OVERLAY_TUTORIAL.content then
			G.OVERLAY_TUTORIAL.content:remove()
		end
		G.OVERLAY_TUTORIAL:remove()
		G.OVERLAY_TUTORIAL = nil
	end
end

function cry_intro_info(args)
	local overlay_colour = { 0.32, 0.36, 0.41, 0 }
	ease_value(overlay_colour, 4, 0.6, nil, "REAL", true, 0.4)
	G.OVERLAY_TUTORIAL = G.OVERLAY_TUTORIAL
		or UIBox({
			definition = {
				n = G.UIT.ROOT,
				config = { align = "cm", padding = 32.05, r = 0.1, colour = overlay_colour, emboss = 0.05 },
				nodes = {},
			},
			config = {
				align = "cm",
				offset = { x = 0, y = 3.2 },
				major = G.ROOM_ATTACH,
				bond = "Weak",
			},
		})
	G.OVERLAY_TUTORIAL.step = G.OVERLAY_TUTORIAL.step or 1
	G.OVERLAY_TUTORIAL.step_complete = false
	local row_dollars_chips = G.HUD and G.HUD:get_UIE_by_ID("row_dollars_chips") or G.ROOM_ATTACH
	local align = args.align or "tm"
	local step = args.step or 1
	local attach = args.attach or { major = row_dollars_chips, type = "tm", offset = { x = 0, y = -0.5 } }
	local pos = args.pos or { x = attach.major.T.x + attach.major.T.w / 2, y = attach.major.T.y + attach.major.T.h / 2 }
	local button = args.button or { button = localize("b_next"), func = "tut_next" }
	args.highlight = args.highlight or {}
	G.E_MANAGER:add_event(
		Event({
			trigger = "after",
			delay = 0.3,
			func = function()
				if G.OVERLAY_TUTORIAL and G.OVERLAY_TUTORIAL.step == step and not G.OVERLAY_TUTORIAL.step_complete then
					if args.on_start then
						args.on_start()
					end
					G.CONTROLLER.interrupt.focus = true
					G.OVERLAY_TUTORIAL.Jimbo = G.OVERLAY_TUTORIAL.Jimbo or Card_Character(pos)
					if type(args.highlight) == "function" then
						args.highlight = args.highlight()
					end
					args.highlight[#args.highlight + 1] = G.OVERLAY_TUTORIAL.Jimbo
					if args.text_key then
						G.OVERLAY_TUTORIAL.Jimbo:add_speech_bubble(args.text_key, align, args.loc_vars)
					end
					G.OVERLAY_TUTORIAL.Jimbo:set_alignment(attach)
					if args.hard_set then
						G.OVERLAY_TUTORIAL.Jimbo:hard_set_VT()
					end
					G.OVERLAY_TUTORIAL.button_listen = nil
					if G.OVERLAY_TUTORIAL.content then
						G.OVERLAY_TUTORIAL.content:remove()
					end
					if args.content then
						G.OVERLAY_TUTORIAL.content = UIBox({
							definition = args.content(),
							config = {
								align = args.content_config and args.content_config.align or "cm",
								offset = args.content_config and args.content_config.offset or { x = 0, y = 0 },
								major = args.content_config and args.content_config.major or G.OVERLAY_TUTORIAL.Jimbo,
								bond = "Weak",
							},
						})
						args.highlight[#args.highlight + 1] = G.OVERLAY_TUTORIAL.content
					end
					if args.button_listen then
						G.OVERLAY_TUTORIAL.button_listen = args.button_listen
					end
					if not args.no_button then
						G.OVERLAY_TUTORIAL.Jimbo:add_button(
							button.button,
							button.func,
							button.colour,
							button.update_func,
							true
						)
					end
					G.OVERLAY_TUTORIAL.Jimbo:say_stuff(2 * #(G.localization.misc.tutorial[args.text_key] or {}) + 1)
					if args.snap_to then
						G.E_MANAGER:add_event(
							Event({
								trigger = "immediate",
								blocking = false,
								blockable = false,
								func = function()
									if
										G.OVERLAY_TUTORIAL
										and G.OVERLAY_TUTORIAL.Jimbo
										and not G.OVERLAY_TUTORIAL.Jimbo.talking
									then
										local _snap_to = args.snap_to()
										if _snap_to then
											G.CONTROLLER.interrupt.focus = false
											G.CONTROLLER:snap_to({ node = args.snap_to() })
										end
										return true
									end
								end,
							}),
							"tutorial"
						)
					end
					if args.highlight then
						G.OVERLAY_TUTORIAL.highlights = args.highlight
					end
					G.OVERLAY_TUTORIAL.step_complete = true
				end
				return not G.OVERLAY_TUTORIAL or G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
			end,
		}),
		"tutorial"
	)
	return step + 1
end

-- Profile stuff: all profiles start with M to separate from vanilla
function G.UIDEF.profile_select()
	G.focused_profile = G.focused_profile or G.SETTINGS.profile or (Cryptid.profile_prefix .. "1")

	local t = create_UIBox_generic_options({
		padding = 0,
		contents = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0, draw_layer = 1, minw = 4 },
				nodes = {
					create_tabs({
						tabs = {
							{
								label = Cryptid.profile_prefix .. "1",
								chosen = G.focused_profile == (Cryptid.profile_prefix .. "1"),
								tab_definition_function = G.UIDEF.profile_option,
								tab_definition_function_args = Cryptid.profile_prefix .. "1",
							},
							{
								label = Cryptid.profile_prefix .. "2",
								chosen = G.focused_profile == (Cryptid.profile_prefix .. "2"),
								tab_definition_function = G.UIDEF.profile_option,
								tab_definition_function_args = Cryptid.profile_prefix .. "2",
							},
							{
								label = Cryptid.profile_prefix .. "3",
								chosen = G.focused_profile == (Cryptid.profile_prefix .. "3"),
								tab_definition_function = G.UIDEF.profile_option,
								tab_definition_function_args = Cryptid.profile_prefix .. "3",
							},
						},
						snap_to_nav = true,
					}),
				},
			},
		},
	})
	return t
end

------------------------
---- GAMESET SYSTEM ----
------------------------

-- Gets gameset sprite of current profile
function gameset_sprite(scale, profile, force_gameset)
	gameset = force_gameset or G.PROFILES[profile or G.SETTINGS.profile].cry_gameset_overrides and "modified" or G.PROFILES[profile or G.SETTINGS.profile].cry_gameset
	scale = scale or 1
	local sprite = Sprite(
		0,
		0,
		scale,
		scale,
		G.ASSET_ATLAS["cry_gameset"],
		{ x = (gameset == "modified" and 3 or gameset == "madness" and 2 or gameset == "modest" and 0 or 1), y = 0 }
	)
	sprite:define_draw_steps({
		{ shader = "dissolve", shadow_height = 0.09 },
		{ shader = "dissolve" },
	})
	sprite.states.collide.can = true
	sprite.states.drag.can = true
	return sprite
end

-- designed to work on any object type
function cry_get_gameset(card, center)
	if not center then
		if not card then
			return G.PROFILES[G.SETTINGS.profile].cry_gameset or "mainline"
		end
		center = card.config and card.config.center or card.effect and card.effect.center or card
	end
	if card.force_gameset then
		return card.force_gameset
	end
	if center.force_gameset then
		return center.force_gameset
	end
	if not center.key then
		if center.tag and center.tag.key then --dumb fix for tags
			center = center.tag
		else
			error("Could not find key for center: "..tprint(center))
		end
	end
	local gameset = G.PROFILES[G.SETTINGS.profile].cry_gameset or "mainline"
	if
		G.PROFILES[G.SETTINGS.profile].cry_gameset_overrides
		and G.PROFILES[G.SETTINGS.profile].cry_gameset_overrides[center.key]
	then
		return G.PROFILES[G.SETTINGS.profile].cry_gameset_overrides[center.key]
	end
	if Cryptid.gameset_overrides[gameset][center.key] then
		return Cryptid.gameset_overrides[gameset][center.key]
	end
	return gameset
end
-- set_ability accounts for gamesets
function Card:get_gameset(center)
	return cry_get_gameset(self, center)
end
local csa = Card.set_ability
function Card:set_ability(center, y, z)
	csa(self, center, y, z)
	if center.gameset_config and center.gameset_config[self:get_gameset(center)] then
		for k, v in pairs(center.gameset_config[self:get_gameset(center)]) do
			if k ~= "disabled" and k ~= "center" then
				if k == "cost" then
					self.base_cost = v
				else
					self.ability[k] = v
				end
			end
		end
		if center.gameset_config[self:get_gameset(center)].disabled then
			self.cry_disabled = true
		end
		if center.gameset_config[self:get_gameset(center)].center and not self.gameset_select then
			for k, v in pairs(center.gameset_config[self:get_gameset(center)].center) do
				center[k] = v
				self[k] = v
				if k == "rarity" then
					center:set_rarity(v)
				end
			end
		end
	end
end

--open gameset config UI when clicking on a card in the Cryptid collection
local ccl = Card.click
function Card:click()
	ccl(self)
	if G.your_collection then
		for k, v in pairs(G.your_collection) do
			if self.area == v and G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id == "Cryptid" then
				if not self.config.center or self.config.center and self.config.center.set == "Default" then
					--make a fake center
					local old_force_gameset = self.config.center and self.config.center.force_gameset
					if self.seal then
						self.config.center = SMODS.Seal.obj_table[self.seal]
						self.config.center.set = "Seal"
					end
					for k, v in pairs(SMODS.Stickers) do
						if self.ability[k] then
							self.config.center = SMODS.Sticker.obj_table[k]
							self.config.center.set = "Sticker"
						end
					end
					if self.config.center then
						self.config.center.force_gameset = old_force_gameset
					end
				end
				if self.gameset_select then
					Card.cry_set_gameset(self, self.config.center, self.config.center.force_gameset)
					cry_update_obj_registry()
				end
				cry_gameset_config_UI(self.config.center)
			end
		end
	end
	if G.GAME.viewed_back and self.config.center.key == 'c_base' then
		cry_gameset_config_UI(G.GAME.viewed_back.effect.center)
	end
end

-- gameset config UI
function cry_gameset_config_UI(center)
	G.SETTINGS.paused = true
	G.your_collection = {}
	G.your_collection[1] = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		5.3 * G.CARD_W,
		1.03 * G.CARD_H,
		{ card_limit = 5, type = "title", highlight_limit = 0, collection = true }
	)
	local deck_tables = {
		n = G.UIT.R,
		config = { align = "cm", padding = 0, no_fill = true },
		nodes = {
			{ n = G.UIT.O, config = { object = G.your_collection[1] } },
		},
	}

	local gamesets = { "disabled", "modest", "mainline", "madness" }
	if center.extra_gamesets then
		for i = 1, #center.extra_gamesets do
			gamesets[#gamesets + 1] = center.extra_gamesets[i]
		end
	end
    if center.set == "Content Set" then
        gamesets = { "disabled", G.PROFILES[G.SETTINGS.profile].cry_gameset }
    end

	for i = 1, #gamesets do
		if not (center.gameset_config and center.gameset_config[gamesets[i]] and center.gameset_config[gamesets[i]].disabled) then
			local _center = cry_deep_copy(center)
			_center.force_gameset = gamesets[i]
			local card = create_generic_card(_center)
			card.gameset_select = true
			G.your_collection[1]:emplace(card)
			--[[if not is_back then
				local card = Card(
					G.your_collection[1].T.x + G.your_collection[1].T.w / 2,
					G.your_collection[1].T.y,
					G.CARD_W,
					G.CARD_H,
					G.P_CARDS.empty,
					_center
				)
				card:start_materialize()
				card.gameset_select = true
				G.your_collection[1]:emplace(card)
			else
				local fake_center = {
					set = "Back",
					force_gameset = gamesets[i],
					pos = center.pos,
					atlas = center.atlas,
					key = center.key,
					config = {}
				}
				local card = Card(G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h, G.CARD_W, G.CARD_H, G.P_CARDS.empty, fake_center)		
				card:start_materialize()
				card.gameset_select = true
				G.your_collection[1]:emplace(card)
			end--]]
		end
	end

	INIT_COLLECTION_CARD_ALERTS()

	local t = create_UIBox_generic_options({
		infotip = localize("cry_gameset_explanation"),
		back_func = "openModUI_Cryptid",
		snap_back = true,
		contents = {
			{
				n = G.UIT.R,
				config = { align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05 },
				nodes = { deck_tables },
			},
		},
	})
	G.FUNCS.overlay_menu({
		definition = t,
	})
end

-- change the rarity sticker's color for gameset selection on an item
local gtc = get_type_colour
function get_type_colour(center, card)
	local color = gtc(center, card)
	if center.set == "Back" or center.set == "Tag" or center.set == "Blind" then
		color = G.C.CRY_SELECTED
	end
	if card.gameset_select then
		if center.force_gameset == "modest" then
			color = G.C.GREEN
		elseif center.force_gameset == "mainline" then
			color = G.C.RED
		elseif center.force_gameset == "madness" then
			color = G.C.CRY_EXOTIC
		elseif center.force_gameset ~= "disabled" then
			color = G.C.CRY_ASCENDANT
		end
	end
	if
		cry_get_gameset(card, center) == "disabled"
		or (center.cry_disabled and (not card.gameset_select or center.cry_disabled.type ~= "manual"))
	then
		color = mix_colours(G.C.RED, G.C.GREY, 0.7)
	end
	return color
end

function Card:cry_set_gameset(center, gameset)
	if
		G.PROFILES[G.SETTINGS.profile].cry_gameset == gameset
		and not G.PROFILES[G.SETTINGS.profile].cry_gameset_overrides
	then
		return
	end
	if not G.PROFILES[G.SETTINGS.profile].cry_gameset_overrides then
		G.PROFILES[G.SETTINGS.profile].cry_gameset_overrides = {}
	end
	G.PROFILES[G.SETTINGS.profile].cry_gameset_overrides[center.key] = gameset
	if G.PROFILES[G.SETTINGS.profile].cry_gameset == gameset then
		G.PROFILES[G.SETTINGS.profile].cry_gameset_overrides[center.key] = nil
	end
	local empty = true
	for _, _ in pairs(G.PROFILES[G.SETTINGS.profile].cry_gameset_overrides) do
		empty = false
		break
	end
	if empty then
		G.PROFILES[G.SETTINGS.profile].cry_gameset_overrides = nil
	end
	G:save_progress()
end

function cry_card_enabled(key, iter)
	if not iter then
		iter = 0
	end --iter is used to prevent infinite loops from freezing on startup
	if iter > 10 then
		print("Warning: Circular dependency with " .. key)
		return true
	end
	local card = cry_get_center(key)
	if cry_get_gameset(card) == "disabled" or card.gameset_config and card.gameset_config[cry_get_gameset(card)] and card.gameset_config[cry_get_gameset(card)].disabled then
		return { type = "manual" }
	end
	if card.dependencies then
		if card.dependencies.items then
			for i = 1, #card.dependencies.items do
				if cry_card_enabled(card.dependencies.items[i], iter + 1) ~= true then
					return { type = "card_dependency", key = card.dependencies.items[i] }
				end
			end
		end
		if card.dependencies.mods then
			for i = 1, #card.dependencies.mods do
				if not (SMODS.Mods[card.dependencies.mods[i]] or {}).can_load then
					return { type = "mod_dependency", key = card.dependencies.mods[i] }
				end
			end
		end
	end
	if card.conflicts then
		if card.conflicts.mods then
			for i = 1, #card.conflicts.mods do
				if (SMODS.Mods[card.conflicts.mods[i]] or {}).can_load then
					return { type = "mod_conflict", key = card.conflicts.mods[i] }
				end
			end
		end
	end
	return true
end

function cry_get_center(key, m)
	if not m then
		-- check for non game objects
		if SMODS.Seals.obj_table and SMODS.Seals.obj_table[key] then
			return SMODS.Seals.obj_table[key]
		end
		if SMODS.Stickers.obj_table and SMODS.Stickers.obj_table[key] then
			return SMODS.Stickers.obj_table[key]
		end
		m = SMODS.GameObject
		if m.subclasses then
			for k, v in pairs(m.subclasses) do
				local c = cry_get_center(key, v)
				if c then
					return c
				end
			end
		end
	end
	return m.obj_table and m.obj_table[key]
end

------------------------------
---- CARD ENABLING SYSTEM ----
------------------------------

SMODS.GameObject.disable = function(self, reason)
	self.cry_disabled = reason or { type = "manual" } --used to display more information that can be used later
end
SMODS.GameObject.enable = function(self)
	self.cry_disabled = nil
end

SMODS.Center.disable = function(self, reason)
	self.cry_disabled = reason or { type = "manual" } --used to display more information that can be used later
	SMODS.remove_pool(G.P_CENTER_POOLS[self.set], self.key)
	G.P_CENTERS[self.key] = nil
end
SMODS.Center.enable = function(self)
	self.cry_disabled = nil
	SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
	G.P_CENTERS[self.key] = self
end
--todo: properly deal with rarity pools being changed by gamesets
SMODS.Joker.enable = function(self)
	SMODS.Center.enable(self)
	SMODS.insert_pool(G.P_JOKER_RARITY_POOLS[self.rarity], self)
	local vanilla_rarities = {["Common"] = 1, ["Uncommon"] = 2, ["Rare"] = 3, ["Legendary"] = 4}
	if vanilla_rarities[self.rarity] then
		SMODS.insert_pool(G.P_JOKER_RARITY_POOLS[vanilla_rarities[self.rarity]], self)
	end
end
SMODS.Joker.disable = function(self, reason)
	SMODS.Center.disable(self, reason)
	SMODS.remove_pool(G.P_JOKER_RARITY_POOLS[self.rarity], self.key)
	local vanilla_rarities = {["Common"] = 1, ["Uncommon"] = 2, ["Rare"] = 3, ["Legendary"] = 4}
	if vanilla_rarities[self.rarity] then
		SMODS.remove_pool(G.P_JOKER_RARITY_POOLS[vanilla_rarities[self.rarity]], self.key)
	end
end
SMODS.Joker.set_rarity = function(self, rarity)
	SMODS.remove_pool(G.P_JOKER_RARITY_POOLS[self.rarity], self.key)
	self.rarity = rarity
	SMODS.insert_pool(G.P_JOKER_RARITY_POOLS[self.rarity], self)
	local vanilla_rarities = {["Common"] = 1, ["Uncommon"] = 2, ["Rare"] = 3, ["Legendary"] = 4}
	if vanilla_rarities[self.rarity] then
		SMODS.insert_pool(G.P_JOKER_RARITY_POOLS[vanilla_rarities[self.rarity]], self)
	end
end

SMODS.Consumable.enable = function(self)
	SMODS.Center.enable(self)
	SMODS.insert_pool(G.P_CENTER_POOLS['Consumeables'], self)
end
SMODS.Consumable.disable = function(self, reason)
	SMODS.Center.disable(self, reason)
	SMODS.remove_pool(G.P_CENTER_POOLS['Consumeables'], self.key)
end

SMODS.Tag.disable = function(self, reason)
	self.cry_disabled = reason or { type = "manual" } --used to display more information that can be used later
	SMODS.remove_pool(G.P_CENTER_POOLS[self.set], self.key)
	G.P_TAGS[self.key] = nil
end
SMODS.Tag.enable = function(self)
	self.cry_disabled = nil
	SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
	G.P_TAGS[self.key] = self
end

SMODS.Blind.disable = function(self, reason)
	self.cry_disabled = reason or { type = "manual" } --used to display more information that can be used later
	G.P_BLINDS[self.key] = nil
end
SMODS.Blind.enable = function(self)
	self.cry_disabled = nil
	G.P_BLINDS[self.key] = self
end

--Removing seals from the center table causes issues
SMODS.Seal.disable = function(self, reason)
	self.cry_disabled = reason or { type = "manual" } --used to display more information that can be used later
	SMODS.remove_pool(G.P_CENTER_POOLS[self.set], self.key)
end
SMODS.Seal.enable = function(self)
	self.cry_disabled = nil
	SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
end

--Removing editions from the center table causes issues, so instead we make them unable to spawn naturally
SMODS.Edition.disable = function(self, reason)
	self.cry_disabled = reason or { type = "manual" } --used to display more information that can be used later
	SMODS.remove_pool(G.P_CENTER_POOLS[self.set], self.key)
	self.cry_get_weight = self.get_weight
	self.get_weight = function() return 0 end
end
SMODS.Edition.enable = function(self)
	self.cry_disabled = nil
	SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
	self.get_weight = self.cry_get_weight
	self.cry_get_weight = nil
end

function cry_update_obj_registry(m)
	if not m then
		m = SMODS.GameObject
		if m.subclasses then
			for k, v in pairs(m.subclasses) do
				cry_update_obj_registry(v)
			end
		end
	end
	if m.obj_table then
		for k, v in pairs(m.obj_table) do
			if v.mod and v.mod.id == "Cryptid" then
				local en = cry_card_enabled(k)
				if en == true then
					if v.cry_disabled then
						v:enable()
					end
				else
					if not v.cry_disabled then
						v:disable(en)
					end
				end
			end
		end
	end
end
G.cuor = cry_update_obj_registry
local init_item_prototypes_ref = Game.init_item_prototypes
function Game:init_item_prototypes()
	init_item_prototypes_ref(self)
	cry_update_obj_registry()
end

------------------------
----- CONTENT SETS -----
------------------------

-- Content sets are used to group cards together in the settings menu, to bulk enable/disable things
-- These include CSL content sets, as well as others which are categorical (nostalgic items, epic jokers, etc.)
-- Because of this, they are referred to as Thematic Sets in-game

SMODS.ContentSet = SMODS.Center:extend({
	set = "Content Set",
	pos = { x = 0, y = 0 },
	config = {},
	class_prefix = "set",
	required_params = {
		"key",
	},
	inject = function(self)
		if not G.P_CENTER_POOLS[self.set] then
			G.P_CENTER_POOLS[self.set] = {}
		end
		SMODS.Center.inject(self)
	end,
})
G.P_CENTER_POOLS["Content Set"] = {}
SMODS.ContentSet({
	key = "m",
	atlas = "atlasepic",
	pos = { x = 3, y = 1 },
})

-- these are mostly copy/paste from vanilla code
G.FUNCS.your_collection_content_sets = function(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = create_UIBox_your_collection_content_sets(),
	})
end

function create_UIBox_your_collection_content_sets()
	local deck_tables = {}

	G.your_collection = {}
	for j = 1, 3 do
		G.your_collection[j] = CardArea(
			G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
			G.ROOM.T.h,
			5 * G.CARD_W,
			0.95 * G.CARD_H,
			{ card_limit = 5, type = "title", highlight_limit = 0, collection = true }
		)
		table.insert(
			deck_tables,
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.07, no_fill = true },
				nodes = {
					{ n = G.UIT.O, config = { object = G.your_collection[j] } },
				},
			}
		)
	end

	local joker_pool = {}
    for k, v in pairs(SMODS.ContentSet.obj_table) do
        if v.set == "Content Set" then
            table.insert(joker_pool, v)
        end
    end
	local joker_options = {}
	for i = 1, math.ceil(#joker_pool / (5 * #G.your_collection)) do
		table.insert(
			joker_options,
			localize("k_page")
				.. " "
				.. tostring(i)
				.. "/"
				.. tostring(math.ceil(#joker_pool / (5 * #G.your_collection)))
		)
	end

	for i = 1, 5 do
		for j = 1, #G.your_collection do
			local center = joker_pool[i + (j - 1) * 5]
			if not center then
				break
			end
			local card = Card(
				G.your_collection[j].T.x + G.your_collection[j].T.w / 2,
				G.your_collection[j].T.y,
				G.CARD_W,
				G.CARD_H,
				nil,
				center
			)
			G.your_collection[j]:emplace(card)
		end
	end

	INIT_COLLECTION_CARD_ALERTS()

	local t = create_UIBox_generic_options({
		back_func = G.ACTIVE_MOD_UI and "openModUI_" .. G.ACTIVE_MOD_UI.id or "your_collection",
		contents = {
			{ n = G.UIT.R, config = { align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05 }, nodes = deck_tables },
			{
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					create_option_cycle({
						options = joker_options,
						w = 4.5,
						cycle_shoulders = true,
						opt_callback = "your_collection_content_set_page",
						current_option = 1,
						colour = G.C.RED,
						no_pips = true,
						focus_args = { snap_to = true, nav = "wide" },
					}),
				},
			},
		},
	})
	return t
end

G.FUNCS.your_collection_content_set_page = function(args)
	if not args or not args.cycle_config then
		return
	end
	for j = 1, #G.your_collection do
		for i = #G.your_collection[j].cards, 1, -1 do
			local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
			c:remove()
			c = nil
		end
	end
	local joker_pool = {}
    for k, v in pairs(SMODS.ContentSet.obj_table) do
        if v.set == "Content Set" then
            table.insert(joker_pool, v)
        end
    end
	for i = 1, 5 do
		for j = 1, #G.your_collection do
			local center =
				joker_pool[i + (j - 1) * 5 + (5 * #G.your_collection * (args.cycle_config.current_option - 1))]
			if not center then
				break
			end
			local card = Card(
				G.your_collection[j].T.x + G.your_collection[j].T.w / 2,
				G.your_collection[j].T.y,
				G.CARD_W,
				G.CARD_H,
				G.P_CARDS.empty,
				center
			)
			G.your_collection[j]:emplace(card)
		end
	end
	INIT_COLLECTION_CARD_ALERTS()
end

------------------------------
---- GENERIC COLLECTIONS -----
------------------------------

G.FUNCS.your_collection_generic = function(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = create_UIBox_your_collection_generic(),
	})
end

function create_generic_card(center)
	--todo: make gameset stickers play nicely with resized sprites
	local card = Card(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		center.set == "Blind" and 0.7 * G.CARD_W or center.set == "Tag" and 0.42 * G.CARD_W or G.CARD_W,
		center.set == "Blind" and 0.7 * G.CARD_W or center.set == "Tag" and 0.42 * G.CARD_W or G.CARD_H,
		nil,
		center.set ~= "Seal" and center.set ~= "Sticker" and center or G.P_CENTERS.c_base
	)
	--todo: make this work when the edition is disabled (although it's a good failsafe that it doesn't?)
	if center.set == "Edition" then
		card:set_edition(center.key, true, true)
	end
	if center.set == "Seal" then
		card:set_seal(center.key, true, true)
		card.config.center = cry_deep_copy(card.config.center)
		card.config.center.force_gameset = center.force_gameset
		card.config.center.key = center.key
	end
	if center.set == "Sticker" then
		center:apply(card, true)
		card.config.center = cry_deep_copy(card.config.center)
		card.config.center.force_gameset = center.force_gameset
		card.config.center.key = center.key
	end
	return card
end

-- Hooks for all collection types
local smcp = SMODS.collection_pool
SMODS.collection_pool = function(m)
	if G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id == "Cryptid" then
		-- use SMODS pools instead of vanilla pools, so disabled cards appear
		if m[1] and m[1].set and m[1].set == "Seal" then
			m = {}
			for k, v in pairs(SMODS.Seal.obj_table) do
				if v.mod and v.mod.id == "Cryptid" then
					table.insert(m, v)
				end
			end
		elseif m[1] and m[1].set and m[1].set == "Sticker" then
			m = {}
			for k, v in pairs(SMODS.Sticker.obj_table) do
				if v.mod and v.mod.id == "Cryptid" then
					table.insert(m, v)
				end
			end
		elseif m[1] and m[1].set and G.P_CENTER_POOLS[m[1].set] == m then
			local set = m[1].set
			m = {}
			for k, v in pairs(SMODS.Center.obj_table) do
				if v.set == set and v.mod and v.mod.id == "Cryptid" then
					table.insert(m, v)
				end
			end
		end
		-- Fix blind issues
		for k, v in pairs(m) do
			if v.set == "Blind" and v.mod and v.mod.id == "Cryptid" then
				v.config = {}
			end
		end
	end
	return smcp(m)
end

-- Make Cryptid show all collection boxes (kinda silly)
local mct = modsCollectionTally
function modsCollectionTally(...)
	local t = mct(...)
	if G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id == "Cryptid" then
		return {tally = 10^400, of = 10^400}
	end
	return t
end

-- Make non-center collections show all cards as centers
local uibk = create_UIBox_your_collection_decks
function create_UIBox_your_collection_decks()
	if G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id == "Cryptid" then
		local generic_collection_pool = {}
		for k, v in pairs(SMODS.Center.obj_table) do
			if v.set == "Back" and v.mod and v.mod.id == "Cryptid" then
				table.insert(generic_collection_pool, v)
			end
		end
		return SMODS.card_collection_UIBox(generic_collection_pool, {5,5,5})
	else
		return uibk()
	end
end

local uitag = create_UIBox_your_collection_tags
function create_UIBox_your_collection_tags()
	if G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id == "Cryptid" then
		local generic_collection_pool = {}
		for k, v in pairs(SMODS.Tag.obj_table) do
			if v.set == "Tag" and v.mod and v.mod.id == "Cryptid" then
				table.insert(generic_collection_pool, v)
			end
		end
		return SMODS.card_collection_UIBox(generic_collection_pool, {6,6,6,6}, {
			card_scale = 0.42,
			h_mod = 0.3,
			w_mod = 0.55,
			area_type = "title_2",
			modify_card = function(card, center, i, j)
				card.T.h = card.T.w
			end
		})
	else
		return uitag()
	end
end

local uibl = create_UIBox_your_collection_blinds
function create_UIBox_your_collection_blinds()
	if G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id == "Cryptid" then
		local generic_collection_pool = {}
		for k, v in pairs(SMODS.Blind.obj_table) do
			if v.set == "Blind" and v.mod and v.mod.id == "Cryptid" then
				table.insert(generic_collection_pool, v)
			end
		end
		return SMODS.card_collection_UIBox(generic_collection_pool, {5,5,5,5,5}, {
			card_scale = 0.70,
			h_mod = 0.45,
			w_mod = 0.70,
			area_type = "title_2",
			modify_card = function(card, center, i, j)
				card.T.h = card.T.w
			end
		})
	else
		return uibl()
	end
end

local uisl = create_UIBox_your_collection_seals
function create_UIBox_your_collection_seals()
	if G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id == "Cryptid" then
		return SMODS.card_collection_UIBox(G.P_CENTER_POOLS.Seal, {5,5}, {
			snap_back = true,
			infotip = localize('ml_edition_seal_enhancement_explanation'),
			hide_single_page = true,
			collapse_single_page = true,
			center = 'c_base',
			h_mod = 1.03,
			modify_card = function(card, center)
				card:set_seal(center.key, true)
				-- Make disabled UI appear
				card.config.center = cry_deep_copy(card.config.center)
				card.config.center.key = center.key
			end,
		})
	else
		return uisl()
	end
end

local uist = create_UIBox_your_collection_stickers
function create_UIBox_your_collection_stickers()
	if G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id == "Cryptid" then
		return SMODS.card_collection_UIBox(SMODS.Stickers, {5,5}, {
			snap_back = true,
			hide_single_page = true,
			collapse_single_page = true,
			center = 'c_base',
			h_mod = 1.03,
			back_func = 'your_collection_other_gameobjects',
			modify_card = function(card, center)
				card.ignore_pinned = true
				center:apply(card, true)
				-- Make disabled UI appear
				card.config.center = cry_deep_copy(card.config.center)
				card.config.center.key = center.key
			end,
		})
	else
		return uist()
	end
end

--hacky fix to get animated atlases visible for centers
local smai = SMODS.Atlas.inject
SMODS.Atlas.inject = function(self)
	smai(self)
	if self.atlas_table ~= 'ASSET_ATLAS' then
		G.ASSET_ATLAS[self.key_noloc or self.key] = G[self.atlas_table][self.key_noloc or self.key]
	end
end