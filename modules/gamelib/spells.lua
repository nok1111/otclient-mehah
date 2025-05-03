SpelllistSettings = {
  ['Default'] = {
    iconFile = '/images/game/spells/defaultspells',
    iconSize = {width = 32, height = 32},
    spellListWidth = 245,
    spellWindowWidth = 550,
    spellOrder = {
    --dragon knight
        'Rend', 
        'Earthquake', 
        'Fire Within', 
        'Brutal Swing', 
        'Charge', 
        'Dragon Aura', 
        'Challenging Spear', 
        'Whirlwind', 
        'Dragon Shrine', 
        'Roar', 
        'Phoenix Wrath', 
        --templar
        'Divine Clock', 
        'Penitence', 
        'Holy Ground', 
        'Sacred Ground',
        'Crusader Strike', 
        'Divine Storm',
        'Relieve Friend',
        'Exorcism', 
        'Divine Force', 
        'Smite', 
        'Light Beam', 
        'Summon Guardian of Light',
        'Kings Blessings',
        --Magician
        'Living Bomb', 
        'Energy Blast', 
        'Fire Blast', 
        'Frost Blast', 
        'Elemental Blast', 
        'Teleport', 
        'Mana Distortion', 
        'Mana Flow', 
        'Hand of God', 
        'Frost Wave', 
        'Water Typhoon', 
        'Arcane Missiles', 
        'Blizzard',
        
        --warlock
        'Zombie Wall', 
        'Curse', 
        'Fear', 
        'Shadow Strike', 
        'Summon Shadow Seeker', 
        'Blood Pact', 
        'Party Vitality', 
        'Summon Abomination', 
        'Summon Heket', 
        'Blood Wall', 
        'Dark Plague', 
        'Astral Revival',
        'Soul Rain',
        'Void Creep',
        'Void Recall',  
        
        --nightblade
        'Stealth', 
        'Mutilate', 
        'Backstab', 
        'Dark Ambush',
        'Shadow Hunt',
        'Shadowstep',       
        'Fan of Knives', 
        'Shadow Form', 
        'Dark Rupture', 
        'Void Execution', 
        'Blood Blades', 
        
        --stellar
        'Earth Call',
        'Regrowth',
        'Aery Wrath',
        'Star Fall',
        'Falling Star',
        'Rain Fall', 
        'Heal Party',
        'Lunar Beam',
        'Aery Dance',
        'Earth Dance',
        'Full Moon',
        
        --soul weave
        'Soul Fists',
        'Soul Barrage',
        'Anger Release',
        'Spectral Wave',
        'Underworld Gaze',
        'Hollow Blade',
        'Veil of Anguish',
        'Absolute Denial',
        'Soul Link',
        'Void Slumber',
        'Drain Soul',
        
        --Druid
        'Terra Strike',
        'Living Seeds',
        'Life Bloom',
        'Rejuvenation',
        'Seed Germination',
        'Travel Form',
        'Carnivorous Vile',
        'living ground',
        'Thorns',
        'Peircing Wave',
        'Bear Form',
        'Bless of the Forest',
        'Wrath of Nature',
        'Soul Form',
        
        --Light Dancer
        'Charged Strike',
        'Static Charge',
        'Light Dash',
        'Lightning Orb',
        'Fission Break',
        'Aereal Shock',
        'Lightning Spear',
        'Overcharge',
        'Magnetic Field',
        'Thunderstorm',
        
        --Archer
        'Flaming Shot',
        'Beer Barrel',
        'Explosive Shots',
        'Wind Barrel',
        'Condemn Shot',
        'Nail Bomb',
        'Healing Barrel',
        'Arrow Rain',
        'Frost Barrel',
        'Arrow Barrage', 
        'Aspect Mastery',
        
        --healing spells
        'Minor Heal', 
        'Strong Heal', 
        'Great Heal', 
        
        
        --mastery
        'Shield Wall', 
        'Protection', 
        'Shield Bash',       
        'Grow',
        'Hells Core', 
        'Quick Chains',
        'Magic Shield', 
        'Blood Rage',
        --etc
        'Find Person', 
        'Food', 
        'Magic Rope',  
        'Heal Friend', 
        'Haste', 
        
        'Invisibility', 
        'Levitate', 
        'Light', 
        'Protect Party', 
        'Mass Healing', 
        'Strong Haste',
        'Taunt',
        'Kings Call'



    }
  }
}

local VocationMapping = {
    [1] = "None",
    [2] = "Druid",
    [3] = "Sorcerer",
    [4] = "Paladin",
    [5] = "Knight",
    [6] = "Master Sorcerer",
    [7] = "Elder Druid",
    [8] = "Royal Paladin",
    [9] = "Elite Knight"
}

local spellsByVocation = {
    -- Dragon Knight (5,9)
    [5] = {'Rend', 'Earthquake', 'Fire Within', 'Brutal Swing', 'Charge', 'Dragon Aura', 
           'Challenging Spear', 'Whirlwind', 'Dragon Shrine', 'Roar', 'Phoenix Wrath'},
    [9] = {'Rend', 'Earthquake', 'Fire Within', 'Brutal Swing', 'Charge', 'Dragon Aura', 
           'Challenging Spear', 'Whirlwind', 'Dragon Shrine', 'Roar', 'Phoenix Wrath'},
    
    -- Templar (4,8)
    [4] = {'Divine Clock', 'Penitence', 'Holy Ground', 'Sacred Ground', 'Crusader Strike', 
           'Divine Storm', 'Relieve Friend', 'Exorcism', 'Divine Force', 'Smite', 
           'Light Beam', 'Summon Guardian of Light', 'Kings Blessings'},
    [8] = {'Divine Clock', 'Penitence', 'Holy Ground', 'Sacred Ground', 'Crusader Strike', 
           'Divine Storm', 'Relieve Friend', 'Exorcism', 'Divine Force', 'Smite', 
           'Light Beam', 'Summon Guardian of Light', 'Kings Blessings'},
    
    -- Magician (2,3,6,7)
    [2] = {'Living Bomb', 'Energy Blast', 'Fire Blast', 'Frost Blast', 'Elemental Blast', 
           'Teleport', 'Mana Distortion', 'Mana Flow', 'Hand of God', 'Frost Wave', 
           'Water Typhoon', 'Arcane Missiles', 'Blizzard'},
    [3] = {'Living Bomb', 'Energy Blast', 'Fire Blast', 'Frost Blast', 'Elemental Blast', 
           'Teleport', 'Mana Distortion', 'Mana Flow', 'Hand of God', 'Frost Wave', 
           'Water Typhoon', 'Arcane Missiles', 'Blizzard'},
    [6] = {'Living Bomb', 'Energy Blast', 'Fire Blast', 'Frost Blast', 'Elemental Blast', 
           'Teleport', 'Mana Distortion', 'Mana Flow', 'Hand of God', 'Frost Wave', 
           'Water Typhoon', 'Arcane Missiles', 'Blizzard'},
    [7] = {'Living Bomb', 'Energy Blast', 'Fire Blast', 'Frost Blast', 'Elemental Blast', 
           'Teleport', 'Mana Distortion', 'Mana Flow', 'Hand of God', 'Frost Wave', 
           'Water Typhoon', 'Arcane Missiles', 'Blizzard'}
}

function getSpellsForVocation(vocationId)
    return spellsByVocation[vocationId] or {}
end

function getVocationName(vocationId)
    return VocationMapping[vocationId] or "Unknown"
end

SpellInfo = {
  ['Default'] = {
  --DRAGON Knight
    ['Rend'] =                     {id = 1, words = 'rend',                exhaustion = 3000, premium = false, type = 'Instant', icon = 'bloodaxe',        mana = 20,     level = 8,  soul = 0, group = {[1] = 1000},                 parameter = false, vocations = {4}, description = 'Deals physical damage to the target and all sorrounding enemies. [Weapon base attack Damage, Melee Skill]'},
    ['Earthquake'] =               {id = 2,  words = 'Earthquake',            exhaustion = 20000, premium = false, type = 'Instant', icon = 'fireearth',    mana = 300,    level = 100,  soul = 0, group = {[1] = 1000},                parameter = false, vocations = {4}, description = 'deals aoe damage and stun all enemies reached. [Weapon Damage, Melee Skill, MAGIC LEVEL]'},
    ['Fire Within'] =              {id = 3,  words = 'Fire Within',          exhaustion = 6000, premium = false, type = 'Instant', icon = 'firesoul',   mana = 45,     level = 70,  soul = 0, group = {[1] = 1000},              parameter = false, vocations = {4}, description = 'expels fire waves that deal fire damage arround the caster. [MxHP, MAGIC LEVEL]'},
    ['Brutal Swing'] =             {id = 4,  words = 'Brutal Swing',             exhaustion = 6000, premium = false, type = 'Instant', icon = 'bloodaxe',  mana = 55,     level = 18, soul = 0, group = {[1] = 1000},                 parameter = false, vocations = {4}, description = 'deals a brutal strike based on the direction and weapon used. heals the caster based on the damage done. [Weapon base attack Damage, Melee Skill]'},
    ['Charge'] =                   {id = 5,  words = 'Charge',             exhaustion = 15000, premium = false, type = 'Instant', icon = 'charge',          mana = 70,     level = 40, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {4}, description = 'charge at a high speed into your target dealing physical damage upon landing. [Weapon Damage, Melee Skill]'},
    ['Dragon Aura'] =              {id = 6,  words = 'Dragon Aura',         exhaustion = 20000, premium = false, type = 'Instant', icon = 'dragonstance',   mana = 150,    level = 46, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {4}, description = 'the caster gains the dragons aura dealing fire damage over time to all enemies near the player. caster will also heal on every orb rotation. [MxHp, MAGIC LEVEL]'},
    ['Challenging Spear'] =        {id = 7, words = 'Challenging Spear',          exhaustion = 5000, premium = false, type = 'Instant', icon = 'pending', mana = 30,     level = 20, soul = 0, group = {[3] = 1000},                 parameter = false, vocations = {4}, description = 'throw a spear at the target dealing damage and taunting it for a short duration. [Weapon base attack Damage, Melee Skill]'},
    ['Whirlwind'] =                {id = 8,  words = 'whirlwind',             exhaustion = 5000, premium = false, type = 'Instant', icon = 'firetornado', mana = 85,    level = 30, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {4}, description = 'creates a fire whirlwind around the caster. affected targets will also burn. [MxHp, MAGIC LEVEL]'},
    ['Dragon Shrine'] =            {id = 9,  words = 'Dragon Shrine',        exhaustion = 20000, premium = false, type = 'Instant', icon = 'dragonshrine', mana = 325,     level = 150, soul = 0, group = {[3] = 1000},              parameter = false, vocations = {4}, description = 'pull all enemies around the target dealing a moderate amount of damage. [MAGIC LEVEL]'},
    ['Roar'] =                     {id = 10,  words = 'Roar',            exhaustion = 8000, premium = false, type = 'Instant', icon = 'roar',               mana = 20,     level = 60, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {4}, description = 'repels all enemies surrounding the target, if an enemy hits a wall it will get stunned. [Weapon Damage, Melee Skill]'},
    ['Phoenix Wrath'] =            {id = 11,  words = 'Phoenix Wrath',            exhaustion = 17000, premium = false, type = 'Instant', icon = 'dragonbreath',      mana = 115,     level = 125, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {4}, description = 'Call the phoenix breath dealing fire damage to all enemies in front the caster direction. [MAGIC LEVEL]'},
    
    --TEMPLAR
    ['Divine Clock'] =             {id = 20,  words = 'Divine Clock',             exhaustion = 20000, premium = false, type = 'Instant', icon = 'divineclock',  mana = 200,    level = 125, soul = 1, group = {[1] = 1000},                parameter = false, vocations = {2}, description = 'brings the hevenly hourglass dealing high amount of holy damage in a wide area. [MAGIC LEVEL]'},
    ['Penitence'] =                {id = 21,  words = 'Penitence',             exhaustion = 7000, premium = false, type = 'Instant', icon = 'penitence',       mana = 60,     level = 25, soul = 1, group = {[1] = 1000},                parameter = false, vocations = {2}, description = 'hits multiple enemies and taunt them for a few seconds. [MAGIC LEVEL]'},
    ['Holy Ground'] =              {id = 22,   words = 'Holy Ground',             exhaustion = 15000, premium = false, type = 'Instant', icon = 'holyarea',     mana = 75,    level = 46, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {2}, description = 'place a holy ground beneat the player dealing holy damage over time to all enemies inside. (shares cooldown with sacred ground) [MAGIC LEVEL]'},
    ['Sacred Ground'] =            {id = 17, words = 'Sacred Ground',           exhaustion = 30000, premium = false, type = 'Instant', icon = 'sacredarea',     mana = 75,    level = 40, soul = 0, group = {[2] = 1000},                parameter = false, vocations = {2}, description = 'place a sacred ground healling all players inside the area. (shares cooldown with holy ground) [MAGIC LEVEL]'},
    ['Crusader Strike'] =          {id = 23,  words = 'Crusader Strike',        exhaustion = 6000, premium = false, type = 'Instant', icon = 'holysword',      mana = 50,     level = 18, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {2}, description = 'deals physical damage at close range. [Weapon Damage, Melee Skill]'},
    ['Divine Storm'] =             {id = 24,  words = 'Divine Storm',            exhaustion = 15000, premium = false, type = 'Instant', icon = 'divineclock', mana = 150,    level = 70, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {2},   description = 'Deals aoe damage to all nearby enemies and heal the player for an small amount. [Weapon Damage, Melee Skill, MAGIC LEVEL]'},
    ['Relieve Friend'] =           {id = 25,  words = 'Relieve Friend',           exhaustion = 3000, premium = false, type = 'Instant', icon = 'lighthealing', mana = 85,     level = 60, soul = 0, group = {[2] = 2000},                parameter = true, vocations = {2}, description = 'heals an ally (ex. heal friend "player"). [MAGIC LEVEL]'},
    ['Exorcism'] =                 {id = 26,  words = 'Exorcism',            exhaustion = 15000, premium = false, type = 'Instant', icon = 'holyarea',          mana = 125,     level = 100, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {2},  description = 'shoot holy damage to all nearby enemies. [MxHP, MAGIC LEVEL]'},
    ['Divine Force'] =             {id = 27, words = 'Divine Force',             exhaustion = 15000, premium = false, type = 'Instant', icon = 'holysmite',     mana = 125,     level = 80, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {2},  description = 'use light force to bring a targeted enemy near the player. [MAGIC LEVEL]'},
    ['Smite'] =                    {id = 28,  words = 'Smite',        exhaustion = 4100, premium = false, type = 'Instant', icon = 'smite',                    mana = 20,     level = 8,  soul = 0, group = {[1] = 1000},                parameter = false, vocations = {2},     description = 'smite the player dealing holy damage. [Weapon Damage, Melee Skill, MAGIC LEVEL]'},
    ['Light Beam'] =               {id = 29,  words = 'Light Beam',        exhaustion = 12000, premium = false, type = 'Instant', icon = 'holyslash',           mana = 95,     level = 30, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {2},     description = 'deals holy damage multiple times based on the players direction. [MAGIC LEVEL]'},
    ['Summon Guardian of Light'] = {id = 30, words = 'Summon Guardian',             exhaustion = 100000, premium = false, type = 'Instant', icon = 'elf',        mana = 250,    level = 150, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {2},  description = 'summons a seraphine the heals the summoner and random party members. [MAGIC LEVEL]'},
    ['Kings Blessings'] =          {id = 31, words = 'Kings Blessing',             exhaustion = 1000, premium = false, type = 'Instant', icon = 'holycross',        mana = 50,    level = 60, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {2},  description = 'Bless the player and all party members by increasing all offensive skills by 10% for 20 minutes.'},
    
    --magician
    ['Living Bomb'] =              {id = 40, words = 'Living Bomb',        exhaustion = 17000, premium = false, type = 'Instant', icon = 'firesoul',       mana = 200,     level = 150, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {1}, description = 'ignite the target dealing magic damage. after a few seconds the fire within the target will explode expreading the same effect on nearby enemies. [MAGIC LEVEL]'},
    ['Energy Blast'] =             {id = 41,   words = 'Energy Blast',      exhaustion = 4000, premium = false, type = 'Instant', icon = 'energybeam1',   mana = 25,      level = 10, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {1}, description = 'shoots an energy attack dealing magic damage and restoring 4% of the users total mana. [MAGIC LEVEL]'},
    ['Fire Blast'] =               {id = 42,  words = 'Fire Blast',         exhaustion = 3000, premium = false, type = 'Instant', icon = 'fireshot',      mana = 40,      level = 8, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {1}, description = 'shoots a fire ball that explodes upon reaching the target dealing magic damage. [MAGIC LEVEL]'},
    ['Frost Blast'] =              {id = 44, words = 'Frost Blast',         exhaustion = 3000, premium = false, type = 'Instant', icon = 'frostmissile',  mana = 45,      level = 15, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {1}, description = 'shoots multiple ice attacks at the same time dealing magic damage. [MAGIC LEVEL]'},
    ['Elemental Blast'] =          {id = 43,  words = 'Elemental Blast',   exhaustion = 10000, premium = false, type = 'Instant', icon = 'elementalblast', mana = 200,     level = 150, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {1}, description = 'gather all elements into one powerfull attack. [MAGIC LEVEL]'},
    ['Teleport'] =                 {id = 52,  words = 'Teleport',           exhaustion = 12000, premium = false, type = 'Instant', icon = 'travel',       mana = 150,     level = 60, soul = 0, group = {[3] = 3000},                parameter = false, vocations = {1}, description = 'teleports the caster few tiles forward based on directing.'},
    ['Mana Distortion'] =          {id = 46,   words = 'Mana Distortion',   exhaustion = 120000, premium = false, type = 'Instant', icon = 'electrticity',  mana = 0,       level = 80, soul = 0, group = {[2] = 1000},                parameter = false, vocations = {1}, description = 'distort your mana to create a magic field in the ground that gives mana and magic power.'},
    ['Mana Flow'] =                {id = 47, words = 'Mana Flow',           exhaustion = 25000, premium = false, type = 'Instant', icon = 'bluehand',      mana = 0,       level = 40, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {1}, description = 'restores players mana by percentage in a short amount of time.'},
    ['Hand of God'] =              {id = 48,  words = 'Hand of God',        exhaustion = 5000, premium = false, type = 'Instant', icon = 'firefist',      mana = 75,     level = 30, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {1}, description = 'summon the fire gods hand to deal massive fire damage to the target and enemies nearby. [MAGIC LEVEL]'},
    ['Frost Wave'] =               {id = 49, words = 'Frost Wave',          exhaustion = 13000, premium = false, type = 'Instant', icon = 'frostice',      mana = 155,     level = 70, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {1}, description = 'deals high amount of ice damage and freezes all the enemies for 4 seconds. [MAGIC LEVEL]'},
    ['Water Typhoon'] =            {id = 50,  words = 'Water Typhoon',      exhaustion = 25000, premium = false, type = 'Instant', icon = 'tornado',      mana = 250,    level = 100, soul = 0, group = {[1] = 5000},                parameter = false, vocations = {1}, description = 'take the form of a typhoon dealing water damage to all enemies around the caster. [MAGIC LEVEL]'},
    ['Arcane Missiles'] =          {id = 51,   words = 'Arcane Missiles',   exhaustion = 6000, premium = false, type = 'Instant', icon = 'energymissiles',  mana = 65,      level = 18, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {1}, description = 'shoots arcane missiles dealing magic damage. the amount of missilis increases with your total magic level. [MAGIC LEVEL]'},
    ['Blizzard'] =                {id = 53,  words = 'Blizzard',        exhaustion = 15000, premium = false, type = 'Instant', icon = 'frostaura',        mana = 150,     level = 46, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {1}, description = 'deals elemental damage to all nearby enemies around the selected target. [MAGIC LEVEL]'},
    ['Hells Core'] =               {id = 304, words = 'Hells Core',         exhaustion = 18000, premium = false, type = 'Instant', icon = 'meteor',          mana = 350,     level = 125,   soul = 0,       group = {[1] = 1000},     parameter = false, vocations = {1}, description = 'Call down meteors at your position dealing damage to all nearbt enemies. [MAGIC LEVEL]'}, 
   
    -- warlock
    ['Void Recall'] =              {id = 60, words = 'void recall',    exhaustion = 15000, premium = false, type = 'Instant', icon = 'ghost',        mana = 250,     level = 115, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {5}, description = 'summon skeletons that fight at your side Max: 4.'},
    ['Zombie Wall'] =              {id = 61, words = 'Zombie Wall',    exhaustion = 20000, premium = false, type = 'Instant', icon = 'zombiewall',   mana = 50,     level = 40, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {5}, description = 'place a undead wall in front of the caster. '},
    ['Curse'] =                    {id = 62,  words = 'Curse',         exhaustion = 2000, premium = false, type = 'Instant', icon = 'shadoweye',             mana = 35,     level = 8, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {5}, description = 'curse the target dealing death damage over time. [MAGIC LEVEL]'},
    ['Fear'] =                     {id = 63, words = 'Fear',           exhaustion = 30000, premium = false, type = 'Instant', icon = 'fear',               mana = 150,    level = 60, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {5}, description = 'fears the target. feared enemies are unable to move or cast by themselves.'},
    ['Shadow Strike'] =            {id = 64,  words = 'Shadow Strike', exhaustion = 5000, premium = false, type = 'Instant', icon = 'shadowbolts', mana = 70,    level = 30, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {5}, description = 'strikes the target with death damage. [MAGIC LEVEL]'},
    ['Summon Shadow Seeker'] =     {id = 65, words = 'Summon Shadow',  exhaustion = 60000, premium = false, type = 'Instant', icon = 'minion',     mana = 300,     level = 100, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {5}, description = 'summon shadow seeker. shadow seeker drains the enemies soul and gives it back to the caster as mana. [MxHP, MAGIC LEVEL]'},
    ['Blood Pact'] =               {id = 66, words = 'Blood Pact',     exhaustion = 1500, premium = false, type = 'Instant', icon = 'bloodpact',          mana = 0,      level = 40, soul = 0, group = {[2] = 1000},                parameter = false, vocations = {5}, description = 'sacrifice some of your health in exchange for mana. you cant die while casting this. [MxHP]'},
    ['Party Vitality'] =           {id = 67,  words = 'Party Vitality',  exhaustion = 1000, premium = false, type = 'Instant', icon = 'bloodmush',    mana = 50,    level = 60, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {5}, description = 'increases your and party total maxhealth by 20% for 20 minutes. '},
    ['Summon Abomination'] =       {id = 68,  words = 'Summon Abomination',   exhaustion = 60000, premium = false, type = 'Instant', icon = 'minion',    mana = 500,    level = 150, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {5}, description = 'summon an abomination that deals aoe damage, taunt and has a large health pool. [MxHP, MAGIC LEVEL]'},
    ['Summon Heket'] =             {id = 69,  words = 'Summon Heket',  exhaustion = 60000, premium = false, type = 'Instant', icon = 'minion',               mana = 250,    level = 70, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {5}, description = 'summon heket, deals high amounts of single target damage and has increased range. [MxHP, MAGIC LEVEL]'},
    ['Blood Wall'] =               {id = 70, words = 'Blood Wall',         exhaustion = 20000, premium = false, type = 'Instant', icon = 'bloodpact',        mana = 0,      level = 90, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {5}, description = 'in exchange of some of your health you will gain a 50% increased shielding and maxhealth buff.'},
    ['Dark Plague'] =              {id = 71,  words = 'Dark plague',    exhaustion = 22000, premium = false, type = 'Instant', icon = 'bats',                 mana = 300,    level = 100, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {5}, description = 'deals poison damage to all nearby enemies araound your target for several seconds.'},
    ['Astral Revival'] =           {id = 72, words = 'Astral Revival',             exhaustion = 25000, premium = false, type = 'Instant', icon = 'ghost',     mana = 300,     level = 125, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {5}, description = 'open the gates of hell. [MAGIC LEVEL]'},
    ['Void Creep'] =               {id = 73, words = 'creep',             exhaustion = 6000, premium = false, type = 'Instant', icon = 'minion',             mana = 60,     level = 18, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {5}, description = 'summon a void creep that explodes when reaching his target. [MAGIC LEVEL]'},
    ['Soul Rain'] =                {id = 74,  words = 'Soul Rain',    exhaustion = 15000, premium = false, type = 'Instant', icon = 'shadowexplode',         mana = 150,    level = 46, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {5}, description = 'deals damage to all nearby enemies around the selected target. [MxHP, MAGIC LEVEL]'},
    
    --NIGHTBLADE
    ['Stealth'] =                  {id = 80, words = 'Stealth',          exhaustion = 60000, premium = false, type = 'Instant', icon = 'stealth',      mana = 110,     level = 40, soul = 0, group = {[3] = 5000},                parameter = false, vocations = {3}, description = 'enter stealth mode for a 2.5 seconds, while stealth you become inmune to all incomming damage.'},
    ['Shadowstep'] =               {id = 83, words = 'Shadowstep',    exhaustion = 15000, premium = false, type = 'Instant', icon = 'jump',          mana = 125,     level = 90, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {3}, description = 'turn into shadows to teleport into your target and stunning them for 1.8 seconds. [Melee Skill]'},    
    ['Mutilate'] =                 {id = 81, words = 'Mutilate',         exhaustion = 4000, premium = false, type = 'Instant', icon = 'markofdeath',    mana = 35,      level = 8, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {3}, description = 'mutilate the target dealing damage multiple times. [Weapon Damage, Melee Skill]'},
    ['Backstab'] =                 {id = 84, words = 'Backstab',         exhaustion = 7000, premium = false, type = 'Instant', icon = 'backstab',       mana = 60,      level = 15, soul = 0, group = {[1] = 0},                parameter = false, vocations = {3}, description = 'stuns the target for 1.8 seconds and deals physical damage. [Melee Skill, MAGIC LEVEL]'},
    ['Shadow Hunt'] =              {id = 82, words = 'Shadow Hunt',        exhaustion = 6000, premium = false, type = 'Instant', icon = 'bats',       mana = 60,     level = 18, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {3}, description = 'hunt the target with crows dealing consecutive amounts of magic damage. [Weapon Damage, Melee Skill, MAGIC LEVEL]'},
    ['Dark Ambush'] =              {id = 85, words = 'Dark Ambush',        exhaustion = 22000, premium = false, type = 'Instant', icon = 'daggers',       mana = 250,     level = 70, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {3}, description = 'exterminates all enemies in your sight. [Weapon Damage, Melee Skill]'},
    ['Shadow Form'] =              {id = 87, words = 'Shadow Form',    exhaustion = 30000, premium = false, type = 'Instant', icon = 'void',            mana = 65,     level = 60, soul = 0, group = {[2] = 3000},              parameter = false, vocations = {3}, description = 'enter the shadow form wich heals yourself for a moderate period of time. [MxHP, MAGIC LEVEL]'},
    ['Fan of Knives'] =            {id = 86, words = 'Fan of knives',    exhaustion = 5000, premium = false, type = 'Instant', icon = 'shadowblade',    mana = 100,     level = 46, soul = 0, group = {[1] = 1000, [1] = 2000},    parameter = false, vocations = {3}, description = 'strike and poison all enemies around the yourself with physical damage and earth damage based on proximity. [Weapon Damage, Melee Skill]'},
    ['Dark Rupture'] =             {id = 88, words = 'Dark Rupture',    exhaustion = 6000, premium = false, type = 'Instant', icon = 'shadowexplode',    mana = 45,     level = 30, soul = 0, group = {[1] = 1000, [1] = 2000},    parameter = false, vocations = {3}, description = 'strike your target with a death attack, if the target is stunned damage will be significantly increased. [Weapon Damage, Melee Skill] or [Weapon Damage, Melee Skill, MAGIC LEVEL]'},
    ['Void Execution'] =           {id = 89, words = 'Void Execution',    exhaustion = 15000, premium = false, type = 'Instant', icon = 'execution',    mana = 125,     level = 100, soul = 0, group = {[1] = 1000, [1] = 2000},    parameter = false, vocations = {3}, description = 'Call death and Executes any target that is below 25%. [TRUE DAMAGE]'},
    ['Blood Blades'] =             {id = 90, words = 'Blood Blades',    exhaustion = 25000, premium = false, type = 'Instant', icon = 'firedagger',    mana = 50,     level = 125, soul = 0, group = {[1] = 1000, [1] = 2000},    parameter = false, vocations = {3}, description = 'Heals the target everytime it hits with melee attacks by a small percent.'},

    --Stellar
    ['Earth Call'] =                {id = 100, words = 'Earth Call',         exhaustion = 3000, premium = false, type = 'Instant', icon = 'naturefist',    mana = 30,      level = 8, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {6}, description = 'Call the earth spirits to shoot an earth attack into your target. [MAGIC LEVEL]'},
    ['Regrowth'] =                  {id = 101,  words = 'Regrowth',          exhaustion = 2000, premium = false, type = 'Instant', icon = 'healhand',         mana = 65,      level = 40,       soul = 0, group = {[2] = 1000},          parameter = false, vocations = {6}, description = 'heals the caster with healing winds. [MAGIC LEVEL]'}, 
    ['Aery Wrath'] =                {id = 102, words = 'Aery Wrath',         exhaustion = 10000, premium = false, type = 'Instant', icon = 'penitence',    mana = 45,      level = 18, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {6}, description = 'Call aery into batle hitting all enemies around the main target. [MAGIC LEVEL]'},
    ['Star Fall'] =                 {id = 103, words = 'Star Fall',          exhaustion = 7000, premium = false, type = 'Instant', icon = 'frostmissile',    mana = 0,      level = 46, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {6}, description = 'Call down one star dealing energy damage. (this spells does not consume mana) [MAGIC LEVEL].'},
    ['Falling Star'] =              {id = 104, words = 'Falling Star',       exhaustion = 7000, premium = false, type = 'Instant', icon = 'divinemissile',    mana = 95,      level = 30, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {6}, description = 'Call down one star dealing earth damage and stunning the target. [MxMANA, MAGIC LEVEL]'},
    ['Rain Fall'] =                 {id = 105, words = 'Rain Fall',             exhaustion = 20000, premium = false, type = 'Instant', icon = 'nightwolf',        mana = 85,       level = 25, soul = 0,            group = {[2] = 1000},    parameter = false, vocations = {6}, description = 'Bring a healling rain at your locationm healing all players inside the radius. [Target MxHP, MAGIC LEVEL]'}, 
    ['Heal Party'] =                {id = 106, words = 'Heal Party',            exhaustion = 4000, premium = false, type = 'Instant', icon = 'ultimatehealing',        mana = 150,       level = 28, soul = 0,          group = {[2] = 1000},    parameter = false, vocations = {6}, description = 'Heal all party members close to the caster. [MAGIC LEVEL]'}, 
    ['Aery Dance'] =                {id = 109, words = 'Aery Dance',         exhaustion = 8000, premium = false, type = 'Instant', icon = 'holysmite',    mana = 135,      level = 70, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {6}, description = 'Call aery into batle hitting all enemies around the main target. [MAGIC LEVEL]'},
    ['Lunar Beam'] =                {id = 108, words = 'Lunar Beam',        exhaustion = 13000, premium = false, type = 'Instant', icon = 'energybeam1',           mana = 260,        level = 125, soul = 0,            group = {[3] = 1000},     parameter = false, vocations = {6}, description = 'Deals energy damage to all enemies in front the caster direction. [MAGIC LEVEL]'},
    ['Full Moon'] =                 {id = 111, words = 'Full Moon',         exhaustion = 40000, premium = false, type = 'Instant', icon = 'moon',    mana = 300,      level = 100, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {6}, description = 'Procs Your passive (stellar alligment) continiusly. [MAGIC LEVEL]'},
    ['Grow'] =                      {id = 107, words = 'Grow',        exhaustion = 25000, premium = false, type = 'Instant', icon = 'nature',          mana = 100,        level = 60, soul = 0,             group = {[3] = 1000},     parameter = false, vocations = {6, 8}, description = 'grown multiple earth columns that can block paths.'},
    
    --Soul Weaver
    ['Soul Fists'] =                {id = 120, words = 'Soul Fists',        exhaustion = 3000, premium = false, type = 'Instant', icon = 'energyhand',         mana = 35,        level = 8, soul = 0,           group = {[1] = 1000},     parameter = false, vocations = {7}, description = 'Fist your target with your gathered souls, the damage is applied for every stored soul. [Mx Health, MAGIC LEVEL]'},
    ['Soul Barrage'] =              {id = 121, words = 'Soul Barrage',        exhaustion = 6000, premium = false, type = 'Instant', icon = 'deathhand',        mana = 75,        level = 30, soul = 0,          group = {[1] = 1000},     parameter = false, vocations = {7}, description = 'blast nearby targets with your gathered souls, the damage is applied for every stored soul. [Mx Health, MAGIC LEVEL]'},
    ['Anger Release'] =             {id = 122, words = 'Anger Release',        exhaustion = 12000, premium = false, type = 'Instant', icon = 'firehand',           mana = 125,        level = 55, soul = 0,             group = {[1] = 1000},     parameter = false, vocations = {7}, description = 'gather and release the anger of souls dealing death damage to all surrounding enemies. [Mx Health, MAGIC LEVEL]'},
    ['Spectral Wave'] =             {id = 124, words = 'Spectral Wave',        exhaustion = 15000, premium = false, type = 'Instant', icon = 'icearrow',           mana = 115,        level = 46, soul = 0,             group = {[1] = 1000},     parameter = false, vocations = {7}, description = 'Call from death spectral wave of creatures that deals damage to all enemies in front the caster direction. [Mx Health, MAGIC LEVEL]'},
    ['Underworld Gaze'] =           {id = 125, words = 'Underworld Gaze',        exhaustion = 10000, premium = false, type = 'Instant', icon = 'holyhand',         mana = 220,        level = 125, soul = 0,            group = {[1] = 1000},     parameter = false, vocations = {7}, description = 'deals AOE death damage to all surrounding enemies. [MAGIC LEVEL]'},
    ['Hollow Blade'] =              {id = 126, words = 'Hollow Blade',        exhaustion = 4000, premium = false, type = 'Instant', icon = 'bloodhand',        mana = 20,        level = 18, soul = 0,          group = {[1] = 1000},     parameter = false, vocations = {7}, description = 'strike the target with a hollow blade this spell has a 50% chance to generate 1 soul charge. [MAGIC LEVEL]'},
    ['Veil of Anguish'] =           {id = 127, words = 'Veil of Anguish',        exhaustion = 7000, premium = false, type = 'Instant', icon = 'spikes',        mana = 60,        level = 40, soul = 0,          group = {[3] = 1000},     parameter = false, vocations = {7}, description = 'Increase physical damage reflection by: 10% by 10 seconds.'},
    ['Absolute Denial'] =           {id = 128, words = 'Absolute Denial',        exhaustion = 20000, premium = false, type = 'Instant', icon = 'void',         mana = 200,        level = 60, soul = 0,             group = {[3] = 1000},     parameter = false, vocations = {7}, description = 'creates a hollow attack around the target that deals minor damage but heals the target based on the amount on enemies reached. [MAGIC LEVEL]'},
    ['Soul Link'] =                 {id = 129, words = 'Soul Link',        exhaustion = 50000, premium = false, type = 'Instant', icon = 'poisonhand',         mana = 100,        level = 90, soul = 0,             group = {[2] = 1000},     parameter = false, vocations = {7}, description = 'swap your current max health with your target. (only works on non elite monters)'},
    ['Drain Soul'] =                 {id = 130, words = 'Drain Soul',        exhaustion = 18000, premium = false, type = 'Instant', icon = 'shadowbolts',          mana = 200,        level = 100, soul = 0,            group = {[1] = 1000},     parameter = false, vocations = {7}, description = 'drain the soul of all surrounding enemies healing for each enemy afected'},
    ['Void Slumber'] =                 {id = 131, words = 'Void Slumber',        exhaustion = 10000, premium = false, type = 'Instant', icon = 'ghost',        mana = 125,        level = 70, soul = 0,             group = {[1] = 1000},     parameter = false, vocations = {7}, description = 'gather all nearby souls from dead enemies and summon them as soul voids the fight by your side.'},
    
    --Druid
    ['Terra Strike'] =              {id = 140, words = 'Terra Strike',        exhaustion = 3000, premium = false, type = 'Instant', icon = 'earthattack2',         mana = 30,        level = 8, soul = 0,           group = {[1] = 1000},     parameter = false, vocations = {8}, description = 'shoots an earth strike to the target. [MAGIC LEVEL]'},
    ['Living Seeds'] =              {id = 141, words = 'Living Seeds',        exhaustion = 35000, premium = false, type = 'Instant', icon = 'greenwind',           mana = 150,        level = 46, soul = 0,             group = {[3] = 1000},     parameter = false, vocations = {8}, description = 'creates 2 living seeds in your inventory. these seeds can be place in the ground as summons. [MAGIC LEVEL]'},
    ['Life Bloom'] =                {id = 142, words = 'Life Bloom',        exhaustion = 6000, premium = false, type = 'Instant', icon = 'icehand',        mana = 70,        level = 25, soul = 0,          group = {[2] = 1000},     parameter = false, vocations = {8}, description = 'restore casters and all party members health every second. [Target MxHP, MAGIC LEVEL]'},
    ['Rejuvenation'] =              {id = 143, words = 'Rejuvenation',        exhaustion = 11000, premium = false, type = 'Instant', icon = 'healhand',        mana = 85,        level = 40, soul = 0,          group = {[2] = 1000},     parameter = false, vocations = {8}, description = 'Strong Self heal. [MAGIC LEVEL]'},
    ['Seed Germination'] =          {id = 144, words = 'Seed Germination',        exhaustion = 15000, premium = false, type = 'Instant', icon = 'icehand2',        mana = 75,        level = 18, soul = 0,          group = {[1] = 1000},     parameter = false, vocations = {8}, description = 'place a corrupted seed into the target that spreads over time dealing earth damage. [MAGIC LEVEL]'},
    ['Travel Form'] =               {id = 145, words = 'Travel Form',        exhaustion = 2000, premium = false, type = 'Instant', icon = 'haste',         mana = 60,        level = 25, soul = 0,          group = {[3] = 2000},     parameter = false, vocations = {8}, description = 'turn yourself into your travel form increasing dramatically your movement speed, while in this form you are unable to cast any spells.'},
    ['Carnivorous Vile'] =          {id = 146, words = 'Carnivorous Vile',        exhaustion = 5500, premium = false, type = 'Instant', icon = 'plant2',           mana = 85,        level = 30, soul = 0,          group = {[1] = 1000},     parameter = false, vocations = {8}, description = 'cast a carnivorous plant into the target dealing earth damage, damage is increased if the target is poisoned. [MAGIC LEVEL]'},
    ['living ground'] =             {id = 147, words = 'living ground',        exhaustion = 10000, premium = false, type = 'Instant', icon = 'energythunder2',         mana = 110,        level = 60, soul = 0,             group = {[2] = 1000},     parameter = false, vocations = {8}, description = 'creates a restoring ground that heals all players affected. [Target MxHP]'},
    ['Thorns'] =                    {id = 148, words = 'Thorns',        exhaustion = 2000, premium = false, type = 'Instant', icon = 'nature',         mana = 50,        level = 60, soul = 0,          group = {[3] = 1000},     parameter = false, vocations = {8}, description = 'place thorns in all party members increasing physical damage reflection by: 5% for 20 minutes.'},
    ['Peircing Wave'] =             {id = 149, words = 'Peircing Wave',        exhaustion = 12000, premium = false, type = 'Instant', icon = 'earthattack',        mana = 115,        level = 42, soul = 0,             group = {[1] = 1000},     parameter = false, vocations = {8}, description = 'pierce trough enemies with a thorns wave stunning and bleeding all enemies affected. [MAGIC LEVEL]'},
    ['Bear Form'] =                {id = 150, words = 'Bear Form',        exhaustion = 20000, premium = false, type = 'Instant', icon = 'roar',        mana = 60,        level = 45, soul = 0,          group = {[3] = 1000},     parameter = false, vocations = {8}, description = 'turn yourself into your bear form increasing dramatically your max health but reducing your speed, while in this form you are only able to cast healing spells .'},
    ['Bless of the Forest'] =       {id = 151, words = 'Bless of the Forest',        exhaustion = 2000, premium = false, type = 'Instant', icon = 'flower',        mana = 100,        level = 60, soul = 0,             group = {[3] = 1000},     parameter = false, vocations = {8}, description = 'bless all your party members by increasing Health and mana restoration: 1% every 2 seconds for 20 minutes.'},
    ['Wrath of Nature'] =           {id = 152, words = 'Wrath of Nature',        exhaustion = 18000, premium = false, type = 'Instant', icon = 'naturewrath',          mana = 350,        level = 70, soul = 0,             group = {[1] = 1000},     parameter = false, vocations = {8}, description = 'Call the wrath of nature into all enemies around your target dealing energy damage. [MAGIC LEVEL]'},
    ['Soul Form'] =                 {id = 153, words = 'Soul Form',        exhaustion = 120000, premium = false, type = 'Instant', icon = 'nightwolf',         mana = 250,        level = 100, soul = 0,            group = {[3] = 1000},     parameter = false, vocations = {8}, description = 'enter your soul form increasing your magic level by 20% and increasing drastically your hp and mana regeneration.'},
    ['Earth Dance'] =               {id = 110, words = 'Earth Dance',         exhaustion = 16000, premium = false, type = 'Instant', icon = 'plant2',    mana = 225,      level = 125, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {8}, description = 'Call the earth spirits to create an avalanche of rocks that collides into enemy targets. [MAGIC LEVEL]'},
    
    --Light Dancer
    ['Charged Strike'] =            {id = 160, words = 'Charged Strike',        exhaustion = 4000, premium = false, type = 'Instant', icon = 'swordslash',         mana = 25,        level = 8, soul = 0,           group = {[1] = 1000},     parameter = false, vocations = {9}, description = 'strike the target with an electric slash dealing energy damage, if the target is affected by static charge this effect will be powered twice. [Weapon Damage, Melee Skill]'},
    ['Static Charge'] =             {id = 161, words = 'Static Charge',        exhaustion = 2200, premium = false, type = 'Instant', icon = 'electrticity',        mana = 0,        level = 15, soul = 0,           group = {[1] = 1000},     parameter = false, vocations = {9}, description = 'apply static charge into the target. [LVL]'},
    ['Light Dash'] =                {id = 162, words = 'Light Dash',        exhaustion = 6000, premium = false, type = 'Instant', icon = 'travel',         mana = 65,        level = 18, soul = 0,          group = {[1] = 1000},     parameter = false, vocations = {9}, description = 'dash into the targeted enemy dealing energy damage, if the target if affected by static charge this effect will be powered and also stun the target by 1.8 seconds. [Melee Skill]'},
    ['Lightning Orb'] =             {id = 163, words = 'Lightning Orb',        exhaustion = 10000, premium = false, type = 'Instant', icon = 'energyball',         mana = 155,        level = 100, soul = 0,            group = {[1] = 1000},     parameter = false, vocations = {9}, description = 'summon a lighting orb that deals energy damage around the target. [MAGIC LEVEL]'},
    ['Fission Break'] =             {id = 164, words = 'Fission Break',        exhaustion = 15000, premium = false, type = 'Instant', icon = 'swordstance',        mana = 250,        level = 70, soul = 0,             group = {[1] = 1000},     parameter = false, vocations = {9}, description = 'expels high amounts of energy from the caster wich deals energy damage (this effect can also apply on hit effects)[Weapon Damage, Melee Skill, MAGIC LEVEL].'},
    ['Aereal Shock'] =              {id = 165, words = 'Aereal Shock',        exhaustion = 5000, premium = false, type = 'Instant', icon = 'intensehealing',           mana = 100,        level = 46, soul = 0,             group = {[1] = 1000},     parameter = false, vocations = {9}, description = 'Shocks all surrounding enemies that are affected by static shock dealing energy damage. [Target MxHP, MAGIC LEVEL]'},
    ['Lightning Spear'] =           {id = 166, words = 'Lightning Spear',        exhaustion = 12000, premium = false, type = 'Instant', icon = 'frostmissile',         mana = 85,        level = 50, soul = 0,          group = {[1] = 1000},     parameter = false, vocations = {9}, description = 'throws a energy spear into the target dealing high energy damage and applying static charge. [MAGIC LEVEL]'},
    ['Overcharge'] =                {id = 167, words = 'Overcharge',        exhaustion = 30000, premium = false, type = 'Instant', icon = 'energythunder',         mana = 115,        level = 45, soul = 0,             group = {[3] = 1000},     parameter = false, vocations = {9}, description = 'enter overcharge mode wich increases all your offensive skills by 20% but reciving damage for the duration.'},
    ['Magnetic Field'] =            {id = 168, words = 'Magnetic Field',        exhaustion = 35000, premium = false, type = 'Instant', icon = 'energyattack',          mana = 175,        level = 90, soul = 0,             group = {[3] = 1000},     parameter = false, vocations = {9}, description = 'place a magnetic field in the ground wich makes all enemies unable to walk normally.'},
    ['Thunderstorm'] =              {id = 169, words = 'Thunderstorm',        exhaustion = 25000, premium = false, type = 'Instant', icon = 'thunders',        mana = 250,        level = 125, soul = 0,            group = {[1] = 1000},     parameter = false, vocations = {9}, description = 'create a thunderstorm in the target location that will damage all nearvy enemies.(this will not affect players) [MAGIC LEVEL]'},
    
    --Archer
    ['Flaming Shot'] =             {id = 180, words = 'Flaming Shot',        exhaustion = 3000, premium = false, type = 'Instant', icon = 'fireshot',          mana = 30,        level = 8, soul = 0,           group = {[1] = 1000},     parameter = false, vocations = {10}, description = 'shoot a flaming shot to the target dealing fire damage and burning the target (based on your ml), if the target is affected by beer barrel this spell will be powered and deal target max health damage. [Weapon Damage, DISTANCE, MAGIC LEVEL] & [Target MxHP]'},
    ['Beer Barrel'] =              {id = 181, words = 'Beer Barrel',        exhaustion = 2000, premium = false, type = 'Instant', icon = 'barrel',         mana = 25,        level = 15, soul = 0,          group = {[3] = 1000},     parameter = false, vocations = {10}, description = 'throws a beer barrel to the enemy target that spreads to all nearby enemies.'},
    ['Wind Barrel'] =              {id = 183, words = 'Wind Barrel',        exhaustion = 5000, premium = false, type = 'Instant', icon = 'deathattack',        mana = 40,        level = 40, soul = 0,          group = {[3] = 1000},     parameter = false, vocations = {10}, description = 'creates a wind barrel that explodes after a short time duration increasing your movement speed drastically.'},
    ['Healing Barrel'] =           {id = 186, words = 'Healing Barrel',        exhaustion = 8000, premium = false, type = 'Instant', icon = 'icicle',          mana = 120,        level = 60, soul = 0,             group = {[2] = 1000},     parameter = false, vocations = {10}, description = 'creates a healing barrel that explodes after a short time duration healing all players in the area.'},
    ['Arrow Rain'] =               {id = 187, words = 'Arrow rain',       exhaustion = 15000, premium = false, type = 'Instant', icon = 'arrowbarrage',   mana = 130,     level = 46, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {10}, description = 'cast a arrow rain into the target dealing physical damage to all enemies in the area.[Weapon Damage, DISTANCE]'},
    ['Nail Bomb'] =                {id = 185, words = 'Nail Bomb',        exhaustion = 8000, premium = false, type = 'Instant', icon = 'firestom',        mana = 90,      level = 30, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {10}, description = 'throw a nail bomb that instantly explode dealing high amounts of physical damage. [Weapon Damage, DISTANCE]'},
    ['Explosive Shots'] =          {id = 182, words = 'Explosive Shots', exhaustion = 15000, premium = false, type = 'Instant', icon = 'arrowshot1',      mana = 90,     level = 18, soul = 0, group = {[1] = 1000},                parameter = false, vocations = {10}, description = 'shoot 4 rounds of explosive shots dealing aoe damage to the target location, if the target is affected by beer barrel this spell will be powered and deal target max health damage. [Weapon Damage, DISTANCE]'},
    ['Condemn Shot'] =             {id = 184,  words = 'Condemn Shot',    exhaustion = 25000, premium = false, type = 'Instant', icon = 'arrowbreak',    mana = 60,      level = 28, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {10}, description = 'repels your target away from the caster. [Weapon Damage, DISTANCE]'},
    ['Arrow Barrage'] =            {id = 189, words = 'Arrow Barrage',    exhaustion = 22000, premium = false, type = 'Instant', icon = 'arrowshots',    mana = 250,     level = 100, soul = 0, group = {[1] = 1000, [1] = 2000},    parameter = false, vocations = {10}, description = 'shoot multiple dark shots into all nearby enemies dealing physical damage. [Weapon Damage, DISTANCE]'},
    ['Frost Barrel'] =             {id = 188, words = 'Frost Barrel',        exhaustion = 15000, premium = false, type = 'Instant', icon = 'firearrow',        mana = 150,        level = 70, soul = 0,             group = {[3] = 1000},     parameter = false, vocations = {10}, description = 'creates a frost barrel that explodes after a short time duration freezing all enemies in the area.'},
    ['Aspect Mastery'] =             {id = 123, words = 'Aspect Mastery',        exhaustion = 22000, premium = false, type = 'Instant', icon = 'firestance',           mana = 150,        level = 125, soul = 0,            group = {[1] = 1000},     parameter = false, vocations = {10}, description = 'change between demolition stance and beast mode. Demlolition mode: allows the user to deal aoe damage on hit. Beast Mode: allows the user tu summon a wolf that evolves into a war wolf later on to assist you on combat.'},
    



    ['Minor Heal'] =               {id = 200, words = 'Minor Heal',            exhaustion = 1500, premium = false, type = 'Instant', icon = 'ultimatehealing',     mana = 20,      level = 1,  soul = 0, group = {[2] = 1000},                parameter = false, vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, description = 'Basic healing spell, heals the caster for an small amount. [Target MxHP, MAGIC LEVEL]'},
    ['Strong Heal'] =              {id = 201, words = 'Strong Heal',           exhaustion = 1700, premium = false, type = 'Instant', icon = 'ultimatehealing',     mana = 65,      level = 40,  soul = 0, group = {[2] = 1000},                parameter = false, vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, description = 'Basic healing spell, heals the caster for an moderate amount. [Target MxHP, MAGIC LEVEL]'},
    ['Great Heal'] =               {id = 202, words = 'Great Heal',            exhaustion = 2300, premium = false, type = 'Instant', icon = 'ultimatehealing',     mana = 140,      level = 90,  soul = 0, group = {[2] = 1000},                parameter = false, vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, description = 'Basic healing spell, heals the caster for an moderate amount. [Target MxHP, MAGIC LEVEL]'},
    
    --MASTERY
    ['Taunt'] =                    {id = 324,  words = 'taunt',        exhaustion = 2000, premium = false, type = 'Instant', icon = 'roar',    mana = 75,     level = 22, soul = 0,                              group = {[3] = 1000},                parameter = false, vocations = {11}, description = 'taunt all enemies around the caster. unlocked at defence 30.'},      
    ['Shield Wall'] =              {id = 300, words = 'shield wall',           exhaustion = 15000, premium = false, type = 'Instant', icon = 'shield2',     mana = 0,      level = 27,  soul = 0, group = {[3] = 1000},                parameter = false, vocations = {11}, description = 'Increases your max health and defence for a short period of time.'},
    ['Protection'] =               {id = 301,  words = 'protection',            exhaustion = 50000, premium = false, type = 'Instant', icon = 'shield',       mana = 50,     level = 50,  soul = 0, group = {[3] = 1000},                parameter = false, vocations = {11}, description = 'inmune to all damage for 3 seconds.'},
    ['Shield Bash'] =              {id = 302, words = 'shield bash',       exhaustion = 15000, premium = false, type = 'Instant', icon = 'kick',      mana = 65,     level = 25, soul = 0,          group = {[3] = 1000},   parameter = false, vocations = {11}, description = 'Stuns your target, this skill requires a shield. unlocked at defence 22.'}, 
    ['Hells Core'] =               {id = 304, words = 'Hells Core',         exhaustion = 2000, premium = false, type = 'Instant', icon = 'meteor',   mana = 650,     level = 85,    soul = 0,       group = {[1] = 1000},     parameter = false, vocations = {11}, description = 'unlocked at magic 55 and intelligence 105.'}, 
    ['Quick Chains'] =             {id = 305, words = 'Quick Chains',       exhaustion = 2000, premium = false, type = 'Instant', icon = 'chains',   mana = 250,     level = 47,    soul = 0,       group = {[3] = 1000},      parameter = false, vocations = {11}, description = 'unlocked at dexterity 65.'},  
    ['Blood Rage'] =               {id = 306, words = 'Blood Rage',    exhaustion = 30000, premium = false, type = 'Instant', icon = 'firestance',   mana = 85,      level = 30, soul = 0,          group = {[1] = 1000},      parameter = false, vocations = {11}, description = 'unlocked at strenght 27.'}, 
    ['Magic Shield'] =             {id = 307, words = 'Magic Shield',  exhaustion = 2000, premium = false, type = 'Instant', icon = 'manashield',    mana = 0,       level = 17, soul = 0,          group = {[3] = 1000},      parameter = false, vocations = {11}, description = 'unlocked at intelligence 25.'},  
    ['Find Person'] =              {id = 308,  words = 'exiva',        exhaustion = 2000, premium = false, type = 'Instant', icon = 'other',       mana = 20,     level = 8, soul = 0, group = {[3] = 1000},                parameter = true, vocations = {11}},    
    ['Food'] =                     {id = 309,  words = 'exevo pan',        exhaustion = 2000, premium = false, type = 'Instant', icon = 'other',   mana = 15,     level = 10, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {11}, description = 'unlocked at Faith 10.'},      
   
    ['Haste'] =                    {id = 311,  words = 'utani hur',        exhaustion = 2000, premium = false, type = 'Instant', icon = 'haste',   mana = 60,     level = 14, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {11}},      
    ['Heal Friend'] =              {id = 312,  words = 'exura sio',            exhaustion = 2000, premium = false, type = 'Instant', icon = 'ultimatehealing',        strenght = 8, dexterity = 8, intelligence = 8,   faith = 8,     mana = 140,         level = 18, soul = 0,                 group = {[2] = 1000},                parameter = true, vocations = {11}, description = 'unlocked at faith 20 and intelligence 24.'},     
    ['Invisibility'] =             {id = 313,  words = 'Invisibility',             exhaustion = 2000, premium = false, type = 'Instant', icon = 'other',          strenght = 8, dexterity = 8, intelligence = 8,   faith = 8,     mana = 440,             level = 35,   soul = 0,               group = {[3] = 1000},                parameter = false, vocations = {11}, description = 'unlocked at faith 50.'},     
    ['Levitate'] =                 {id = 314,  words = 'exani hur',        exhaustion = 2000, premium = false, type = 'Instant', icon = 'other',   mana = 50,     level = 15, soul = 0, group = {[3] = 1000},                parameter = true, vocations = {11}},      
    ['Light'] =                    {id = 315,  words = 'utevo lux',        exhaustion = 2000, premium = false, type = 'Instant', icon = 'other',   mana = 20,     level = 8, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {11}},     
    
    ['Magic Rope'] =               {id = 317,  words = 'exani tera',        exhaustion = 2000, premium = false, type = 'Instant', icon = 'other',  mana = 20,     level = 8, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {11}},      
    ['Mass Healing'] =             {id = 318,  words = 'exura gran mas res',               exhaustion = 2000, premium = false, type = 'Instant', icon = 'ultimatehealing',        strenght = 8, dexterity = 8, intelligence = 8, faith = 8, mana = 150,    level = 36, soul = 0,    group = {[4] = 2000},                parameter = false, vocations = {11}, description = 'unlocked at faith 60.'},     
    ['Protect Party'] =            {id = 319,  words = 'utamo mas sio',            exhaustion = 2000, premium = false, type = 'Instant', icon = 'partyshield',        strenght = 8, dexterity = 70, intelligence = 8,   faith = 8,     mana = 90,        level = 32,    soul = 0,           group = {[4] = 2000},                parameter = false, vocations = {11}, description = 'unlocked at faith 55.'},   
    ['Strong Haste'] =             {id = 322,  words = 'utani gran hur', exhaustion = 2000, premium = false, type = 'Instant', icon = 'haste',     mana = 100,     level = 40, soul = 0, group = {[3] = 1000},                parameter = false, vocations = {11}, description = 'unlocked at Faith 20'},     
    ['Kings Call'] =                    {id = 325,  words = 'kings call',        exhaustion = 3600000, premium = false, type = 'Instant', icon = 'holycross',    mana = 0,     level = 8, soul = 0,                              group = {[3] = 1000},                parameter = false, vocations = {11}, description = 'Summoned by your kings command, Kings Call instantly teleports you to your hometown. A spell of royal privilege, granted to those bearing the Kings Scroll.'},      
    
    
  }
}

-- ['const_name'] =       {client_id, TFS_id}
-- Conversion from TFS icon id to the id used by client (icons.png order)
SpellIcons = {
  ['bluehand']           = {13, 160},
  ['healingdot']                  = {14, 159},
  ['potionheal']     = {6,  158},
  ['strongpotionheal']       = {7, 157},
  ['partyshield']         = {8, 156},
  ['partyaura']      = {9, 155},
  ['greenwind']       = {10, 154},
  ['pending']         = {11, 153},
  ['execution']           = {12, 152},
  ['auraclock']        = {15, 151},
  ['auraclock2']         = {16, 150},
  ['hearths']                 = {17, 149},
  ['energymissiles']            = {18, 148},
  ['frostmissile']                 = {19, 147},
  ['frostaura']      = {20, 146},
  ['energybeam1']               = {21, 145},
  ['frostice']              = {22, 144},
  ['meteor']                 = {23, 143},
  ['fireshot']                   = {24, 142},
  ['elementalblast']              = {25, 141},
  ['thunderhammer']                 = {26, 140},
  ['electrticity']                     = {27, 139},
  ['ignite']                    = {28, 138},
  -- [[ 136 / 137 Unknown ]]
  ['energyball']              = {29, 135},
  ['travel']                 = {30, 134},
  ['energyattack']                 = {31,  133},
  ['firefist']                 = {32, 132},
  ['tornado']                    = {33,  131},
  ['strongfrost']               = {34,  130},
  ['earthattack']              = {35, 129},
  ['earthattack2']                 = {36, 128},
  ['elf']              = {37, 127},
  ['deathattack']                = {38, 126},
  ['energyball1']             = {41,   125},
  ['divinecaldera']             = {40,  124},
  ['energyrush']            = {42,   123},
  ['divinemissile']             = {39,  122},
  ['energyrush2']                   = {43,  121},
  ['eternalfire']                 = {44,  120},
  ['icehand']            = {45,  119},
  ['icehand2']             = {46,  118},
  ['plant1']              = {47,  117},
  ['plant2']               = {48,  116},
  ['firearrow']                 = {49,  115},
  ['icicle']                    = {50,  114},
  ['energythunder']               = {51,  113},
  ['energythunder2']               = {52,  162},
  ['holyhand']                 = {53,  112},
  ['deathhand']             = {54,  111},
  ['firehand']              = {55, 110},
  ['energyhand']              = {56, 109},
  ['bloodhand']               = {57, 108},
  ['poisonhand']            = {58,  107},
  ['icearrow']              = {59,  106},
  ['holycross']             = {60,  105},
  -- [[ 96 - 104 Unknown ]]
  ['dragonshrine']                 = {61, 95},
  ['firebolt']                = {62,  94},
  ['firetornado']                 = {63,  93},
  ['dragonbreath']              = {64, 92},
  ['dragonstance']                = {65,  91},
  ['fireearth']        = {66,  90},
  ['bloodaxe']               = {67,  89},
  ['charge']              = {68,  88},
  ['firesoul']              = {69,  161},
  ['firestance']               = {70,  87},
  ['swordstance']                 = {71,  86},
  ['nightwolf']                = {72,   84},
  ['holyarea']               = {73,  83},
  ['holysword']               = {74,   82},
  ['divineclock']                  = {75, 81},
  ['sacredarea']                   = {76,  80},
  ['penitence']               = {77, 79},
  ['holysmite']              = {78,  78},
  ['holyshot']                = {79,  77},
  ['markofdeath']                 = {80, 76},
  ['holyslash']             = {81, 75},
  -- [[ 71 - 64 TFS House Commands ]]
  -- [[ 63 - 70 Unknown ]]
  ['smite']              = {82,  62},
  ['shadowblade']              = {83,  61},
  -- [[ 60 Unknown ]]
  ['arrowbarrage']                = {84,  59},
  -- [[ 58 Unknown ]]
  ['barrel']       = {85,  57},
  ['daggers']             = {86,  56},
  ['arrowshots']                = {87,  55},
  ['partyshield']                  = {88,  54},
  --  [[ 53 Unknown ]]
  --  [[ 52 TFS Retrieve Friend ]]
  ['firedagger']              = {89, 51},
  ['backstab']                  = {90,  50},
  ['arrowbreak']            = {91, 49},
  ['poisonshot']             = {92, 48},
  -- [[ 46 / 47 Unknown ]]
  ['stealth']                 = {93,  45},
  ['jump']               = {94, 44},
  ['arrowshot1']             = {95,  43},
  ['shadowexplode']                      = {96,  42},
  -- [[ 40 / 41 Unknown ]]
  ['zombiewall']               = {97, 39},
  ['shadowbarrage']          = {98, 38},
  -- [[ 37 TFS Move ]]
  ['minion']                 = {99,  36},
  -- [[ 34 / 35 Unknown ]]
  ['shadoweye']                = {100,  33},
  ['fear']                = {101,  32},
  ['bats']                  = {103,  31},
  ['bloodpact']              = {104,  30},
  ['shadowskull']                = {105,  29},
  ['ghost']                  = {106,  28},
  ['bloodmush']               = {107,  27},
  ['shadowbolts']               = {108,  26},
  ['nature']                 = {109,  25},
  ['flower']                 = {110,  24},
  ['chains']           = {111,  23},
  ['naturefist']                = {112,  22},
  ['frog']               = {113,  21},
  ['spikes']                = {114, 20},
  ['healhand']                  = {115,  19},
  ['moon']                 = {116,  18},
  ['thunders']                  = {117,  17},
  ['roar']             = {118,  16},
  ['void']                  = {119,  15},
  ['firestom']                 = {120,  14},
  ['swordslash']                = {121,  13},
  ['hunterstance']          = {122,  12},
  ['kick']                = {123, 11},
  ['shield2']                     = {124, 10},
  ['naturewrath']            = {125, 9},
  ['other']         = {126,  8},
  ['lightmagicmissile']         = {126,  7},
  ['haste']                     = {102, 6},
  ['manashield']                = {3,  5},
  ['shield']                    = {2,  4},
  ['ultimatehealing']           = {1,   3},
  ['intensehealing']            = {5,   2},
  ['lighthealing']              = {4,   1}
}

VocationNames = {
  [1] = 'Magician',
  [2] = 'Templar',
  [3] = 'Nightblade',
  [4] = 'Dragon Knight',
  [5] = 'Warlock',
  [6] = 'Stellar',
  [7] = 'Soul Weaver',
  [8] = 'Druid',
  [9] = 'Light Dancer',
  [10] = 'Archer',
  [11] = 'No specific vocation required',

}

SpellGroups = {
  [1] = 'Attack',
  [2] = 'Healing',
  [3] = 'Support',
  [4] = 'Mastery'
}

Spells = {}

function Spells.getClientId(spellName)
  local profile = Spells.getSpellProfileByName(spellName)

  local id = SpellInfo[profile][spellName].icon
  if not tonumber(id) and SpellIcons[id] then
    return SpellIcons[id][1]
  end
  return tonumber(id)
end

function Spells.getServerId(spellName)
  local profile = Spells.getSpellProfileByName(spellName)

  local id = SpellInfo[profile][spellName].icon
  if not tonumber(id) and SpellIcons[id] then
    return SpellIcons[id][2]
  end
  return tonumber(id)
end

function Spells.getSpellByName(name)
  return SpellInfo[Spells.getSpellProfileByName(name)][name]
end

function Spells.getSpellByWords(words)
  local words = words:lower():trim()
  for profile,data in pairs(SpellInfo) do
    for k,spell in pairs(data) do
      if spell.words == words then
        return spell, profile, k
      end
    end
  end
  return nil
end

function Spells.getSpellByIcon(iconId)
  for profile,data in pairs(SpellInfo) do
    for k,spell in pairs(data) do
      if spell.id == iconId then
        return spell, profile, k
      end
    end
  end
  return nil
end

function Spells.getSpellIconIds()
  local ids = {}
  for profile,data in pairs(SpellInfo) do
    for k,spell in pairs(data) do
      table.insert(ids, spell.id)
    end
  end
  return ids
end

function Spells.getSpellProfileById(id)
  for profile,data in pairs(SpellInfo) do
    for k,spell in pairs(data) do
      if spell.id == id then
        return profile
      end
    end
  end
  return nil
end

function Spells.getSpellProfileByWords(words)
  for profile,data in pairs(SpellInfo) do
    for k,spell in pairs(data) do
      if spell.words == words then
        return profile
      end
    end
  end
  return nil
end

function Spells.getSpellProfileByName(spellName)
  for profile,data in pairs(SpellInfo) do
    if table.findbykey(data, spellName:trim(), true) then
      return profile
    end
  end
  return nil
end

function Spells.getSpellsByVocationId(vocId)
  local spells = {}
  for profile,data in pairs(SpellInfo) do
    for k,spell in pairs(data) do
      if table.contains(spell.vocations, vocId) then
        table.insert(spells, spell)
      end
    end
  end
  return spells
end

function Spells.filterSpellsByGroups(spells, groups)
  local filtered = {}
  for v,spell in pairs(spells) do
    local spellGroups = Spells.getGroupIds(spell)
    if table.equals(spellGroups, groups) then
      table.insert(filtered, spell)
    end
  end
  return filtered
end

function Spells.getGroupIds(spell)
  local groups = {}
  for k,_ in pairs(spell.group) do
    table.insert(groups, k)
  end
  return groups
end

function Spells.getImageClip(id, profile)
  return (((id-1)%12)*SpelllistSettings[profile].iconSize.width) .. ' ' 
    .. ((math.ceil(id/12)-1)*SpelllistSettings[profile].iconSize.height) .. ' ' 
    .. SpelllistSettings[profile].iconSize.width .. ' ' 
    .. SpelllistSettings[profile].iconSize.height
end

function Spells.getSpellNameByWords(spellWords)
  local profile = Spells.getSpellProfileByWords(spellWords)
  for profile,data in pairs(SpellInfo) do
    for k,spell in pairs(data) do
      if spell.words == spellWords then
        return k
      end
    end
  end
  return nil
end

function Spells.getSpellByClientId(clientId)
  for profile,data in pairs(SpellInfo) do
    for k,spell in pairs(data) do
      if spell.clientId and spell.clientId == clientId then
        return spell, profile, k
      end
    end
  end
  return nil
end

function getSpellsForVocation(vocationId)
    return spellsByVocation[vocationId] or {}
end

function getVocationName(vocationId)
    return VocationMapping[vocationId] or "Unknown"
end
