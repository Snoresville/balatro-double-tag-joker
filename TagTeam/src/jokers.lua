local jokers = {
    snoresville_tag_team = {
        name = "snoresville_tag_team", -- If I put "Seeing Double" here, Balatro is going to kill me
        slug = "snoresville_tag_team",
        config = {},
        spritePos = {x = 0, y = 0},
        loc_txt = {
            name = "Tag Team",
            text = {
                "Gain a {C:attention,T:tag_double}Double Tag",
                "for each {C:attention}Pair{} contained",
                "in a played hand."
            }
        },
        rarity = 2,
        cost = 8,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        functions = {
            loc_def = function(self)
                return {}
            end,
            calculate = function(self, context)
                if context.cardarea == G.jokers and context.after and context.full_hand then
                    local card_pairs = {}
                    for i = 1, #context.full_hand do
                        local card = context.full_hand[i]
                        if card.ability.effect ~= 'Stone Card' then
                            card_pairs[card.base.value] = (card_pairs[card.base.value] or 0) + 1
                        end
                    end

                    for card_face, card_freq in pairs(card_pairs) do
                        for _ = 2, card_freq, 2 do
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.5,
                                func = (function()
                                    card_eval_status_text(self, 'extra', nil, nil, nil, {
                                        message = "Double Tag!",
                                        colour = G.C.GREEN,
                                        instant = true
                                    })

                                    add_tag(Tag('tag_double'))
                                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                                    return true
                                end)
                            }))
                        end
                    end
                end
            end
        }
    }
}

return jokers