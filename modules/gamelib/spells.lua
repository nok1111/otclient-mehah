SpelllistSettings = {
  ['Custom'] =  {
    iconFile = '/images/game/spells',
    iconSize = {width = 32, height = 32},
    spellListWidth = 245,
    spellWindowWidth = 800,
    spellOrder = {
      --Dragon Knight
      'Rend',
      'Brutal Swing',
      'Ripping Slash',
      'Fire Within',
      'Charge',
      'whirlwind',
      'Phoenix Wrath',
      'Dragon Aura',
      'Dragons Call',
      'Draconic Chains',
      'Shockwave',
      'Bloodlust',
      'Dragon Soul',

      --Samurai
      'Rending Slash',
      'Blade Tempest',
      'Wind Step',
      'Guardian Stance',
      'Iaijutsu',
      'Triple Slash',
      'Crimson Lotus',
      'Merciful End',
      'Flash Steel',
      'Death Mark',
      'Iron Skin',
      'Second Wind',
      'Cyclone Slash',
      'Searing Wind',
      'Meditation',

      --Templar
      'Divine Punishment',
      'Penitence',
      'Holy Ground',
      'Sacred Ground',
      'Holy Strike',
      'Divine Storm',
      'Exorcism',
      'Smite',
      'Light Beam',
      'Summon Guardian of Light',
      'Kings Blessing',
      'Angelic Form',
      'Judgement',

      --Magician
      'Frost Blast',
      'Energy Blast',
      'Fire Blast',
      'Ice Nova',
      'Mana Distortion',
      'Mana Flow',
      'Hand of God',
      'Frost Wave',
      'Arcane Missiles',
      'Teleport',
      'Blizzard',
      'Hells Core',
      'Ice Barrage',
      'Ice Wall',
      'Ice Clones',
      'Eruption',
      'Glacial Steps',

      --warlock
      'Zombie Wall',
      'Curse',
      'Fear',
      'Shadow Strike',
      'Summon Void Mender',
      'Blood Pact',
      'Party Vitality',
      'Summon Void Guard',
      'Summon Void Sentinel',
      'Blood Wall',
      'Dark Plague',
      'Soul Rain',
      'Drain Soul',
      'Malediction',
      'Haunt',
      'Dark Aura',
    
    --Nightblade
      'Stealth',
      'Mutilate',
      'Shadow Hunt',
      'Shadowstep',
      'Backstab',
      'Assassination',
      'Fan of Knives',
      'Shadow Form',
      'Dark Rupture',
      'Void Execution',
      'Blood Blades',
      'Lethal Dagger',
      'Blackout',

      --Stellar
      'Cosmic Force',
      'Aery Wrath',
      'Starfall',
      'Falling Star',
      'Rain fall',
      'Magic Walls',
      'Lunar Beam',
      'Aery Strikes',
      'Full Moon',
      'Moonlight',
      'Holy Flare',
      'Solar Blessing',
      'Astral Infusion',


        --monk
      'Lotus Kick',
      'Adaptive Punch',
      'Fire Punch',
      'Ice Punch',
      'Life Punch',
      'Fist of Fire',
      'Volcanic Dash',
      'Stormfist',
      'Mountain Stance',
      'Zen Barrier',
      'Mystic Fist',
      'Crane Stance',
      'Fist of Ice',
      'Fist of Life',

      --druid
      'Terra Strike',
      'Life Bloom',
      'Rejuvenation',
      'Insect Swarm',
      'Travel Form',
      'Carnivorous Vile',
      'living ground',
      'Piercing Wave',
      'Bear Form',
      'Bless of the Forest',
      'Wrath of Nature',
      'Focus Healing',
      'Ice Shatter',
      'Frost Armor',

      --light dancer
      'Charged Strike',
      'Static Charge',
      'Light Dash',
      'Veil of Swords',
      'Magnetic Shield',
      'Lightning Spear',
      'Overcharge',
      'Elusive Blade',
      'Magnetic Orb',
      'Tempest Coin',

      --Archer
      'Flaming Shot',
      'Explosive Barrel',
      'Explosive Shot',
      'Wind Barrel',
      'Condemn Shot',
      'Healing Barrel',
      'Arrow rain',
      'Frost Barrel',
      'Phantom Shot',
      'Arrow Barrage',
      'Rapid Fire',
      'Ice Arrow',
      'Falcon Shot',

      --Bard
      'Cheerful Melody',
      'Pensive Melody',
      'Menacing Melody',
      'Cathartic Melody',
      'Epic Melody',
      'Echo Strike',
      'Resonant Chorus',
      'Discordant Verse',
      'Harmonic Collapse',
      'Reverberation',
      'Grand Finale',

      --Warden
      'Crystal Cleave',
      'Glacial Shard',
      'Avalanche Stomp',
      'Barkskin',
      'Sylvan Mend',
      'Frozen Earth',
      "Guardian's Bulwark",
      'Permafrost Shell',
      'Frigid Grasp',
      'Verdant Sanctuary',
      'Thorned Skin',
      'Seismic Slam',
      'Ice Barrier',
      'Taunting Roar',
      'Root Grasp',
      'Spring of Life',

      --Blood Mage
      'Sanguine Bolt',
      'Blood Siphon',
      'Crimson Sigil',
      'Sanguine Pool',
      'Blood Threads',
      'Blood Tether',
      'Bloodletting Curse',
      'Blood Eruption',
      'Blood Lance',
      'Blood Detonation',
      'Blood Curse',
      'Crimson Rain',
      'Sanguine Shield',
      'Vampiric Aura',
      'Blood Walk',
      'Crimson Chains',
      'Blood Ritual',


      'Shield Wall',
      'Taunt',
      'Minor Heal',
      'Strong Heal',
      'Great Heal',

      'Magic Shield',
      'Find Person',
      'Food',
      'Haste',
      'Levitate',
      'Light',

      

     
     
    }
  }
}


local learnedSpells = {}

local function printLearnedSpells()
  print('Learned spells received from server:')
  for k, v in pairs(learnedSpells) do
    print('  ', k)
  end
end

local function onLearnedSpellsOpcode(protocol, opcode, buffer)
  if opcode == GameServerOpcodes.GameServerLearnedSpells then
    print('Raw buffer received:', buffer)
    local data = json.decode(buffer)
    if type(data) ~= 'table' then
      print('ERROR: Decoded data is not a table, got:', type(data), data)
      return
    end
    if data.topic == 'learned-spells' and type(data.spells) == 'table' then
      learnedSpells = {}
      for k, v in pairs(data.spells) do
        print('  spells[', k, '] = ', v)
      end
      for _, spell in ipairs(data.spells) do
        print('Adding learned spell:', spell)
        learnedSpells[spell] = true
      end
      printLearnedSpells()
    else
      print('No valid learned-spells topic or spells field in received data.')
    end
  end
end

ProtocolGame.registerExtendedOpcode(GameServerOpcodes.GameServerLearnedSpells, onLearnedSpellsOpcode)

function getLearnedSpells()
  return learnedSpells
end

function getSpellsForVocation(vocId, learnedSpellsOverride)
  local spells = {}
  for profile, data in pairs(SpellInfo) do
    for name, spell in pairs(data) do
      if table.contains(spell.vocations, vocId) then
        if not spell.needLearn or (learnedSpellsOverride or learnedSpells)[name] then
          table.insert(spells, spell)
        end
      end
    end
  end
  return spells
end

function getAllSpellsForVocation(vocId)
  local spells = {}
  for profile, data in pairs(SpellInfo) do
    for name, spell in pairs(data) do
      if table.contains(spell.vocations, vocId) then
        table.insert(spells, spell)
      end
    end
  end
  return spells
end

function isSpellLearned(spell, learnedSpellsOverride)
  if not spell.needLearn then return true end
  return (learnedSpellsOverride or learnedSpells)[spell.words] or false
end

SpellInfo = {
  ['Custom'] = {

    -- Dragon Knight
    ['Rend'] = {id = 1, words = 'rend', icon = 1, description = 'rend the target dealing physical damage and reaching nearby enemies.', exhaustion = 3000, premium = false, type = 'Instant', mana = 15, level = 1, soul = 0, group = {[1] = 1900}, vocations = {4}},
    ['Brutal Swing'] = {id = 2, words = 'brutal swing', icon = 2, description = 'smash the target dealing high ammounts of physical damage, the targeted area can vary based on one handed or two handed weapon.', exhaustion = 7000, premium = false, type = 'Instant', mana = 60, level = 38, soul = 0, group = {[1] = 1900}, vocations = {4}},
    ['Ripping Slash'] = {id = 3, words = 'ripping slash', icon = 3, description = 'slash your way through enemies dealing physical damage in a small cone area.', exhaustion = 5000, premium = false, type = 'Instant', mana = 30, level = 45, soul = 0, group = {[3] = 1900}, vocations = {4}},
    ['Fire Within'] = {id = 4, words = 'fire within', icon = 4, description = 'ignite yourself into fire to deal fire damage to your nearest enemy and spread it to nearby enemies.', exhaustion = 20000, premium = false, type = 'Instant', mana = 80, level = 1, soul = 0, group = {[1] = 1900}, vocations = {4}, needLearn = true},
    ['Charge'] = {id = 5, words = 'charge', icon = 5, description = 'charge into your target from the distance and stun it for 1 second.', exhaustion = 15000, premium = false, type = 'Instant', mana = 20, level = 60, soul = 0, group = {[3] = 1900}, vocations = {4}},
    ['whirlwind'] = {id = 6, words = 'whirlwind', icon = 6, description = 'slash your surroundings dealing fire damage and igniting all enemies in the area.', exhaustion = 10000, premium = false, type = 'Instant', mana = 110, level = 70, soul = 0, group = {[1] = 1900}, vocations = {4}},
    ['Phoenix Wrath'] = {id = 8, words = 'phoenix wrath', icon = 8, description = 'command a phoenix to attack in a straight line dealing fire damage to all enemies in that direction. [skill+attack]', exhaustion = 17000, premium = false, type = 'Instant', mana = 115, level = 1, soul = 0, group = {[1] = 1900}, vocations = {4}, needLearn = true},
    ['Dragon Aura'] = {id = 9, words = 'dragon aura', icon = 9, description = 'create a dragon aura that deals fire damage to enemies around you.', exhaustion = 35000, premium = false, type = 'Instant', mana = 70, level = 53, soul = 0, group = {[1] = 1900}, vocations = {4}},
    ['Dragons Call'] = {id = 10, words = 'dragons call', icon = 10, description = 'strike your target high a powerfull blow dealing high amounts of fire damage.', exhaustion = 45000, premium = false, type = 'Instant', mana = 180, level = 80, soul = 0, group = {[1] = 1900}, vocations = {4}},
    ['Draconic Chains'] = {id = 11, words = 'draconic chains', icon = 11, description = 'unleash your dragon chains pullin all enemies into you dealing physical damage to all enemies. [magic]', exhaustion = 18000, premium = false, type = 'Instant', mana = 300, level = 1, soul = 0, group = {[3] = 1900}, vocations = {4}, needLearn = true},
    ['Shockwave'] = {id = 12, words = 'shockwave', icon = 12, description = 'stomp the floor creating a shockwave and stunning all enemies in the area for 2 seconds. [skill+attack+magic]', exhaustion = 10000, premium = false, type = 'Instant', mana = 40, level = 1, soul = 0, group = {[1] = 1900}, vocations = {4}, needLearn = true},
    ['Bloodlust'] = {id = 13, words = 'bloodlust', icon = 13, description = 'for the next 8 seconds enter a frenzy state increasing your melee skill, attack speed and critical hit chance by 50%.', exhaustion = 30000, premium = false, type = 'Instant', mana = 85, level = 1, soul = 0, group = {[3] = 1100}, vocations = {4}, needLearn = true},
    ['Dragon Soul'] = {id = 14, words = 'dragon soul', icon = 14, description = 'restore high amounts of max health scaled by your max health percent and magic.', exhaustion = 2000, premium = false, type = 'Instant', mana = 20, level = 1, soul = 0, group = {[2] = 1100}, vocations = {4}, needLearn = true},
    
    -- Templar
    ['Divine Punishment'] = {id = 20, words = 'divine punishment', icon = 20, description = 'call down judgement to a enemy dealing high amounts of holy damage after a shot delay', exhaustion = 60000, premium = false, type = 'Instant', mana = 320, level = 1, soul = 0, group = {[1] = 1900}, vocations = {2}, needLearn = true},
    ['Penitence'] = {id = 21, words = 'penitence', icon = 21, description = 'send a holy shield wich deals holy damage and taunts all enemies. player will be healed based on the damage dealt per every creature hit', exhaustion = 15000, premium = false, type = 'Instant', mana = 100, level = 60, soul = 0, group = {[1] = 1900}, vocations = {2}},
    ['Holy Ground'] = {id = 22, words = 'holy ground', icon = 22, description = 'create a holy ground at your casted position wich will deal damage to enemies who stand inside its radius.', exhaustion = 15000, premium = false, type = 'Instant', mana = 90, level = 53, soul = 0, group = {[1] = 1900}, vocations = {2}},
    ['Sacred Ground'] = {id = 23, words = 'sacred Ground', icon = 23, description = 'create a sacred ground at your casted position wich will heal allies who stand inside its radius.', exhaustion = 30000, premium = false, type = 'Instant', mana = 100, level = 1, soul = 0, group = {[2] = 1900}, vocations = {2}, needLearn = true},
    ['Holy Strike'] = {id = 24, words = 'holy strike', icon = 24, description = 'after a short delay strike your target with a holy sentence.', exhaustion = 8000, premium = false, type = 'Instant', mana = 80, level = 45, soul = 0, group = {[1] = 1900}, vocations = {2}},
    ['Divine Storm'] = {id = 25, words = 'divine storm', icon = 25, description = 'create a holy storm wich deals damage in a radius and heals you and your nearby allies.', exhaustion = 15000, premium = false, type = 'Instant', mana = 130, level = 70, soul = 0, group = {[1] = 1900}, vocations = {2}},
    ['Exorcism'] = {id = 26, words = 'exorcism', icon = 26, description = 'call faith around you several times dealing damage to nearby enemies.', exhaustion = 40000, premium = false, type = 'Instant', mana = 185, level = 80, soul = 0, group = {[1] = 1900}, vocations = {2}},
    ['Smite'] = {id = 27, words = 'smite', icon = 27, description = 'smite your target dealing physical damage after a short delay', exhaustion = 3000, premium = false, type = 'Instant', mana = 20, level = 1, soul = 0, group = {[1] = 1900}, vocations = {2}},
    ['Light Beam'] = {id = 28, words = 'light beam', icon = 28, description = 'create a holy wave wich deals damage based on your direction.', exhaustion = 12000, premium = false, type = 'Instant', mana = 130, level = 53, soul = 0, group = {[1] = 1900}, vocations = {2}},
    ['Summon Guardian of Light'] = {id = 29, words = 'summon guardian', icon = 29, description = 'summon the guardian of light to aid you, healing you and nearby allies while it is active.', exhaustion = 100000, premium = false, type = 'Instant', mana = 250, level = 1, soul = 0, group = {[3] = 1900}, vocations = {2}, needLearn = true},
    ['Kings Blessing'] = {id = 30, words = 'Kings Blessing', icon = 30, description = 'bless you and all party members increasing their combat stats by 8% for 20 minutes.', exhaustion = 1000, premium = false, type = 'Instant', mana = 50, level = 1, soul = 0, group = {[3] = 1900}, vocations = {2}, needLearn = true},
    ['Angelic Form'] = {id = 31, words = 'angelic form', icon = 31, description = 'gain the blessing of angels transforming you into a angel, while this form is active you and all your nearby allies will be constantly healed.', exhaustion = 100000, premium = false, type = 'Instant', mana = 500, level = 1, soul = 0, group = {[3] = 1900}, vocations = {2}, needLearn = true},
    ['Judgement'] = {id = 32, words = 'judgement', icon = 32, description = 'throw a holy hammer to your target wich deals holy damage.', exhaustion = 3800, premium = false, type = 'Instant', mana = 40, level = 38, soul = 0, group = {[1] = 1900}, vocations = {2}},

    --Magician
    ['Frost Blast'] = {id = 40, words = 'frost blast', icon = 40, description = 'shoot 2 frost bolts that deal frost damage to your target and reduce its movement speed.', exhaustion = 3000, premium = false, type = 'Instant', mana = 35, level = 1, soul = 0, group = {[1] = 1900}, vocations = {1}},
    ['Energy Blast'] = {id = 41, words = 'energy blast', icon = 41, description = 'cast a energy blast wich restore mana on impact and deals energy damage to your target.', exhaustion = 3000, premium = false, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[1] = 1900}, vocations = {1}},
    ['Fire Blast'] = {id = 42, words = 'fire blast', icon = 42, description = 'cast a fire blast wich deals fire damage in a small radius.', exhaustion = 3000, premium = false, type = 'Instant', mana = 40, level = 1, soul = 0, group = {[1] = 1900}, vocations = {1}},
    ['Ice Nova'] = {id = 44, words = 'ice nova', icon = 44, description = 'create a ice nova wich extends from your current position slowing all enemies in its radius.', exhaustion = 25000, premium = false, type = 'Instant', mana = 115, level = 38, soul = 0, group = {[1] = 1900}, vocations = {1}},
    ['Mana Distortion'] = {id = 46, words = 'mana distortion', icon = 46, description = 'creates a distortion field wich increases magic level by 20% and restore mana to allies who stand inside its radius', exhaustion = 120000, premium = false, type = 'Instant', mana = 0, level = 100, soul = 0, group = {[3] = 1900}, vocations = {1}},
    ['Mana Flow'] = {id = 47, words = 'mana flow', icon = 47, description = 'restores a percentage of your max mana every second for 8 seconds.', exhaustion = 33000, premium = false, type = 'Instant', mana = 0, level = 53, soul = 0, group = {[2] = 1900}, vocations = {1}},
    ['Hand of God'] = {id = 48, words = 'hand of god', icon = 48, description = 'slam the ground creating a fire explosion dealing damage to all enemies in its radius.', exhaustion = 7000, premium = false, type = 'Instant', mana = 130, level = 1, soul = 0, group = {[1] = 1900}, vocations = {1}, needLearn = true},
    ['Frost Wave'] = {id = 49, words = 'frost wave', icon = 49, description = 'send a frozen wave into your faced direction wich stuns and freeze in aplce all enemies reached.', exhaustion = 15000, premium = false, type = 'Instant', mana = 230, level = 1, soul = 0, group = {[1] = 1900}, vocations = {1}, needLearn = true},
    ['Arcane Missiles'] = {id = 51, words = 'arcane missiles', icon = 51, description = 'shoot a group of missiles wich deals energy damage to your target.', exhaustion = 4000, premium = false, type = 'Instant', mana = 130, level = 1, soul = 0, group = {[1] = 1900}, vocations = {1}, needLearn = true},
    ['Teleport'] = {id = 52, words = 'teleport', icon = 52, description = 'insstantly teleport yourself forwards, this effect can affected by objects', exhaustion = 12000, premium = false, type = 'Instant', mana = 150, level = 60, soul = 0, group = {[3] = 1900}, vocations = {1}},
    ['Blizzard'] = {id = 53, words = 'blizzard', icon = 53, description = 'create a blizzard storm into your target position dealing ice damage while it is active.', exhaustion = 15000, premium = false, type = 'Instant', mana = 300, level = 45, soul = 0, group = {[1] = 1900}, vocations = {1}, crosshair = true, area = 'AREA_BLIZZARD', range = 7, areaSprite = 1178},
    ['Hells Core'] = {id = 54, words = 'hells core', icon = 54, description = 'a meteor fall at your target position dealing massive fire damage.', exhaustion = 55000, premium = false, type = 'Instant', mana = 400, level = 1, soul = 0, group = {[1] = 1900}, vocations = {1}, needLearn = true, crosshair = true, area = 'AREA_HELLS_CORE', range = 7, areaSprite = 1178},
    ['Ice Barrage'] = {id = 55, words = 'ice barrage', icon = 55, description = 'shoot a group of icicles wich deals ice damage to your target.', exhaustion = 9000, premium = false, type = 'Instant', mana = 130, level = 38, soul = 0, group = {[1] = 1900}, vocations = {1}},
    ['Ice Wall'] = {id = 56, words = 'ice wall', icon = 56, description = 'create a ice wall wich extends horizontally blocking paths and enemies.', exhaustion = 12000, premium = false, type = 'Instant', mana = 200, level = 70, soul = 0, group = {[3] = 1900}, vocations = {1}},
    ['Ice Clones'] = {id = 57, words = 'ice clones', icon = 57, description = 'create a 4 clones of yourself wich will follow you and deal ice damage to enemies.', exhaustion = 70000, premium = false, type = 'Instant', mana = 350, level = 1, soul = 0, group = {[1] = 1900}, vocations = {1}, needLearn = true},
    ['Eruption'] = {id = 58, words = 'eruption', icon = 58, description = 'prepare a area for eruption, wich explodes after a quick delay dealing fire damage to all enemies reached.', exhaustion = 4000, premium = false, type = 'Instant', mana = 140, level = 60, soul = 0, group = {[1] = 1900}, vocations = {1}},
    ['Glacial Steps'] = {id = 59, words = 'glacial steps', icon = 59, description = 'leave a trail of ice traps while walking wich slow down enemies on contact.', exhaustion = 50000, premium = false, type = 'Instant', mana = 115, level = 42, soul = 0, group = {[1] = 2000}, vocations = {1}},
    
    --Warlock
    ['Zombie Wall'] = {id = 61, words = 'zombie wall', icon = 61, description = 'create a zombie wall wich extends horizontally 2 tiles from your current position.', exhaustion = 20000, premium = false, type = 'Instant', mana = 80, level = 1, soul = 0, group = {[3] = 1900}, vocations = {5}, needLearn = true},
    ['Curse'] = {id = 62, words = 'curse', icon = 62, description = 'curse your target dealing death damage for 6 seconds.', exhaustion = 2000, premium = false, type = 'Instant', mana = 30, level = 1, soul = 0, group = {[1] = 1900}, vocations = {5}},
    ['Fear'] = {id = 63, words = 'fear', icon = 63, description = 'fear your target for 6 seconds wich makes it unable to control itself.', exhaustion = 30000, premium = false, type = 'Instant', mana = 150, level = 70, soul = 0, group = {[3] = 1900}, vocations = {5}},
    ['Shadow Strike'] = {id = 64, words = 'shadow strike', icon = 64, description = 'send a shadow bolt to your target dealing shadow damage.', exhaustion = 7000, premium = false, type = 'Instant', mana = 65, level = 38, soul = 0, group = {[1] = 1900}, vocations = {5}},
    ['Summon Void Mender'] = {id = 65, words = 'summon void mender', icon = 65, description = 'summon a void mender wich heals injured allies or summons.', exhaustion = 5000, premium = false, type = 'Instant', mana = 300, level = 1, soul = 0, group = {[3] = 1900}, vocations = {5}, needLearn = true},
    ['Blood Pact'] = {id = 66, words = 'blood pact', icon = 66, description = 'exchage a percentage of your max health for mana.', exhaustion = 1500, premium = false, type = 'Instant', mana = 0, level = 60, soul = 0, group = {[2] = 0}, vocations = {5}},
    ['Party Vitality'] = {id = 67, words = 'Party Vitality', icon = 67, description = 'increase the max health of you and your party members by 10% for 20 minutes.', exhaustion = 8000, premium = false, type = 'Instant', mana = 200, level = 53, soul = 0, group = {[3] = 1900}, vocations = {5}},
    ['Summon Void Guard'] = {id = 68, words = 'summon void guard', icon = 68, description = 'summon a void guard taunts nearby enemies and has a larger health pool.', exhaustion = 4000, premium = false, type = 'Instant', mana = 480, level = 1, soul = 0, group = {[3] = 1900}, vocations = {5}, needLearn = true},
    ['Summon Void Sentinel'] = {id = 69, words = 'summon void sentinel', icon = 69, description = 'summon a void sentinel wich damages enemies from the distance.', exhaustion = 60000, premium = false, type = 'Instant', mana = 300, level = 60, soul = 0, group = {[3] = 1900}, vocations = {5}, needLearn = false},
    ['Blood Wall'] = {id = 70, words = 'blood wall', icon = 70, description = 'increase your defense stat and max hitpoints for 15 seconds.', exhaustion = 50000, premium = false, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[3] = 1900}, vocations = {5}},
    ['Dark Plague'] = {id = 71, words = 'dark plague', icon = 71, description = 'curse your target and all nearby enemies dealing death damage over 15 seconds.', exhaustion = 50000, premium = false, type = 'Instant', mana = 300, level = 1, soul = 0, group = {[1] = 2000}, vocations = {5}, needLearn = true},
    ['Soul Rain'] = {id = 74, words = 'soul rain', icon = 74, description = 'cast a rain of death over your target position dealing death damage over 8 seconds.', exhaustion = 45000, premium = false, type = 'Instant', mana = 200, level = 80, soul = 0, group = {[1] = 2000}, vocations = {5}, crosshair = true, area = 'AREA_CIRCLE3X3', range = 7, areaSprite = 1178},
    ['Drain Soul'] = {id = 75, words = 'drain soul', icon = 75, description = 'drain the souls of nearby enemies healing yourself and dealing death damage.', exhaustion = 15000, premium = false, type = 'Instant', mana = 150, level = 53, soul = 0, group = {[1] = 2000}, vocations = {5}},
    ['Malediction'] = {id = 76, words = 'malediction', icon = 76, description = 'cast a strong plague to your target that deals death damage on impact.', exhaustion = 8000, premium = false, type = 'Instant', mana = 150, level = 1, soul = 0, group = {[1] = 2000}, vocations = {5}, needLearn = true},
    ['Haunt'] = {id = 77, words = 'haunt', icon = 77, description = 'haunts the target and apply a curse to it and nearby enemies after impact wich last 10 seconds.', exhaustion = 2000, premium = false, type = 'Instant', mana = 250, level = 1, soul = 0, group = {[1] = 2000}, vocations = {5}, needLearn = true},
    ['Dark Aura'] = {id = 78, words = 'dark aura', icon = 78, description = 'infuse yourself with a dark aura that reduce all damage taken by 25%.', exhaustion = 2000, premium = false, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[3] = 2000}, vocations = {5}, needLearn = true},
   
    --Nightblade
    ['Stealth'] = {id = 80, words = 'stealth', icon = 80, description = 'enter stealth for 2.5 seconds wich makes you invisible to enemies and damage.', exhaustion = 60000, premium = false, type = 'Instant', mana = 110, level = 80, soul = 0, group = {[3] = 5000}, vocations = {3}},
    ['Mutilate'] = {id = 81, words = 'mutilate', icon = 81, description = 'mutilate your target 4 times in a row dealing physical damage.', exhaustion = 3000, premium = false, type = 'Instant', mana = 20, level = 1, soul = 0, group = {[1] = 1900}, vocations = {3}},
    ['Shadow Hunt'] = {id = 82, words = 'shadow hunt', icon = 82, description = 'cast a hunting blade over your target that deals shadow damage 4 times in a row.', exhaustion = 6000, premium = false, type = 'Instant', mana = 60, level = 38, soul = 0, group = {[1] = 1900}, vocations = {3}},
    ['Shadowstep'] = {id = 83, words = 'shadowstep', icon = 83, description = 'shadow step before your target appearing behind it and stuning it for a small duration.', exhaustion = 20000, premium = false, type = 'Instant', mana = 50, level = 70, soul = 0, group = {[3] = 1900}, vocations = {3}},
    ['Backstab'] = {id = 84, words = 'backstab', icon = 84, description = 'backstab your target dealing physical damage wich stuns it for 2 seconds.', exhaustion = 8000, premium = false, type = 'Instant', mana = 50, level = 53, soul = 0, group = {[1] = 0}, vocations = {3}},
    ['Assassination'] = {id = 85, words = 'assassination', icon = 85, description = 'assassinate all nearby enemies teleporting you into them for a breaf period of time making you untargetable.', exhaustion = 22000, premium = false, type = 'Instant', mana = 250, level = 1, soul = 0, group = {[1] = 1900}, vocations = {3}, needLearn = true},
    ['Fan of Knives'] = {id = 86, words = 'fan of knives', icon = 86, description = 'sprays knives at all enemies around your dealing physical damage and applie a poison effect.', exhaustion = 5000, premium = false, type = 'Instant', mana = 120, level = 60, soul = 0, group = {[1] = 1900}, vocations = {3}},
    ['Shadow Form'] = {id = 87, words = 'shadow form', icon = 87, description = 'enter a shadow state that heals you for the duration.', exhaustion = 30000, premium = false, type = 'Instant', mana = 65, level = 80, soul = 0, group = {[3] = 3000}, vocations = {3}},
    ['Dark Rupture'] = {id = 88, words = 'dark rupture', icon = 88, description = 'create a rupture into your target wich deals physical damage, if the target is stunned it will apply a bleeding effect.', exhaustion = 7000, premium = false, type = 'Instant', mana = 50, level = 45, soul = 0, group = {[1] = 1900}, vocations = {3}},
    ['Void Execution'] = {id = 89, words = 'void execution', icon = 89, description = 'executes all nearby enemies while their health is below 30%, this effect is changed to 20% for players.', exhaustion = 22000, premium = false, type = 'Instant', mana = 200, level = 1, soul = 0, group = {[1] = 1900}, vocations = {3}, needLearn = true},
    ['Blood Blades'] = {id = 90, words = 'blood blades', icon = 90, description = 'enter a bloody state wich heals you everytime you land a melee hit.', exhaustion = 25000, premium = false, type = 'Instant', mana = 0, level = 80, soul = 0, group = {[3] = 1900}, vocations = {3}},
    ['Lethal Dagger'] = {id = 91, words = 'lethal dagger', icon = 91, description = 'throw a lethal dagger at your target dealing physical damage.', exhaustion = 4000, premium = false, type = 'Instant', mana = 50, level = 38, soul = 0, group = {[1] = 0}, vocations = {3}},
    ['Blackout'] = {id = 92, words = 'blackout', icon = 92, description = 'hit your target with a dark force stunnin it for 4 seconds.', exhaustion = 16000, premium = false, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[1] = 0}, vocations = {3}, needLearn = true},
   
   --Stellar
    ['Cosmic Force'] = {id = 100, words = 'cosmic force', icon = 100, description = 'after a short delay send a force ball at your target dealing energy damage.', exhaustion = 3000, premium = false, type = 'Instant', mana = 40, level = 1, soul = 0, group = {[1] = 1900}, vocations = {6}},
    ['Aery Wrath'] = {id = 102, words = 'aery wrath', icon = 102, description = 'send aery into combat making her travel through your target and all enemies around it dealing holy damage.', exhaustion = 15000, premium = false, type = 'Instant', mana = 160, level = 45, soul = 0, group = {[1] = 1900}, vocations = {6}},
    ['Starfall'] = {id = 103, words = 'starfall', icon = 103, description = 'call a starfall over your target position dealing energy damage and restoring mana.', exhaustion = 5000, premium = false, type = 'Instant', mana = 0, level = 38, soul = 0, group = {[1] = 0}, vocations = {6}},
    ['Falling Star'] = {id = 104, words = 'falling star', icon = 104, description = 'call down a falling star over your target dealing damage and stunning it for 3 seconds..', exhaustion = 12000, premium = false, type = 'Instant', mana = 170, level = 60, soul = 0, group = {[1] = 1900}, vocations = {6}},
    ['Rain fall'] = {id = 105, words = 'rain fall', icon = 105, description = 'create a safe zone where rain falls and heals all allies who stand in it.', exhaustion = 30000, premium = false, type = 'Instant', mana = 200, level = 53, soul = 0, group = {[2] = 1900}, vocations = {6}, crosshair = true, area = 'AREA_RAIN_FALL', range = 7, areaSprite = 1178},
    ['Magic Walls'] = {id = 107, words = 'magic walls', icon = 107, description = 'create a sequence of magic walls that block paths, each consecutive wall will be placed based on the direction you are facing at that moment.', exhaustion = 60000, premium = false, type = 'Instant', mana = 100, level = 80, soul = 0, group = {[3] = 1900}, vocations = {6}},
    ['Lunar Beam'] = {id = 108, words = 'lunar beam', icon = 108, description = 'create a beam of lunar light that deals energy damage.', exhaustion = 20000, premium = false, type = 'Instant', mana = 285, level = 80, soul = 0, group = {[1] = 1900}, vocations = {6}},
    ['Aery Strikes'] = {id = 109, words = 'aery strikes', icon = 109, description = 'aery strikes the target 3 times in a row dealing holy damage.', exhaustion = 15000, premium = false, type = 'Instant', mana = 120, level = 70, soul = 0, group = {[1] = 1900}, vocations = {6}},
    ['Full Moon'] = {id = 111, words = 'full moon', icon = 111, description = 'for the next 8 seconds starfall will trigger constantly on all nearby enemies.', exhaustion = 90000, premium = false, type = 'Instant', mana = 300, level = 1, soul = 0, group = {[2] = 1900}, vocations = {6}, needLearn = true},
    ['Moonlight'] = {id = 112, words = 'moonlight', icon = 112, description = 'strong heal, that heals your friendly target, this spell consumes 12% of your max mana.', exhaustion = 2000, premium = false, parameter = true, type = 'Instant', mana = 100, level = 60, soul = 0, group = {[2] = 1900}, vocations = {6}},
    ['Holy Flare'] = {id = 113, words = 'holy flare', icon = 113, description = 'send a strong holy flare at your target and nearby enemies dealing holy damage and applying a short duration fear.', exhaustion = 17000, premium = false, type = 'Instant', mana = 220, level = 1, soul = 0, group = {[2] = 1900}, vocations = {6}, needLearn = true},
    ['Solar Blessing'] = {id = 114, words = 'solar blessing', icon = 114, description = 'Increase a friendly target max health by 65% for 8 seconds and heal them instantly for 50% of your max mana at the start and ending of spell.', exhaustion = 45000, parameter = true, premium = false, type = 'Instant', mana = 500, level = 1, soul = 0, group = {[2] = 1900}, vocations = {6}, needLearn = true},
    ['Astral Infusion'] = {id = 115, words = 'astral infusion', icon = 115, description = 'Bless you and all party members with a 3% critical hit chance for 20 minutes.', exhaustion = 2000, premium = false, type = 'Instant', mana = 50, level = 60, soul = 0, group = {[3] = 1900}, vocations = {6}},
    

    --Monk
    ['Lotus Kick'] = {id = 127, words = 'lotus kick', icon = 127, description = 'powerfull kick that pulls in and out enemies and grants you 2 random chi orbs.', exhaustion = 25000, premium = false, type = 'Instant', mana = 80, level = 53, soul = 0, group = {[3] = 0}, vocations = {7}},
    ['Adaptive Punch'] = {id = 128, words = 'adaptive punch', icon = 128, description = 'advance technique that adapts based on the current 2 chi orbs combination you have.', exhaustion = 7000, premium = false, type = 'Instant', mana = 70, level = 38, soul = 0, group = {[3] = 2000}, vocations = {7}},
    ['Fire Punch'] = {id = 129, words = 'fire punch', icon = 129, description = 'send a flaming fist at your target dealing fire damage and burning the target for 3 seconds.', exhaustion = 3000, premium = false, type = 'Instant', mana = 30, level = 1, soul = 0, group = {[1] = 1900}, vocations = {7}},
    ['Ice Punch'] = {id = 130, words = 'ice punch', icon = 130, description = 'send a icy fist at your target dealing ice damage and freezing the target for 1 second.', exhaustion = 3000, premium = false, type = 'Instant', mana = 22, level = 8, soul = 0, group = {[1] = 1900}, vocations = {7}},
    ['Life Punch'] = {id = 131, words = 'life punch', icon = 131, description = 'send a life fist at your target dealing physical damage and healing yourself.', exhaustion = 3000, premium = false, type = 'Instant', mana = 45, level = 8, soul = 0, group = {[2] = 1900}, vocations = {7}},
    ['Fist of Fire'] = {id = 132, words = 'fist of fire', icon = 132, description = 'after spending 2 fire chi orbs, send a flurry of blows wich deals fire damage.', exhaustion = 12000, premium = false, type = 'Instant', mana = 115, level = 80, soul = 0, group = {[1] = 3000}, vocations = {7}},
    ['Volcanic Dash'] = {id = 133, words = 'volcanic dash', icon = 133, description = 'call the turtle spirit and dash to to your target dealing fire damage on impact.', exhaustion = 12000, premium = false, type = 'Instant', mana = 30, level = 45, soul = 0, group = {[1] = 3000}, vocations = {7}},
    ['Stormfist'] = {id = 134, words = 'stormfist', icon = 134, description = 'for the next 3 seconds your physical damage sends a lighting shock to a nearby enemies.', exhaustion = 20000, premium = false, type = 'Instant', mana = 350, level = 1, soul = 0, group = {[1] = 0}, vocations = {7}, needLearn = true},
    ['Mountain Stance'] = {id = 135, words = 'mountain stance', icon = 135, description = 'for the next 10 seconds reduce damage taken by 30% and increases your max health by 25%', exhaustion = 50000, premium = false, type = 'Instant', mana = 80, level = 1, soul = 0, group = {[3] = 1900}, vocations = {7}, needLearn = true},
    ['Zen Barrier'] = {id = 136, words = 'zen barrier', icon = 136, description = 'Place a serenity sphere on a chosen player for 8 seconds. Each time they take damage, the sphere absorbs the damage and instantly heals them for the same amount.', exhaustion = 45000, parameter = true, premium = false, type = 'Instant', mana = 350, level = 1, soul = 0, group = {[2] = 1900}, vocations = {7}, needLearn = true},
    ['Mystic Fist'] = {id = 137, words = 'mystic fist', icon = 137, description = 'spend any orb combination to cast a powerfull strike.', exhaustion = 20000, premium = false, type = 'Instant', mana = 220, level = 70, soul = 0, group = {[1] = 1900}, vocations = {7}},
    ['Crane Stance'] = {id = 138, words = 'crane stance', icon = 138, description = 'adopt the crane stance to increase your and all party members attack speed by 5% for 20 minutes.', exhaustion = 2000, premium = false, type = 'Instant', mana = 200, level = 60, soul = 0, group = {[3] = 1900}, vocations = {7}},
    ['Fist of Ice'] = {id = 139, words = 'fist of ice', icon = 139, description = 'after spending 2 ice chi orbs, send a flurry of blows wich deals ice damage and slows all enemies while being casted.', exhaustion = 12000, premium = false, type = 'Instant', mana = 115, level = 80, soul = 0, group = {[1] = 3000}, vocations = {7}},
    ['Fist of Life'] = {id = 140, words = 'fist of life', icon = 140, description = 'after spending 2 life chi orbs, send a flurry of blows wich heals all reached allies while being casted.', exhaustion = 12000, premium = false, type = 'Instant', mana = 250, level = 80, soul = 0, group = {[2] = 3000}, vocations = {7}},
    
    --Druid
    ['Terra Strike'] = {id = 150, words = 'terra strike', icon = 150, description = 'send a terra strike at your target dealing earth damage on a small area.', exhaustion = 3000, premium = false, type = 'Instant', mana = 25, level = 1, soul = 0, group = {[1] = 1900}, vocations = {8}},
    ['Life Bloom'] = {id = 152, words = 'life bloom', icon = 152, description = 'apply a powerfull bloom wich heals overtime you and all party members for 6 seconds. this spell will consume 25% of your max mana.', exhaustion = 8000, premium = false, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[2] = 1900}, vocations = {8}, needLearn = true},
    ['Rejuvenation'] = {id = 153, words = 'rejuvenation', icon = 153, description = 'apply a rejuvenation effect to yourself wich heals overtime for 10 seconds.', exhaustion = 11000, premium = false, type = 'Instant', mana = 105, level = 53, soul = 0, group = {[2] = 1900}, vocations = {8}},
    ['Insect Swarm'] = {id = 154, words = 'insect swarm', icon = 154, description = 'cast a swarm of insects to your target wich deals nature damage and applies a infection effect to all nerby enemies on wich it can spread.', exhaustion = 15000, premium = false, type = 'Instant', mana = 220, level = 1, soul = 0, group = {[1] = 1900}, vocations = {8}, needLearn = true},
    ['Travel Form'] = {id = 155, words = 'travel form', icon = 155, description = 'turn into your travel form, wich allows you to move faster but unable to cast spells.', exhaustion = 2000, premium = false, type = 'Instant', mana = 60, level = 60, soul = 0, group = {[3] = 2000}, vocations = {8}},
    ['Carnivorous Vile'] = {id = 156, words = 'carnivorous vile', icon = 156, description = 'cast a carnivorous vile wich devours its target dealing earth damage, if your target was infected by poison/earth/nature it does extra damage.', exhaustion = 5000, premium = false, type = 'Instant', mana = 85, level = 38, soul = 0, group = {[1] = 1900}, vocations = {8}},
    ['living ground'] = {id = 157, words = 'living ground', icon = 157, description = 'place a restoring field on the ground wich heals all allies while they stand on it.', exhaustion = 35000, premium = false, type = 'Instant', mana = 200, level = 1, soul = 0, group = {[2] = 1900}, vocations = {8}, needLearn = true, crosshair = true, area = 'AREA_LIVING_GROUND', range = 5, areaSprite = 1178},
    ['Piercing Wave'] = {id = 159, words = 'piercing wave', icon = 159, description = 'send a piercing wave that deals physical damage.', exhaustion = 8000, premium = false, type = 'Instant', mana = 155, level = 45, soul = 0, group = {[1] = 1900}, vocations = {8}},
    ['Bear Form'] = {id = 160, words = 'bear form', icon = 160, description = 'turn into your bear form, wich increases your max health by 100% , heals yourself but reduces your damage done by 50% and movement speed.', exhaustion = 35000, premium = false, needLearn = true, type = 'Instant', mana = 60, level = 1, soul = 0, group = {[3] = 2000}, vocations = {8}},
    ['Bless of the Forest'] = {id = 161, words = 'bless of the forest', icon = 161, description = 'infuse you and all party members with the blessing of the forest wich restores 1% of max hp and max mana every 3 seconds for 20 minutes', exhaustion = 2000, premium = false, type = 'Instant', mana = 250, level = 70, soul = 0, group = {[3] = 2000}, vocations = {8}},
    ['Wrath of Nature'] = {id = 162, words = 'wrath of nature', icon = 162, description = 'cast a thunderstorm at your target position wich deals earth damage.', exhaustion = 26000, premium = false, type = 'Instant', mana = 380, level = 80, soul = 0, group = {[1] = 1900}, vocations = {8}, crosshair = true, area = 'AREA_WRATH_OF_NATURE', range = 5, areaSprite = 1178},
    ['Focus Healing'] = {id = 165, words = 'focus healing', icon = 165, description = 'strong heal, that heals your friendly target', exhaustion = 1000, parameter = true, premium = false, type = 'Instant', mana = 140, level = 60, soul = 0, group = {[2] = 1900}, vocations = {8}},
    ['Ice Shatter'] = {id = 166, words = 'ice shatter', icon = 166, description = 'create a ice block wich deals ice damage and it shatters itself to deal ice damage to all enemies in its radius.', exhaustion = 5000, premium = false, type = 'Instant', mana = 120, level = 1, soul = 0, group = {[1] = 1900}, vocations = {8}, needLearn = true},
    ['Frost Armor'] = {id = 168, words = 'frost armor', icon = 168, description = 'cast a frost armor wich reduces damage taken by 20% and deals ice damage back to the attacker for 9 seconds.', exhaustion = 5000, premium = false, type = 'Instant', mana = 80, level = 1, soul = 0, group = {[1] = 1900}, vocations = {8}, needLearn = true},
    ['Ice Strike'] = {id = 169, words = 'ice strike', icon = 169, description = 'send an ice strike that chills the target and triggers a short delayed shard burst around it.', exhaustion = 3000, premium = false, type = 'Instant', mana = 35, level = 8, soul = 0, group = {[1] = 1900}, vocations = {8}},

    --light dancer
    ['Charged Strike'] = {id = 170, words = 'charged strike', icon = 170, description = 'strike the target with a energy charged strike, if the target is affected by static charge it will trigger a second time.', exhaustion = 3000, premium = false, type = 'Instant', mana = 15, level = 1, soul = 0, group = {[1] = 1900}, vocations = {9}},
    ['Static Charge'] = {id = 171, words = 'static charge', icon = 171, description = 'apply a static charge to yourself wich deals energy damage over time.', exhaustion = 2200, premium = false, type = 'Instant', mana = 30, level = 38, soul = 0, group = {[1] = 0}, vocations = {9}},
    ['Light Dash'] = {id = 172, words = 'light dash', icon = 172, description = 'dash to the target position and deal energy damage on impact.', exhaustion = 6000, premium = false, type = 'Instant', mana = 20, level = 53, soul = 0, group = {[1] = 0}, vocations = {9}},
    ['Veil of Swords'] = {id = 174, words = 'veil of swords', icon = 174, description = 'slash at lightning speed multiple times around yourself dealing physical damage.', exhaustion = 15000, premium = false, type = 'Instant', mana = 65, level = 45, soul = 0, group = {[3] = 1900}, vocations = {9}},
    ['Magnetic Shield'] = {id = 175, words = 'magnetic shield', icon = 175, description = 'gain damage immunity for 5 seconds to all damage types but reduce your damage done by 80%', exhaustion = 45000, premium = false, type = 'Instant', mana = 115, level = 1, soul = 0, group = {[3] = 0}, vocations = {9}, needLearn = true},
    ['Lightning Spear'] = {id = 176, words = 'lightning spear', icon = 176, description = 'send a lightning spear to the target that deals energy damage to all nearby enemies and also applies a static charge on impact.', exhaustion = 12000, premium = false, type = 'Instant', mana = 55, level = 38, soul = 0, group = {[1] = 1900}, vocations = {9}},
    ['Overcharge'] = {id = 177, words = 'overcharge', icon = 177, description = 'gain a temporary 40% boost to your offensive skills for 8 seconds.', exhaustion = 30000, premium = false, type = 'Instant', mana = 115, level = 70, soul = 0, group = {[3] = 0}, vocations = {9}},
    ['Elusive Blade'] = {id = 178, words = 'elusive blade', icon = 178, description = 'slash your target with a strong strike dealing physical damage.', exhaustion = 9000, premium = false, type = 'Instant', mana = 65, level = 1, soul = 0, group = {[1] = 1900}, vocations = {9}, needLearn = true},
    ['Magnetic Orb'] = {id = 179, words = 'magnetic orb', icon = 179, description = 'create a magnetic orb at your target position that deals energy damage to all nearby enemies on its path.', exhaustion = 26000, premium = false, type = 'Instant', mana = 190, level = 80, soul = 0, group = {[1] = 1900}, vocations = {9}, crosshair = true, area = 'AREA_MAGNETIC_ORB', range = 3, areaSprite = 1178},
    ['Tempest Coin'] = {id = 180, words = 'tempest coin', icon = 180, description = 'toss a tempest coin in the air that will grant you Tempest Charges, Tempest charges will determine the times charged strike will be triggered on next cast based on token results (1-3)', exhaustion = 22000, premium = false, type = 'Instant', mana = 115, level = 1, soul = 0, group = {[3] = 0}, vocations = {9}, needLearn = true},

    --Archer
    ['Flaming Shot'] =              {id = 181, words = 'flaming shot', icon = 181, exhaustion = 3000, premium = false, type = 'Instant', mana = 20, level = 1, soul = 0, group = {[1] = 1900}, parameter = false, vocations = {10}, description = 'shoot a flaming shot to the target dealing fire damage and burning the target (based on your ml), if the target is affected by beer barrel this spell will be powered and deal target max health damage. [Weapon Damage, DISTANCE, MAGIC LEVEL] & [Target MxHP]'},
    ['Explosive Barrel'] =          {id = 182, words = 'explosive barrel', icon = 182, exhaustion = 15000, premium = false, type = 'Instant', mana = 150, level = 1, soul = 0, group = {[3] = 1900}, parameter = false, vocations = {10}, description = 'throws an explosive barrel that explodes after a short time duration, dealing area damage.', needLearn = true, crosshair = true, area = 'AREA_EXPLOSIVE_BARREL', range = 5, areaSprite = 1178},
    ['Explosive Shot'] =            {id = 183, words = 'explosive shot', icon = 183, exhaustion = 7000, premium = false, type = 'Instant', mana = 70, level = 1, soul = 0, group = {[1] = 1900}, parameter = false, vocations = {10}, description = 'shoot 4 rounds of explosive shots dealing aoe damage to the target location, if the target is affected by beer barrel this spell will be powered and deal target max health damage. [Weapon Damage, DISTANCE]',needLearn = true},
    ['Wind Barrel'] =               {id = 184, words = 'wind barrel', icon = 184, exhaustion = 22000, premium = false, type = 'Instant', mana = 25, level = 53, soul = 0, group = {[3] = 1900}, parameter = false, vocations = {10}, description = 'creates a wind barrel that explodes after a short time duration increasing your movement speed drastically.', crosshair = true, area = 'AREA_WIND_BARREL', range = 5, areaSprite = 1178},
    ['Condemn Shot'] =              {id = 185, words = 'condemn shot', icon = 185, exhaustion = 25000, premium = false, type = 'Instant', mana = 60, level = 60, soul = 0, group = {[3] = 1900}, parameter = false, vocations = {10}, description = 'repels your target away from the caster. [Weapon Damage, DISTANCE]'},
    ['Healing Barrel'] =            {id = 187, words = 'healing barrel', icon = 187, exhaustion = 20000, premium = false, type = 'Instant', mana = 200, level = 60, soul = 0, group = {[2] = 1900}, parameter = false, vocations = {10}, description = 'creates a healing barrel that explodes after a short time duration healing all players in the area.', crosshair = true, area = 'AREA_HEALING_BARREL', range = 5, areaSprite = 1178},
    ['Arrow rain'] =                {id = 188, words = 'arrow rain', icon = 188, exhaustion = 15000, premium = false, type = 'Instant', mana = 200, level = 80, soul = 0, group = {[1] = 1900}, parameter = false, vocations = {10}, description = 'cast a arrow rain into the target dealing physical damage to all enemies in the area.[Weapon Damage, DISTANCE]', crosshair = true, area = 'AREA_ARROW_RAIN', range = 7, areaSprite = 1178},
    ['Frost Barrel'] =              {id = 189, words = 'frost barrel', icon = 189, exhaustion = 15000, premium = false, type = 'Instant', mana = 150, level = 1, soul = 0, group = {[3] = 1900}, parameter = false, vocations = {10}, description = 'creates a frost barrel that explodes after a short time duration freezing all enemies in the area.',needLearn = true},
    ['Phantom Shot'] =              {id = 190, words = 'phantom shot', icon = 190, exhaustion = 6000, premium = false, type = 'Instant', mana = 35, level = 1, soul = 0, group = {[1] = 1900}, parameter = false, vocations = {10}, description = 'shoots a phantom shot at the target, dealing high damage. [Weapon Damage, DISTANCE]',needLearn = true},
    ['Arrow Barrage'] =             {id = 191, words = 'arrow barrage', icon = 191, exhaustion = 16000, premium = false, type = 'Instant', mana = 115, level = 45, soul = 0, group = {[1] = 1900}, parameter = false, vocations = {10}, description = 'shoot multiple dark shots into all nearby enemies dealing physical damage. [Weapon Damage, DISTANCE]'},
    ['Rapid Fire'] =                {id = 192, words = 'rapid fire', icon = 192, exhaustion = 6000, premium = false, type = 'Instant', mana = 55, level = 38, soul = 0, group = {[1] = 1900}, parameter = false, vocations = {10}, description = 'shoots a rapid succession of arrows at the target. [Weapon Damage, DISTANCE]'},
    ['Ice Arrow'] =                 {id = 193, words = 'ice arrow', icon = 193, exhaustion = 3000, premium = false, type = 'Instant', mana = 50, level = 1, soul = 0, group = {[1] = 1900}, parameter = false, vocations = {10}, description = 'shoots an ice arrow at the target, dealing ice damage and slowing the target. [Weapon Damage, DISTANCE]',needLearn = true},
    ['Falcon Shot'] =               {id = 194, words = 'falcon shot', icon = 194, exhaustion = 13000, premium = false, type = 'Instant', mana = 120, level = 1, soul = 0, group = {[1] = 1900}, parameter = false, vocations = {10}, description = 'shoots a falcon shot at the target, dealing high damage. [Weapon Damage, DISTANCE]',needLearn = true},
    

    --others
    ['Shield Wall'] = {id = 203, words = 'shield wall', icon = 204, description = 'Increase your defense skill and block value by 30%, requires a shield or offhand to be equiped.', exhaustion = 2000, premium = false, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[2] = 2000}, vocations = {2,4,7,8,15}},
    ['Taunt'] = {id = 220, words = 'taunt', icon = 220, description = 'Taunt all nearby enemies forcing them to attack you.', exhaustion = 2000, premium = false, type = 'Instant', mana = 20, level = 1, soul = 0, group = {[2] = 1900}, vocations = {2,4,7,8,15}},


    ['Minor Heal'] = {id = 200, words = 'minor heal', icon = 200, description = 'personal minor heal', exhaustion = 2000, premium = false, type = 'Instant', mana = 20, level = 1, soul = 0, group = {[2] = 1900}, vocations = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}},
    ['Strong Heal'] = {id = 201, words = 'strong heal', icon = 201, description = 'personal strong heal', exhaustion = 2000, premium = false, type = 'Instant', mana = 65, level = 50, soul = 0, group = {[2] = 1900}, vocations = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}},
    ['Great Heal'] = {id = 202, words = 'great heal', icon = 202, description = 'personal great heal', exhaustion = 2000, premium = false, type = 'Instant', mana = 120, level = 100, soul = 0, group = {[2] = 1900}, vocations = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}},

    ['Magic Shield'] = {id = 208, words = 'magic shield', icon = 208, description = 'Creates a protective barrier that absorbs damage.', exhaustion = 2000, premium = false, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[2] = 2000}, vocations = {1,5,8,6,15}},
    ['Find Person'] = {id = 209, words = 'exiva', icon = 209, description = 'Reveals the location of a player.', exhaustion = 1000, premium = false, type = 'Instant', mana = 20, level = 8, soul = 0, group = {[2] = 1900}, vocations = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}},
    ['Food'] = {id = 210, words = 'exevo pan', icon = 210, description = 'Creates food to restore hunger.', exhaustion = 2000, premium = false, type = 'Instant', mana = 15, level = 8, soul = 1, group = {[2] = 2000}, vocations = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}},
    ['Haste'] = {id = 211, words = 'utani hur', icon = 211, description = 'Increases movement speed for a short duration.', exhaustion = 2000, premium = false, type = 'Instant', mana = 60, level = 14, soul = 0, group = {[2] = 2000}, vocations = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}},
    ['Levitate'] = {id = 212, words = 'exani hur', icon = 212, description = 'Allows the caster to move up or down floors.', exhaustion = 2000, premium = false, type = 'Instant', mana = 50, level = 12, soul = 0, group = {[2] = 2000}, vocations = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}},
    ['Light'] = {id = 213, words = 'utevo lux', icon = 213, description = 'Creates a light source around the caster.', exhaustion = 2000, premium = false, type = 'Instant', mana = 20, level = 8, soul = 0, group = {[2] = 2000}, vocations = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}},

       
    --Samurai
    ['Rending Slash'] = {id = 250, words = 'rending slash', icon = 287, description = 'strike your target with a quick slash dealing physical damage. Generates 1 Focus.', exhaustion = 2500, premium = false, type = 'Instant', mana = 15, level = 1, soul = 0, group = {[1] = 1900}, vocations = {13}},
    ['Blade Tempest'] = {id = 251, words = 'blade tempest', icon = 289, description = 'unleash a circular fan of blades around you dealing physical damage to nearby enemies. Generates 1 Focus.', exhaustion = 6000, premium = false, type = 'Instant', mana = 35, level = 38, soul = 0, group = {[1] = 1900}, vocations = {13}},
    ['Wind Step'] = {id = 252, words = 'wind step', icon = 252, description = 'dash 5 tiles in a straight line leaving an after-image trail and damaging enemies along the path.', exhaustion = 8000, premium = false, type = 'Instant', mana = 30, level = 45, soul = 0, group = {[3] = 1900}, vocations = {13}, crosshair = true, area = 'WIND_STEP', range = 5, areaSprite = 1178},
    ['Guardian Stance'] = {id = 253, words = 'guardian stance', icon = 297, description = 'enter a defensive stance that heals you and reduces damage taken. Consumes all Focus on cast.', exhaustion = 18000, premium = false, type = 'Instant', mana = 50, level = 53, soul = 0, group = {[3] = 1100}, vocations = {13}},
    ['Iaijutsu'] = {id = 254, words = 'iaijutsu', icon = 292, description = 'draw your blade with blinding speed to strike the target for heavy holy damage. Consumes all Focus.', exhaustion = 12000, premium = false, type = 'Instant', mana = 60, level = 60, soul = 0, group = {[1] = 1900}, vocations = {13}},
    ['Triple Slash'] = {id = 257, words = 'triple slash', icon = 293, description = 'perform 1 to 3 rapid slashes on the target based on current Focus. Consumes all Focus.', exhaustion = 6000, premium = false, type = 'Instant', mana = 40, level = 38, soul = 0, group = {[1] = 1900}, vocations = {13}},
    ['Crimson Lotus'] = {id = 255, words = 'crimson lotus', icon = 298, description = 'ignite the area in front of you with a fiery lotus, dealing fire damage over time. Scales with Focus.', exhaustion = 25000, premium = false, type = 'Instant', mana = 90, level = 70, soul = 0, group = {[1] = 1900}, vocations = {13}},
    ['Merciful End'] = {id = 256, words = 'merciful end', icon = 290, description = 'finish off a wounded target with a devastating strike. Scales with Focus.', exhaustion = 30000, premium = false, type = 'Instant', mana = 75, level = 80, soul = 0, group = {[1] = 1900}, vocations = {13}},
    ['Flash Steel'] = {id = 291, words = 'flash steel', icon = 287, description = 'hurl a blade of energy at a target up to 4 tiles away. Generates 1 Focus.', exhaustion = 3000, premium = false, needLearn = true, type = 'Instant', mana = 20, level = 1, soul = 0, group = {[1] = 1900}, vocations = {13}},
    ['Death Mark'] = {id = 292, words = 'death mark', icon = 292, description = 'mark a target for 8 seconds. Your finisher spells deal +20% damage to marked targets.', exhaustion = 15000, premium = false, needLearn = true, type = 'Instant', mana = 25, level = 1, soul = 0, group = {[3] = 1100}, vocations = {13}},
    ['Iron Skin'] = {id = 293, words = 'iron skin', icon = 297, description = 'reduce all damage taken by 30% + 10% per Focus stack consumed for 3 seconds. Consumes all Focus.', exhaustion = 15000, premium = false, needLearn = true, type = 'Instant', mana = 40, level = 1, soul = 0, group = {[3] = 1100}, vocations = {13}},
    ['Second Wind'] = {id = 294, words = 'second wind', icon = 297, description = 'instantly heal 15% max HP + 10% per Focus stack consumed. Consumes all Focus.', exhaustion = 20000, premium = false, needLearn = true, type = 'Instant', mana = 50, level = 1, soul = 0, group = {[3] = 1100}, vocations = {13}},
    ['Cyclone Slash'] = {id = 295, words = 'cyclone slash', icon = 289, description = 'spin in a whirlwind dealing physical damage to all enemies within 3 tiles. Generates 1 Focus.', exhaustion = 4000, premium = false, needLearn = true, type = 'Instant', mana = 30, level = 1, soul = 0, group = {[1] = 1900}, vocations = {13}},
    ['Searing Wind'] = {id = 296, words = 'searing wind', icon = 252, description = 'passive: your Wind Step leaves a trail of fire that burns enemies.', exhaustion = 1000, premium = false, needLearn = true, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[3] = 1100}, vocations = {13}},
    ['Meditation'] = {id = 297, words = 'meditation', icon = 297, description = 'channel for 1 second to instantly gain 3 Focus stacks.', exhaustion = 15000, premium = false, needLearn = true, type = 'Instant', mana = 20, level = 1, soul = 0, group = {[3] = 1100}, vocations = {13}},


        --Blood Mage
    ['Sanguine Bolt'] = {id = 260, words = 'sanguine bolt', icon = 248, description = 'Fire a blood bolt at your target dealing lifedrain damage. Costs 3% max HP, generates 12 Blood Essence. +8% damage per Blood Orb held. If Crimson Sigil is active, 25% chance to apply a bleed for 3 ticks.', exhaustion = 2000, premium = false, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[1] = 1900}, vocations = {14}},
    ['Blood Siphon'] = {id = 261, words = 'blood siphon', icon = 249, description = 'Send multiple blood missiles at your target dealing lifedrain damage. Generates Blood Essence per missile hit and heals you for a portion of damage dealt.', exhaustion = 5000, premium = false, type = 'Instant', mana = 0, level = 38, soul = 0, group = {[1] = 1900}, vocations = {14}},
    ['Crimson Sigil'] = {id = 262, words = 'crimson sigil', icon = 253, description = 'Consume 50 Blood Essence to activate Crimson Sigil for 12 seconds. +20% damage, +10% lifesteal, and Sanguine Bolt gains 25% chance to apply bleed. Costs 10% max HP.', exhaustion = 18000, premium = false, type = 'Instant', mana = 0, level = 22, soul = 0, group = {[3] = 1900}, vocations = {14}},
    ['Sanguine Pool'] = {id = 268, words = 'sanguine pool', icon = 262, description = 'Consume 20 Blood Essence to create a sanguine pool for 4 seconds. Grants a shield based on max HP and missing health. While active, all your bleeds tick 50% faster.', exhaustion = 25000, premium = false, type = 'Instant', mana = 0, level = 28, soul = 0, group = {[3] = 1900}, vocations = {14}},
    ['Blood Threads'] = {id = 263, words = 'blood threads', icon = 250, description = 'Unleash crimson threads in a cone before you, dealing physical damage and applying bleeds to all enemies hit. Visual crimson lines connect you to all targets. Costs 7% max HP.', exhaustion = 8000, premium = false, type = 'Instant', mana = 0, level = 38, soul = 0, group = {[1] = 1900}, vocations = {14}},
    ['Blood Tether'] = {id = 269, words = 'blood tether', icon = 252, description = 'Bind your target with a blood tether that drains life for 8 ticks. Generates 4 Blood Essence per tick and heals you for 30% of damage. If the target dies while tethered, gain 1 Blood Orb. Costs 7% max HP.', exhaustion = 15000, premium = false, type = 'Instant', mana = 0, level = 45, soul = 0, group = {[1] = 1900}, vocations = {14}},
    ['Bloodletting Curse'] = {id = 264, words = 'bloodletting curse', icon = 260, description = 'Curse your target with a powerful bleed that deals damage over time and generates Blood Essence. Heals you for a portion of damage dealt. Costs 5% max HP.', exhaustion = 12000, premium = false, type = 'Instant', mana = 0, level = 53, soul = 0, group = {[1] = 1900}, vocations = {14}},
    ['Blood Eruption'] = {id = 265, words = 'blood eruption', icon = 259, description = 'Erupt in an AoE dealing lifedrain damage. Consumes all active bleeds on targets hit: +20% damage per bleed consumed. Grants a shield equal to 5% max HP per bleed consumed (cap 30%). Generates 15 Blood Essence. Costs 7% max HP.', exhaustion = 10000, premium = false, type = 'Instant', mana = 0, level = 60, soul = 0, group = {[1] = 1900}, vocations = {14}},
    ['Blood Lance'] = {id = 266, words = 'blood lance', icon = 258, description = 'Thrust a blood lance in a straight line dealing heavy physical damage. Consumes all Blood Orbs for bonus damage and applies a bleed. Synergizes with Blood Frenzy for increased damage. Costs 6% max HP.', exhaustion = 10000, premium = false, type = 'Instant', mana = 0, level = 70, soul = 0, group = {[1] = 1900}, vocations = {14}},
    ['Blood Detonation'] = {id = 267, words = 'blood detonation', icon = 263, description = 'Detonate all bleeds on nearby enemies dealing burst physical damage. Only affects targets with active bleeds. Consumes both manual and condition bleeds. Costs 8% max HP.', exhaustion = 16000, premium = false, type = 'Instant', mana = 0, level = 80, soul = 0, group = {[1] = 1900}, vocations = {14}},
    ['Blood Curse'] = {id = 298, words = 'blood curse', icon = 263, description = 'Debuff a target for 6 seconds: target takes +15% damage and healing received is reduced by 50%. Costs 3% max HP.', exhaustion = 12000, premium = false, needLearn = true, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[1] = 1900}, vocations = {14}},
    ['Crimson Rain'] = {id = 299, words = 'crimson rain', icon = 263, description = 'Call down a rain of blood on a 3x3 area for 5 seconds, applying bleeds to all enemies standing in it. Costs 5% max HP.', exhaustion = 10000, premium = false, needLearn = true, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[1] = 1900}, vocations = {14}},
    ['Sanguine Shield'] = {id = 300, words = 'sanguine shield', icon = 263, description = 'For 5 seconds, 20% of incoming damage is converted to Blood Essence instead of dealing damage. Costs 3% max HP.', exhaustion = 15000, premium = false, needLearn = true, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[3] = 1100}, vocations = {14}},
    ['Vampiric Aura'] = {id = 301, words = 'vampiric aura', icon = 263, description = 'For 10 seconds, all allies within 5 tiles gain 10% lifesteal. Costs 5% max HP.', exhaustion = 20000, premium = false, needLearn = true, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[3] = 1100}, vocations = {14}},
    ['Blood Walk'] = {id = 302, words = 'blood walk', icon = 263, description = 'Teleport to a bleeding target within 6 tiles, dealing AoE damage on arrival. Costs 3% max HP.', exhaustion = 6000, premium = false, needLearn = true, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[3] = 1900}, vocations = {14}},
    ['Crimson Chains'] = {id = 303, words = 'crimson chains', icon = 263, description = 'Root all enemies within 3 tiles for 3 seconds. Costs 4% max HP.', exhaustion = 12000, premium = false, needLearn = true, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[3] = 1100}, vocations = {14}},
    ['Blood Ritual'] = {id = 304, words = 'blood ritual', icon = 263, description = 'Toggle: sacrifice 5% HP per second for 15 Blood Essence per second. Cast again to toggle off.', exhaustion = 1000, premium = false, needLearn = true, type = 'Instant', mana = 0, level = 1, soul = 0, group = {[3] = 1100}, vocations = {14}},


    -- Bard
    ['Cheerful Melody'] = {id = 270, words = 'cheerful melody', icon = 228, description = 'Aura: +20% healing received. Burst: AoE heal on cast. Generates Harmony.', exhaustion = 8000, premium = false, type = 'Instant', mana = 30, level = 8, soul = 0, group = {[3] = 1900}, vocations = {11}},
    ['Pensive Melody'] = {id = 271, words = 'pensive melody', icon = 236, description = 'Aura: mana regen. Burst: AoE mana restore on cast. Generates Harmony.', exhaustion = 8000, premium = false, type = 'Instant', mana = 25, level = 38, soul = 0, group = {[3] = 1900}, vocations = {11}},
    ['Menacing Melody'] = {id = 272, words = 'menacing melody', icon = 235, description = 'Aura: enemies +15% damage taken. Burst: 1.5s AoE stun on cast. Generates Harmony.', exhaustion = 12000, premium = false, type = 'Instant', mana = 35, level = 45, soul = 0, group = {[3] = 1900}, vocations = {11}},
    ['Cathartic Melody'] = {id = 273, words = 'cathartic melody', icon = 223, description = 'Aura: +15% damage output. Burst: AoE energy damage on cast. Generates Harmony.', exhaustion = 8000, premium = false, type = 'Instant', mana = 40, level = 53, soul = 0, group = {[3] = 1900}, vocations = {11}},
    ['Epic Melody'] = {id = 274, words = 'epic melody', icon = 229, description = 'Aura: +30 movement speed. Burst: instant speed on cast. Generates Harmony.', exhaustion = 8000, premium = false, type = 'Instant', mana = 20, level = 60, soul = 0, group = {[3] = 1900}, vocations = {11}},
    ['Echo Strike'] = {id = 275, words = 'echo strike', icon = 232, description = 'Single target damage. Applies Resonance for 6s. Resonating enemies emit a small sonic wave when hit (0.5s cd).', exhaustion = 4000, premium = false, type = 'Instant', mana = 15, level = 1, soul = 0, group = {[1] = 1900}, vocations = {11}},
    ['Resonant Chorus'] = {id = 276, words = 'resonant chorus', icon = 245, description = 'AoE damage. The first enemy hit becomes Resonating. Hitting a resonating enemy makes resonance jump to the nearest non-resonating enemy.', exhaustion = 8000, premium = false, type = 'Instant', mana = 30, level = 38, soul = 0, group = {[1] = 1900}, vocations = {11}},
    ['Discordant Verse'] = {id = 277, words = 'discordant verse', icon = 247, description = 'High single target damage. Against resonating targets: bonus damage and reduces target damage dealt for 5s. Does not consume Resonance.', exhaustion = 10000, premium = false, type = 'Instant', mana = 45, level = 45, soul = 0, group = {[1] = 1900}, vocations = {11}},
    ['Harmonic Collapse'] = {id = 278, words = 'harmonic collapse', icon = 231, description = 'Detonates all nearby resonating enemies. Overlapping explosions boost each other by +10% (max +50%). Consumes Resonance.', exhaustion = 12000, premium = false, type = 'Instant', mana = 70, level = 60, soul = 0, group = {[1] = 1900}, vocations = {11}},
    ['Reverberation'] = {id = 280, words = 'reverberation', icon = 240, description = '5s aura: every resonating enemy that takes damage emits a sonic wave (1s cd per enemy). Does not consume Resonance.', exhaustion = 15000, premium = false, type = 'Instant', mana = 60, level = 53, soul = 0, group = {[1] = 1900}, vocations = {11}},
    ['Grand Finale'] = {id = 279, words = 'grand finale', icon = 226, description = 'Requires a meter at 100%. Dissonance: Apocalypse Crescendo - massive holy AoE + debuff enemies. Harmony: Elysian Symphony - party heal + cleanse + defense.', exhaustion = 30000, premium = false, type = 'Instant', mana = 120, level = 80, soul = 0, group = {[1] = 1900}, vocations = {11}},

    --Warden
    ['Crystal Cleave'] = {id = 281, words = 'crystal cleave', icon = 267, description = 'Strike the target with earth damage. Applies Earth Mark.', exhaustion = 2000, premium = false, type = 'Instant', mana = 20, level = 1, soul = 0, group = {[1] = 1900}, vocations = {15}},
    ['Glacial Shard'] = {id = 282, words = 'glacial shard', icon = 283, description = 'Launch an icy shard at the target. Applies Frost Mark.', exhaustion = 2500, premium = false, type = 'Instant', mana = 20, level = 8, soul = 0, group = {[1] = 1900}, vocations = {15}},
    ['Avalanche Stomp'] = {id = 283, words = 'avalanche stomp', icon = 281, description = 'Deal ice damage around you. Consumes Frost Mark to expand the area and stun enemies.', exhaustion = 7000, premium = false, type = 'Instant', mana = 45, level = 38, soul = 0, group = {[1] = 1900}, vocations = {15}},
    ['Barkskin'] = {id = 284, words = 'barkskin', icon = 271, description = 'Shield yourself; stronger with Earth Mark. Consumes Earth Mark.', exhaustion = 10000, premium = false, type = 'Instant', mana = 30, level = 45, soul = 0, group = {[2] = 1900}, vocations = {15}},
    ['Sylvan Mend'] = {id = 285, words = 'sylvan mend', icon = 284, description = 'Heal yourself or an ally; stronger with Earth Mark. Consumes Earth Mark.', exhaustion = 8000, premium = false, type = 'Instant', mana = 35, level = 38, soul = 0, group = {[2] = 1900}, vocations = {15}},
    ['Frozen Earth'] = {id = 286, words = 'frozen earth', icon = 275, description = 'Deal earth damage around you. Applies Earth Mark.', exhaustion = 12000, premium = false, type = 'Instant', mana = 40, level = 45, soul = 0, group = {[1] = 1900}, vocations = {15}},
    ["Guardian's Bulwark"] = {id = 287, words = 'guardian bulwark', icon = 277, description = 'Shield nearby allies; stronger with Earth Mark. Consumes Earth Mark.', exhaustion = 18000, premium = false, type = 'Instant', mana = 50, level = 53, soul = 0, group = {[2] = 1900}, vocations = {15}},
    ['Permafrost Shell'] = {id = 288, words = 'permafrost shell', icon = 282, description = 'Shield yourself; stronger with Earth Mark. Consumes Earth Mark.', exhaustion = 14000, premium = false, type = 'Instant', mana = 45, level = 60, soul = 0, group = {[2] = 1900}, vocations = {15}},
    ['Frigid Grasp'] = {id = 289, words = 'frigid grasp', icon = 285, description = 'Hurl an ice shard at the target. Consumes Frost Mark to slow it and gain a shield.', exhaustion = 14000, premium = false, type = 'Instant', mana = 30, level = 53, soul = 0, group = {[3] = 1900}, vocations = {15}},
    ['Verdant Sanctuary'] = {id = 290, words = 'verdant sanctuary', icon = 286, description = 'Ultimate: shield and cleanse allies, pulse earth damage, then finish with an earth explosion. Consumes Earth Mark.', exhaustion = 60000, premium = false, type = 'Instant', mana = 120, level = 80, soul = 0, group = {[1] = 1900}, vocations = {15}},
    ['Thorned Skin'] = {id = 305, words = 'thorned skin', icon = 267, description = 'For 8 seconds, reflect 25% of melee damage as earth. Each reflect grants 1 Thorn Stack (max 5). When Thorned Skin ends, each stack explodes for earth damage.', exhaustion = 15000, premium = false, needLearn = true, type = 'Instant', mana = 30, level = 1, soul = 0, group = {[3] = 1100}, vocations = {15}},
    ['Seismic Slam'] = {id = 306, words = 'seismic slam', icon = 267, description = 'Leap to a target location (5 tiles), dealing earth damage in 3x3 on impact. If you have Earth Mark, consume it to stun all hit enemies for 2s and create a Fissure for 5s.', exhaustion = 8000, premium = false, needLearn = true, type = 'Instant', mana = 35, level = 1, soul = 0, group = {[1] = 1900}, vocations = {15}},
    ['Ice Barrier'] = {id = 307, words = 'ice barrier', icon = 283, description = 'For 6 seconds, gain a shield absorbing 20% max HP. Melee attackers are slowed 30% for 3s and you gain 1 Frost Stack per hit (max 5). When the shield expires, each Frost Stack releases a frozen shard.', exhaustion = 12000, premium = false, needLearn = true, type = 'Instant', mana = 40, level = 1, soul = 0, group = {[3] = 1100}, vocations = {15}},
    ['Taunting Roar'] = {id = 308, words = 'taunting roar', icon = 267, description = 'Force all enemies within 4 tiles to attack you for 4s. Marked targets are also rooted for 2s. While taunted, enemies deal 15% less damage to you.', exhaustion = 20000, premium = false, needLearn = true, type = 'Instant', mana = 25, level = 1, soul = 0, group = {[3] = 1100}, vocations = {15}},
    ['Root Grasp'] = {id = 309, words = 'root grasp', icon = 267, description = 'Root a target for 3s. If you have Earth Mark, consume it: root spreads to all enemies within 2 tiles and duration becomes 5s. Rooted enemies take +15% damage.', exhaustion = 10000, premium = false, needLearn = true, type = 'Instant', mana = 25, level = 1, soul = 0, group = {[1] = 1900}, vocations = {15}},
    ['Spring of Life'] = {id = 310, words = 'spring of life', icon = 267, description = 'Create a healing spring on a 3x3 area for 8s. Allies standing in it heal 4% max HP/s and gain 5% damage reduction. If you have Earth Mark, consume it: spring also cleanses debuffs on entry.', exhaustion = 20000, premium = false, needLearn = true, type = 'Instant', mana = 50, level = 1, soul = 0, group = {[3] = 1100}, vocations = {15}},

   
  }
}

-- ['const_name'] =       {client_id, TFS_id}
-- Conversion from TFS icon id to the id used by client (icons.png order)
SpellIcons = {

}

VocationNames = {
    [0] = 'None',
    [1] = 'Magician',
    [2] = 'Templar',
    [3] = 'Nightblade',
    [4] = 'Dragon Knight',
    [5] = 'Warlock',
    [6] = 'Stellar',
    [7] = 'Monk',
    [8] = 'Druid',
    [9] = 'Light Dancer',
    [10] = 'Archer',
    [11] = 'Bard',
    [12] = 'Tinker',
    [13] = 'Samurai',
    [14] = 'Blood Mage',
    [15] = 'Warden',
}

SpellGroups = {
    [1] = 'Attack',
    [2] = 'Healing',
    [3] = 'Support',
    [4] = 'Special',
    [5] = 'Crippling',
    [6] = 'Focus',
    [7] = 'Ultimate Strikes',
    [8] = 'Great Beams',
    [9] = 'Bursts of Nature'
}

Spells = {}

function Spells.getClientId(spellName)
    local spell = Spells.getSpellByName(spellName)
    if not spell then return nil end

    local id = spell.icon
    if not tonumber(id) and SpellIcons[id] then
        return SpellIcons[id][1]
    end
    return tonumber(id)
end

function Spells.getSpellByClientId(id)
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.id == id then
                return spell, profile, k
            end
        end
    end
    return nil
end

function Spells.getServerId(spellName)
    local spell = Spells.getSpellByName(spellName)
    if not spell then return nil end
    
    local id = spell.icon
    if not tonumber(id) and SpellIcons[id] then
        return SpellIcons[id][2]
    end
    return tonumber(id)
end

function Spells.getSpellByName(name)
    if not name then return nil end
    local nameLower = name:lower():trim()
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if k:lower() == nameLower then
                return spell
            end
        end
    end
    return nil
end

function Spells.getSpellByWords(words)
    local words = words:lower():trim()
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.words:lower() == words then
                return spell, profile, k
            end
        end
    end
    return nil
end

function Spells.getSpellByIcon(iconId)
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.id == iconId then
                return spell, profile, k
            end
        end
    end
    return nil
end

function Spells.getSpellIconIds()
    local ids = {}
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            table.insert(ids, spell.id)
        end
    end
    return ids
end

function Spells.getSpellProfileById(id)
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.id == id then
                return profile
            end
        end
    end
    return nil
end

function Spells.getSpellProfileByWords(words)
    local wordsLower = words:lower():trim()
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.words:lower() == wordsLower then
                return profile
            end
        end
    end
    return nil
end

function Spells.getSpellProfileByName(spellName)
    local nameLower = spellName:lower():trim()
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if k:lower() == nameLower then
                return profile
            end
        end
    end
    return nil
end

function Spells.getSpellsByVocationId(vocId)
    local spells = {}
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if table.contains(spell.vocations, vocId) then
                table.insert(spells, spell)
            end
        end
    end
    return spells
end

function Spells.filterSpellsByGroups(spells, groups)
    local filtered = {}
    for v, spell in pairs(spells) do
        local spellGroups = Spells.getGroupIds(spell)
        if table.equals(spellGroups, groups) then
            table.insert(filtered, spell)
        end
    end
    return filtered
end

function Spells.getGroupIds(spell)
    local groups = {}
    for k, _ in pairs(spell.group) do
        table.insert(groups, k)
    end
    return groups
end

function Spells.getIconId(iconid, profile)
    if not SpellInfo[profile] then return nil end
    for k, v in pairs(SpellInfo[profile]) do
        local clientIcon = tonumber(v.icon)
        if clientIcon and clientIcon == iconid then
            return SpelllistSettings[profile].iconFile .. '/' .. tostring(clientIcon) .. '.png'
        end
    end
end

function Spells.getIconFileByProfile(profile)
    return SpelllistSettings[profile]['iconFile']
end

function Spells.getByWords(words)
    for profile, spells in pairs(SpellInfo) do
        for name, spell in pairs(spells) do
            if spell.words == words then
                return spell
            end
        end
    end
    return nil
end

SpellAreaOffsets = {
    ['AREA_CIRCLE3X3'] = '0,-3;-1,-3;1,-3;-2,-2;-1,-2;0,-2;1,-2;2,-2;-3,-1;-2,-1;-1,-1;0,-1;1,-1;2,-1;3,-1;-3,0;-2,0;-1,0;0,0;1,0;2,0;3,0;-3,1;-2,1;-1,1;0,1;1,1;2,1;3,1;-2,2;-1,2;0,2;1,2;2,2;-1,3;0,3;1,3',
    ['AREA_CROSS1X1'] = '0,-1;-1,0;0,0;0,1;1,0',
    ['AREA_BLIZZARD'] = '0,-1;-1,0;0,0;0,1;1,0',
    ['AREA_TELEPORT'] = '0,0',
    ['AREA_HELLS_CORE'] = '-1,-1;0,-1;1,-1;-1,0;0,0;1,0;-1,1;0,1;1,1',
    ['AREA_RAIN_FALL'] = '-1,-1;0,-1;1,-1;-1,0;0,0;1,0;-1,1;0,1;1,1',
    ['AREA_LIVING_GROUND'] = '-1,-1;0,-1;1,-1;-1,0;0,0;1,0;-1,1;0,1;1,1',
    ['AREA_WRATH_OF_NATURE'] = '-1,-1;0,-1;1,-1;-1,0;0,0;1,0;-1,1;0,1;1,1',
    ['AREA_MAGNETIC_ORB'] = '0,0',
    ['AREA_WIND_BARREL'] = '-1,-1;0,-1;1,-1;-1,0;0,0;1,0;-1,1;0,1;1,1',
    ['AREA_ARROW_RAIN'] = '-1,-1;0,-1;1,-1;-1,0;0,0;1,0;-1,1;0,1;1,1',
    ['AREA_HEALING_BARREL'] = '-1,-1;0,-1;1,-1;-1,0;0,0;1,0;-1,1;0,1;1,1',
    ['AREA_EXPLOSIVE_BARREL'] = '-1,-1;0,-1;1,-1;-1,0;0,0;1,0;-1,1;0,1;1,1',
    ['WIND_STEP'] = '0,0',
    ['AREA_BEAM5'] = '0,-4;0,-3;0,-2;0,-1;0,0'
}

function Spells.getAreaOffsets(areaName)
    return SpellAreaOffsets[areaName] or ''
end
