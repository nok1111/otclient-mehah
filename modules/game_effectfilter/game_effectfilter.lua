-- Magic effect IDs rendered BELOW creatures instead of on top of them.
-- The actual filtering happens natively in C++ (parseMagicEffect ->
-- Effect::setDrawBelow -> Tile::m_effectsBelow); this module only
-- declares which effect IDs belong to the below-creatures list.

local GROUND_EFFECT_IDS = {
     [1389] = true,
     [1722] = true,
}

function init()
    for effectId in pairs(GROUND_EFFECT_IDS) do
        g_map.addBelowEffectId(effectId)
    end
end

function terminate()
    g_map.clearBelowEffectIds()
end
