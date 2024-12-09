local d20 = {
	object_type = "Joker",
	key = "d20",
	pos = { x = 0, y = 0 },
	rarity = 3,
	cost = 10,
	order = 132,
	atlas = "atlasd20",
	config = {extra = {rollmult = 0}},
	immutable = true,
	no_dbl = true,
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.rollmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.before and not context.after then
			--todo: check if duplicates of event are already started/finished
			card.ability.extra.rollmult = roll_dice("cry_d20", 1, 20, {ignore_value = card.ability.extra.rollmult})
			SMODS.Events["ev_cry_choco"..card.ability.extra.roll]:start()
			return {
				message = tostring(card.ability.extra.roll),
				colour = G.C.GREEN
			}
		end
	end,
}
