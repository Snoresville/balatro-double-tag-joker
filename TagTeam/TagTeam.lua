--- STEAMODDED HEADER
--- MOD_NAME: Tag Team
--- MOD_ID: SnoresvilleTagTeam
--- MOD_AUTHOR: [Snoresville]
--- MOD_DESCRIPTION: A Joker that prints double tags
--- BADGE_COLOUR: A020F0

----------------------------------------------
------------MOD CODE -------------------------
local MOD_ID = "SnoresvilleTagTeam"
local MOD_INIT_MESSAGE = "joker joker"

local function init_modded_jokers()
    local jokers = require(SMODS.findModByID(MOD_ID).path.."/src/jokers")
    local joker_objects = {}

    for joker_id, joker_def in pairs(jokers) do
        joker_objects[joker_id] = SMODS.Joker:new(
            joker_def.name,
            joker_def.slug,
            joker_def.config,
            joker_def.spritePos,
            joker_def.loc_txt,
            joker_def.rarity,
            joker_def.cost,
            joker_def.unlocked,
            joker_def.discovered,
            joker_def.blueprint_compat,
            joker_def.eternal_compat
        )
    end

    -- Order the jokers by rarity
    local joker_sorted = {}

    for joker_name, joker_data in pairs(joker_objects) do
        local j = {}
        j.name = joker_data.name
        j.rarity = joker_data.rarity
        j.slug = joker_name
        table.insert(joker_sorted, j)
    end

    table.sort(joker_sorted, function(a, b)
        if a.rarity ~= b.rarity then
            return a.rarity < b.rarity
        end
        return a.name < b.name
    end)

    for _, joker_data in ipairs(joker_sorted) do
        local name = joker_data.slug
        local v = joker_objects[name]

        v.slug = "j_" .. name
        v.mod = MOD_ID
        v:register()

        -- https://github.com/Steamopollys/Steamodded/wiki/Creating-new-game-objects#creating-jokers
        SMODS.Sprite:new(v.slug, SMODS.findModByID(MOD_ID).path, v.slug..".png", 71, 95, "asset_atli")
        :register()
    end

    for joker_id, joker_def in pairs(jokers) do
        local joker_slug = "j_"..joker_id
        for function_name, function_call in pairs(joker_def.functions) do
            SMODS.Jokers[joker_slug][function_name] = function_call
        end
    end
end

SMODS.INIT[MOD_ID] = function ()
    sendDebugMessage(MOD_INIT_MESSAGE)
    init_localization()
    init_modded_jokers()
end