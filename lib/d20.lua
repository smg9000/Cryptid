-- d20.lua - APIs for D20 content

-- Currently this is very empty since D20 hasn't been fully implemented yet, but it should have a lot more later.

--Will be moved to D20 file when that gets added
function roll(dice, seed)
    if type(dice.amount) == "table" then
        return roll({
            amount = roll(dice.amount, seed),
            sides = dice.sides
        })
    else
        if type(dice.sides) == "table" then
            return roll({
                amount = dice.amount,
                sides = roll(dice.sides, seed)
            })
        else
            local total = 0
            for i = 1, dice.amount do
                total = total + math.min(1 + math.floor(pseudorandom(seed) * (dice.sides)), dice.sides)
            end
            return total
        end
    end
end
