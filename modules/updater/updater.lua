Updater = {}

Updater.maxRetries = 5

local updaterWindow
local loadModulesFunction
local scheduledEvent
local httpOperationId = 0

local function onLog(level, message, time)
  if level == LogError then
    Updater.error(message)
    g_logger.setOnLog(nil)
  end
end

local function loadModules()
  if loadModulesFunction then
    local tmpLoadFunc = loadModulesFunction
    loadModulesFunction = nil
    tmpLoadFunc()
  end
end

local function downloadFiles(url, files, index, retries, doneCallback)
  if not updaterWindow then return end
  local entry = files[index]
  if not entry then -- finished
    return doneCallback()
  end
  local file = entry[1]
  local file_checksum = entry[2]

  if retries > 0 then
    updaterWindow.downloadStatus:setText(tr("Downloading (%i retry):\n%s", retries, file))
  else
    updaterWindow.downloadStatus:setText(tr("Downloading:\n%s", file))
  end
  updaterWindow.downloadProgress:setPercent(0)
  updaterWindow.mainProgress:setPercent(math.floor(100 * index / #files))

  httpOperationId = HTTP.download(url .. file, file,
    function(file, checksum, err)
      if not err and checksum ~= file_checksum then
        err = "Invalid checksum of: " .. file .. ".\nShould be " .. file_checksum .. ", is: " .. checksum
      end
      if err then
        if retries >= Updater.maxRetries then
          Updater.error("Can't download file: " .. file .. ".\nError: " .. err)
        else
          scheduledEvent = scheduleEvent(function()
            downloadFiles(url, files, index, retries + 1, doneCallback)
          end, 250)
        end
        return
      end
      downloadFiles(url, files, index + 1, 0, doneCallback)
    end,
    function(progress, speed)
      updaterWindow.downloadProgress:setPercent(progress)
      updaterWindow.downloadProgress:setText(speed .. " kbps")
    end)
end

local function updateFiles(data, keepCurrentFiles)
  if not updaterWindow then return end

  if type(data) ~= "table" then
    return Updater.error("Invalid data from updater api (not table)")
  end

  if type(data.error) == 'string' and data.error:len() > 0 then
    return Updater.error(data.error)
  end

  if not data.files or type(data.url) ~= 'string' or data.url:len() < 4 then
    return Updater.error("Invalid data from updater api: " .. json.encode(data, 2))
  end

  local manifestFiles = {}
  for file, checksum in pairs(data.files) do
    table.insert(manifestFiles, { file, checksum })
  end

  local toUpdate = {}
  local toUpdateFiles = {}
  local checkIndex = 1

  local function finishCheck()
    local newFiles = #toUpdateFiles > 0

    -- update binary
    local binary = nil
    if type(data.binary) == "table" and data.binary.file:len() > 1 then
      local selfChecksum = g_resources.selfChecksum()
      if selfChecksum:len() > 0 and selfChecksum ~= data.binary.checksum then
        binary = data.binary.file
        table.insert(toUpdate, { binary, data.binary.checksum })
      end
    end

    if #toUpdate == 0 then -- nothing to update
      updaterWindow.mainProgress:setPercent(100)
      scheduledEvent = scheduleEvent(Updater.abort, 20)
      return
    end

  -- update of some files require full client restart
  local forceRestart = false
  local reloadModules = false
  local forceRestartPattern = { "init.lua", "corelib", "updater", "otmod" }
  for _, file in ipairs(toUpdate) do
    for __, pattern in ipairs(forceRestartPattern) do
      if string.find(file[1], pattern) then
        forceRestart = true
      end
      if not string.find(file[1], "data/things") then
        reloadModules = true
      end
    end
  end

  updaterWindow.status:setText(tr("Updating %i files", #toUpdate))
  updaterWindow.mainProgress:setPercent(0)
  updaterWindow.downloadProgress:setPercent(0)
  updaterWindow.downloadProgress:show()
  updaterWindow.downloadStatus:show()
  updaterWindow.changeUrlButton:hide()

  downloadFiles(data["url"], toUpdate, 1, 0, function()
    updaterWindow.status:setText(tr("Updating client (may take few seconds)"))
    updaterWindow.mainProgress:setPercent(100)
    updaterWindow.downloadProgress:hide()
    updaterWindow.downloadStatus:hide()
    scheduledEvent = scheduleEvent(function()
      local restart = binary or (not loadModulesFunction and reloadModules) or forceRestart
      if newFiles then
        g_resources.updateFiles(toUpdateFiles, not restart)
      end

      if binary then
        g_resources.updateExecutable(binary)
        g_resources.deleteFile(binary) -- remove downloaded copy, real exe is written as Ascension-<ts>.exe
      end

      if restart then
        g_app.restart()
      else
        if reloadModules then
          g_textures.clearCache()
          g_modules.reloadModules()
        end
        Updater.abort()
      end
    end, 100)
  end)
  end

  -- check manifest files in chunks so the UI doesn't freeze
  local function checkChunk()
    if not updaterWindow then return end
    local deadline = g_clock.millis() + 30
    while checkIndex <= #manifestFiles do
      local entry = manifestFiles[checkIndex]
      if g_resources.fileChecksum(entry[1]) ~= entry[2] then
        table.insert(toUpdate, entry)
        table.insert(toUpdateFiles, entry[1])
      end
      checkIndex = checkIndex + 1
      if g_clock.millis() >= deadline then break end
    end
    updaterWindow.mainProgress:setPercent(math.floor(60 + 40 * checkIndex / #manifestFiles))
    if checkIndex <= #manifestFiles then
      scheduledEvent = scheduleEvent(checkChunk, 1)
    else
      finishCheck()
    end
  end

  updaterWindow.status:setText(tr("Checking %i files", #manifestFiles))
  checkChunk()
end

-- public functions
function Updater.init(loadModulesFunc)
  g_logger.setOnLog(onLog)
  loadModulesFunction = loadModulesFunc
  Updater.check()
end

function Updater.terminate()
  loadModulesFunction = nil
  Updater.abort(true)
end

function Updater.abort(terminate)
  HTTP.cancel(httpOperationId)
  removeEvent(scheduledEvent)
  if updaterWindow then
    updaterWindow:destroy()
    updaterWindow = nil
  end
  loadModules()
  if not terminate then
    signalcall(g_app.onUpdateFinished, g_app)
  end
end

function Updater.check(args)
  if updaterWindow then return end

  updaterWindow = g_ui.displayUI('updater')
  updaterWindow:show()
  updaterWindow:focus()
  updaterWindow:raise()

  local updateData = nil
  local function progressUpdater(value)
    removeEvent(scheduledEvent)
    if value == 100 then
      return Updater.error(tr("Timeout"))
    end
    if updateData and (value > 60 or (not g_platform.isMobile() or not ALLOW_CUSTOM_SERVERS or not loadModulesFunc)) then -- gives 3s to set custom updater for mobile version
      return updateFiles(updateData)
    end
    scheduledEvent = scheduleEvent(function() progressUpdater(value + 1) end, 100)
    updaterWindow.mainProgress:setPercent(value)
  end
  progressUpdater(0)

  httpOperationId = HTTP.postJSON(Services.updater, {
    version = g_app.getBuildRevision(),
    build = g_app.getVersion(),
    os = g_app.getOs(),
    platform = g_window.getPlatformType(),
    args = args or {}
  }, function(data, err)
    if err then
      return Updater.error(err)
    end
    updateData = data
  end)
end

function Updater.error(message)
  removeEvent(scheduledEvent)
  if not updaterWindow then return end
  displayErrorBox(tr("Updater Error"), message).onOk = function()
    Updater.abort()
  end
end
