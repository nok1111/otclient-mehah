-- Wiki Data
-- Multilanguage content for the wiki system
-- Add more content here as needed

function getWikiData(language)
  if language == 'es' then
    return getSpanishData()
  else
    return getEnglishData()
  end
end

function getEnglishData()
  return {
    categories = {
      items = {
        name = 'Items',
        subcategories = {
          dropable_spells = {
            name = 'Dropable Spells',
            type = 'list',
            items = {
              {
                name = 'Fireball Spell',
                description = 'A powerful fire spell that deals AoE damage',
                icon = 2260
              },
              {
                name = 'Ice Wave Spell',
                description = 'Freezes enemies in a wave pattern',
                icon = 2261
              },
              {
                name = 'Lightning Strike',
                description = 'Calls down lightning on your enemies',
                icon = 2262
              }
            }
          },
          runes = {
            name = 'Runes',
            type = 'list',
            items = {
              {
                name = 'Ultimate Healing Rune',
                description = 'Restores a large amount of HP',
                icon = 2273
              },
              {
                name = 'Great Fireball Rune',
                description = 'Creates a massive fireball',
                icon = 2304
              },
              {
                name = 'Paralyze Rune',
                description = 'Paralyzes the target',
                icon = 2278
              }
            }
          },
          sample = {
            name = 'Sample Category 1',
            type = 'list',
            items = {
              {
                name = 'Sample Item 1',
                description = 'This is a sample item for testing',
                icon = 2160
              }
            }
          },
          sample2 = {
            name = 'Sample Category 2',
            type = 'list',
            items = {
              {
                name = 'Sample Item 2',
                description = 'Another sample item',
                icon = 2159
              }
            }
          },
          stat_enchantments = {
            name = 'Stat Enchantments',
            type = 'enchants',
            items = {
              {
                name = 'Max HP',
                description = 'Increases your maximum health points',
                enchantType = 'Condition',
                valuesPerLevel = '2.0 per level',
                minLevel = 15,
                equipment = 'Armor, Boots, Shield, Ring, Amulet, Necklace, Weapon, Ammo',
                icon = 2392
              },
              {
                name = 'Max Mana',
                description = 'Increases your maximum mana points',
                enchantType = 'Condition',
                valuesPerLevel = '2.0 per level',
                minLevel = 15,
                equipment = 'Armor, Boots, Shield, Ring, Amulet, Necklace, Weapon, Ammo',
                icon = 2392
              },
              {
                name = 'Magic Level',
                description = 'Boosts your magic level for stronger spells',
                enchantType = 'Condition',
                valuesPerLevel = '0.1 per level',
                minLevel = 15,
                equipment = 'Armor, Boots, Shield, Ring, Amulet, Necklace, Weapon, Ammo',
                icon = 2392
              },
              {
                name = 'Melee',
                description = 'Improves sword, club and axe fighting skills',
                enchantType = 'Condition',
                valuesPerLevel = '0.1 per level',
                minLevel = 15,
                equipment = 'Armor, Boots, Shield, Ring, Amulet, Necklace, Weapon, Ammo',
                icon = 2392
              },
              {
                name = 'Arcana',
                description = 'Enhances magical combat proficiency',
                enchantType = 'Condition',
                valuesPerLevel = '0.1 per level',
                minLevel = 15,
                equipment = 'Armor, Boots, Shield, Ring, Amulet, Necklace, Weapon, Ammo',
                icon = 2392
              },
              {
                name = 'Distance',
                description = 'Increases accuracy with ranged weapons',
                enchantType = 'Condition',
                valuesPerLevel = '0.1 per level',
                minLevel = 15,
                equipment = 'Armor, Boots, Ring, Necklace, Weapon, Ammo',
                icon = 2392
              },
              {
                name = 'Defence',
                description = 'Improves your shielding ability',
                enchantType = 'Condition',
                valuesPerLevel = '0.1 per level',
                minLevel = 15,
                equipment = 'Armor, Boots, Shield, Ring, Necklace, Weapon',
                icon = 2392
              }
            }
          },
          combat_enchantments = {
            name = 'Combat Enchantments',
            type = 'enchants',
            items = {
              {
                name = 'Critical Hit Chance',
                description = 'Increases chance to deal critical damage',
                enchantType = 'Condition',
                valuesPerLevel = '0.1% per level',
                minLevel = 15,
                equipment = 'Necklace, Ring',
                icon = 2393
              },
              {
                name = 'Attack Speed',
                description = 'Makes you attack faster',
                enchantType = 'Condition',
                valuesPerLevel = '0.1% per level',
                minLevel = 15,
                equipment = 'Weapon',
                icon = 2393
              },
              {
                name = 'Bonus Healing',
                description = 'Increases effectiveness of healing spells and potions',
                enchantType = 'Condition',
                valuesPerLevel = '0.1% per level',
                minLevel = 15,
                equipment = 'Necklace, Ring, Shield',
                icon = 2393
              },
              {
                name = 'Life Steal',
                description = 'Recovers health when dealing damage',
                enchantType = 'Condition',
                valuesPerLevel = '0.1% per level',
                minLevel = 15,
                equipment = 'Weapon',
                icon = 2393
              },
              {
                name = 'Mana Shield',
                description = 'Absorbs damage using mana instead of health',
                enchantType = 'Condition',
                valuesPerLevel = 'On/Off effect',
                minLevel = 5,
                equipment = 'Ring',
                icon = 2393
              },
              {
                name = 'Experience',
                description = 'Grants bonus experience from all sources',
                enchantType = 'Special',
                valuesPerLevel = '0.04% per level',
                minLevel = 25,
                equipment = 'Necklace, Ring',
                icon = 2393
              }
            }
          },
          offensive_enchantments = {
            name = 'Offensive Enchantments',
            type = 'enchants',
            items = {
              {
                name = 'Physical Damage',
                description = 'Amplifies all physical damage dealt',
                enchantType = 'Offensive',
                valuesPerLevel = '0.2% per level',
                minLevel = 25,
                equipment = 'Weapon, Necklace, Ring, Shield',
                icon = 2394
              },
              {
                name = 'Fire Damage',
                description = 'Increases fire element damage',
                enchantType = 'Offensive',
                valuesPerLevel = '0.2% per level',
                minLevel = 25,
                equipment = 'Weapon, Necklace, Ring, Shield',
                icon = 2394
              },
              {
                name = 'Ice Damage',
                description = 'Increases ice element damage',
                enchantType = 'Offensive',
                valuesPerLevel = '0.2% per level',
                minLevel = 25,
                equipment = 'Weapon, Necklace, Ring, Shield',
                icon = 2394
              },
              {
                name = 'Energy Damage',
                description = 'Increases energy element damage',
                enchantType = 'Offensive',
                valuesPerLevel = '0.2% per level',
                minLevel = 25,
                equipment = 'Weapon, Necklace, Ring, Shield',
                icon = 2394
              },
              {
                name = 'Holy Damage',
                description = 'Increases holy element damage',
                enchantType = 'Offensive',
                valuesPerLevel = '0.2% per level',
                minLevel = 25,
                equipment = 'Weapon, Necklace, Ring, Shield',
                icon = 2394
              },
              {
                name = 'Death Damage',
                description = 'Increases death element damage',
                enchantType = 'Offensive',
                valuesPerLevel = '0.2% per level',
                minLevel = 25,
                equipment = 'Weapon, Necklace, Ring, Shield',
                icon = 2394
              },
              {
                name = 'Earth Damage',
                description = 'Increases earth element damage',
                enchantType = 'Offensive',
                valuesPerLevel = '0.2% per level',
                minLevel = 25,
                equipment = 'Weapon, Necklace, Ring, Shield',
                icon = 2394
              }
            }
          },
          defensive_enchantments = {
            name = 'Defensive Enchantments',
            type = 'enchants',
            items = {
              {
                name = 'Physical Protection',
                description = 'Reduces physical damage taken',
                enchantType = 'Defensive',
                valuesPerLevel = '0.1% per level',
                minLevel = 10,
                equipment = 'Necklace, Ring',
                icon = 2395
              },
              {
                name = 'Fire Protection',
                description = 'Reduces fire damage taken',
                enchantType = 'Defensive',
                valuesPerLevel = '0.1% per level',
                minLevel = 10,
                equipment = 'Necklace, Ring',
                icon = 2395
              },
              {
                name = 'Ice Protection',
                description = 'Reduces ice damage taken',
                enchantType = 'Defensive',
                valuesPerLevel = '0.1% per level',
                minLevel = 10,
                equipment = 'Necklace, Ring',
                icon = 2395
              },
              {
                name = 'Energy Protection',
                description = 'Reduces energy damage taken',
                enchantType = 'Defensive',
                valuesPerLevel = '0.08% per level',
                minLevel = 10,
                equipment = 'Necklace, Ring',
                icon = 2395
              }
            }
          },
          trigger_enchantments = {
            name = 'Trigger Enchantments (Special)',
            type = 'enchants',
            items = {
              {
                name = 'Flame Strike on Attack',
                description = '5% chance to cast flame strike when attacking',
                enchantType = 'Trigger: Attack',
                valuesPerLevel = '2.5 damage per level',
                minLevel = 10,
                equipment = 'Weapon',
                icon = 2396,
                effect = '5% chance to cast on attack'
              },
              {
                name = 'Flame Strike on Hit',
                description = '20% chance to cast flame strike when hit',
                enchantType = 'Trigger: Hit',
                valuesPerLevel = '1.0 damage per level',
                minLevel = 10,
                equipment = 'Shield',
                icon = 2396,
                effect = '20% chance to cast when hit'
              },
              {
                name = 'Ice Strike on Attack',
                description = '5% chance to cast ice strike and slow enemy',
                enchantType = 'Trigger: Attack',
                valuesPerLevel = '1.7 damage per level',
                minLevel = 10,
                equipment = 'Weapon',
                icon = 2396,
                effect = '5% chance + slow effect'
              },
              {
                name = 'Critical Damage Buff',
                description = '5% chance on kill to gain critical damage buff',
                enchantType = 'Trigger: Kill',
                valuesPerLevel = '1.0% per level',
                minLevel = 5,
                equipment = 'Weapon, Necklace, Ring',
                icon = 2396,
                effect = '5% on kill: +crit for 20s'
              },
              {
                name = 'Monk Teachings',
                description = '8% chance on kill to gain attack speed boost',
                enchantType = 'Trigger: Kill',
                valuesPerLevel = '6% per level',
                minLevel = 20,
                equipment = 'Weapon',
                icon = 2396,
                effect = '8% on kill: +attack speed 20s'
              },
              {
                name = 'Iron Skin Buff',
                description = '20% chance on kill to gain deflect buff',
                enchantType = 'Trigger: Kill',
                valuesPerLevel = '3% per level',
                minLevel = 5,
                equipment = 'Shield',
                icon = 2396,
                effect = '20% on kill: deflect buff 20s'
              },
              {
                name = 'Bob Bomb on Kill',
                description = 'Chance to spawn a Bob Bomb helper on kill',
                enchantType = 'Trigger: Kill',
                valuesPerLevel = '0.6% per level',
                minLevel = 5,
                equipment = 'Weapon',
                icon = 2396,
                effect = 'Spawns Bob Bomb on kill'
              },
              {
                name = 'Treasure Goblin on Kill',
                description = 'Small chance to spawn treasure goblin on kill',
                enchantType = 'Trigger: Kill',
                valuesPerLevel = '0.2 per level',
                minLevel = 20,
                equipment = 'Necklace, Ring',
                icon = 2396,
                effect = '1/300 chance per kill'
              }
            }
          }
        }
      },
      dungeons = {
        name = 'Dungeons',
        subcategories = {
          dungeon_stones = {
            name = 'Dungeon Teleport Stones',
            type = 'list',
            items = {
              {
                name = 'Demon Dungeon Stone',
                description = 'Teleports to the Demon Dungeon. Required level: 150',
                icon = 1950
              },
              {
                name = 'Dragon Lair Stone',
                description = 'Teleports to the Dragon Lair. Required level: 100',
                icon = 1951
              },
              {
                name = 'Vampire Crypt Stone',
                description = 'Teleports to the Vampire Crypt. Required level: 80',
                icon = 1952
              }
            }
          },
          bosses = {
            name = 'Boss Information',
            type = 'list',
            items = {
              {
                name = 'Demon Lord',
                description = 'HP: 50,000 | Location: Demon Dungeon | Drops: Demon Armor, Demon Legs',
                icon = 5080
              },
              {
                name = 'Ancient Dragon',
                description = 'HP: 35,000 | Location: Dragon Lair | Drops: Dragon Scale Mail',
                icon = 5081
              },
              {
                name = 'Vampire Prince',
                description = 'HP: 25,000 | Location: Vampire Crypt | Drops: Vampire Shield',
                icon = 5082
              }
            }
          }
        }
      },
      currencies = {
        name = 'Currencies',
        subcategories = {
          fame = {
            name = 'Fame Points',
            type = 'text',
            content = 'Fame points are earned by completing quests and defeating bosses.\n\nUses:\n• Purchase exclusive items from NPC shops\n• Unlock special areas\n• Buy cosmetic items\n\nHow to earn:\n• Daily quests: 10-50 fame\n• Boss kills: 100-500 fame\n• Events: varies'
          },
          valuable_pouches = {
            name = 'Valuable Pouches',
            type = 'list',
            items = {
              {
                name = 'Bronze Pouch',
                description = 'Contains 100-500 gold. Common drop from monsters.',
                icon = 2853
              },
              {
                name = 'Silver Pouch',
                description = 'Contains 500-2000 gold. Rare drop from monsters.',
                icon = 2854
              },
              {
                name = 'Golden Pouch',
                description = 'Contains 2000-10000 gold. Very rare drop.',
                icon = 2855
              }
            }
          }
        }
      },
      pets = {
        name = 'Pets',
        subcategories = {
          epic_pets = {
            name = 'Epic Pets',
            type = 'pets',
            items = {
              {
                name = 'Baby Nightmare',
                outfitId = 321,
                rarity = 'Epic',
                element = 'Fire',
                collector = 'Spooky Collector',
                abilities = {
                  { name = 'Nightmare Flames', description = 'Fire damage + fear effect to enemies' }
                }
              },
              {
                name = 'Baby Prisma',
                outfitId = 2116,
                rarity = 'Epic',
                element = 'Multi-element',
                collector = 'Palette / Mythical Collector',
                abilities = {
                  { name = 'Prismatic Beam', description = 'Shoots multi-element laser beam' }
                }
              },
              {
                name = 'Terroc',
                outfitId = 2200,
                rarity = 'Epic',
                element = 'Energy',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Thunder Strike', description = 'Energy AoE damage + stun' }
                }
              },
              {
                name = 'Spectre',
                outfitId = 1588,
                rarity = 'Epic',
                element = 'Death',
                collector = 'Spooky Collector',
                abilities = {
                  { name = 'Soul Devour', description = 'Death damage + life steal effect' }
                }
              },
              {
                name = 'Winged Angel',
                outfitId = 1324,
                rarity = 'Epic',
                element = 'Holy',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Divine Wrath', description = 'Holy AoE damage + heal' }
                }
              },
              {
                name = 'The Thing',
                outfitId = 1353,
                rarity = 'Epic',
                element = 'Death',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Consume', description = 'Multi-element damage + buff' }
                }
              }
            }
          },
          rare_pets = {
            name = 'Rare Pets',
            type = 'pets',
            items = {
              {
                name = 'Baby Fire Fenix',
                outfitId = 1978,
                rarity = 'Rare',
                element = 'Fire',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Flame Aura', description = 'Fire AoE + 10% fire damage buff for 8s' }
                }
              },
              {
                name = 'Baby Ice Fenix',
                outfitId = 1977,
                rarity = 'Rare',
                element = 'Ice',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Frost Wave', description = 'Ice AoE + slow enemies' }
                }
              },
              {
                name = 'Mystic Baby Dragon',
                outfitId = 2173,
                rarity = 'Rare',
                element = 'Holy/Ice',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Mystic Breath', description = 'Holy + Ice combo damage' }
                }
              },
              {
                name = 'Wolf Cub',
                outfitId = 1709,
                rarity = 'Rare',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Howl', description = 'Buff attack damage for party' }
                }
              },
              {
                name = 'Old Mummy',
                outfitId = 2223,
                rarity = 'Rare',
                element = 'Death',
                collector = 'Spooky Collector',
                abilities = {
                  { name = 'Curse', description = 'Death DoT + reduce healing' }
                }
              },
              {
                name = 'Green Ghost',
                outfitId = 566,
                rarity = 'Rare',
                element = 'Death',
                collector = 'Spooky Collector',
                abilities = {
                  { name = 'Spectral Touch', description = 'Death damage + slow' }
                }
              },
              {
                name = 'Darkin',
                outfitId = 1887,
                rarity = 'Rare',
                element = 'Death',
                collector = 'Spooky Collector',
                abilities = {
                  { name = 'Shadow Strike', description = 'Death ranged damage' }
                }
              },
              {
                name = 'Fairy',
                outfitId = 983,
                rarity = 'Rare',
                element = 'Holy',
                collector = 'Mythical / Palette Collector',
                abilities = {
                  { name = 'Fairy Dust', description = 'Heal + buff owner' }
                }
              },
              {
                name = 'Dream Slime',
                outfitId = 1597,
                rarity = 'Rare',
                element = 'Holy',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Dream Mist', description = 'Sleep + heal effect' }
                }
              },
              {
                name = 'Small Dragon-Fly',
                outfitId = 528,
                rarity = 'Rare',
                element = 'Energy',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Lightning Bolt', description = 'Energy ranged damage' }
                }
              },
              {
                name = 'Golden Cat',
                outfitId = 2005,
                rarity = 'Rare',
                element = 'Holy',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Divine Scratch', description = 'Holy melee damage' }
                }
              },
              {
                name = 'Baby Angel',
                outfitId = 1326,
                rarity = 'Rare',
                element = 'Holy',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Blessing', description = 'Heal + buff owner' }
                }
              },
              {
                name = 'Baby Frazzlemaw',
                outfitId = 594,
                rarity = 'Rare',
                element = 'Fire',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Fireball', description = 'Fire ranged damage' }
                }
              },
              {
                name = 'Baby Vector',
                outfitId = 680,
                rarity = 'Rare',
                element = 'Energy',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Vector Beam', description = 'Energy laser damage' }
                }
              },
              {
                name = 'Baby Rex',
                outfitId = 2168,
                rarity = 'Rare',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Roar', description = 'Physical buff to damage' }
                }
              },
              {
                name = 'Air Elemental',
                outfitId = 1354,
                rarity = 'Rare',
                element = 'Energy',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Air Blast', description = 'Energy push + damage' }
                }
              },
              {
                name = 'Baby Elemental',
                outfitId = 2075,
                rarity = 'Rare',
                element = 'Energy',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Spark', description = 'Energy ranged damage' }
                }
              },
              {
                name = 'Bee Queen',
                outfitId = 1758,
                rarity = 'Rare',
                element = 'Poison',
                collector = 'Bugs Collector',
                abilities = {
                  { name = 'Bee Swarm', description = 'Poison multi-hit damage' }
                }
              },
              {
                name = 'Lion',
                outfitId = 41,
                rarity = 'Rare',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Majestic Roar', description = 'Attack buff to party' }
                }
              }
            }
          },
          uncommon_pets = {
            name = 'Uncommon Pets',
            type = 'pets',
            items = {
              {
                name = 'Purple Chicken',
                outfitId = 2172,
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Chef Collector',
                abilities = {
                  { name = 'Enhanced Peck', description = 'Stronger physical melee' }
                }
              },
              {
                name = 'Baby Squid',
                outfitId = 451,
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Aquatic Collector',
                abilities = {
                  { name = 'Ink Cloud', description = 'Blind + physical damage' }
                }
              },
              {
                name = 'Crab',
                outfitId = 112,
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Aquatic / Chef Collector',
                abilities = {
                  { name = 'Pincer Strike', description = 'Physical melee damage' }
                }
              },
              {
                name = 'Black Spider',
                outfitId = 1482,
                rarity = 'Uncommon',
                element = 'Earth',
                collector = 'Bugs Collector',
                abilities = {
                  { name = 'Acid Spit', description = 'Earth ranged damage' }
                }
              },
              {
                name = 'Blood Bug',
                outfitId = 1888,
                rarity = 'Uncommon',
                element = 'Death',
                collector = 'Bugs Collector',
                abilities = {
                  { name = 'Blood Drain', description = 'Life steal attack' }
                }
              },
              {
                name = 'Bunny',
                outfitId = 1821,
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Chef Collector',
                abilities = {
                  { name = 'Quick Hop', description = 'Jump attack + speed' }
                }
              },
              {
                name = 'Sheep',
                outfitId = 1481,
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Chef Collector',
                abilities = {
                  { name = 'Ram', description = 'Charge attack' }
                }
              },
              {
                name = 'Night Butterfly',
                outfitId = 363,
                rarity = 'Uncommon',
                element = 'Energy',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Night Flash', description = 'Energy damage' }
                }
              },
              {
                name = 'Dark Slime',
                outfitId = 1960,
                rarity = 'Uncommon',
                element = 'Death',
                collector = 'Spooky Collector',
                abilities = {
                  { name = 'Dark Pulse', description = 'Death AoE damage' }
                }
              },
              {
                name = 'Jelly Jelly',
                outfitId = 452,
                rarity = 'Uncommon',
                element = 'Ice',
                collector = 'Aquatic Collector',
                abilities = {
                  { name = 'Jelly Bounce', description = 'Ice + knockback' }
                }
              },
              {
                name = 'Baby Twin Turtle',
                outfitId = 2103,
                rarity = 'Uncommon',
                element = 'Ice',
                collector = 'Aquatic Collector',
                abilities = {
                  { name = 'Twin Shell', description = 'Double defense buff' }
                }
              },
              {
                name = 'Scarab',
                outfitId = 83,
                rarity = 'Uncommon',
                element = 'Earth',
                collector = 'Bugs Collector',
                abilities = {
                  { name = 'Burrow Strike', description = 'Earth damage' }
                }
              },
              {
                name = 'Insectoid Larve',
                outfitId = 82,
                rarity = 'Uncommon',
                element = 'Poison',
                collector = 'Bugs Collector',
                abilities = {
                  { name = 'Larva Burst', description = 'Poison AoE' }
                }
              },
              {
                name = 'Baby Dworc',
                outfitId = 216,
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Club Hit', description = 'Physical melee' }
                }
              },
              {
                name = 'Baby Eyeboh',
                outfitId = 109,
                rarity = 'Uncommon',
                element = 'Death',
                collector = 'Spooky Collector',
                abilities = {
                  { name = 'Evil Eye', description = 'Death ranged' }
                }
              },
              {
                name = 'Goblin',
                outfitId = 1692,
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Spear Throw', description = 'Physical ranged' }
                }
              },
              {
                name = 'Gumateddy',
                outfitId = 313,
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Hug', description = 'Heal ally' }
                }
              },
              {
                name = 'Penguin',
                outfitId = 2211,
                rarity = 'Uncommon',
                element = 'Ice',
                collector = 'Aquatic Collector',
                abilities = {
                  { name = 'Ice Slide', description = 'Ice + slide' }
                }
              },
              {
                name = 'White Owl',
                outfitId = 2220,
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Talon Strike', description = 'Physical flying' }
                }
              }
            }
          },
          common_pets = {
            name = 'Common Pets',
            type = 'pets',
            items = {
              {
                name = 'White Cat',
                outfitId = 2027,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Scratch', description = 'Basic melee attack' }
                }
              },
              {
                name = 'Gray Cat',
                outfitId = 2026,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Scratch', description = 'Basic melee attack' }
                }
              },
              {
                name = 'Black Cat',
                outfitId = 2024,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Palette / Spooky Collector',
                abilities = {
                  { name = 'Shadow Claw', description = 'Physical melee' }
                }
              },
              {
                name = 'Chicken',
                outfitId = 111,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Chef Collector',
                abilities = {
                  { name = 'Peck', description = 'Basic melee attack' }
                }
              },
              {
                name = 'Rooster',
                outfitId = 1937,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Chef Collector',
                abilities = {
                  { name = 'Crow', description = 'Wake up call attack' }
                }
              },
              {
                name = 'Wasp',
                outfitId = 1992,
                rarity = 'Common',
                element = 'Poison',
                collector = 'Bugs Collector',
                abilities = {
                  { name = 'Poison Sting', description = 'Poison ranged' }
                }
              },
              {
                name = 'Seagul',
                outfitId = 223,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Dive Bomb', description = 'Stun + damage' }
                }
              },
              {
                name = 'Ghost',
                outfitId = 1273,
                rarity = 'Common',
                element = 'Death',
                collector = 'Spooky Collector',
                abilities = {
                  { name = 'Haunt', description = 'Death damage' }
                }
              },
              {
                name = 'Turtle',
                outfitId = 1841,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Aquatic Collector',
                abilities = {
                  { name = 'Shell Defense', description = 'Defense buff' }
                }
              },
              {
                name = 'Aqua Slime',
                outfitId = 1901,
                rarity = 'Common',
                element = 'Ice',
                collector = 'Aquatic Collector',
                abilities = {
                  { name = 'Frost Wave', description = 'Ice AoE' }
                }
              },
              {
                name = 'Sand Spider',
                outfitId = 1895,
                rarity = 'Common',
                element = 'Earth',
                collector = 'Bugs Collector',
                abilities = {
                  { name = 'Poison Web', description = 'Poison + slow' }
                }
              },
              {
                name = 'Bug',
                outfitId = 45,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Bugs Collector',
                abilities = {
                  { name = 'Bite', description = 'Basic melee' }
                }
              },
              {
                name = 'Deer',
                outfitId = 1805,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Antler Charge', description = 'Physical charge' }
                }
              },
              {
                name = 'Fox',
                outfitId = 1296,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Quick Bite', description = 'Fast melee' }
                }
              },
              {
                name = 'Squirrel',
                outfitId = 274,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild / Chef Collector',
                abilities = {
                  { name = 'Nut Throw', description = 'Ranged physical' }
                }
              },
              {
                name = 'Badger',
                outfitId = 105,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Dig Strike', description = 'Earth physical' }
                }
              },
              {
                name = 'Skunk',
                outfitId = 106,
                rarity = 'Common',
                element = 'Poison',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Stink Cloud', description = 'Poison AoE' }
                }
              },
              {
                name = 'Firewind Parrot',
                outfitId = 217,
                rarity = 'Common',
                element = 'Fire',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Fire Gust', description = 'Fire ranged' }
                }
              },
              {
                name = 'Flamingo',
                outfitId = 212,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Wing Slap', description = 'Physical melee' }
                }
              },
              {
                name = 'Bear Cub',
                outfitId = 1716,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Claw Swipe', description = 'Physical AoE' }
                }
              },
              {
                name = 'Boar Cub',
                outfitId = 1286,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Charge', description = 'Physical charge' }
                }
              },
              {
                name = 'Baby Poodle',
                outfitId = 467,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Bark', description = 'Physical ranged' }
                }
              },
              {
                name = 'Dog',
                outfitId = 32,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Bite', description = 'Physical melee' }
                }
              },
              {
                name = 'Husky',
                outfitId = 258,
                rarity = 'Common',
                element = 'Ice',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Ice Howl', description = 'Ice AoE' }
                }
              },
              {
                name = 'Mouse',
                outfitId = 1886,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Nibble', description = 'Fast melee' }
                }
              },
              {
                name = 'Old Dog',
                outfitId = 1806,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Old Bite', description = 'Weak melee' }
                }
              },
              {
                name = 'Small Pidgeon',
                outfitId = 531,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Fly Peck', description = 'Flying melee' }
                }
              },
              {
                name = 'Baby Crow',
                outfitId = 1559,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Peck', description = 'Flying melee' }
                }
              },
              {
                name = 'Snake',
                outfitId = 1803,
                rarity = 'Common',
                element = 'Poison',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Poison Bite', description = 'Poison melee' }
                }
              },
              {
                name = 'Cobra',
                outfitId = 81,
                rarity = 'Common',
                element = 'Poison',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Venom Bite', description = 'Poison melee' }
                }
              },
              {
                name = 'Snail',
                outfitId = 2186,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Bugs Collector',
                abilities = {
                  { name = 'Slow Slime', description = 'Slow trail' }
                }
              },
              {
                name = 'Night Frog',
                outfitId = 412,
                rarity = 'Common',
                element = 'Poison',
                collector = 'Aquatic Collector',
                abilities = {
                  { name = 'Poison Spit', description = 'Poison ranged' }
                }
              },
              {
                name = 'Rabit',
                outfitId = 1821,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Hop', description = 'Jump away' }
                }
              },
              {
                name = 'Furry',
                outfitId = 1263,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Cuddle', description = 'Heal' }
                }
              },
              {
                name = 'Baby',
                outfitId = 1267,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Special',
                abilities = {
                  { name = 'Baby Cry', description = 'Confusion' }
                }
              }
            }
          }
        }
      }
    }
  }
end

function getSpanishData()
  return {
    categories = {
      items = {
        name = 'Objetos',
        subcategories = {
          dropable_spells = {
            name = 'Hechizos Dropeables',
            type = 'list',
            items = {
              {
                name = 'Hechizo de Bola de Fuego',
                description = 'Un poderoso hechizo de fuego que hace daño en área',
                icon = 2260
              },
              {
                name = 'Hechizo de Ola de Hielo',
                description = 'Congela enemigos en patrón de ola',
                icon = 2261
              },
              {
                name = 'Rayo',
                description = 'Invoca un rayo sobre tus enemigos',
                icon = 2262
              }
            }
          },
          runes = {
            name = 'Runas',
            type = 'list',
            items = {
              {
                name = 'Runa de Curación Suprema',
                description = 'Restaura una gran cantidad de HP',
                icon = 2273
              },
              {
                name = 'Runa de Gran Bola de Fuego',
                description = 'Crea una bola de fuego masiva',
                icon = 2304
              },
              {
                name = 'Runa de Parálisis',
                description = 'Paraliza al objetivo',
                icon = 2278
              }
            }
          },
          sample = {
            name = 'Categoría de Muestra 1',
            type = 'list',
            items = {
              {
                name = 'Objeto de Muestra 1',
                description = 'Este es un objeto de muestra para pruebas',
                icon = 2160
              }
            }
          },
          sample2 = {
            name = 'Categoría de Muestra 2',
            type = 'list',
            items = {
              {
                name = 'Objeto de Muestra 2',
                description = 'Otro objeto de muestra',
                icon = 2159
              }
            }
          },
          enchantments = {
            name = 'Encantamientos',
            type = 'list',
            items = {
              {
                name = 'Encantamiento de Fuego',
                description = 'Añade daño de fuego a tu arma (+15% daño de fuego)',
                icon = 2392
              },
              {
                name = 'Encantamiento de Hielo',
                description = 'Añade daño de hielo a tu arma (+15% daño de hielo)',
                icon = 2393
              },
              {
                name = 'Encantamiento Sagrado',
                description = 'Añade daño sagrado a tu arma (+15% daño sagrado)',
                icon = 2394
              }
            }
          }
        }
      },
      dungeons = {
        name = 'Mazmorras',
        subcategories = {
          dungeon_stones = {
            name = 'Piedras de Teleporte de Mazmorras',
            type = 'list',
            items = {
              {
                name = 'Piedra de Mazmorra Demoníaca',
                description = 'Teletransporta a la Mazmorra Demoníaca. Nivel requerido: 150',
                icon = 1950
              },
              {
                name = 'Piedra de Guarida del Dragón',
                description = 'Teletransporta a la Guarida del Dragón. Nivel requerido: 100',
                icon = 1951
              },
              {
                name = 'Piedra de Cripta Vampírica',
                description = 'Teletransporta a la Cripta Vampírica. Nivel requerido: 80',
                icon = 1952
              }
            }
          },
          bosses = {
            name = 'Información de Jefes',
            type = 'list',
            items = {
              {
                name = 'Señor Demonio',
                description = 'HP: 50,000 | Ubicación: Mazmorra Demoníaca | Drops: Armadura Demoníaca',
                icon = 5080
              },
              {
                name = 'Dragón Ancestral',
                description = 'HP: 35,000 | Ubicación: Guarida del Dragón | Drops: Armadura de Escamas',
                icon = 5081
              },
              {
                name = 'Príncipe Vampiro',
                description = 'HP: 25,000 | Ubicación: Cripta Vampírica | Drops: Escudo Vampírico',
                icon = 5082
              }
            }
          }
        }
      },
      currencies = {
        name = 'Monedas',
        subcategories = {
          fame = {
            name = 'Puntos de Fama',
            type = 'text',
            content = 'Los puntos de fama se ganan completando misiones y derrotando jefes.\n\nUsos:\n• Comprar objetos exclusivos en tiendas NPC\n• Desbloquear áreas especiales\n• Comprar objetos cosméticos\n\nCómo ganar:\n• Misiones diarias: 10-50 fama\n• Matar jefes: 100-500 fama\n• Eventos: varía'
          },
          valuable_pouches = {
            name = 'Bolsas Valiosas',
            type = 'list',
            items = {
              {
                name = 'Bolsa de Bronce',
                description = 'Contiene 100-500 oro. Drop común de monstruos.',
                icon = 2853
              },
              {
                name = 'Bolsa de Plata',
                description = 'Contiene 500-2000 oro. Drop raro de monstruos.',
                icon = 2854
              },
              {
                name = 'Bolsa Dorada',
                description = 'Contiene 2000-10000 oro. Drop muy raro.',
                icon = 2855
              }
            }
          }
        }
      },
      pets = {
        name = 'Mascotas',
        subcategories = {
          pet_list = {
            name = 'Todas las Mascotas',
            type = 'pets',
            items = {
              {
                name = 'Bebé Pesadilla',
                rarity = 'Épica',
                collector = 'Coleccionista Tenebroso',
                abilities = {
                  { name = 'Carga de Pesadilla', description = 'Se lanza hacia adelante causando daño y miedo' },
                  { name = 'Devorador de Sueños', description = 'Drena maná de enemigos y aumenta la regeneración de maná del dueño un 10%' }
                }
              },
              {
                name = 'Bebé Prisma',
                rarity = 'Épica',
                collector = 'Coleccionista de Paleta',
                abilities = {
                  { name = 'Rayo Prisma', description = 'Dispara un rayo elemental aleatorio (fuego/hielo/energía)' },
                  { name = 'Escudo Prisma', description = 'Aumenta +8% todas las resistencias durante 10 segundos' }
                }
              },
              {
                name = 'Terroc',
                rarity = 'Épica',
                collector = 'Coleccionista Mítico',
                abilities = {
                  { name = 'Terremoto', description = 'Daño físico en área con 2s de aturdimiento' },
                  { name = 'Buff de Terror', description = '+10% probabilidad crítica durante 10 segundos' }
                }
              },
              {
                name = 'Espectro',
                rarity = 'Épica',
                collector = 'Coleccionista Tenebroso',
                abilities = {
                  { name = 'Maldición Espectral', description = 'Daño de muerte + reduce curación un 50%' },
                  { name = 'Aparición', description = '+15% daño de muerte durante 12 segundos' }
                }
              },
              {
                name = 'Lobo',
                rarity = 'Rara',
                collector = 'Coleccionista Salvaje',
                abilities = {
                  { name = 'Aullido', description = 'Miedo en área + 10% velocidad de ataque' }
                }
              },
              {
                name = 'Conejo',
                rarity = 'Rara',
                collector = 'Coleccionista Chef',
                abilities = {
                  { name = 'Salto Rápido', description = 'Se lanza hacia adelante con aumento de velocidad' }
                }
              },
              {
                name = 'Bebé Fénix de Fuego',
                rarity = 'Rara',
                collector = 'Coleccionista Mítico',
                abilities = {
                  { name = 'Aura de Llamas', description = 'Daño de fuego en área + 10% daño de fuego' }
                }
              },
              {
                name = 'Bebé Fénix de Hielo',
                rarity = 'Rara',
                collector = 'Coleccionista Mítico',
                abilities = {
                  { name = 'Ola de Escarcha', description = 'Daño de hielo + ralentización + aumento de velocidad' }
                }
              },
              {
                name = 'Hada',
                rarity = 'Rara',
                collector = 'Coleccionista de Paleta',
                abilities = {
                  { name = 'Polvo de Hada', description = 'Cura al dueño 5% HP + HoT durante 8 segundos' }
                }
              },
              {
                name = 'Gato Blanco',
                rarity = 'Común',
                collector = 'Coleccionista de Paleta',
                abilities = {
                  { name = 'Pata de la Suerte', description = '+3% probabilidad de botín durante 10 segundos' }
                }
              },
              {
                name = 'Gato Negro',
                rarity = 'Común',
                collector = 'Coleccionista Tenebroso',
                abilities = {
                  { name = 'Garra de Sombra', description = 'Daño + reduce resistencia a la luz' }
                }
              }
            }
          }
        }
      }
    }
  }
end
