-- Wiki Data
-- Multilanguage content for the wiki system
-- Add more content here as needed

function getWikiData(language)
  -- English is the most complete/updated dataset; localized categories
  -- override it where translations exist, the rest stays in English
  local data = getEnglishData()
  local localized
  if language == 'es' then
    localized = getSpanishData()
  elseif language == 'pt' then
    localized = getPortugueseData()
  end
  if localized then
    for key, category in pairs(localized.categories) do
      data.categories[key] = category
    end
  end
  return data
end

function getEnglishData()
  return {
    lastUpdated = 'Oct 5, 2026',
    categories = {
      items = {
        name = 'Items',
        subcategories = {
          dropable_spells = {
            name = 'Dropable Spells',
            type = 'list',
            order = 1,
            items = {
              {
                name = 'magnetic orb',
                description = 'place a magnetic orb to create a magnetic field that damages nearby enemies',
                icon = 38167
              },
              {
                name = 'celestial sigil',
                description = 'Shoots a celestial mark into the targeted position which deals damage and increases your magic level percent by 20% for 4 seconds',
                icon = 38149
              },
              {
                name = 'absolute defense',
                description = 'increase your block chance by 50% and max health by 30% for the next 8 seconds. (requires a shield equiped)',
                icon = 38177
              },
              {
                name = 'bouncing sphere',
                description = 'create a bouncing sphere that bounces between you and your target dealing damage and healing yourself, the sphere speed is based on the distance between you and your target',
                icon = 38169
              },
              {
                name = 'earthquake',
                description = 'break the ground dealing physical damage to all enemies and stun them for a short period of time',
                icon = 38168
              },
              {
                name = 'blessed tree',
                description = 'create a blessed tree in the targeted position, which restores health and mana to all nearby players if destroyed.',
                icon = 38157
              },
              {
                name = 'spider web',
                description = 'throw a spider web on your target which stuns it for 2 seconds.',
                icon = 38165
              },
              {
                name = 'meteor',
                description = 'throw a meteor on your targeted position dealing fire damage to nearby enemies.',
                icon = 38152
              },
              {
                name = 'water wave',
                description = 'create 3 water tides which deal ice damage and stun the enemies for 1 second.',
                icon = 38194
              },
              {
                name = 'thunder chain',
                description = 'create a energy chain reaction will travel through all nearby enemies.',
                icon = 38153
              },
              {
                name = 'water torrent',
                description = 'create a water torrent which repels enemies around yourself.',
                icon = 38178
              },
              {
                name = 'shark teeth',
                description = 'create a dangerous area which later will be devoured by a giant shark.',
                icon = 34003
              },
              {
                name = 'wild vines',
                description = 'create wild vines around yourself that pulls nearby monsters into you.',
                icon = 38188
              },
              {
                name = 'quick chains',
                description = 'send quick chains in the direction aimed and pull in the first enemy reached into you.',
                icon = 38156
              },
              {
                name = 'boomerang',
                description = 'Throw a magical boomerang that deals damage in a straight line and returns to you.',
                icon = 38202
              },
              {
                name = 'wild spikes',
                description = 'Unleash two wild spikes in front of you, healing yourself and dealing damage to the target.',
                icon = 33995
              },
              {
                name = 'sniper shot',
                description = 'A precise, long-range attack that deals damage based on the distance traveled.',
                icon = 34015
              },
              {
                name = 'thunder leap',
                description = 'leap into your targeted position dealing damage and stunning nearby enemies for 1 second.',
                icon = 38190
              },
              {
                name = 'chain of flames',
                description = 'create a fire chain reaction that will travel through all nearby enemies.',
                icon = 38158
              },
              {
                name = 'toxic spores',
                description = 'emanate toxic spores poisoning all nearby enemies for 8 seconds.',
                icon = 34077
              },
              {
                name = 'final sentence',
                description = "Sentence your target dealing massive holy damage in a small area increasing its damage based on the target's missing health.",
                icon = 33996
              },
              {
                name = 'healing prisma',
                description = 'Heals you and nearby allies in a wider area',
                icon = 38191
              },
              {
                name = 'fire tornado',
                description = 'Summon a raging fire tornado that repeatedly burns enemies in an area and slows their movement.',
                icon = 38179
              },
              {
                name = 'opelus',
                description = 'Unleash repeated bursts of energy damage at a target location, striking all enemies in the area multiple times.',
                icon = 38162
              },
              {
                name = 'voltstorm',
                description = 'Unleash a storm of constant energy damage at your targeted location, striking all enemies in the area multiple times.',
                icon = 38182
              },
              {
                name = 'blood aura',
                description = 'wield a blood aura draining life force from all nearby enemies.',
                icon = 33997
              },
              {
                name = 'arcane missiles',
                description = 'Fire 5 arcane missiles that seek random enemies in a 7x7 area, dealing energy damage.',
                icon = 38154
              },
              {
                name = 'lightning rod',
                description = 'Place a lightning rod that strikes nearby enemies with chain lightning every second for 6 seconds.',
                icon = 38155
              },
              {
                name = 'phase shift',
                description = 'Become intangible for 2 seconds. You cannot attack or be attacked during this time.',
                icon = 21703
              },
              {
                name = 'rejuvenation',
                description = 'Regenerate 5% of your maximum health per second for 10 seconds, healing 50% total.',
                icon = 38175
              },
              {
                name = 'last stand',
                description = 'When your health drops below 15%, automatically heal 30% of your maximum health. 120 second cooldown.',
                icon = 38206
              },
              {
                name = 'mana battery',
                description = 'Convert 20% of your current health into 30% of your maximum mana.',
                icon = 38205
              },
              {
                name = 'soul reaper',
                description = 'Every time you kill an enemy within the next 10 seconds, you deal death damage in a small area and restore 8% of your health and mana.',
                icon = 38187
              },
              {
                name = 'frost nova',
                description = 'Freeze the ground in a 5x5 area for 8 seconds. Enemies entering are slowed by 70% for 2 seconds.',
                icon = 38192
              }
            }
          },
          spell_boots = {
            name = 'Spell Boots',
            type = 'list',
            order = 2,
            items = {
              {
                name = 'boots of teleportation',
                description = '[onUse] Teleport to your targeted position.',
                icon = 33267
              },
              {
                name = 'boots of the wild',
                description = '[onUse] Charge to your current targeted enemy.',
                icon = 33348
              },
              {
                name = 'boots of timewalking',
                description = '[onUse] Mark your current self and rewind to it after 4 seconds.',
                icon = 33378
              },
              {
                name = 'boots of winter',
                description = '[onUse] Place ice traps on the ground while moving that will slow down the enemies.',
                icon = 2642
              },
              {
                name = 'boots of levitation',
                description = '[onUse] Levitate into the air removing all paralysed effects and dashing towards the direction you are facing.',
                icon = 33328
              },
              {
                name = 'boots of the void',
                description = '[onUse] Instantly trap all nearby enemies in a void field.',
                icon = 32497
              },
              {
                name = 'boots of the salamander',
                description = '[onUse] Place fire pillars in your targeted position which can block line of sight.',
                icon = 9933
              },
              {
                name = 'boots of the dreamer',
                description = '[onUse] Restore 15% maximum mana of all nearby friendly players.',
                icon = 6132
              }
            }
          },
          runes = {
            name = 'Crafting Runes',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'title', text = 'CRAFTING RUNES', color = '#ffd75e' },
              { type = 'text', content = 'Crafting runes are made by the **Enchanting** profession from Empty Enchanting Runes. They equip in the three **CRAFTING** slots of your inventory and grant passive bonuses. Each rune rolls a unique stat package - the higher your Enchanting level, the stronger the rune you craft.' },
              { type = 'divider' },
              { type = 'warning', content = 'You cannot equip the same rune in two rune slots - your three slots must hold different runes.' },
              { type = 'divider' },

              { type = 'title', text = 'BLUE RUNES - MAGE', color = '#66aaff' },
              { type = 'cards', items = {
                { icon = 35381, name = 'Rune of the Magician', color = '#66aaff', description = 'Grants Arcana.' },
                { icon = 35380, name = 'Rune of Knowledge', color = '#66aaff', description = 'Grants Magic Level.' },
                { icon = 35384, name = 'Rune of Chaos', color = '#66aaff', description = 'Grants Critical Hit Chance.' },
                { icon = 35386, name = 'Rune of Magic Echoes', color = '#c080ff', description = 'Triple stat rune: Magic Level, Cooldown Reduction and Arcana.' },
              }},
              { type = 'text', content = 'Blue runes also cover Max Mana (Arcanists, Mana Insight), Max HP (Lost Sage) and Magic Level + Attack Speed (Distortion).' },
              { type = 'divider' },

              { type = 'title', text = 'GREEN RUNES - HUNTER', color = '#9fe89f' },
              { type = 'cards', items = {
                { icon = 35388, name = 'Rune of the Assassin', color = '#9fe89f', description = 'Grants Attack Speed.' },
                { icon = 35389, name = 'Rune of the Betrayer', color = '#9fe89f', description = 'Grants Melee.' },
                { icon = 35393, name = 'Rune of Eros', color = '#9fe89f', description = 'Grants Earth Damage.' },
              }},
              { type = 'text', content = 'Green runes also cover Block (Hunter), Melee (Despair), Bonus Healing (the Humble), Max Mana (the Thief) and Death Damage + Distance (Glory).' },
              { type = 'divider' },

              { type = 'title', text = 'YELLOW RUNES - HOLY', color = '#ffd75e' },
              { type = 'cards', items = {
                { icon = 35397, name = 'Rune of Dawn of Justice', color = '#ffd75e', description = 'Grants Holy Damage.' },
                { icon = 35396, name = 'Rune of Righteousness', color = '#ffd75e', description = 'Grants Shield Power.' },
                { icon = 35401, name = 'Rune of Sin Eater', color = '#ffd75e', description = 'Dual stat rune: Max HP and Shield Power.' },
              }},
              { type = 'text', content = 'Yellow runes also cover Magic Level (Glory), Melee (Faith), Bonus Healing (Devotion) and Max Mana (the Sinless).' },
              { type = 'divider' },

              { type = 'title', text = 'PURPLE RUNES - DARK', color = '#c080ff' },
              { type = 'cards', items = {
                { icon = 35404, name = 'Rune of Agony', color = '#c080ff', description = 'Grants Physical Damage.' },
                { icon = 35407, name = 'Rune of Doomed Prophet', color = '#c080ff', description = 'Grants Fire Damage.' },
                { icon = 35409, name = 'Rune of the Eclipse', color = '#c080ff', description = 'Dual stat rune: Melee and Life Steal.' },
              }},
              { type = 'text', content = 'Purple runes also cover Max HP (Flesh Eater), Magic Level (Drowned Sorrows), Max Mana (the Monarch) and Bonus Healing (the Void).' },
              { type = 'divider' },

              { type = 'title', text = 'RED RUNES - WARRIOR', color = '#ff8888' },
              { type = 'cards', items = {
                { icon = 35413, name = 'Rune of the Berserker', color = '#ff8888', description = 'Grants Melee.' },
                { icon = 35414, name = 'Rune of the Juggernaut', color = '#ff8888', description = 'Grants Max HP.' },
                { icon = 35417, name = 'Rune of Aegis', color = '#ff8888', description = 'Grants Shield Power.' },
                { icon = 35412, name = 'Rune of Ashes', color = '#ff8888', description = 'Grants Critical Hit Chance.' },
              }},
              { type = 'text', content = 'Red runes also cover Defence (Wrath), Max HP (Warden) and Physical Damage (the Hammer).' },
              { type = 'divider' },
              { type = 'tip', content = 'Empty Enchanting Runes come from disenchanting Prismatic Cubes with the Enchanters Rod - see Crafting > Materials.' },
            }
          },
          inventory = {
            name = 'Inventory Slots',
            type = 'rich_text',
            order = 4,
            sections = {
              { type = 'title', text = 'THE INVENTORY WINDOW', color = '#ffd75e' },
              { type = 'text', content = 'Your equipment window is split into three groups: **ACTIVE** for utility gear, **COMBAT** for weapon and armor, and **CRAFTING** for your three rune slots. Backpack, ring and necklace sit in between.' },
              { type = 'divider' },

              { type = 'title', text = 'ACTIVE', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/inventory/inventory_head.png', name = 'Spell Slot (Active)', color = '#c080ff', description = 'Equip your droppable spells here - spell items found as loot that grant an extra ability usable by any vocation (see Dropable Spells for the full list).' },
                { image = '/images/inventory/inventory_feet.png', name = 'Boots (Active)', color = '#ffaa55', description = 'Feet items. This is where spell boots go - Boots of Teleportation, Wild, Timewalking and friends (see Dropable Spells) - plus regular boots.' },
                { image = '/images/inventory/inventory_hip.png', name = 'Torch (Active)', color = '#77ddff', description = 'Utility slot for light sources and utility items like the Bless Item. Torches and utility tools equip here.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'COMBAT', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/inventory/inventory_left_hand.png', name = 'Weapon', color = '#ff8888', description = 'Main hand. Swords, axes, clubs, wands, rods and bows. A two-handed weapon occupies both hands and disables the shield slot.' },
                { image = '/images/inventory/inventory_right_hand.png', name = 'Shield', color = '#66aaff', description = 'Off hand. Shields and spellbooks - anything with a shield slot type. Stays empty while a two-handed weapon is equipped.' },
                { image = '/images/inventory/inventory_torso.png', name = 'Armor', color = '#9fe89f', description = 'Body slot. Chest armor and robes - your main defensive piece.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'EQUIPMENT', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/inventory/inventory_back.png', name = 'Backpack', color = '#ffd75e', description = 'Your carried container - determines how much loot you can haul before needing a supply trip.' },
                { image = '/images/inventory/inventory_finger.png', name = 'Ring', color = '#ffaa77', description = 'Ring slot. Custom rings add strong modifiers - watch out for charged rings that burn charges while equipped.' },
                { image = '/images/inventory/inventory_neck.png', name = 'Necklace', color = '#77ddaa', description = 'Amulet/necklace slot. Necklaces carry passive stats and resistances; some are charged and wear out over time.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'CRAFTING RUNES', color = '#d4a843' },
              { type = 'text', content = 'The three rune slots hold **crafted runes** - the "Rune of ..." items produced by the Enchanting profession from Empty Enchanting Runes. Each rune grants a passive bonus while equipped.' },
              { type = 'cards', items = {
                { image = '/images/inventory/inventory_rune1.png', name = 'Rune Slot 1', color = '#c080ff', description = 'Accepts any crafted rune - sorcerer-flavored ones like Rune of the Magician, Rune of Chaos or Rune of Mana Insight.' },
                { image = '/images/inventory/inventory_rune1.png', name = 'Rune Slot 2', color = '#c080ff', description = 'Accepts any crafted rune - hunter/rogue-flavored ones like Rune of the Hunter, Rune of the Assassin or Rune of the Thief.' },
                { image = '/images/inventory/inventory_rune1.png', name = 'Rune Slot 3', color = '#c080ff', description = 'Accepts any crafted rune - knight-flavored ones like Rune of the Juggernaut, Rune of Aegis or Rune of the Berserker.' },
              }},
              { type = 'divider' },
              { type = 'warning', content = 'You cannot equip the same rune twice - the three slots must each hold a different crafted rune.' },
              { type = 'tip', content = 'Runes are made through Refinement and Transmutation in the Enchanting profession - check the Crafting section for recipes.' },
            }
          },
        }
      },
      tasks = {
        name = 'Task System',
        subcategories = {
          overview = {
            name = 'How Tasks Work',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'Task Board' },
              { type = 'divider' },
              { type = 'text', content = [[The Task Board is your main hunting engine. It offers **3 task offers** that regenerate daily and whenever you reroll. Pick one, hunt the listed monsters, and claim the rewards.

- You can have **1 active task** at a time
- Tasks are drawn from the pools closest to your level (**79 pools**: hunting zones, dungeon floors and bosses)
- Each task shows the **monster outfits** so you know exactly what to hunt
- Abandoning a task loses all progress]] },
              { type = 'subtitle', text = 'The Flow' },
              { type = 'cards', items = {
                { image = '/images/icons/quest_marker.png', name = '1. Pick an offer', description = 'Open the Task Board and choose one of the 3 available slots.' },
                { image = '/images/icons/prey_damage.png', name = '2. Hunt', description = 'Kill the required monsters (56-120 scaled by level). Boss tasks are a **single kill**.' },
                { image = '/images/icons/treasure.png', name = '3. Claim', description = 'Return to the board and press Complete. Your **first completion each day** also grants **+100 Fame**.' },
              }},
              { type = 'tip', content = 'Dungeon pools cut the required kills in half but pay **double** rewards (triple for boss kills) - always check if a dungeon task is offered.' },
            }
          },
          npc_quests = {
            name = 'Kill Tasks vs NPC Quests',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'TWO DIFFERENT SYSTEMS', color = '#ffd75e' },
              { type = 'text', content = 'The server has **two separate task systems** that run side by side - knowing which is which saves confusion.' },
              { type = 'divider' },

              { type = 'title', text = 'KILL TASKS - THE TASK BOARD', color = '#d4a843' },
              { type = 'text', content = 'The **Task Board** (this whole category) is the repeatable hunting engine: 3 daily offers + rerolls, kill-count objectives from level-scaled pools, tiered rewards and modifiers.' },
              { type = 'cards', items = {
                { image = '/images/icons/quest_marker.png', name = 'Source', color = '#ffd75e', description = 'The Task Board window - pick one of 3 rolled offers.' },
                { image = '/images/icons/prey_damage.png', name = 'Objectives', color = '#ff8888', description = 'Pure kill counts (or a single boss kill) - no item deliveries.' },
                { image = '/images/icons/treasure.png', name = 'Rewards', color = '#9fe89f', description = 'Gold / Fame / EXP rolled per task, plus Codex Essences and crates by tier. Repeatable every day.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'NPC QUESTS - THE TASK LIST', color = '#d4a843' },
              { type = 'text', content = '**NPC Quests** are story-driven quests given by specific NPCs around the world (Sheriff Gordon, Seer Valeria, Dream-Seeker Alran, Farmer Mabel and ~30 more). Each NPC offers its own questline - talk to them, complete the objectives, then **return to the same NPC to claim your reward**.' },
              { type = 'cards', items = {
                { image = '/images/icons/quest_marker.png', name = 'Source', color = '#ffd75e', description = 'NPC dialogues - each NPC hands out its own fixed quests (about 100 quests across the world).' },
                { image = '/images/icons/icon_axe.png', name = 'Objectives', color = '#ff8888', description = 'Varied: kill named monsters or bosses, collect and deliver specific items, or complete story steps.' },
                { image = '/images/icons/crown.png', name = 'Rewards', color = '#9fe89f', description = 'Fixed loot per quest: unique items, gold, potions, titles (like the Quest 90 verdict rewards) - not rerollable.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'KEY DIFFERENCES', color = '#d4a843' },
              { type = 'text', content = [[- **Kill tasks** come from the board, are random each day, and you can only hold **1 at a time**
- **NPC quests** are fixed questlines - you can run several from different NPCs in parallel
- Kill task rewards are **rolled** (tiers, modifiers, essence/crate chances)
- NPC quest rewards are **fixed** per quest - check the NPC dialogue for what you get
- Abandoning a kill task loses its progress; NPC quest progress is stored until you finish]] },
              { type = 'tip', content = 'Both systems run independently - a daily "Kill Task" objective can complete while an NPC quest line is also active.' },
            }
          },
          tiers = {
            name = 'Task Tiers & Rarity',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'title', text = 'Task Tiers' },
              { type = 'divider' },
              { type = 'text', content = 'Every generated task rolls one of **4 tiers**. Higher tiers have more modifiers and bigger reward multipliers - and all tiers can roll from the start.' },
              { type = 'cards', items = {
                { image = '/images/icons/circle_10513369.png', name = 'Normal', color = '#dfdfdf', description = '**60%** weight - 1.0x rewards - 0-1 modifiers - 20% chance of 30-60 Codex Essences.' },
                { image = '/images/ui/rarity_blue.png', name = 'Rare', color = '#58a6ff', description = '**25%** weight - 1.25x rewards - 1-2 modifiers - 35% essence roll + 12% Bronze Crate - 25% bonus reroll.' },
                { image = '/images/ui/rarity_purple.png', name = 'Epic', color = '#c678dd', description = '**10%** weight - 1.5x rewards - 2-3 modifiers - 50% essence roll + 25% Bronze/Silver Crate - up to +1 reroll and +1 lock.' },
                { image = '/images/ui/rarity_yellow.png', name = 'Legendary', color = '#ffa940', description = '**5%** weight - 2.0x rewards - 3 modifiers (first 2 always positive) - 70% essence roll + 40% crate - +1-2 rerolls and locks.' },
              }},
              { type = 'tip', content = 'Fame hunter ranks increase Rare/Epic/Legendary weights - see Fame & Premium Benefits.' },
            }
          },
          rewards = {
            name = 'Rewards & Bonuses',
            type = 'rich_text',
            order = 4,
            sections = {
              { type = 'title', text = 'How Rewards Are Calculated' },
              { type = 'divider' },
              { type = 'text', content = [[Base rewards scale with the pool's average level (Lv):
- **Experience:** 1600 x Lv^1.15
- **Fame:** 0.6 x Lv^0.75
- **Gold:** 50 + Lv^0.7]] },
              { type = 'subtitle', text = 'Stacking Multipliers' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Tier', description = 'Rare x1.25 / Epic x1.5 / Legendary x2.0 - applies to all three base rewards.' },
                { image = '/images/icons/prey_damage.png', name = 'Monster Count', description = '+15% gold & exp per extra monster in the objective.' },
                { image = '/images/icons/warning.png', name = 'Difficulty Pay', description = '+15% rewards per **negative** modifier, +10% per **mixed** modifier.' },
                { image = '/images/icons/experience.png', name = 'Grind Bonus', description = '+5% rewards per 50 required kills, capped at **+25%**.' },
                { image = '/images/icons/dungeon.png', name = 'Dungeon Tasks', description = 'Half the kills, **x2 rewards** (x3 on boss pools). Codex rewards also scale x1.5/x2.' },
              }},
              { type = 'warning', content = 'Each task only pays out **2 of the 3 base rewards** - gold, fame and experience are drawn randomly per task (bonus rerolls/locks join the pool when rolled). Check the offer before starting.' },
              { type = 'subtitle', text = 'Codex Rewards (always on top)' },
              { type = 'cards', items = {
                { image = '/images/icons/bronce_crate.png', name = 'Bronze Crate', description = 'Rare 12% - Epic 25% (Bronze or Silver) - Legendary 40% (any tier).' },
                { image = '/images/icons/golden_crate.png', name = 'Dungeon Bosses', description = 'Boss pools grant **2 crates** when a crate roll succeeds.' },
                { image = '/images/codex/essence_icon.png', name = 'Essences', description = 'Normal 20% (30-60) - Rare 35% (60-120) - Epic 50% (120-240) - Legendary 70% (240-480).' },
              }},
            }
          },
          modifiers = {
            name = 'Task Modifiers',
            type = 'rich_text',
            order = 5,
            sections = {
              { type = 'title', text = 'Task Modifiers' },
              { type = 'divider' },
              { type = 'text', content = 'Modifiers roll with the task tier and apply while the task is active. **Legendary tasks always get 3, the first two guaranteed positive.**' },
              { type = 'subtitle', text = 'Positive', color = '#9fe89f' },
              { type = 'cards', items = {
                { image = '/images/icons/gold-bars.png', name = 'Golden Opportunity', color = '#9fe89f', description = '+50-100% gold from monsters.' },
                { image = '/images/icons/fame.png', name = 'Fame Fortune', color = '#9fe89f', description = '+20-40 extra fame reward.' },
                { image = '/images/icons/icon_magic.png', name = 'Experience Essence', color = '#9fe89f', description = '+10-25% green orb (experience) chance.' },
                { image = '/images/icons/prey_star.png', name = 'Elite Surge', color = '#9fe89f', description = '+10-20% purple orb (elite) chance.' },
                { image = '/images/icons/prey_loot.png', name = "Fortune's Favor", color = '#9fe89f', description = '+5-15% blue orb (rare loot) chance.' },
                { image = '/images/icons/pet.png', name = 'Companion Training', color = '#9fe89f', description = '+15-25% pet experience.' },
              }},
              { type = 'subtitle', text = 'Negative', color = '#ff9a8a' },
              { type = 'cards', items = {
                { image = '/images/icons/prey_damage.png', name = 'Empowered Enemies', color = '#ff9a8a', description = 'Monsters deal +10-20% damage.' },
                { image = '/images/icons/icon_health.png', name = 'Cursed Ground', color = '#ff9a8a', description = '-15-25% potion effectiveness.' },
                { image = '/images/icons/icon_health.png', name = 'Weakened Vitality', color = '#ff9a8a', description = '-10-20% max health.' },
                { image = '/images/icons/icon_mana.png', name = 'Mana Drain', color = '#ff9a8a', description = '-10-25% max mana.' },
                { image = '/images/icons/prey_defense.png', name = 'Hardened Enemies', color = '#ff9a8a', description = 'Monsters gain +10-20% damage resistance.' },
                { image = '/images/icons/icon_mana.png', name = 'Mana Burn', color = '#ff9a8a', description = 'Monster attacks drain 5-15% of your mana.' },
              }},
              { type = 'subtitle', text = 'Mixed', color = '#c9a0ff' },
              { type = 'cards', items = {
                { image = '/images/icons/prey_star.png', name = 'High Risk, High Reward', color = '#c9a0ff', description = '+50% fame, but monsters deal +25% damage.' },
                { image = '/images/icons/prey_damage.png', name = 'Glass Cannon', color = '#c9a0ff', description = '+10% rare loot chance, but you take +15% damage.' },
                { image = '/images/icons/prey_star.png', name = 'Elite Surge (mixed)', color = '#c9a0ff', description = '+25% elite spawn chance - more danger, more drops.' },
                { image = '/images/icons/icon_health.png', name = 'Blood Hunt', color = '#c9a0ff', description = 'Heal 5% HP on every kill, but take +15% damage.' },
                { image = '/images/icons/prey_damage.png', name = 'Berserker Mode', color = '#c9a0ff', description = 'Deal +15-25% damage, but take +15-25% damage too.' },
              }},
            }
          },
          rerolls = {
            name = 'Rerolls System',
            type = 'rich_text',
            order = 6,
            sections = {
              { type = 'title', text = 'Rerolls' },
              { type = 'divider' },
              { type = 'text', content = 'Rerolling refreshes all **unlocked** task slots with new offers - lock the ones you want to keep first.' },
              { type = 'cards', items = {
                { image = '/images/icons/reroll.png', name = 'Free Rerolls', description = '**5 per day** base. Premium adds **+5**. Each **5 Fame levels** add **+1** more. Resets daily.' },
                { image = '/images/icons/gold_coin.png', name = 'Paid Rerolls', description = '**20 gold** each once free rerolls run out - unlimited.' },
                { image = '/images/icons/prey_star.png', name = 'Bonus Rerolls', description = 'Rare tasks 25% for +1, Epic 40% for +1, Legendary +1-2 guaranteed - granted through the task reward slot.' },
              }},
              { type = 'tip', content = 'Save free rerolls for higher tiers, and lock a good Legendary before rolling the rest.' },
            }
          },
          locks = {
            name = 'Lock System',
            type = 'rich_text',
            order = 7,
            sections = {
              { type = 'title', text = 'Locks' },
              { type = 'divider' },
              { type = 'text', content = 'A **locked** task survives rerolls - protect the good offers while you roll for better ones.' },
              { type = 'cards', items = {
                { image = '/images/icons/lock.png', name = 'Free Locks', description = '**3 per day** base. Premium adds **+5**. Resets daily.' },
                { image = '/images/icons/gold_coin.png', name = 'Paid Locks', description = '**10 gold** each once free locks run out.' },
                { image = '/images/icons/lock_small.png', name = 'Bonus Locks', description = 'Epic tasks 30% for +1, Legendary +1-2 guaranteed - through the task reward slot.' },
              }},
              { type = 'tip', content = 'Lock Epic/Legendary tasks or any task with a modifier set you like, then reroll the other slots freely.' },
            }
          },
          fame_premium = {
            name = 'Fame & Premium Benefits',
            type = 'rich_text',
            order = 8,
            sections = {
              { type = 'title', text = 'Fame Hunter Ranks' },
              { type = 'divider' },
              { type = 'text', content = 'Your account-wide **Fame level** grants permanent task bonuses:' },
              { type = 'cards', items = {
                { image = '/images/icons/fame.png', name = 'Fame 3 - Experienced Hunter', description = '+5 weight on Rare tier rolls.' },
                { image = '/images/icons/fame.png', name = 'Fame 5 - Veteran Hunter', description = '15% chance to convert a negative modifier into positive/mixed.' },
                { image = '/images/icons/fame.png', name = 'Fame 7 - Elite Hunter', description = '+1 free reroll per day.' },
                { image = '/images/icons/fame.png', name = 'Fame 8 - Master Hunter', description = 'Bonus weight on Epic rolls (applies from Fame 20+).' },
                { image = '/images/icons/fame_big.png', name = 'Fame 10 - Legendary Hunter', description = '+5% to all task rewards.' },
              }},
              { type = 'subtitle', text = 'Premium Account' },
              { type = 'cards', items = {
                { image = '/images/icons/crown.png', name = 'Premium Perks', description = '+5 free rerolls and +5 free locks per day.' },
              }},
              { type = 'tip', content = 'The **+100 Fame daily bonus** is credited automatically with your first completed task of the day.' },
            }
          },
        }
      },
      daily_tasks = {
        name = 'Daily Quests',
        subcategories = {
          overview = {
            name = 'How Daily Quests Work',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'DAILY QUESTS', color = '#ffd75e' },
              { type = 'text', content = 'Every day you get **8 tasks** rolled automatically with weighted difficulty: Easy (34%), Medium (33%) and Hard (33%). They reset at server local midnight - unfinished tasks are lost when the day rolls over.' },
              { type = 'image', path = '/images/wiki/daily_tasks_overview.png', width = 400, height = 126 },
              { type = 'cards', items = {
                { icon = 33904, name = 'Daily Task Board', color = '#ffd75e', description = 'The board in the city center opens your Daily Tasks window - click it to check tasks, track progress and claim rewards.' },
                { image = '/images/icons/clock.png', name = 'Daily Reset', color = '#66aaff', description = 'Tasks re-roll every local server day. Claim rewards before reset or they are gone.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'TASK CATEGORIES', color = '#d4a843' },
              { type = 'text', content = [[- **Kill Zone** - kill monsters in non-PvP, PvP or PvP-enforced zones
- **Boss** - defeat bosses (any or a specific one)
- **Dungeon** - complete dungeon runs
- **Zone Event** - complete zone events
- **Tower Floor** - clear Tower of God floors
- **Pet Level** - level up your pet
- **Item Proficiency** - hit item proficiency milestones
- **Kill Task** - complete task board kill tasks
- **Crafting** - deliver crafted items (Alchemy, Enchanting, Blacksmith)
- **Gathering** - deliver gathered essences
- **Mixed** - combine multiple actions at once (kills + tower, bosses + dungeons + events)

**Auto-progress** tasks update as you play. **Turn In** tasks need the items in your inventory - then click Turn In.]] },
              { type = 'divider' },

              { type = 'title', text = 'REWARDS', color = '#d4a843' },
              { type = 'text', content = 'Rewards scale with task difficulty:' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Easy Task', color = '#9fe89f', description = '3 Achievement Points + 25 Codex Essences' },
                { image = '/images/icons/star.png', name = 'Medium Task', color = '#ffd75e', description = '6 Achievement Points + 40 Codex Essences' },
                { image = '/images/icons/star.png', name = 'Hard Task', color = '#ff8888', description = '10 Achievement Points + 60 Codex Essences' },
                { image = '/images/icons/crown.png', name = 'Daily Big Reward', color = '#ffd75e', description = 'Complete 4 tasks to claim 1 Golden Codex Crate - once per day, claim it before reset.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'CRAFTING TASK TIERS', color = '#d4a843' },
              { type = 'text', content = [[Crafting tasks scale with your profession tier:

**Alchemy:** Apprentice (refined essences, basic potions) - Novice (health/mana/spirit potions, small vials) - Journeyman (strong potions, mid-tier vials and elixirs) - Master (great potions) - Grandmaster (enchanted great potions)

**Enchanting:** Apprentice (tier 1 runes) - Journeyman (tier 3) - Adept (tier 4) - Master (tier 5) - Grand (tier 6 top-tier) - Blueprint Specialist (rare blueprint crafts)

**Blacksmith:** Apprentice (starter weapons and shields) - Journeyman (basic combat gear: 1H swords, 2H weapons, ranged, shields)

**Refinery (Gadgets):** utility items crafted from wood and bars - bandages and training weapons at low levels, decoys, whetstones, glue bombs and camp tents mid-tier, then the livingwood staff, grappling hook, boomerang sword and pocket depot at the top. Refinery level directly boosts gadget damage and healing.

**Woodcutting:** gathering profession that feeds Refinery - chop tree nodes into logs, refine them into planks, and gain +1% attack speed per level.]] },
              { type = 'divider' },
              { type = 'tip', content = 'Prioritize easy tasks first for quick completions, keep spare crafted items in storage for instant turn-ins, and always claim your Golden Crate before the day ends.' },
            }
          },
        }
      },
      pets = {
        name = 'Pets',
        subcategories = {
          epic_pets = {
            name = 'Epic Pets',
            type = 'pets',
            order = 4,
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
                  { name = 'Devour', description = 'Melee attack with lifesteal (heals owner for 20% of damage dealt)' }
                }
              },
              {
                name = 'Baby',
                outfitId = 1267,
                rarity = 'Epic',
                element = 'Physical',
                collector = 'Special',
                abilities = {
                  { name = 'Guardian Cry', description = '+5% all resistances for 8s' },
                  { name = 'Tantrum', description = 'AoE paralyze to nearby enemies' }
                }
              },
              {
                name = 'Furry',
                outfitId = 1263,
                rarity = 'Epic',
                element = 'Physical',
                collector = 'Special',
                abilities = {
                  { name = 'Warm Embrace', description = '+8% physical resistance and HP regen for 10s' }
                }
              },
              {
                name = 'Bob 1',
                outfitId = 1562,
                rarity = 'Epic',
                element = 'Physical',
                collector = 'Special',
                abilities = {
                  { name = 'Challenge', description = 'Challenge + buff' }
                }
              },
              {
                name = 'Bob 2',
                outfitId = 1561,
                rarity = 'Epic',
                element = 'Physical',
                collector = 'Special',
                abilities = {
                  { name = 'Challenge', description = 'Challenge + buff' }
                }
              }
            }
          },
          rare_pets = {
            name = 'Rare Pets',
            type = 'pets',
            order = 3,
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
                rarity = 'Epic',
                element = 'Holy/Ice',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Mystic Breath', description = 'Holy + Ice combo damage' }
                }
              },
              {
                name = 'Wolf Cub',
                outfitId = 1709,
                rarity = 'Common',
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
                rarity = 'Uncommon',
                element = 'Holy',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Divine Scratch', description = 'Holy melee damage' }
                }
              },
              {
                name = 'Baby Angel',
                outfitId = 1326,
                rarity = 'Epic',
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
                rarity = 'Epic',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Roar', description = 'Physical buff to damage' }
                }
              },
              {
                name = 'Air Elemental',
                outfitId = 1354,
                rarity = 'Common',
                element = 'Energy',
                collector = 'Mythical Collector',
                abilities = {
                  { name = 'Air Blast', description = 'Energy push + damage' }
                }
              },
              {
                name = 'Baby Elemental',
                outfitId = 2075,
                rarity = 'Uncommon',
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
            order = 2,
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
                rarity = 'Rare',
                element = 'Death',
                collector = 'Bugs Collector',
                abilities = {
                  { name = 'Blood Drain', description = 'Life steal attack' }
                }
              },
              {
                name = 'Bunny',
                outfitId = 1821,
                rarity = 'Common',
                element = 'Physical',
                collector = 'Chef Collector',
                abilities = {
                  { name = 'Quick Hop', description = 'Jump attack + speed' }
                }
              },
              {
                name = 'Sheep',
                outfitId = 1481,
                rarity = 'Rare',
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
                rarity = 'Epic',
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
                rarity = 'Rare',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Club Hit', description = 'Physical melee' }
                }
              },
              {
                name = 'Baby Eyeboh',
                outfitId = 109,
                rarity = 'Rare',
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
                rarity = 'Epic',
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
            order = 1,
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
                rarity = 'Uncommon',
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
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Aquatic Collector',
                abilities = {
                  { name = 'Shell Defense', description = 'Defense buff' }
                }
              },
              {
                name = 'Aqua Slime',
                outfitId = 1901,
                rarity = 'Uncommon',
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
                rarity = 'Uncommon',
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
                rarity = 'Uncommon',
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
                rarity = 'Uncommon',
                element = 'Fire',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Fire Gust', description = 'Fire ranged' }
                }
              },
              {
                name = 'Flamingo',
                outfitId = 212,
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Palette Collector',
                abilities = {
                  { name = 'Wing Slap', description = 'Physical melee' }
                }
              },
              {
                name = 'Bear Cub',
                outfitId = 1716,
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Claw Swipe', description = 'Physical AoE' }
                }
              },
              {
                name = 'Boar Cub',
                outfitId = 1286,
                rarity = 'Uncommon',
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
                rarity = 'Uncommon',
                element = 'Physical',
                collector = 'Wild Collector',
                abilities = {
                  { name = 'Fly Peck', description = 'Flying melee' }
                }
              },
              {
                name = 'Baby Crow',
                outfitId = 1559,
                rarity = 'Uncommon',
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
                rarity = 'Rare',
                element = 'Physical',
                collector = 'Bugs Collector',
                abilities = {
                  { name = 'Slow Slime', description = 'Slow trail' }
                }
              },
              {
                name = 'Night Frog',
                outfitId = 412,
                rarity = 'Uncommon',
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
                  { name = 'Quick Dodge', description = 'Dodge bonus (5-15%) for 5s based on pet level' }
                }
              }
            }
          }
        }
      },
      ascension_guide = {
        name = 'Ascension Guide',
        subcategories = {
          getting_started = {
            name = 'First Steps',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'Welcome to Ascension' },
              { type = 'divider' },
              { type = 'text', content = 'Ascension is an **ARPG-style** server built around deep progression: tasks, talents, codex cards, pets, prestige and more. This wiki explains every system - press **Ctrl+H** or the Wiki button to reopen it anytime.' },
              { type = 'subtitle', text = 'Your First Priorities' },
              { type = 'cards', items = {
                { image = '/images/icons/quest_marker.png', name = 'Hunt & Task', description = 'Level up and complete **Task Board** offers - they are your main source of gold, fame and codex essences early on.' },
                { image = '/images/icons/bag.png', name = 'Loot Everything', description = 'Use the **Stash** and **Quick Loot** to manage items. Keep materials - almost everything feeds a system.' },
                { image = '/images/icons/gem.png', name = 'Do Not Vendor Trash', description = 'Use the **Recycler** or **Upgrade System** to extract essences and materials from unwanted items instead of selling them.' },
                { image = '/images/icons/icon_sword.png', name = 'Pick Your Path', description = '**15 vocations** including Bard, Tinker, Samurai, Blood Mage and Warden - each with its own talent tree.' },
              }},
              { type = 'subtitle', text = 'Where To Next' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Class Talents', description = 'Earn a talent point every **8 levels** and build your tree - see Class Talents.' },
                { image = '/images/icons/clock.png', name = 'Daily Quests', description = 'Eight rotating objectives; complete **4+** for a Golden Crate - see Daily Quests.' },
                { image = '/images/icons/wow_zone.png', name = 'Zones & Events', description = 'Hunting zones run rotating buffs and events - see Zones & Events.' },
              }},
              { type = 'tip', content = 'Progress in this wiki is saved - the bar below shows how much you have read.' },
            }
          },
          class_talents = {
            name = 'Class Talents',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'image', path = '/images/wiki/talents_overview.png', width = 400, height = 110 },
              { type = 'title', text = 'WHAT ARE CLASS TALENTS', color = '#ffd75e' },
              { type = 'text', content = 'Every vocation has its own **Constellation** - a talent tree built from three themed **axes** plus specialization **branches**. Investing points into an axis unlocks milestone bonuses, and nodes inside each branch grant passive stats, triggered effects or even **new spells**. Talents apply automatically on login.' },
              { type = 'divider' },

              { type = 'title', text = 'HOW THE TREE WORKS', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/wiki/talent_node.png', name = 'Core Node', color = '#ffd75e', description = 'Every tree starts from a core node (like Elemental Attunement) that connects to all branches.' },
                { image = '/images/icons/icon_sword.png', name = 'Three Axes', color = '#ff8888', description = 'Offense, defense and utility axes with themed names per vocation. Spending points on an axis unlocks milestone effects at its thresholds.' },
                { image = '/images/icons/icon_axe.png', name = 'Branches', color = '#9fe89f', description = 'Each tree has 3 specialization branches - e.g. the Magician splits into Pyromancy, Cryomancy and Arcana.' },
                { image = '/images/icons/icon_health.png', name = 'Node Effects', color = '#66aaff', description = 'Nodes grant stats (conditions), passive procs and masteries, or unlock real spells like Hand of God or Arcane Missiles.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'TALENT POINTS', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Earning', color = '#ffd75e', description = 'You earn 1 talent point every 5 character levels.' },
                { image = '/images/icons/icon_axe.png', name = 'Spending', color = '#9fe89f', description = 'Each node level costs 1 point. Nodes have varying max levels, and deeper nodes require the previous node to be leveled first.' },
                { image = '/images/icons/star.png', name = 'Preview', color = '#66aaff', description = 'You can inspect every node and its effect in the Class Talents window before committing points.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'RESETTING YOUR TREE', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/icons/icon_health.png', name = 'Cost', color = '#ff8888', description = '10 gold per spent point to reset your whole tree.' },
                { image = '/images/icons/crown.png', name = 'Premium', color = '#ffd75e', description = 'Premium players pay half: 5 gold per spent point.' },
                { image = '/images/icons/star.png', name = 'Refund', color = '#9fe89f', description = 'Resetting refunds every spent point - your total earned points are never lost.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'THE 15 CONSTELLATIONS', color = '#d4a843' },
              { type = 'text', content = [[**Magician** - Wrath / Aegis / Harmony - Pyromancy, Cryomancy, Arcana
**Templar** - Wrath / Aegis - Reprisal, Guardian, Sacred Healer
**Nightblade** - Cruelty / Evasion / Shadow - Hemorrhage, Shadow Dance, Void Blades
**Dragonknight** - Fury / Scales / Embers - Bloodlust, Draconic Ward, Phoenix Forge
**Warlock** - Blight / Vitality / Summoning - Curses & Plague, Demonic Legion, Blood Pact
**Stellar** - Radiance / Lunarity / Astral - Lunar Fury, Holy Wrath, Celestial Grace
**Monk** - Fury / Stone / Chi - Stormfist, Mountain Path, Vital Chi
**Druid** - Wildgrowth / Verdancy / Frost - Savage Growth, Verdant Healing, Frost Ward
**Light Dancer** - Storm / Ward / Blade - Tempest Gambit, Lightning Guard, Elusive Blade
**Archer** - Ballistics / Frost / Survival - Explosive Arsenal, Frost Hunter, Phantom Marksman
**Bard** - Dissonance / Harmony / Resonance - Dissonant Strike, Melodic Harmony, Reverberating Echo
**Tinker** - Robotics / Demolition / Engineering - Robotics, Demolition, Engineering
**Samurai** - Steel / Iron / Wind - Way of the Sword, Way of the Shield, Way of the Wind
**Blood Mage** - Crimson / Sanguine / Battlemage - Crimson Path, Sanguine Path, Battlemage Path
**Warden** - Earth / Frost / Wilderness - Earthshaker, Frostwarden, Guardian]] },
              { type = 'divider' },
              { type = 'title', text = 'IMPORTANT NODES', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/wiki/talent_notable.png', name = 'Notable', color = '#9fe89f', description = 'Star-framed nodes - strong standalone bonuses worth planning around.' },
                { image = '/images/wiki/talent_nexus.png', name = 'Nexus', color = '#66aaff', description = 'Constellation-framed nodes - junctions where branches connect, opening new paths across the tree.' },
                { image = '/images/wiki/talent_keystone.png', name = 'Keystone', color = '#ffd75e', description = 'The large node at the end of each branch - the capstone bonus that defines the path (Pyromancer, Cryomancer, Arcanist...).' },
              }},
              { type = 'divider' },
              { type = 'tip', content = 'Plan a branch first - keystone nodes are powerful but sit at the end of each path, so rushing three branches at once leaves you weak in all of them.' },
            }
          },
          paragon_ascension = {
            name = 'Paragon Ascension',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'image', path = '/images/wiki/paragon_overview.png', width = 400, height = 117 },
              { type = 'title', text = 'WHAT IS PARAGON', color = '#ffd75e' },
              { type = 'text', content = 'Paragon is the endgame progression system that unlocks at **Character Level 300**. Once you hit the cap, all XP flows into your Paragon bar instead. Each Paragon level grants a point for one of three stat categories - the category rotates automatically as you level.\n\nOpen the **Ascension** tab in your Class Talents window to see your board and spend points.' },
              { type = 'divider' },

              { type = 'title', text = 'PARAGON XP', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'XP Curve', color = '#ffd75e', description = 'First level needs 6,000,000 XP. Each level adds +12% of the base cost on top (linear - about 720k more per level).' },
                { image = '/images/icons/crown.png', name = 'Premium', color = '#9fe89f', description = 'Premium accounts gain +15% Paragon XP.' },
                { icon = 40146, name = 'XP Boost Token', color = '#66aaff', description = 'Consumable: +25% Paragon XP for 1 hour. Requires Paragon Level 1 and does not stack - reuse when it expires.' },
                { image = '/images/icons/icon_health.png', name = 'Death Penalty', color = '#ff8888', description = 'Dying costs 10% of your current Paragon XP progress - protect your bar.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'POINT ROTATION', color = '#d4a843' },
              { type = 'text', content = 'Paragon Lv 1 -> **Primary**, Lv 2 -> **Secondary**, Lv 3 -> **Utility**, then it repeats. Earned points never expire - spend them whenever you want in the Ascension tab.' },
              { type = 'divider' },

              { type = 'title', text = 'PRIMARY - OFFENSE', color = '#ff8888' },
              { type = 'cards', items = {
                { image = '/images/icons/icon_sword.png', name = 'Physical Damage', color = '#ff8888', description = '+1% per point - cap 150%' },
                { image = '/images/icons/icon_axe.png', name = 'Elemental Damage', color = '#ff8888', description = '+1 flat per point - cap 200' },
                { image = '/images/icons/star.png', name = 'Attack Speed', color = '#ff8888', description = '+1% per point - cap 100%' },
                { image = '/images/icons/crown.png', name = 'Critical Chance', color = '#ff8888', description = '+1% per point - cap 75%' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'SECONDARY - DEFENSE', color = '#66aaff' },
              { type = 'cards', items = {
                { image = '/images/inventory/inventory_right_hand.png', name = 'Block Chance', color = '#66aaff', description = '+1% per point - cap 30%' },
                { image = '/images/icons/icon_health.png', name = 'Max HP', color = '#66aaff', description = '+50 per point - no cap, safe long-term investment' },
                { image = '/images/icons/icon_health.png', name = 'Max Mana', color = '#66aaff', description = '+40 per point - no cap' },
                { image = '/images/icons/icon_health.png', name = 'Healing Received', color = '#66aaff', description = '+1% per point - cap 100%' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'UTILITY - PROGRESSION', color = '#9fe89f' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'EXP Gain', color = '#9fe89f', description = '+1% per point - cap 100%. Speeds up Paragon itself.' },
                { image = '/images/icons/icon_axe.png', name = 'Crafting EXP', color = '#9fe89f', description = '+2% per point - cap 150%' },
                { image = '/images/icons/crown.png', name = 'Fame Gain', color = '#9fe89f', description = '+2% per point - cap 100%' },
                { image = '/images/icons/icon_health.png', name = 'Codex Knowledge', color = '#9fe89f', description = '+0.2% codex point chance per point - cap ~10%' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'MILESTONES', color = '#d4a843' },
              { type = 'text', content = 'Points spent in a category unlock automatic milestones. Damage and HP bonuses **replace** the previous tier - they do not stack.' },
              { type = 'cards', items = {
                { image = '/images/icons/icon_sword.png', name = 'Primary', color = '#ff8888', description = '25 pts: "Warrior" title - 50: +3% all damage - 100: +5% - 200: "Paragon of War" title +8%' },
                { image = '/images/inventory/inventory_right_hand.png', name = 'Secondary', color = '#66aaff', description = '25 pts: "Guardian" title - 50: +5% max HP - 100: +8% - 200: "Paragon of Fortitude" title +12%' },
                { image = '/images/icons/star.png', name = 'Utility', color = '#9fe89f', description = '25 pts: "Explorer" title - 50: +3% all gains - 100: +5% - 200: "Paragon of Fortune" title +8%' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'RESETTING', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Ascension Tab', color = '#9fe89f', description = 'The reset button on the Paragon board refunds all allocated points for free.' },
                { icon = 40137, name = 'Reset Scroll', color = '#c080ff', description = 'Paragon Reset Scroll item: refunds every allocated point. Requires Paragon Level 5 and at least one spent point.' },
              }},
              { type = 'divider' },
              { type = 'tip', content = 'Every 10 Paragon levels a broadcast announces your progress - milestone titles are broadcast too, so they double as flexes.' },
            }
          },
        }
      },
      currencies = {
        name = 'Currencies',
        subcategories = {
          overview = {
            name = 'Currency Guide',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'CURRENCIES OF ASCENSION', color = '#ffd75e' },
              { type = 'text', content = 'Ascension uses several currencies for different systems. Here is what each one does and where to get it.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Core Currencies', color = '#ffd75e' },
              { type = 'cards', items = {
                { icon = 2148, name = 'Gold Coins', color = '#ffd700',
                  description = 'The main currency. Earned from monster kills, [color=#ffd700]Gold Orbs[/color], tasks, quest rewards and the Auction House. Spent on NPC shops, task rerolls/locks and crafting fees.' },
                { image = '/images/icons/fame_big.png', name = 'Fame', color = '#ff9e5e',
                  description = 'Account-wide progression currency with [color=#ffd700]30 levels[/color] (100 to 715,000 points). Earn fame from tasks, zone events, bounty kills and prestige rewards. Spend it at the [color=#ffd700]Fame NPC shops[/color] for exclusive items.' },
                { image = '/images/codex/essence_icon.png', name = 'Codex Essences', color = '#cc66ff',
                  description = 'Currency of the Codex card system. Earned from monster kills, crate bonus rolls and duplicate cards. Spent on crafting [color=#ffd700]Bronze / Silver / Golden Crates[/color] (100 / 200 / 350), upgrading cards, and unlocking deck slots early.' },
                { image = '/images/icons/star.png', name = 'Achievement Points', color = '#66ccff',
                  description = 'Earned by completing achievements across 19 categories. Points unlock titles and milestone rewards.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Monster Essences (crafting materials)', color = '#66ff99' },
              { type = 'text', content = 'Dropped by monsters and used as ingredients for [color=#ffd700]crafted gear[/color]. The generic **Monster Essence** and **Boss Essence** are required by every blueprint recipe.' },
              { type = 'cards', items = {
                { icon = 6500, name = 'Monster Essence', color = '#66ff99',
                  description = 'Core crafting material. Drops from regular monsters. Every blueprint recipe needs 30-35 of them.' },
                { icon = 11223, name = 'Boss Essence', color = '#ff6666',
                  description = 'Rare crafting material that only drops from bosses. Blueprints require 2 per craft.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Elite Essences', color = '#cc99ff' },
              { type = 'text', content = 'Special essences dropped by [color=#ffd700]elite monster variants[/color] (the [bracketed] name prefixes you see in zones). Each variant drops its own element-themed essence, used in crafting and daily tasks.' },
              { type = 'cards', items = {
                { icon = 40418, name = 'Life Essence', color = '#ff8888', description = 'From [Vampiric] elites.' },
                { icon = 40419, name = 'Mana Essence', color = '#66aaff', description = 'From [Arcane] elites.' },
                { icon = 40420, name = 'Spirit Essence', color = '#dddddd', description = 'From spirit-themed elites.' },
                { icon = 40421, name = 'Fire Essence', color = '#ff7733', description = 'From [Burning] elites.' },
                { icon = 40422, name = 'Pure Essence', color = '#ffff88', description = 'From [Sacred] elites. Rarer - daily tasks ask for only 2.' },
                { icon = 40423, name = 'Ice Essence', color = '#77ddff', description = 'From [Frostbound] elites.' },
                { icon = 40424, name = 'Dark Essence', color = '#aa66cc', description = 'From [Darkness] elites.' },
                { icon = 40425, name = 'Earth Essence', color = '#99cc66', description = 'From [Plagued] elites.' },
              }},
              { type = 'tip', content = 'Tip: keep a stack of each essence - Daily Tasks frequently ask for deliveries of 5 (2 for Pure Essence).' },
            }
          },
        }
      },

      monster_orbs = {
        name = 'Monster Orbs',
        subcategories = {
          overview = {
            name = 'Orb Guide',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'MONSTER ORBS', color = '#ffd75e' },
              { type = 'text', content = 'When you kill a monster (level 2+), there is a chance a glowing orb drops on the floor. Walk over it to claim the reward - [color=#ff8888]only you can pick up your own orbs[/color].' },
              { type = 'divider' },

              { type = 'subtitle', text = 'The Four Orb Types', color = '#ffd75e' },
              { type = 'cards', items = {
                { icon = 39941, name = 'Gold Orb', color = '#ffd700',
                  description = 'Grants instant gold: [color=#ffd700]monster level x 10[/color]. Drop chance ~2.7% (4 in 150).' },
                { icon = 38694, name = 'Loot Orb', color = '#5599ff',
                  description = 'Grants a loot item scaled to the monster level - this is where [color=#ffd700]custom gear[/color] enters the game. Drop chance ~1.3% (2 in 150).' },
                { icon = 38693, name = 'Experience Orb', color = '#77ff77',
                  description = 'Grants instant experience: [color=#ffd700]monster level x 100[/color]. Drop chance ~1.3% (2 in 150).' },
                { icon = 38572, name = 'Death Orb', color = '#cc66ff',
                  description = 'Summons an [color=#ff8888]elite version of the monster you just killed[/color] with double HP and a special prefix ([Shadow], [Aqua], [Volcanic], [Sacred], [Mighty], [Terra]). Elites have unique powers and drop elite essences. Drop chance ~1.3% (2 in 150).' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'How to get more orbs', color = '#66ff99' },
              { type = 'cards', items = {
                { icon = 38694, name = 'Orb Shower (Zone Buff)', color = '#44aaff',
                  description = 'When a zone has the Orb Shower buff active, all orb drop chances are boosted while it lasts (~30 min).' },
                { icon = 33904, name = 'Task Modifiers', color = '#ffcc66',
                  description = 'Some task modifiers increase purple / blue / green orb drop chance - but only while the task monster is still incomplete.' },
                { icon = 33621, name = 'High Risk Prestige', color = '#ff5544',
                  description = 'The High Risk prestige mode raises blue orb chance by 20% and grants +1 extra drop from blue orbs.' },
              }},
              { type = 'warning', content = 'Orbs belong to the player who killed the monster - party members and bystanders cannot steal them.' },
            }
          },
        }
      },

      zones = {
        name = 'Zones & Events',
        subcategories = {
          overview = {
            name = 'How Zones Work',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'HUNTING ZONES', color = '#ffd75e' },
              { type = 'text', content = 'The world is divided into ~99 hunting zones. Each zone has its own monster spawns, level range, weather, and a [color=#ffd700]zone boss[/color] that spawns after enough kills. Zones rotate random events and buffs - always check the zone panel before hunting.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Zone Events', color = '#66ff99' },
              { type = 'text', content = 'Zones periodically run events: kill quotas, boss hunts and funnykill invasions (waves of spawned monsters). Top contributors earn podium rewards.' },
              { type = 'cards', items = {
                { image = '/images/icons/treasure.png', name = 'Podium Rewards (Top 3)', color = '#ffd700',
                  description = '1st: 200 exp + Golden Crate + essences. 2nd: 100 exp + Golden Crate. 3rd: 75 exp + Golden Crate. Plus platinum coins.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Zone Buffs (rotate automatically)', color = '#66aaff' },
              { type = 'text', content = 'Each zone can have an active buff. [color=#77ff77]Friendly buffs[/color] are pure bonuses; [color=#ff8888]aggressive buffs[/color] add risk or PvP pressure.' },
              { type = 'cards', items = {
                { icon = 38693, name = 'Double Experience', color = '#ffd700', description = 'Double exp from all monster kills. 40 min. (friendly)' },
                { icon = 38694, name = 'Orb Shower', color = '#44aaff', description = 'All orb drop chances boosted. 30 min. (friendly)' },
                { image = '/images/icons/explosion.png', name = 'Monster Rush', color = '#ff4444', description = 'Monster spawn rate doubled. 20 min. (aggressive)' },
                { image = '/images/icons/skull.png', name = 'Blood Pact', color = '#cc0000', description = 'Each kill permanently boosts your stats until you die or leave the zone. 40 min. (aggressive)' },
                { image = '/images/icons/skull.png', name = 'Bounty Hunt', color = '#ff0000', description = 'Monster kills may grant fame; player kills grant more. 40 min. (aggressive)' },
                { icon = 35768, name = 'Rapid Regeneration', color = '#00ff88', description = 'HP and mana regeneration +200%. 40 min. (friendly)' },
                { image = '/images/icons/flash.png', name = 'Speed Demon', color = '#00ccff', description = '+50% movement speed, -20% spell cooldowns. 20 min. (friendly)' },
                { image = '/images/icons/shield-divided-four_16769380.png', name = 'Survival Instinct', color = '#8888ff', description = '-25% damage taken, +20% max HP. 40 min. (friendly)' },
                { image = '/images/icons/fire.png', name = 'Blood Moon', color = '#cc0033', description = '+15% lifesteal; taking damage boosts your next attack by 10%. 35 min. (aggressive)' },
                { image = '/images/codex/essence_icon.png', name = 'Codex Knowledge', color = '#9933ff', description = 'Monsters have a chance to grant +5 codex essence on kill. 35 min. (friendly)' },
              }},
              { type = 'tip', content = 'Check which buff is active before choosing a hunting zone - Double Exp and Orb Shower hours are the best farming windows.' },
            }
          },
        }
      },

      dungeons = {
        name = 'Dungeons',
        subcategories = {
          overview = {
            name = 'Dungeon Guide',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'DUNGEONS', color = '#ffd75e' },
              { type = 'text', content = 'Dungeons are instanced runs entered through portal stones. Each has a mission objective - usually killing a final boss. A [color=#ffd700]daily mutation[/color] modifies every active dungeon with extra mechanics.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Difficulty', color = '#ff9e5e' },
              { type = 'text', content = 'Difficulty scales monster damage and pressure from x0.85 (level 1) up to x1.60 (level 6). Pick a level you can clear - failed runs waste the entry.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Daily Mutators (one active per day, rerolls at 00:00)', color = '#cc66ff' },
              { type = 'cards', items = {
                { image = '/images/dungeons/mutations/1.png', name = 'Anti-Heal', color = '#ff6666', description = 'Healing received reduced by 30%.' },
                { image = '/images/dungeons/mutations/2.png', name = 'Elite Rage', color = '#ff4444', description = 'Elites deal 20% more damage.' },
                { image = '/images/dungeons/mutations/3.png', name = 'Slow Fields', color = '#66aaff', description = 'Hazard fields apply slow.' },
                { image = '/images/dungeons/mutations/4.png', name = 'Mana Burn', color = '#66ffee', description = 'Monsters burn mana on hit.' },
                { image = '/images/dungeons/mutations/5.png', name = 'Unleashed Fury', color = '#ff8888', description = 'Enemies below 30% HP deal +40% damage.' },
                { image = '/images/dungeons/mutations/6.png', name = 'Ethereal Explosion', color = '#cc99ff', description = 'Some enemies explode on death in an area.' },
                { image = '/images/dungeons/mutations/7.png', name = 'Adamantite Skin', color = '#aaaaaa', description = 'Enemies reduce the first hit received every 5s by 80%.' },
                { image = '/images/dungeons/mutations/8.png', name = 'Profane Regeneration', color = '#77ff77', description = 'If not damaged for 5s, enemies regenerate health quickly.' },
                { image = '/images/dungeons/mutations/9.png', name = 'Arcane Storm', color = '#aa66ff', description = 'Lightning strikes random areas every 8s.' },
                { image = '/images/dungeons/mutations/10.png', name = 'Void Dominion', color = '#9933cc', description = 'A void entity slowly pursues and detonates on contact.' },
                { image = '/images/dungeons/mutations/12.png', name = 'Unstable Mana', color = '#66ffcc', description = 'When spending 50% of max mana, you explode in a small AoE.' },
                { image = '/images/dungeons/mutations/13.png', name = 'Vampiric Essence', color = '#ff6688', description = 'Enemies steal 5% of damage dealt as life.' },
                { image = '/images/dungeons/mutations/14.png', name = 'Painful Reflection', color = '#ffaa55', description = 'Enemies reflect 15% of damage received.' },
                { image = '/images/dungeons/mutations/15.png', name = 'Global Enrage', color = '#ff5544', description = 'Every minute, enemies gain cumulative damage.' },
              }},
              { type = 'warning', content = 'Check the daily mutator before entering! Anti-Heal and Vampiric Essence on high difficulty are brutal.' },
            }
          },
          dungeon_list = {
            name = 'Dungeon List',
            type = 'list',
            order = 2,
            items = {
              { name = 'The Aquarium', description = 'Boss: Lady Undine.', image = '/images/dungeons/The Aquarium.png' },
              { name = 'Black Temple', description = 'Boss: Lord Hamelin.', image = '/images/dungeons/Black Temple.png' },
              { name = 'Blackstone Depths', description = 'Boss: Drakkomir.', image = '/images/dungeons/Blackstone Depths.png' },
              { name = 'Crystal Rift', description = 'Boss: Crystallith.', image = '/images/dungeons/Crystal Rift.png' },
              { name = 'Dr Pomelo Laboratory', description = 'Boss: Doctor Pomelo.', image = '/images/dungeons/Dr Pomelo Laboratory.png' },
              { name = 'Garona Nightmare', description = 'Boss: Garona Nightmarized.', image = '/images/dungeons/Garona Nightmare.png' },
              { name = 'Goblin Lair', description = 'Boss: Garnak the Warlord.', image = '/images/dungeons/Goblin Lair.png' },
              { name = 'Lucellas Dungeon', description = 'Boss: Lucella.', image = '/images/dungeons/Lucellas Dungeon.png' },
              { name = 'Luminicent Path', description = 'Boss: Lumelia.', image = '/images/dungeons/Luminicent Path.png' },
              { name = 'Sandstorm Coliseum', description = 'Boss: Colliseum Champion Garuda.', image = '/images/dungeons/Sandstorm coliseum.png' },
              { name = 'Shadow Realm', description = 'Boss: Dreadmaw.', image = '/images/dungeons/Shadow Realm.png' },
              { name = 'The Pit', description = 'Boss: Widow Empress.', image = '/images/dungeons/The Pit.png' },
              { name = 'The Pyrotheca', description = 'Boss: Vulcanys.', image = '/images/icons/dungeon.png' },
            }
          },
        }
      },

      item_upgrades = {
        name = 'Item Upgrades',
        subcategories = {
          overview = {
            name = 'How It Works',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'ITEM UPGRADES', color = '#ffd75e' },
              { type = 'text', content = 'The **Orb of Performance** is the only upgrade item in the game. Use it on a piece of equipment to raise its upgrade level, shown as **+N** next to the item name - up to **+15**.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Using an Orb', color = '#66ff99' },
              { type = 'text', content = '**1.** Put the item in your backpack - orbs cannot be used on equipped gear.\n**2.** Use the Orb of Performance on the item.\n**3.** On success the item gains +1 upgrade level; on failure only the orb is consumed.' },
              { type = 'text', content = 'The item must be upgradable (weapons, shields, armor, legs, boots, rings and necklaces) and already have an **item level**. Unidentified or mirrored items cannot be modified.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Success Chance per Level', color = '#ff9e5e' },
              { type = 'text', content = '+1: 100% | +2: 85% | +3: 70% | +4: 50% | +5: 35% | +6: 20% | +7: 10% | +8: 8% | +9: 3% | +10 to +15: 2%' },
              { type = 'tip', content = 'A failed roll only costs the orb - the item is never downgraded or destroyed. Past +8 the odds drop sharply, so budget several orbs for the last levels.' },
            }
          },
          obtain = {
            name = 'How to Obtain',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'WHERE TO GET ORBS OF PERFORMANCE', color = '#ffd75e' },
              { type = 'text', content = 'Orbs of Performance come from a few reliable sources - dungeons are by far the steadiest one.' },
              { type = 'divider' },
              { type = 'cards', items = {
                { image = '/images/icons/dungeon.png', name = 'Dungeon Chests', color = '#66ff99', description = 'Every dungeon completion awards 3-5 orbs guaranteed. The most reliable farm once you can clear dungeons.' },
                { image = '/images/icons/prey_loot.png', name = 'Blue Loot Orbs', color = '#77aaff', description = 'Around a 10% chance per blue orb loot roll, on any monster level. Stacks up while you hunt.' },
                { image = '/images/icons/quest_marker.png', name = 'Task & Quest Rewards', color = '#ffd75e', description = 'Several NPC task list quests award 1-3 orbs on completion.' },
                { image = '/images/icons/icon_axe.png', name = 'Crafting', color = '#ffaa55', description = 'Craftable in the Augments category of professions using enchanting powders.' },
              }},
              { type = 'divider' },
              { type = 'tip', content = 'Daily dungeon runs plus orb drops while hunting will keep a steady supply - save them for gear you plan to keep.' },
            }
          },
          bonuses = {
            name = 'Upgrade Bonuses',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'title', text = 'WHAT EACH UPGRADE ADDS', color = '#ffd75e' },
              { type = 'text', content = 'Every upgrade level adds flat stats on top of the item\'s base values - the bonus scales with the +N level, so a +15 weapon is dramatically stronger than a +5 one.' },
              { type = 'divider' },
              { type = 'cards', items = {
                { image = '/images/icons/icon_axe.png', name = 'One-Handed Weapons', color = '#ff8888', description = '+2 attack per upgrade level.' },
                { image = '/images/icons/icon_axe.png', name = 'Two-Handed Weapons', color = '#ff6666', description = '+4 attack per upgrade level - double the bonus of one-handers.' },
                { image = '/images/icons/shield-divided-four_16769380.png', name = 'Shields & Weapons', color = '#66aaff', description = '+2 defense per upgrade level.' },
                { image = '/images/icons/shield-divided-four_16769380.png', name = 'Extra Defense', color = '#77ddff', description = '+1 extra defense per upgrade level on items that have it.' },
                { image = '/images/icons/icon_health.png', name = 'Armor Pieces', color = '#9fe89f', description = '+1 armor per upgrade level on armor, legs and boots.' },
              }},
              { type = 'divider' },
              { type = 'text', content = 'Upgrade bonuses are applied on top of the item\'s level-normalized stats, so upgrading a high **item level** piece is always more valuable than upgrading a low-level one.' },
            }
          },
        }
      },

      item_level = {
        name = 'Item Level',
        subcategories = {
          overview = {
            name = 'What Is Item Level',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'ITEM LEVEL', color = '#ffd75e' },
              { type = 'text', content = 'Every piece of gear that drops has an **item level (iLvl)** - a hidden power rating that determines how strong its stats are. Two copies of the same sword can have very different attack because they dropped at different item levels.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'The Basics', color = '#66ff99' },
              { type = 'text', content = '- iLvl is assigned when the item drops - equal to the level of the monster that dropped it.\n- Stats (attack, defense, armor) are scaled to that level, so higher iLvl = stronger item.\n- The item\'s tooltip shows its iLvl and a suggested character level to wield it.\n- iLvl caps at **500** - only the toughest endgame monsters reach it.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Why It Matters', color = '#ff9e5e' },
              { type = 'text', content = 'Item level is the backbone of gearing: a high-iLvl common item can beat a low-iLvl rare one. Before spending **Orbs of Performance**, make sure the piece is worth it - upgrades multiply a good base, they do not fix a weak one.' },
            }
          },
          calculation = {
            name = 'How It\'s Calculated',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'HOW ITEM LEVEL WORKS', color = '#ffd75e' },
              { type = 'text', content = 'Item level is not random - it is derived from the source that produced the item, then passed through several modifiers.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'The Drop', color = '#66ff99' },
              { type = 'text', content = 'When a monster dies, each eligible item in its corpse takes the **monster\'s level** as its item level. Hunting stronger zones is the only way to raise the iLvl floor of your drops.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Stat Normalization', color = '#ff9e5e' },
              { type = 'text', content = 'The item\'s attack, defense and armor are then rebuilt around that level: each equipment slot has its own baseline plus a per-level growth rate. That is why iLvl, not the item\'s name, decides its real power.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Source Quality', color = '#cc99ff' },
              { type = 'text', content = 'Where the item came from also matters - **elite** monsters, **bosses**, **orb drops** and **crafted** gear roll a source quality that can push stats above or below the level baseline.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Rarity Bonus', color = '#ffd75e' },
              { type = 'text', content = 'Identified items with **Orbital**, **Forged** or **Ascended** rarity get a modest item level bump on top of everything else - rarity is the cherry on top, not the foundation.' },
              { type = 'divider' },
              { type = 'tip', content = 'Rule of thumb: monster level sets the ceiling, source quality and rarity decide where inside it the item lands.' },
            }
          },
        }
      },

      proficiency = {
        name = 'Item Proficiency',
        subcategories = {
          overview = {
            name = 'Proficiency Guide',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'ITEM PROFICIENCY', color = '#ffd75e' },
              { type = 'text', content = 'Your equipped items gain proficiency XP as you kill monsters. Each milestone unlocks a [color=#ffd700]trait choice[/color] - pick one trait per column to customize that item.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'How XP works', color = '#66ff99' },
              { type = 'text', content = 'Per monster kill, each eligible equipped item gains [color=#ffd700]300 + 15% of the monster exp[/color] proficiency XP. Progress is tracked per item id - swap gear and your progress stays saved.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Milestones (7 columns)', color = '#ff9e5e' },
              { type = 'text', content = '**Col 1:** 91,000 XP | **Col 2:** 205,000 | **Col 3:** 455,000 | **Col 4:** 1,023,750 | **Col 5:** 2,275,000 | **Col 6:** 5,005,000 | **Col 7:** 11,375,000' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Example Traits', color = '#cc66ff' },
              { type = 'cards', items = {
                { image = '/images/proficiency/executioner.png', name = 'Executioner', color = '#ff6666', description = 'Deal +30% damage to enemies below 25% health.' },
                { image = '/images/proficiency/cleave.png', name = 'Cleave', color = '#ffaa55', description = 'Melee hits have 35% chance to splash 60% damage to adjacent enemies.' },
                { image = '/images/proficiency/bloodfeast.png', name = 'Bloodfeast', color = '#ff8888', description = 'Heal for 4% of the damage you deal.' },
                { image = '/images/proficiency/last_stand.png', name = 'Last Stand', color = '#8888ff', description = 'Below 30% health, take 30% less damage.' },
                { image = '/images/proficiency/twin_strike.png', name = 'Twin Strike', color = '#66ffee', description = '20% chance to instantly strike again for 70% damage.' },
                { image = '/images/proficiency/adrenaline.png', name = 'Adrenaline', color = '#ffcc66', description = 'Below 40% health, gain +12% attack speed.' },
              }},
              { type = 'tip', content = 'Traits are per item type (weapons, bows, wands, shields, armor, rings, necklaces, boots each have their own trait route). Check the Proficiency window to preview all routes.' },
            }
          },
          traits = {
            name = 'Trait List',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'ALL PROFICIENCY TRAITS', color = '#ffd75e' },
              { type = 'text', content = 'Every trait available in proficiency routes. Icons match the in-game Proficiency window. Which traits appear depends on the item type route.' },
              { type = 'divider' },
              { type = 'subtitle', text = 'Core Stat Traits (30)', color = '#66ff99' },
              { type = 'cards', items = {
                { image = '/images/proficiency/keen_edge.png', name = 'Keen Edge', color = '#66ff99', description = '+4% Critical Hit Chance' },
                { image = '/images/proficiency/brutality.png', name = 'Brutality', color = '#66ff99', description = '+5% Physical Damage' },
                { image = '/images/proficiency/swiftstrike.png', name = 'Swiftstrike', color = '#66ff99', description = '+5% Attack Speed' },
                { image = '/images/proficiency/sharpened.png', name = 'Sharpened', color = '#66ff99', description = '+2 Sword skill' },
                { image = '/images/proficiency/heavy_blows.png', name = 'Heavy Blows', color = '#66ff99', description = '+2 Arcana skill' },
                { image = '/images/proficiency/crushing.png', name = 'Crushing', color = '#66ff99', description = '+2 Sword skill +2% Critical Hit Chance ' },
                { image = '/images/proficiency/steady_aim.png', name = 'Steady Aim', color = '#66ff99', description = '+3 Distance skill' },
                { image = '/images/proficiency/spellbinder.png', name = 'Spellbinder', color = '#66ff99', description = '+3 Magic Level' },
                { image = '/images/proficiency/vampiric.png', name = 'Vampiric', color = '#66ff99', description = '+5% Life Leech Amount' },
                { image = '/images/proficiency/bloodthirst.png', name = 'Bloodthirst', color = '#66ff99', description = '+8% Life Leech Amount' },
                { image = '/images/proficiency/mana_siphon.png', name = 'Mana Siphon', color = '#66ff99', description = '+5% Mana Leech Amount' },
                { image = '/images/proficiency/mind_drain.png', name = 'Mind Drain', color = '#66ff99', description = '+8% Mana Leech Amount' },
                { image = '/images/proficiency/emberforged.png', name = 'Emberforged', color = '#66ff99', description = '+6% Fire Damage' },
                { image = '/images/proficiency/frostbitten.png', name = 'Frostbitten', color = '#66ff99', description = '+6% Ice Damage' },
                { image = '/images/proficiency/hallowed.png', name = 'Hallowed', color = '#66ff99', description = '+6% Holy Damage' },
                { image = '/images/proficiency/necrotic.png', name = 'Necrotic', color = '#66ff99', description = '+6% Death Damage' },
                { image = '/images/proficiency/stormcharged.png', name = 'Stormcharged', color = '#66ff99', description = '+6% Energy Damage' },
                { image = '/images/proficiency/earthrender.png', name = 'Earthrender', color = '#66ff99', description = '+6% Earth Damage' },
                { image = '/images/proficiency/reinforced.png', name = 'Reinforced', color = '#66ff99', description = '+4% Physical Damage, +3% Block' },
                { image = '/images/proficiency/vitality.png', name = 'Vitality', color = '#66ff99', description = '+7% Max Health' },
                { image = '/images/proficiency/clarity.png', name = 'Clarity', color = '#66ff99', description = '+7% Max Mana' },
                { image = '/images/proficiency/evasion.png', name = 'Evasion', color = '#66ff99', description = '+4% Dodge' },
                { image = '/images/proficiency/bulwark.png', name = 'Bulwark', color = '#66ff99', description = '+4% Block' },
                { image = '/images/proficiency/aegis.png', name = 'Aegis', color = '#66ff99', description = '+2 Defence skill' },
                { image = '/images/proficiency/fortified.png', name = 'Fortified', color = '#66ff99', description = '+8% Shield Power' },
                { image = '/images/proficiency/mending.png', name = 'Mending', color = '#66ff99', description = '+12% Extra Healing' },
                { image = '/images/proficiency/focus.png', name = 'Focus', color = '#66ff99', description = '+8% Cooldown Reduction' },
                { image = '/images/proficiency/swiftness.png', name = 'Swiftness', color = '#66ff99', description = '+25 Movement Speed' },
                { image = '/images/proficiency/regrowth.png', name = 'Regrowth', color = '#66ff99', description = '+6% Max HP regeneration / 6s' },
                { image = '/images/proficiency/channeling.png', name = 'Channeling', color = '#66ff99', description = '+6% Max MP regeneration / 6s' },
              }},
              { type = 'divider' },
              { type = 'subtitle', text = 'Playstyle Procs (14)', color = '#ff9e5e' },
              { type = 'cards', items = {
                { image = '/images/proficiency/executioner.png', name = 'Executioner', color = '#ff9e5e', description = 'Deal +30% damage to enemies below 25% Health.' },
                { image = '/images/proficiency/opportunist.png', name = 'Opportunist', color = '#ff9e5e', description = 'Deal +20% damage to isolated enemies (no other enemy beside them).' },
                { image = '/images/proficiency/rend.png', name = 'Rend', color = '#ff9e5e', description = '30% chance on hit to cause Bleed (physical damage over time).' },
                { image = '/images/proficiency/cleave.png', name = 'Cleave', color = '#ff9e5e', description = 'Melee hits have a 35% chance to splash 60% damage to adjacent enemies.' },
                { image = '/images/proficiency/arc_surge.png', name = 'Arc Surge', color = '#ff9e5e', description = '25% chance on hit to arc 50% energy damage to a nearby enemy.' },
                { image = '/images/proficiency/lone_wolf.png', name = 'Lone Wolf', color = '#ff9e5e', description = 'While no allies are nearby, deal +15% damage.' },
                { image = '/images/proficiency/pack_tactics.png', name = 'Pack Tactics', color = '#ff9e5e', description = 'Deal +6% damage per nearby ally (max +18%).' },
                { image = '/images/proficiency/warding_bond.png', name = 'Warding Bond', color = '#ff9e5e', description = 'While allies are nearby, take 12% less damage.' },
                { image = '/images/proficiency/self_reliant.png', name = 'Self-Reliant', color = '#ff9e5e', description = 'While no allies are nearby, take 15% less damage.' },
                { image = '/images/proficiency/bloodfeast.png', name = 'Bloodfeast', color = '#ff9e5e', description = 'Heal for 4% of the damage you deal.' },
                { image = '/images/proficiency/soul_harvest.png', name = 'Soul Harvest', color = '#ff9e5e', description = '20% chance on hit to restore mana equal to 3% of damage dealt.' },
                { image = '/images/proficiency/last_stand.png', name = 'Last Stand', color = '#ff9e5e', description = 'While below 30% Health, take 30% less damage.' },
                { image = '/images/proficiency/thornguard.png', name = 'Thornguard', color = '#ff9e5e', description = 'Reflect 20% of physical damage taken back to the attacker.' },
                { image = '/images/proficiency/adrenaline.png', name = 'Adrenaline', color = '#ff9e5e', description = 'While below 40% Health, gain +12% Attack Speed.' },
              }},
              { type = 'divider' },
              { type = 'subtitle', text = 'Proc Perks (71)', color = '#66aaff' },
              { type = 'cards', items = {
                { image = '/images/proficiency/god_spear.png', name = 'God Spear', color = '#66aaff', description = 'Weapon attacks have a 20% chance to deal +2% of the enemy\'s Max Health as bonus damage.' },
                { image = '/images/proficiency/heartseeker.png', name = 'Heartseeker', color = '#66aaff', description = 'Weapon attacks have a 15% chance to deal +3% of the enemy\'s Max Health as bonus damage.' },
                { image = '/images/proficiency/head_shot.png', name = 'Head Shot', color = '#66aaff', description = 'Enemies below 25% Health take +80% damage from you.' },
                { image = '/images/proficiency/coup_de_grace.png', name = 'Coup de Grace', color = '#66aaff', description = 'Enemies below 15% Health take +150% damage from you.' },
                { image = '/images/proficiency/executioners_will.png', name = 'Executioners Will', color = '#66aaff', description = 'Enemies below 30% Health take +60% damage from you.' },
                { image = '/images/proficiency/twin_strike.png', name = 'Twin Strike', color = '#66aaff', description = 'Weapon attacks have a 20% chance to instantly strike again for 70% damage.' },
                { image = '/images/proficiency/flurry_of_blows.png', name = 'Flurry of Blows', color = '#66aaff', description = 'Weapon attacks have a 14% chance to instantly strike again for full damage.' },
                { image = '/images/proficiency/rupturing_strike.png', name = 'Rupturing Strike', color = '#66aaff', description = 'Weapon attacks have a 12% chance to instantly strike again for 120% damage.' },
                { image = '/images/proficiency/whirlwind.png', name = 'Whirlwind', color = '#66aaff', description = 'Melee weapon attacks have a 25% chance to hit all adjacent enemies for 30% damage.' },
                { image = '/images/proficiency/seismic_slam.png', name = 'Seismic Slam', color = '#66aaff', description = 'Melee weapon attacks have a 16% chance to hit all adjacent enemies for 45% damage.' },
                { image = '/images/proficiency/cleaving_arc.png', name = 'Cleaving Arc', color = '#66aaff', description = 'Melee weapon attacks have a 20% chance to hit all adjacent enemies for 25% damage.' },
                { image = '/images/proficiency/chain_spark.png', name = 'Chain Spark', color = '#66aaff', description = 'Damaging abilities have an 18% chance to arc 65% energy damage to a nearby enemy.' },
                { image = '/images/proficiency/inferno_lash.png', name = 'Inferno Lash', color = '#66aaff', description = 'Damaging abilities have an 18% chance to arc 65% fire damage to a nearby enemy.' },
                { image = '/images/proficiency/avalanche.png', name = 'Avalanche', color = '#66aaff', description = 'Damaging abilities have an 18% chance to arc 65% ice damage to a nearby enemy.' },
                { image = '/images/proficiency/earthbind.png', name = 'Earthbind', color = '#66aaff', description = 'Damaging abilities have an 18% chance to arc 65% earth damage to a nearby enemy.' },
                { image = '/images/proficiency/sacred_bolt.png', name = 'Sacred Bolt', color = '#66aaff', description = 'Damaging abilities have an 18% chance to arc 65% holy damage to a nearby enemy.' },
                { image = '/images/proficiency/parasyte.png', name = 'Parasyte', color = '#66aaff', description = 'Damaging abilities have an 18% chance to arc 65% death damage to a nearby enemy.' },
                { image = '/images/proficiency/concussive_blow.png', name = 'Concussive Blow', color = '#66aaff', description = 'Weapon attacks have a 10% chance to stun the enemy for 1.2s.' },
                { image = '/images/proficiency/skullbreaker.png', name = 'Skullbreaker', color = '#66aaff', description = 'Weapon attacks have an 8% chance to stun the enemy for 1.7s.' },
                { image = '/images/proficiency/stunning_fist.png', name = 'Stunning Fist', color = '#66aaff', description = 'Weapon attacks have a 12% chance to stun the enemy for 1s.' },
                { image = '/images/proficiency/dread_visage.png', name = 'Dread Visage', color = '#66aaff', description = 'Weapon attacks have a 10% chance to make the enemy flee in fear for 2.5s.' },
                { image = '/images/proficiency/nightmare_toll.png', name = 'Nightmare Toll', color = '#66aaff', description = 'Weapon attacks have an 8% chance to make the enemy flee in fear for 3s.' },
                { image = '/images/proficiency/horrify.png', name = 'Horrify', color = '#66aaff', description = 'Weapon attacks have a 12% chance to make the enemy flee in fear for 2s.' },
                { image = '/images/proficiency/crippling_cut.png', name = 'Crippling Cut', color = '#66aaff', description = 'Weapon attacks have a 25% chance to cripple the enemy (slow) for 3s.' },
                { image = '/images/proficiency/glacial_edge.png', name = 'Glacial Edge', color = '#66aaff', description = 'Weapon attacks have a 20% chance to freeze the enemy in place (slow) for 3.5s.' },
                { image = '/images/proficiency/frostbite.png', name = 'Frostbite', color = '#66aaff', description = 'Weapon attacks have a 28% chance to chill the enemy (slow) for 2.5s.' },
                { image = '/images/proficiency/searing_brand.png', name = 'Searing Brand', color = '#66aaff', description = 'Weapon attacks have a 30% chance to set the enemy ablaze, burning over time.' },
                { image = '/images/proficiency/cinderbite.png', name = 'Cinderbite', color = '#66aaff', description = 'Weapon attacks have a 22% chance to inflict heavy burning damage over time.' },
                { image = '/images/proficiency/wildfire.png', name = 'Wildfire', color = '#66aaff', description = 'Weapon attacks have a 26% chance to ignite the enemy, burning over time.' },
                { image = '/images/proficiency/envenom.png', name = 'Envenom', color = '#66aaff', description = 'Weapon attacks have a 30% chance to poison the enemy over time.' },
                { image = '/images/proficiency/plaguebearer.png', name = 'Plaguebearer', color = '#66aaff', description = 'Weapon attacks have a 22% chance to inflict virulent poison.' },
                { image = '/images/proficiency/toxic_coating.png', name = 'Toxic Coating', color = '#66aaff', description = 'Weapon attacks have a 26% chance to coat your strikes in poison.' },
                { image = '/images/proficiency/bloodletter.png', name = 'Bloodletter', color = '#66aaff', description = 'Weapon attacks have a 30% chance to cause bleeding (physical damage over time).' },
                { image = '/images/proficiency/hemorrhage.png', name = 'Hemorrhage', color = '#66aaff', description = 'Weapon attacks have a 26% chance to cause severe bleeding.' },
                { image = '/images/proficiency/leeching_strikes.png', name = 'Leeching Strikes', color = '#66aaff', description = 'Heal for 5% of all damage you deal.' },
                { image = '/images/proficiency/vampiric_edge.png', name = 'Vampiric Edge', color = '#66aaff', description = 'Heal for 3% of all damage you deal.' },
                { image = '/images/proficiency/spirit_siphon.png', name = 'Spirit Siphon', color = '#66aaff', description = '25% chance on any damage to restore mana equal to 4% of damage dealt.' },
                { image = '/images/proficiency/mana_reaver.png', name = 'Mana Reaver', color = '#66aaff', description = '20% chance on any damage to restore mana equal to 5% of damage dealt.' },
                { image = '/images/proficiency/overpower.png', name = 'Overpower', color = '#66aaff', description = '25% chance on any damage to deal +35% bonus damage.' },
                { image = '/images/proficiency/knight.png', name = 'Knight', color = '#66aaff', description = '20% chance on any damage to deal +45% bonus damage.' },
                { image = '/images/proficiency/ruthless_strike.png', name = 'Ruthless Strike', color = '#66aaff', description = '15% chance on any damage to deal +60% bonus damage.' },
                { image = '/images/proficiency/solar_flare.png', name = 'Solar Flare', color = '#66aaff', description = 'Damaging abilities have a 15% chance to burst holy fire, dealing 25% of hit as holy damage to all adjacent enemies.' },
                { image = '/images/proficiency/void_collapse.png', name = 'Void Collapse', color = '#66aaff', description = 'Damaging abilities have a 15% chance to collapse dark energy, dealing 25% of hit as death damage to all adjacent enemies.' },
                { image = '/images/proficiency/dragons_breath.png', name = 'Dragons Breath', color = '#66aaff', description = 'Damaging abilities have a 15% chance to breathe fire, dealing 25% of hit as fire damage to adjacent enemies.' },
                { image = '/images/proficiency/judgment.png', name = 'Judgment', color = '#66aaff', description = 'Damaging abilities have a 20% chance to smite with holy light for 50% bonus holy damage.' },
                { image = '/images/proficiency/soul_reap.png', name = 'Soul Reap', color = '#66aaff', description = 'Damaging abilities have a 20% chance to reap the soul for 50% bonus death damage and heal for 15% of it.' },
                { image = '/images/proficiency/iron_bulwark.png', name = 'Iron Bulwark', color = '#66aaff', description = '25% chance to take 20% less physical damage from an incoming hit.' },
                { image = '/images/proficiency/astral_form.png', name = 'Astral Form', color = '#66aaff', description = '20% chance to take 25% less physical damage from an incoming hit.' },
                { image = '/images/proficiency/resilience.png', name = 'Resilience', color = '#66aaff', description = '15% chance to take 15% less magic damage from an incoming hit.' },
                { image = '/images/proficiency/aegis_reflex.png', name = 'Aegis Reflex', color = '#66aaff', description = '10% chance to completely block an incoming hit.' },
                { image = '/images/proficiency/etheral_form.png', name = 'Etheral Form', color = '#66aaff', description = '6% chance to completely block an incoming hit. +3% Dodge' },
                { image = '/images/proficiency/life_form.png', name = 'Life Form', color = '#66aaff', description = '8% chance to completely block an incoming hit. +3% Max Health' },
                { image = '/images/proficiency/thorns.png', name = 'Thorns', color = '#66aaff', description = 'Reflect 15% of damage taken back to the attacker. +2% Dodge' },
                { image = '/images/proficiency/payback.png', name = 'Payback', color = '#66aaff', description = 'Reflect 25% of damage taken back to the attacker.' },
                { image = '/images/proficiency/bramblemail.png', name = 'Bramblemail', color = '#66aaff', description = 'Reflect 20% of damage taken back to the attacker. +2% Block' },
                { image = '/images/proficiency/counterstrike.png', name = 'Counterstrike', color = '#66aaff', description = '12% chance to stun your attacker when you are hit.' },
                { image = '/images/proficiency/riposte.png', name = 'Riposte', color = '#66aaff', description = '10% chance to stun your attacker when you are hit.' },
                { image = '/images/proficiency/frost_nova.png', name = 'Frost Nova', color = '#66aaff', description = '18% chance to slow your attacker when you are hit.' },
                { image = '/images/proficiency/terrifying_visage.png', name = 'Terrifying Visage', color = '#66aaff', description = '10% chance to make your attacker flee when you are hit.' },
                { image = '/images/proficiency/burning_resolve.png', name = 'Burning Resolve', color = '#66aaff', description = '25% chance to set your attacker ablaze when hit.' },
                { image = '/images/proficiency/searing_skin.png', name = 'Searing Skin', color = '#66aaff', description = '20% chance to set your attacker ablaze when hit.' },
                { image = '/images/proficiency/second_wind.png', name = 'Second Wind', color = '#66aaff', description = '20% chance to heal 5% of Max Health when hit.' },
                { image = '/images/proficiency/lifeward.png', name = 'Lifeward', color = '#66aaff', description = '15% chance to heal 8% of Max Health when hit.' },
                { image = '/images/proficiency/battle_trance.png', name = 'Battle Trance', color = '#66aaff', description = '20% chance to gain +12% Attack Speed for 4s when hit.' },
                { image = '/images/proficiency/adrenal_surge.png', name = 'Adrenal Surge', color = '#66aaff', description = '15% chance to gain +18% Attack Speed for 5s when hit.' },
                { image = '/images/proficiency/rallying_cry.png', name = 'Rallying Cry', color = '#66aaff', description = '12% chance to gain +20% Attack Speed for 6s when hit.' },
                { image = '/images/proficiency/bastion_stance.png', name = 'Bastion Stance', color = '#66aaff', description = '20% chance to gain a protective ward (+15% defense) for 4s when hit.' },
                { image = '/images/proficiency/bracing_guard.png', name = 'Bracing Guard', color = '#66aaff', description = '15% chance to gain a protective ward (+20% defense) for 5s when hit.' },
                { image = '/images/proficiency/granite_skin.png', name = 'Granite Skin', color = '#66aaff', description = '12% chance to gain a protective ward (+25% defense) for 6s when hit.' },
                { image = '/images/proficiency/purifying_flame.png', name = 'Purifying Flame', color = '#66aaff', description = '18% chance to cleanse a negative condition when hit.' },
                { image = '/images/proficiency/mana_shell.png', name = 'Mana Shell', color = '#66aaff', description = '15% chance to restore 10% of Max Mana when hit.' },
              }},
              { type = 'divider' },
              { type = 'subtitle', text = 'Hybrid Traits (54)', color = '#cc66ff' },
              { type = 'cards', items = {
                { image = '/images/proficiency/glacial_burst.png', name = 'Glacial Burst', color = '#cc66ff', description = 'Damaging abilities have a 15% chance to erupt ice, dealing 25% of hit as ice damage to adjacent enemies.' },
                { image = '/images/proficiency/arc_storm.png', name = 'Arc Storm', color = '#cc66ff', description = 'Damaging abilities have a 15% chance to discharge lightning, dealing 25% of hit as energy damage to adjacent enemies.' },
                { image = '/images/proficiency/toxic_touch.png', name = 'Toxic Touch', color = '#cc66ff', description = 'Damaging abilities have a 15% chance to burst spores, dealing 25% of hit as earth damage to adjacent enemies.' },
                { image = '/images/proficiency/infernal_touch.png', name = 'Infernal Touch', color = '#cc66ff', description = 'Damaging abilities have a 20% chance to scorch the target for 50% bonus fire damage.' },
                { image = '/images/proficiency/glacial_spike.png', name = 'Glacial Spike', color = '#cc66ff', description = 'Damaging abilities have a 20% chance to pierce with ice for 50% bonus ice damage.' },
                { image = '/images/proficiency/spark_strike.png', name = 'Spark Strike', color = '#cc66ff', description = 'Damaging abilities have a 20% chance to shock the target for 50% bonus energy damage.' },
                { image = '/images/proficiency/venom_blood.png', name = 'Venom Blood', color = '#cc66ff', description = 'Damaging abilities have a 20% chance to impale with earth for 50% bonus earth damage.' },
                { image = '/images/proficiency/edge_of_ruin.png', name = 'Edge of Ruin', color = '#cc66ff', description = '+4% Crit Chance, +8% Physical Damage' },
                { image = '/images/proficiency/cruel_intent.png', name = 'Cruel Intent', color = '#cc66ff', description = '+8% Physical Damage, +4% Life Leech Amount' },
                { image = '/images/proficiency/reapers_focus.png', name = 'Reapers Focus', color = '#cc66ff', description = '+4% Crit Chance, +3% Cooldown Reduction' },
                { image = '/images/proficiency/deadeye.png', name = 'Deadeye', color = '#cc66ff', description = '+6% Crit Chance' },
                { image = '/images/proficiency/mortal_verdict.png', name = 'Mortal Verdict', color = '#cc66ff', description = '+4% Crit Chance, +10% Physical Damage' },
                { image = '/images/proficiency/hawkeye.png', name = 'Hawkeye', color = '#cc66ff', description = '+6% Crit Chance' },
                { image = '/images/proficiency/lucky_strike.png', name = 'Lucky Strike', color = '#cc66ff', description = '+4% Crit Chance, +3% Dodge' },
                { image = '/images/proficiency/phantom_step.png', name = 'Phantom Step', color = '#cc66ff', description = '+3% Attack Speed, +2% Dodge' },
                { image = '/images/proficiency/quickblade.png', name = 'Quickblade', color = '#cc66ff', description = '+4% Attack Speed, +5% Physical Damage' },
                { image = '/images/proficiency/berserkers_rage.png', name = 'Berserkers Rage', color = '#cc66ff', description = '+3% Attack Speed, +3% Crit Chance' },
                { image = '/images/proficiency/storm_edge.png', name = 'Storm Edge', color = '#cc66ff', description = '+3% Attack Speed, +4% Energy Damage' },
                { image = '/images/proficiency/bloodfury.png', name = 'Bloodfury', color = '#cc66ff', description = '+4% Attack Speed, +5% Life Leech Amount' },
                { image = '/images/proficiency/war_machine.png', name = 'War Machine', color = '#cc66ff', description = '+4% Attack Speed, +3% Block' },
                { image = '/images/proficiency/fleetfoot.png', name = 'Fleetfoot', color = '#cc66ff', description = '+4% Attack Speed, +20 Movement Speed' },
                { image = '/images/proficiency/duelists_grace.png', name = 'Duelists Grace', color = '#cc66ff', description = '+3% Attack Speed, +2% Dodge' },
                { image = '/images/proficiency/bloodfire.png', name = 'Bloodfire', color = '#cc66ff', description = '+4% Life Leech Chance, +6% Life Leech Amount' },
                { image = '/images/proficiency/crimson_feast.png', name = 'Crimson Feast', color = '#cc66ff', description = '+6% Life Leech Amount, +4% Physical Damage' },
                { image = '/images/proficiency/dark_pact.png', name = 'Dark Pact', color = '#cc66ff', description = '+3% Life Leech Chance, +10 HP regen / 6s' },
                { image = '/images/proficiency/bloodscent.png', name = 'Bloodscent', color = '#cc66ff', description = '+5% Life Leech Chance, +3% Attack Speed' },
                { image = '/images/proficiency/hallowed_mending.png', name = 'Hallowed Mending', color = '#cc66ff', description = '+12% Extra Healing, +12 HP regen / 6s' },
                { image = '/images/proficiency/oblivion.png', name = 'Oblivion', color = '#cc66ff', description = '+8% Life Leech Amount, +5% Max Health' },
                { image = '/images/proficiency/mage_wisdom.png', name = 'Mage Wisdom', color = '#cc66ff', description = '+2 Magic Level, +5% Max Mana' },
                { image = '/images/proficiency/soulbound_tome.png', name = 'Soulbound Tome', color = '#cc66ff', description = '+2 Magic Level, +5% Max Mana' },
                { image = '/images/proficiency/void_channeling.png', name = 'Void Channeling', color = '#cc66ff', description = '+2 Magic Level, +4% Holy Damage' },
                { image = '/images/proficiency/arcane_tempo.png', name = 'Arcane Tempo', color = '#cc66ff', description = '+2 Magic Level, +3% Cooldown Reduction' },
                { image = '/images/proficiency/spellblade.png', name = 'Spellblade', color = '#cc66ff', description = '+2 Magic Level, +3% Attack Speed' },
                { image = '/images/proficiency/mana_font.png', name = 'Mana Font', color = '#cc66ff', description = '+4% Mana Leech Chance, +12 MP regen / 6s' },
                { image = '/images/proficiency/arcane_explosion.png', name = 'Arcane Explosion', color = '#cc66ff', description = '+2 Magic Level, +3% Crit Chance' },
                { image = '/images/proficiency/sages_helmet.png', name = 'Sages Helmet', color = '#cc66ff', description = '+2 Magic Level, +4% Cooldown Reduction' },
                { image = '/images/proficiency/apprentices_robe.png', name = 'Apprentices Robe', color = '#cc66ff', description = '+2 Magic Level, +4% Max Mana' },
                { image = '/images/proficiency/demonic_circle.png', name = 'Demonic Circle', color = '#cc66ff', description = '+2 Magic Level, +5% Life Leech Amount' },
                { image = '/images/proficiency/pyre_heart.png', name = 'Pyre Heart', color = '#cc66ff', description = '+6% Fire Damage' },
                { image = '/images/proficiency/frost_core.png', name = 'Frost Core', color = '#cc66ff', description = '+6% Ice Damage' },
                { image = '/images/proficiency/emberhide.png', name = 'Emberhide', color = '#cc66ff', description = '+5% Fire Damage, +5% Max Health' },
                { image = '/images/proficiency/flamereaver.png', name = 'Flamereaver', color = '#cc66ff', description = '+4% Fire Damage, +5% Life Leech Amount' },
                { image = '/images/proficiency/flame_hands.png', name = 'Flame Hands', color = '#cc66ff', description = '+5% Fire Damage, +4% Physical Damage' },
                { image = '/images/proficiency/permafrost.png', name = 'Permafrost', color = '#cc66ff', description = '+5% Ice Damage, +5% Max Health, +5% Max Mana' },
                { image = '/images/proficiency/stormcaller.png', name = 'Stormcaller', color = '#cc66ff', description = '+6% Energy Damage, +3% Attack Speed' },
                { image = '/images/proficiency/glacial_aegis.png', name = 'Glacial Aegis', color = '#cc66ff', description = '+4% Ice Damage, +5% Max Mana' },
                { image = '/images/proficiency/necrotic_sigil.png', name = 'Necrotic Sigil', color = '#cc66ff', description = '+6% Death Damage' },
                { image = '/images/proficiency/sacred_light.png', name = 'Sacred Light', color = '#cc66ff', description = '+7% Holy Damage' },
                { image = '/images/proficiency/stormbrand.png', name = 'Stormbrand', color = '#cc66ff', description = '+5% Energy Damage, +2% Attack Speed' },
                { image = '/images/proficiency/hellforged.png', name = 'Hellforged', color = '#cc66ff', description = '+5% Fire Damage, +6% Max Health' },
                { image = '/images/proficiency/naturewrath.png', name = 'Naturewrath', color = '#cc66ff', description = '+4% Ice Damage, +6% Max Health' },
                { image = '/images/proficiency/ruinous_power.png', name = 'Ruinous Power', color = '#cc66ff', description = '+3 Magic Level, +4% Cooldown Reduction' },
                { image = '/images/proficiency/shield_mastery.png', name = 'Shield Mastery', color = '#cc66ff', description = 'Damage taken -15%, Damage dealt -25%' },
                { image = '/images/proficiency/healing_mastery.png', name = 'Healing Mastery', color = '#cc66ff', description = '+10% Healing, Damage dealt -15%' },
              }},
            }
          },        }
      },

      crafting = {
        name = 'Crafting',
        subcategories = {
          overview = {
            name = 'Crafting Guide',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'CRAFTING & PROFESSIONS', color = '#ffd75e' },
              { type = 'text', content = 'Crafted gear is a core progression path: blueprint recipes produce [color=#ffd700]pre-upgraded items[/color] with custom stats - often better than regular drops of the same tier.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'How to get materials', color = '#66ff99' },
              { type = 'cards', items = {
                { icon = 6500, name = 'Monster Essence', color = '#66ff99', description = 'Farm regular monsters - every recipe needs 30-35.' },
                { icon = 11223, name = 'Boss Essence', color = '#ff6666', description = 'Kill zone bosses and dungeon bosses - 2 per craft.' },
                { icon = 29080, name = 'Crystal Fossils', color = '#aaddaa', description = 'Drop from monsters (1:30 chance, level 10+). Extract crystals with the Crystal Extractor.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Professions', color = '#ff9e5e' },
              { type = 'cards', items = {
                { icon = 35768, name = 'Alchemy', color = '#77ff77', description = 'Brew custom potions. Level it by crafting.' },
                { icon = 29034, name = 'Enchanting', color = '#cc99ff', description = 'Disenchant gear and craft stat runes (blue/green/yellow/purple/red tiers with unique rolls).' },
                { icon = 3630, name = 'Blacksmith', color = '#ff8888', description = 'Forge weapons and armor from metal bars - typically paired with Mining for its ore.' },
                { icon = 39962, name = 'Refinery', color = '#ffd75e', description = 'The gadgets profession - turns Woodcutting planks and materials into utility items: grappling hook, boomerang sword, glue bombs, bandages, decoys, camp tents and training weapons. Gadget damage and healing scale with your Refinery level.' },
                { icon = 6500, name = 'Herbalism', color = '#88cc66', description = 'Gather herbs from random herb nodes in the world.' },
                { icon = 6500, name = 'Mining', color = '#ccaa77', description = 'Mine ore from random vein nodes.' },
                { icon = 6500, name = 'Woodcutting', color = '#aa7744', description = 'Chop tree nodes for logs and refine them into planks - the raw material of Refinery gadgets. Grants attack speed per level.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Why crafted items are better', color = '#ffd75e' },
              { type = 'text', content = '**Pre-upgraded:** blueprint items come out already upgraded, saving crystals and risk.\n**Custom stats:** they roll attributes from the item balance table (crit, leech, %HP, cooldown reduction, etc.) - real end-game stats, not flat armor.\n**Blueprints:** learn recipes like Fire Sword, Dragonbreath Crossbow, Grievous Axe, Fire Essence Wand and Fragment of Pure Life.' },
            }
          },
          bonuses = {
            name = 'Crafting Bonuses',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'CRAFTING BONUSES', color = '#ffd75e' },
              { type = 'text', content = 'Crafted items do not inherit a monster\'s level - their **item level is built from the recipe**, your profession level and a bit of luck. That is why a good crafter outclasses monster drops.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Where the Item Level Comes From', color = '#66ff99' },
              { type = 'text', content = '**1.** Every recipe has a **tier** that sets the base item level - higher-tier blueprints produce much higher iLvl.\n**2.** Your **profession level** adds item levels on top of every craft.\n**3.** A lucky **rarity roll** (Orbital / Forged) pushes the item level even further.\nStats are then normalized to that final iLvl, exactly like a drop of the same level - but you control the tier.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Crafted Quality', color = '#ff9e5e' },
              { type = 'text', content = 'Monster drops roll mostly Damaged, Worn or Normal quality. **Tier 1+ recipes always craft at Superior or better**, and the quality floor keeps rising with your profession level - Pristine and Perfect rolls become reachable at high level.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'What Leveling a Profession Gives You', color = '#cc99ff' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Higher Item Level', color = '#ffd75e', description = 'Each profession level adds item levels to everything you craft - your gear scales with your skill, not with luck.' },
                { image = '/images/icons/gem.png', name = 'Better Rarity Odds', color = '#cc99ff', description = 'Tiered recipes roll rarity with a bonus from your profession level - more Orbital and Forged results as you level.' },
                { image = '/images/icons/crown.png', name = 'Higher Quality Floor', color = '#ffaa55', description = 'Profession level raises the minimum quality of your crafts, so bad rolls disappear over time.' },
                { image = '/images/icons/quest_marker.png', name = 'Recipe Unlocks', color = '#66ff99', description = 'Higher-tier blueprints require a minimum profession level - leveling opens the strongest crafts.' },
                { image = '/images/icons/icon_magic.png', name = 'Stronger Runes', color = '#77ddff', description = 'Enchanting crafts special runes whose item level scales with your Enchanting skill.' },
              }},
              { type = 'divider' },
              { type = 'tip', content = 'Every craft also awards profession experience and Fame - leveling professions is progress even when the item itself is not an upgrade.' },
            }
          },
          materials = {
            name = 'Materials',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'title', text = 'CRAFTING MATERIALS', color = '#ffd75e' },
              { type = 'text', content = 'Every recipe asks for a mix of **essences**, **gathered goods** and **powders**. Most come from hunting - blue loot orbs carry the bulk of the raw materials.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Core Essences', color = '#66ff99' },
              { type = 'cards', items = {
                { icon = 6500, name = 'Monster Essence', color = '#66ff99', description = 'The backbone material - nearly every recipe needs it. Drops from monsters and blue orb rolls.' },
                { icon = 11223, name = 'Guardian Essence', color = '#ff8888', description = 'Boss-tier essence required by advanced recipes. Hunt zone and dungeon bosses.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Elemental Essences', color = '#77ddff' },
              { type = 'text', content = 'Eight refined essences fuel mid and high-tier recipes. They **only drop from elite variation monsters** - the ones with a prefix like [Vampiric] or [Burning]. Each variation feeds exactly one essence, so hunt the prefix you need.' },
              { type = 'cards', items = {
                { icon = 40418, name = 'Life Essence', color = '#ff6666', description = 'Drops from [Vampiric] elite monsters.' },
                { icon = 40419, name = 'Mana Essence', color = '#77aaff', description = 'Drops from [Arcane] elite monsters.' },
                { icon = 40421, name = 'Fire Essence', color = '#ff8844', description = 'Drops from [Burning] elite monsters.' },
                { icon = 40422, name = 'Pure Essence', color = '#ffffaa', description = 'Drops from [Sacred] elite monsters - the rarest drop.' },
                { icon = 40423, name = 'Ice Essence', color = '#99ddff', description = 'Drops from [Frostbound] elite monsters.' },
                { icon = 40424, name = 'Dark Essence', color = '#aa66cc', description = 'Drops from [Darkness] elite monsters.' },
                { icon = 40425, name = 'Earth Essence', color = '#aadd66', description = 'Drops from [Plagued] elite monsters.' },
                { icon = 40420, name = 'Spirit Essence', color = '#dddddd', description = 'Never drops - only obtainable through Refinement crafting.' },
              }},
              { type = 'tip', content = 'Each elite variation kill also yields a **Guardian Essence** on top of its elemental drop - two birds, one hunt.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Refinement & Transmutation', color = '#ff9e5e' },
              { type = 'text', content = 'The Alchemy profession can **fuse essences into other essences** (Refinement recipes): combine a Monster Essence with two elemental essences to produce the one you are missing. This is the only way to obtain **Spirit Essence**, and **Pure Essence** can be fused too if you have a Guardian Essence to spare.' },
              { type = 'text', content = '**Transmutation** goes the other way: it converts essences into consumables - **Life** becomes health potions, **Mana** becomes mana potions and **Spirit** becomes hybrid potions, in stacks. Higher-tier transmutations produce the powerful versions and even combat runes.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Gathering Professions', color = '#ccaa77' },
              { type = 'warning', content = 'Gathering nodes are temporarily disabled while the system is being reworked - profession levels and their passive bonuses still apply.' },
              { type = 'cards', items = {
                { icon = 40035, name = 'Mining', color = '#aaaaaa', description = 'Ore veins spawn in the world - copper first, then silver, gold, platinum and mythril as your skill rises. Each level grants HP passives.' },
                { icon = 39096, name = 'Herbalism', color = '#88cc66', description = 'Herb nodes yield plants for alchemy. Grants mana passives per level.' },
                { icon = 37763, name = 'Woodcutting', color = '#cc8844', description = 'Chop tree nodes for wood materials. Grants attack speed per level.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Enchanting Supplies', color = '#cc99ff' },
              { type = 'cards', items = {
                { icon = 13215, name = 'Arcane Powder', color = '#cc99ff', description = 'Main enchanting dust - also needed to craft Orbs of Performance.' },
                { icon = 13197, name = 'Mystic Powder', color = '#aa88dd', description = 'Higher-grade powder used by advanced augment recipes.' },
                { icon = 29020, name = 'Enchanting Powder', color = '#ddbbff', description = 'Base powder for rune crafting.' },
                { icon = 33201, name = 'Crystal Essences', color = '#77ddff', description = 'Five colors - blue, green, purple, red and yellow. Rare drops used in crystal recipes.' },
                { icon = 35377, name = 'Empty Enchanting Runes', color = '#ffff88', description = 'Blank rune stones - the base item every crafted rune starts from.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Disenchanting (Enchanters Rod)', color = '#ddbbff' },
              { type = 'text', content = 'The **Enchanters Rod** destroys an item to salvage materials from it. What you get depends on what you disenchant - and every disenchant grants **Enchanting experience**.' },
              { type = 'cards', items = {
                { icon = 7735, name = 'Rarity Items', color = '#cc99ff', description = 'Disenchant **Orbital**, **Forged** or **unique** items for Arcane Powder (common), Mystic Powder and colored Crystal Essences. Higher rarity multiplies every drop chance - uniques pay out the most. Common items cannot be disenchanted.' },
                { icon = 26170, name = 'Prismatic Cubes', color = '#77ddff', description = 'Cubes do not give powders - disenchanting one yields **Empty Enchanting Runes** instead, the raw material for rune crafting.' },
              }},
              { type = 'text', content = 'There are **three cube recipes**, each hiding a different rune pool: the basic cube (Arcane Powder) drops **Pelagos** and **Magellan** runes, the mid cube (Arcane + Mystic) drops **Elysium** and **Eldric**, and the high cube (Mystic Powder) drops **Solstice** and **Euphoria**.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Alchemy Ingredients', color = '#77ff77' },
              { type = 'cards', items = {
                { icon = 39093, name = 'Rough Leather', color = '#ccaa77', description = 'Blue orb drop - alchemy and gear recipes.' },
                { icon = 39094, name = 'Ember & Fire Leaf', color = '#ff8844', description = 'Blue orb drops - fire-themed alchemy ingredients.' },
                { icon = 39161, name = 'Valuable Pouches', color = '#ffd75e', description = 'Blue orb drop - salvage into extra materials.' },
              }},
              { type = 'divider' },
              { type = 'tip', content = 'Keep blue orb farming in mind while hunting - a couple of orbs often covers an entire craft.' },
            }
          },
        }
      },

      prestige = {
        name = 'Prestige Modes',
        subcategories = {
          overview = {
            name = 'Prestige Guide',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'PRESTIGE CHALLENGES', color = '#ffd75e' },
              { type = 'text', content = 'Prestige resets your character for a challenge run with permanent rewards. Your [color=#ffd700]pets, codex, achievements and blueprints are preserved[/color] across every prestige.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'The Modes', color = '#66aaff' },
              { type = 'cards', items = {
                { image = '/images/icons/repeat.png', name = 'Prestige Normal', color = '#77ff77',
                  description = 'Requires level 300. Resets to level 8 with [color=#ffd700]+20% exp[/color]. Reach 300 again to complete: 50k gold + 5k fame + 5k codex.' },
                { image = '/images/icons/skull.png', name = 'Hardcore', color = '#ff4444',
                  description = 'Start at level 10 or lower, reset to 1. [color=#ff8888]ONE LIFE - death deletes the character.[/color] Goal: level 200. Reward: 100k gold + 10k fame + 15k codex.' },
                { image = '/images/icons/treasure.png', name = 'High Risk', color = '#ffaa55',
                  description = 'Start at 10 or lower, reset to 1. +15% exp, bonus loot rolls, +20% blue orb chance. But death drops your backpack + 1 equipped item in a chest AND costs 2x exp loss. Goal: 300. Reward: 50k + 5k + 7.5k codex (paid on start).' },
                { image = '/images/icons/shield-divided-four_16769380.png', name = 'Iron Man', color = '#aaaaaa',
                  description = 'Start at 10 or lower, reset to 8. ONE LIFE + only weapon/shield slots allowed - all armor slots locked. Goal: 200. Reward: 150k + 12k fame + 10k codex.' },
                { image = '/images/icons/flame.png', name = 'Nightmare I', color = '#cc66ff',
                  description = 'Start at 10 or lower, account needs a level 100+ char. +80% damage taken. Goal: 300. Reward: 75k + 7.5k + 10k codex.' },
                { image = '/images/icons/flame.png', name = 'Nightmare II', color = '#aa44dd',
                  description = '+100% damage taken, -30% damage dealt. Goal: 300. Reward: 150k + 12k + 20k codex.' },
                { image = '/images/icons/flame.png', name = 'Nightmare III', color = '#8811cc',
                  description = '+120% damage taken, -50% damage dealt, [color=#ff8888]ONE LIFE.[/color] Goal: 300. Reward: 250k + 20k + 30k codex.' },
              }},
              { type = 'warning', content = 'Hardcore, Iron Man and Nightmare III are one-life modes: a single death permanently deletes the character. Choose carefully!' },
            }
          },
        }
      },

      codex = {
        name = 'Codex',
        subcategories = {
          collection = {
            name = 'Collection',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'Codex Collection' },
              { type = 'divider' },
              { type = 'text', content = 'The Codex is a card collection system: monsters drop **cards and crates** that feed your Deck with passive and triggered bonuses. There are **104 unique cards** to collect.' },
              { type = 'image', path = '/images/wiki/codex_overview.png', width = 400, height = 267 },
              { type = 'spacer', height = 8 },
              { type = 'subtitle', text = 'Card Rarities' },
              { type = 'cards', items = {
                { image = '/images/ui/rarity_white.png', name = 'Common', color = '#dfdfdf', description = 'Basic effects - the easiest cards to obtain.' },
                { image = '/images/ui/rarity_blue.png', name = 'Rare', color = '#58a6ff', description = 'Stronger effects, moderate drop rate.' },
                { image = '/images/ui/rarity_purple.png', name = 'Epic', color = '#c678dd', description = 'Powerful, build-enabling effects.' },
                { image = '/images/ui/rarity_yellow.png', name = 'Legendary', color = '#ffa940', description = 'Game-changing effects, hardest to roll.' },
              }},
              { type = 'image', path = '/images/wiki/codex_card_rarities.png', width = 400, height = 200 },
              { type = 'spacer', height = 8 },
              { type = 'subtitle', text = 'Duplicates & EXP' },
              { type = 'text', content = 'Duplicate cards grant EXP to the card you own - **Common 100 / Rare 200 / Epic 300 / Legendary 500** EXP. If the card is already at the max level for its crate tier, duplicates convert into **Codex Essences** instead.' },
              { type = 'subtitle', text = 'Trigger Types' },
              { type = 'text', content = 'Cards activate on different conditions - shown on each card tooltip: **Passive** (always on), **On Kill**, **On Heal**, **On Spell**, **On Attack Spell**, **On Healing Spell**, **On Party Heal**, **On Crit**, **On Low HP**, **On Death**, **On Dash**, **On Shield** and **On Think** (periodic).' },
              { type = 'image', path = '/images/wiki/codex_trigger_examples.png', width = 330, height = 200 },
            }
          },
          deck = {
            name = 'Deck',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'Your Deck' },
              { type = 'divider' },
              { type = 'text', content = 'Cards only work while **equipped** in your Deck. You get **6 slots**, unlocked progressively:' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Slots 1-3', description = 'Slot 1 free - Slot 2 at **Level 80** - Slot 3 at **Level 150**.' },
                { image = '/images/icons/fame.png', name = 'Slots 4-5', description = 'Unlock at **Paragon Level 1** and **Paragon Level 50**.' },
                { image = '/images/icons/crown.png', name = 'Slot 6', description = '**Premium account** only.' },
                { image = '/images/codex/essence_icon.png', name = 'Early Unlock', description = 'Unlock the next slot early with essences: **500, then doubles each time** (1000, 2000...).' },
              }},
              { type = 'warning', content = 'Cards sitting in your Collection give **no bonus** - equip them in the Deck tab.' },
              { type = 'subtitle', text = 'Building a Deck' },
              { type = 'text', content = [[**DPS:** Critical Surge, The Witch, Glass Cannon, The Dragon, Guns Lover, The Gunner, Svarog, Zeus
**Tank/Survival:** Golem, The Phoenix, The Behemoth, The Slime, Water Elemental, Soul Leech
**Healer:** Undine, The Elf, Archangel, Blood Link, Blossom Dragon, The Naga
**Utility:** Executioner (cooldown), Essence Reaver (essence farm), The Child (EXP), Carnage Presence]] },
              { type = 'tip', content = 'Dragon cards synergize with Dragon Lord. Healer cards like Blood Link only trigger when healing **party members**.' },
            }
          },
          crates = {
            name = 'Crates',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'title', text = 'Card Crates' },
              { type = 'divider' },
              { type = 'text', content = 'Craft crates in the Crates tab with **Codex Essences**, or loot them from monsters and elites. Higher crates roll better rarities and higher card levels.' },
              { type = 'cards', items = {
                { image = '/images/codex/bronzecrate.png', name = 'Bronze Crate - 100 essences', color = '#cd7f32', description = 'Cards up to **level 2**. Common 70% / Rare 20% / Epic 8% / Legendary 2%. 25% chance of +50 bonus essences.' },
                { image = '/images/codex/silver-crate.png', name = 'Silver Crate - 200 essences', color = '#c0c0c0', description = 'Cards up to **level 3**. Common 60% / Rare 25% / Epic 10% / Legendary 5%. 30% chance of +80 bonus essences.' },
                { image = '/images/codex/golden-crate.png', name = 'Golden Crate - 350 essences', color = '#ffd75e', description = 'Cards up to **level 5**. Common 30% / Rare 30% / Epic 30% / Legendary 10%. 35% chance of +120 bonus essences.' },
              }},
              { type = 'image', path = '/images/wiki/codex_crates.png', width = 400, height = 267 },
              { type = 'spacer', height = 8 },
              { type = 'tip', content = 'You get **1 free Bronze Crate every 15 character levels**. Task Board offers also roll crates - Legendary tasks can drop any tier.' },
            }
          },
          upgrade = {
            name = 'Upgrade',
            type = 'rich_text',
            order = 4,
            sections = {
              { type = 'title', text = 'Upgrading Cards' },
              { type = 'divider' },
              { type = 'text', content = 'Spend **Codex Essences** in the Upgrade tab to push a card toward its next level - **1 essence = 10 card EXP**. Max level is **10** (crate-rolled cards may start capped lower).' },
              { type = 'image', path = '/images/wiki/codex_level_comparison.png', width = 380, height = 238 },
              { type = 'spacer', height = 8 },
              { type = 'subtitle', text = 'Essence Sources' },
              { type = 'cards', items = {
                { image = '/images/codex/essence_icon.png', name = 'Farming', description = 'Monster and elite kills, crate bonus rolls, task rewards.' },
                { image = '/images/icons/repeat.png', name = 'Max-Level Duplicates', description = 'Dupes of crate-maxed cards convert straight into essences.' },
                { image = '/images/icons/icon_magic.png', name = 'Knowledge Potion', description = '+50% essence gain while the potion buff is active.' },
              }},
              { type = 'tip', content = 'Farm lower-tier crates for essence income - maxed common cards turn every duplicate into essences.' },
            }
          },
        }
      },

      achievements = {
        name = 'Achievements',
        subcategories = {
          overview = {
            name = 'Achievements Guide',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'ACHIEVEMENTS', color = '#ffd75e' },
              { type = 'text', content = 'Over [color=#ffd700]215 achievements[/color] reward achievement points, titles and items. Progress is preserved through prestige.' },
              { type = 'divider' },
              { type = 'subtitle', text = 'Categories', color = '#66aaff' },
              { type = 'text', content = '**Combat** - kills, bosses, crits\n**Tasks & Daily** - task board and daily completions\n**Crafting & Professions** - recipes and profession levels\n**Gathering** - herb/vein/tree/pool nodes\n**Pets** - collecting and leveling\n**Codex** - cards, crates, deck milestones\n**Dungeons** - clears and mutator runs\n**Paragon / Prestige** - end-game milestones\n**Proficiency** - trait unlocks\n**Exploration & Social** - map discovery, guild, party\n**Skills, Collection, Capture, Forge, Special**' },
              { type = 'tip', content = 'Achievement points count toward titles and milestone rewards - check the Achievements window for progress and claim buttons.' },
            }
          },
        }
      },
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
            order = 1,
            items = {
              {
                name = 'boots of teleportation',
                description = '[onUse] Teleport to your targeted position.',
                icon = 29188
              },
              {
                name = 'boots of the wild',
                description = '[onUse] Charge to your current targeted enemy.',
                icon = 29269
              },
              {
                name = 'boots of timewalking',
                description = '[onUse] Mark your current self and rewind to it after 4 seconds.',
                icon = 29299
              },
              {
                name = 'boots of winter',
                description = '[onUse] Place ice traps on the ground while moving that will slow down the enemies.',
                icon = 3551
              },
              {
                name = 'boots of levitation',
                description = '[onUse] Levitate into the air removing all paralysed effects and dashing towards the direction you are facing.',
                icon = 29249
              },
              {
                name = 'boots of the void',
                description = '[onUse] Instantly trap all nearby enemies in a void field.',
                icon = 27379
              },
              {
                name = 'boots of the salamander',
                description = '[onUse] Place fire pillars in your targeted position wich can block line of sight.',
                icon = 9019
              },
              {
                name = 'boots of the dreamer',
                description = '[onUse] Restore 15% maximum mana of all nearby friendly players.',
                icon = 6529
              },
              {
                name = 'magnetic orb',
                description = 'place a magnetic orb to create a magnetic field that damages nearby enemies',
                icon = 34086
              },
              {
                name = 'celestial sigil',
                description = 'Shoots a celestial mark into the targeted position wich deals damage and increases your magic level percent by 20% for 4 seconds',
                icon = 34068
              },
              {
                name = 'absolute defense',
                description = 'increase your block chance by 50% and max health by 30% for the next 8 seconds. (requires a shield equiped)',
                icon = 34096
              },
              {
                name = 'bouncing sphere',
                description = 'create a bouncing sphere that bounces between you and your target dealing damage and healing yourself, the sphere speed is based on the distance between you and your target',
                icon = 34088
              },
              {
                name = 'earthquake',
                description = 'break the ground dealing physical damage to all enemies and stun them for a short period of time',
                icon = 34087
              },
              {
                name = 'blessed tree',
                description = 'create a blessed tree in the targeted position, wich restores health and mana to all nearby players if destroyed.',
                icon = 34076
              },
              {
                name = 'spider web',
                description = 'throw a spider web on your target wich stuns it for 2 seconds.',
                icon = 34084
              },
              {
                name = 'meteor',
                description = 'throw a meteor on your targeted position dealing fire damage to nearby enemies.',
                icon = 34071
              },
              {
                name = 'water wave',
                description = 'create 3 water tides wich deal ice damage and stun the enemies for 1 second.',
                icon = 34113
              },
              {
                name = 'thunder chain',
                description = 'create a energy chain reaction will travel through all nearby enemies.',
                icon = 34072
              },
              {
                name = 'water torrent',
                description = 'create a water torrent wich repell enemies around yourself.',
                icon = 34097
              },
              {
                name = 'shark teeth',
                description = 'create a dangerous area wich later will be devoured by a giant shark.',
                icon = 29924
              },
              {
                name = 'wild vines',
                description = 'create wild vines around yourself that pulls nearby monsters into you.',
                icon = 34107
              },
              {
                name = 'quick chains',
                description = 'send quick chains in the direction aimed and pull in the first enemy reached into you.',
                icon = 34075
              },
              {
                name = 'boomerang',
                description = 'Throw a magical boomerang that deals damage in a straight line and returns to you.',
                icon = 34121
              },
              {
                name = 'wild spikes',
                description = 'Unleash two wild spikes in front of you, healing yourself and dealing damage to the target.',
                icon = 29916
              },
              {
                name = 'sniper shot',
                description = 'A precise, long-range attack that deals damage based on the distance traveled.',
                icon = 29936
              },
              {
                name = 'thunder leap',
                description = 'leap into your targeted position dealing damage and stuning nearby enemies for 1 second.',
                icon = 34109
              },
              {
                name = 'chain of flames',
                description = 'create a fire chain reaction will travel through all nearby enemies.',
                icon = 34077
              },
              {
                name = 'toxic spores',
                description = 'emanate toxic spores poisoning all nearby enemies for 8 seconds.',
                icon = 29998
              },
              {
                name = 'final sentence',
                description = 'Setence your target dealing massive holy damage in a small area increasing its damage based on the target\'s missing health.',
                icon = 29917
              },
              {
                name = 'healing prisma',
                description = 'Heals you and nearby allies in a wider area',
                icon = 34110
              },
              {
                name = 'fire tornado',
                description = 'Summon a raging fire tornado that repeatedly burns enemies in an area and slows their movement.',
                icon = 34098
              },
              {
                name = 'opelus',
                description = 'Unleash repeated bursts of energy damage at a target location, striking all enemies in the area multiple times.',
                icon = 34081
              },
              {
                name = 'voltstorm',
                description = 'Unleash a storm of constant energy damage at your targeted location, striking all enemies in the area multiple times.',
                icon = 34101
              },
              {
                name = 'blood aura',
                description = 'wield a blood aura draining life force from all nearby enemies.',
                icon = 29918
              },
              {
                name = 'arcane missiles',
                description = 'Fire 5 arcane missiles that seek random enemies in a 7x7 area, dealing energy damage.',
                icon = 34073
              },
              {
                name = 'lightning rod',
                description = 'Place a lightning rod that strikes nearby enemies with chain lightning every second for 6 seconds.',
                icon = 34074
              },
              {
                name = 'phase shift',
                description = 'Become intangible for 2 seconds. You cannot attack or be attacked during this time.',
                icon = 19369
              },
              {
                name = 'rejuvenation',
                description = 'Regenerate 5% of your maximum health per second for 10 seconds, healing 50% total.',
                icon = 34094
              },
              {
                name = 'last stand',
                description = 'When your health drops below 15%, automatically heal 30% of your maximum health. 120 second cooldown.',
                icon = 34125
              },
              {
                name = 'mana battery',
                description = 'Convert 20% of your current health into 30% of your maximum mana.',
                icon = 34124
              },
              {
                name = 'soul reaper',
                description = 'Every time you kill an enemy within the next 10 seconds, you deal death damage in a small area and restore 8% of your health and mana.',
                icon = 34106
              },
              {
                name = 'frost nova',
                description = 'Freeze the ground in a 5x5 area for 8 seconds. Enemies entering are slowed by 70% for 2 seconds.',
                icon = 34111
              }
            }
          },
          runes = {
            name = 'Runas',
            type = 'list',
            order = 2,
            items = {
              {
                name = 'Runa de Curacion Suprema',
                description = 'Restaura una gran cantidad de HP',
                icon = 2273
              },
              {
                name = 'Runa de Gran Bola de Fuego',
                description = 'Crea una bola de fuego masiva',
                icon = 2304
              },
              {
                name = 'Runa de ParAlisis',
                description = 'Paraliza al objetivo',
                icon = 2278
              }
            }
          },
          sample = {
            name = 'Categoria de Muestra 1',
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
            name = 'Categoria de Muestra 2',
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
                description = 'Anade dano de fuego a tu arma (+15% dano de fuego)',
                icon = 2392
              },
              {
                name = 'Encantamiento de Hielo',
                description = 'Anade dano de hielo a tu arma (+15% dano de hielo)',
                icon = 2393
              },
              {
                name = 'Encantamiento Sagrado',
                description = 'Anade dano sagrado a tu arma (+15% dano sagrado)',
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
                name = 'Piedra de Mazmorra Demoniaca',
                description = 'Teletransporta a la Mazmorra Demoniaca. Nivel requerido: 150',
                icon = 1950
              },
              {
                name = 'Piedra de Guarida del Dragon',
                description = 'Teletransporta a la Guarida del Dragon. Nivel requerido: 100',
                icon = 1951
              },
              {
                name = 'Piedra de Cripta Vampirica',
                description = 'Teletransporta a la Cripta Vampirica. Nivel requerido: 80',
                icon = 1952
              }
            }
          },
          bosses = {
            name = 'Informacion de Jefes',
            type = 'list',
            items = {
              {
                name = 'Senor Demonio',
                description = 'HP: 50,000 | Ubicacion: Mazmorra Demoniaca | Drops: Armadura Demoniaca',
                icon = 5080
              },
              {
                name = 'Dragon Ancestral',
                description = 'HP: 35,000 | Ubicacion: Guarida del Dragon | Drops: Armadura de Escamas',
                icon = 5081
              },
              {
                name = 'Principe Vampiro',
                description = 'HP: 25,000 | Ubicacion: Cripta Vampirica | Drops: Escudo Vampirico',
                icon = 5082
              }
            }
          }
        }
      },
      daily_tasks = {
        name = 'Misiones Diarias',
        subcategories = {
          overview = {
            name = 'Como Funcionan las Misiones Diarias',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'text', content = [[**Que son las Misiones Diarias?**

Las Misiones Diarias son 8 tareas que se reinician cada dia, dandote objetivos y recompensas consistentes. Abre la ventana de Misiones Diarias usando el objeto especial (Daily Task Scroll) para ver tus tareas activas, seguir tu progreso y reclamar recompensas.

Las tareas se sortean automaticamente cada dia con dificultad ponderada: Facil (34%), Media (33%) y Dificil (33%).]] },
              { type = 'image', path = '/images/wiki/daily_tasks_overview.png', width = 400, height = 220 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Categorias de Tareas**

| Categoria | Descripcion | Tipo |
|-----------|-------------|------|
| Kill Zone | Mata monstruos en zonas non-PvP, PvP o PvP-forzado | Auto |
| Boss | Derrota bosses (cualquiera o especifico) | Auto |
| Dungeon | Completa mazmorras | Auto |
| Zone Event | Completa eventos de zona | Auto |
| Tower Floor | Limpia pisos de la Torre de Dios | Auto |
| Kill Task | Completa tareas de matar del tablero | Auto |
| Crafting | Entrega items crafteados (Alquimia, Encantamiento, Herreria) | Entregar |
| Gathering | Entrega esencias recolectadas de mineria | Entregar |
| Mixed | Combina multiples actividades (kills + torre, bosses + mazmorras + eventos) | Auto |

Las tareas de **progreso automatico** se actualizan automaticamente mientras juegas.
Las tareas de **entrega** requieren que tengas los items en tu inventario y hagas clic en el boton "Entregar".]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Recompensas**

**Por Tarea Completada:**
- **3 Puntos de Logro**
- **25 Esencias de Codex**

**Recompensa Diaria Grande (4 completadas):**
- **1 Caja Dorada de Codex**

La Caja Dorada se puede reclamar una vez al dia despues de completar al menos 4 tareas. Asegurate de reclamarla antes del reinicio diario!]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Niveles de Tareas de Crafting**

Las tareas de crafting escalan con los niveles de profesion:

**Alquimia:**
- Aprendiz: Esencias refinadas, pociones basicas
- Novicio: Pociones de salud/mana/espiritu, viales pequenos
- Oficial: Pociones fuertes, viales y elixires de nivel medio
- Maestro: Grandes pociones
- Gran Maestro: Grandes pociones encantadas

**Encantamiento (Runesmith):**
- Aprendiz: Runas Tier 1
- Oficial: Runas Tier 3
- Adepto: Runas Tier 4
- Maestro: Runas Tier 5 (dos sub-lineas)
- Gran: Runas Tier 6 (maximo nivel)
- Especialista en Planos: Crafteos raros de planos

**Herreria:**
- Aprendiz: Armas iniciales y escudos
- Oficial: Equipo de combate basico (espadas 1M, armas 2M, a distancia, escudos)

**Refineria (Gadgets):**
- Items de utilidad hechos de madera y metales: vendas y armas de entrenamiento en niveles bajos; senuelos, piedras de afilar, bombas de pegamento y carpas en niveles medios; baston de madera viva, gancho de agarre, espada boomerang y deposito portatil en niveles altos
- El nivel de Refineria aumenta directamente el dano y curacion de los gadgets

**Leñador (Woodcutting):**
- Profesion de recoleccion que alimenta a Refineria: corta arboles para obtener troncos, refinalos en tablones y gana +1% de velocidad de ataque por nivel]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Consejos**

- Prioriza las tareas faciles primero para completarlas rapido
- Guarda las tareas dificiles para cuando ya estes corriendo mazmorras o eventos
- Manten items crafteados en tu storage para entregar tareas de crafting rapidamente
- Las tareas Mixtas cuentan multiples actividades a la vez - muy eficientes
- El reinicio diario ocurre segun la hora local del servidor - planifica en consecuencia
- Siempre reclama tu Caja Dorada antes de que termine el dia]] }
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
            content = 'Los puntos de fama se ganan completando misiones y derrotando jefes.\n\nUsos:\na Comprar objetos exclusivos en tiendas NPC\na Desbloquear Areas especiales\na Comprar objetos cosmA(c)ticos\n\nComo ganar:\na Misiones diarias: 10-50 fama\na Matar jefes: 100-500 fama\na Eventos: varia'
          },
          valuable_pouches = {
            name = 'Bolsas Valiosas',
            type = 'list',
            items = {
              {
                name = 'Bolsa de Bronce',
                description = 'Contiene 100-500 oro. Drop comAon de monstruos.',
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
      tasks = {
        name = 'Sistema de Tareas',
        subcategories = {
          overview = {
            name = 'Como Funcionan las Tareas',
            type = 'text',
            order = 1,
            content = 'El Sistema de Tareas es un tablero de misiones dinAmico donde cazas monstruos por recompensas.\n\n**Como Funciona:**\n- Tienes 3 slots de tareas disponibles\n- Cada tarea requiere matar monstruos especificos\n- Completa tareas para ganar oro, fama y experiencia\n- Las tareas tienen diferentes niveles: Normal, Rara, Apica, Legendaria\n- Cada tarea tiene modificadores que afectan dificultad y recompensas\n\n**Comenzando:**\n1. Abre el Tablero de Tareas (Ctrl+T o click en boton Tasks)\n2. Elige una tarea de los 3 slots disponibles\n3. Click "Start" para activar la tarea\n4. Caza los monstruos requeridos\n5. Regresa y click "Complete" para reclamar recompensas\n\n**Importante:**\n- Solo puedes tener 1 tarea activa a la vez\n- Las tareas muestran outfits de monstruos para saber quA(c) cazar\n- Los rangos de nivel te ayudan a encontrar zonas apropiadas\n- Puedes abandonar una tarea, pero pierdes todo el progreso'
          },
          rerolls = {
            name = 'Sistema de Rerolls',
            type = 'text',
            order = 4,
            content = 'Los Rerolls te permiten refrescar los 3 slots de tareas para obtener nuevas opciones.\n\n**Rerolls Gratis:**\n- Base: 5 rerolls gratis por dia\n- Bono Premium: +5 rerolls extra (10 total)\n- Bono Fama: +1 reroll por cada 5 niveles de fama\n- Reinicio Diario: Se reinicia cada 24 horas\n\n**Rerolls Pagados:**\n- Costo: 20 oro por reroll\n- Uso ilimitado (si tienes oro)\n- Asalos cuando se acaben los gratis\n\n**Rerolls Bonus:**\n- Tareas Raras: 25% chance de +1 reroll de recompensa\n- Tareas Apicas: 40% chance de +1 reroll de recompensa\n- Tareas Legendarias: +1-2 rerolls garantizados\n- Estos se acumulan con tus rerolls diarios\n\n**Tips de Estrategia:**\n- Guarda rerolls gratis para cuando necesites mejores tareas\n- Bloquea buenas tareas antes de hacer reroll\n- Mayor fama = mAs rerolls gratis'
          },
          locks = {
            name = 'Sistema de Bloqueos',
            type = 'text',
            order = 5,
            content = 'Los Bloqueos protegen tareas de ser rerolleadas, permitiendo mantener buenas tareas mientras refrescas otras.\n\n**Bloqueos Gratis:**\n- Base: 3 bloqueos gratis por dia\n- Bono Premium: +5 bloqueos extra (8 total)\n- Reinicio Diario: Se reinicia cada 24 horas\n\n**Bloqueos Pagados:**\n- Costo: 10 oro por bloqueo\n- Uso ilimitado (si tienes oro)\n- Asalos cuando se acaben los gratis\n\n**Bloqueos Bonus:**\n- Tareas Apicas: 30% chance de +1 bloqueo de recompensa\n- Tareas Legendarias: +1-2 bloqueos garantizados\n- Estos se acumulan con tus bloqueos diarios\n\n**Como Usar:**\n1. Encuentra una tarea que quieras mantener\n2. Click en el boton "Lock" en esa tarea\n3. Haz reroll de otras tareas sin perder la bloqueada\n4. Click "Unlock" para remover el bloqueo\n\n**Tips de Estrategia:**\n- Bloquea tareas de alto nivel (Apica/Legendaria)\n- Bloquea tareas con buenos modificadores\n- Jugadores premium obtienen significativamente mAs bloqueos'
          },
          tiers = {
            name = 'Niveles y Rareza de Tareas',
            type = 'text',
            order = 2,
            content = 'Las tareas vienen en 4 niveles con diferentes tasas de aparicion y multiplicadores de recompensa.\n\n**Normal (60% tasa de aparicion)**\n- Multiplicador de Recompensa: 1.0x\n- Modificadores: 0-1\n- Tareas comunes, recompensas base\n\n**Rara (25% tasa de aparicion)**\n- Multiplicador de Recompensa: 1.25x\n- Modificadores: 1-2\n- 25% bonus de recompensas\n- 25% chance de +1 reroll bonus\n\n**Apica (10% tasa de aparicion)**\n- Multiplicador de Recompensa: 1.5x\n- Modificadores: 2-3\n- 50% bonus de recompensas\n- 40% chance de +1 reroll\n- 30% chance de +1 bloqueo\n- Desbloqueada en Nivel de Fama 8\n\n**Legendaria (5% tasa de aparicion)**\n- Multiplicador de Recompensa: 2.0x\n- Modificadores: 3 (siempre)\n- 100% bonus de recompensas\n- +1-2 rerolls bonus garantizados\n- +1-2 bloqueos bonus garantizados\n- Extremadamente rara, recompensas mAximas\n\n**Desbloqueos de Nivel:**\n- Normal, Rara: Disponibles desde el inicio\n- Apica: Requiere Nivel de Fama 8\n- Legendaria: Siempre disponible (si tienes suerte)'
          },
          rewards = {
            name = 'Recompensas y Bonificaciones',
            type = 'text',
            order = 3,
            content = 'Las tareas te recompensan basAndose en mAoltiples factores que se acumulan.\n\n**Recompensas Base (del rango de nivel):**\n- Oro, Fama y Experiencia escalan con el nivel del monstruo\n- Tareas de mayor nivel = recompensas base mAs altas\n\n**Multiplicadores de Recompensa:**\n\n1. **Multiplicador de Nivel:**\n   - Normal: 1.0x\n   - Rara: 1.25x\n   - Apica: 1.5x\n   - Legendaria: 2.0x\n\n2. **Bonus por Cantidad de Monstruos:**\n   - 1 monstruo: 1.0x\n   - 2 monstruos: 1.15x (+15%)\n   - 3 monstruos: 1.30x (+30%)\n\n3. **Bonus por Modificadores:**\n   - Modificador negativo: +15% por modificador\n   - Modificador mixto: +10% por modificador\n   - Tareas mAs dificiles = mejores recompensas\n\n4. **Bonus por Kills (NUEVO):**\n   - +5% por cada 50 kills (hasta +25% mAx)\n   - 50 kills: +5%\n   - 100 kills: +10%\n   - 150 kills: +15%\n   - 200 kills: +20%\n   - 250+ kills: +25% (limite)\n\n**Formula Final:**\nRecompensa = Base A- Nivel A- CantidadMonstruos A- (1 + BonusMod) A- BonusKills\n\n**Ejemplo:**\n- Base: 1000 oro\n- Nivel Raro: 1.25x\n- 2 monstruos: 1.15x\n- 1 mod negativo: 1.15x\n- 150 kills: 1.15x\n= 1,913 oro\n\n**Cada Tarea Muestra 2 Recompensas Aleatorias:**\n- Oro, Fama, Experiencia, Rerolls Bonus, o Bloqueos Bonus'
          },
          fame_premium = {
            name = 'Beneficios de Fama y Premium',
            type = 'text',
            order = 6,
            content = 'Tu Nivel de Fama y estado Premium proporcionan bonos permanentes.\n\n**Bonos de Nivel de Fama:**\n\n- **Nivel 3 - Cazador Experimentado:**\n  Tasa de aparicion de nivel Raro +5%\n\n- **Nivel 5 - Cazador Veterano:**\n  Modificadores negativos reducidos en 15%\n\n- **Nivel 7 - Cazador Alite:**\n  +1 reroll gratis por dia\n\n- **Nivel 8 - Cazador Maestro:**\n  Desbloquea tareas de nivel Apico\n\n- **Nivel 10 - Cazador Legendario:**\n  +5% bonus a todas las recompensas\n\n**Como Ganar Fama:**\n- Completa tareas para ganar puntos de fama\n- Tareas de mayor nivel dan mAs fama\n- La fama se acumula y nunca se reinicia\n- Revisa tu nivel de fama en el Tablero de Tareas\n\n**Beneficios de Cuenta Premium:**\n\n- **Rerolls Gratis:**\n  +5 extra por dia (10 total vs 5 gratis)\n\n- **Bloqueos Gratis:**\n  +5 extra por dia (8 total vs 3 gratis)\n\n- **Mejor Eficiencia:**\n  Bloquea mAs tareas mientras haces reroll\n  MAs flexibilidad en seleccion de tareas\n\n**Poder Combinado:**\nPremium + Nivel de Fama 10:\n- 10+ rerolls gratis por dia\n- 8 bloqueos gratis por dia\n- +5% recompensas en todas las tareas\n- Nivel Apico desbloqueado\n- Mejores chances de modificadores\n\n**Estrategia:**\n- Los bonos de fama son permanentes - siempre vale la pena farmear\n- Premium da QoL masivo para gestion de tareas\n- Mayor fama = mejor generacion de tareas'
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
                name = 'BebA(c) Pesadilla',
                rarity = 'Apica',
                collector = 'Coleccionista Tenebroso',
                abilities = {
                  { name = 'Carga de Pesadilla', description = 'Se lanza hacia adelante causando dano y miedo' },
                  { name = 'Devorador de Suenos', description = 'Drena manA de enemigos y aumenta la regeneracion de manA del dueno un 10%' }
                }
              },
              {
                name = 'BebA(c) Prisma',
                rarity = 'Apica',
                collector = 'Coleccionista de Paleta',
                abilities = {
                  { name = 'Rayo Prisma', description = 'Dispara un rayo elemental aleatorio (fuego/hielo/energia)' },
                  { name = 'Escudo Prisma', description = 'Aumenta +8% todas las resistencias durante 10 segundos' }
                }
              },
              {
                name = 'Terroc',
                rarity = 'Apica',
                collector = 'Coleccionista Mitico',
                abilities = {
                  { name = 'Terremoto', description = 'Dano fisico en Area con 2s de aturdimiento' },
                  { name = 'Buff de Terror', description = '+10% probabilidad critica durante 10 segundos' }
                }
              },
              {
                name = 'Espectro',
                rarity = 'Apica',
                collector = 'Coleccionista Tenebroso',
                abilities = {
                  { name = 'Maldicion Espectral', description = 'Dano de muerte + reduce curacion un 50%' },
                  { name = 'Aparicion', description = '+15% dano de muerte durante 12 segundos' }
                }
              },
              {
                name = 'Lobo',
                rarity = 'Rara',
                collector = 'Coleccionista Salvaje',
                abilities = {
                  { name = 'Aullido', description = 'Miedo en Area + 10% velocidad de ataque' }
                }
              },
              {
                name = 'Conejo',
                rarity = 'Rara',
                collector = 'Coleccionista Chef',
                abilities = {
                  { name = 'Salto RApido', description = 'Se lanza hacia adelante con aumento de velocidad' }
                }
              },
              {
                name = 'BebA(c) FA(c)nix de Fuego',
                rarity = 'Rara',
                collector = 'Coleccionista Mitico',
                abilities = {
                  { name = 'Aura de Llamas', description = 'Dano de fuego en Area + 10% dano de fuego' }
                }
              },
              {
                name = 'BebA(c) FA(c)nix de Hielo',
                rarity = 'Rara',
                collector = 'Coleccionista Mitico',
                abilities = {
                  { name = 'Ola de Escarcha', description = 'Dano de hielo + ralentizacion + aumento de velocidad' }
                }
              },
              {
                name = 'Hada',
                rarity = 'Rara',
                collector = 'Coleccionista de Paleta',
                abilities = {
                  { name = 'Polvo de Hada', description = 'Cura al dueno 5% HP + HoT durante 8 segundos' }
                }
              },
              {
                name = 'Gato Blanco',
                rarity = 'ComAon',
                collector = 'Coleccionista de Paleta',
                abilities = {
                  { name = 'Pata de la Suerte', description = '+3% probabilidad de botin durante 10 segundos' }
                }
              },
              {
                name = 'Gato Negro',
                rarity = 'ComAon',
                collector = 'Coleccionista Tenebroso',
                abilities = {
                  { name = 'Garra de Sombra', description = 'Dano + reduce resistencia a la luz' }
                }
              }
            }
          }
        }
      },
      ascension_guide = {
        name = 'Guia de Ascension',
        subcategories = {
          getting_started = {
            name = 'Primeros Pasos',
            type = 'text',
            order = 1,
            content = 'Bienvenido a Ascension! Este servidor funciona estilo ARPG con varios sistemas de progresion.\n\n**Tus Prioridades:**\n1. Sube de nivel y completa Tasks v2.\n2. Recoge todo el botin. Usa el Stash System y el Quick Loot para organizar todo.\n3. No vendas los items basura al NPC! Usa el Recycler o el Upgrade System para extraer minerales y gemas.'
          },
          class_talents = {
            name = 'Talentos de Clase',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'text', content = [[**Que son los Talentos de Clase?**

Cada clase de personaje tiene su propio arbol de talentos unico con varias ramas que se especializan en dano, defensa o utilidad. Cada arbol contiene nodos que otorgan bonificaciones pasivas al subirlos de nivel. Los talentos se aplican automaticamente al iniciar sesion, asi que planifica tu build con cuidado!]] },
              { type = 'image', path = '/images/wiki/talents_overview.png', width = 400, height = 220 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Puntos de Talento**

- Ganas **1 punto de talento cada 8 niveles** de personaje
- Cada nivel de nodo cuesta **1 punto de talento**
- La mayoria de nodos tienen un **nivel maximo de 10**
- Los puntos no usados se pueden gastar en cualquier momento abriendo la ventana de Talentos]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Resetear Talentos**

Te equivocaste? Puedes resetear todo tu arbol y recuperar todos los puntos gastados.

- Costo base: **50 de oro por punto gastado**
- **Descuento Premium:** 25 de oro por punto (-50%)
- Todos los puntos gastados se **reembolsan**
- **Conservas** tus puntos totales ganados

Abre la ventana de talentos y haz clic en el boton Reset para ver el costo exacto.]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Clases Disponibles**

| Clase | Ramas |
|-------|-------|
| Magician | Fuego / Arcano / Escarcha |
| Templar | Sagrado / Castigo / Proteccion / Justicia |
| Nightblade | Sombra / Sangre / Asesinato |
| Dragonknight | Tierra / Dragon / Fuego / Elemental |
| Warlock | Demonologia / Maldiciones / Invocacion / Pacto de Sangre |
| Stellar | Cosmico / Celestial / Wand |
| Monk | Elementos / Tierra / Vida / Viento |
| Druid | Naturaleza / Espiritu / Hielo / Cambiaformas |
| Light Dancer | Luz / Velocidad / Soporte |]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Consejos**

- Haz que tus talentos hagan sinergia con tu equipo y estilo de juego
- Las builds de DPS deben enfocarse primero en ramas de dano
- Los Tanques deben priorizar salud y resistencias
- Los Healers deben aumentar su mana y la efectividad de curacion
- Algunos nodos desbloquean hechizos o habilidades especiales en ciertos niveles
- Puedes previsualizar todos los nodos antes de gastar puntos]] }
            }
          },
          paragon_ascension = {
            name = 'Ascension Paragon',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'text', content = [[**Que es Paragon?**

Paragon es el sistema de progresion End-Game que se desbloquea al alcanzar **Nivel de Personaje 300**. Despues de llegar a este limite, la XP que ganas comienza a llenar tu barra de Paragon en lugar de subir de nivel. Cada nivel de Paragon otorga un punto para gastar en una de tres categorias de estadisticas, rotando automaticamente entre ellas.

Abre la pestana Ascension en la ventana de Talentos de Clase para ver tu tablero de Paragon, asignar puntos y seguir tu progreso.]] },
              { type = 'image', path = '/images/wiki/paragon_overview.png', width = 400, height = 220 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Como funciona la XP de Paragon**

- XP base para Nivel de Paragon 1: **6,000,000**
- Cada nivel siguiente cuesta **+12% mas XP** que el anterior
- **Bonificacion Premium:** +15% de XP de Paragon
- **Token de Boost:** +25% de XP de Paragon (buff consumible)
- **Penalizacion por Muerte:** Pierdes 10% del progreso actual de XP de Paragon
- Notificacion broadcast cada 10 niveles de Paragon

La XP de Paragon se gana de las mismas fuentes que la XP normal (matar monstruos, quests, etc.) una vez que estas en nivel maximo.]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Asignacion de Puntos y Rotacion**

Los puntos rotan automaticamente entre categorias al subir de nivel:

- **Paragon Niv 1, 4, 7...** -> **Primario** (Ataque)
- **Paragon Niv 2, 5, 8...** -> **Secundario** (Defensa)
- **Paragon Niv 3, 6, 9...** -> **Utilidad** (Progresion)

Puedes gastar los puntos ganados en cualquier momento. Los puntos no expiran. Abre la pestana Ascension para asignarlos a estadisticas especificas.]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Estadisticas Primarias (Ataque)**

| Estadistica | Por Punto | Limite |
|-------------|-----------|--------|
| Dano Fisico | +1% | 150% |
| Dano Elemental | +1 plano | 200 |
| Velocidad de Ataque | +1% | 100% |
| Probabilidad de Critico | +1% | 75% |]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Estadisticas Secundarias (Defensa)**

| Estadistica | Por Punto | Limite |
|-------------|-----------|--------|
| Probabilidad de Bloqueo | +1% | 30% |
| HP Maxima | +50 plano | Sin limite |
| Mana Maximo | +40 plano | Sin limite |
| Curacion Recibida | +1% | 100% |]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Estadisticas de Utilidad (Progresion)**

| Estadistica | Por Punto | Limite |
|-------------|-----------|--------|
| Ganancia de EXP | +1% | 100% |
| Experiencia de Crafting | +2% | 150% |
| Ganancia de Fame | +2% | 100% |
| Conocimiento del Codex | +0.2% | 50 (~10%) |]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Hitos (Milestones)**

Gastar puntos en una categoria desbloquea bonos de hito y titulos:

**Primario (Ataque):**
- 25 puntos -> Titulo: "Warrior"
- 50 puntos -> +3% Dano Total
- 100 puntos -> +5% Dano Total
- 200 puntos -> Titulo: "Paragon of War", +8% Dano Total

**Secundario (Defensa):**
- 25 puntos -> Titulo: "Guardian"
- 50 puntos -> +5% HP Maxima
- 100 puntos -> +8% HP Maxima
- 200 puntos -> Titulo: "Paragon of Fortitude", +12% HP Maxima

**Utilidad (Progresion):**
- 25 puntos -> Titulo: "Explorer"
- 50 puntos -> +3% Todas las Ganancias
- 100 puntos -> +5% Todas las Ganancias
- 200 puntos -> Titulo: "Paragon of Fortune", +8% Todas las Ganancias

Los bonos de hito son automaticos y se acumulan con los bonos de estadisticas.]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Consejos**

- Prioriza puntos Primarios para aumentar tu DPS bruto
- La HP Secundaria no tiene limite, lo que la hace una inversion segura a largo plazo
- La Ganancia de EXP de Utilidad es valiosa para progresar Paragon mas rapido
- El Conocimiento del Codex ayuda con los drops de cartas mientras farmeas
- Los bonos de hito reemplazan el nivel anterior (ej. 100pt reemplaza 50pt, no se acumulan)
- Proteccion contra muerte: ten cuidado en zonas peligrosas para evitar perder progreso de XP]] }
            }
          },
          codex = {
            name = 'Sistema Codex',
            type = 'rich_text',
            order = 4,
            sections = {
              { type = 'text', content = [[**Que es el Codex?**

El Codex es un sistema de coleccion de cartas. Los monstruos pueden soltar cartas (o cajas de cartas) que equipas en tu Deck (Mazo) para obtener poderosas bonificaciones pasivas y activas. Con 104 cartas unicas, construir el mazo correcto es esencial para el dano, supervivencia y utilidad del End-Game.

Abre el modulo de Codex para ver tu Coleccion, tu Deck activo y la pestana de Fabricacion de Cajas.]] },
              { type = 'image', path = '/images/wiki/codex_overview.png', width = 400, height = 220 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Espacios del Deck**

Tienes 6 espacios para equipar cartas activas. Requisitos de desbloqueo:

- **Espacio 1:** Gratis (siempre desbloqueado)
- **Espacio 2:** Nivel de personaje 80
- **Espacio 3:** Nivel de personaje 150
- **Espacio 4:** Paragon Nivel 1
- **Espacio 5:** Paragon Nivel 50
- **Espacio 6:** Solo cuentas Premium

Las cartas inactivas en tu coleccion no otorgan beneficios. Solo las cartas equipadas aplican sus efectos. Ve a la pestana Deck en el modulo de Codex para equipar o cambiar cartas.]] },
              { type = 'image', path = '/images/codex/deck_bg.png', width = 380, height = 200 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Cajas y Como Obtener Cartas**

Las cartas se obtienen abriendo Cajas. Hay 3 niveles de cajas que puedes fabricar en la pestana Cajas del Codex:

| Caja | Costo de Fabricacion | Nivel Max. de Carta | Comun | Rara | Epica | Legendaria | Esencias Extra |
|------|----------------------|---------------------|-------|------|-------|------------|----------------|
| Bronce | 100 Esencias | Nivel 2 | 70% | 20% | 8% | 2% | 50 (25% probabilidad) |
| Plata | 200 Esencias | Nivel 3 | 60% | 25% | 10% | 5% | 80 (30% probabilidad) |
| Dorada | 350 Esencias | Nivel 5 | 30% | 30% | 30% | 10% | 120 (35% probabilidad) |

Las cajas tambien pueden caer como botin de monstruos y elites. Ademas recibes **1 Caja de Bronce gratis cada 15 niveles de personaje**.]] },
              { type = 'image', path = '/images/wiki/codex_crates.png', width = 400, height = 180 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Esencias del Codex**

Las Esencias son la moneda del sistema Codex. Usos:
- Fabricar cajas (100/200/350 por caja)
- Mejorar cartas directamente (10 EXP por esencia gastada, con multiplicador de rareza)
- Desbloquear espacios del deck anticipadamente (500+ esencias, costo se duplica cada vez)

**Formas de ganar Esencias:**
- Matar monstruos y elites
- Bonificaciones al abrir cajas
- Cartas duplicadas al nivel maximo se convierten en esencias
- **Pocion de Conocimiento:** +50% de ganancia de esencias mientras esta activa

Puedes ver tus Esencias actuales en la parte superior del modulo de Codex.]] },
              { type = 'image', path = '/images/wiki/codex_esssences.png', width = 200, height = 60 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Rareza de Cartas**

Las cartas vienen en 4 rarezas que determinan la tasa de drop y el poder:

- **Comun** (Blanca): Efectos basicos, mas faciles de obtener
- **Rara** (Azul): Efectos mas fuertes, tasa moderada
- **Epica** (Morada): Efectos poderosos que definen builds
- **Legendaria** (Dorada): Efectos que cambian el juego, mas dificiles de obtener]] },
              { type = 'image', path = '/images/wiki/codex_card_rarities.png', width = 400, height = 120 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Nivelacion de Cartas**

Cada carta comienza en Nivel 1 y puede subir hasta Nivel 10. Niveles mas altos desbloquean efectos mas fuertes. Puedes subir de nivel al obtener duplicados (otorgan EXP) o gastando Esencias directamente desde la vista de detalle de la carta.

| Nivel | EXP para Subir | EXP Total |
|-------|----------------|-----------|
| 1 | 500 | 0 |
| 2 | 700 | 500 |
| 3 | 1,000 | 1,200 |
| 4 | 1,300 | 2,200 |
| 5 | 1,600 | 3,500 |
| 6 | 1,900 | 5,100 |
| 7 | 2,200 | 7,000 |
| 8 | 2,500 | 9,200 |
| 9 | 3,000 | 11,700 |
| 10 | -- | 14,700 (Max) |

**Cartas Duplicadas:** Cuando obtienes una carta que ya posees, otorga EXP segun rareza (Comun=100, Rara=200, Epica=300, Legendaria=500). Si la carta ya esta al nivel maximo para el tipo de caja, los duplicados se convierten en esencias.]] },
              { type = 'image', path = '/images/wiki/codex_level_comparison.png', width = 380, height = 160 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Tipos de Activacion (Triggers)**

Las cartas se activan segun diferentes condiciones. Puedes ver el tipo de activacion en el tooltip de cada carta:

- **Pasiva:** Siempre activa mientras esta equipada (bonificaciones de stats, resistencias, auras)
- **Al Matar:** Se activa cuando matas un monstruo (reduccion de cooldown, explosiones, miedo, invocacion)
- **Al Curar:** Se activa cuando curas (restaurar mana, sobrecuracion, eco de grupo)
- **Al Lanzar Hechizo:** Se activa al lanzar hechizos (campos de fuego, curar-al-lanzar)
- **Hechizo de Ataque:** Solo hechizos ofensivos (rayos, sacrificio de sangre)
- **Hechizo de Curacion:** Solo hechizos de curacion (explosion del dragon florido)
- **Curar Aliado:** Solo al curar aliados (castigo divino en enemigos)
- **Al Morir:** Evita la muerte una vez (Fenix revive)
- **Al Critico:** Se activa en golpes criticos
- **HP Bajo:** Se activa al bajar de cierto umbral de vida
- **Periodica:** Se activa periodicamente (efectos basados en intervalos)]] },
              { type = 'image', path = '/images/wiki/codex_trigger_examples.png', width = 400, height = 140 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Construyendo tu Deck**

*Cartas de Dano (DPS):* Critical Surge, The Witch, Glass Cannon, The Dragon, Guns Lover, The Gunner, Svarog, Zeus

*Cartas de Tanque/Supervivencia:* Golem, The Phoenix, The Behemoth, The Slime, Water Elemental, Soul Leech, Final Symphony

*Cartas de Sanador:* Undine, The Elf, Archangel, Blood Link, Blossom Dragon, The Naga, Yacy

*Cartas de Utilidad:* Executioner (reduccion CD), Essence Reaver (farmeo de esencias), The Child (EXP), Carnage Presence (limpieza), The Necromancer (invocaciones)

**Consejos**
- Sinergiza cartas con tu build (ej. The Witch con pools de mana altos)
- Las cartas de dragon (31-40) sinergizan con Dragon Lord para bonificaciones multiplicativas
- Cartas de sanador como Blood Link y Archangel solo funcionan al curar miembros del grupo
- Guns Lover y The Gunner son obligatorias para builds a distancia
- Glass Cannon es alto riesgo, alta recompensa (+32% dano pero +32% dano recibido al maximo)
- Cartas duplicadas al nivel maximo se convierten en esencias -- farmea cajas de bajo tier para ingresos de esencias]] }
            }
          },
        }
      }
    }
  }
end

function getPortugueseData()
  return {
    categories = {
      items = {
        name = 'Itens',
        subcategories = {
          dropable_spells = {
            name = 'Feiticos Dropaveis',
            type = 'list',
            order = 1,
            items = {
              { name = 'magnetic orb', description = 'coloca um orbe magnetico que cria um campo que causa dano aos inimigos proximos', icon = 38167 },
              { name = 'celestial sigil', description = 'Dispara uma marca celestial na posicao alvo que causa dano e aumenta seu magic level em 20% por 4 segundos', icon = 38149 },
              { name = 'absolute defense', description = 'aumenta sua chance de bloqueio em 50% e vida maxima em 30% pelos proximos 8 segundos. (requer escudo equipado)', icon = 38177 },
              { name = 'bouncing sphere', description = 'cria uma esfera que quica entre voce e seu alvo, causando dano e te curando; a velocidade da esfera depende da distancia ate o alvo', icon = 38169 },
              { name = 'earthquake', description = 'quebra o chao causando dano fisico a todos os inimigos e os atordoa por um curto periodo', icon = 38168 },
              { name = 'blessed tree', description = 'cria uma arvore abencoada na posicao alvo, que restaura vida e mana de todos os jogadores proximos se destruida.', icon = 38157 },
              { name = 'spider web', description = 'joga uma teia de aranha no alvo que o atordoa por 2 segundos.', icon = 38165 },
              { name = 'meteor', description = 'joga um meteoro na posicao alvo causando dano de fogo aos inimigos proximos.', icon = 38152 },
              { name = 'water wave', description = 'cria 3 ondas de agua que causam dano de gelo e atordoam os inimigos por 1 segundo.', icon = 38194 },
              { name = 'thunder chain', description = 'cria uma reacao em cadeia de energia que viaja por todos os inimigos proximos.', icon = 38153 },
              { name = 'water torrent', description = 'cria um torrente de agua que repele os inimigos ao seu redor.', icon = 38178 },
              { name = 'shark teeth', description = 'cria uma area perigosa que depois sera devorada por um tubarao gigante.', icon = 34003 },
              { name = 'wild vines', description = 'cria vinhas selvagens ao seu redor que puxam monstros proximos para voce.', icon = 38188 },
              { name = 'quick chains', description = 'envia correntes rapidas na direcao apontada e puxa o primeiro inimigo atingido ate voce.', icon = 38156 },
              { name = 'boomerang', description = 'Lanca um boomerangue magico que causa dano em linha reta e retorna para voce.', icon = 38202 },
              { name = 'wild spikes', description = 'Libera dois espinhos selvagens a sua frente, te curando e causando dano ao alvo.', icon = 33995 },
              { name = 'sniper shot', description = 'Um ataque preciso de longo alcance que causa dano baseado na distancia percorrida.', icon = 34015 },
              { name = 'thunder leap', description = 'salta para a posicao alvo causando dano e atordoando inimigos proximos por 1 segundo.', icon = 38190 },
              { name = 'chain of flames', description = 'cria uma reacao em cadeia de fogo que viaja por todos os inimigos proximos.', icon = 38158 },
              { name = 'toxic spores', description = 'emana esporos toxicos envenenando todos os inimigos proximos por 8 segundos.', icon = 34077 },
              { name = 'final sentence', description = 'Condena seu alvo causando dano sagrado massivo em uma pequena area, aumentando o dano conforme a vida faltante do alvo.', icon = 33996 },
              { name = 'healing prisma', description = 'Cura voce e aliados proximos em uma area ampla', icon = 38191 },
              { name = 'fire tornado', description = 'Invoca um tornado de fogo que queima repetidamente inimigos em area e reduz sua velocidade.', icon = 38179 },
              { name = 'opelus', description = 'Libera rajadas repetidas de dano de energia em um local alvo, atingindo todos os inimigos da area varias vezes.', icon = 38162 },
              { name = 'voltstorm', description = 'Libera uma tempestade de dano de energia constante no local alvo, atingindo todos os inimigos da area varias vezes.', icon = 38182 },
              { name = 'blood aura', description = 'empunha uma aura de sangue drenando a forca vital de todos os inimigos proximos.', icon = 33997 },
              { name = 'arcane missiles', description = 'Dispara 5 misseis arcanos que buscam inimigos aleatorios em uma area 7x7, causando dano de energia.', icon = 38154 },
              { name = 'lightning rod', description = 'Coloca uma torre de raios que atinge inimigos proximos com raios em cadeia a cada segundo por 6 segundos.', icon = 38155 },
              { name = 'phase shift', description = 'Torna-se intangivel por 2 segundos. Voce nao pode atacar nem ser atacado durante esse tempo.', icon = 21703 },
              { name = 'rejuvenation', description = 'Regenera 5% da sua vida maxima por segundo por 10 segundos, curando 50% no total.', icon = 38175 },
              { name = 'last stand', description = 'Quando sua vida cai abaixo de 15%, cura automaticamente 30% da sua vida maxima. Cooldown de 120 segundos.', icon = 38206 },
              { name = 'mana battery', description = 'Converte 20% da sua vida atual em 30% da sua mana maxima.', icon = 38205 },
              { name = 'soul reaper', description = 'Cada vez que voce mata um inimigo nos proximos 10 segundos, causa dano de morte em uma pequena area e restaura 8% da sua vida e mana.', icon = 38187 },
              { name = 'frost nova', description = 'Congela o chao em uma area 5x5 por 8 segundos. Inimigos que entram ficam 70% mais lentos por 2 segundos.', icon = 38192 }
            }
          },
          spell_boots = {
            name = 'Botas de Feitico',
            type = 'list',
            order = 2,
            items = {
              { name = 'boots of teleportation', description = '[onUse] Teletransporta para a posicao alvo.', icon = 33267 },
              { name = 'boots of the wild', description = '[onUse] Avanca ate o inimigo alvo atual.', icon = 33348 },
              { name = 'boots of timewalking', description = '[onUse] Marca sua posicao atual e retorna a ela apos 4 segundos.', icon = 33378 },
              { name = 'boots of winter', description = '[onUse] Coloca armadilhas de gelo no chao enquanto se move, que retardam os inimigos.', icon = 2642 },
              { name = 'boots of levitation', description = '[onUse] Levita no ar removendo todos os efeitos de paralisia e avancando na direcao que voce olha.', icon = 33328 },
              { name = 'boots of the void', description = '[onUse] Prende instantaneamente todos os inimigos proximos em um campo de vazio.', icon = 32497 },
              { name = 'boots of the salamander', description = '[onUse] Coloca pilares de fogo na posicao alvo que podem bloquear a linha de visao.', icon = 9933 },
              { name = 'boots of the dreamer', description = '[onUse] Restaura 15% da mana maxima de todos os jogadores aliados proximos.', icon = 6132 }
            }
          },
          runes = {
            name = 'Runas de Crafting',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'title', text = 'RUNAS DE CRAFTING', color = '#ffd75e' },
              { type = 'text', content = 'As runas de crafting sao feitas pela profissao **Encantamento** a partir de Empty Enchanting Runes. Elas equipam nos tres espacos **CRAFTING** do seu inventario e concedem bonus passivos. Cada runa rola um pacote de atributos unico - quanto maior seu nivel de Encantamento, mais forte a runa que voce crafta.' },
              { type = 'divider' },
              { type = 'warning', content = 'Voce nao pode equipar a mesma runa em dois espacos - seus tres espacos devem ter runas diferentes.' },
              { type = 'divider' },

              { type = 'title', text = 'RUNAS AZUIS - MAGO', color = '#66aaff' },
              { type = 'cards', items = {
                { icon = 35381, name = 'Rune of the Magician', color = '#66aaff', description = 'Concede Arcana.' },
                { icon = 35380, name = 'Rune of Knowledge', color = '#66aaff', description = 'Concede Magic Level.' },
                { icon = 35384, name = 'Rune of Chaos', color = '#66aaff', description = 'Concede Chance de Critico.' },
                { icon = 35386, name = 'Rune of Magic Echoes', color = '#c080ff', description = 'Runa tripla: Magic Level, Reducao de Cooldown e Arcana.' },
              }},
              { type = 'text', content = 'Runas azuis tambem cobrem Mana Maxima (Arcanists, Mana Insight), HP Maximo (Lost Sage) e Magic Level + Velocidade de Ataque (Distortion).' },
              { type = 'divider' },

              { type = 'title', text = 'RUNAS VERDES - CACADOR', color = '#9fe89f' },
              { type = 'cards', items = {
                { icon = 35388, name = 'Rune of the Assassin', color = '#9fe89f', description = 'Concede Velocidade de Ataque.' },
                { icon = 35389, name = 'Rune of the Betrayer', color = '#9fe89f', description = 'Concede Melee.' },
                { icon = 35393, name = 'Rune of Eros', color = '#9fe89f', description = 'Concede Dano de Terra.' },
              }},
              { type = 'text', content = 'Runas verdes tambem cobrem Bloqueio (Hunter), Melee (Despair), Cura Bonus (the Humble), Mana Maxima (the Thief) e Dano de Morte + Distancia (Glory).' },
              { type = 'divider' },

              { type = 'title', text = 'RUNAS AMARELAS - SAGRADO', color = '#ffd75e' },
              { type = 'cards', items = {
                { icon = 35397, name = 'Rune of Dawn of Justice', color = '#ffd75e', description = 'Concede Dano Sagrado.' },
                { icon = 35396, name = 'Rune of Righteousness', color = '#ffd75e', description = 'Concede Poder de Escudo.' },
                { icon = 35401, name = 'Rune of Sin Eater', color = '#ffd75e', description = 'Runa dupla: HP Maximo e Poder de Escudo.' },
              }},
              { type = 'text', content = 'Runas amarelas tambem cobrem Magic Level (Glory), Melee (Faith), Cura Bonus (Devotion) e Mana Maxima (the Sinless).' },
              { type = 'divider' },

              { type = 'title', text = 'RUNAS ROXAS - SOMBRA', color = '#c080ff' },
              { type = 'cards', items = {
                { icon = 35404, name = 'Rune of Agony', color = '#c080ff', description = 'Concede Dano Fisico.' },
                { icon = 35407, name = 'Rune of Doomed Prophet', color = '#c080ff', description = 'Concede Dano de Fogo.' },
                { icon = 35409, name = 'Rune of the Eclipse', color = '#c080ff', description = 'Runa dupla: Melee e Roubo de Vida.' },
              }},
              { type = 'text', content = 'Runas roxas tambem cobrem HP Maximo (Flesh Eater), Magic Level (Drowned Sorrows), Mana Maxima (the Monarch) e Cura Bonus (the Void).' },
              { type = 'divider' },

              { type = 'title', text = 'RUNAS VERMELHAS - GUERREIRO', color = '#ff8888' },
              { type = 'cards', items = {
                { icon = 35413, name = 'Rune of the Berserker', color = '#ff8888', description = 'Concede Melee.' },
                { icon = 35414, name = 'Rune of the Juggernaut', color = '#ff8888', description = 'Concede HP Maximo.' },
                { icon = 35417, name = 'Rune of Aegis', color = '#ff8888', description = 'Concede Poder de Escudo.' },
                { icon = 35412, name = 'Rune of Ashes', color = '#ff8888', description = 'Concede Chance de Critico.' },
              }},
              { type = 'text', content = 'Runas vermelhas tambem cobrem Defesa (Wrath), HP Maximo (Warden) e Dano Fisico (the Hammer).' },
              { type = 'divider' },
              { type = 'tip', content = 'Empty Enchanting Runes vem de desencantar Prismatic Cubes com a Enchanters Rod - veja Crafting > Materiais.' },
            }
          },
          inventory = {
            name = 'Espacos do Inventario',
            type = 'rich_text',
            order = 4,
            sections = {
              { type = 'title', text = 'A JANELA DE INVENTARIO', color = '#ffd75e' },
              { type = 'text', content = 'Sua janela de equipamento e dividida em tres grupos: **ACTIVE** para itens de utilidade, **COMBAT** para arma e armadura, e **CRAFTING** para seus tres espacos de runa. Mochila, anel e colar ficam no meio.' },
              { type = 'divider' },

              { type = 'title', text = 'ACTIVE', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/inventory/inventory_head.png', name = 'Espaco de Feitico (Active)', color = '#c080ff', description = 'Equipe seus feiticos dropaveis aqui - itens de feitico encontrados como loot que concedem uma habilidade extra usavel por qualquer vocacao (veja Feiticos Dropaveis para a lista completa).' },
                { image = '/images/inventory/inventory_feet.png', name = 'Botas (Active)', color = '#ffaa55', description = 'Itens de pe. Aqui vao as spell boots - Boots of Teleportation, Wild, Timewalking e afins (veja Botas de Feitico) - alem de botas normais.' },
                { image = '/images/inventory/inventory_hip.png', name = 'Tocha (Active)', color = '#77ddff', description = 'Espaco de utilidade para fontes de luz e itens de utilidade como o Bless Item. Tochas e ferramentas equipam aqui.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'COMBAT', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/inventory/inventory_left_hand.png', name = 'Arma', color = '#ff8888', description = 'Mao principal. Espadas, machados, clavas, wands, rods e bows. Uma arma de duas maos ocupa ambas as maos e desativa o espaco de escudo.' },
                { image = '/images/inventory/inventory_right_hand.png', name = 'Escudo', color = '#66aaff', description = 'Mao secundaria. Escudos e spellbooks - qualquer coisa com tipo shield. Fica vazio enquanto uma arma de duas maos estiver equipada.' },
                { image = '/images/inventory/inventory_torso.png', name = 'Armadura', color = '#9fe89f', description = 'Espaco do corpo. Armaduras de peito e robes - sua peca defensiva principal.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'EQUIPMENT', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/inventory/inventory_back.png', name = 'Mochila', color = '#ffd75e', description = 'Seu container carregado - determina quanto loot voce pode carregar antes de precisar voltar.' },
                { image = '/images/inventory/inventory_finger.png', name = 'Anel', color = '#ffaa77', description = 'Espaco de anel. Aneis custom adicionam modificadores fortes - cuidado com aneis de cargas que consomem cargas enquanto equipados.' },
                { image = '/images/inventory/inventory_neck.png', name = 'Colar', color = '#77ddaa', description = 'Espaco de amuleto/colar. Colares trazem atributos passivos e resistencias; alguns sao de cargas e se desgastam com o tempo.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'RUNAS DE CRAFTING', color = '#d4a843' },
              { type = 'text', content = 'Os tres espacos de runa guardam **runas craftadas** - os itens "Rune of ..." produzidos pela profissao Encantamento a partir de Empty Enchanting Runes. Cada runa concede um bonus passivo enquanto equipada.' },
              { type = 'cards', items = {
                { image = '/images/inventory/inventory_rune1.png', name = 'Espaco de Runa 1', color = '#c080ff', description = 'Aceita qualquer runa craftada - as de estilo sorcerer como Rune of the Magician, Rune of Chaos ou Rune of Mana Insight.' },
                { image = '/images/inventory/inventory_rune1.png', name = 'Espaco de Runa 2', color = '#c080ff', description = 'Aceita qualquer runa craftada - as de estilo hunter/rogue como Rune of the Hunter, Rune of the Assassin ou Rune of the Thief.' },
                { image = '/images/inventory/inventory_rune1.png', name = 'Espaco de Runa 3', color = '#c080ff', description = 'Aceita qualquer runa craftada - as de estilo knight como Rune of the Juggernaut, Rune of Aegis ou Rune of the Berserker.' },
              }},
              { type = 'divider' },
              { type = 'warning', content = 'Voce nao pode equipar a mesma runa duas vezes - os tres espacos devem ter runas craftadas diferentes.' },
              { type = 'tip', content = 'Runas sao feitas por Refinamento e Transmutacao na profissao Encantamento - veja a secao Crafting para as receitas.' },
            }
          },
        }
      },
      tasks = {
        name = 'Sistema de Tarefas',
        subcategories = {
          overview = {
            name = 'Como Funcionam as Tarefas',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'Quadro de Tarefas' },
              { type = 'divider' },
              { type = 'text', content = [[O Quadro de Tarefas e seu principal motor de caca. Ele oferece **3 ofertas de tarefa** que se regeneram diariamente e sempre que voce faz reroll. Escolha uma, cace os monstros listados e resgate as recompensas.

- Voce pode ter **1 tarefa ativa** por vez
- As tarefas vem dos pools mais proximos do seu nivel (**79 pools**: zonas de caca, andares de masmorra e bosses)
- Cada tarefa mostra os **outfits dos monstros** para voce saber exatamente o que cacar
- Abandonar uma tarefa perde todo o progresso]] },
              { type = 'subtitle', text = 'O Fluxo' },
              { type = 'cards', items = {
                { image = '/images/icons/quest_marker.png', name = '1. Escolha uma oferta', description = 'Abra o Quadro de Tarefas e escolha um dos 3 slots disponiveis.' },
                { image = '/images/icons/prey_damage.png', name = '2. Cace', description = 'Mate os monstros requeridos (56-120 conforme o nivel). Tarefas de boss sao uma **unica morte**.' },
                { image = '/images/icons/treasure.png', name = '3. Resgate', description = 'Volte ao quadro e aperte Complete. Sua **primeira conclusao do dia** tambem da **+100 Fama**.' },
              }},
              { type = 'tip', content = 'Pools de masmorra cortam as kills pela metade mas pagam o **dobro** de recompensa (triplo em boss) - sempre verifique se ha tarefa de masmorra ofertada.' },
            }
          },
          npc_quests = {
            name = 'Tarefas de Kill vs Quests de NPC',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'DOIS SISTEMAS DIFERENTES', color = '#ffd75e' },
              { type = 'text', content = 'O servidor tem **dois sistemas de tarefas separados** que rodam lado a lado - saber qual e qual evita confusao.' },
              { type = 'divider' },

              { type = 'title', text = 'KILL TASKS - O QUADRO DE TAREFAS', color = '#d4a843' },
              { type = 'text', content = 'O **Quadro de Tarefas** (toda esta categoria) e o motor de caca repetivel: 3 ofertas diarias + rerolls, objetivos de kills de pools escalados por nivel, recompensas em tiers e modificadores.' },
              { type = 'cards', items = {
                { image = '/images/icons/quest_marker.png', name = 'Origem', color = '#ffd75e', description = 'A janela do Quadro de Tarefas - escolha uma das 3 ofertas sorteadas.' },
                { image = '/images/icons/prey_damage.png', name = 'Objetivos', color = '#ff8888', description = 'Contagem de kills pura (ou uma unica kill de boss) - sem entregas de itens.' },
                { image = '/images/icons/treasure.png', name = 'Recompensas', color = '#9fe89f', description = 'Ouro / Fama / EXP sorteados por tarefa, alem de Essencias de Codex e caixas por tier. Repetivel todo dia.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'QUESTS DE NPC - A TASK LIST', color = '#d4a843' },
              { type = 'text', content = '**Quests de NPC** sao quests de historia dadas por NPCs especificos pelo mundo (Sheriff Gordon, Seer Valeria, Dream-Seeker Alran, Farmer Mabel e ~30 mais). Cada NPC oferece sua propria questline - fale com eles, complete os objetivos e **volte ao mesmo NPC para resgatar sua recompensa**.' },
              { type = 'cards', items = {
                { image = '/images/icons/quest_marker.png', name = 'Origem', color = '#ffd75e', description = 'Dialogos de NPC - cada NPC entrega suas proprias quests fixas (cerca de 100 quests pelo mundo).' },
                { image = '/images/icons/icon_axe.png', name = 'Objetivos', color = '#ff8888', description = 'Variados: matar monstros ou bosses nomeados, coletar e entregar itens especificos, ou completar etapas de historia.' },
                { image = '/images/icons/crown.png', name = 'Recompensas', color = '#9fe89f', description = 'Loot fixo por quest: itens unicos, ouro, pocoes, titulos - nao rerollaveis.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'DIFERENCAS CHAVE', color = '#d4a843' },
              { type = 'text', content = [[- **Kill tasks** vem do quadro, sao aleatorias a cada dia, e voce so pode ter **1 ativa**
- **Quests de NPC** sao questlines fixas - voce pode rodar varias de NPCs diferentes em paralelo
- Recompensas de kill task sao **sorteadas** (tiers, modificadores, chances de essencia/caixa)
- Recompensas de quests de NPC sao **fixas** por quest - veja o dialogo do NPC
- Abandonar uma kill task perde o progresso; o progresso de quests de NPC fica salvo ate voce terminar]] },
              { type = 'tip', content = 'Os dois sistemas rodam independentes - um objetivo diario de "Kill Task" pode completar enquanto uma questline de NPC tambem esta ativa.' },
            }
          },
          tiers = {
            name = 'Tiers e Raridade de Tarefas',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'title', text = 'Tiers de Tarefa' },
              { type = 'divider' },
              { type = 'text', content = 'Cada tarefa gerada rola um de **4 tiers**. Tiers maiores tem mais modificadores e multiplicadores de recompensa maiores - e todos os tiers podem sair desde o inicio.' },
              { type = 'cards', items = {
                { image = '/images/icons/circle_10513369.png', name = 'Normal', color = '#dfdfdf', description = '**60%** peso - 1.0x recompensas - 0-1 modificadores - 20% chance de 30-60 Essencias de Codex.' },
                { image = '/images/ui/rarity_blue.png', name = 'Rara', color = '#58a6ff', description = '**25%** peso - 1.25x recompensas - 1-2 modificadores - 35% essencia + 12% Caixa de Bronze - 25% reroll bonus.' },
                { image = '/images/ui/rarity_purple.png', name = 'Epica', color = '#c678dd', description = '**10%** peso - 1.5x recompensas - 2-3 modificadores - 50% essencia + 25% Caixa Bronze/Prata - ate +1 reroll e +1 bloqueio.' },
                { image = '/images/ui/rarity_yellow.png', name = 'Lendaria', color = '#ffa940', description = '**5%** peso - 2.0x recompensas - 3 modificadores (2 primeiros sempre positivos) - 70% essencia + 40% caixa - +1-2 rerolls e bloqueios.' },
              }},
              { type = 'tip', content = 'Os ranks de cacador de fama aumentam os pesos de Rara/Epica/Lendaria - veja Beneficios de Fama e Premium.' },
            }
          },
          rewards = {
            name = 'Recompensas e Bonus',
            type = 'rich_text',
            order = 4,
            sections = {
              { type = 'title', text = 'Como as Recompensas Sao Calculadas' },
              { type = 'divider' },
              { type = 'text', content = [[Recompensas base escalam com o nivel medio do pool (Lv):
- **Experiencia:** 1600 x Lv^1.15
- **Fama:** 0.6 x Lv^0.75
- **Ouro:** 50 + Lv^0.7]] },
              { type = 'subtitle', text = 'Multiplicadores Acumulaveis' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Tier', description = 'Rara x1.25 / Epica x1.5 / Lendaria x2.0 - aplica as tres recompensas base.' },
                { image = '/images/icons/prey_damage.png', name = 'Quantidade de Monstros', description = '+15% ouro e exp por monstro extra no objetivo.' },
                { image = '/images/icons/warning.png', name = 'Pagamento de Dificuldade', description = '+15% recompensas por modificador **negativo**, +10% por **misto**.' },
                { image = '/images/icons/experience.png', name = 'Bonus de Grind', description = '+5% recompensas a cada 50 kills requeridas, limitado a **+25%**.' },
                { image = '/images/icons/dungeon.png', name = 'Tarefas de Masmorra', description = 'Metade das kills, **x2 recompensas** (x3 em pools de boss). Recompensas de Codex tambem escalam x1.5/x2.' },
              }},
              { type = 'warning', content = 'Cada tarefa paga apenas **2 das 3 recompensas base** - ouro, fama e experiencia sao sorteados por tarefa (rerolls/bloqueios bonus entram no pool quando saem). Confira a oferta antes de comecar.' },
              { type = 'subtitle', text = 'Recompensas de Codex (sempre por cima)' },
              { type = 'cards', items = {
                { image = '/images/icons/bronce_crate.png', name = 'Caixa de Bronze', description = 'Rara 12% - Epica 25% (Bronze ou Prata) - Lendaria 40% (qualquer tier).' },
                { image = '/images/icons/golden_crate.png', name = 'Bosses de Masmorra', description = 'Pools de boss dao **2 caixas** quando o roll de caixa sucede.' },
                { image = '/images/codex/essence_icon.png', name = 'Essencias', description = 'Normal 20% (30-60) - Rara 35% (60-120) - Epica 50% (120-240) - Lendaria 70% (240-480).' },
              }},
            }
          },
          modifiers = {
            name = 'Modificadores de Tarefa',
            type = 'rich_text',
            order = 5,
            sections = {
              { type = 'title', text = 'Modificadores de Tarefa' },
              { type = 'divider' },
              { type = 'text', content = 'Modificadores rolam com o tier da tarefa e se aplicam enquanto ela esta ativa. **Tarefas Lendarias sempre recebem 3, os dois primeiros garantidamente positivos.**' },
              { type = 'subtitle', text = 'Positivos', color = '#9fe89f' },
              { type = 'cards', items = {
                { image = '/images/icons/gold-bars.png', name = 'Golden Opportunity', color = '#9fe89f', description = '+50-100% ouro de monstros.' },
                { image = '/images/icons/fame.png', name = 'Fame Fortune', color = '#9fe89f', description = '+20-40 fama extra de recompensa.' },
                { image = '/images/icons/icon_magic.png', name = 'Experience Essence', color = '#9fe89f', description = '+10-25% chance de orbe verde (experiencia).' },
                { image = '/images/icons/prey_star.png', name = 'Elite Surge', color = '#9fe89f', description = '+10-20% chance de orbe roxo (elite).' },
                { image = '/images/icons/prey_loot.png', name = "Fortune's Favor", color = '#9fe89f', description = '+5-15% chance de orbe azul (loot raro).' },
                { image = '/images/icons/pet.png', name = 'Companion Training', color = '#9fe89f', description = '+15-25% experiencia de pet.' },
              }},
              { type = 'subtitle', text = 'Negativos', color = '#ff9a8a' },
              { type = 'cards', items = {
                { image = '/images/icons/prey_damage.png', name = 'Empowered Enemies', color = '#ff9a8a', description = 'Monstros causam +10-20% dano.' },
                { image = '/images/icons/icon_health.png', name = 'Cursed Ground', color = '#ff9a8a', description = '-15-25% efetividade de pocoes.' },
                { image = '/images/icons/icon_health.png', name = 'Weakened Vitality', color = '#ff9a8a', description = '-10-20% vida maxima.' },
                { image = '/images/icons/icon_mana.png', name = 'Mana Drain', color = '#ff9a8a', description = '-10-25% mana maxima.' },
                { image = '/images/icons/prey_defense.png', name = 'Hardened Enemies', color = '#ff9a8a', description = 'Monstros ganham +10-20% resistencia a dano.' },
                { image = '/images/icons/icon_mana.png', name = 'Mana Burn', color = '#ff9a8a', description = 'Ataques de monstros drenam 5-15% da sua mana.' },
              }},
              { type = 'subtitle', text = 'Mistos', color = '#c9a0ff' },
              { type = 'cards', items = {
                { image = '/images/icons/prey_star.png', name = 'High Risk, High Reward', color = '#c9a0ff', description = '+50% fama, mas monstros causam +25% dano.' },
                { image = '/images/icons/prey_damage.png', name = 'Glass Cannon', color = '#c9a0ff', description = '+10% chance de loot raro, mas voce recebe +15% dano.' },
                { image = '/images/icons/prey_star.png', name = 'Elite Surge (misto)', color = '#c9a0ff', description = '+25% chance de spawn de elite - mais perigo, mais drops.' },
                { image = '/images/icons/icon_health.png', name = 'Blood Hunt', color = '#c9a0ff', description = 'Cura 5% HP a cada kill, mas recebe +15% dano.' },
                { image = '/images/icons/prey_damage.png', name = 'Berserker Mode', color = '#c9a0ff', description = 'Causa +15-25% dano, mas tambem recebe +15-25% dano.' },
              }},
            }
          },
          rerolls = {
            name = 'Sistema de Rerolls',
            type = 'rich_text',
            order = 6,
            sections = {
              { type = 'title', text = 'Rerolls' },
              { type = 'divider' },
              { type = 'text', content = 'Rerollar atualiza todos os slots de tarefa **nao bloqueados** com novas ofertas - bloqueie as que quer manter primeiro.' },
              { type = 'cards', items = {
                { image = '/images/icons/reroll.png', name = 'Rerolls Gratis', description = '**5 por dia** base. Premium adiciona **+5**. Cada **5 niveis de Fama** adicionam **+1**. Reinicia diariamente.' },
                { image = '/images/icons/gold_coin.png', name = 'Rerolls Pagos', description = '**20 ouro** cada quando os gratis acabam - ilimitado.' },
                { image = '/images/icons/prey_star.png', name = 'Rerolls Bonus', description = 'Raras 25% por +1, Epicas 40% por +1, Lendarias +1-2 garantido - via slot de recompensa da tarefa.' },
              }},
              { type = 'tip', content = 'Guarde rerolls gratis para tiers maiores, e bloqueie uma boa Lendaria antes de rolar o resto.' },
            }
          },
          locks = {
            name = 'Sistema de Bloqueios',
            type = 'rich_text',
            order = 7,
            sections = {
              { type = 'title', text = 'Bloqueios' },
              { type = 'divider' },
              { type = 'text', content = 'Uma tarefa **bloqueada** sobrevive aos rerolls - proteja as boas ofertas enquanto rola por melhores.' },
              { type = 'cards', items = {
                { image = '/images/icons/lock.png', name = 'Bloqueios Gratis', description = '**3 por dia** base. Premium adiciona **+5**. Reinicia diariamente.' },
                { image = '/images/icons/gold_coin.png', name = 'Bloqueios Pagos', description = '**10 ouro** cada quando os gratis acabam.' },
                { image = '/images/icons/lock_small.png', name = 'Bloqueios Bonus', description = 'Epicas 30% por +1, Lendarias +1-2 garantido - via slot de recompensa da tarefa.' },
              }},
              { type = 'tip', content = 'Bloqueie tarefas Epicas/Lendarias ou qualquer tarefa com modificadores que voce goste, depois rerolle os outros slots livremente.' },
            }
          },
          fame_premium = {
            name = 'Beneficios de Fama e Premium',
            type = 'rich_text',
            order = 8,
            sections = {
              { type = 'title', text = 'Ranks de Cacador de Fama' },
              { type = 'divider' },
              { type = 'text', content = 'Seu **nivel de Fama** de conta concede bonus permanentes de tarefas:' },
              { type = 'cards', items = {
                { image = '/images/icons/fame.png', name = 'Fama 3 - Cacador Experiente', description = '+5 peso nos rolls de tier Raro.' },
                { image = '/images/icons/fame.png', name = 'Fama 5 - Cacador Veterano', description = '15% chance de converter um modificador negativo em positivo/misto.' },
                { image = '/images/icons/fame.png', name = 'Fama 7 - Cacador de Elite', description = '+1 reroll gratis por dia.' },
                { image = '/images/icons/fame.png', name = 'Fama 8 - Mestre Cacador', description = 'Peso bonus nos rolls Epic (aplica a partir de Fama 20+).' },
                { image = '/images/icons/fame_big.png', name = 'Fama 10 - Cacador Lendario', description = '+5% em todas as recompensas de tarefa.' },
              }},
              { type = 'subtitle', text = 'Conta Premium' },
              { type = 'cards', items = {
                { image = '/images/icons/crown.png', name = 'Vantagens Premium', description = '+5 rerolls gratis e +5 bloqueios gratis por dia.' },
              }},
              { type = 'tip', content = 'O **bonus diario de +100 Fama** e creditado automaticamente com sua primeira tarefa completada do dia.' },
            }
          },
        }
      },
      daily_tasks = {
        name = 'Missoes Diarias',
        subcategories = {
          overview = {
            name = 'Como Funcionam as Missoes Diarias',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'MISSOES DIARIAS', color = '#ffd75e' },
              { type = 'text', content = 'Todo dia voce recebe **8 tarefas** sorteadas automaticamente com dificuldade ponderada: Facil (34%), Media (33%) e Dificil (33%). Elas reiniciam na meia-noite local do servidor - tarefas nao terminadas se perdem na virada do dia.' },
              { type = 'image', path = '/images/wiki/daily_tasks_overview.png', width = 400, height = 126 },
              { type = 'cards', items = {
                { icon = 33904, name = 'Quadro de Missoes Diarias', color = '#ffd75e', description = 'O quadro no centro da cidade abre sua janela de Missoes Diarias - clique nele para ver tarefas, acompanhar progresso e resgatar recompensas.' },
                { image = '/images/icons/clock.png', name = 'Reinicio Diario', color = '#66aaff', description = 'As tarefas rerollam a cada dia local do servidor. Resgate as recompensas antes do reinicio ou elas se perdem.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'CATEGORIAS DE TAREFAS', color = '#d4a843' },
              { type = 'text', content = [[- **Kill Zone** - mate monstros em zonas non-PvP, PvP ou PvP-forcado
- **Boss** - derrote bosses (qualquer um ou um especifico)
- **Dungeon** - complete runs de masmorra
- **Zone Event** - complete eventos de zona
- **Tower Floor** - limpe andares da Torre de Deus
- **Pet Level** - suba o nivel do seu pet
- **Item Proficiency** - atinja marcos de proficiencia de item
- **Kill Task** - complete kill tasks do quadro
- **Crafting** - entregue itens craftados (Alquimia, Encantamento, Ferraria)
- **Gathering** - entregue essencias coletadas
- **Mixed** - combine multiplas acoes de uma vez (kills + torre, bosses + masmorras + eventos)

Tarefas de **progresso automatico** se atualizam enquanto voce joga. Tarefas de **entrega** precisam dos itens no seu inventario - depois clique em Entregar.]] },
              { type = 'divider' },

              { type = 'title', text = 'RECOMPENSAS', color = '#d4a843' },
              { type = 'text', content = 'As recompensas escalam com a dificuldade da tarefa:' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Tarefa Facil', color = '#9fe89f', description = '3 Pontos de Conquista + 25 Essencias de Codex' },
                { image = '/images/icons/star.png', name = 'Tarefa Media', color = '#ffd75e', description = '6 Pontos de Conquista + 40 Essencias de Codex' },
                { image = '/images/icons/star.png', name = 'Tarefa Dificil', color = '#ff8888', description = '10 Pontos de Conquista + 60 Essencias de Codex' },
                { image = '/images/icons/crown.png', name = 'Recompensa Diaria Grande', color = '#ffd75e', description = 'Complete 4 tarefas para resgatar 1 Caixa Dourada de Codex - uma vez por dia, resgate antes do reinicio.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'TIERS DE TAREFAS DE CRAFTING', color = '#d4a843' },
              { type = 'text', content = [[As tarefas de crafting escalam com seu tier de profissao:

**Alquimia:** Aprendiz (essencias refinadas, pocoes basicas) - Novato (pocoes de vida/mana/espirito, frascos pequenos) - Oficial (pocoes fortes, frascos e elixires medios) - Mestre (grandes pocoes) - Grao-Mestre (grandes pocoes encantadas)

**Encantamento:** Aprendiz (runas tier 1) - Oficial (tier 3) - Adepto (tier 4) - Mestre (tier 5) - Grao (tier 6 topo) - Especialista em Projetos (crafteos raros de projetos)

**Ferraria:** Aprendiz (armas iniciais e escudos) - Oficial (equipamento de combate basico: espadas 1M, armas 2M, a distancia, escudos)

**Refinaria (Gadgets):** itens de utilidade craftados de madeira e barras - bandagens e armas de treino em niveis baixos, iscas, pedras de amolar, bombas de cola e tendas no meio, depois cajado de madeira viva, gancho de escalada, espada boomerang e deposito portatil no topo. O nivel de Refinaria aumenta diretamente o dano e a cura dos gadgets.

**Lenhador:** profissao de coleta que alimenta a Refinaria - corte arvores em troncos, refine-os em tabuas, e ganhe +1% de velocidade de ataque por nivel.]] },
              { type = 'divider' },
              { type = 'tip', content = 'Priorize as tarefas faceis primeiro para conclusoes rapidas, guarde itens craftados extras no storage para entregas instantaneas, e sempre resgate sua Caixa Dourada antes de o dia terminar.' },
            }
          },
        }
      },
      monster_orbs = {
        name = 'Orbes de Monstro',
        subcategories = {
          overview = {
            name = 'Guia de Orbes',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'ORBES DE MONSTRO', color = '#ffd75e' },
              { type = 'text', content = 'Quando voce mata um monstro (nivel 2+), ha uma chance de um orbe brilhante cair no chao. Passe por cima para resgatar a recompensa - [color=#ff8888]somente voce pode pegar seus proprios orbes[/color].' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Os Quatro Tipos de Orbe', color = '#ffd75e' },
              { type = 'cards', items = {
                { icon = 39941, name = 'Orbe de Ouro', color = '#ffd700',
                  description = 'Concede ouro instantaneo: [color=#ffd700]nivel do monstro x 10[/color]. Chance de drop ~2.7% (4 em 150).' },
                { icon = 38694, name = 'Orbe de Loot', color = '#5599ff',
                  description = 'Concede um item de loot escalado ao nivel do monstro - e aqui que o [color=#ffd700]equipamento custom[/color] entra no jogo. Chance ~1.3% (2 em 150).' },
                { icon = 38693, name = 'Orbe de Experiencia', color = '#77ff77',
                  description = 'Concede experiencia instantanea: [color=#ffd700]nivel do monstro x 100[/color]. Chance ~1.3% (2 em 150).' },
                { icon = 38572, name = 'Orbe da Morte', color = '#cc66ff',
                  description = 'Invoca uma [color=#ff8888]versao elite do monstro que voce acabou de matar[/color] com o dobro de HP e um prefixo especial ([Shadow], [Aqua], [Volcanic], [Sacred], [Mighty], [Terra]). Elites tem poderes unicos e dropam essencias de elite. Chance ~1.3% (2 em 150).' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Como conseguir mais orbes', color = '#66ff99' },
              { type = 'cards', items = {
                { icon = 38694, name = 'Orb Shower (Buff de Zona)', color = '#44aaff',
                  description = 'Quando uma zona tem o buff Orb Shower ativo, todas as chances de drop de orbe ficam aumentadas enquanto durar (~30 min).' },
                { icon = 33904, name = 'Modificadores de Tarefa', color = '#ffcc66',
                  description = 'Alguns modificadores de tarefa aumentam a chance de orbe roxo / azul / verde - mas apenas enquanto o monstro da tarefa ainda estiver incompleto.' },
                { icon = 33621, name = 'Prestigio High Risk', color = '#ff5544',
                  description = 'O modo de prestigio High Risk aumenta a chance de orbe azul em 20% e concede +1 drop extra dos orbes azuis.' },
              }},
              { type = 'warning', content = 'Os orbes pertencem ao jogador que matou o monstro - membros de party e espectadores nao podem rouba-los.' },
            }
          },
        }
      },
      zones = {
        name = 'Zonas e Eventos',
        subcategories = {
          overview = {
            name = 'Como Funcionam as Zonas',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'ZONAS DE CACA', color = '#ffd75e' },
              { type = 'text', content = 'O mundo e dividido em ~99 zonas de caca. Cada zona tem seus proprios spawns de monstros, faixa de nivel, clima e um [color=#ffd700]boss de zona[/color] que aparece apos kills suficientes. As zonas rotacionam eventos e buffs aleatorios - sempre confira o painel de zona antes de cacar.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Eventos de Zona', color = '#66ff99' },
              { type = 'text', content = 'As zonas rodam eventos periodicamente: cotas de kills, cacas a boss e invasoes funnykill (ondas de monstros spawnados). Os maiores contribuidores ganham recompensas de podio.' },
              { type = 'cards', items = {
                { image = '/images/icons/treasure.png', name = 'Recompensas de Podio (Top 3)', color = '#ffd700',
                  description = '1o: 200 exp + Caixa Dourada + essencias. 2o: 100 exp + Caixa Dourada. 3o: 75 exp + Caixa Dourada. Mais moedas de platina.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Buffs de Zona (rotacionam automaticamente)', color = '#66aaff' },
              { type = 'text', content = 'Cada zona pode ter um buff ativo. Buffs [color=#77ff77]amigaveis[/color] sao bonus puros; buffs [color=#ff8888]agressivos[/color] adicionam risco ou pressao de PvP.' },
              { type = 'cards', items = {
                { icon = 38693, name = 'Experiencia em Dobro', color = '#ffd700', description = 'Exp em dobro de todas as kills de monstros. 40 min. (amigavel)' },
                { icon = 38694, name = 'Chuva de Orbes', color = '#44aaff', description = 'Todas as chances de drop de orbe aumentadas. 30 min. (amigavel)' },
                { image = '/images/icons/explosion.png', name = 'Monster Rush', color = '#ff4444', description = 'Taxa de spawn de monstros em dobro. 20 min. (agressivo)' },
                { image = '/images/icons/skull.png', name = 'Pacto de Sangue', color = '#cc0000', description = 'Cada kill aumenta permanentemente seus stats ate voce morrer ou sair da zona. 40 min. (agressivo)' },
                { image = '/images/icons/skull.png', name = 'Caca de Recompensas', color = '#ff0000', description = 'Kills de monstros podem dar fama; kills de players dao mais. 40 min. (agressivo)' },
                { icon = 35768, name = 'Regeneracao Rapida', color = '#00ff88', description = 'Regeneracao de HP e mana +200%. 40 min. (amigavel)' },
                { image = '/images/icons/flash.png', name = 'Speed Demon', color = '#00ccff', description = '+50% velocidade de movimento, -20% cooldown de feiticos. 20 min. (amigavel)' },
                { image = '/images/icons/shield-divided-four_16769380.png', name = 'Instinto de Sobrevivencia', color = '#8888ff', description = '-25% dano recebido, +20% HP maximo. 40 min. (amigavel)' },
                { image = '/images/icons/fire.png', name = 'Lua de Sangue', color = '#cc0033', description = '+15% lifesteal; receber dano aumenta seu proximo ataque em 10%. 35 min. (agressivo)' },
                { image = '/images/codex/essence_icon.png', name = 'Conhecimento do Codex', color = '#9933ff', description = 'Monstros tem chance de dar +5 essencia de codex por kill. 35 min. (amigavel)' },
              }},
              { type = 'tip', content = 'Confira qual buff esta ativo antes de escolher a zona de caca - as horas de Exp em Dobro e Chuva de Orbes sao as melhores janelas de farm.' },
            }
          },
        }
      },
      dungeons = {
        name = 'Masmorras',
        subcategories = {
          overview = {
            name = 'Guia de Masmorras',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'MASMORRAS', color = '#ffd75e' },
              { type = 'text', content = 'Masmorras sao runs instanciadas acessadas por pedras de portal. Cada uma tem um objetivo de missao - geralmente matar um boss final. Uma [color=#ffd700]mutacao diaria[/color] modifica toda masmorra ativa com mecanicas extras.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Dificuldade', color = '#ff9e5e' },
              { type = 'text', content = 'A dificuldade escala o dano dos monstros e a pressao de x0.85 (nivel 1) ate x1.60 (nivel 6). Escolha um nivel que voce consegue limpar - runs falhadas desperdicam a entrada.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Mutadores Diarios (um ativo por dia, rerolla as 00:00)', color = '#cc66ff' },
              { type = 'cards', items = {
                { image = '/images/dungeons/mutations/1.png', name = 'Anti-Cura', color = '#ff6666', description = 'Cura recebida reduzida em 30%.' },
                { image = '/images/dungeons/mutations/2.png', name = 'Furia de Elite', color = '#ff4444', description = 'Elites causam 20% mais dano.' },
                { image = '/images/dungeons/mutations/3.png', name = 'Campos Lentos', color = '#66aaff', description = 'Campos de perigo aplicam lentidao.' },
                { image = '/images/dungeons/mutations/4.png', name = 'Queima de Mana', color = '#66ffee', description = 'Monstros queimam mana ao atingir.' },
                { image = '/images/dungeons/mutations/5.png', name = 'Furia Descontrolada', color = '#ff8888', description = 'Inimigos abaixo de 30% HP causam +40% dano.' },
                { image = '/images/dungeons/mutations/6.png', name = 'Explosao Eterea', color = '#cc99ff', description = 'Alguns inimigos explodem ao morrer em area.' },
                { image = '/images/dungeons/mutations/7.png', name = 'Pele de Adamantita', color = '#aaaaaa', description = 'Inimigos reduzem em 80% o primeiro golpe recebido a cada 5s.' },
                { image = '/images/dungeons/mutations/8.png', name = 'Regeneracao Profana', color = '#77ff77', description = 'Se nao forem atingidos por 5s, inimigos regeneram vida rapidamente.' },
                { image = '/images/dungeons/mutations/9.png', name = 'Tempestade Arcana', color = '#aa66ff', description = 'Raios atingem areas aleatorias a cada 8s.' },
                { image = '/images/dungeons/mutations/10.png', name = 'Dominio do Vazio', color = '#9933cc', description = 'Uma entidade do vazio persegue lentamente e detona ao contato.' },
                { image = '/images/dungeons/mutations/12.png', name = 'Mana Instavel', color = '#66ffcc', description = 'Ao gastar 50% da mana maxima, voce explode em uma pequena AoE.' },
                { image = '/images/dungeons/mutations/13.png', name = 'Essencia Vampirica', color = '#ff6688', description = 'Inimigos roubam 5% do dano causado como vida.' },
                { image = '/images/dungeons/mutations/14.png', name = 'Reflexo Doloroso', color = '#ffaa55', description = 'Inimigos refletem 15% do dano recebido.' },
                { image = '/images/dungeons/mutations/15.png', name = 'Furia Global', color = '#ff5544', description = 'A cada minuto, inimigos ganham dano cumulativo.' },
              }},
              { type = 'warning', content = 'Confira o mutador diario antes de entrar! Anti-Cura e Essencia Vampirica em alta dificuldade sao brutais.' },
            }
          },
          dungeon_list = {
            name = 'Lista de Masmorras',
            type = 'list',
            order = 2,
            items = {
              { name = 'The Aquarium', description = 'Boss: Lady Undine.', image = '/images/dungeons/The Aquarium.png' },
              { name = 'Black Temple', description = 'Boss: Lord Hamelin.', image = '/images/dungeons/Black Temple.png' },
              { name = 'Blackstone Depths', description = 'Boss: Drakkomir.', image = '/images/dungeons/Blackstone Depths.png' },
              { name = 'Crystal Rift', description = 'Boss: Crystallith.', image = '/images/dungeons/Crystal Rift.png' },
              { name = 'Dr Pomelo Laboratory', description = 'Boss: Doctor Pomelo.', image = '/images/dungeons/Dr Pomelo Laboratory.png' },
              { name = 'Garona Nightmare', description = 'Boss: Garona Nightmarized.', image = '/images/dungeons/Garona Nightmare.png' },
              { name = 'Goblin Lair', description = 'Boss: Garnak the Warlord.', image = '/images/dungeons/Goblin Lair.png' },
              { name = 'Lucellas Dungeon', description = 'Boss: Lucella.', image = '/images/dungeons/Lucellas Dungeon.png' },
              { name = 'Luminicent Path', description = 'Boss: Lumelia.', image = '/images/dungeons/Luminicent Path.png' },
              { name = 'Sandstorm Coliseum', description = 'Boss: Colliseum Champion Garuda.', image = '/images/dungeons/Sandstorm coliseum.png' },
              { name = 'Shadow Realm', description = 'Boss: Dreadmaw.', image = '/images/dungeons/Shadow Realm.png' },
              { name = 'The Pit', description = 'Boss: Widow Empress.', image = '/images/dungeons/The Pit.png' },
              { name = 'The Pyrotheca', description = 'Boss: Vulcanys.', image = '/images/icons/dungeon.png' },
            }
          },
        }
      },
      item_upgrades = {
        name = 'Melhoria de Itens',
        subcategories = {
          overview = {
            name = 'Como Funciona',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'MELHORIA DE ITENS', color = '#ffd75e' },
              { type = 'text', content = 'O **Orb of Performance** e o unico item de melhoria do jogo. Use-o em uma peca de equipamento para aumentar seu nivel de melhoria, mostrado como **+N** ao lado do nome do item - ate **+15**.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Usando um Orbe', color = '#66ff99' },
              { type = 'text', content = '**1.** Coloque o item na sua mochila - orbes nao funcionam em equipamento vestido.\n**2.** Use o Orb of Performance no item.\n**3.** Em sucesso o item ganha +1 nivel de melhoria; em falha apenas o orbe e consumido.' },
              { type = 'text', content = 'O item deve ser melhoravel (armas, escudos, armaduras, pernas, botas, aneis e colares) e ja ter um **item level**. Itens nao identificados ou espelhados nao podem ser modificados.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Chance de Sucesso por Nivel', color = '#ff9e5e' },
              { type = 'text', content = '+1: 100% | +2: 85% | +3: 70% | +4: 50% | +5: 35% | +6: 20% | +7: 10% | +8: 8% | +9: 3% | +10 a +15: 2%' },
              { type = 'tip', content = 'Um roll falho so custa o orbe - o item nunca e rebaixado nem destruido. Apos +8 as chances caem bruscamente, entao guarde varios orbes para os ultimos niveis.' },
            }
          },
          obtain = {
            name = 'Como Obter',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'ONDE CONSEGUIR ORBS OF PERFORMANCE', color = '#ffd75e' },
              { type = 'text', content = 'Orbs of Performance vem de algumas fontes confiaveis - masmorras sao de longe a mais constante.' },
              { type = 'divider' },
              { type = 'cards', items = {
                { image = '/images/icons/dungeon.png', name = 'Baus de Masmorra', color = '#66ff99', description = 'Toda conclusao de masmorra da 3-5 orbes garantidos. O farm mais confiavel quando voce ja limpa masmorras.' },
                { image = '/images/icons/prey_loot.png', name = 'Orbes de Loot Azuis', color = '#77aaff', description = 'Cerca de 10% de chance por roll de orbe azul, em qualquer nivel de monstro. Acumula enquanto voce caca.' },
                { image = '/images/icons/quest_marker.png', name = 'Recompensas de Tarefa e Quest', color = '#ffd75e', description = 'Varias quests da task list de NPC dao 1-3 orbes ao completar.' },
                { image = '/images/icons/icon_axe.png', name = 'Crafting', color = '#ffaa55', description = 'Craftavel na categoria Augments das profissoes usando pos de encantamento.' },
              }},
              { type = 'divider' },
              { type = 'tip', content = 'Runs diarias de masmorra mais drops de orbe enquanto caca mantem um estoque constante - guarde-os para equipamento que voce pretende manter.' },
            }
          },
          bonuses = {
            name = 'Bonus de Melhoria',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'title', text = 'O QUE CADA MELHORIA ADICIONA', color = '#ffd75e' },
              { type = 'text', content = 'Cada nivel de melhoria adiciona stats fixos sobre os valores base do item - o bonus escala com o nivel +N, entao uma arma +15 e dramaticamente mais forte que uma +5.' },
              { type = 'divider' },
              { type = 'cards', items = {
                { image = '/images/icons/icon_axe.png', name = 'Armas de Uma Mao', color = '#ff8888', description = '+2 ataque por nivel de melhoria.' },
                { image = '/images/icons/icon_axe.png', name = 'Armas de Duas Maos', color = '#ff6666', description = '+4 ataque por nivel de melhoria - o dobro do bonus das de uma mao.' },
                { image = '/images/icons/shield-divided-four_16769380.png', name = 'Escudos e Armas', color = '#66aaff', description = '+2 defesa por nivel de melhoria.' },
                { image = '/images/icons/shield-divided-four_16769380.png', name = 'Defesa Extra', color = '#77ddff', description = '+1 defesa extra por nivel de melhoria em itens que a possuem.' },
                { image = '/images/icons/icon_health.png', name = 'Pecas de Armadura', color = '#9fe89f', description = '+1 armadura por nivel de melhoria em armadura, pernas e botas.' },
              }},
              { type = 'divider' },
              { type = 'text', content = 'Os bonus de melhoria se aplicam sobre os stats normalizados por nivel do item, entao melhorar uma peca de **item level** alto e sempre mais valioso que melhorar uma de nivel baixo.' },
            }
          },
        }
      },
      item_level = {
        name = 'Item Level',
        subcategories = {
          overview = {
            name = 'O Que E Item Level',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'ITEM LEVEL', color = '#ffd75e' },
              { type = 'text', content = 'Toda peca de equipamento que dropa tem um **item level (iLvl)** - uma nota de poder oculta que determina quao fortes seus stats sao. Duas copias da mesma espada podem ter ataques muito diferentes porque droparam em item levels diferentes.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'O Basico', color = '#66ff99' },
              { type = 'text', content = '- O iLvl e atribuido quando o item dropa - igual ao nivel do monstro que o dropou.\n- Stats (ataque, defesa, armadura) sao escalados a esse nivel, entao iLvl maior = item mais forte.\n- O tooltip do item mostra seu iLvl e um nivel de personagem sugerido para usa-lo.\n- O iLvl tem cap de **500** - apenas os monstros mais fortes do endgame o atingem.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Por Que Importa', color = '#ff9e5e' },
              { type = 'text', content = 'Item level e a espinha dorsal do equipamento: um item comum de iLvl alto pode superar um raro de iLvl baixo. Antes de gastar **Orbs of Performance**, certifique-se de que a peca vale a pena - melhorias multiplicam uma boa base, nao consertam uma fraca.' },
            }
          },
          calculation = {
            name = 'Como E Calculado',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'COMO O ITEM LEVEL FUNCIONA', color = '#ffd75e' },
              { type = 'text', content = 'O item level nao e aleatorio - ele deriva da fonte que produziu o item, depois passa por varios modificadores.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'O Drop', color = '#66ff99' },
              { type = 'text', content = 'Quando um monstro morre, cada item elegivel no corpo recebe o **nivel do monstro** como item level. Cacar em zonas mais fortes e a unica forma de subir o piso de iLvl dos seus drops.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Normalizacao de Stats', color = '#ff9e5e' },
              { type = 'text', content = 'O ataque, defesa e armadura do item sao entao reconstruidos em torno daquele nivel: cada espaco de equipamento tem sua propria base mais uma taxa de crescimento por nivel. E por isso que o iLvl, e nao o nome do item, decide seu poder real.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Qualidade da Fonte', color = '#cc99ff' },
              { type = 'text', content = 'De onde o item veio tambem importa - monstros **elite**, **bosses**, **drops de orbe** e equipamento **craftado** rolam uma qualidade de fonte que pode empurrar os stats acima ou abaixo da base do nivel.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Bonus de Raridade', color = '#ffd75e' },
              { type = 'text', content = 'Itens identificados com raridade **Orbital**, **Forged** ou **Ascended** recebem um aumento modesto de item level por cima de tudo - raridade e a cereja do bolo, nao a fundacao.' },
              { type = 'divider' },
              { type = 'tip', content = 'Regra pratica: o nivel do monstro define o teto, a qualidade da fonte e a raridade decidem onde dentro dele o item cai.' },
            }
          },
        }
      },
      proficiency = {
        name = 'Proficiencia de Item',
        subcategories = {
          overview = {
            name = 'Guia de Proficiencia',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'PROFICIENCIA DE ITEM', color = '#ffd75e' },
              { type = 'text', content = 'Seus itens equipados ganham XP de proficiencia conforme voce mata monstros. Cada marco desbloqueia uma [color=#ffd700]escolha de traco[/color] - escolha um traco por coluna para customizar o item.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Como o XP funciona', color = '#66ff99' },
              { type = 'text', content = 'Por monstro morto, cada item equipado elegivel ganha [color=#ffd700]300 + 15% da exp do monstro[/color] de XP de proficiencia. O progresso e salvo por id de item - troque de equipamento e seu progresso fica guardado.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Marcos (7 colunas)', color = '#ff9e5e' },
              { type = 'text', content = '**Col 1:** 91,000 XP | **Col 2:** 205,000 | **Col 3:** 455,000 | **Col 4:** 1,023,750 | **Col 5:** 2,275,000 | **Col 6:** 5,005,000 | **Col 7:** 11,375,000' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Tracos de Exemplo', color = '#cc66ff' },
              { type = 'cards', items = {
                { image = '/images/proficiency/executioner.png', name = 'Executioner', color = '#ff6666', description = 'Causa +30% de dano a inimigos abaixo de 25% de vida.' },
                { image = '/images/proficiency/cleave.png', name = 'Cleave', color = '#ffaa55', description = 'Golpes melee tem 35% de chance de espalhar 60% de dano a inimigos adjacentes.' },
                { image = '/images/proficiency/bloodfeast.png', name = 'Bloodfeast', color = '#ff8888', description = 'Cura 4% do dano que voce causa.' },
                { image = '/images/proficiency/last_stand.png', name = 'Last Stand', color = '#8888ff', description = 'Abaixo de 30% de vida, recebe 30% menos dano.' },
                { image = '/images/proficiency/twin_strike.png', name = 'Twin Strike', color = '#66ffee', description = '20% de chance de atacar instantaneamente de novo por 70% de dano.' },
                { image = '/images/proficiency/adrenaline.png', name = 'Adrenaline', color = '#ffcc66', description = 'Abaixo de 40% de vida, ganha +12% de velocidade de ataque.' },
              }},
              { type = 'tip', content = 'Os tracos sao por tipo de item (armas, bows, wands, escudos, armaduras, aneis, colares e botas tem sua propria rota de tracos). Confira a janela de Proficiencia para ver todas as rotas.' },
            }
          },
          traits = {
            name = 'Lista de Tracos',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'TODOS OS TRACOS DE PROFICIENCIA', color = '#ffd75e' },
              { type = 'text', content = 'Todos os tracos disponiveis nas rotas de proficiencia. Os icones correspondem a janela de Proficiencia no jogo. Quais tracos aparecem depende da rota do tipo de item.' },
              { type = 'divider' },
              { type = 'subtitle', text = 'Tracos de Stat Base (30)', color = '#66ff99' },
              { type = 'cards', items = {
                { image = '/images/proficiency/keen_edge.png', name = 'Keen Edge', color = '#66ff99', description = '+4% Chance de Critico' },
                { image = '/images/proficiency/brutality.png', name = 'Brutality', color = '#66ff99', description = '+5% Dano Fisico' },
                { image = '/images/proficiency/swiftstrike.png', name = 'Swiftstrike', color = '#66ff99', description = '+5% Velocidade de Ataque' },
                { image = '/images/proficiency/sharpened.png', name = 'Sharpened', color = '#66ff99', description = '+2 skill de Sword' },
                { image = '/images/proficiency/heavy_blows.png', name = 'Heavy Blows', color = '#66ff99', description = '+2 skill de Arcana' },
                { image = '/images/proficiency/crushing.png', name = 'Crushing', color = '#66ff99', description = '+2 skill de Sword +2% Chance de Critico ' },
                { image = '/images/proficiency/steady_aim.png', name = 'Steady Aim', color = '#66ff99', description = '+3 skill de Distance' },
                { image = '/images/proficiency/spellbinder.png', name = 'Spellbinder', color = '#66ff99', description = '+3 Magic Level' },
                { image = '/images/proficiency/vampiric.png', name = 'Vampiric', color = '#66ff99', description = '+5% Roubo de Vida' },
                { image = '/images/proficiency/bloodthirst.png', name = 'Bloodthirst', color = '#66ff99', description = '+8% Roubo de Vida' },
                { image = '/images/proficiency/mana_siphon.png', name = 'Mana Siphon', color = '#66ff99', description = '+5% Roubo de Mana' },
                { image = '/images/proficiency/mind_drain.png', name = 'Mind Drain', color = '#66ff99', description = '+8% Roubo de Mana' },
                { image = '/images/proficiency/emberforged.png', name = 'Emberforged', color = '#66ff99', description = '+6% Dano de Fogo' },
                { image = '/images/proficiency/frostbitten.png', name = 'Frostbitten', color = '#66ff99', description = '+6% Dano de Gelo' },
                { image = '/images/proficiency/hallowed.png', name = 'Hallowed', color = '#66ff99', description = '+6% Dano Sagrado' },
                { image = '/images/proficiency/necrotic.png', name = 'Necrotic', color = '#66ff99', description = '+6% Dano de Morte' },
                { image = '/images/proficiency/stormcharged.png', name = 'Stormcharged', color = '#66ff99', description = '+6% Dano de Energia' },
                { image = '/images/proficiency/earthrender.png', name = 'Earthrender', color = '#66ff99', description = '+6% Dano de Terra' },
                { image = '/images/proficiency/reinforced.png', name = 'Reinforced', color = '#66ff99', description = '+4% Dano Fisico, +3% Bloqueio' },
                { image = '/images/proficiency/vitality.png', name = 'Vitality', color = '#66ff99', description = '+7% Vida Maxima' },
                { image = '/images/proficiency/clarity.png', name = 'Clarity', color = '#66ff99', description = '+7% Mana Maxima' },
                { image = '/images/proficiency/evasion.png', name = 'Evasion', color = '#66ff99', description = '+4% Esquiva' },
                { image = '/images/proficiency/bulwark.png', name = 'Bulwark', color = '#66ff99', description = '+4% Bloqueio' },
                { image = '/images/proficiency/aegis.png', name = 'Aegis', color = '#66ff99', description = '+2 skill de Defence' },
                { image = '/images/proficiency/fortified.png', name = 'Fortified', color = '#66ff99', description = '+8% Poder de Escudo' },
                { image = '/images/proficiency/mending.png', name = 'Mending', color = '#66ff99', description = '+12% Cura Extra' },
                { image = '/images/proficiency/focus.png', name = 'Focus', color = '#66ff99', description = '+8% Reducao de Cooldown' },
                { image = '/images/proficiency/swiftness.png', name = 'Swiftness', color = '#66ff99', description = '+25 Velocidade de Movimento' },
                { image = '/images/proficiency/regrowth.png', name = 'Regrowth', color = '#66ff99', description = '+6% regeneracao de HP Maximo / 6s' },
                { image = '/images/proficiency/channeling.png', name = 'Channeling', color = '#66ff99', description = '+6% regeneracao de MP Maximo / 6s' },
              }},
              { type = 'divider' },
              { type = 'subtitle', text = 'Procs de Estilo de Jogo (14)', color = '#ff9e5e' },
              { type = 'cards', items = {
                { image = '/images/proficiency/executioner.png', name = 'Executioner', color = '#ff9e5e', description = 'Causa +30% de dano a inimigos abaixo de 25% de Vida.' },
                { image = '/images/proficiency/opportunist.png', name = 'Opportunist', color = '#ff9e5e', description = 'Causa +20% de dano a inimigos isolados (sem outro inimigo ao lado).' },
                { image = '/images/proficiency/rend.png', name = 'Rend', color = '#ff9e5e', description = '30% de chance ao acertar de causar Sangramento (dano fisico continuo).' },
                { image = '/images/proficiency/cleave.png', name = 'Cleave', color = '#ff9e5e', description = 'Golpes melee tem 35% de chance de espalhar 60% de dano a inimigos adjacentes.' },
                { image = '/images/proficiency/arc_surge.png', name = 'Arc Surge', color = '#ff9e5e', description = '25% de chance ao acertar de arquear 50% de dano de energia a um inimigo proximo.' },
                { image = '/images/proficiency/lone_wolf.png', name = 'Lone Wolf', color = '#ff9e5e', description = 'Enquanto nao ha aliados por perto, causa +15% de dano.' },
                { image = '/images/proficiency/pack_tactics.png', name = 'Pack Tactics', color = '#ff9e5e', description = 'Causa +6% de dano por aliado proximo (max +18%).' },
                { image = '/images/proficiency/warding_bond.png', name = 'Warding Bond', color = '#ff9e5e', description = 'Enquanto ha aliados por perto, recebe 12% menos dano.' },
                { image = '/images/proficiency/self_reliant.png', name = 'Self-Reliant', color = '#ff9e5e', description = 'Enquanto nao ha aliados por perto, recebe 15% menos dano.' },
                { image = '/images/proficiency/bloodfeast.png', name = 'Bloodfeast', color = '#ff9e5e', description = 'Cura 4% do dano que voce causa.' },
                { image = '/images/proficiency/soul_harvest.png', name = 'Soul Harvest', color = '#ff9e5e', description = '20% de chance ao acertar de restaurar mana igual a 3% do dano causado.' },
                { image = '/images/proficiency/last_stand.png', name = 'Last Stand', color = '#ff9e5e', description = 'Enquanto abaixo de 30% de Vida, recebe 30% menos dano.' },
                { image = '/images/proficiency/thornguard.png', name = 'Thornguard', color = '#ff9e5e', description = 'Reflete 20% do dano fisico recebido de volta ao atacante.' },
                { image = '/images/proficiency/adrenaline.png', name = 'Adrenaline', color = '#ff9e5e', description = 'Enquanto abaixo de 40% de Vida, ganha +12% de Velocidade de Ataque.' },
              }},
              { type = 'divider' },
              { type = 'subtitle', text = 'Perks de Proc (71)', color = '#66aaff' },
              { type = 'cards', items = {
                { image = '/images/proficiency/god_spear.png', name = 'God Spear', color = '#66aaff', description = 'Ataques de arma tem 20% de chance de causar +2% da Vida Maxima do inimigo como dano bonus.' },
                { image = '/images/proficiency/heartseeker.png', name = 'Heartseeker', color = '#66aaff', description = 'Ataques de arma tem 15% de chance de causar +3% da Vida Maxima do inimigo como dano bonus.' },
                { image = '/images/proficiency/head_shot.png', name = 'Head Shot', color = '#66aaff', description = 'Inimigos abaixo de 25% de Vida recebem +80% de dano de voce.' },
                { image = '/images/proficiency/coup_de_grace.png', name = 'Coup de Grace', color = '#66aaff', description = 'Inimigos abaixo de 15% de Vida recebem +150% de dano de voce.' },
                { image = '/images/proficiency/executioners_will.png', name = 'Executioners Will', color = '#66aaff', description = 'Inimigos abaixo de 30% de Vida recebem +60% de dano de voce.' },
                { image = '/images/proficiency/twin_strike.png', name = 'Twin Strike', color = '#66aaff', description = 'Ataques de arma tem 20% de chance de atacar instantaneamente de novo por 70% de dano.' },
                { image = '/images/proficiency/flurry_of_blows.png', name = 'Flurry of Blows', color = '#66aaff', description = 'Ataques de arma tem 14% de chance de atacar instantaneamente de novo por dano total.' },
                { image = '/images/proficiency/rupturing_strike.png', name = 'Rupturing Strike', color = '#66aaff', description = 'Ataques de arma tem 12% de chance de atacar instantaneamente de novo por 120% de dano.' },
                { image = '/images/proficiency/whirlwind.png', name = 'Whirlwind', color = '#66aaff', description = 'Ataques de arma melee tem 25% de chance de atingir todos os inimigos adjacentes por 30% de dano.' },
                { image = '/images/proficiency/seismic_slam.png', name = 'Seismic Slam', color = '#66aaff', description = 'Ataques de arma melee tem 16% de chance de atingir todos os inimigos adjacentes por 45% de dano.' },
                { image = '/images/proficiency/cleaving_arc.png', name = 'Cleaving Arc', color = '#66aaff', description = 'Ataques de arma melee tem 20% de chance de atingir todos os inimigos adjacentes por 25% de dano.' },
                { image = '/images/proficiency/chain_spark.png', name = 'Chain Spark', color = '#66aaff', description = 'Habilidades de dano tem 18% de chance de arquear 65% de dano de energia a um inimigo proximo.' },
                { image = '/images/proficiency/inferno_lash.png', name = 'Inferno Lash', color = '#66aaff', description = 'Habilidades de dano tem 18% de chance de arquear 65% de dano de fogo a um inimigo proximo.' },
                { image = '/images/proficiency/avalanche.png', name = 'Avalanche', color = '#66aaff', description = 'Habilidades de dano tem 18% de chance de arquear 65% de dano de gelo a um inimigo proximo.' },
                { image = '/images/proficiency/earthbind.png', name = 'Earthbind', color = '#66aaff', description = 'Habilidades de dano tem 18% de chance de arquear 65% de dano de terra a um inimigo proximo.' },
                { image = '/images/proficiency/sacred_bolt.png', name = 'Sacred Bolt', color = '#66aaff', description = 'Habilidades de dano tem 18% de chance de arquear 65% de dano sagrado a um inimigo proximo.' },
                { image = '/images/proficiency/parasyte.png', name = 'Parasyte', color = '#66aaff', description = 'Habilidades de dano tem 18% de chance de arquear 65% de dano de morte a um inimigo proximo.' },
                { image = '/images/proficiency/concussive_blow.png', name = 'Concussive Blow', color = '#66aaff', description = 'Ataques de arma tem 10% de chance de atordoar o inimigo por 1.2s.' },
                { image = '/images/proficiency/skullbreaker.png', name = 'Skullbreaker', color = '#66aaff', description = 'Ataques de arma tem 8% de chance de atordoar o inimigo por 1.7s.' },
                { image = '/images/proficiency/stunning_fist.png', name = 'Stunning Fist', color = '#66aaff', description = 'Ataques de arma tem 12% de chance de atordoar o inimigo por 1s.' },
                { image = '/images/proficiency/dread_visage.png', name = 'Dread Visage', color = '#66aaff', description = 'Ataques de arma tem 10% de chance de fazer o inimigo fugir de medo por 2.5s.' },
                { image = '/images/proficiency/nightmare_toll.png', name = 'Nightmare Toll', color = '#66aaff', description = 'Ataques de arma tem 8% de chance de fazer o inimigo fugir de medo por 3s.' },
                { image = '/images/proficiency/horrify.png', name = 'Horrify', color = '#66aaff', description = 'Ataques de arma tem 12% de chance de fazer o inimigo fugir de medo por 2s.' },
                { image = '/images/proficiency/crippling_cut.png', name = 'Crippling Cut', color = '#66aaff', description = 'Ataques de arma tem 25% de chance de aleijar o inimigo (lentidao) por 3s.' },
                { image = '/images/proficiency/glacial_edge.png', name = 'Glacial Edge', color = '#66aaff', description = 'Ataques de arma tem 20% de chance de congelar o inimigo no lugar (lentidao) por 3.5s.' },
                { image = '/images/proficiency/frostbite.png', name = 'Frostbite', color = '#66aaff', description = 'Ataques de arma tem 28% de chance de resfriar o inimigo (lentidao) por 2.5s.' },
                { image = '/images/proficiency/searing_brand.png', name = 'Searing Brand', color = '#66aaff', description = 'Ataques de arma tem 30% de chance de incendiar o inimigo, queimando com o tempo.' },
                { image = '/images/proficiency/cinderbite.png', name = 'Cinderbite', color = '#66aaff', description = 'Ataques de arma tem 22% de chance de infligir queimadura pesada continua.' },
                { image = '/images/proficiency/wildfire.png', name = 'Wildfire', color = '#66aaff', description = 'Ataques de arma tem 26% de chance de incendiar o inimigo, queimando com o tempo.' },
                { image = '/images/proficiency/envenom.png', name = 'Envenom', color = '#66aaff', description = 'Ataques de arma tem 30% de chance de envenenar o inimigo com o tempo.' },
                { image = '/images/proficiency/plaguebearer.png', name = 'Plaguebearer', color = '#66aaff', description = 'Ataques de arma tem 22% de chance de infligir veneno virulento.' },
                { image = '/images/proficiency/toxic_coating.png', name = 'Toxic Coating', color = '#66aaff', description = 'Ataques de arma tem 26% de chance de cobrir seus golpes com veneno.' },
                { image = '/images/proficiency/bloodletter.png', name = 'Bloodletter', color = '#66aaff', description = 'Ataques de arma tem 30% de chance de causar sangramento (dano fisico continuo).' },
                { image = '/images/proficiency/hemorrhage.png', name = 'Hemorrhage', color = '#66aaff', description = 'Ataques de arma tem 26% de chance de causar sangramento severo.' },
                { image = '/images/proficiency/leeching_strikes.png', name = 'Leeching Strikes', color = '#66aaff', description = 'Cura 5% de todo o dano que voce causa.' },
                { image = '/images/proficiency/vampiric_edge.png', name = 'Vampiric Edge', color = '#66aaff', description = 'Cura 3% de todo o dano que voce causa.' },
                { image = '/images/proficiency/spirit_siphon.png', name = 'Spirit Siphon', color = '#66aaff', description = '25% de chance em qualquer dano de restaurar mana igual a 4% do dano causado.' },
                { image = '/images/proficiency/mana_reaver.png', name = 'Mana Reaver', color = '#66aaff', description = '20% de chance em qualquer dano de restaurar mana igual a 5% do dano causado.' },
                { image = '/images/proficiency/overpower.png', name = 'Overpower', color = '#66aaff', description = '25% de chance em qualquer dano de causar +35% de dano bonus.' },
                { image = '/images/proficiency/knight.png', name = 'Knight', color = '#66aaff', description = '20% de chance em qualquer dano de causar +45% de dano bonus.' },
                { image = '/images/proficiency/ruthless_strike.png', name = 'Ruthless Strike', color = '#66aaff', description = '15% de chance em qualquer dano de causar +60% de dano bonus.' },
                { image = '/images/proficiency/solar_flare.png', name = 'Solar Flare', color = '#66aaff', description = 'Habilidades de dano tem 15% de chance de explodir fogo sagrado, causando 25% do golpe como dano sagrado a todos os inimigos adjacentes.' },
                { image = '/images/proficiency/void_collapse.png', name = 'Void Collapse', color = '#66aaff', description = 'Habilidades de dano tem 15% de chance de colapsar energia sombria, causando 25% do golpe como dano de morte a todos os inimigos adjacentes.' },
                { image = '/images/proficiency/dragons_breath.png', name = 'Dragons Breath', color = '#66aaff', description = 'Habilidades de dano tem 15% de chance de soprar fogo, causando 25% do golpe como dano de fogo a inimigos adjacentes.' },
                { image = '/images/proficiency/judgment.png', name = 'Judgment', color = '#66aaff', description = 'Habilidades de dano tem 20% de chance de golpear com luz sagrada por 50% de dano sagrado bonus.' },
                { image = '/images/proficiency/soul_reap.png', name = 'Soul Reap', color = '#66aaff', description = 'Habilidades de dano tem 20% de chance de ceifar a alma por 50% de dano de morte bonus e curar 15% dele.' },
                { image = '/images/proficiency/iron_bulwark.png', name = 'Iron Bulwark', color = '#66aaff', description = '25% de chance de receber 20% menos dano fisico de um golpe recebido.' },
                { image = '/images/proficiency/astral_form.png', name = 'Astral Form', color = '#66aaff', description = '20% de chance de receber 25% menos dano fisico de um golpe recebido.' },
                { image = '/images/proficiency/resilience.png', name = 'Resilience', color = '#66aaff', description = '15% de chance de receber 15% menos dano magico de um golpe recebido.' },
                { image = '/images/proficiency/aegis_reflex.png', name = 'Aegis Reflex', color = '#66aaff', description = '10% de chance de bloquear completamente um golpe recebido.' },
                { image = '/images/proficiency/etheral_form.png', name = 'Etheral Form', color = '#66aaff', description = '6% de chance de bloquear completamente um golpe recebido. +3% Esquiva' },
                { image = '/images/proficiency/life_form.png', name = 'Life Form', color = '#66aaff', description = '8% de chance de bloquear completamente um golpe recebido. +3% Vida Maxima' },
                { image = '/images/proficiency/thorns.png', name = 'Thorns', color = '#66aaff', description = 'Reflete 15% do dano recebido de volta ao atacante. +2% Esquiva' },
                { image = '/images/proficiency/payback.png', name = 'Payback', color = '#66aaff', description = 'Reflete 25% do dano recebido de volta ao atacante.' },
                { image = '/images/proficiency/bramblemail.png', name = 'Bramblemail', color = '#66aaff', description = 'Reflete 20% do dano recebido de volta ao atacante. +2% Bloqueio' },
                { image = '/images/proficiency/counterstrike.png', name = 'Counterstrike', color = '#66aaff', description = '12% de chance de atordoar seu atacante ao ser atingido.' },
                { image = '/images/proficiency/riposte.png', name = 'Riposte', color = '#66aaff', description = '10% de chance de atordoar seu atacante ao ser atingido.' },
                { image = '/images/proficiency/frost_nova.png', name = 'Frost Nova', color = '#66aaff', description = '18% de chance de retardar seu atacante ao ser atingido.' },
                { image = '/images/proficiency/terrifying_visage.png', name = 'Terrifying Visage', color = '#66aaff', description = '10% de chance de fazer seu atacante fugir ao ser atingido.' },
                { image = '/images/proficiency/burning_resolve.png', name = 'Burning Resolve', color = '#66aaff', description = '25% de chance de incendiar seu atacante ao ser atingido.' },
                { image = '/images/proficiency/searing_skin.png', name = 'Searing Skin', color = '#66aaff', description = '20% de chance de incendiar seu atacante ao ser atingido.' },
                { image = '/images/proficiency/second_wind.png', name = 'Second Wind', color = '#66aaff', description = '20% de chance de curar 5% da Vida Maxima ao ser atingido.' },
                { image = '/images/proficiency/lifeward.png', name = 'Lifeward', color = '#66aaff', description = '15% de chance de curar 8% da Vida Maxima ao ser atingido.' },
                { image = '/images/proficiency/battle_trance.png', name = 'Battle Trance', color = '#66aaff', description = '20% de chance de ganhar +12% de Velocidade de Ataque por 4s ao ser atingido.' },
                { image = '/images/proficiency/adrenal_surge.png', name = 'Adrenal Surge', color = '#66aaff', description = '15% de chance de ganhar +18% de Velocidade de Ataque por 5s ao ser atingido.' },
                { image = '/images/proficiency/rallying_cry.png', name = 'Rallying Cry', color = '#66aaff', description = '12% de chance de ganhar +20% de Velocidade de Ataque por 6s ao ser atingido.' },
                { image = '/images/proficiency/bastion_stance.png', name = 'Bastion Stance', color = '#66aaff', description = '20% de chance de ganhar protecao (+15% defesa) por 4s ao ser atingido.' },
                { image = '/images/proficiency/bracing_guard.png', name = 'Bracing Guard', color = '#66aaff', description = '15% de chance de ganhar protecao (+20% defesa) por 5s ao ser atingido.' },
                { image = '/images/proficiency/granite_skin.png', name = 'Granite Skin', color = '#66aaff', description = '12% de chance de ganhar protecao (+25% defesa) por 6s ao ser atingido.' },
                { image = '/images/proficiency/purifying_flame.png', name = 'Purifying Flame', color = '#66aaff', description = '18% de chance de limpar uma condicao negativa ao ser atingido.' },
                { image = '/images/proficiency/mana_shell.png', name = 'Mana Shell', color = '#66aaff', description = '15% de chance de restaurar 10% da Mana Maxima ao ser atingido.' },
              }},
              { type = 'divider' },
              { type = 'subtitle', text = 'Tracos Hibridos (54)', color = '#cc66ff' },
              { type = 'cards', items = {
                { image = '/images/proficiency/glacial_burst.png', name = 'Glacial Burst', color = '#cc66ff', description = 'Habilidades de dano tem 15% de chance de irromper gelo, causando 25% do golpe como dano de gelo a inimigos adjacentes.' },
                { image = '/images/proficiency/arc_storm.png', name = 'Arc Storm', color = '#cc66ff', description = 'Habilidades de dano tem 15% de chance de descarregar raios, causando 25% do golpe como dano de energia a inimigos adjacentes.' },
                { image = '/images/proficiency/toxic_touch.png', name = 'Toxic Touch', color = '#cc66ff', description = 'Habilidades de dano tem 15% de chance de explodir esporos, causando 25% do golpe como dano de terra a inimigos adjacentes.' },
                { image = '/images/proficiency/infernal_touch.png', name = 'Infernal Touch', color = '#cc66ff', description = 'Habilidades de dano tem 20% de chance de queimar o alvo por 50% de dano de fogo bonus.' },
                { image = '/images/proficiency/glacial_spike.png', name = 'Glacial Spike', color = '#cc66ff', description = 'Habilidades de dano tem 20% de chance de perfurar com gelo por 50% de dano de gelo bonus.' },
                { image = '/images/proficiency/spark_strike.png', name = 'Spark Strike', color = '#cc66ff', description = 'Habilidades de dano tem 20% de chance de chocar o alvo por 50% de dano de energia bonus.' },
                { image = '/images/proficiency/venom_blood.png', name = 'Venom Blood', color = '#cc66ff', description = 'Habilidades de dano tem 20% de chance de empalar com terra por 50% de dano de terra bonus.' },
                { image = '/images/proficiency/edge_of_ruin.png', name = 'Edge of Ruin', color = '#cc66ff', description = '+4% Chance de Critico, +8% Dano Fisico' },
                { image = '/images/proficiency/cruel_intent.png', name = 'Cruel Intent', color = '#cc66ff', description = '+8% Dano Fisico, +4% Roubo de Vida' },
                { image = '/images/proficiency/reapers_focus.png', name = 'Reapers Focus', color = '#cc66ff', description = '+4% Chance de Critico, +3% Reducao de Cooldown' },
                { image = '/images/proficiency/deadeye.png', name = 'Deadeye', color = '#cc66ff', description = '+6% Chance de Critico' },
                { image = '/images/proficiency/mortal_verdict.png', name = 'Mortal Verdict', color = '#cc66ff', description = '+4% Chance de Critico, +10% Dano Fisico' },
                { image = '/images/proficiency/hawkeye.png', name = 'Hawkeye', color = '#cc66ff', description = '+6% Chance de Critico' },
                { image = '/images/proficiency/lucky_strike.png', name = 'Lucky Strike', color = '#cc66ff', description = '+4% Chance de Critico, +3% Esquiva' },
                { image = '/images/proficiency/phantom_step.png', name = 'Phantom Step', color = '#cc66ff', description = '+3% Velocidade de Ataque, +2% Esquiva' },
                { image = '/images/proficiency/quickblade.png', name = 'Quickblade', color = '#cc66ff', description = '+4% Velocidade de Ataque, +5% Dano Fisico' },
                { image = '/images/proficiency/berserkers_rage.png', name = 'Berserkers Rage', color = '#cc66ff', description = '+3% Velocidade de Ataque, +3% Chance de Critico' },
                { image = '/images/proficiency/storm_edge.png', name = 'Storm Edge', color = '#cc66ff', description = '+3% Velocidade de Ataque, +4% Dano de Energia' },
                { image = '/images/proficiency/bloodfury.png', name = 'Bloodfury', color = '#cc66ff', description = '+4% Velocidade de Ataque, +5% Roubo de Vida' },
                { image = '/images/proficiency/war_machine.png', name = 'War Machine', color = '#cc66ff', description = '+4% Velocidade de Ataque, +3% Bloqueio' },
                { image = '/images/proficiency/fleetfoot.png', name = 'Fleetfoot', color = '#cc66ff', description = '+4% Velocidade de Ataque, +20 Velocidade de Movimento' },
                { image = '/images/proficiency/duelists_grace.png', name = 'Duelists Grace', color = '#cc66ff', description = '+3% Velocidade de Ataque, +2% Esquiva' },
                { image = '/images/proficiency/bloodfire.png', name = 'Bloodfire', color = '#cc66ff', description = '+4% Chance de Roubo de Vida, +6% Roubo de Vida' },
                { image = '/images/proficiency/crimson_feast.png', name = 'Crimson Feast', color = '#cc66ff', description = '+6% Roubo de Vida, +4% Dano Fisico' },
                { image = '/images/proficiency/dark_pact.png', name = 'Dark Pact', color = '#cc66ff', description = '+3% Chance de Roubo de Vida, +10 regen de HP / 6s' },
                { image = '/images/proficiency/bloodscent.png', name = 'Bloodscent', color = '#cc66ff', description = '+5% Chance de Roubo de Vida, +3% Velocidade de Ataque' },
                { image = '/images/proficiency/hallowed_mending.png', name = 'Hallowed Mending', color = '#cc66ff', description = '+12% Cura Extra, +12 regen de HP / 6s' },
                { image = '/images/proficiency/oblivion.png', name = 'Oblivion', color = '#cc66ff', description = '+8% Roubo de Vida, +5% Vida Maxima' },
                { image = '/images/proficiency/mage_wisdom.png', name = 'Mage Wisdom', color = '#cc66ff', description = '+2 Magic Level, +5% Mana Maxima' },
                { image = '/images/proficiency/soulbound_tome.png', name = 'Soulbound Tome', color = '#cc66ff', description = '+2 Magic Level, +5% Mana Maxima' },
                { image = '/images/proficiency/void_channeling.png', name = 'Void Channeling', color = '#cc66ff', description = '+2 Magic Level, +4% Dano Sagrado' },
                { image = '/images/proficiency/arcane_tempo.png', name = 'Arcane Tempo', color = '#cc66ff', description = '+2 Magic Level, +3% Reducao de Cooldown' },
                { image = '/images/proficiency/spellblade.png', name = 'Spellblade', color = '#cc66ff', description = '+2 Magic Level, +3% Velocidade de Ataque' },
                { image = '/images/proficiency/mana_font.png', name = 'Mana Font', color = '#cc66ff', description = '+4% Chance de Roubo de Mana, +12 regen de MP / 6s' },
                { image = '/images/proficiency/arcane_explosion.png', name = 'Arcane Explosion', color = '#cc66ff', description = '+2 Magic Level, +3% Chance de Critico' },
                { image = '/images/proficiency/sages_helmet.png', name = 'Sages Helmet', color = '#cc66ff', description = '+2 Magic Level, +4% Reducao de Cooldown' },
                { image = '/images/proficiency/apprentices_robe.png', name = 'Apprentices Robe', color = '#cc66ff', description = '+2 Magic Level, +4% Mana Maxima' },
                { image = '/images/proficiency/demonic_circle.png', name = 'Demonic Circle', color = '#cc66ff', description = '+2 Magic Level, +5% Roubo de Vida' },
                { image = '/images/proficiency/pyre_heart.png', name = 'Pyre Heart', color = '#cc66ff', description = '+6% Dano de Fogo' },
                { image = '/images/proficiency/frost_core.png', name = 'Frost Core', color = '#cc66ff', description = '+6% Dano de Gelo' },
                { image = '/images/proficiency/emberhide.png', name = 'Emberhide', color = '#cc66ff', description = '+5% Dano de Fogo, +5% Vida Maxima' },
                { image = '/images/proficiency/flamereaver.png', name = 'Flamereaver', color = '#cc66ff', description = '+4% Dano de Fogo, +5% Roubo de Vida' },
                { image = '/images/proficiency/flame_hands.png', name = 'Flame Hands', color = '#cc66ff', description = '+5% Dano de Fogo, +4% Dano Fisico' },
                { image = '/images/proficiency/permafrost.png', name = 'Permafrost', color = '#cc66ff', description = '+5% Dano de Gelo, +5% Vida Maxima, +5% Mana Maxima' },
                { image = '/images/proficiency/stormcaller.png', name = 'Stormcaller', color = '#cc66ff', description = '+6% Dano de Energia, +3% Velocidade de Ataque' },
                { image = '/images/proficiency/glacial_aegis.png', name = 'Glacial Aegis', color = '#cc66ff', description = '+4% Dano de Gelo, +5% Mana Maxima' },
                { image = '/images/proficiency/necrotic_sigil.png', name = 'Necrotic Sigil', color = '#cc66ff', description = '+6% Dano de Morte' },
                { image = '/images/proficiency/sacred_light.png', name = 'Sacred Light', color = '#cc66ff', description = '+7% Dano Sagrado' },
                { image = '/images/proficiency/stormbrand.png', name = 'Stormbrand', color = '#cc66ff', description = '+5% Dano de Energia, +2% Velocidade de Ataque' },
                { image = '/images/proficiency/hellforged.png', name = 'Hellforged', color = '#cc66ff', description = '+5% Dano de Fogo, +6% Vida Maxima' },
                { image = '/images/proficiency/naturewrath.png', name = 'Naturewrath', color = '#cc66ff', description = '+4% Dano de Gelo, +6% Vida Maxima' },
                { image = '/images/proficiency/ruinous_power.png', name = 'Ruinous Power', color = '#cc66ff', description = '+3 Magic Level, +4% Reducao de Cooldown' },
                { image = '/images/proficiency/shield_mastery.png', name = 'Shield Mastery', color = '#cc66ff', description = 'Dano recebido -15%, Dano causado -25%' },
                { image = '/images/proficiency/healing_mastery.png', name = 'Healing Mastery', color = '#cc66ff', description = '+10% Cura, Dano causado -15%' },
              }},
            }
          },
        }
      },
      crafting = {
        name = 'Crafting',
        subcategories = {
          overview = {
            name = 'Guia de Crafting',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'CRAFTING E PROFISSOES', color = '#ffd75e' },
              { type = 'text', content = 'Equipamento craftado e um caminho central de progressao: receitas de projeto produzem [color=#ffd700]itens pre-melhorados[/color] com stats custom - muitas vezes melhores que drops normais do mesmo tier.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Como conseguir materiais', color = '#66ff99' },
              { type = 'cards', items = {
                { icon = 6500, name = 'Monster Essence', color = '#66ff99', description = 'Farme monstros comuns - toda receita precisa de 30-35.' },
                { icon = 11223, name = 'Boss Essence', color = '#ff6666', description = 'Mate bosses de zona e de masmorra - 2 por craft.' },
                { icon = 29080, name = 'Crystal Fossils', color = '#aaddaa', description = 'Dropam de monstros (chance 1:30, nivel 10+). Extraia cristais com o Crystal Extractor.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Profissoes', color = '#ff9e5e' },
              { type = 'cards', items = {
                { icon = 35768, name = 'Alchemy', color = '#77ff77', description = 'Produza pocoes customizadas. Suba de nivel craftando.' },
                { icon = 29034, name = 'Enchanting', color = '#cc99ff', description = 'Desencante equipamento e crafte runas de stats (tiers azul/verde/amarelo/roxo/vermelho com rolls unicos).' },
                { icon = 3630, name = 'Blacksmith', color = '#ff8888', description = 'Forje armas e armaduras a partir de barras de metal - tipicamente combinada com Mining para conseguir minerio.' },
                { icon = 39962, name = 'Refinery', color = '#ffd75e', description = 'A profissao de gadgets - transforma tabuas de Lenhador e materiais em itens de utilidade: gancho de escalada, espada boomerang, bombas de cola, bandagens, iscas, tendas de acampamento e armas de treino. Dano e cura dos gadgets escalam com seu nivel de Refinaria.' },
                { icon = 6500, name = 'Herbalism', color = '#88cc66', description = 'Colete ervas de nos de erva aleatorios pelo mundo.' },
                { icon = 6500, name = 'Mining', color = '#ccaa77', description = 'Minere minerio de veios aleatorios.' },
                { icon = 6500, name = 'Woodcutting', color = '#aa7744', description = 'Corte arvores para conseguir troncos e refine-os em tabuas - a materia-prima dos gadgets da Refinaria. Concede velocidade de ataque por nivel.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Por que itens craftados sao melhores', color = '#ffd75e' },
              { type = 'text', content = '**Pre-melhorados:** itens de projeto ja saem melhorados, economizando cristais e risco.\n**Stats custom:** eles rolam atributos da tabela de balanceamento de itens (crit, leech, %HP, reducao de cooldown, etc.) - stats reais de end-game, nao armadura plana.\n**Projetos:** aprenda receitas como Fire Sword, Dragonbreath Crossbow, Grievous Axe, Fire Essence Wand e Fragment of Pure Life.' },
            }
          },
          bonuses = {
            name = 'Bonus de Crafting',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'BONUS DE CRAFTING', color = '#ffd75e' },
              { type = 'text', content = 'Itens craftados nao herdam o nivel de um monstro - seu **item level e construido pela receita**, seu nivel de profissao e um pouco de sorte. E por isso que um bom crafter supera drops de monstros.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'De Onde Vem o Item Level', color = '#66ff99' },
              { type = 'text', content = '**1.** Toda receita tem um **tier** que define o item level base - projetos de tier maior produzem iLvl bem mais alto.\n**2.** Seu **nivel de profissao** adiciona item levels em cima de todo craft.\n**3.** Um **roll de raridade** de sorte (Orbital / Forged) empurra o item level ainda mais.\nOs stats sao entao normalizados para o iLvl final, exatamente como um drop do mesmo nivel - mas voce controla o tier.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Qualidade Craftada', color = '#ff9e5e' },
              { type = 'text', content = 'Drops de monstro rolam majoritariamente qualidade Damaged, Worn ou Normal. **Receitas tier 1+ sempre craftam em Superior ou melhor**, e o piso de qualidade continua subindo com seu nivel de profissao - rolls Pristine e Perfect ficam alcancaveis em nivel alto.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'O Que Subir uma Profissao te Da', color = '#cc99ff' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Item Level Maior', color = '#ffd75e', description = 'Cada nivel de profissao adiciona item levels a tudo que voce crafta - seu equipamento escala com sua skill, nao com sorte.' },
                { image = '/images/icons/gem.png', name = 'Melhores Chances de Raridade', color = '#cc99ff', description = 'Receitas por tier rolam raridade com bonus do seu nivel de profissao - mais resultados Orbital e Forged conforme voce sobe.' },
                { image = '/images/icons/crown.png', name = 'Piso de Qualidade Maior', color = '#ffaa55', description = 'O nivel de profissao eleva a qualidade minima dos seus crafts, entao rolls ruins desaparecem com o tempo.' },
                { image = '/images/icons/quest_marker.png', name = 'Desbloqueio de Receitas', color = '#66ff99', description = 'Projetos de tier maior exigem nivel minimo de profissao - subir de nivel abre os crafts mais fortes.' },
                { image = '/images/icons/icon_magic.png', name = 'Runas Mais Fortes', color = '#77ddff', description = 'Encantamento crafta runas especiais cujo item level escala com sua skill de Encantamento.' },
              }},
              { type = 'divider' },
              { type = 'tip', content = 'Todo craft tambem concede experiencia de profissao e Fama - subir profissoes e progresso mesmo quando o item em si nao e um upgrade.' },
            }
          },
          materials = {
            name = 'Materiais',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'title', text = 'MATERIAIS DE CRAFTING', color = '#ffd75e' },
              { type = 'text', content = 'Toda receita pede uma mistura de **essencias**, **produtos coletados** e **pos**. A maioria vem da caca - orbes azuis de loot carregam a maior parte das materias-primas.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Essencias Principais', color = '#66ff99' },
              { type = 'cards', items = {
                { icon = 6500, name = 'Monster Essence', color = '#66ff99', description = 'O material base - quase toda receita precisa. Dropa de monstros e rolls de orbe azul.' },
                { icon = 11223, name = 'Guardian Essence', color = '#ff8888', description = 'Essencia de tier boss exigida por receitas avancadas. Cace bosses de zona e de masmorra.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Essencias Elementais', color = '#77ddff' },
              { type = 'text', content = 'Oito essencias refinadas alimentam receitas de tier medio e alto. Elas **so dropam de monstros de variacao elite** - os que tem prefixo como [Vampiric] ou [Burning]. Cada variacao alimenta exatamente uma essencia, entao cace o prefixo que voce precisa.' },
              { type = 'cards', items = {
                { icon = 40418, name = 'Life Essence', color = '#ff6666', description = 'Dropa de elites [Vampiric].' },
                { icon = 40419, name = 'Mana Essence', color = '#77aaff', description = 'Dropa de elites [Arcane].' },
                { icon = 40421, name = 'Fire Essence', color = '#ff8844', description = 'Dropa de elites [Burning].' },
                { icon = 40422, name = 'Pure Essence', color = '#ffffaa', description = 'Dropa de elites [Sacred] - o drop mais raro.' },
                { icon = 40423, name = 'Ice Essence', color = '#99ddff', description = 'Dropa de elites [Frostbound].' },
                { icon = 40424, name = 'Dark Essence', color = '#aa66cc', description = 'Dropa de elites [Darkness].' },
                { icon = 40425, name = 'Earth Essence', color = '#aadd66', description = 'Dropa de elites [Plagued].' },
                { icon = 40420, name = 'Spirit Essence', color = '#dddddd', description = 'Nunca dropa - so obtida via crafting de Refinamento.' },
              }},
              { type = 'tip', content = 'Cada kill de variacao elite tambem rende uma **Guardian Essence** alem do drop elemental - dois coelhos, uma cacada.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Refinamento e Transmutacao', color = '#ff9e5e' },
              { type = 'text', content = 'A profissao Alquimia pode **fundir essencias em outras essencias** (receitas de Refinamento): combine uma Monster Essence com duas essencias elementais para produzir a que falta. E a unica forma de obter **Spirit Essence**, e **Pure Essence** tambem pode ser fundida se voce tiver uma Guardian Essence sobrando.' },
              { type = 'text', content = '**Transmutacao** vai no sentido contrario: converte essencias em consumiveis - **Vida** vira pocoes de vida, **Mana** vira pocoes de mana e **Espirito** vira pocoes hibridas, em stacks. Transmutacoes de tier maior produzem as versoes poderosas e ate runas de combate.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Profissoes de Coleta', color = '#ccaa77' },
              { type = 'warning', content = 'Nos de coleta estao temporariamente desabilitados enquanto o sistema e retrabalhado - niveis de profissao e seus bonus passivos continuam valendo.' },
              { type = 'cards', items = {
                { icon = 40035, name = 'Mining', color = '#aaaaaa', description = 'Veios de minerio spawnam pelo mundo - cobre primeiro, depois prata, ouro, platina e mythril conforme sua skill sobe. Cada nivel concede passivas de HP.' },
                { icon = 39096, name = 'Herbalism', color = '#88cc66', description = 'Nos de erva rendem plantas para alquimia. Concede passivas de mana por nivel.' },
                { icon = 37763, name = 'Woodcutting', color = '#cc8844', description = 'Corte nos de arvore para materiais de madeira. Concede velocidade de ataque por nivel.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Suprimentos de Encantamento', color = '#cc99ff' },
              { type = 'cards', items = {
                { icon = 13215, name = 'Arcane Powder', color = '#cc99ff', description = 'Po principal de encantamento - tambem necessario para craftar Orbs of Performance.' },
                { icon = 13197, name = 'Mystic Powder', color = '#aa88dd', description = 'Po de grau maior usado em receitas avancadas de augment.' },
                { icon = 29020, name = 'Enchanting Powder', color = '#ddbbff', description = 'Po base para crafting de runas.' },
                { icon = 33201, name = 'Crystal Essences', color = '#77ddff', description = 'Cinco cores - azul, verde, roxo, vermelho e amarelo. Drops raros usados em receitas de cristal.' },
                { icon = 35377, name = 'Empty Enchanting Runes', color = '#ffff88', description = 'Pedras de runa em branco - o item base de toda runa craftada.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Desencantando (Enchanters Rod)', color = '#ddbbff' },
              { type = 'text', content = 'A **Enchanters Rod** destroi um item para recuperar materiais dele. O que voce ganha depende do que desencanta - e todo desencanto concede **experiencia de Encantamento**.' },
              { type = 'cards', items = {
                { icon = 7735, name = 'Itens de Raridade', color = '#cc99ff', description = 'Desencante itens **Orbital**, **Forged** ou **unique** para Arcane Powder (comum), Mystic Powder e Crystal Essences coloridas. Raridade maior multiplica toda chance de drop - unicos pagam mais. Itens comuns nao podem ser desencantados.' },
                { icon = 26170, name = 'Prismatic Cubes', color = '#77ddff', description = 'Cubos nao dao pos - desencantar um rende **Empty Enchanting Runes**, a materia-prima do crafting de runas.' },
              }},
              { type = 'text', content = 'Existem **tres receitas de cubo**, cada uma escondendo um pool de runas diferente: o cubo basico (Arcane Powder) dropa runas **Pelagos** e **Magellan**, o cubo medio (Arcane + Mystic) dropa **Elysium** e **Eldric**, e o cubo alto (Mystic Powder) dropa **Solstice** e **Euphoria**.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Ingredientes de Alquimia', color = '#77ff77' },
              { type = 'cards', items = {
                { icon = 39093, name = 'Rough Leather', color = '#ccaa77', description = 'Drop de orbe azul - receitas de alquimia e equipamento.' },
                { icon = 39094, name = 'Ember & Fire Leaf', color = '#ff8844', description = 'Drops de orbe azul - ingredientes de alquimia de tema fogo.' },
                { icon = 39161, name = 'Valuable Pouches', color = '#ffd75e', description = 'Drop de orbe azul - desmanche em materiais extras.' },
              }},
              { type = 'divider' },
              { type = 'tip', content = 'Lembre do farm de orbe azul enquanto caca - um par de orbes geralmente cobre um craft inteiro.' },
            }
          },
        }
      },

      prestige = {
        name = 'Modos de Prestigio',
        subcategories = {
          overview = {
            name = 'Guia de Prestigio',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'DESAFIOS DE PRESTIGIO', color = '#ffd75e' },
              { type = 'text', content = 'Prestigio reseta seu personagem para uma run de desafio com recompensas permanentes. Seus [color=#ffd700]pets, codex, conquistas e projetos sao preservados[/color] em todo prestigio.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Os Modos', color = '#66aaff' },
              { type = 'cards', items = {
                { image = '/images/icons/repeat.png', name = 'Prestigio Normal', color = '#77ff77',
                  description = 'Requer nivel 300. Reseta para nivel 8 com [color=#ffd700]+20% exp[/color]. Chegue a 300 de novo para completar: 50k gold + 5k fama + 5k codex.' },
                { image = '/images/icons/skull.png', name = 'Hardcore', color = '#ff4444',
                  description = 'Comece nivel 10 ou menor, reseta para 1. [color=#ff8888]UMA VIDA - morrer deleta o personagem.[/color] Meta: nivel 200. Recompensa: 100k gold + 10k fama + 15k codex.' },
                { image = '/images/icons/treasure.png', name = 'High Risk', color = '#ffaa55',
                  description = 'Comece nivel 10 ou menor, reseta para 1. +15% exp, rolls de loot bonus, +20% chance de orbe azul. Mas morrer dropa sua mochila + 1 item equipado num bau E custa 2x de exp perdida. Meta: 300. Recompensa: 50k + 5k + 7.5k codex (pago ao iniciar).' },
                { image = '/images/icons/shield-divided-four_16769380.png', name = 'Iron Man', color = '#aaaaaa',
                  description = 'Comece nivel 10 ou menor, reseta para 8. UMA VIDA + apenas espacos de arma/escudo permitidos - todos os espacos de armadura travados. Meta: 200. Recompensa: 150k + 12k fama + 10k codex.' },
                { image = '/images/icons/flame.png', name = 'Nightmare I', color = '#cc66ff',
                  description = 'Comece nivel 10 ou menor, a conta precisa de um char nivel 100+. +80% dano recebido. Meta: 300. Recompensa: 75k + 7.5k + 10k codex.' },
                { image = '/images/icons/flame.png', name = 'Nightmare II', color = '#aa44dd',
                  description = '+100% dano recebido, -30% dano causado. Meta: 300. Recompensa: 150k + 12k + 20k codex.' },
                { image = '/images/icons/flame.png', name = 'Nightmare III', color = '#8811cc',
                  description = '+120% dano recebido, -50% dano causado, [color=#ff8888]UMA VIDA.[/color] Meta: 300. Recompensa: 250k + 20k + 30k codex.' },
              }},
              { type = 'warning', content = 'Hardcore, Iron Man e Nightmare III sao modos de vida unica: uma morte deleta o personagem permanentemente. Escolha com cuidado!' },
            }
          },
        }
      },

      codex = {
        name = 'Codex',
        subcategories = {
          collection = {
            name = 'Colecao',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'Colecao do Codex' },
              { type = 'divider' },
              { type = 'text', content = 'O Codex e um sistema de colecao de cartas: monstros dropam **cartas e caixas** que alimentam seu Deck com bonus passivos e ativados. Sao **104 cartas unicas** para colecionar.' },
              { type = 'image', path = '/images/wiki/codex_overview.png', width = 400, height = 267 },
              { type = 'spacer', height = 8 },
              { type = 'subtitle', text = 'Raridades de Carta' },
              { type = 'cards', items = {
                { image = '/images/ui/rarity_white.png', name = 'Comum', color = '#dfdfdf', description = 'Efeitos basicos - as cartas mais faceis de obter.' },
                { image = '/images/ui/rarity_blue.png', name = 'Rara', color = '#58a6ff', description = 'Efeitos mais fortes, taxa de drop moderada.' },
                { image = '/images/ui/rarity_purple.png', name = 'Epica', color = '#c678dd', description = 'Efeitos poderosos que viabilizam builds.' },
                { image = '/images/ui/rarity_yellow.png', name = 'Lendaria', color = '#ffa940', description = 'Efeitos que mudam o jogo, os mais dificeis de rolar.' },
              }},
              { type = 'image', path = '/images/wiki/codex_card_rarities.png', width = 400, height = 200 },
              { type = 'spacer', height = 8 },
              { type = 'subtitle', text = 'Duplicatas e EXP' },
              { type = 'text', content = 'Cartas duplicadas dao EXP a carta que voce tem - **Comum 100 / Rara 200 / Epica 300 / Lendaria 500** EXP. Se a carta ja esta no nivel maximo do tier da caixa, duplicatas viram **Essencias de Codex**.' },
              { type = 'subtitle', text = 'Tipos de Ativacao' },
              { type = 'text', content = 'As cartas ativam em condicoes diferentes - mostradas no tooltip de cada carta: **Passiva** (sempre ativa), **Ao Matar**, **Ao Curar**, **Ao Lancar Feitico**, **Ao Lancar Feitico de Ataque**, **Ao Lancar Feitico de Cura**, **Ao Curar Aliado**, **Ao Critar**, **Em HP Baixo**, **Ao Morrer**, **Ao Dash**, **Ao Escudar** e **Ao Pensar** (periodica).' },
              { type = 'image', path = '/images/wiki/codex_trigger_examples.png', width = 330, height = 200 },
            }
          },
          deck = {
            name = 'Deck',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'title', text = 'Seu Deck' },
              { type = 'divider' },
              { type = 'text', content = 'Cartas so funcionam enquanto **equipadas** no seu Deck. Voce tem **6 espacos**, desbloqueados progressivamente:' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Espacos 1-3', description = 'Espaco 1 gratis - Espaco 2 no **Nivel 80** - Espaco 3 no **Nivel 150**.' },
                { image = '/images/icons/fame.png', name = 'Espacos 4-5', description = 'Desbloqueia no **Nivel Paragon 1** e **Nivel Paragon 50**.' },
                { image = '/images/icons/crown.png', name = 'Espaco 6', description = 'Somente **conta premium**.' },
                { image = '/images/codex/essence_icon.png', name = 'Desbloqueio Antecipado', description = 'Desbloqueie o proximo espaco antes com essencias: **500, dobrando a cada vez** (1000, 2000...).' },
              }},
              { type = 'warning', content = 'Cartas paradas na sua Colecao nao dao **nenhum bonus** - equipe-as na aba Deck.' },
              { type = 'subtitle', text = 'Montando um Deck' },
              { type = 'text', content = [[**DPS:** Critical Surge, The Witch, Glass Cannon, The Dragon, Guns Lover, The Gunner, Svarog, Zeus
**Tank/Sobrevivencia:** Golem, The Phoenix, The Behemoth, The Slime, Water Elemental, Soul Leech
**Healer:** Undine, The Elf, Archangel, Blood Link, Blossom Dragon, The Naga
**Utilidade:** Executioner (cooldown), Essence Reaver (farm de essencia), The Child (EXP), Carnage Presence]] },
              { type = 'tip', content = 'Cartas de dragao tem sinergia com Dragon Lord. Cartas de healer como Blood Link so ativam ao curar **membros da party**.' },
            }
          },
          crates = {
            name = 'Caixas',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'title', text = 'Caixas de Cartas' },
              { type = 'divider' },
              { type = 'text', content = 'Crafte caixas na aba Crates com **Essencias de Codex**, ou pegue-as de monstros e elites. Caixas maiores rolam raridades melhores e niveis de carta maiores.' },
              { type = 'cards', items = {
                { image = '/images/codex/bronzecrate.png', name = 'Caixa de Bronze - 100 essencias', color = '#cd7f32', description = 'Cartas ate **nivel 2**. Comum 70% / Rara 20% / Epica 8% / Lendaria 2%. 25% de chance de +50 essencias bonus.' },
                { image = '/images/codex/silver-crate.png', name = 'Caixa de Prata - 200 essencias', color = '#c0c0c0', description = 'Cartas ate **nivel 3**. Comum 60% / Rara 25% / Epica 10% / Lendaria 5%. 30% de chance de +80 essencias bonus.' },
                { image = '/images/codex/golden-crate.png', name = 'Caixa Dourada - 350 essencias', color = '#ffd75e', description = 'Cartas ate **nivel 5**. Comum 30% / Rara 30% / Epica 30% / Lendaria 10%. 35% de chance de +120 essencias bonus.' },
              }},
              { type = 'image', path = '/images/wiki/codex_crates.png', width = 400, height = 267 },
              { type = 'spacer', height = 8 },
              { type = 'tip', content = 'Voce ganha **1 Caixa de Bronze gratis a cada 15 niveis de personagem**. Ofertas do Quadro de Tarefas tambem rolam caixas - tarefas Lendarias podem dropar qualquer tier.' },
            }
          },
          upgrade = {
            name = 'Upgrade',
            type = 'rich_text',
            order = 4,
            sections = {
              { type = 'title', text = 'Melhorando Cartas' },
              { type = 'divider' },
              { type = 'text', content = 'Gaste **Essencias de Codex** na aba Upgrade para levar uma carta ao proximo nivel - **1 essencia = 10 EXP de carta**. Nivel maximo e **10** (cartas de caixa podem comecar com cap menor).' },
              { type = 'image', path = '/images/wiki/codex_level_comparison.png', width = 380, height = 238 },
              { type = 'spacer', height = 8 },
              { type = 'subtitle', text = 'Fontes de Essencia' },
              { type = 'cards', items = {
                { image = '/images/codex/essence_icon.png', name = 'Farm', description = 'Kills de monstros e elites, rolls bonus de caixa, recompensas de tarefa.' },
                { image = '/images/icons/repeat.png', name = 'Duplicatas no Maximo', description = 'Duplicatas de cartas no cap da caixa viram essencias direto.' },
                { image = '/images/icons/icon_magic.png', name = 'Pocao do Conhecimento', description = '+50% de ganho de essencia enquanto o buff da pocao durar.' },
              }},
              { type = 'tip', content = 'Farme caixas de tier menor para renda de essencia - cartas comuns maximizadas transformam toda duplicata em essencias.' },
            }
          },
        }
      },

      achievements = {
        name = 'Conquistas',
        subcategories = {
          overview = {
            name = 'Guia de Conquistas',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'CONQUISTAS', color = '#ffd75e' },
              { type = 'text', content = 'Mais de [color=#ffd700]215 conquistas[/color] recompensam pontos de conquista, titulos e itens. O progresso e preservado atraves do prestigio.' },
              { type = 'divider' },
              { type = 'subtitle', text = 'Categorias', color = '#66aaff' },
              { type = 'text', content = '**Combate** - kills, bosses, crits\n**Tarefas e Diarias** - quadro de tarefas e conclusoes diarias\n**Crafting e Profissoes** - receitas e niveis de profissao\n**Coleta** - nos de erva/veio/arvore/poco\n**Pets** - colecao e niveis\n**Codex** - cartas, caixas, marcos de deck\n**Masmorras** - conclusoes e runs com mutador\n**Paragon / Prestigio** - marcos de end-game\n**Proficiencia** - desbloqueios de tracos\n**Exploracao e Social** - descoberta de mapa, guild, party\n**Skills, Colecao, Captura, Forja, Especial**' },
              { type = 'tip', content = 'Pontos de conquista contam para titulos e recompensas de marco - confira a janela de Conquistas para progresso e botoes de resgate.' },
            }
          },
        }
      },
      pets = {
        name = 'Pets',
        subcategories = {
          epic_pets = {
            name = 'Pets Epicos',
            type = 'pets',
            order = 4,
            items = {
              { name = 'Bebe Pesadelo', outfitId = 321, rarity = 'Epica', element = 'Fogo', collector = 'Colecionador Sinistro',
                abilities = { { name = 'Chamas do Pesadelo', description = 'Dano de fogo + efeito de medo nos inimigos' } } },
              { name = 'Bebe Prisma', outfitId = 2116, rarity = 'Epica', element = 'Multi-elemento', collector = 'Colecionador Paleta / Mitico',
                abilities = { { name = 'Raio Prismatico', description = 'Dispara um raio laser multi-elemento' } } },
              { name = 'Terroc', outfitId = 2200, rarity = 'Epica', element = 'Energia', collector = 'Colecionador Mitico',
                abilities = { { name = 'Golpe de Trovao', description = 'Dano de energia em area + atordoamento' } } },
              { name = 'Espectro', outfitId = 1588, rarity = 'Epica', element = 'Morte', collector = 'Colecionador Sinistro',
                abilities = { { name = 'Devorar Alma', description = 'Dano de morte + efeito de roubo de vida' } } },
              { name = 'Anjo Alado', outfitId = 1324, rarity = 'Epica', element = 'Sagrado', collector = 'Colecionador Mitico',
                abilities = { { name = 'Ira Divina', description = 'Dano sagrado em area + cura' } } },
              { name = 'A Coisa', outfitId = 1353, rarity = 'Epica', element = 'Morte', collector = 'Colecionador Mitico',
                abilities = { { name = 'Devorar', description = 'Ataque melee com roubo de vida (cura o dono em 20% do dano causado)' } } },
              { name = 'Bebe', outfitId = 1267, rarity = 'Epica', element = 'Fisico', collector = 'Especial',
                abilities = {
                  { name = 'Grito Guardiao', description = '+5% em todas as resistencias por 8s' },
                  { name = 'Birra', description = 'Paralisia em area nos inimigos proximos' }
                } },
              { name = 'Peludo', outfitId = 1263, rarity = 'Epica', element = 'Fisico', collector = 'Especial',
                abilities = { { name = 'Abraco Quente', description = '+8% resistencia fisica e regen de HP por 10s' } } },
              { name = 'Bob 1', outfitId = 1562, rarity = 'Epica', element = 'Fisico', collector = 'Especial',
                abilities = { { name = 'Desafio', description = 'Desafio + buff' } } },
              { name = 'Bob 2', outfitId = 1561, rarity = 'Epica', element = 'Fisico', collector = 'Especial',
                abilities = { { name = 'Desafio', description = 'Desafio + buff' } } },
            }
          },
          rare_pets = {
            name = 'Pets Raros',
            type = 'pets',
            order = 3,
            items = {
              { name = 'Bebe Fenix de Fogo', outfitId = 1978, rarity = 'Rara', element = 'Fogo', collector = 'Colecionador Mitico',
                abilities = { { name = 'Aura de Chamas', description = 'Dano de fogo em area + buff de 10% dano de fogo por 8s' } } },
              { name = 'Bebe Fenix de Gelo', outfitId = 1977, rarity = 'Rara', element = 'Gelo', collector = 'Colecionador Mitico',
                abilities = { { name = 'Onda de Gelo', description = 'Dano de gelo em area + retarda inimigos' } } },
              { name = 'Bebe Dragao Mistico', outfitId = 2173, rarity = 'Epica', element = 'Sagrado/Gelo', collector = 'Colecionador Mitico',
                abilities = { { name = 'Sopro Mistico', description = 'Dano combinado sagrado + gelo' } } },
              { name = 'Filhote de Lobo', outfitId = 1709, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Uivo', description = 'Buff de dano de ataque para a party' } } },
              { name = 'Mumia Velha', outfitId = 2223, rarity = 'Rara', element = 'Morte', collector = 'Colecionador Sinistro',
                abilities = { { name = 'Maldicao', description = 'DoT de morte + reduz cura' } } },
              { name = 'Fantasma Verde', outfitId = 566, rarity = 'Rara', element = 'Morte', collector = 'Colecionador Sinistro',
                abilities = { { name = 'Toque Espectral', description = 'Dano de morte + lentidao' } } },
              { name = 'Darkin', outfitId = 1887, rarity = 'Rara', element = 'Morte', collector = 'Colecionador Sinistro',
                abilities = { { name = 'Golpe Sombrio', description = 'Dano de morte a distancia' } } },
              { name = 'Fada', outfitId = 983, rarity = 'Rara', element = 'Sagrado', collector = 'Colecionador Mitico / Paleta',
                abilities = { { name = 'Po de Fada', description = 'Cura + buff no dono' } } },
              { name = 'Slime dos Sonhos', outfitId = 1597, rarity = 'Rara', element = 'Sagrado', collector = 'Colecionador Paleta',
                abilities = { { name = 'Nevoa dos Sonhos', description = 'Efeito de sono + cura' } } },
              { name = 'Pequena Libelula', outfitId = 528, rarity = 'Rara', element = 'Energia', collector = 'Colecionador Mitico',
                abilities = { { name = 'Raio', description = 'Dano de energia a distancia' } } },
              { name = 'Gato Dourado', outfitId = 2005, rarity = 'Incomum', element = 'Sagrado', collector = 'Colecionador Paleta',
                abilities = { { name = 'Arranhao Divino', description = 'Dano sagrado melee' } } },
              { name = 'Bebe Anjo', outfitId = 1326, rarity = 'Epica', element = 'Sagrado', collector = 'Colecionador Mitico',
                abilities = { { name = 'Bencao', description = 'Cura + buff no dono' } } },
              { name = 'Bebe Frazzlemaw', outfitId = 594, rarity = 'Rara', element = 'Fogo', collector = 'Colecionador Mitico',
                abilities = { { name = 'Bola de Fogo', description = 'Dano de fogo a distancia' } } },
              { name = 'Bebe Vector', outfitId = 680, rarity = 'Rara', element = 'Energia', collector = 'Colecionador Mitico',
                abilities = { { name = 'Raio Vector', description = 'Dano de laser de energia' } } },
              { name = 'Bebe Rex', outfitId = 2168, rarity = 'Epica', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Rugido', description = 'Buff fisico de dano' } } },
              { name = 'Elemental do Ar', outfitId = 1354, rarity = 'Comum', element = 'Energia', collector = 'Colecionador Mitico',
                abilities = { { name = 'Explosao de Ar', description = 'Empurrao de energia + dano' } } },
              { name = 'Bebe Elemental', outfitId = 2075, rarity = 'Incomum', element = 'Energia', collector = 'Colecionador Mitico',
                abilities = { { name = 'Faisca', description = 'Dano de energia a distancia' } } },
              { name = 'Abelha Rainha', outfitId = 1758, rarity = 'Rara', element = 'Veneno', collector = 'Colecionador de Insetos',
                abilities = { { name = 'Enxame de Abelhas', description = 'Dano de veneno multiplo' } } },
              { name = 'Leao', outfitId = 41, rarity = 'Rara', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Rugido Majestoso', description = 'Buff de ataque para a party' } } },
            }
          },
          uncommon_pets = {
            name = 'Pets Incomuns',
            type = 'pets',
            order = 2,
            items = {
              { name = 'Galinha Roxa', outfitId = 2172, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Chef',
                abilities = { { name = 'Bicada Aprimorada', description = 'Melee fisico mais forte' } } },
              { name = 'Bebe Lula', outfitId = 451, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Aquatico',
                abilities = { { name = 'Nuvem de Tinta', description = 'Cegueira + dano fisico' } } },
              { name = 'Caranguejo', outfitId = 112, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Aquatico / Chef',
                abilities = { { name = 'Golpe de Pinca', description = 'Dano fisico melee' } } },
              { name = 'Aranha Negra', outfitId = 1482, rarity = 'Incomum', element = 'Terra', collector = 'Colecionador de Insetos',
                abilities = { { name = 'Cuspe Acido', description = 'Dano de terra a distancia' } } },
              { name = 'Inseto de Sangue', outfitId = 1888, rarity = 'Rara', element = 'Morte', collector = 'Colecionador de Insetos',
                abilities = { { name = 'Dreno de Sangue', description = 'Ataque com roubo de vida' } } },
              { name = 'Coelhinho', outfitId = 1821, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Chef',
                abilities = { { name = 'Pulo Rapido', description = 'Ataque de salto + velocidade' } } },
              { name = 'Ovelha', outfitId = 1481, rarity = 'Rara', element = 'Fisico', collector = 'Colecionador Chef',
                abilities = { { name = 'Investida', description = 'Ataque de investida' } } },
              { name = 'Borboleta Noturna', outfitId = 363, rarity = 'Incomum', element = 'Energia', collector = 'Colecionador Paleta',
                abilities = { { name = 'Flash Noturno', description = 'Dano de energia' } } },
              { name = 'Slime Sombrio', outfitId = 1960, rarity = 'Incomum', element = 'Morte', collector = 'Colecionador Sinistro',
                abilities = { { name = 'Pulso Sombrio', description = 'Dano de morte em area' } } },
              { name = 'Geleia Geleia', outfitId = 452, rarity = 'Incomum', element = 'Gelo', collector = 'Colecionador Aquatico',
                abilities = { { name = 'Quicada de Geleia', description = 'Gelo + empurrao' } } },
              { name = 'Bebe Tartaruga Gemea', outfitId = 2103, rarity = 'Epica', element = 'Gelo', collector = 'Colecionador Aquatico',
                abilities = { { name = 'Casco Gemeo', description = 'Buff de defesa dupla' } } },
              { name = 'Escaravelho', outfitId = 83, rarity = 'Incomum', element = 'Terra', collector = 'Colecionador de Insetos',
                abilities = { { name = 'Golpe Subterraneo', description = 'Dano de terra' } } },
              { name = 'Larva Insectoide', outfitId = 82, rarity = 'Incomum', element = 'Veneno', collector = 'Colecionador de Insetos',
                abilities = { { name = 'Explosao de Larva', description = 'Veneno em area' } } },
              { name = 'Bebe Dworc', outfitId = 216, rarity = 'Rara', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Golpe de Clava', description = 'Melee fisico' } } },
              { name = 'Bebe Eyeboh', outfitId = 109, rarity = 'Rara', element = 'Morte', collector = 'Colecionador Sinistro',
                abilities = { { name = 'Olho Maligno', description = 'Morte a distancia' } } },
              { name = 'Goblin', outfitId = 1692, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Arremesso de Lanca', description = 'Fisico a distancia' } } },
              { name = 'Gumateddy', outfitId = 313, rarity = 'Epica', element = 'Fisico', collector = 'Colecionador Paleta',
                abilities = { { name = 'Abraco', description = 'Cura aliado' } } },
              { name = 'Pinguim', outfitId = 2211, rarity = 'Incomum', element = 'Gelo', collector = 'Colecionador Aquatico',
                abilities = { { name = 'Deslize no Gelo', description = 'Gelo + deslize' } } },
              { name = 'Coruja Branca', outfitId = 2220, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Golpe de Garra', description = 'Fisico voador' } } },
            }
          },
          common_pets = {
            name = 'Pets Comuns',
            type = 'pets',
            order = 1,
            items = {
              { name = 'Gato Branco', outfitId = 2027, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Paleta',
                abilities = { { name = 'Arranhao', description = 'Ataque melee basico' } } },
              { name = 'Gato Cinza', outfitId = 2026, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Paleta',
                abilities = { { name = 'Arranhao', description = 'Ataque melee basico' } } },
              { name = 'Gato Preto', outfitId = 2024, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Paleta / Sinistro',
                abilities = { { name = 'Garra Sombria', description = 'Melee fisico' } } },
              { name = 'Galinha', outfitId = 111, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Chef',
                abilities = { { name = 'Bicada', description = 'Ataque melee basico' } } },
              { name = 'Galo', outfitId = 1937, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Chef',
                abilities = { { name = 'Cocorico', description = 'Ataque de chamado' } } },
              { name = 'Vespa', outfitId = 1992, rarity = 'Incomum', element = 'Veneno', collector = 'Colecionador de Insetos',
                abilities = { { name = 'Ferrao Venenoso', description = 'Veneno a distancia' } } },
              { name = 'Gaivota', outfitId = 223, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Bombardeio', description = 'Atordoamento + dano' } } },
              { name = 'Fantasma', outfitId = 1273, rarity = 'Comum', element = 'Morte', collector = 'Colecionador Sinistro',
                abilities = { { name = 'Assombrar', description = 'Dano de morte' } } },
              { name = 'Tartaruga', outfitId = 1841, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Aquatico',
                abilities = { { name = 'Defesa de Casco', description = 'Buff de defesa' } } },
              { name = 'Slime Aquatico', outfitId = 1901, rarity = 'Incomum', element = 'Gelo', collector = 'Colecionador Aquatico',
                abilities = { { name = 'Onda de Gelo', description = 'Gelo em area' } } },
              { name = 'Aranha da Areia', outfitId = 1895, rarity = 'Comum', element = 'Terra', collector = 'Colecionador de Insetos',
                abilities = { { name = 'Teia Venenosa', description = 'Veneno + lentidao' } } },
              { name = 'Inseto', outfitId = 45, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador de Insetos',
                abilities = { { name = 'Mordida', description = 'Melee basico' } } },
              { name = 'Cervo', outfitId = 1805, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Investida de Chifres', description = 'Investida fisica' } } },
              { name = 'Raposa', outfitId = 1296, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Mordida Rapida', description = 'Melee rapido' } } },
              { name = 'Esquilo', outfitId = 274, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Selvagem / Chef',
                abilities = { { name = 'Arremesso de Noz', description = 'Fisico a distancia' } } },
              { name = 'Texugo', outfitId = 105, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Golpe Escavador', description = 'Fisico de terra' } } },
              { name = 'Gamb', outfitId = 106, rarity = 'Comum', element = 'Veneno', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Nuvem Fedida', description = 'Veneno em area' } } },
              { name = 'Papagaio Fogovendaval', outfitId = 217, rarity = 'Incomum', element = 'Fogo', collector = 'Colecionador Paleta',
                abilities = { { name = 'Rajada de Fogo', description = 'Fogo a distancia' } } },
              { name = 'Flamingo', outfitId = 212, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Paleta',
                abilities = { { name = 'Tapa de Asa', description = 'Melee fisico' } } },
              { name = 'Filhote de Urso', outfitId = 1716, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Garrada', description = 'Fisico em area' } } },
              { name = 'Filhote de Javali', outfitId = 1286, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Investida', description = 'Investida fisica' } } },
              { name = 'Bebe Poodle', outfitId = 467, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Paleta',
                abilities = { { name = 'Latido', description = 'Fisico a distancia' } } },
              { name = 'Cachorro', outfitId = 32, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Mordida', description = 'Melee fisico' } } },
              { name = 'Husky', outfitId = 258, rarity = 'Comum', element = 'Gelo', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Uivo de Gelo', description = 'Gelo em area' } } },
              { name = 'Rato', outfitId = 1886, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Mordiscada', description = 'Melee rapido' } } },
              { name = 'Cachorro Velho', outfitId = 1806, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Mordida Velha', description = 'Melee fraco' } } },
              { name = 'Pombinho', outfitId = 531, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Bicada Voadora', description = 'Melee voador' } } },
              { name = 'Bebe Corvo', outfitId = 1559, rarity = 'Incomum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Bicada', description = 'Melee voador' } } },
              { name = 'Cobra', outfitId = 1803, rarity = 'Comum', element = 'Veneno', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Mordida Venenosa', description = 'Melee de veneno' } } },
              { name = 'Naja', outfitId = 81, rarity = 'Comum', element = 'Veneno', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Mordida Venenosa', description = 'Melee de veneno' } } },
              { name = 'Caracol', outfitId = 2186, rarity = 'Rara', element = 'Fisico', collector = 'Colecionador de Insetos',
                abilities = { { name = 'Limo Lento', description = 'Rastro de lentidao' } } },
              { name = 'Ra Noturna', outfitId = 412, rarity = 'Incomum', element = 'Veneno', collector = 'Colecionador Aquatico',
                abilities = { { name = 'Cuspe Venenoso', description = 'Veneno a distancia' } } },
              { name = 'Coelho', outfitId = 1821, rarity = 'Comum', element = 'Fisico', collector = 'Colecionador Selvagem',
                abilities = { { name = 'Esquiva Rapida', description = 'Bonus de esquiva (5-15%) por 5s baseado no nivel do pet' } } },
            }
          },
        }
      },
      ascension_guide = {
        name = 'Guia de Ascension',
        subcategories = {
          getting_started = {
            name = 'Primeiros Passos',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'Bem-vindo a Ascension' },
              { type = 'divider' },
              { type = 'text', content = 'Ascension e um servidor **estilo ARPG** construido em torno de progressao profunda: tarefas, talentos, cartas de codex, pets, prestigio e mais. Esta wiki explica cada sistema - aperte **Ctrl+H** ou o botao Wiki para reabri-la quando quiser.' },
              { type = 'subtitle', text = 'Suas Primeiras Prioridades' },
              { type = 'cards', items = {
                { image = '/images/icons/quest_marker.png', name = 'Cace e Faca Tarefas', description = 'Suba de nivel e complete ofertas do **Quadro de Tarefas** - elas sao sua principal fonte de ouro, fama e essencias de codex no inicio.' },
                { image = '/images/icons/bag.png', name = 'Pegue Todo o Loot', description = 'Use o **Stash** e o **Quick Loot** para gerenciar itens. Guarde materiais - quase tudo alimenta um sistema.' },
                { image = '/images/icons/gem.png', name = 'Nao Venda Lixo', description = 'Use o **Recycler** ou o **Sistema de Upgrade** para extrair essencias e materiais de itens indesejados em vez de vende-los.' },
                { image = '/images/icons/icon_sword.png', name = 'Escolha Seu Caminho', description = '**15 vocacoes** incluindo Bard, Tinker, Samurai, Blood Mage e Warden - cada uma com sua arvore de talentos.' },
              }},
              { type = 'subtitle', text = 'Para Onde Ir Depois' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Talentos de Classe', description = 'Ganhe um ponto de talento a cada **8 niveis** e monte sua arvore - veja Talentos de Classe.' },
                { image = '/images/icons/clock.png', name = 'Missoes Diarias', description = 'Oito objetivos rotativos; complete **4+** para uma Caixa Dourada - veja Missoes Diarias.' },
                { image = '/images/icons/wow_zone.png', name = 'Zonas e Eventos', description = 'Zonas de caca rodam buffs e eventos rotativos - veja Zonas e Eventos.' },
              }},
              { type = 'tip', content = 'O progresso nesta wiki e salvo - a barra abaixo mostra quanto voce ja leu.' },
            }
          },
          class_talents = {
            name = 'Talentos de Classe',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'image', path = '/images/wiki/talents_overview.png', width = 400, height = 110 },
              { type = 'title', text = 'O QUE SAO TALENTOS DE CLASSE', color = '#ffd75e' },
              { type = 'text', content = 'Cada vocacao tem sua propria **Constelacao** - uma arvore de talentos feita de tres **eixos** tematicos mais **ramos** de especializacao. Investir pontos em um eixo desbloqueia bonus de marco, e nos dentro de cada ramo concedem stats passivos, efeitos ativados ou ate **novos feiticos**. Talentos se aplicam automaticamente no login.' },
              { type = 'divider' },

              { type = 'title', text = 'COMO A ARVORE FUNCIONA', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/wiki/talent_node.png', name = 'No Central', color = '#ffd75e', description = 'Toda arvore comeca de um no central (como Elemental Attunement) que conecta todos os ramos.' },
                { image = '/images/icons/icon_sword.png', name = 'Tres Eixos', color = '#ff8888', description = 'Eixos de ataque, defesa e utilidade com nomes tematicos por vocacao. Gastar pontos em um eixo desbloqueia efeitos de marco nos seus limites.' },
                { image = '/images/icons/icon_axe.png', name = 'Ramos', color = '#9fe89f', description = 'Cada arvore tem 3 ramos de especializacao - ex.: o Magician se divide em Pyromancy, Cryomancy e Arcana.' },
                { image = '/images/icons/icon_health.png', name = 'Efeitos dos Nos', color = '#66aaff', description = 'Nos concedem stats (condicoes), procs passivos e masteries, ou desbloqueiam feiticos reais como Hand of God ou Arcane Missiles.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'PONTOS DE TALENTO', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Ganhando', color = '#ffd75e', description = 'Voce ganha 1 ponto de talento a cada 5 niveis de personagem.' },
                { image = '/images/icons/icon_axe.png', name = 'Gastando', color = '#9fe89f', description = 'Cada nivel de no custa 1 ponto. Nos tem niveis maximos variados, e nos mais profundos exigem que o no anterior esteja subido primeiro.' },
                { image = '/images/icons/star.png', name = 'Pre-visualizacao', color = '#66aaff', description = 'Voce pode inspecionar cada no e seu efeito na janela de Talentos de Classe antes de gastar pontos.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'RESETANDO SUA ARVORE', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/icons/icon_health.png', name = 'Custo', color = '#ff8888', description = '10 de ouro por ponto gasto para resetar sua arvore inteira.' },
                { image = '/images/icons/crown.png', name = 'Premium', color = '#ffd75e', description = 'Jogadores premium pagam metade: 5 de ouro por ponto gasto.' },
                { image = '/images/icons/star.png', name = 'Reembolso', color = '#9fe89f', description = 'Resetar devolve todo ponto gasto - seus pontos ganhos nunca sao perdidos.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'AS 15 CONSTELACOES', color = '#d4a843' },
              { type = 'text', content = [[**Magician** - Wrath / Aegis / Harmony - Pyromancy, Cryomancy, Arcana
**Templar** - Wrath / Aegis - Reprisal, Guardian, Sacred Healer
**Nightblade** - Cruelty / Evasion / Shadow - Hemorrhage, Shadow Dance, Void Blades
**Dragonknight** - Fury / Scales / Embers - Bloodlust, Draconic Ward, Phoenix Forge
**Warlock** - Blight / Vitality / Summoning - Curses & Plague, Demonic Legion, Blood Pact
**Stellar** - Radiance / Lunarity / Astral - Lunar Fury, Holy Wrath, Celestial Grace
**Monk** - Fury / Stone / Chi - Stormfist, Mountain Path, Vital Chi
**Druid** - Wildgrowth / Verdancy / Frost - Savage Growth, Verdant Healing, Frost Ward
**Light Dancer** - Storm / Ward / Blade - Tempest Gambit, Lightning Guard, Elusive Blade
**Archer** - Ballistics / Frost / Survival - Explosive Arsenal, Frost Hunter, Phantom Marksman
**Bard** - Dissonance / Harmony / Resonance - Dissonant Strike, Melodic Harmony, Reverberating Echo
**Tinker** - Robotics / Demolition / Engineering - Robotics, Demolition, Engineering
**Samurai** - Steel / Iron / Wind - Way of the Sword, Way of the Shield, Way of the Wind
**Blood Mage** - Crimson / Sanguine / Battlemage - Crimson Path, Sanguine Path, Battlemage Path
**Warden** - Earth / Frost / Wilderness - Earthshaker, Frostwarden, Guardian]] },
              { type = 'divider' },
              { type = 'title', text = 'NOS IMPORTANTES', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/wiki/talent_notable.png', name = 'Notavel', color = '#9fe89f', description = 'Nos com moldura de estrela - bonus fortes que valem planejamento.' },
                { image = '/images/wiki/talent_nexus.png', name = 'Nexus', color = '#66aaff', description = 'Nos com moldura de constelacao - juncoes onde ramos se conectam, abrindo novos caminhos na arvore.' },
                { image = '/images/wiki/talent_keystone.png', name = 'Keystone', color = '#ffd75e', description = 'O no grande no fim de cada ramo - o bonus final que define o caminho (Pyromancer, Cryomancer, Arcanist...).' },
              }},
              { type = 'divider' },
              { type = 'tip', content = 'Planeje um ramo primeiro - keystones sao poderosos mas ficam no fim de cada caminho, entao correr tres ramos ao mesmo tempo te deixa fraco em todos.' },
            }
          },
          paragon_ascension = {
            name = 'Ascensao Paragon',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'image', path = '/images/wiki/paragon_overview.png', width = 400, height = 117 },
              { type = 'title', text = 'O QUE E PARAGON', color = '#ffd75e' },
              { type = 'text', content = 'Paragon e o sistema de progressao de endgame que desbloqueia no **Nivel 300**. Ao atingir o cap, todo XP flui para sua barra de Paragon. Cada nivel de Paragon concede um ponto para uma de tres categorias de stats - a categoria rotaciona automaticamente conforme voce sobe.\n\nAbra a aba **Ascension** na janela de Talentos de Classe para ver seu quadro e gastar pontos.' },
              { type = 'divider' },

              { type = 'title', text = 'XP DE PARAGON', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Curva de XP', color = '#ffd75e', description = 'O primeiro nivel precisa de 6,000,000 XP. Cada nivel adiciona +12% do custo base por cima (linear - cerca de 720k a mais por nivel).' },
                { image = '/images/icons/crown.png', name = 'Premium', color = '#9fe89f', description = 'Contas premium ganham +15% de XP de Paragon.' },
                { icon = 40146, name = 'Token de Boost de XP', color = '#66aaff', description = 'Consumivel: +25% XP de Paragon por 1 hora. Requer Nivel Paragon 1 e nao acumula - reative quando expirar.' },
                { image = '/images/icons/icon_health.png', name = 'Penalidade de Morte', color = '#ff8888', description = 'Morrer custa 10% do progresso atual de XP de Paragon - proteja sua barra.' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'ROTACAO DE PONTOS', color = '#d4a843' },
              { type = 'text', content = 'Paragon Nv 1 -> **Primario**, Nv 2 -> **Secundario**, Nv 3 -> **Utilidade**, depois repete. Pontos ganhos nunca expiram - gaste-os quando quiser na aba Ascension.' },
              { type = 'divider' },

              { type = 'title', text = 'PRIMARIO - ATAQUE', color = '#ff8888' },
              { type = 'cards', items = {
                { image = '/images/icons/icon_sword.png', name = 'Dano Fisico', color = '#ff8888', description = '+1% por ponto - cap 150%' },
                { image = '/images/icons/icon_axe.png', name = 'Dano Elemental', color = '#ff8888', description = '+1 fixo por ponto - cap 200' },
                { image = '/images/icons/star.png', name = 'Velocidade de Ataque', color = '#ff8888', description = '+1% por ponto - cap 100%' },
                { image = '/images/icons/crown.png', name = 'Chance de Critico', color = '#ff8888', description = '+1% por ponto - cap 75%' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'SECUNDARIO - DEFESA', color = '#66aaff' },
              { type = 'cards', items = {
                { image = '/images/inventory/inventory_right_hand.png', name = 'Chance de Bloqueio', color = '#66aaff', description = '+1% por ponto - cap 30%' },
                { image = '/images/icons/icon_health.png', name = 'HP Maximo', color = '#66aaff', description = '+50 por ponto - sem cap, investimento seguro de longo prazo' },
                { image = '/images/icons/icon_health.png', name = 'Mana Maxima', color = '#66aaff', description = '+40 por ponto - sem cap' },
                { image = '/images/icons/icon_health.png', name = 'Cura Recebida', color = '#66aaff', description = '+1% por ponto - cap 100%' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'UTILIDADE - PROGRESSAO', color = '#9fe89f' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Ganho de EXP', color = '#9fe89f', description = '+1% por ponto - cap 100%. Acelera o proprio Paragon.' },
                { image = '/images/icons/icon_axe.png', name = 'EXP de Crafting', color = '#9fe89f', description = '+2% por ponto - cap 150%' },
                { image = '/images/icons/crown.png', name = 'Ganho de Fama', color = '#9fe89f', description = '+2% por ponto - cap 100%' },
                { image = '/images/icons/icon_health.png', name = 'Conhecimento do Codex', color = '#9fe89f', description = '+0.2% de chance de ponto de codex por ponto - cap ~10%' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'MARCOS', color = '#d4a843' },
              { type = 'text', content = 'Pontos gastos numa categoria desbloqueiam marcos automaticos. Bonus de dano e HP **substituem** o tier anterior - nao acumulam.' },
              { type = 'cards', items = {
                { image = '/images/icons/icon_sword.png', name = 'Primario', color = '#ff8888', description = '25 pts: titulo "Warrior" - 50: +3% todo dano - 100: +5% - 200: titulo "Paragon of War" +8%' },
                { image = '/images/inventory/inventory_right_hand.png', name = 'Secundario', color = '#66aaff', description = '25 pts: titulo "Guardian" - 50: +5% HP maximo - 100: +8% - 200: titulo "Paragon of Fortitude" +12%' },
                { image = '/images/icons/star.png', name = 'Utilidade', color = '#9fe89f', description = '25 pts: titulo "Explorer" - 50: +3% todos os ganhos - 100: +5% - 200: titulo "Paragon of Fortune" +8%' },
              }},
              { type = 'divider' },

              { type = 'title', text = 'RESETANDO', color = '#d4a843' },
              { type = 'cards', items = {
                { image = '/images/icons/star.png', name = 'Aba Ascension', color = '#9fe89f', description = 'O botao de reset no quadro Paragon devolve todos os pontos alocados de graca.' },
                { icon = 40137, name = 'Pergaminho de Reset', color = '#c080ff', description = 'Item Paragon Reset Scroll: devolve todo ponto alocado. Requer Nivel Paragon 5 e pelo menos um ponto gasto.' },
              }},
              { type = 'divider' },
              { type = 'tip', content = 'A cada 10 niveis de Paragon um broadcast anuncia seu progresso - titulos de marco tambem sao broadcast, entao servem de ostentacao.' },
            }
          },
        }
      },
      currencies = {
        name = 'Moedas',
        subcategories = {
          overview = {
            name = 'Guia de Moedas',
            type = 'rich_text',
            order = 1,
            sections = {
              { type = 'title', text = 'MOEDAS DE ASCENSION', color = '#ffd75e' },
              { type = 'text', content = 'Ascension usa varias moedas para sistemas diferentes. Aqui esta o que cada uma faz e onde consegui-la.' },
              { type = 'divider' },

              { type = 'subtitle', text = 'Moedas Principais', color = '#ffd75e' },
              { type = 'cards', items = {
                { icon = 2148, name = 'Moedas de Ouro', color = '#ffd700',
                  description = 'A moeda principal. Ganha de kills de monstros, [color=#ffd700]Orbes de Ouro[/color], tarefas, recompensas de quest e da Casa de Leiloes. Gasta em lojas de NPC, rerolls/bloqueios de tarefa e taxas de crafting.' },
                { image = '/images/icons/fame_big.png', name = 'Fama', color = '#ff9e5e',
                  description = 'Moeda de progressao da conta com [color=#ffd700]30 niveis[/color] (100 a 715,000 pontos). Ganhe fama de tarefas, eventos de zona, kills de recompensa e premios de prestigio. Gaste nas [color=#ffd700]lojas de NPC de Fama[/color] por itens exclusivos.' },
                { image = '/images/codex/essence_icon.png', name = 'Essencias de Codex', color = '#cc66ff',
                  description = 'Moeda do sistema de cartas Codex. Ganha de kills de monstros, rolls bonus de caixa e cartas duplicadas. Gasta craftando [color=#ffd700]Caixas de Bronze / Prata / Dourada[/color] (100 / 200 / 350), melhorando cartas e desbloqueando espacos de deck cedo.' },
                { image = '/images/icons/star.png', name = 'Pontos de Conquista', color = '#66ccff',
                  description = 'Ganhos ao completar conquistas em 19 categorias. Os pontos desbloqueiam titulos e recompensas de marco.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Essencias de Monstro (materiais de crafting)', color = '#66ff99' },
              { type = 'text', content = 'Dropadas por monstros e usadas como ingredientes para [color=#ffd700]equipamento craftado[/color]. A **Monster Essence** generica e a **Boss Essence** sao exigidas por toda receita de projeto.' },
              { type = 'cards', items = {
                { icon = 6500, name = 'Monster Essence', color = '#66ff99',
                  description = 'Material central de crafting. Dropa de monstros comuns. Toda receita de projeto precisa de 30-35.' },
                { icon = 11223, name = 'Boss Essence', color = '#ff6666',
                  description = 'Material raro de crafting que so dropa de bosses. Projetos exigem 2 por craft.' },
              }},
              { type = 'divider' },

              { type = 'subtitle', text = 'Essencias de Elite', color = '#cc99ff' },
              { type = 'text', content = 'Essencias especiais dropadas por [color=#ffd700]variantes elite de monstros[/color] (os prefixos [entre colchetes] que voce ve nas zonas). Cada variante dropa sua propria essencia de tema elemental, usada em crafting e missoes diarias.' },
              { type = 'cards', items = {
                { icon = 40418, name = 'Life Essence', color = '#ff8888', description = 'De elites [Vampiric].' },
                { icon = 40419, name = 'Mana Essence', color = '#66aaff', description = 'De elites [Arcane].' },
                { icon = 40420, name = 'Spirit Essence', color = '#dddddd', description = 'De elites de tema espirito.' },
                { icon = 40421, name = 'Fire Essence', color = '#ff7733', description = 'De elites [Burning].' },
                { icon = 40422, name = 'Pure Essence', color = '#ffff88', description = 'De elites [Sacred]. Mais rara - missoes diarias pedem apenas 2.' },
                { icon = 40423, name = 'Ice Essence', color = '#77ddff', description = 'De elites [Frostbound].' },
                { icon = 40424, name = 'Dark Essence', color = '#aa66cc', description = 'De elites [Darkness].' },
                { icon = 40425, name = 'Earth Essence', color = '#99cc66', description = 'De elites [Plagued].' },
              }},
              { type = 'tip', content = 'Dica: guarde um stack de cada essencia - Missoes Diarias frequentemente pedem entregas de 5 (2 para Pure Essence).' },
            }
          },
        }
      },
    }
  }
end
