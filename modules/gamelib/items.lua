ItemsDatabase = {}

ItemsDatabase.rarityColors = {
    ["yellow"] = TextColors.yellow,
    ["purple"] = TextColors.purple,
    ["blue"] = TextColors.blue,
    ["green"] = TextColors.green,
    ["grey"] = TextColors.grey,
}

local function getColorForValue(value)
    if value >= 1000000 then
        return "yellow"
    elseif value >= 100000 then
        return "purple"
    elseif value >= 10000 then
        return "blue"
    elseif value >= 1000 then
        return "green"
    elseif value >= 50 then
        return "grey"
    else
        return "white"
    end
end

local function clipfunction(value)
    if value >= 1000000 then
        return "128 0 32 32"
    elseif value >= 100000 then
        return "96 0 32 32"
    elseif value >= 10000 then
        return "64 0 32 32"
    elseif value >= 1000 then
        return "32 0 32 32"
    elseif value >= 50 then
        return "0 0 32 32"
    end
    return ""
end

function ItemsDatabase.setRarityItem(widget, item, style)
    if not g_game.getFeature(GameColorizedLootValue) or not widget then
        return
    end
    local frameOption = modules.client_options.getOption('framesRarity')
    if frameOption == "none" then
        return
    end
    local imagePath = '/images/ui/item'
    local clip = nil
    if item then
        local price = type(item) == "number" and item or (item and item:getMeanPrice()) or 0
        local itemRarity = getColorForValue(price)
        if itemRarity then
            clip = clipfunction(price)
            if clip ~= "" then
                if frameOption == "frames" then
                    imagePath = "/images/ui/rarity_frames"
                elseif frameOption == "corners" then
                    imagePath = "/images/ui/containerslot-coloredges"
                end
            else
                clip = nil
            end
        end
    end
    widget:setImageClip(clip)
    widget:setImageSource(imagePath)
    if style then
        widget:setStyle(style)
    end
end

function ItemsDatabase.getColorForRarity(rarity)
    return ItemsDatabase.rarityColors[rarity] or TextColors.white
end

function ItemsDatabase.setColorLootMessage(text)
    local function coloringLootName(match)
        local id, itemName = match:match("(%d+)|(.+)")
        local itemInfo = g_things.getThingType(tonumber(id), ThingCategoryItem):getMeanPrice()
        if itemInfo then
            local color = ItemsDatabase.getColorForRarity(getColorForValue(itemInfo))
            return "{" .. itemName .. ", " .. color .. "}"
        else
            return itemName
        end
    end
    return text:gsub("{(.-)}", coloringLootName)
end

function ItemsDatabase.setTier(widget, item)
    if not g_game.getFeature(GameThingUpgradeClassification) or not widget then
        return
    end
    local tier = type(item) == "number" and item or (item and item:getTier()) or 0
    if tier and tier > 0 then
        local xOffset = (math.min(math.max(tier, 1), 10) - 1) * 9
        widget.tier:setImageClip({
            x = xOffset,
            y = 0,
            width = 10,
            height = 9
        })
        widget.tier:setVisible(true)
    else
        widget.tier:setVisible(false)
    end
end

-- Per-tier color for the proficiency mini bar (tier 0..maxTier).
local proficiencyTierColors = {
    [0] = "#7d7d7d",
    [1] = "#9FD49F",
    [2] = "#67C7E2",
    [3] = "#5B8DEF",
    [4] = "#A66CFF",
    [5] = "#E2A85B",
    [6] = "#E2675B",
    [7] = "#FFD17A",
}

-- Draws a thin proficiency tier bar at the bottom of an item widget.
-- Reads tier data from the global `ProficiencyTiers` table (clientId -> {t,m,p}),
-- populated by the game_itemproficiency module.
function ItemsDatabase.setProficiency(widget, item)
    if not widget or not widget.proficiency then
        return
    end

    local bar = widget.proficiency
    local mod = modules.game_itemproficiency
    local tiers = mod and mod.tiers
    if not tiers then
        bar:setVisible(false)
        return
    end

    local clientId = type(item) == "number" and item or (item and item:getId()) or 0
    local info = clientId > 0 and tiers[tostring(clientId)] or nil
    if not info then
        bar:setVisible(false)
        return
    end

    local tier = tonumber(info.t) or 0
    local maxTier = tonumber(info.m) or 7
    local pct = tonumber(info.p) or 0
    if tier >= maxTier then
        pct = 100
    end

    bar:setPercent(pct)
    bar:setBackgroundColor("#4FC3F7")
    bar:setVisible(true)
end

function ItemsDatabase.setCharges(widget, item, style)
    if not g_game.getFeature(GameThingCounter) or not widget then
        return
    end

    if item and item:getCharges() > 0 then
        widget.charges:setText(item:getCharges())
    else
        widget.charges:setText("")
    end

    if style then
        widget:setStyle(style)
    end
end


function ItemsDatabase.setDuration(widget, item, style)
    if not g_game.getFeature(GameThingClock) or not widget then
        return
    end

    if item and item:getDurationTime() > 0 then
            local durationTimeLeft = item:getDurationTime()
            widget.duration:setText(string.format("%dm%02d", durationTimeLeft / 60, durationTimeLeft % 60))
    else
        widget.duration:setText("")
    end

    if style then
        widget:setStyle(style)
    end
end
