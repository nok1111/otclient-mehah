-- Wiki Data
-- Multilanguage content for the wiki system
-- Add more content here as needed

function getWikiData(language)
  if language == 'es' then
    return getSpanishData()
  elseif language == 'pt' then
    return getPortugueseData()
  else
    return getEnglishData()
  end
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
              { name = 'boots of teleportation', description = '[onUse] Teleport to your targeted position.', icon = 29188 },
              { name = 'boots of the wild', description = '[onUse] Charge to your current targeted enemy.', icon = 29269 },
              { name = 'boots of timewalking', description = '[onUse] Mark your current self and rewind to it after 4 seconds.', icon = 29299 },
              { name = 'boots of winter', description = '[onUse] Place ice traps on the ground while moving that will slow down the enemies.', icon = 3551 },
              { name = 'boots of levitation', description = '[onUse] Levitate into the air removing all paralysed effects and dashing towards the direction you are facing.', icon = 29249 },
              { name = 'boots of the void', description = '[onUse] Instantly trap all nearby enemies in a void field.', icon = 27379 },
              { name = 'boots of the salamander', description = '[onUse] Place fire pillars in your targeted position wich can block line of sight.', icon = 9019 },
              { name = 'boots of the dreamer', description = '[onUse] Restore 15% maximum mana of all nearby friendly players.', icon = 6529 },
              { name = 'magnetic orb', description = 'place a magnetic orb to create a magnetic field that damages nearby enemies', icon = 34086 },
              { name = 'celestial sigil', description = 'Shoots a celestial mark into the targeted position wich deals damage and increases your magic level percent by 20% for 4 seconds', icon = 34068 },
              { name = 'absolute defense', description = 'increase your block chance by 50% and max health by 30% for the next 8 seconds. (requires a shield equiped)', icon = 34096 },
              { name = 'bouncing sphere', description = 'create a bouncing sphere that bounces between you and your target dealing damage and healing yourself, the sphere speed is based on the distance between you and your target', icon = 34088 },
              { name = 'earthquake', description = 'break the ground dealing physical damage to all enemies and stun them for a short period of time', icon = 34087 },
              { name = 'blessed tree', description = 'create a blessed tree in the targeted position, wich restores health and mana to all nearby players if destroyed.', icon = 34076 },
              { name = 'spider web', description = 'throw a spider web on your target wich stuns it for 2 seconds.', icon = 34084 },
              { name = 'meteor', description = 'throw a meteor on your targeted position dealing fire damage to nearby enemies.', icon = 34071 },
              { name = 'water wave', description = 'create 3 water tides wich deal ice damage and stun the enemies for 1 second.', icon = 34113 },
              { name = 'thunder chain', description = 'create a energy chain reaction will travel through all nearby enemies.', icon = 34072 },
              { name = 'water torrent', description = 'create a water torrent wich repell enemies around yourself.', icon = 34097 },
              { name = 'shark teeth', description = 'create a dangerous area wich later will be devoured by a giant shark.', icon = 29924 },
              { name = 'wild vines', description = 'create wild vines around yourself that pulls nearby monsters into you.', icon = 34107 },
              { name = 'quick chains', description = 'send quick chains in the direction aimed and pull in the first enemy reached into you.', icon = 34075 },
              { name = 'boomerang', description = 'Throw a magical boomerang that deals damage in a straight line and returns to you.', icon = 34121 },
              { name = 'wild spikes', description = 'Unleash two wild spikes in front of you, healing yourself and dealing damage to the target.', icon = 29916 },
              { name = 'sniper shot', description = 'A precise, long-range attack that deals damage based on the distance traveled.', icon = 29936 },
              { name = 'thunder leap', description = 'leap into your targeted position dealing damage and stuning nearby enemies for 1 second.', icon = 34109 },
              { name = 'chain of flames', description = 'create a fire chain reaction will travel through all nearby enemies.', icon = 34077 },
              { name = 'toxic spores', description = 'emanate toxic spores poisoning all nearby enemies for 8 seconds.', icon = 29998 },
              { name = 'final sentence', description = 'Setence your target dealing massive holy damage in a small area increasing its damage based on the target\'s missing health.', icon = 29917 },
              { name = 'healing prisma', description = 'Heals you and nearby allies in a wider area', icon = 34110 },
              { name = 'fire tornado', description = 'Summon a raging fire tornado that repeatedly burns enemies in an area and slows their movement.', icon = 34098 },
              { name = 'opelus', description = 'Unleash repeated bursts of energy damage at a target location, striking all enemies in the area multiple times.', icon = 34081 },
              { name = 'voltstorm', description = 'Unleash a storm of constant energy damage at your targeted location, striking all enemies in the area multiple times.', icon = 34101 },
              { name = 'blood aura', description = 'wield a blood aura draining life force from all nearby enemies.', icon = 29918 },
              { name = 'arcane missiles', description = 'Fire 5 arcane missiles that seek random enemies in a 7x7 area, dealing energy damage.', icon = 34073 },
              { name = 'lightning rod', description = 'Place a lightning rod that strikes nearby enemies with chain lightning every second for 6 seconds.', icon = 34074 },
              { name = 'phase shift', description = 'Become intangible for 2 seconds. You cannot attack or be attacked during this time.', icon = 19369 },
              { name = 'rejuvenation', description = 'Regenerate 5% of your maximum health per second for 10 seconds, healing 50% total.', icon = 34094 },
              { name = 'last stand', description = 'When your health drops below 15%, automatically heal 30% of your maximum health. 120 second cooldown.', icon = 34125 },
              { name = 'mana battery', description = 'Convert 20% of your current health into 30% of your maximum mana.', icon = 34124 },
              { name = 'soul reaper', description = 'Every time you kill an enemy within the next 10 seconds, you deal death damage in a small area and restore 8% of your health and mana.', icon = 34106 },
              { name = 'frost nova', description = 'Freeze the ground in a 5x5 area for 8 seconds. Enemies entering are slowed by 70% for 2 seconds.', icon = 34111 }
            }
          },
          runes = {
            name = 'Runas',
            type = 'list',
            order = 2,
            items = {
              { name = 'Runa de Cura Suprema', description = 'Restaura uma grande quantidade de HP', icon = 2273 },
              { name = 'Runa de Grande Bola de Fogo', description = 'Cria uma bola de fogo massiva', icon = 2304 },
              { name = 'Runa de Paralisia', description = 'Paralisa o alvo', icon = 2278 }
            }
          },
          sample = {
            name = 'Categoria de Exemplo 1',
            type = 'list',
            items = {
              { name = 'Item de Exemplo 1', description = 'Este e um item de exemplo para testes', icon = 2160 }
            }
          },
          sample2 = {
            name = 'Categoria de Exemplo 2',
            type = 'list',
            items = {
              { name = 'Item de Exemplo 2', description = 'Outro item de exemplo', icon = 2159 }
            }
          },
          enchantments = {
            name = 'Encantamentos',
            type = 'list',
            items = {
              { name = 'Encantamento de Fogo', description = 'Adiciona dano de fogo a sua arma (+15% dano de fogo)', icon = 2392 },
              { name = 'Encantamento de Gelo', description = 'Adiciona dano de gelo a sua arma (+15% dano de gelo)', icon = 2393 },
              { name = 'Encantamento Sagrado', description = 'Adiciona dano sagrado a sua arma (+15% dano sagrado)', icon = 2394 }
            }
          }
        }
      },
      dungeons = {
        name = 'Masmorras',
        subcategories = {
          dungeon_stones = {
            name = 'Pedras de Teleporte de Masmorras',
            type = 'list',
            items = {
              { name = 'Pedra de Masmorra Demoniaca', description = 'Teleporta para a Masmorra Demoniaca. Nivel requerido: 150', icon = 1950 },
              { name = 'Pedra de Covil do Dragao', description = 'Teleporta para o Covil do Dragao. Nivel requerido: 100', icon = 1951 },
              { name = 'Pedra de Cripta Vampirica', description = 'Teleporta para a Cripta Vampirica. Nivel requerido: 80', icon = 1952 }
            }
          },
          bosses = {
            name = 'Informacao de Chefes',
            type = 'list',
            items = {
              { name = 'Senhor Demonio', description = 'HP: 50,000 | Localizacao: Masmorra Demoniaca | Drops: Armadura Demoniaca', icon = 5080 },
              { name = 'Dragao Ancestral', description = 'HP: 35,000 | Localizacao: Covil do Dragao | Drops: Armadura de Escamas', icon = 5081 },
              { name = 'Principe Vampiro', description = 'HP: 25,000 | Localizacao: Cripta Vampirica | Drops: Escudo Vampirico', icon = 5082 }
            }
          }
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
              { type = 'text', content = [[**O que sao as Missoes Diarias?**

As Missoes Diarias sao 8 tarefas que reiniciam a cada dia, dando objetivos e recompensas consistentes. Abra a janela de Missoes Diarias usando o objeto especial (Daily Task Scroll) para ver suas tarefas ativas, acompanhar seu progresso e resgatar recompensas.

As tarefas sao sorteadas automaticamente a cada dia com dificuldade ponderada: Facil (34%), Media (33%) e Dificil (33%).]] },
              { type = 'image', path = '/images/wiki/daily_tasks_overview.png', width = 400, height = 220 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Categorias de Tarefas**

| Categoria | Descricao | Tipo |
|-----------|-------------|------|
| Kill Zone | Mate monstros em zonas non-PvP, PvP ou PvP-forcado | Auto |
| Boss | Derrote bosses (qualquer um ou especifico) | Auto |
| Dungeon | Complete masmorras | Auto |
| Zone Event | Complete eventos de zona | Auto |
| Tower Floor | Limpe andares da Torre de Deus | Auto |
| Kill Task | Complete tarefas de matar do quadro | Auto |
| Crafting | Entregue itens craftados (Alquimia, Encantamento, Ferraria) | Entregar |
| Gathering | Entregue essencias coletadas de mineracao | Entregar |
| Mixed | Combina multiplas atividades (kills + torre, bosses + masmorras + eventos) | Auto |

As tarefas de **progresso automatico** se atualizam automaticamente enquanto voce joga.
As tarefas de **entrega** requerem que voce tenha os itens no inventario e clique no botao "Entregar".]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Recompensas**

**Por Tarefa Completada:**
- **3 Pontos de Conquista**
- **25 Essencias de Codex**

**Recompensa Diaria Grande (4 completadas):**
- **1 Caixa Dourada de Codex**

A Caixa Dourada pode ser resgatada uma vez por dia depois de completar pelo menos 4 tarefas. Nao esqueca de resgata-la antes do reinicio diario!]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Niveis de Tarefas de Crafting**

As tarefas de crafting escalam com os niveis de profissao:

**Alquimia:**
- Aprendiz: Essencias refinadas, pocoes basicas
- Novato: Pocoes de vida/mana/espirito, frascos pequenos
- Oficial: Pocoes fortes, frascos e elixires de nivel medio
- Mestre: Grandes pocoes
- Grao-Mestre: Grandes pocoes encantadas

**Encantamento (Runesmith):**
- Aprendiz: Runas Tier 1
- Oficial: Runas Tier 3
- Adepto: Runas Tier 4
- Mestre: Runas Tier 5 (duas sub-linhas)
- Grao: Runas Tier 6 (nivel maximo)
- Especialista em Projetos: Crafteos raros de projetos

**Ferraria:**
- Aprendiz: Armas iniciais e escudos
- Oficial: Equipamento de combate basico (espadas 1M, armas 2M, a distancia, escudos)

**Refinaria (Gadgets):**
- Itens de utilidade feitos de madeira e metais: bandagens e armas de treino em niveis baixos; iscas, pedras de amolar, bombas de cola e tendas em niveis medios; cajado de madeira viva, gancho de escalada, espada boomerang e deposito portatil em niveis altos
- O nivel de Refinaria aumenta diretamente o dano e a cura dos gadgets

**Lenhador (Woodcutting):**
- Profissao de coleta que alimenta a Refinaria: corte arvores para obter troncos, refine-os em tabuas e ganhe +1% de velocidade de ataque por nivel]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Dicas**

- Priorize as tarefas faceis primeiro para completa-las rapido
- Guarde as tarefas dificeis para quando ja estiver rodando masmorras ou eventos
- Mantenha itens craftados no seu storage para entregar tarefas de crafting rapidamente
- As tarefas Mistas contam multiplas atividades ao mesmo tempo - muito eficientes
- O reinicio diario ocorre conforme a hora local do servidor - planeje adequadamente
- Sempre resgate sua Caixa Dourada antes de o dia terminar]] }
            }
          }
        }
      },
      currencies = {
        name = 'Moedas',
        subcategories = {
          fame = {
            name = 'Pontos de Fama',
            type = 'text',
            content = 'Os pontos de fama sao ganhos completando missoes e derrotando chefes.\n\nUsos:\na Comprar itens exclusivos em lojas NPC\na Desbloquear areas especiais\na Comprar itens cosmeticos\n\nComo ganhar:\na Missoes diarias: 10-50 fama\na Matar chefes: 100-500 fama\na Eventos: varia'
          },
          valuable_pouches = {
            name = 'Bolsas Valiosas',
            type = 'list',
            items = {
              { name = 'Bolsa de Bronze', description = 'Contem 100-500 ouro. Drop comum de monstros.', icon = 2853 },
              { name = 'Bolsa de Prata', description = 'Contem 500-2000 ouro. Drop raro de monstros.', icon = 2854 },
              { name = 'Bolsa Dourada', description = 'Contem 2000-10000 ouro. Drop muito raro.', icon = 2855 }
            }
          }
        }
      },
      tasks = {
        name = 'Sistema de Tarefas',
        subcategories = {
          overview = {
            name = 'Como Funcionam as Tarefas',
            type = 'text',
            order = 1,
            content = 'O Sistema de Tarefas e um quadro de missoes dinamico onde voce caca monstros por recompensas.\n\n**Como Funciona:**\n- Voce tem 3 slots de tarefas disponiveis\n- Cada tarefa requer matar monstros especificos\n- Complete tarefas para ganhar ouro, fama e experiencia\n- As tarefas tem diferentes niveis: Normal, Rara, Epica, Lendaria\n- Cada tarefa tem modificadores que afetam dificuldade e recompensas\n\n**Comecando:**\n1. Abra o Quadro de Tarefas (Ctrl+T ou clique no botao Tasks)\n2. Escolha uma tarefa dos 3 slots disponiveis\n3. Clique "Start" para ativar a tarefa\n4. Cace os monstros requeridos\n5. Volte e clique "Complete" para resgatar recompensas\n\n**Importante:**\n- Voce so pode ter 1 tarefa ativa por vez\n- As tarefas mostram outfits de monstros para saber o que cacar\n- As faixas de nivel ajudam a encontrar zonas apropriadas\n- Voce pode abandonar uma tarefa, mas perde todo o progresso'
          },
          rerolls = {
            name = 'Sistema de Rerolls',
            type = 'text',
            order = 4,
            content = 'Os Rerolls permitem atualizar os 3 slots de tarefas para obter novas opcoes.\n\n**Rerolls Gratis:**\n- Base: 5 rerolls gratis por dia\n- Bonus Premium: +5 rerolls extras (10 total)\n- Bonus Fama: +1 reroll a cada 5 niveis de fama\n- Reinicio Diario: Reinicia a cada 24 horas\n\n**Rerolls Pagos:**\n- Custo: 20 ouro por reroll\n- Uso ilimitado (se tiver ouro)\n- Use quando os gratis acabarem\n\n**Rerolls Bonus:**\n- Tarefas Raras: 25% chance de +1 reroll de recompensa\n- Tarefas Epicas: 40% chance de +1 reroll de recompensa\n- Tarefas Lendarias: +1-2 rerolls garantidos\n- Estes se acumulam com seus rerolls diarios\n\n**Dicas de Estrategia:**\n- Guarde rerolls gratis para quando precisar de tarefas melhores\n- Bloqueie boas tarefas antes de fazer reroll\n- Maior fama = mais rerolls gratis'
          },
          locks = {
            name = 'Sistema de Bloqueios',
            type = 'text',
            order = 5,
            content = 'Os Bloqueios protegem tarefas de serem rerolladas, permitindo manter boas tarefas enquanto atualiza outras.\n\n**Bloqueios Gratis:**\n- Base: 3 bloqueios gratis por dia\n- Bonus Premium: +5 bloqueios extras (8 total)\n- Reinicio Diario: Reinicia a cada 24 horas\n\n**Bloqueios Pagos:**\n- Custo: 10 ouro por bloqueio\n- Uso ilimitado (se tiver ouro)\n- Use quando os gratis acabarem\n\n**Bloqueios Bonus:**\n- Tarefas Epicas: 30% chance de +1 bloqueio de recompensa\n- Tarefas Lendarias: +1-2 bloqueios garantidos\n- Estes se acumulam com seus bloqueios diarios\n\n**Como Usar:**\n1. Encontre uma tarefa que queira manter\n2. Clique no botao "Lock" nessa tarefa\n3. Faca reroll de outras tarefas sem perder a bloqueada\n4. Clique "Unlock" para remover o bloqueio\n\n**Dicas de Estrategia:**\n- Bloqueie tarefas de alto nivel (Epica/Lendaria)\n- Bloqueie tarefas com bons modificadores\n- Jogadores premium obtem significativamente mais bloqueios'
          },
          tiers = {
            name = 'Niveis e Raridade de Tarefas',
            type = 'text',
            order = 2,
            content = 'As tarefas vem em 4 niveis com diferentes taxas de aparecimento e multiplicadores de recompensa.\n\n**Normal (60% taxa de aparecimento)**\n- Multiplicador de Recompensa: 1.0x\n- Modificadores: 0-1\n- Tarefas comuns, recompensas base\n\n**Rara (25% taxa de aparecimento)**\n- Multiplicador de Recompensa: 1.25x\n- Modificadores: 1-2\n- 25% bonus de recompensas\n- 25% chance de +1 reroll bonus\n\n**Epica (10% taxa de aparecimento)**\n- Multiplicador de Recompensa: 1.5x\n- Modificadores: 2-3\n- 50% bonus de recompensas\n- 40% chance de +1 reroll\n- 30% chance de +1 bloqueio\n- Desbloqueada no Nivel de Fama 8\n\n**Lendaria (5% taxa de aparecimento)**\n- Multiplicador de Recompensa: 2.0x\n- Modificadores: 3 (sempre)\n- 100% bonus de recompensas\n- +1-2 rerolls bonus garantidos\n- +1-2 bloqueios bonus garantidos\n- Extremamente rara, recompensas maximas\n\n**Desbloqueios de Nivel:**\n- Normal, Rara: Disponiveis desde o inicio\n- Epica: Requer Nivel de Fama 8\n- Lendaria: Sempre disponivel (se tiver sorte)'
          },
          rewards = {
            name = 'Recompensas e Bonificacoes',
            type = 'text',
            order = 3,
            content = 'As tarefas te recompensam com base em multiplos fatores que se acumulam.\n\n**Recompensas Base (da faixa de nivel):**\n- Ouro, Fama e Experiencia escalam com o nivel do monstro\n- Tarefas de maior nivel = recompensas base mais altas\n\n**Multiplicadores de Recompensa:**\n\n1. **Multiplicador de Nivel:**\n   - Normal: 1.0x\n   - Rara: 1.25x\n   - Epica: 1.5x\n   - Lendaria: 2.0x\n\n2. **Bonus por Quantidade de Monstros:**\n   - 1 monstro: 1.0x\n   - 2 monstros: 1.15x (+15%)\n   - 3 monstros: 1.30x (+30%)\n\n3. **Bonus por Modificadores:**\n   - Modificador negativo: +15% por modificador\n   - Modificador misto: +10% por modificador\n   - Tarefas mais dificeis = melhores recompensas\n\n4. **Bonus por Kills (NOVO):**\n   - +5% a cada 50 kills (ate +25% max)\n   - 50 kills: +5%\n   - 100 kills: +10%\n   - 150 kills: +15%\n   - 200 kills: +20%\n   - 250+ kills: +25% (limite)\n\n**Formula Final:**\nRecompensa = Base x Nivel x QuantidadeMonstros x (1 + BonusMod) x BonusKills\n\n**Exemplo:**\n- Base: 1000 ouro\n- Nivel Raro: 1.25x\n- 2 monstros: 1.15x\n- 1 mod negativo: 1.15x\n- 150 kills: 1.15x\n= 1,913 ouro\n\n**Cada Tarefa Mostra 2 Recompensas Aleatorias:**\n- Ouro, Fama, Experiencia, Rerolls Bonus ou Bloqueios Bonus'
          },
          fame_premium = {
            name = 'Beneficios de Fama e Premium',
            type = 'text',
            order = 6,
            content = 'Seu Nivel de Fama e status Premium fornecem bonus permanentes.\n\n**Bonus de Nivel de Fama:**\n\n- **Nivel 3 - Cacador Experiente:**\n  Taxa de aparecimento de nivel Raro +5%\n\n- **Nivel 5 - Cacador Veterano:**\n  Modificadores negativos reduzidos em 15%\n\n- **Nivel 7 - Cacador de Elite:**\n  +1 reroll gratis por dia\n\n- **Nivel 8 - Mestre Cacador:**\n  Desbloqueia tarefas de nivel Epico\n\n- **Nivel 10 - Cacador Lendario:**\n  +5% bonus em todas as recompensas\n\n**Como Ganhar Fama:**\n- Complete tarefas para ganhar pontos de fama\n- Tarefas de maior nivel dao mais fama\n- A fama se acumula e nunca reinicia\n- Verifique seu nivel de fama no Quadro de Tarefas\n\n**Beneficios de Conta Premium:**\n\n- **Rerolls Gratis:**\n  +5 extras por dia (10 total vs 5 gratis)\n\n- **Bloqueios Gratis:**\n  +5 extras por dia (8 total vs 3 gratis)\n\n- **Melhor Eficiencia:**\n  Bloqueie mais tarefas enquanto faz reroll\n  Mais flexibilidade na selecao de tarefas\n\n**Poder Combinado:**\nPremium + Nivel de Fama 10:\n- 10+ rerolls gratis por dia\n- 8 bloqueios gratis por dia\n- +5% recompensas em todas as tarefas\n- Nivel Epico desbloqueado\n- Melhores chances de modificadores\n\n**Estrategia:**\n- Os bonus de fama sao permanentes - sempre vale a pena farmar\n- Premium da QoL massivo para gestao de tarefas\n- Maior fama = melhor geracao de tarefas'
          }
        }
      },
      pets = {
        name = 'Mascotes',
        subcategories = {
          pet_list = {
            name = 'Todos os Mascotes',
            type = 'pets',
            items = {
              {
                name = 'Bebe Pesadelo',
                rarity = 'Epica',
                collector = 'Colecionador Sombrio',
                abilities = {
                  { name = 'Carga de Pesadelo', description = 'Arremessa-se para frente causando dano e medo' },
                  { name = 'Devorador de Sonhos', description = 'Drena mana de inimigos e aumenta a regeneracao de mana do dono em 10%' }
                }
              },
              {
                name = 'Bebe Prisma',
                rarity = 'Epica',
                collector = 'Colecionador de Paleta',
                abilities = {
                  { name = 'Raio Prisma', description = 'Dispara um raio elemental aleatorio (fogo/gelo/energia)' },
                  { name = 'Escudo Prisma', description = 'Aumenta +8% todas as resistencias por 10 segundos' }
                }
              },
              {
                name = 'Terroc',
                rarity = 'Epica',
                collector = 'Colecionador Mitico',
                abilities = {
                  { name = 'Terremoto', description = 'Dano fisico em area com 2s de atordoamento' },
                  { name = 'Buff de Terror', description = '+10% chance critica por 10 segundos' }
                }
              },
              {
                name = 'Espectro',
                rarity = 'Epica',
                collector = 'Colecionador Sombrio',
                abilities = {
                  { name = 'Maldicao Espectral', description = 'Dano de morte + reduz cura em 50%' },
                  { name = 'Aparicao', description = '+15% dano de morte por 12 segundos' }
                }
              },
              {
                name = 'Lobo',
                rarity = 'Rara',
                collector = 'Colecionador Selvagem',
                abilities = {
                  { name = 'Uivo', description = 'Medo em area + 10% velocidade de ataque' }
                }
              },
              {
                name = 'Coelho',
                rarity = 'Rara',
                collector = 'Colecionador Chef',
                abilities = {
                  { name = 'Salto Rapido', description = 'Arremessa-se para frente com aumento de velocidade' }
                }
              },
              {
                name = 'Bebe Fenix de Fogo',
                rarity = 'Rara',
                collector = 'Colecionador Mitico',
                abilities = {
                  { name = 'Aura de Chamas', description = 'Dano de fogo em area + 10% dano de fogo' }
                }
              },
              {
                name = 'Bebe Fenix de Gelo',
                rarity = 'Rara',
                collector = 'Colecionador Mitico',
                abilities = {
                  { name = 'Onda de Geada', description = 'Dano de gelo + lentidao + aumento de velocidade' }
                }
              },
              {
                name = 'Fada',
                rarity = 'Rara',
                collector = 'Colecionador de Paleta',
                abilities = {
                  { name = 'Po de Fada', description = 'Cura o dono 5% HP + HoT por 8 segundos' }
                }
              },
              {
                name = 'Gato Branco',
                rarity = 'Comum',
                collector = 'Colecionador de Paleta',
                abilities = {
                  { name = 'Pata da Sorte', description = '+3% chance de loot por 10 segundos' }
                }
              },
              {
                name = 'Gato Preto',
                rarity = 'Comum',
                collector = 'Colecionador Sombrio',
                abilities = {
                  { name = 'Garra de Sombra', description = 'Dano + reduz resistencia a luz' }
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
            name = 'Primeiros Passos',
            type = 'text',
            order = 1,
            content = 'Bem-vindo ao Ascension! Este servidor funciona estilo ARPG com varios sistemas de progressao.\n\n**Suas Prioridades:**\n1. Suba de nivel e complete Tasks v2.\n2. Colete todo o loot. Use o Stash System e o Quick Loot para organizar tudo.\n3. Nao venda os itens lixo ao NPC! Use o Recycler ou o Upgrade System para extrair minerais e gemas.'
          },
          class_talents = {
            name = 'Talentos de Classe',
            type = 'rich_text',
            order = 2,
            sections = {
              { type = 'text', content = [[**O que sao os Talentos de Classe?**

Cada classe de personagem tem sua propria arvore de talentos unica com varias ramas que se especializam em dano, defesa ou utilidade. Cada arvore contem nodos que concedem bonus passivos ao subir de nivel. Os talentos se aplicam automaticamente ao fazer login, entao planeje sua build com cuidado!]] },
              { type = 'image', path = '/images/wiki/talents_overview.png', width = 400, height = 220 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Pontos de Talento**

- Voce ganha **1 ponto de talento a cada 8 niveis** de personagem
- Cada nivel de nodo custa **1 ponto de talento**
- A maioria dos nodos tem um **nivel maximo de 10**
- Os pontos nao usados podem ser gastos a qualquer momento abrindo a janela de Talentos]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Resetar Talentos**

Errou? Voce pode resetar toda sua arvore e recuperar todos os pontos gastos.

- Custo base: **50 de ouro por ponto gasto**
- **Desconto Premium:** 25 de ouro por ponto (-50%)
- Todos os pontos gastos sao **reembolsados**
- Voce **mantem** seus pontos totais ganhos

Abra a janela de talentos e clique no botao Reset para ver o custo exato.]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Classes Disponiveis**

| Classe | Ramos |
|-------|-------|
| Magician | Fogo / Arcano / Gelo |
| Templar | Sagrado / Castigo / Protecao / Justica |
| Nightblade | Sombra / Sangue / Assassinato |
| Dragonknight | Terra / Dragao / Fogo / Elemental |
| Warlock | Demonologia / Maldicoes / Invocacao / Pacto de Sangue |
| Stellar | Cosmico / Celestial / Wand |
| Monk | Elementos / Terra / Vida / Vento |
| Druid | Natureza / Espirito / Gelo / Metamorfo |
| Light Dancer | Luz / Velocidade / Suporte |]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Dicas**

- Faca seus talentos sinergizarem com seu equipamento e estilo de jogo
- Builds de DPS devem focar primeiro em ramos de dano
- Tanques devem priorizar vida e resistencias
- Healers devem aumentar mana e efetividade de cura
- Alguns nodos desbloqueiam feiticos ou habilidades especiais em certos niveis
- Voce pode pre-visualizar todos os nodos antes de gastar pontos]] }
            }
          },
          paragon_ascension = {
            name = 'Ascensao Paragon',
            type = 'rich_text',
            order = 3,
            sections = {
              { type = 'text', content = [[**O que e Paragon?**

Paragon e o sistema de progressao End-Game que desbloqueia ao atingir **Nivel de Personagem 300**. Depois de chegar a esse limite, a XP que voce ganha comeca a encher sua barra de Paragon em vez de subir de nivel. Cada nivel de Paragon concede um ponto para gastar em uma de tres categorias de atributos, rotacionando automaticamente entre elas.

Abra a aba Ascension na janela de Talentos de Classe para ver seu quadro de Paragon, atribuir pontos e acompanhar seu progresso.]] },
              { type = 'image', path = '/images/wiki/paragon_overview.png', width = 400, height = 220 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Como funciona a XP de Paragon**

- XP base para Nivel de Paragon 1: **6,000,000**
- Cada nivel seguinte custa **+12% mais XP** que o anterior
- **Bonus Premium:** +15% de XP de Paragon
- **Token de Boost:** +25% de XP de Paragon (buff consumivel)
- **Penalidade por Morte:** Voce perde 10% do progresso atual de XP de Paragon
- Notificacao broadcast a cada 10 niveis de Paragon

A XP de Paragon e ganha das mesmas fontes que a XP normal (matar monstros, quests, etc.) uma vez que voce esta no nivel maximo.]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Atribuicao de Pontos e Rotacao**

Os pontos rotacionam automaticamente entre categorias ao subir de nivel:

- **Paragon Niv 1, 4, 7...** -> **Primario** (Ataque)
- **Paragon Niv 2, 5, 8...** -> **Secundario** (Defesa)
- **Paragon Niv 3, 6, 9...** -> **Utilidade** (Progressao)

Voce pode gastar os pontos ganhos a qualquer momento. Os pontos nao expiram. Abra a aba Ascension para atribui-los a atributos especificos.]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Atributos Primarios (Ataque)**

| Atributo | Por Ponto | Limite |
|-------------|-----------|--------|
| Dano Fisico | +1% | 150% |
| Dano Elemental | +1 fixo | 200 |
| Velocidade de Ataque | +1% | 100% |
| Chance de Critico | +1% | 75% |]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Atributos Secundarios (Defesa)**

| Atributo | Por Ponto | Limite |
|-------------|-----------|--------|
| Chance de Bloqueio | +1% | 30% |
| HP Maximo | +50 fixo | Sem limite |
| Mana Maxima | +40 fixo | Sem limite |
| Cura Recebida | +1% | 100% |]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Atributos de Utilidade (Progressao)**

| Atributo | Por Ponto | Limite |
|-------------|-----------|--------|
| Ganho de EXP | +1% | 100% |
| Experiencia de Crafting | +2% | 150% |
| Ganho de Fama | +2% | 100% |
| Conhecimento do Codex | +0.2% | 50 (~10%) |]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Marcos (Milestones)**

Gastar pontos em uma categoria desbloqueia bonus de marco e titulos:

**Primario (Ataque):**
- 25 pontos -> Titulo: "Warrior"
- 50 pontos -> +3% Dano Total
- 100 pontos -> +5% Dano Total
- 200 pontos -> Titulo: "Paragon of War", +8% Dano Total

**Secundario (Defesa):**
- 25 pontos -> Titulo: "Guardian"
- 50 pontos -> +5% HP Maximo
- 100 pontos -> +8% HP Maximo
- 200 pontos -> Titulo: "Paragon of Fortitude", +12% HP Maximo

**Utilidade (Progressao):**
- 25 pontos -> Titulo: "Explorer"
- 50 pontos -> +3% Todos os Ganhos
- 100 pontos -> +5% Todos os Ganhos
- 200 pontos -> Titulo: "Paragon of Fortune", +8% Todos os Ganhos

Os bonus de marco sao automaticos e se acumulam com os bonus de atributos.]] },
              { type = 'image', path = '/images/wiki/horizontal_bridge.png', width = 365, height = 28 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Dicas**

- Priorize pontos Primarios para aumentar seu DPS bruto
- O HP Secundario nao tem limite, o que o torna um investimento seguro a longo prazo
- O Ganho de EXP de Utilidade e valioso para progredir Paragon mais rapido
- O Conhecimento do Codex ajuda com os drops de cartas enquanto farma
- Os bonus de marco substituem o nivel anterior (ex. 100pt substitui 50pt, nao se acumulam)
- Protecao contra morte: tome cuidado em zonas perigosas para evitar perder progresso de XP]] }
            }
          },
          codex = {
            name = 'Sistema Codex',
            type = 'rich_text',
            order = 4,
            sections = {
              { type = 'text', content = [[**O que e o Codex?**

O Codex e um sistema de colecao de cartas. Os monstros podem dropar cartas (ou caixas de cartas) que voce equipa no seu Deck para obter poderosos bonus passivos e ativos. Com 104 cartas unicas, montar o deck certo e essencial para o dano, sobrevivencia e utilidade do End-Game.

Abra o modulo de Codex para ver sua Colecao, seu Deck ativo e a aba de Fabricacao de Caixas.]] },
              { type = 'image', path = '/images/wiki/codex_overview.png', width = 400, height = 220 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Espacos do Deck**

Voce tem 6 espacos para equipar cartas ativas. Requisitos de desbloqueio:

- **Espaco 1:** Gratis (sempre desbloqueado)
- **Espaco 2:** Nivel de personagem 80
- **Espaco 3:** Nivel de personagem 150
- **Espaco 4:** Paragon Nivel 1
- **Espaco 5:** Paragon Nivel 50
- **Espaco 6:** Apenas contas Premium

Cartas inativas na sua colecao nao concedem beneficios. Apenas cartas equipadas aplicam seus efeitos. Va ate a aba Deck no modulo de Codex para equipar ou trocar cartas.]] },
              { type = 'image', path = '/images/codex/deck_bg.png', width = 380, height = 200 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Caixas e Como Obter Cartas**

As cartas sao obtidas abrindo Caixas. Ha 3 niveis de caixas que voce pode fabricar na aba Caixas do Codex:

| Caixa | Custo de Fabricacao | Nivel Max. de Carta | Comum | Rara | Epica | Lendaria | Essencias Extra |
|------|----------------------|---------------------|-------|------|-------|------------|----------------|
| Bronze | 100 Essencias | Nivel 2 | 70% | 20% | 8% | 2% | 50 (25% chance) |
| Prata | 200 Essencias | Nivel 3 | 60% | 25% | 10% | 5% | 80 (30% chance) |
| Dourada | 350 Essencias | Nivel 5 | 30% | 30% | 30% | 10% | 120 (35% chance) |

As caixas tambem podem cair como loot de monstros e elites. Alem disso voce recebe **1 Caixa de Bronze gratis a cada 15 niveis de personagem**.]] },
              { type = 'image', path = '/images/wiki/codex_crates.png', width = 400, height = 180 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Essencias do Codex**

As Essencias sao a moeda do sistema Codex. Usos:
- Fabricar caixas (100/200/350 por caixa)
- Melhorar cartas diretamente (10 EXP por essencia gasta, com multiplicador de raridade)
- Desbloquear espacos do deck antecipadamente (500+ essencias, custo dobra a cada vez)

**Formas de ganhar Essencias:**
- Matar monstros e elites
- Bonus ao abrir caixas
- Cartas duplicadas no nivel maximo se convertem em essencias
- **Pocao de Conhecimento:** +50% de ganho de essencias enquanto ativa

Voce pode ver suas Essencias atuais na parte superior do modulo de Codex.]] },
              { type = 'image', path = '/images/wiki/codex_esssences.png', width = 200, height = 60 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Raridade de Cartas**

As cartas vem em 4 raridades que determinam a taxa de drop e o poder:

- **Comum** (Branca): Efeitos basicos, mais faceis de obter
- **Rara** (Azul): Efeitos mais fortes, taxa moderada
- **Epica** (Roxa): Efeitos poderosos que definem builds
- **Lendaria** (Dourada): Efeitos que mudam o jogo, mais dificeis de obter]] },
              { type = 'image', path = '/images/wiki/codex_card_rarities.png', width = 400, height = 120 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Nivelamento de Cartas**

Cada carta comeca no Nivel 1 e pode subir ate Nivel 10. Niveis mais altos desbloqueiam efeitos mais fortes. Voce pode subir de nivel ao obter duplicatas (concedem EXP) ou gastando Essencias diretamente na vista de detalhe da carta.

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

**Cartas Duplicadas:** Quando voce obtem uma carta que ja possui, ela concede EXP conforme a raridade (Comum=100, Rara=200, Epica=300, Lendaria=500). Se a carta ja esta no nivel maximo para o tipo de caixa, as duplicatas se convertem em essencias.]] },
              { type = 'image', path = '/images/wiki/codex_level_comparison.png', width = 380, height = 160 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Tipos de Ativacao (Triggers)**

As cartas se ativam conforme diferentes condicoes. Voce pode ver o tipo de ativacao no tooltip de cada carta:

- **Passiva:** Sempre ativa enquanto equipada (bonus de stats, resistencias, auras)
- **Ao Matar:** Ativa quando voce mata um monstro (reducao de cooldown, explosoes, medo, invocacao)
- **Ao Curar:** Ativa quando voce cura (restaurar mana, sobrecura, eco de grupo)
- **Ao Lancar Feitico:** Ativa ao lancar feiticos (campos de fogo, curar-ao-lancar)
- **Feitico de Ataque:** Apenas feiticos ofensivos (raios, sacrificio de sangue)
- **Feitico de Cura:** Apenas feiticos de cura (explosao do dragao florido)
- **Curar Aliado:** Apenas ao curar aliados (castigo divino em inimigos)
- **Ao Morrer:** Evita a morte uma vez (Fenix revive)
- **Ao Critico:** Ativa em golpes criticos
- **HP Baixo:** Ativa ao ficar abaixo de certo limiar de vida
- **Periodica:** Ativa periodicamente (efeitos baseados em intervalos)]] },
              { type = 'image', path = '/images/wiki/codex_trigger_examples.png', width = 400, height = 140 },
              { type = 'spacer', height = 8 },

              { type = 'text', content = [[**Montando seu Deck**

*Cartas de Dano (DPS):* Critical Surge, The Witch, Glass Cannon, The Dragon, Guns Lover, The Gunner, Svarog, Zeus

*Cartas de Tanque/Sobrevivencia:* Golem, The Phoenix, The Behemoth, The Slime, Water Elemental, Soul Leech, Final Symphony

*Cartas de Curandeiro:* Undine, The Elf, Archangel, Blood Link, Blossom Dragon, The Naga, Yacy

*Cartas de Utilidade:* Executioner (reducao CD), Essence Reaver (farm de essencias), The Child (EXP), Carnage Presence (limpeza), The Necromancer (invocacoes)

**Dicas**
- Sinergize cartas com sua build (ex. The Witch com pools de mana altos)
- As cartas de dragao (31-40) sinergizam com Dragon Lord para bonus multiplicativos
- Cartas de curandeiro como Blood Link e Archangel so funcionam ao curar membros do grupo
- Guns Lover e The Gunner sao obrigatorias para builds a distancia
- Glass Cannon e alto risco, alta recompensa (+32% dano mas +32% dano recebido no maximo)
- Cartas duplicadas no nivel maximo se convertem em essencias -- farme caixas de baixo tier para renda de essencias]] }
            }
          },
        }
      }
    }
  }
end
