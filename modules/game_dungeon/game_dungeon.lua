dungeonWindow = nil

local localDungeonItemList = {}
local currentDungeon = nil
local dungeonReqItemPanel = nil

function printOutDungeon(tmpDangeon)
    if tmpDangeon then
        print("name:"..tmpDangeon.name)
        print("description:"..tmpDangeon.description)
        print("difficulty:"..tmpDangeon.difficulty)
        print("lvl:"..tmpDangeon.lvl)
        print("reqPlayers:"..tmpDangeon.reqPlayers)
        print("coins:"..tmpDangeon.coins)
        print("fame:"..tmpDangeon.fame)
        print("exp:"..tmpDangeon.exp)
        print("\tRewards:")
        for i = 1, #tmpDangeon.reqItems do
            print("\tCnt:"..i)
            print("\tcid:"..tmpDangeon.reqItems[i].cid)
        end
    end
end

function parseIncomingDungeonData(buffer)
    print("buffer:"..tostring(buffer))
    local parseDungeon = {}
    local mainSplit = {}
    local requestedItemsList = {}
    for split in string.gmatch(buffer, "(.-)|") do
        table.insert(mainSplit, split)
    end
    local requestItemsSplit = {}
    for split in string.gmatch(mainSplit[10], "(.-):") do
        table.insert(requestItemsSplit, split)
    end
    local requestItemsCnt = tonumber(#requestItemsSplit) / 2
    for j = 1, requestItemsCnt do
        table.insert(requestedItemsList, {cid = requestItemsSplit[(2*(j-1)) + 1], itemCnt = requestItemsSplit[(2*(j-1)) + 2] })
    end
    parseDungeon = {name = mainSplit[2], description = mainSplit[3], difficulty = mainSplit[4], lvl = mainSplit[5],
                    reqPlayers = mainSplit[6], coins = mainSplit[7], fame = mainSplit[8],
                    exp = mainSplit[9], reqItems = requestedItemsList, backgroundId = mainSplit[11]}
    --printOutDungeon(parseDungeon)
    return parseDungeon
end


function onExtendedDungeonWindow(protocol, opcode, buffer)
    if string.starts(buffer, "open") then
        currentDungeon = parseIncomingDungeonData(buffer)
        openWindow(currentDungeon.backgroundId)
    elseif buffer == "close" then
        hide()
    end
end

function init()
    ProtocolGame.registerExtendedOpcode(ExtendedIds.DungeonWindow, onExtendedDungeonWindow)

    dungeonWindow = g_ui.displayUI('game_dungeon', modules.game_interface.getRightPanel())
    dungeonReqItemPanel = dungeonWindow:recursiveGetChildById('dungeonReqItemsPanel')
    hide()
    if g_game.isOnline() then
      online()
    end
end

function terminate()
    ProtocolGame.unregisterExtendedOpcode(ExtendedIds.DungeonWindow)
    dungeonWindow:destroy()
end

function online()
end

function offline()
    hide()
    currentDungeon = nil
end

function hide()
  for i = #localDungeonItemList, 1, -1 do
    localDungeonItemList[i]:destroy()
    table.remove(localDungeonItemList, i)
  end
  dungeonWindow:hide()
end

function openWindow(backgroundId)
  print("/images/game/dungeon/dungeon_" .. tostring(backgroundId))
  dungeonWindow:setImageSource("/images/game/dungeon/dungeon_" .. tostring(backgroundId))
  dungeonWindow:show()
  dungeonWindow:raise()
  updateDungeonWidget()
end

function updateDungeonWidget()
    if currentDungeon then
        dungeonWindow:getChildById('missionName'):setText(currentDungeon.name)
        dungeonWindow:getChildById('objectivesDesc'):setText(currentDungeon.description)
        dungeonWindow:getChildById('difficultyDesc'):setText(currentDungeon.difficulty)
        dungeonWindow:getChildById('recommendedLevel'):setText(currentDungeon.lvl)
        dungeonWindow:getChildById('recommendedPlayers'):setText(currentDungeon.reqPlayers)
        dungeonWindow:getChildById('rewards'):getChildById('coins'):setText(currentDungeon.coins)
        dungeonWindow:getChildById('rewards'):getChildById('fame'):setText(currentDungeon.fame)
        dungeonWindow:getChildById('rewards'):getChildById('exp'):setText(currentDungeon.exp)
        for i = 1, #currentDungeon.reqItems do
            local dungeonItem = g_ui.createWidget('DungeonItem', dungeonReqItemPanel)
            table.insert(localDungeonItemList, dungeonItem)
            dungeonItem:getChildById('dungeonItemCnt'):setText(currentDungeon.reqItems[i].itemCnt)
            dungeonItem:getChildById('dungeonItem'):setItemId(currentDungeon.reqItems[i].cid)
        end
    end
end

function startDungeon()
    local protocol = g_game.getProtocolGame()
    if protocol then
        protocol:sendExtendedOpcode(ClientOpcodes.ClientStartDungeon, "")
    end
end
