local buyerID = tostring(getDiscordID())

local buyerList = {
    ["636196321232945152"] = "Author",
	["562894447315124227"] = "Admin",
	["1038445236608831508"] = "voltranf"
}

function cekMember(playerID)
  if buyerList[playerID] then
    return true, buyerList[playerID] -- return true + nama
  else
    return false, nil
  end
end

function errDialog(t)
sendDialog({
    title = "ERROR",
    confirm = "OK",
    message = t.."\n\nHaving trouble?\nReport bugs or problem at my Discord Server.\n\nDiscord : @hsndika\n[https://discord.gg/3xKNPbB5qd]",
    alias = "diates"
})
editValue("hsnclear_startBtn", false)
end

function dialogBuilder(t, m, c)
    sendDialog({
        title = t,
        confirm = c,
        message = m
    })
end

Sleep(1000)
sendNotification("Verifying...")
Sleep(5000)

local premium = false

if cekMember(buyerID) then
  dialogBuilder("Auto Clear World v1.0 by HsnGL", "Verified, Welcome ".. buyerList[buyerID].."\n\nStatus : Premium\n\nFeatures:\n - Auto Clear all world types ✔\n - Multi worlds ✔\n - No Key required ✔\n - Auto save water ✔\n - Auto collect and save drop item ✔\n - Auto reconnect ✔", "OK")
  premium = true
  log("[HsnGL] Added Auto Clear : Premium")
  sendNotification("[HsnGL] Added Auto Clear : Premium")
else
  dialogBuilder("Auto Clear World v1.0 by HsnGL", "Welcome Free User\n\nStatus : Free\n\nFeatures:\n - Auto Clear all world types ✔\n - Auto save water ✔\n - Multi worlds ❌\n - No Key required ❌\n - Auto collect and save drop item ✔\n - Auto reconnect ❌", "OK")
  premium = false
  log("[HsnGL] Added Auto Clear : Free")
  sendNotification("[HsnGL] Added Auto Clear : Free")
end

addCategory("HsnGL", "FileOpen")

local Hsnclear = [[
{
  "sub_name": "Auto Clear World",
  "description": "Auto Clear World by HsnGL",
  "icon": "TravelExplore",
  "menu": [
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "text": "START/STOP",
          "default": false,
          "alias": "hsnclear_startBtn"
      },
      {
          "type": "divider"
      },
      {
          "type": "label",
          "text": "Script Version: v2"
      },
      {
          "type": "label",
          "text": "Status: FREE",
          "alias": "hsnclear_labelStatus"
      },
      {
          "type": "label",
          "text": ""
      },
      {
          "type": "label",
          "text": "Block Filter:"
      },
      {
          "type": "toggle_button",
          "text": "SHOW FILTER",
          "default": false,
          "alias": "hsnclear_filterBtn"
      },
      {
          "text": "Target World Setting",
          "support_text": "Click to open World settings.",
          "type": "dialog",
          "background": false,
          "menu": [
              
              {
                 "text": "Target World Settings",
                 "icon": "SettingsSuggest",
                 "support_text": "Get Premium to unlock multi world!\n\nTarget World format: WORLD1, WORLD2, WORLD3\n\nDefault World Size:\n     Normal: 100 x 60\n     Island: 100 x 100",
                 "background": true,
                 "type": "tooltip"
              },
              {
                 "type": "input_string",
                 "text": "Target World",
                 "default": "",
                 "placeholder": "EXAMPLE, CONTOH, WORLD",
                 "icon": "TravelExplore",
                 "alias": "hsnclear_targetWorld"
              },
              {
                  "type": "label",
                  "text": "Current Queue: 1",
                  "alias": "hsnclear_currentQueue"
              },
              {
                  "type": "button",
                  "alias": "hsnclear_resetQueue",
                  "text": "RESET QUEUE"
              },
              {
                 "type": "input_int",
                 "text": "World width",
                 "default": "100",
                 "placeholder": "",
                 "icon": "AspectRatio",
                 "alias": "hsnclear_sizeX"
              },
              {
                 "type": "input_int",
                 "text": "World height",
                 "default": "60",
                 "placeholder": "",
                 "icon": "AspectRatio",
                 "alias": "hsnclear_sizeY"
              }
          ]
      },       
      {
          "text": "Save World Setting",
          "support_text": "Click to open World settings.",
          "type": "dialog",
          "background": false,
          "menu": [
              
              {
                 "text": "Save World Settings",
                 "icon": "SettingsSuggest",
                 "support_text": "Save World format: WORLD or WORLD|ID",
                 "background": true,
                 "type": "tooltip"
              },
              {
                 "alias": "hsnclear_saveWorldName",
                 "text": "Save World",
                 "icon": "TravelExplore",
                 "placeholder": "WORLD|ID, WORLD",
                 "default": "",
                 "type": "input_string",
                 "label": "Save world name"
              },
              {
                  "type": "button",
                  "alias": "hsnclear_currentSaveName",
                  "text": "Get Current World"
              },
              {
                  "alias": "hsnclear_savePosX",
                  "text": "Drop X",
                  "icon": "LocationOn",
                  "placeholder": "Input drop X",
                  "default": "",
                  "type": "input_int",
                  "label": "X position for drop"
              },
              {
                  "alias": "hsnclear_savePosY",
                  "text": "Drop Y",
                  "icon": "LocationOn",
                  "placeholder": "Input drop Y",
                  "default": "",
                  "type": "input_int",
                  "label": "Y position for drop"
              },
              {
                  "type": "button",
                  "alias": "hsnclear_currentSavePos",
                  "text": "Get Current Position"
              }
          ]
      },
      {
          "text": "Delay Setting",
          "support_text": "Click to open delay settings.",
          "type": "dialog",
          "background": false,
          "menu": [
              {
                 "type": "tooltip",
                 "text": "Delay for Auto Clear",
                 "support_text": "Don't use low delay if you're lagging",
                 "background": false,
                 "icon": "HourglassTop"
              },
              {
                 "type": "slider",
                 "text": "Punch Delay\n",
                 "usedot": false,
                 "max": 500,
                 "min": 180,
                 "default": 180,
                 "alias": "hsnclear_delay"
              },
              {
                 "type": "slider",
                 "text": "Water Delay\n",
                 "usedot": false,
                 "max": 1000,
                 "min": 300,
                 "default": 500,
                 "alias": "hsnclear_delayWater"
              },
              {
                 "type": "slider",
                 "text": "Lag Delay\n",
                 "usedot": false,
                 "max": 10000,
                 "min": 3000,
                 "default": 3000,
                 "alias": "hsnclear_delayLag"
              }
          ]
      },
      {
          "type": "divider"
      },
      {
          "type": "divider"
      },
      {
          "type": "labelapp",
          "text": "Advanced Settings",
          "icon": "SettingsSuggest",
          "description": "Advanced settings for Auto Clear"
      },
      {
          "type": "toggle",
          "text": "Auto Collect",
          "description": "Automatically collect dropped items.",
          "default": true,
          "alias": "hsnclear_collect"
      },
      {
          "type": "toggle",
          "text": "Antibounce",
          "description": "Prevent death from deadly tiles (optional).",
          "default": false,
          "alias": "hsnclear_antibounce"
      },
      {
          "type": "toggle",
          "text": "Auto Ban",
          "description": "Automatically ban player when entering world.",
          "default": false,
          "alias": "hsnclear_autoBan"
      }
]    
}
]]

local hsnclear_key = [[
{
  "sub_name": "Auto Clear World",
  "description": "by Hsn",
  "icon": "TravelExplore",
  "menu": [
     {
         "type": "tooltip",
         "icon": "",
         "background": false,
         "text": "Auto Clear World",
         "support_text": ""
      },
      {
          "type": "input_string",
          "alias": "hsnclear_inputKey",
          "default": "",
          "text": "Pass Key",
          "placeholder": "Input Key here!",
          "label": "Input correctly",
          "icon": "VpnKey"
      },
      {
          "type": "label",
          "text": ""
      },    
      {
          "type": "button",
          "alias": "hsnclear_loadBtn",
          "text": "ENTER"
      },
      {
          "type": "divider"
      },
      {
          "type": "label",
          "text": ""
      },    
      {
          "type": "tooltip",
          "text": "How to get Key? (FREE!)",
          "support_text": "",
          "background": true,
          "icon": "Lightbulb"
      },
      {
          "type": "tooltip",
          "text": "Join my Discord Server!\n\nLINK :\n",
          "support_text": "",
          "background": false,
          "icon": "AddLink"
      },
      {
          "type": "divider"
      },
      {
          "type": "label",
          "text": "https://discord.gg/3xKNPbB5qd"
      },
      {
          "type": "divider"
      }
         
]    
}
]]

local hsnclear_mode = hsnclear_key
local Key777 = "HsnClear144"

if premium then
    addIntoModule(Hsnclear, "HsnGL")
    Sleep(100)
    editValue("hsnclear_labelStatus", "Status: PREMIUM")
else
    addIntoModule(hsnclear_mode, "HsnGL")
end   

-- ==========================================
-- VARIABEL & KONFIGURASI
-- ==========================================
function getVar()
  cache = {
      targetWorld = getValue(2, "hsnclear_targetWorld"),
      saveWorld = getValue(2, "hsnclear_saveWorldName"),
      dx = getValue(1, "hsnclear_savePosX"),
      dy = getValue(1, "hsnclear_savePosY"),
      delay = getValue(1, "hsnclear_delay"),
      delayWater = getValue(1, "hsnclear_delayWater"),
      delayLag = getValue(1, "hsnclear_delayLag"),
      width = getValue(1, "hsnclear_sizeX") - 1,
      height = getValue(1, "hsnclear_sizeY") - 1
      }
  return cache
end

local y = 0
local globalX, globalY, globalWorld = 0, 0 , ""
local globalTX, globalTY = 1, 1
local maxY = 54
local direction = 1
local lastLock = 0
local iklan = 0

local isCollect = true
local isLocked = false
local triggered = false
local breakFg = false
local breakBg = false
local putWater = false
local isFull = false
local isBlocked = false
local inMainMenu = false
local running = false
local autoBan = false

local blacklist = {
    [6] = true,
    [8] = true,
    [242] = true,
    [226] = true,
    [3760] = true,
	[7372] = true,
	[14908] = true,
	[14910] = true,
	[16206] = true,
	[16208] = true
}

local whitelist = {}

local waterChecked = 1
local hasWater = false
    
function blockScan()
    local blocks = {}
    local blockLines = {}
    local blockCount = {}
    local waterCount = 0

    for _, tile in pairs(GetTiles()) do
        if tile.fg and tile.fg ~= 0 then
            blockCount[tile.fg] = (blockCount[tile.fg] or 0) + 1
        end

        if tile.bg and tile.bg ~= 0 then
            blockCount[tile.bg] = (blockCount[tile.bg] or 0) + 1
        end
        
        local water = math.floor(tile.flag/1024) % 2 == 1
        
        if water then
           hasWater = true
           waterCount = waterCount + 1
        end     
    end

    for id, count in pairs(blockCount) do

        id = tonumber(id)

        local info = getItemInfoByID(id)

        if info then

                -- Kalau sudah ada di whitelist, ikuti state-nya.
                -- Kalau belum pernah ada, default checked.
                local checked = whitelist[id]

                if checked == nil then
                    checked = 1
                end

                table.insert(blocks, {
                    id = id,
                    name = info.name,
                    checked = checked,
                    count = count
                })
        end
    end
    
    if hasWater then
       table.insert(blockLines, string.format(
           "add_spacer|small|\n" ..
           "add_checkbox|%s||%d\n"..
           "add_custom_margin|x:45;y:-53|\n"..
           "add_label_with_icon|small|%s x%d|left|%d|\n"..
           "reset_placement_x|\n"..
           "reset_placement_y|",
           "hsnclear_water",
           waterChecked,
           "Water",
           waterCount,
           822
       ))
    end  
    
    for _, block in pairs(blocks) do
        local key = "hsnclear_check" .. block.id

        table.insert(blockLines, string.format(
            "add_spacer|small|\n" ..
            "add_checkbox|%s||%d\n"..
            "add_custom_margin|x:45;y:-53|\n"..
            "add_label_with_icon|small|%s x%d|left|%d|\n"..
            "reset_placement_x|\n"..
            "reset_placement_y|",
            key,
            block.checked,
            block.name,
            block.count,
            block.id
        ))
    end

    growtopia.sendDialog(table.concat({
        "set_default_color|`w",
        "set_border_color|112,86,191,255",
        "set_bg_color|43,34,74,200",
        "add_custom_button|DUMMY_PADDING_X|state:disabled;icon:1402;|",
        "add_textbox|Auto Clear World|",
        "add_smalltext|Script By HsnGL|",
        "add_custom_break|",
        "reset_placement_x|",
        "add_spacer|small|",
        "add_textbox|Blocks Filter:|",

        (#blockLines > 0
            and table.concat(blockLines, "\n")
            or "add_textbox|No block found!|"
        ),

        "add_spacer|small|",
        "add_quick_exit|",
        "add_smalltext|`4NOTE:`o don't sell this script|",
        "end_dialog|hsnclear_checkList|Close|Apply|",
        "add_custom_margin|x:300;y:0|\n" ..
        "add_custom_button|DUMMY_PADDING_X|textLabel:``;state:disabled;middle_colour:0;border_colour:0;|"
    }, "\n"))
    
    waterCount = 0
    hasWater = false
end

-- ==========================================
-- FUNGSI PENDUKUNG
-- ==========================================
function whiteless(t) return t or "" end
function cek(id) return growtopia.checkInventoryCount(id) end
function msg(t) sendNotification("[HsnGL] "..t) end
function ost(t) growtopia.notify("`c[HsnGL] "..t) end
function notif(t) log("`c[HsnGL] "..t) end

function rnDelay(base)
    local offset = math.floor(base * 0.1)
    return math.random(base - offset, base + offset)
end

local pref = require("preferences")
local db = whiteless(pref):new("Hsnclear")
whiteless(db):save()

function saveSettings()
    whiteless(db):set("settings", {
        delay = getValue(1, "hsnclear_delay"),
        delayWater = getValue(1, "hsnclear_delayWater"),
        delayLag = getValue(1, "hsnclear_delayLag"),
        targetWorld = getValue(2, "hsnclear_targetWorld"),
        saveWorld = getValue(2, "hsnclear_saveWorldName"),
        dropX = getValue(1, "hsnclear_savePosX"),
        dropY = getValue(1, "hsnclear_savePosY")
    })
    whiteless(db):save()
    return true
end

function loadSettings()
    local cfg = whiteless(db):get("settings")

    if not cfg then
        return
    end

    editValue("hsnclear_delay", cfg.delay)
    editValue("hsnclear_delayWater", cfg.delayWater)
    editValue("hsnclear_delayLag", cfg.delayLag)
    editValue("hsnclear_targetWorld", cfg.targetWorld)
    editValue("hsnclear_saveWorldName", cfg.saveWorld)
    editValue("hsnclear_savePosX", cfg.dropX)
    editValue("hsnclear_savePosY", cfg.dropY)
    
end
loadSettings()

function particle(parX, parY, id)
      SendVariant({
          v1 = "OnParticleEffect",
          v2 = id,
          v3 = {
              x = parX*32+16,
              y = (parY+1)*32-16
          }
      })
   end    
   
function showArea()
   ost("Show Area enabled")
   local NextAction = 0
   Sleep(100)
   while running do
      if not running then return false end
      
      if os.clock() - NextAction >= 1 then
         NextAction = os.clock()
         particle(globalTX, globalTY, 88)
      else
         Sleep(100)
      end
   end
end

function hasWhitelist()
   for _, checked in pairs(whitelist) do
      if checked == 1 then
         return true
      end
   end

   return false
end

function pos()
    local p = GetLocal()
    
    if p then
       return math.floor(p.posX / 32), math.floor(p.posY / 32)
    end    
end

function spr(t, v, x, y)
    SendPacketRaw(false, {
        type = t, value = v, px = x, py = y,
        x = GetLocal().posX, y = GetLocal().posY
    })
end

function waitLocal(timeout)
    timeout = timeout or 10
    local count = 0
    repeat
        if not running then return false end
        Sleep(rnDelay(200))
        count = count + 1
    until GetLocal() or count >= timeout
    return GetLocal() ~= nil
end

function wName(world)
    world = whiteless(world):upper()
    return whiteless(world):match("^[^|]+") or world
end

function warp(rawWorld)
    local timeout = 0
    local world = whiteless(rawWorld):upper()
    
    if wName(world) == GetWorldName() then return true end
    
    growtopia.warpTo(world)
    msg("Warp to " .. wName(world))
    repeat
        if not running then return false end
        Sleep(rnDelay(3000))
        timeout = timeout + 1
        msg("Waiting for warp to " .. wName(world))
    until GetWorldName() == wName(world) or timeout >= 200 or not GetLocal()
    return GetWorldName() == wName(world)
end

function fp(x, y)
    local px = math.floor(GetLocal().posX / 32)
    local py = math.floor(GetLocal().posY / 32)
    
    if px == x and py == y then return true end
    
    while math.abs(y - py) > 6 do
        if not running then return false end
        py = py + (y - py > 0 and 6 or -6)
        FindPath(px, py)
        Sleep(rnDelay(200))
    end
    
    while math.abs(x - px) > 6 do
        if not running then return false end
        px = px + (x - px > 0 and 6 or -6)
        FindPath(px, py)
        Sleep(rnDelay(200))
    end
    
    FindPath(x, y)
    Sleep(rnDelay(200))
    return growtopia.isOnPos(x, y)
end

function clearRadius(x, y, radius)
    local g = getVar()
    local m, n = pos()
    msg("Solving stuck")
    for ox = -radius, radius do
        if not running then return false end
        for oy = -radius, radius do
            if not running then return false end
            local tx, ty = x + ox, y + oy
            if tx >= 0 and tx <= 99 and ty >= 0 and ty <= 99 then
                local tile = getTile(tx, ty)
                globalTY, globalTX = tx, ty
                if tile then
                    -- Hancurkan FG/BG jika bukan blacklist
                    if whitelist[tile.fg] == 1  and tile.fg ~= 0 then
                        repeat 
                          if not reconnect() then 
                              errDialog("Failed to reconnect")
                              return false end
                          if not running then return false end
                          if isLocked then return false end
                          spr(3, 18, tx, ty)
                          Sleep(rnDelay(g.delay))
                        until GetTile(tx, ty).fg == 0
                    end
                    
                    collect(world)
                    
                    if whitelist[tile.bg] == 1 and (whitelist[tile.fg] == 1 or tile.fg == 0)  then
                        repeat
                         if not running then return false end
                         if not reconnect() then 
                              errDialog("Failed to reconnect")
                              return false end
                         if isLocked then return false end
                         spr(3, 18, tx, ty) 
                         Sleep(rnDelay(g.delay))
                        until GetTile(tx, ty).bg == 0
                    end
                    collect(world)
                end
            end
        end
    end
end

-- FUNGSI FP DENGAN ESCAPE LOGIC
function safeFP(targetX, targetY)
    if fp(targetX, targetY) then return true end
    
    -- Gagal, mulai proses clearing
    local curX, curY = pos()
    clearRadius(curX, curY, 2)
    
    -- Coba lagi
    if fp(targetX, targetY) then return true end
    
    -- Gagal lagi, cari area kosong terdekat ke target
    msg("Still blocked, solving...")
    local bestX, bestY = -1, -1
    local minDist = 999
    local c, d = pos()
    -- Mencari titik kosong (fg == 0) terdekat dari target
    for ox = -2, 2 do
        for oy = -2, 2 do
            local tx, ty = c + ox, d + oy
            if tx >= 0 and tx <= 99 and ty >= 0 and ty <= 99 then
                local tile = getTile(tx, ty)
                if tile and tile.fg == 0 then
                    local dist = math.abs(tx - targetX) + math.abs(ty - targetY)
                    if dist < minDist then
                        minDist = dist
                        bestX, bestY = tx, ty
                    end
                end
            end
        end
    end
    
    -- Bergerak ke area kosong hasil temuan
    if bestX ~= -1 then
        local limit = 0
        repeat
            if not running then return false end
            if isLocked then return false end
            if not reconnect() then 
                errDialog("Failed to reconnect")
                    return false end
            fp(bestX, bestY)
            clearRadius(bestX, bestY, 2, globalWorld)
            Sleep(200)
            if fp(targetX, targetY) then return true end
            limit = limit + 1
        until limit >= 5
        if limit >= 5 then return false end
    end   
    return false
end

function findY(y)
    local setY = y
    if setY <= 0 then
        return setY
    elseif setY == 1 then
        return setY - 1
    elseif setY >= 2 then
        return setY - 2
    end    
end     

function drop(itemid)
    growtopia.dropItem(itemid)
    local timeout = 0
    local g = getVar()
    repeat
        Sleep(rnDelay(100))
        timeout = timeout + 1
    until isFull or isBlocked or timeout >= 10
    
    if isBlocked then isBlocked = false return false end
    if isFull then
        isFull = false
        local new_dx = g.dx - 1
        
        if new_dx < 0 then msg("DX < 0") errDialog("drop X < 0") return false end
        editValue("hsnclear_savePosX", new_dx)
        if saveSettings() then ost("Move 1 tile") end
        if not fp(new_dx, g.dy) then return false end
        return drop(itemid)
    end
    
    growtopia.confirmDropItem(itemid, 180)
    timeout = 0
    repeat
        if not running then return false end
        Sleep(200)
        timeout = timeout + 1
    until cek(itemid) < 180 or timeout >= 50
    return cek(itemid)
end

function autoDrop(x, y, id)
    local g = getVar()
    if not warp(g.saveWorld) then return false end
    if not waitLocal(100) then return false end
    if not fp(g.dx, g.dy) then return false end
    Sleep(rnDelay(1000))
    if not drop(id) then return false end
    if not warp(globalWorld) then return false end
    if not waitLocal(10) then return false end
    if not fp(x, y) then return false end
    Sleep(1000) -- Memberi waktu load world
    return true
end

function collect()
    if not isCollect then return true end
    
    local curX, curY = pos()
    
    for _, obj in pairs(GetObjectList()) do
        local posiX = math.floor(obj.posX / 32)
        local posiY = math.floor(obj.posY / 32)
        
        if obj.itemid ~= 0 then
            if math.abs(posiX - curX) <= 2 and math.abs(posiY - curY) <= 2 then
                spr(11, obj.id, obj.posX + 6, 0)
            end
            if cek(obj.itemid) >= 190 then
                local b, c = pos()
                if not autoDrop(b, c, obj.itemid) then return false end
            end
        end
    end
    return true
end

function reconnect()
   if not premium then return true end
   local g = getVar()
   
   if not GetLocal() then
      local limit = 0
      repeat
         if not running then return false end
         ost("Waiting to reconnect")
         Sleep(1000)
         limit = limit + 1
      until inMainMenu or GetLocal() or limit >= 3000
      
      if limit >= 3000 then 
         return false
      elseif inMainMenu then
         reconnected = false
         if not warp(globalWorld) then return false end
         Sleep(1000)
         inMainMenu = false
      end   
   else
      return true
   end
   Sleep(1000)
   
   if not safeFP(globalX, findY(globalY)) then
       return false
   end
       
   return true
end         
   

function scan(x, y)
    local tile = GetTile(x, y)
    local waterPos = math.floor(tile.flag/1024) % 2 == 1
    
    putWater = false
    breakFg = false
    breakBg = false
    
    if waterPos and waterChecked == 1 and (whitelist[tile.fg] == 1 or tile.fg == 0) and cek(822) >= 1 then putWater = true end
    if whitelist[tile.fg] == 1 and tile.fg ~= 0 then breakFg = true end
    if whitelist[tile.bg] == 1 and (whitelist[tile.fg] == 1 or tile.fg == 0) then breakBg = true end
end

-- ==========================================
-- LOGIKA UTAMA
-- ==========================================
local Index = 1

function loadWorldList()
   local worlds = {}

   for world in whiteless(getVar().targetWorld):gmatch("[^,]+") do
      world = whiteless(world):match("^%s*(.-)%s*$")
      table.insert(worlds, world)
   end

   return worlds
end

function clear(world)
   isLocked = false
   trigger = false
   y = 0
    
   if running then
      editToggle("ModFly", true)
      editToggle("Antipunch", true)
        
      if not warp(world) then return "stop" end
      if not waitLocal(10) then return "stop" end
      
      globalWorld = GetWorldName()
      
      Sleep(1000)
      ost("Auto Clear: START")
      notif("Auto Clear: START")
   else
      return
   end
     
   while y <= getValue(1, "hsnclear_sizeY") - 1 and running do
      local h = getVar()
      local startX, endX, step
    
      if not running then return "stop" end
      if isLocked then return "locked" end
    
      if direction == 1 then
         startX = 0
         endX = h.width
         step = 1
      else
         startX = h.width
         endX = 0
         step = -1
      end

      for x = startX, endX, step do
         local waterTry = 0
         globalX = x
         globalY = y
         
         if not running then return "stop" end
         if isLocked then return "locked" end
        
         scan(x, y)
        
         if putWater and cek(822) >= 1 then
            if not safeFP(x, findY(y), world) then break end
            if cek(822) >= 190 then
               local a, b = pos()
               
               if not autoDrop(a, b, 822, world) then 
                  if not reconnect() then
                     return "Uknown Error: Failed to save!?"
                  end   
               end
            end
            
            local checkArr = (x >= 2 and x <= 97) and {x, x + step, x + step + step} or {x}
            
            for _, tx in ipairs(checkArr) do
               local before = cek(822)
            
               globalTX, globalTY = tx, y
               globalX = x
               globalY = y
            
               if not running then return "stop" end
               if isLocked then return "locked" end
               if not reconnect() then 
                  errDialog("Failed to reconnect")
                  return "stop"
               end
               
               if getTile(tx, y).flag >= 1024 and cek(822) >= 1 then
                  spr(3, 822, tx, y)
                  Sleep(rnDelay(h.delayWater))
                  if before >= cek(822) then
                     waterTry = waterTry + 1
                  end   
               end
            end
            if waterTry >= 3 then
               ost("Lag detected")
               Sleep(h.delayLag)
            end   
         end
        
         local checkArr = (x >= 2 and x <= 97) and {x, x + step, x + step + step} or {x}

-- Break FG
         if breakFg then
            if not safeFP(x, findY(y), world) then break end
    
            if os.clock() - iklan >= 20 then
               iklan = os.clock()
                
               if premium then
                  ost("Auto Clear World: Premium")
               else
                  ost("Auto Clear World: Free")
               end   
            end
    
            for _, tx in ipairs(checkArr) do
               local attempt = 0
               while true do
                  globalTX, globalTY = tx, y
                  globalX = x
                  globalY = y
                  
                  if not running then return "stop" end
                  if not reconnect() then 
                     errDialog("Failed to reconnect")
                     return "stop"
                  end
                   
                  if isLocked then return "locked" end
            
                  local tile = getTile(tx, y)

                  if tile.fg == 0 or whitelist[tile.fg] ~= 1 then
                     break
                  end

                  spr(3, 18, tx, y)
                  Sleep(rnDelay(h.delay))
                  attempt = attempt + 1
                  
                  if attempt  >= 25 then
                     attempt = 0
                     ost("Lag detected!")
                     Sleep(h.delayLag)
                  end   
               end
            end
          
            collect(world)
         end

-- Break BG
         if breakBg then
            if not safeFP(x, findY(y), world) then break end

            for _, tx in ipairs(checkArr) do
               local attempt = 0
               while true do
                  globalTX, globalTY = tx, y
                  globalX = x
                  globalY = y
                  
                  if not running then return "stop" end
                  if not reconnect(x, y, world) then 
                     errDialog("Failed to reconnect")
                     return "stop"
                  end
                   
                  if isLocked then return "locked" end
        
                  local tile = getTile(tx, y)
            
                  if whitelist[tile.bg] ~= 1 then
                     break
                  end   

                  if tile.fg ~= 0 and whitelist[tile.fg] ~= 1 then
                     break
                  end
                   
                  spr(3, 18, tx, y)
                  Sleep(rnDelay(h.delay))
                  attempt = attempt + 1
                  
                  if attempt  >= 25 then
                     attempt = 0
                     ost("Lag detected!")
                     Sleep(h.delayLag)
                  end   
               end
            end
             
            collect(world)
         end
      end

      for x = 0, h.width do
         local waterTry = 0
         globalX = x
         globalY = y
         
         if not running then return "stop" end
         if isLocked then return "locked" end
         if not reconnect(x, y, world) then 
            errDialog("Failed to reconnect")
            return "stop"
         end
        
         scan(x, y) -- Scan ulang untuk memastikan kondisi terkini
    
    -- Jika ternyata setelah row selesai masih ada blok yang seharusnya hancur
         if breakFg or breakBg or putWater then
            msg("Detected missed block at " .. x .. "," .. y .. ". Fixing...")
            if putWater and cek(822) >= 1 then
               if not safeFP(x, findY(y), world) then break end
               if cek(822) >= 190 then
                  local a, b = pos()
               
                  if not autoDrop(a, b, 822, world) then 
                     errDialog("Failed to save item")
                     return "stop"
                  end
               end
            
               local checkArr = (x >= 2 and x <= 97) and {x, x + step, x + step + step} or {x}
            
               for _, tx in ipairs(checkArr) do
                  local before = cek(822)
                  globalTX, globalTY = tx, y
                  globalX = x
                  globalY = y
                  
                  if not running then return "stop" end
                  if isLocked then return "locked" end
                  if not reconnect() then 
                     errDialog("Failed to reconnect")
                     return "stop"
                  end
                  
                  if getTile(tx, y).flag >= 1024 and cek(822) >= 1 then
                     spr(3, 822, tx, y)
                     Sleep(rnDelay(h.delayWater))
                     if before >= cek(822) then
                        waterTry = waterTry + 1
                     end   
                  end
               end
               if waterTry >= 3 then
                  ost("Lag detected")
                  Sleep(h.delayLag)
               end   
            end
        
            local checkArr = (x >= 2 and x <= 97) and {x, x + step, x + step + step} or {x}

-- Break FG
            if breakFg then
               if not safeFP(x, findY(y), world) then break end
       
               if os.clock() - iklan >= 20 then
                  iklan = os.clock()
                
                  if premium then
                     ost("Auto Clear World: Premium")
                  else
                     ost("Auto Clear World: Free")
                  end   
               end
    
               for _, tx in ipairs(checkArr) do
                  local attempt = 0
                  while true do
                     globalTX, globalTY = tx, y
                     globalX = x
                     globalY = y
                     
                     if not running then return "stop" end
                     if not reconnect(x, y, world) then 
                        errDialog("Failed to reconnect")
                        return "stop"
                     end
                   
                     if isLocked then return "locked" end
            
                     local tile = getTile(tx, y)

                     if tile.fg == 0 or whitelist[tile.fg] ~= 1 then
                       break
                     end

                     spr(3, 18, tx, y)
                     Sleep(rnDelay(h.delay))
                     attempt = attempt + 1
                     
                     if attempt  >= 25 then
                        attempt = 0
                        ost("Lag detected!")
                       Sleep(h.delayLag)
                     end   
                  end
               end
          
               collect(world)
            end

-- Break BG
            if breakBg then
               if not safeFP(x, findY(y), world) then break end

               for _, tx in ipairs(checkArr) do
                  local attempt = 0
                  while true do
                     globalTX, globalTY = tx, y
                     globalX = x
                     globalY = y
                     
                     if not running then return "stop" end
                     if not reconnect(x, y, world) then 
                        errDialog("Failed to reconnect")
                        return "stop"
                     end
                   
                     if isLocked then return "locked" end
        
                     local tile = getTile(tx, y)
               
                     if whitelist[tile.bg] ~= 1 then
                        break
                     end   

                     if tile.fg ~= 0 and whitelist[tile.fg] ~= 1 then
                        break
                     end
                   
                     spr(3, 18, tx, y)
                     Sleep(rnDelay(h.delay))
                     attempt = attempt + 1
                     
                     if attempt  >= 25 then
                        attempt = 0
                        ost("Lag detected!")
                        Sleep(h.delayLag)
                     end   
                  end
               end
             
               collect(world)
            end
         end
      end
    
      y = y + 1
      globalY = y
      direction = (math.floor(GetLocal().posX / 32) > 50) and -1 or 1
   end

   if premium and y >= getVar().height then
      msg("Move to next World")
      return "finish"
   elseif not premium and y >= getVar().height then
      editToggle("hsnclear_startBtn", false)
      dialogBuilder("Done", whiteless(world):upper().." has been successfully cleared\n\nGet Premium to unlock Multi World.\nThank You.", "OK")
      return "stop"
   end    
end

function mainLoop()
   local d = getVar()
   local worldList = loadWorldList()
   Index = math.max(1, math.min(Index, #worldList))
   editValue("hsnclear_currentQueue", "Current Queue: "..Index)
   
   if d.targetWorld == "" then 
            running = false
            editToggle("ModFly", false) 
            editToggle("hsnclear_startBtn", false)
            ost("Target world cannot be empty")
            return
        end
        
        if d.saveWorld == "" then 
            running = false
            editToggle("ModFly", false) 
            editToggle("hsnclear_startBtn", false)
            ost("Save world cannot be empty")
            return
        end
        
        if d.dx < 0 then 
            editToggle("ModFly", false) 
            editToggle("hsnclear_startBtn", false)
            ost("Drop coordinate X cannot be empty")
            return
        end
        
        if d.dy < 0 then 
            editToggle("ModFly", false) 
            editToggle("hsnclear_startBtn", false)
            ost("Drop coordinate Y cannot be empty")
            return
        end
        
        if not hasWhitelist() then
            editToggle("ModFly", false) 
            editToggle("hsnclear_startBtn", false)
            ost("Select block first!")
            return
        end    

   while running and Index <= #worldList do
      local result = clear(worldList[Index])
      isLocked = false

      if result == "finish" then
         Index = Index + 1
         editValue("hsnclear_currentQueue", "Current Queue: "..Index)
      elseif result == "locked" then
         if premium then
            errDialog(GetWorldName().." is locked by someone else")
            Index = Index + 1
            editValue("hsnclear_currentQueue", "Current Queue: "..Index)
            isLocked = false
         else
            isLocked = false
            return false
         end  
      elseif result == "stop" then
         editValue("hsnclear_startBtn", false)
         return false
      end
   end

   if Index > #worldList then
      Index = 1
      editValue("hsnclear_currentQueue", "Current Queue: "..Index)
      running = false
      editToggle("hsnclear_startBtn", false)
      dialogBuilder("Done", "All selected worlds have been cleared successfully.\n\nPlease share your experience at our Discord Server.\nThank You.", "OK")
   end
end

addHook(function(type, pkt)
   if whiteless(pkt):match("dialog_name|hsnclear_checkList") then
      for id, checked in whiteless(pkt):gmatch("hsnclear_check(%d+)|(%d+)") do
         id = tonumber(id)
         checked = tonumber(checked)

         whitelist[id] = checked
      end
        
      if whiteless(pkt):match("hsnclear_water|(%d+)") then
         local waterCheck = tonumber(whiteless(pkt):match("hsnclear_water|(%d+)"))
         waterChecked = waterCheck
      end
      
      msg("Filters Applied")
      return true
   end
end, "OnSendPacket")

addHook(function(var)
   if var.v1 == "OnTextOverlay" and whiteless(var.v2):find("You can't drop that here, find an emptier spot!") then
    isFull = true
    msg("Tile full")
    
  elseif var.v1 == "OnTextOverlay" and whiteless(var.v2):find("You can't drop that here, face somewhere with open space.") then
    isBlocked = true
    msg("Tile blocked")
    
  elseif running and var.v1 == "OnDialogRequest" and whiteless(var.v2):find("How many to drop?") then
    return true
  elseif running and var.v1 == "OnRequestWorldSelectMenu" then
    inMainMenu = true
  elseif running and var.v1 == "OnPlayPositioned" and var.v2 == "audio/punch_locked.wav" then
     if os.clock() - lastLock >= 2 then
        lastLock = os.clock()
        if not premium then
           editToggle("hsnclear_startBtn", false)
           errDialog(GetWorldName().." is locked by someone else")
        else 
           isLocked = true
        end   
     end   
  elseif var.v1 == "OnDialogRequest" and whiteless(var.v2):find("add_popup_name|WrenchMenu|") and running and autoBan then
     msg("Player has been banned for 1 hour.")
     ost("Player has been banned for 1 hour.")
     return true
  elseif var.v1 == "OnSpawn" and autoBan and running then
      local v2 = var.v2
      local netid = tonumber(whiteless(v2):match("netID|(%d+)"))
      
      if netid then
         sendPacket(2, 
             "action|wrench\n|netid|"..netid
         )
         
         sendPacket(2, 
             "action|dialog_return\n"..
             "dialog_name|popup\n"..
             "netID|"..netid.."|\n"..
             "netID|"..netid.."|\n"..
             "buttonClicked|worldban"
         )
      end
   end 
end, "OnVariant")

addHook(function(type, name, value)
   local g = getVar()
   if name == "hsnclear_startBtn" and getValue(0, "hsnclear_startBtn") then
      running = true
      triggered = false
      
      runThread(function()
         local sukses, hasil = pcall(mainLoop)

         if sukses then
            log(hasil)
         else
            log(" Error:"..hasil) -- hasil = "attempt to divide by zero"
         end
      end)  
      saveSettings()
   elseif name == "hsnclear_startBtn" and not getValue(0, "hsnclear_startBtn") then
      editToggle("ModFly", false)
      editToggle("Antipunch", false)
      y = 0
      ost("Auto Clear: STOP")
      log("Auto Clear: STOP")
      running = false
   elseif name == "hsnclear_filterBtn" and value == true then
      editValue("hsnclear_filterBtn", false)
      blockScan()
   elseif name == "hsnclear_savePosX" then
      if saveSettings() then ost("Drop coordinate set to "..g.dx.." ,"..g.dy) end
   elseif name == "hsnclear_savePosY" then
      if saveSettings() then ost("Drop coordinate set to "..g.dx.." ,"..g.dy) end
   elseif name == "hsnclear_currentSavePos" then
      local a, b = pos()
      editValue("hsnclear_savePosX", a)
      editValue("hsnclear_savePosY", b)
      if saveSettings() then ost("Drop coordinate set to current position") end
   elseif name == "hsnclear_currentSaveName" then
      editValue("hsnclear_saveWorldName", GetWorldName())
      if saveSettings() then ost("Save world set to current world") end
   elseif name == "hsnclear_resetQueue" then
      Index = 1
      ost("Queue has been reset")
      editValue("hsnclear_currentQueue", "Current Queue: "..Index)
   elseif name == "hsnclear_sizeX" then
      ost("World size set to "..getValue(1, "hsnclear_sizeX").." x "..getValue(1, "hsnclear_sizeY"))
   elseif name == "hsnclear_sizeY" then
      ost("World size set to "..getValue(1, "hsnclear_sizeX").." x "..getValue(1, "hsnclear_sizeY"))   
   elseif name == "hsnclear_delay" then
      if saveSettings() then ost("Punch Delay set to "..g.delay) end
   elseif name == "hsnclear_delayWater" then
      if saveSettings() then ost("Water Delay set to "..getValue(1, "hsnclear_delayWater")) end   
   elseif name == "hsnclear_delayLag" then
      if saveSettings() then ost("Lag Delay set to "..getValue(1, "hsnclear_delayLag")) end   
   elseif name == "hsnclear_loadBtn" and getValue(2, "hsnclear_inputKey") == Key777 then
      hsnclear_mode = Hsnclear
      addIntoModule(hsnclear_mode, "HsnGL")
      if loadSettings() then ost("Script Loaded") end
   elseif name == "hsnclear_loadBtn" and getValue(2, "hsnclear_inputKey") ~= Key777 then
      dialogBuilder("ERROR", "Invalid Key!\n\nHow to get Key? (FREE!)\nJoin my Discord Server!\n\nLINK :\nhttps://discord.gg/3xKNPbB5qd", "OK")
   elseif name == "hsnclear_collect" and getValue(0, "hsnclear_collect") then
      ost("Auto Collect enabled")
      isCollect = true
   elseif name == "hsnclear_collect" and not getValue(0, "hsnclear_collect") then
      ost("Auto Collect disabled")
      isCollect = false
   elseif name == "hsnclear_antibounce" and getValue(0, "hsnclear_antibounce") then 
      ost("Antibounce enabled")
      editValue("Antibounce", true)
   elseif name == "hsnclear_antibounce" and not getValue(0, "hsnclear_antibounce") then 
      ost("Antibounce disabled")
      editValue("Antibounce", false)
   elseif name == "hsnclear_autoBan" then
      autoBan = value
      
      if value == true then
         ost("Auto Ban enabled")
      else
         ost("Auto Ban disabled")
      end      
   end    
end, "OnValue")
