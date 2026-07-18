local buyerID = tostring(getDiscordID())

local buyerList = {
    ["636196321232945152"] = "Author",
	["562894447315124227"] = "Admin"
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
  dialogBuilder("Auto Clear World v1.0 by HsnGL", "Welcome Free User\n\nStatus : Free\n\nFeatures:\n - Auto Clear all world types ✔\n - Auto save water ✔\n - Multi worlds ❌\n - No Key required ❌\n - Auto collect and save drop item ❌\n - Auto reconnect ❌", "OK")
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
          "type": "divider"
      },
      {
          "type": "input_string",
          "text": "Target World",
          "default": "",
          "placeholder": "EXAMPLE, CONTOH, WORLD",
          "icon": "Info",
          "alias": "hsnclear_targetWorld"
      },
      {
          "text": "Setting for save world",
          "support_text": "Click to open World settings.",
          "type": "dialog",
          "background": false,
          "menu": [
              
              {
                 "background": false,
                 "text": "Save World Settings",
                 "icon": "TravelExplore",
                 "support_text": "",
                 "type": "tooltip"
              },
              {
                 "alias": "hsnclear_saveWorldName",
                 "text": "Save World",
                 "icon": "Info",
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
                  "icon": "Info",
                  "placeholder": "Input drop X",
                  "default": "",
                  "type": "input_int",
                  "label": "X position for drop"
              },
              {
                  "alias": "hsnclear_savePosY",
                  "text": "Drop Y",
                  "icon": "Info",
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
          "type": "slider",
          "text": "Packet Delay\n",
          "usedot": false,
          "max": 500,
          "min": 180,
          "default": 180,
          "alias": "hsnclear_delay"
      },
      {
          "type": "toggle",
          "text": "Auto Collect (Premium)",
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
          "type": "label",
          "text": ""
      },
      {
          "type": "divider"
      },
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "text": "START/STOP",
          "alias": "hsnclear_startBtn"
      },
      {
          "type": "divider"
      },
      {
          "type": "tooltip",
          "text": "More Free and Premium Scripts",
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
local Key777 = "HsnClear167"

if premium then
    addIntoModule(Hsnclear, "HsnGL")        
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
      delay = getValue(1, "hsnclear_delay")
      }
  return cache
end

local y = 0
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

local blacklist = {
    [6] = true,
    [8] = true,
    [242] = true,
    [226] = true,
    [3760] = true
}

-- ==========================================
-- FUNGSI PENDUKUNG
-- ==========================================
function whiteless(t) return t or "" end
function cek(id) return growtopia.checkInventoryCount(id) end
function msg(t) sendNotification("[HsnGL] "..t) end
function ost(t) growtopia.notify("`c[HsnGL] "..t) end

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
        targetWorld = getValue(2, "hsnclear_,targetWorld"),
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
    editValue("hsnclear_,targetWorld", cfg.targetWorld)
    editValue("hsnclear_saveWorldName", cfg.saveWorld)
    editValue("hsnclear_savePosX", cfg.dropX)
    editValue("hsnclear_savePosY", cfg.dropY)
    
end
loadSettings()

function pos()
    local p = GetLocal()
    if p then
        return math.floor(p.posX / 32), math.floor(p.posY / 32)
    else
       repeat
       if not running then return false end
       p = GetLocal()
       Sleep(1000)
       ost("Waiting for GetLocal")
       until p
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
    until GetWorldName() == wName(world) or timeout >= 10
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

function clearRadius(x, y, radius, world)
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
                if tile then
                    -- Hancurkan FG/BG jika bukan blacklist
                    if not blacklist[getTile(tx, ty).fg] and getTile(tx, ty).fg ~= 0 then
                        repeat 
                          if not reconnect(m, n, world) then 
                              errDialog("Failed to reconnect")
                              return false end
                          if not running then return false end
                          if isLocked then return false end
                          spr(3, 18, tx, ty)
                          Sleep(rnDelay(g.delay))
                        until getTile(tx, ty).fg == 0
                    end
                    collect(world)
                    if getTile(tx, ty).bg ~= 0 and not blacklist[getTile(tx, ty).fg] then
                        repeat
                         if not running then return false end
                         if not reconnect(m, n, world) then 
                              errDialog("Failed to reconnect")
                              return false end
                         if isLocked then return false end
                         spr(3, 18, tx, ty) 
                         Sleep(rnDelay(g.delay))
                        until getTile(tx, ty).bg == 0
                    end
                    collect(world)
                end
            end
        end
    end
end

-- FUNGSI FP DENGAN ESCAPE LOGIC
function safeFP(targetX, targetY, world)
    if fp(targetX, targetY) then return true end
    
    -- Gagal, mulai proses clearing
    local curX, curY = pos()
    clearRadius(curX, curY, 2, world)
    
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
            if not reconnect(m, n, world) then 
                errDialog("Failed to reconnect")
                    return false end
            fp(bestX, bestY)
            clearRadius(bestX, bestY, 2, world)
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

function autoDrop(x, y, id, world)
    local g = getVar()
    if not warp(g.saveWorld) then return false end
    if not waitLocal(100) then return false end
    if not fp(g.dx, g.dy) then return false end
    Sleep(rnDelay(1000))
    if not drop(id) then return false end
    if not warp(world) then return false end
    if not waitLocal(10) then return false end
    if not fp(x, y) then return false end
    Sleep(1000) -- Memberi waktu load world
    return true
end

function collect(world)
    if not premium then return true end
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
                if not autoDrop(b, c, obj.itemid, world) then return false end
            end
        end
    end
    return true
end

function reconnect(x, y, world)
   if not premium then return true end
   local g = getVar()
   
   if not GetLocal() then
      local limit = 0
      repeat
         if not running then return false end
         ost("Waiting to reconnect")
         Sleep(1000)
         limit = limit + 1
      until inMainMenu or GetLocal() or limit >= 300
      
      if limit >= 300 then 
         return false
      elseif inMainMenu then
         reconnected = false
         if not warp(world) then return false end
         Sleep(1000)
         inMainMenu = false
      end   
   else
      return true
   end
   Sleep(1000)
   
   if not safeFP(x, findY(y), world) then
       return false
   end
       
   return true
end         
   

function scan(x, y)
    putWater = false
    breakFg = false
    breakBg = false
    
    if getTile(x, y).flag >= 1024 and not blacklist[getTile(x, y).fg] and cek(822) >= 1 then putWater = true end
    if not blacklist[getTile(x, y).fg] and getTile(x, y).fg ~= 0 then breakFg = true end
    if getTile(x, y).bg ~= 0 and not blacklist[getTile(x, y).fg] then breakBg = true end
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
        Sleep(2000)
    else
       return
    end   
while y <= maxY and running do
    local h = getVar()
    local startX, endX, step
    
    if not running then return "stop" end
    if isLocked then return "locked" end
    
    if direction == 1 then
        startX = 0
        endX = 99
        step = 1
    else
        startX = 99
        endX = 0
        step = -1
    end

    for x = startX, endX, step do
        if not running then return "stop" end
        if isLocked then return "locked" end
        
        scan(x, y)
        
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
                if not running then return "stop" end
                if isLocked then return "locked" end
                if getTile(tx, y).flag >= 1024 and cek(822) >= 1 then
                    spr(3, 822, tx, y)
                    Sleep(rnDelay(h.delay+120))
                end
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
        while true do
            if not running then return "stop" end
            if not reconnect(x, y, world) then 
                errDialog("Failed to reconnect")
                return "stop"
            end 
            if isLocked then return "locked" end
            
            local tile = getTile(tx, y)

            if tile.fg == 0 or blacklist[tile.fg] then
                break
            end

            spr(3, 18, tx, y)
            Sleep(rnDelay(h.delay))
        end
    end
    collect(world)
end

-- Break BG
if breakBg then
    if not safeFP(x, findY(y), world) then break end

    for _, tx in ipairs(checkArr) do
        while true do
            if not running then return "stop" end
            if not reconnect(x, y, world) then 
                errDialog("Failed to reconnect")
                return "stop"
            end
            if isLocked then return "locked" end
        
            local tile = getTile(tx, y)

            if tile.bg == 0 then
                break
            end

            if blacklist[tile.fg] then
                break
            end

            spr(3, 18, tx, y)
            Sleep(rnDelay(h.delay))
        end
    end
    collect(world)
end
    end

    for x = 0, 99 do
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
        -- Aksi perbaikan (Re-run logika break/water untuk titik yang terlewat)
            if not safeFP(x, findY(y), world) then break end
        -- Logic Water
            if putWater and cek(822) >= 1 then
                if getTile(x, y).flag >= 1024 and cek(822) >= 1 then
                    spr(3, 822, x, y)
                    Sleep(rnDelay(h.delay+120))
                end
            end
        -- Logic Break
            if breakBg then
                repeat
                if not running then return "stop" end
                if isLocked then return "locked" end
                if not reconnect(x, y, world) then 
                    errDialog("Failed to reconnect")
                    return false
                end
                spr(3, 18, x, y) 
                Sleep(rnDelay(h.delay)) 
                until getTile(x, y).bg == 0
            end
            if breakFg then
                repeat 
                if not running then return "stop" end
                if isLocked then return "locked" end
                if not reconnect(x, y, world) then 
                    errDialog("Failed to reconnect")
                    return false
                end
                spr(3, 18, x, y) 
                Sleep(rnDelay(h.delay)) 
                until getTile(x, y).fg == 0
            end
    end
end
    
    y = y + 1
    
    direction = (math.floor(GetLocal().posX / 32) > 50) and -1 or 1
end

if premium and y >= 55 then
    msg("Move to next World")
    return "finish"
elseif not premium and y >= 55 then
    editToggle("hsnclear_startBtn", false)
    dialogBuilder("Done", whiteless(world):upper().." has been successfully cleared\n\nGet Premium to unlock Multi World.\nThank You.", "OK")
    return "stop"
end    
end

function mainLoop()
   local d = getVar()
   local worldList = loadWorldList()
   Index = math.max(1, math.min(Index, #worldList))
   
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

   while running and Index <= #worldList do
      local result = clear(worldList[Index])
      isLocked = false

      if result == "finish" then
         Index = Index + 1
      elseif result == "locked" then
         if premium then
            errDialog(GetWorldName().." is locked by someone else")
            Index = Index + 1
            isLocked = false
         else
            isLocked = false
            return false
         end  
      elseif result == "stop" then
         return false
      end
   end

   if Index > #worldList then
      Index = 1
      running = false
      editToggle("hsnclear_startBtn", false)
      dialogBuilder("Done", "All selected worlds have been cleared successfully.\n\nPlease share your experience at our Discord Server.\nThank You.", "OK")
   end
end

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
      running = false
   elseif name == "hsnclear_savePosX" then
      if saveSettings() then ost("Coordinate set to "..g.dx.." ,"..g.dy) end
   elseif name == "hsnclear_savePosY" then
      if saveSettings() then ost("Coordinate set to "..g.dx.." ,"..g.dy) end
   elseif name == "hsnclear_currentSavePos" then
      local a, b = pos()
      editValue("hsnclear_savePosX", a)
      editValue("hsnclear_savePosY", b)
      if saveSettings() then ost("Drop coordinate set to current position") end
   elseif name == "hsnclear_currentSaveName" then
      editValue("hsnclear_saveWorldName", GetWorldName())
      if saveSettings() then ost("Save world set to current world") end
   elseif name == "hsnclear_delay" then
      if saveSettings() then ost("Delay set to "..g.delay) end
   elseif name == "hsnclear_loadBtn" and getValue(2, "hsnclear_inputKey") == Key777 then
      hsnclear_mode = Hsnclear
      addIntoModule(hsnclear_mode, "HsnGL")
      ost("Script Loaded")
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
   end    
end, "OnValue")














