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
      'Challenging Spear',
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

      --Templar
      'Divine Punishment',
      'Penitence',
      'Holy Ground',
      'Sacred Ground',
      'Crusader Strike',
      'Divine Storm',
      'Exorcism',
      'Smite',
      'Light Beam',
      'Summon Guardian of Light',
      'Kings Blessing',
      'Angelic Form',
      'Judgement',

      --Magician
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
      'Ice Tomb',
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
      'Grow',
      'Lunar Beam',
      'Aery Strikes',
      'Full Moon',
      'Moonlight',
      'Holy Flare',
      'Solar Blessing',


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

      --druid
      'Terra Strike',
      'Life Bloom',
      'Rejuvenation',
      'Insect Swarm',
      'Travel Form',
      'Carnivorous Vile',
      'living ground',
      'Thorns',
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

SpellInfo = {
  ['Custom'] = {

    -- Dragon Knight
    ['Rend'] = {id = 1, words = 'rend', icon_id = 1, description = 'rend the target dealing physical damage and reaching nearby enemies. [skill+attack]', exhaustion = 2000, premium = false, type = 'Instant', icon = 1, mana = 20, level = 8, soul = 0, group = {[1] = 2000}, vocations = {4}},
    ['Brutal Swing'] = {id = 2, words = 'brutal swing', icon_id = 2, description = 'smash the target dealing high ammounts of physical damage the reached area can vary based on one handed or two handed weapon. [skill+attack]', exhaustion = 2000, premium = false, type = 'Instant', icon = 2, mana = 55, level = 18, soul = 0, group = {[1] = 2000}, vocations = {4}},
    ['Challenging Spear'] = {id = 3, words = 'Challenging Spear', icon_id = 3, description = 'shoot a spear wich taunts the target and deals physical damage. [skill+attack]', exhaustion = 2000, premium = false, type = 'Instant', icon = 3, mana = 30, level = 20, soul = 0, group = {[3] = 2000}, vocations = {4}},
    ['Fire Within'] = {id = 4, words = 'fire within', icon_id = 4, description = 'ignite yourself into fire to deal fire damage to your nearest enemy and spread it to nearby enemies. [skill+attack]', exhaustion = 2000, premium = false, type = 'Instant', icon = 4, mana = 75, level = 70, soul = 0, group = {[1] = 2000}, vocations = {4}},
    ['Charge'] = {id = 5, words = 'charge', icon_id = 5, description = 'charge into your target from the distance and stun it for 1 second. [skill+attack]', exhaustion = 2000, premium = false, type = 'Instant', icon = 5, mana = 70, level = 40, soul = 0, group = {[3] = 2000}, vocations = {4}},
    ['whirlwind'] = {id = 6, words = 'whirlwind', icon_id = 6, description = 'slash your surroundings dealing fire damage and igniting all enemies in the area. [skill+attack]', exhaustion = 2000, premium = false, type = 'Instant', icon = 6, mana = 85, level = 30, soul = 0, group = {[1] = 2000}, vocations = {4}},
    ['Phoenix Wrath'] = {id = 8, words = 'phoenix wrath', icon_id = 8, description = 'command a phoenix to attack in a straight line dealing fire damage to all enemies in that direction. [skill+attack]', exhaustion = 2000, premium = false, type = 'Instant', icon = 8, mana = 115, level = 125, soul = 0, group = {[1] = 2000}, vocations = {4}},
    ['Dragon Aura'] = {id = 9, words = 'dragon aura', icon_id = 9, description = 'create a dragon aura that deals fire damage to enemies around you. [maxHP+Magic]', exhaustion = 2000, premium = false, type = 'Instant', icon = 9, mana = 75, level = 50, soul = 0, group = {[1] = 2000}, vocations = {4}},
    ['Dragons Call'] = {id = 10, words = 'dragons call', icon_id = 10, description = 'xxxxx missing description xxxxxx[skill+attack]', exhaustion = 2000, premium = false, type = 'Instant', icon = 10, mana = 85, level = 100, soul = 0, group = {[1] = 2000}, vocations = {4}},
    ['Draconic Chains'] = {id = 11, words = 'draconic chains', icon_id = 11, description = 'unleash your dragon chains pullin all enemies into you dealing physical damage to all enemies. [magic]', exhaustion = 2000, premium = false, type = 'Instant', icon = 11, mana = 325, level = 150, soul = 0, group = {[3] = 2000}, vocations = {4}},
    ['Shockwave'] = {id = 12, words = 'shockwave', icon_id = 12, description = 'stomp the floor creating a shockwave and stunning all enemies in the area for 2 seconds. [skill+attack+magic]', exhaustion = 2000, premium = false, type = 'Instant', icon = 12, mana = 75, level = 30, soul = 0, group = {[1] = 2000}, vocations = {4}},
    ['Bloodlust'] = {id = 13, words = 'bloodlust', icon_id = 13, description = 'for the next 8 seconds enter a frenzy state increasing your melee skill, attack speed and critical hit chance by 50%.', exhaustion = 2000, premium = false, type = 'Instant', icon = 13, mana = 85, level = 1, soul = 0, group = {[3] = 2000}, vocations = {4}},
    ['Dragon Soul'] = {id = 14, words = 'dragon soul', icon_id = 14, description = 'restore high amounts of max health scaled by your max health.', exhaustion = 2000, premium = false, type = 'Instant', icon = 14, mana = 20, level = 1, soul = 0, group = {[2] = 2000}, vocations = {4}},
    
    -- Templar
    ['Divine Punishment'] = {id = 20, words = 'divine punishment', icon_id = 20, description = 'call down judgement to a enemy dealing high amounts of holy damage.', exhaustion = 2000, premium = false, type = 'Instant', icon = 20, mana = 200, level = 100, soul = 0, group = {[1] = 2000}, vocations = {2}},
    ['Penitence'] = {id = 21, words = 'penitence', icon_id = 21, description = 'send a holy shield wich deals holy damage and taunts all enemies.', exhaustion = 2000, premium = false, type = 'Instant', icon = 21, mana = 60, level = 25, soul = 0, group = {[1] = 2000}, vocations = {2}},
    ['Holy Ground'] = {id = 22, words = 'holy ground', icon_id = 22, description = 'create a holy ground at your casted position wich will deal damage to enemies who stand inside its radius.', exhaustion = 2000, premium = false, type = 'Instant', icon = 22, mana = 75, level = 50, soul = 0, group = {[1] = 2000}, vocations = {2}},
    ['Sacred Ground'] = {id = 23, words = 'sacred Ground', icon_id = 23, description = 'create a sacred ground at your casted position wich will heal allies who stand inside its radius.', exhaustion = 2000, premium = false, type = 'Instant', icon = 23, mana = 100, level = 40, soul = 0, group = {[2] = 2000}, vocations = {2}},
    ['Crusader Strike'] = {id = 24, words = 'crusader strike', icon_id = 24, description = 'after a short delay strike your target with a holy sentence.', exhaustion = 2000, premium = false, type = 'Instant', icon = 24, mana = 50, level = 18, soul = 0, group = {[1] = 2000}, vocations = {2}},
    ['Divine Storm'] = {id = 25, words = 'divine storm', icon_id = 25, description = 'create a holy storm wich deals damage and heals you and your nearby allies.', exhaustion = 2000, premium = false, type = 'Instant', icon = 25, mana = 150, level = 70, soul = 0, group = {[1] = 2000}, vocations = {2}},
    ['Exorcism'] = {id = 26, words = 'exorcism', icon_id = 26, description = 'call faith around you several times dealing damage to nearby enemies.', exhaustion = 2000, premium = false, type = 'Instant', icon = 26, mana = 125, level = 999, soul = 0, group = {[1] = 2000}, vocations = {2}},
    ['Smite'] = {id = 27, words = 'smite', icon_id = 27, description = 'smite your target dealing physical damage after a short delay', exhaustion = 2000, premium = false, type = 'Instant', icon = 27, mana = 20, level = 8, soul = 0, group = {[1] = 2000}, vocations = {2}},
    ['Light Beam'] = {id = 28, words = 'light beam', icon_id = 28, description = 'create a holy wave wich deals damage based on your direction.', exhaustion = 2000, premium = false, type = 'Instant', icon = 28, mana = 130, level = 30, soul = 0, group = {[1] = 2000}, vocations = {2}},
    ['Summon Guardian of Light'] = {id = 29, words = 'summon guardian', icon_id = 29, description = 'summon the guardian of light to aid you, healing you and nearby allies while it is active.', exhaustion = 2000, premium = false, type = 'Instant', icon = 29, mana = 250, level = 90, soul = 0, group = {[3] = 2000}, vocations = {2}},
    ['Kings Blessing'] = {id = 30, words = 'Kings Blessing', icon_id = 30, description = 'increase all party members combat stats by 10% for 20 minutes.', exhaustion = 2000, premium = false, type = 'Instant', icon = 30, mana = 50, level = 60, soul = 0, group = {[3] = 2000}, vocations = {2}},
    ['Angelic Form'] = {id = 31, words = 'angelic form', icon_id = 31, description = 'gain the blessing of angels transforming you into a angel, while this form is active you and all your nearby allies will be constantly healed.', exhaustion = 2000, premium = false, type = 'Instant', icon = 31, mana = 500, level = 90, soul = 0, group = {[3] = 2000}, vocations = {2}},
    ['Judgement'] = {id = 32, words = 'judgement', icon_id = 32, description = 'trhow a holy hammer dealing holy damage to your target.', exhaustion = 2000, premium = false, type = 'Instant', icon = 32, mana = 30, level = 15, soul = 0, group = {[1] = 2000}, vocations = {2}},
   
    --Magician
    ['Energy Blast'] = {id = 41, words = 'energy blast', icon_id = 41, description = 'cast a energy blast wich restore mana on impact and deals energy damage to your target.', exhaustion = 2000, premium = false, type = 'Instant', icon = 41, mana = 0, level = 10, soul = 0, group = {[1] = 2000}, vocations = {1}},
    ['Fire Blast'] = {id = 42, words = 'fire blast', icon_id = 42, description = 'cast a fire blast wich deals fire damage in a small radius.', exhaustion = 2000, premium = false, type = 'Instant', icon = 42, mana = 25, level = 8, soul = 0, group = {[1] = 2000}, vocations = {1}},
    ['Ice Nova'] = {id = 44, words = 'ice nova', icon_id = 44, description = 'create a ice nova wich extends from your current position slowing all enemies in its radius.', exhaustion = 2000, premium = false, type = 'Instant', icon = 44, mana = 180, level = 20, soul = 0, group = {[1] = 2000}, vocations = {1}},
    ['Mana Distortion'] = {id = 46, words = 'mana distortion', icon_id = 46, description = 'creates a distortion field wich restore mana to allies who stand inside its radius.', exhaustion = 2000, premium = false, type = 'Instant', icon = 46, mana = 0, level = 80, soul = 0, group = {[3] = 2000}, vocations = {1}},
    ['Mana Flow'] = {id = 47, words = 'mana flow', icon_id = 47, description = 'restores a percentage of your max mana every second for 8 seconds.', exhaustion = 2000, premium = false, type = 'Instant', icon = 47, mana = 0, level = 40, soul = 0, group = {[2] = 2000}, vocations = {1}},
    ['Hand of God'] = {id = 48, words = 'hand of god', icon_id = 48, description = 'slam the ground creating a fire explosion dealing damage to all enemies in its radius.', exhaustion = 2000, premium = false, type = 'Instant', icon = 48, mana = 120, level = 18, soul = 0, group = {[1] = 2000}, vocations = {1}},
    ['Frost Wave'] = {id = 49, words = 'frost wave', icon_id = 49, description = 'send a frozen wave into your faced direction wich stuns and freeze in aplce all enemies reached.', exhaustion = 2000, premium = false, type = 'Instant', icon = 49, mana = 200, level = 70, soul = 0, group = {[1] = 2000}, vocations = {1}},
    ['Arcane Missiles'] = {id = 51, words = 'arcane missiles', icon_id = 51, description = 'shoot a group of missiles wich deals energy damage to your target.', exhaustion = 2000, premium = false, type = 'Instant', icon = 51, mana = 80, level = 18, soul = 0, group = {[1] = 2000}, vocations = {1}},
    ['Teleport'] = {id = 52, words = 'teleport', icon_id = 52, description = 'insstantly teleport yourself forwards, this effect can affected by objects', exhaustion = 2000, premium = false, type = 'Instant', icon = 52, mana = 150, level = 60, soul = 0, group = {[3] = 2000}, vocations = {1}},
    ['Blizzard'] = {id = 53, words = 'blizzard', icon_id = 53, description = 'create a blizzard storm into your target position dealing ice damage while it is active.', exhaustion = 2000, premium = false, type = 'Instant', icon = 53, mana = 200, level = 50, soul = 0, group = {[1] = 2000}, vocations = {1}},
    ['Hells Core'] = {id = 54, words = 'hells core', icon_id = 54, description = 'a meteor fall at your target position dealing massive fire damage.', exhaustion = 2000, premium = false, type = 'Instant', icon = 54, mana = 400, level = 100, soul = 0, group = {[1] = 2000}, vocations = {1}},
    ['Ice Barrage'] = {id = 55, words = 'ice barrage', icon_id = 55, description = 'shoot a group of icicles wich deals ice damage to your target.', exhaustion = 2000, premium = false, type = 'Instant', icon = 55, mana = 75, level = 30, soul = 0, group = {[1] = 2000}, vocations = {0}},
    ['Ice Wall'] = {id = 56, words = 'ice wall', icon_id = 56, description = 'create a ice wall wich extends horizontally 2 tilesfrom your current position.', exhaustion = 2000, premium = false, type = 'Instant', icon = 56, mana = 115, level = 42, soul = 0, group = {[1] = 2000}, vocations = {0}},
    ['Ice Clones'] = {id = 57, words = 'ice clones', icon_id = 57, description = 'create a 4 clones of yourself wich will follow you and deal ice damage to enemies.', exhaustion = 2000, premium = false, type = 'Instant', icon = 57, mana = 115, level = 42, soul = 0, group = {[1] = 2000}, vocations = {0}},
    ['Ice Tomb'] = {id = 58, words = 'ice tomb', icon_id = 58, description = 'surround your target with ice pillars trapping it in place.', exhaustion = 2000, premium = false, type = 'Instant', icon = 58, mana = 10, level = 10, soul = 0, group = {[1] = 2000}, vocations = {0}},
    ['Glacial Steps'] = {id = 59, words = 'glacial steps', icon_id = 59, description = 'leave a trail of ice traps while walking wich slow down enemies on contact.', exhaustion = 25000, premium = false, type = 'Instant', icon = 59, mana = 115, level = 42, soul = 0, group = {[1] = 2000}, vocations = {0}},
    
    --Warlock
    ['Zombie Wall'] = {id = 61, words = 'zombie wall', icon_id = 61, description = 'create a zombie wall wich extends horizontally 2 tiles from your current position.', exhaustion = 2000, premium = false, type = 'Instant', icon = 61, mana = 50, level = 40, soul = 0, group = {[3] = 2000}, vocations = {5}},
    ['Curse'] = {id = 62, words = 'curse', icon_id = 62, description = 'curse your target dealing death damage for 6 seconds.', exhaustion = 2000, premium = false, type = 'Instant', icon = 62, mana = 35, level = 8, soul = 0, group = {[1] = 2000}, vocations = {5}},
    ['Fear'] = {id = 63, words = 'fear', icon_id = 63, description = 'fear your target for 6 seconds wich makes it unable to control itself.', exhaustion = 2000, premium = false, type = 'Instant', icon = 63, mana = 150, level = 60, soul = 0, group = {[3] = 2000}, vocations = {5}},
    ['Shadow Strike'] = {id = 64, words = 'shadow strike', icon_id = 64, description = 'send a shadow bolt to your target dealing shadow damage.', exhaustion = 2000, premium = false, type = 'Instant', icon = 64, mana = 110, level = 30, soul = 0, group = {[1] = 2000}, vocations = {5}},
    ['Summon Void Mender'] = {id = 65, words = 'summon void mender', icon_id = 65, description = 'summon a void mender wich heals injured allies or summons.', exhaustion = 2000, premium = false, type = 'Instant', icon = 65, mana = 300, level = 70, soul = 0, group = {[3] = 2000}, vocations = {5}},
    ['Blood Pact'] = {id = 66, words = 'blood pact', icon_id = 66, description = 'exchage a percentage of your max health for mana.', exhaustion = 2000, premium = false, type = 'Instant', icon = 66, mana = 0, level = 40, soul = 0, group = {[2] = 2000}, vocations = {5}},
    ['Party Vitality'] = {id = 67, words = 'Party Vitality', icon_id = 67, description = 'increase the max health of your party members for 20 minutes.', exhaustion = 2000, premium = false, type = 'Instant', icon = 67, mana = 100, level = 60, soul = 0, group = {[3] = 2000}, vocations = {5}},
    ['Summon Void Guard'] = {id = 68, words = 'summon void guard', icon_id = 68, description = 'summon a void guard taunts nearby enemies and has a larger health pool.', exhaustion = 2000, premium = false, type = 'Instant', icon = 68, mana = 480, level = 100, soul = 0, group = {[3] = 2000}, vocations = {5}},
    ['Summon Void Sentinel'] = {id = 69, words = 'summon void sentinel', icon_id = 69, description = 'summon a void sentinel wich damages enemies from the distance.', exhaustion = 2000, premium = false, type = 'Instant', icon = 69, mana = 150, level = 30, soul = 0, group = {[3] = 2000}, vocations = {5}},
    ['Blood Wall'] = {id = 70, words = 'blood Wall', icon_id = 70, description = 'increase your defence stat and max hitpoints for 15 seconds.', exhaustion = 2000, premium = false, type = 'Instant', icon = 70, mana = 0, level = 90, soul = 0, group = {[3] = 2000}, vocations = {5}},
    ['Dark Plague'] = {id = 71, words = 'dark plague', icon_id = 71, description = 'curse all enemies nearby your target position dealing death damage over 10 seconds.', exhaustion = 2000, premium = false, type = 'Instant', icon = 71, mana = 300, level = 100, soul = 0, group = {[1] = 2000}, vocations = {5}},
    ['Soul Rain'] = {id = 74, words = 'soul rain', icon_id = 74, description = 'cast a rain of death over your target position dealing death damage over 8 seconds.', exhaustion = 2000, premium = false, type = 'Instant', icon = 74, mana = 200, level = 50, soul = 0, group = {[1] = 2000}, vocations = {5}},
    ['Drain Soul'] = {id = 75, words = 'drain soul', icon_id = 75, description = 'drain the souls of nearby enemies healing yourself and dealing death damage.', exhaustion = 2000, premium = false, type = 'Instant', icon = 75, mana = 150, level = 100, soul = 0, group = {[1] = 2000}, vocations = {5}},
    ['Malediction'] = {id = 76, words = 'malediction', icon_id = 76, description = 'cast a strong plague to your target that deals death damage on impact.', exhaustion = 2000, premium = false, type = 'Instant', icon = 76, mana = 150, level = 1, soul = 0, group = {[1] = 2000}, vocations = {5}},
    ['Haunt'] = {id = 77, words = 'haunt', icon_id = 77, description = 'haunts the target and apply a curse to it and nearby enemies after impact.', exhaustion = 2000, premium = false, type = 'Instant', icon = 77, mana = 250, level = 1, soul = 0, group = {[1] = 2000}, vocations = {5}},
    ['Dark Aura'] = {id = 78, words = 'dark aura', icon_id = 78, description = 'infuse yourself with a dark aura that reduce all damage taken by 25%.', exhaustion = 2000, premium = false, type = 'Instant', icon = 78, mana = 0, level = 1, soul = 0, group = {[3] = 2000}, vocations = {5}},
   
    --Nightblade
    ['Stealth'] = {id = 80, words = 'stealth', icon_id = 80, description = 'enter stealth mode for 60 seconds wich makes you invisible to enemies and damage.', exhaustion = 60000, premium = false, type = 'Instant', icon = 80, mana = 110, level = 40, soul = 0, group = {[1] = 5000}, vocations = {3}},
    ['Mutilate'] = {id = 81, words = 'mutilate', icon_id = 81, description = 'mutilate your target 4 times in a row dealing physical damage.', exhaustion = 3000, premium = false, type = 'Instant', icon = 81, mana = 35, level = 8, soul = 0, group = {[1] = 1900}, vocations = {3}},
    ['Shadow Hunt'] = {id = 82, words = 'shadow hunt', icon_id = 82, description = 'cast a hunting blade over your target that deals shadow damage 4 times in a row.', exhaustion = 6000, premium = false, type = 'Instant', icon = 82, mana = 60, level = 18, soul = 0, group = {[1] = 1900}, vocations = {3}},
    ['Shadowstep'] = {id = 83, words = 'shadowstep', icon_id = 83, description = 'shadow step before your target appearing behind it and stuning it for a small duration.', exhaustion = 15000, premium = false, type = 'Instant', icon = 83, mana = 125, level = 90, soul = 0, group = {[3] = 1900}, vocations = {3}},
    ['Backstab'] = {id = 84, words = 'backstab', icon_id = 84, description = 'backstab your target dealing physical damage wich stuns it for 2 seconds.', exhaustion = 7000, premium = false, type = 'Instant', icon = 84, mana = 60, level = 15, soul = 0, group = {[1] = 0}, vocations = {3}},
    ['Assassination'] = {id = 85, words = 'assassination', icon_id = 85, description = 'assassinate all nearby enemies teleporting you into them for a breaf period of time making you untargetable.', exhaustion = 22000, premium = false, type = 'Instant', icon = 85, mana = 250, level = 70, soul = 0, group = {[1] = 1900}, vocations = {3}},
    ['Fan of Knives'] = {id = 86, words = 'fan of knives', icon_id = 86, description = 'sprays knives at all enemies around your dealing physical damage and applie a poison effect.', exhaustion = 5000, premium = false, type = 'Instant', icon = 86, mana = 100, level = 50, soul = 0, group = {[1] = 1900}, vocations = {3}},
    ['Shadow Form'] = {id = 87, words = 'shadow form', icon_id = 87, description = 'enter a shadow state that heals you for the duration.', exhaustion = 2000, premium = false, type = 'Instant', icon = 87, mana = 0, level = 1, soul = 0, group = {[1] = 1900}, vocations = {3}},
    ['Dark Rupture'] = {id = 88, words = 'dark rupture', icon_id = 88, description = 'create a rupture into your target wich deals physical damage, if the target is stunned it will apply a bleeding effect.', exhaustion = 6000, premium = false, type = 'Instant', icon = 88, mana = 45, level = 30, soul = 0, group = {[1] = 1900}, vocations = {3}},
    ['Void Execution'] = {id = 89, words = 'void execution', icon_id = 89, description = 'executes all nearby enemies while their health is below 30%, this effect is changed to 20% for players.', exhaustion = 22000, premium = false, type = 'Instant', icon = 89, mana = 200, level = 1, soul = 0, group = {[1] = 1900}, vocations = {3}},
    ['Blood Blades'] = {id = 90, words = 'blood blades', icon_id = 90, description = 'enter a bloody state wich heals you everytime you land a melee hit.', exhaustion = 25000, premium = false, type = 'Instant', icon = 90, mana = 0, level = 35, soul = 0, group = {[3] = 1900}, vocations = {3}},
    ['Lethal Dagger'] = {id = 91, words = 'lethal dagger', icon_id = 91, description = 'throw a lethal dagger at your target dealing physical damage.', exhaustion = 2000, premium = false, type = 'Instant', icon = 91, mana = 50, level = 15, soul = 0, group = {[1] = 0}, vocations = {3}},
    ['Blackout'] = {id = 92, words = 'blackout', icon_id = 92, description = 'hit your target with a dark force stunnin it for 4 seconds.', exhaustion = 16000, premium = false, type = 'Instant', icon = 92, mana = 60, level = 1, soul = 0, group = {[1] = 0}, vocations = {3}},
   
   --Stellar
    ['Cosmic Force'] = {id = 100, words = 'cosmic force', icon_id = 100, description = 'after a short delay send a force ball at your target dealing energy damage.', exhaustion = 3000, premium = false, type = 'Instant', icon = 100, mana = 30, level = 8, soul = 0, group = {[1] = 1900}, vocations = {6}},
    ['Aery Wrath'] = {id = 102, words = 'aery wrath', icon_id = 102, description = 'send aery into combat making her travel through your target and all enemies around it dealing holy damage.', exhaustion = 10000, premium = false, type = 'Instant', icon = 102, mana = 45, level = 18, soul = 0, group = {[1] = 1900}, vocations = {6}},
    ['Starfall'] = {id = 103, words = 'starfall', icon_id = 103, description = 'call a starfall over your target position dealing energy damage and restoring mana.', exhaustion = 7000, premium = false, type = 'Instant', icon = 103, mana = 0, level = 50, soul = 0, group = {[1] = 0}, vocations = {6}},
    ['Falling Star'] = {id = 104, words = 'falling star', icon_id = 104, description = 'call down a falling star over your target dealing damage and stunning it for 3 seconds..', exhaustion = 7000, premium = false, type = 'Instant', icon = 104, mana = 95, level = 30, soul = 0, group = {[1] = 1900}, vocations = {6}},
    ['Rain fall'] = {id = 105, words = 'rain fall', icon_id = 105, description = 'create a safe zone where rain falls and heals all allies who stand in it.', exhaustion = 20000, premium = false, type = 'Instant', icon = 105, mana = 100, level = 25, soul = 0, group = {[2] = 1900}, vocations = {6}},
    ['Grow'] = {id = 107, words = 'grow', icon_id = 107, description = 'create a sequence of magic walls based on the direction you are facing, each consecutive wall will be placed based on the direction you are facing at that momemnt.', exhaustion = 25000, premium = false, type = 'Instant', icon = 107, mana = 100, level = 60, soul = 0, group = {[3] = 1900}, vocations = {6,8}},
    ['Lunar Beam'] = {id = 108, words = 'lunar beam', icon_id = 108, description = 'xxxxxxx', exhaustion = 13000, premium = false, type = 'Instant', icon = 108, mana = 185, level = 60, soul = 0, group = {[1] = 1900}, vocations = {6}},
    ['Aery Strikes'] = {id = 109, words = 'aery strikes', icon_id = 109, description = 'xxxxxxx', exhaustion = 8000, premium = false, type = 'Instant', icon = 109, mana = 135, level = 70, soul = 0, group = {[1] = 1900}, vocations = {6}},
    ['Full Moon'] = {id = 111, words = 'full moon', icon_id = 111, description = 'xxxxxxx', exhaustion = 45000, premium = false, type = 'Instant', icon = 111, mana = 300, level = 100, soul = 0, group = {[2] = 1900}, vocations = {6}},
    ['Moonlight'] = {id = 112, words = 'moonlight', icon_id = 112, description = 'xxxxxxx', exhaustion = 2000, premium = false, type = 'Instant', icon = 112, mana = 80, level = 27, soul = 0, group = {[2] = 1900}, vocations = {6}},
    ['Holy Flare'] = {id = 113, words = 'holy flare', icon_id = 113, description = 'xxxxxxx', exhaustion = 10000, premium = false, type = 'Instant', icon = 113, mana = 140, level = 1, soul = 0, group = {[2] = 1900}, vocations = {6}},
    ['Solar Blessing'] = {id = 114, words = 'solar blessing', icon_id = 114, description = 'xxxxxxx', exhaustion = 10000, parameter = true, premium = false, type = 'Instant', icon = 114, mana = 140, level = 1, soul = 0, group = {[2] = 1900}, vocations = {6}},


    --Monk
    ['Lotus Kick'] = {id = 127, words = 'lotus kick', icon_id = 127, description = 'xxxxxxx', exhaustion = 7000, premium = false, type = 'Instant', icon = 127, mana = 30, level = 40, soul = 0, group = {[3] = 0}, vocations = {7}},
    ['Adaptive Punch'] = {id = 128, words = 'adaptive punch', icon_id = 128, description = 'xxxxxxx', exhaustion = 10000, premium = false, type = 'Instant', icon = 128, mana = 80, level = 15, soul = 0, group = {[3] = 2000}, vocations = {7}},
    ['Fire Punch'] = {id = 129, words = 'fire punch', icon_id = 129, description = 'xxxxxxx', exhaustion = 3000, premium = false, type = 'Instant', icon = 129, mana = 35, level = 8, soul = 0, group = {[1] = 1900}, vocations = {7}},
    ['Ice Punch'] = {id = 130, words = 'ice punch', icon_id = 130, description = 'xxxxxxx', exhaustion = 3000, premium = false, type = 'Instant', icon = 130, mana = 35, level = 8, soul = 0, group = {[1] = 1900}, vocations = {7}},
    ['Life Punch'] = {id = 131, words = 'life punch', icon_id = 131, description = 'xxxxxxx', exhaustion = 3000, premium = false, type = 'Instant', icon = 131, mana = 35, level = 8, soul = 0, group = {[1] = 1900}, vocations = {7}},
    ['Fist of Fire'] = {id = 132, words = 'fist of fire', icon_id = 132, description = 'xxxxxxx', exhaustion = 12000, premium = false, type = 'Instant', icon = 132, mana = 115, level = 42, soul = 0, group = {[1] = 3000}, vocations = {7}},
    ['Volcanic Dash'] = {id = 133, words = 'volcanic dash', icon_id = 133, description = 'xxxxxxx', exhaustion = 12000, premium = false, type = 'Instant', icon = 133, mana = 115, level = 42, soul = 0, group = {[1] = 3000}, vocations = {7}},
    ['Stormfist'] = {id = 134, words = 'stormfist', icon_id = 134, description = 'xxxxxxx', exhaustion = 20000, premium = false, type = 'Instant', icon = 134, mana = 350, level = 1, soul = 0, group = {[1] = 0}, vocations = {7}},
    ['Mountain Stance'] = {id = 135, words = 'mountain stance', icon_id = 135, description = 'xxxxxxx', exhaustion = 50000, premium = false, type = 'Instant', icon = 135, mana = 650, level = 1, soul = 0, group = {[1] = 1900}, vocations = {7}},
    ['Zen Barrier'] = {id = 136, words = 'zen barrier', icon_id = 136, description = 'xxxxxxx', exhaustion = 45000, parameter = true, premium = false, type = 'Instant', icon = 136, mana = 500, level = 1, soul = 0, group = {[1] = 1900}, vocations = {7}},
    ['Mystic Fist'] = {id = 137, words = 'mystic fist', icon_id = 137, description = 'xxxxxxx', exhaustion = 8000, premium = false, type = 'Instant', icon = 137, mana = 150, level = 50, soul = 0, group = {[1] = 1900}, vocations = {7}},
 
    --Druid
    ['Terra Strike'] = {id = 150, words = 'terra strike', icon_id = 150, description = 'xxxxxxx', exhaustion = 3000, premium = false, type = 'Instant', icon = 150, mana = 30, level = 8, soul = 0, group = {[1] = 1900}, vocations = {8}},
    ['Life Bloom'] = {id = 152, words = 'life bloom', icon_id = 152, description = 'xxxxxxx', exhaustion = 6000, premium = false, type = 'Instant', icon = 152, mana = 0, level = 1, soul = 0, group = {[2] = 1900}, vocations = {8}},
    ['Rejuvenation'] = {id = 153, words = 'rejuvenation', icon_id = 153, description = 'xxxxxxx', exhaustion = 5000, premium = false, type = 'Instant', icon = 153, mana = 100, level = 40, soul = 0, group = {[2] = 1900}, vocations = {8}},
    ['Insect Swarm'] = {id = 154, words = 'insect swarm', icon_id = 154, description = 'xxxxxxx', exhaustion = 15000, premium = false, type = 'Instant', icon = 154, mana = 75, level = 1, soul = 0, group = {[1] = 1900}, vocations = {8}},
    ['Travel Form'] = {id = 155, words = 'travel form', icon_id = 155, description = 'xxxxxxx', exhaustion = 2000, premium = false, type = 'Instant', icon = 155, mana = 60, level = 25, soul = 0, group = {[3] = 2000}, vocations = {8}},
    ['Carnivorous Vile'] = {id = 156, words = 'carnivorous vile', icon_id = 156, description = 'xxxxxxx', exhaustion = 5500, premium = false, type = 'Instant', icon = 156, mana = 85, level = 30, soul = 0, group = {[1] = 1900}, vocations = {8}},
    ['living ground'] = {id = 157, words = 'living ground', icon_id = 157, description = 'xxxxxxx', exhaustion = 10000, premium = false, type = 'Instant', icon = 157, mana = 200, level = 1, soul = 0, group = {[2] = 1900}, vocations = {8}},
    ['Thorns'] = {id = 158, words = 'thorns', icon_id = 158, description = 'xxxxxxx', exhaustion = 2000, premium = false, type = 'Instant', icon = 158, mana = 50, level = 60, soul = 0, group = {[2] = 1900}, vocations = {8}},
    ['Piercing Wave'] = {id = 159, words = 'piercing wave', icon_id = 159, description = 'xxxxxxx', exhaustion = 12000, premium = false, type = 'Instant', icon = 159, mana = 115, level = 42, soul = 0, group = {[1] = 1900}, vocations = {8}},
    ['Bear Form'] = {id = 160, words = 'bear form', icon_id = 160, description = 'xxxxxxx', exhaustion = 20000, premium = false, type = 'Instant', icon = 160, mana = 60, level = 45, soul = 0, group = {[3] = 2000}, vocations = {8}},
    ['Bless of the Forest'] = {id = 161, words = 'bless of the forest', icon_id = 161, description = 'xxxxxxx', exhaustion = 2000, premium = false, type = 'Instant', icon = 161, mana = 50, level = 20, soul = 0, group = {[3] = 2000}, vocations = {8}},
    ['Wrath of Nature'] = {id = 162, words = 'wrath of nature', icon_id = 162, description = 'xxxxxxx', exhaustion = 30000, premium = false, type = 'Instant', icon = 162, mana = 420, level = 100, soul = 0, group = {[1] = 1900}, vocations = {8}},
    ['Focus Healing'] = {id = 165, words = 'focus healing', icon_id = 165, description = 'xxxxxxx', exhaustion = 1000, parameter = true, premium = false, type = 'Instant', icon = 165, mana = 140, level = 20, soul = 0, group = {[2] = 1900}, vocations = {8}},
    ['Ice Shatter'] = {id = 166, words = 'ice shatter', icon_id = 166, description = 'xxxxxxx', exhaustion = 5500, premium = false, type = 'Instant', icon = 166, mana = 85, level = 30, soul = 0, group = {[1] = 1900}, vocations = {8}},
    ['Frost Armor'] = {id = 168, words = 'frost armor', icon_id = 168, description = 'xxxxxxx', exhaustion = 5500, premium = false, type = 'Instant', icon = 168, mana = 85, level = 30, soul = 0, group = {[1] = 1900}, vocations = {8}},

    --light dancer
    ['Charged Strike'] = {id = 170, words = 'charged strike', icon_id = 170, description = 'xxxxxxx', exhaustion = 3000, premium = false, type = 'Instant', icon = 170, mana = 25, level = 8, soul = 0, group = {[1] = 1900}, vocations = {9}},
    ['Static Charge'] = {id = 171, words = 'static charge', icon_id = 171, description = 'xxxxxxx', exhaustion = 2200, premium = false, type = 'Instant', icon = 171, mana = 0, level = 15, soul = 0, group = {[1] = 0}, vocations = {9}},
    ['Light Dash'] = {id = 172, words = 'light dash', icon_id = 172, description = 'xxxxxxx', exhaustion = 6000, premium = false, type = 'Instant', icon = 172, mana = 65, level = 18, soul = 0, group = {[1] = 0}, vocations = {9}},
    ['Veil of Swords'] = {id = 174, words = 'veil of swords', icon_id = 174, description = 'xxxxxxx', exhaustion = 15000, premium = false, type = 'Instant', icon = 174, mana = 0, level = 1, soul = 0, group = {[1] = 1900}, vocations = {9}},
    ['Magnetic Shield'] = {id = 175, words = 'magnetic shield', icon_id = 175, description = 'xxxxxxx', exhaustion = 45000, premium = false, type = 'Instant', icon = 175, mana = 115, level = 1, soul = 0, group = {[1] = 0}, vocations = {9}},
    ['Lightning Spear'] = {id = 176, words = 'lightning spear', icon_id = 176, description = 'xxxxxxx', exhaustion = 12000, premium = false, type = 'Instant', icon = 176, mana = 85, level = 30, soul = 0, group = {[1] = 1900}, vocations = {9}},
    ['Overcharge'] = {id = 177, words = 'overcharge', icon_id = 177, description = 'xxxxxxx', exhaustion = 30000, premium = false, type = 'Instant', icon = 177, mana = 115, level = 45, soul = 0, group = {[1] = 0}, vocations = {9}},
    ['Elusive Blade'] = {id = 178, words = 'elusive blade', icon_id = 178, description = 'xxxxxxx', exhaustion = 35000, premium = false, type = 'Instant', icon = 178, mana = 175, level = 90, soul = 0, group = {[1] = 1900}, vocations = {9}},
    ['Magnetic Orb'] = {id = 179, words = 'magnetic orb', icon_id = 179, description = 'xxxxxxx', exhaustion = 26000, premium = false, type = 'Instant', icon = 179, mana = 190, level = 100, soul = 0, group = {[1] = 1900}, vocations = {9}},
    ['Tempest Coin'] = {id = 180, words = 'tempest coin', icon_id = 180, description = 'xxxxxxx', exhaustion = 22000, premium = false, type = 'Instant', icon = 180, mana = 115, level = 1, soul = 0, group = {[1] = 0}, vocations = {9}},

    --Archer
    ['Flaming Shot'] =              {id = 181, icon_id = 181, words = 'Flaming Shot', exhaustion = 3000, premium = false, type = 'Instant', icon = 181, mana = 30, level = 8, soul = 0, group = {[1] = 1000}, parameter = false, vocations = {10}, description = 'shoot a flaming shot to the target dealing fire damage and burning the target (based on your ml), if the target is affected by beer barrel this spell will be powered and deal target max health damage. [Weapon Damage, DISTANCE, MAGIC LEVEL] & [Target MxHP]'},
    ['Explosive Barrel'] =          {id = 182, icon_id = 182,words = 'Explosive Barrel', exhaustion = 15000, premium = false, type = 'Instant', icon = 182, mana = 150, level = 1, soul = 0, group = {[3] = 1000}, parameter = false, vocations = {10}, description = 'throws an explosive barrel that explodes after a short time duration, dealing area damage.'},
    ['Explosive Shot'] =            {id = 183, icon_id = 183, words = 'Explosive Shot', exhaustion = 15000, premium = false, type = 'Instant', icon = 183, mana = 90, level = 1, soul = 0, group = {[1] = 1000}, parameter = false, vocations = {10}, description = 'shoot 4 rounds of explosive shots dealing aoe damage to the target location, if the target is affected by beer barrel this spell will be powered and deal target max health damage. [Weapon Damage, DISTANCE]'},
    ['Wind Barrel'] =               {id = 184, icon_id = 184, words = 'Wind Barrel', exhaustion = 5000, premium = false, type = 'Instant', icon = 184, mana = 40, level = 40, soul = 0, group = {[3] = 1000}, parameter = false, vocations = {10}, description = 'creates a wind barrel that explodes after a short time duration increasing your movement speed drastically.'},
    ['Condemn Shot'] =              {id = 185, icon_id = 185, words = 'Condemn Shot', exhaustion = 25000, premium = false, type = 'Instant', icon = 185, mana = 60, level = 28, soul = 0, group = {[3] = 1000}, parameter = false, vocations = {10}, description = 'repels your target away from the caster. [Weapon Damage, DISTANCE]'},
    ['Healing Barrel'] =            {id = 187, icon_id = 187, words = 'Healing Barrel', exhaustion = 8000, premium = false, type = 'Instant', icon = 187, mana = 120, level = 60, soul = 0, group = {[2] = 1000}, parameter = false, vocations = {10}, description = 'creates a healing barrel that explodes after a short time duration healing all players in the area.'},
    ['Arrow rain'] =                {id = 188, icon_id = 188, words = 'Arrow rain', exhaustion = 15000, premium = false, type = 'Instant', icon = 188, mana = 130, level = 50, soul = 0, group = {[1] = 1000}, parameter = false, vocations = {10}, description = 'cast a arrow rain into the target dealing physical damage to all enemies in the area.[Weapon Damage, DISTANCE]'},
    ['Frost Barrel'] =              {id = 189, icon_id = 189,words = 'Frost Barrel', exhaustion = 15000, premium = false, type = 'Instant', icon = 189, mana = 150, level = 70, soul = 0, group = {[3] = 1000}, parameter = false, vocations = {10}, description = 'creates a frost barrel that explodes after a short time duration freezing all enemies in the area.'},
    ['Phantom Shot'] =              {id = 190, icon_id = 190, words = 'Phantom Shot', exhaustion = 22000, premium = false, type = 'Instant', icon = 190, mana = 250, level = 1, soul = 0, group = {[1] = 1000}, parameter = false, vocations = {10}, description = 'shoots a phantom shot at the target, dealing high damage. [Weapon Damage, DISTANCE]'},
    ['Arrow Barrage'] =             {id = 191, icon_id = 191, words = 'Arrow Barrage', exhaustion = 22000, premium = false, type = 'Instant', icon = 191, mana = 250, level = 50, soul = 0, group = {[1] = 1000, [1] = 2000}, parameter = false, vocations = {10}, description = 'shoot multiple dark shots into all nearby enemies dealing physical damage. [Weapon Damage, DISTANCE]'},
    ['Rapid Fire'] =                {id = 192, icon_id = 192, words = 'Rapid Fire', exhaustion = 6000, premium = false, type = 'Instant', icon = 192, mana = 75, level = 30, soul = 0, group = {[1] = 1000}, parameter = false, vocations = {10}, description = 'shoots a rapid succession of arrows at the target. [Weapon Damage, DISTANCE]'},
    ['Ice Arrow'] =                 {id = 193, icon_id = 193, words = 'Ice Arrow', exhaustion = 3000, premium = false, type = 'Instant', icon = 193, mana = 30, level = 8, soul = 0, group = {[1] = 1000}, parameter = false, vocations = {10}, description = 'shoots an ice arrow at the target, dealing ice damage and slowing the target. [Weapon Damage, DISTANCE]'},
    ['Falcon Shot'] =               {id = 194, icon_id = 194, words = 'Falcon Shot', exhaustion = 3000, premium = false, type = 'Instant', icon = 194, mana = 120, level = 1, soul = 0, group = {[1] = 1000}, parameter = false, vocations = {10}, description = 'shoots a falcon shot at the target, dealing high damage. [Weapon Damage, DISTANCE]'},
    
    --others
    ['Minor Heal'] = {id = 200, words = 'minor heal', icon_id = 200, description = 'xxxxxxx', exhaustion = 2000, premium = false, type = 'Instant', icon = 200, mana = 20, level = 1, soul = 0, group = {[2] = 1900}, vocations = {1,2,3,4,5,6,7,8,9,10}},
    ['Strong Heal'] = {id = 201, words = 'strong heal', icon_id = 201, description = 'xxxxxxx', exhaustion = 2000, premium = false, type = 'Instant', icon = 201, mana = 65, level = 25, soul = 0, group = {[2] = 1900}, vocations = {1,2,3,4,5,6,7,8,9,10}},
    ['Great Heal'] = {id = 202, words = 'great heal', icon_id = 202, description = 'xxxxxxx', exhaustion = 2000, premium = false, type = 'Instant', icon = 202, mana = 120, level = 50, soul = 0, group = {[2] = 1900}, vocations = {1,2,3,4,5,6,7,8,9,10}},

    ['Magic Shield'] = {id = 208, words = 'Magic Shield', icon_id = 208, description = 'Creates a protective barrier that absorbs damage.', exhaustion = 2000, premium = false, type = 'Instant', icon = 208, mana = 0, level = 1, soul = 0, group = {[2] = 2000}, vocations = {1,5,8,6}},
    ['Find Person'] = {id = 209, words = 'exiva', icon_id = 209, description = 'Reveals the location of a player.', exhaustion = 1000, premium = false, type = 'Instant', icon = 209, mana = 20, level = 8, soul = 0, group = {[2] = 1900}, vocations = {1,2,3,4,5,6,7,8,9,10}},
    ['Food'] = {id = 210, words = 'exevo pan', icon_id = 210, description = 'Creates food to restore hunger.', exhaustion = 2000, premium = false, type = 'Instant', icon = 210, mana = 15, level = 8, soul = 1, group = {[2] = 2000}, vocations = {1,2,3,4,5,6,7,8,9,10}},
    ['Haste'] = {id = 211, words = 'utani hur', icon_id = 211, description = 'Increases movement speed for a short duration.', exhaustion = 2000, premium = false, type = 'Instant', icon = 211, mana = 60, level = 14, soul = 0, group = {[2] = 2000}, vocations = {1,2,3,4,5,6,7,8,9,10}},
    ['Levitate'] = {id = 212, words = 'exani hur', icon_id = 212, description = 'Allows the caster to move up or down floors.', exhaustion = 2000, premium = false, type = 'Instant', icon = 212, mana = 50, level = 12, soul = 0, group = {[2] = 2000}, vocations = {1,2,3,4,5,6,7,8,9,10}},
    ['Light'] = {id = 213, words = 'utevo lux', icon_id = 213, description = 'Creates a light source around the caster.', exhaustion = 2000, premium = false, type = 'Instant', icon = 213, mana = 20, level = 8, soul = 0, group = {[2] = 2000}, vocations = {1,2,3,4,5,6,7,8,9,10}},
    
  
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
    local profile = Spells.getSpellProfileByName(spellName)

    local id = SpellInfo[profile][spellName].icon
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
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.words == words then
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
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.words == words then
                return profile
            end
        end
    end
    return nil
end

function Spells.getSpellProfileByName(spellName)
    for profile, data in pairs(SpellInfo) do
        if table.findbykey(data, spellName:trim(), true) then
            return profile
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
    --use iconid as SpellInfo[profile].id to finde SpellInfo[profile].iconid
    --print(iconid)
    for k, v in pairs(SpellInfo[profile]) do
        if v.id == iconid then
            return SpelllistSettings[profile].iconFile .. '/' .. tostring(v.icon_id) .. '.png'
        end
    end
end

function Spells.getIconFileByProfile(profile)
    return SpelllistSettings[profile]['iconFile']
end
