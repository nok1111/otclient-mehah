function postostring(pos)
    return pos.x .. ' ' .. pos.y .. ' ' .. pos.z
end

function dirtostring(dir)
    for k, v in pairs(Directions) do
        if v == dir then
            return k
        end
    end
end

function comma_value(n)
    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end

function isInArray(t, v, c)
    v = (c ~= nil and string.lower(v)) or v
    if type(t) == "table" and v ~= nil then
        for key, value in pairs(t) do
            value = (c ~= nil and string.lower(value)) or value
            if v == value then
                return true
            end
        end
    end
    return false
end



common = {
    5799, 2694, 10563, 13506, 5786, 2109, 8762, 32425, 6103, 5809, 31796, 
    32874, 13633, 5897, 10574, 10610, 12413, 5877, 5948, 26157, 22473, 32465, 
    27756, 11199, 18421, 10608, 37380, 37381, 6091, 11218, 11229, 37416, 31788, --quest / task related
    31789, 31790, 31791, 31763, 27087, 22727, 22728, 28995, 12470, 34500, 34501, 
    34502, 22609, 22614, 18221, 27057, 5804, 38131, 38130, 38136, 38115, 38116, 
    38137, 38138, 38132, 20127, 20128, 20129, 29045, 37420, 19742, 11224, 5802, 
    8300, 5883, 11242, 2359, 28665, 5879, 24122, 22646, 26226, 37426, 36401, 
    36400, 1962
}
rare = {
    10016, 2498, 5741, 11302
}
epic = {
    2493, 12645, 9778, 2502, 34002, 26143, 27756, 34370, 34363, 39197, 39198, 39199, 39200, 39201, 39202, 39203, 39204, 39205, 39206, 39207, 39208, 39209, 39210, 39211, 39212, 39213, 39214, 39215, 39216, 39217, 39218, 39219, 39220

}
legendary = {
    2672, 2685, 2691, 2692, 2792, 5943, 6536, 8838, 9971, 11429, 
    21401, 29020, 32702, 32703, 32704, 33202, 33203, 35337, 35342, 
    35343, 35372, 35374, 35375, 35376, 35377, 35378, 35420, 35421,  --crafting mats related
    35422, 35423, 35425, 35426, 35427, 35428, 35429, 35439, 35440, 
    35442, 35443, 35480, 35481, 35483, 35779, 35788, 35789, 36837, 
    36839, 37127, 37134, 37135, 37136, 37431, 38148, 38174, 38195, 
    38197, 38199, 38201, 38203, 38701, 39195

}

rare_inArray = {fromId = 38574, toId = 38691} --bluepints
rare_inArray2 = {fromId = 37860, toId = 37985} -- eggs
rare_inArray3 = {fromId = 38147, toId = 38235} --enchants

-- Define isInRarityArray function
function isInRarityArray(itemid, rarityArray)
    local inRange = itemid >= rarityArray.fromId and itemid <= rarityArray.toId
    --print("Checking Range: ", itemid, rarityArray.fromId, rarityArray.toId, inRange)  -- Debug print
    return inRange
end

function isInRarityArrayById(itemid, rangeArray)
    return itemid >= rangeArray.fromId and itemid <= rangeArray.toId
end

function getItemRarity(itemid)
    local rarity = "Normal"

    if isInArray(common, itemid) then
        rarity = "Quests"
    elseif isInArray(rare, itemid) then
        rarity = "Rare"
    elseif isInArray(epic, itemid) then
        rarity = "Cosmetic"
    elseif isInArray(legendary, itemid) then
        rarity = "Material"
    elseif isInRarityArrayById(itemid, rare_inArray) then
        rarity = "Blueprints"
    elseif isInRarityArrayById(itemid, rare_inArray2) then
        rarity = "Pet"
    elseif isInRarityArrayById(itemid, rare_inArray3) then
        rarity = "Enchants"
    end

    return rarity
end
    
-- Correct usage of variable names for consistency
function getItemRarityColor(item)       
    if not item then 
        return "none"
    else
        local itemID = item:getServerId()  -- Ensure this method exists and correctly retrieves the ID
        if isInArray(common, itemID) then
            newColour = "#059c2d"
        elseif isInArray(rare, itemID) or isInRarityArray(itemID, rare_inArray) or isInRarityArray(itemID, rare_inArray2) or isInRarityArray(itemID, rare_inArray3) then 
            newColour = "#3561e6"   
        elseif isInArray(epic, itemID) then 
            newColour = "#02e6f2"
        elseif isInArray(legendary, itemID) then 
            newColour = "#E8F1F2"           
        else
            newColour = "none"
        end
        return newColour
    end 
end
