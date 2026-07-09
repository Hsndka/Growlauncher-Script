local buyerID = tostring(getDiscordID())

local buyerList = {
    ["636196321232945152"] = "Author"
}

function isWhitelisted(playerID)
  if buyerList[playerID] then
    return true, buyerList[playerID] -- return true + nama
  else
    return false, nil
  end
end
Sleep(1000)
sendNotification("Verifying...")
Sleep(5000)
if isWhitelisted(buyerID) then
  sendNotification("Verified, Welcome ".. buyerList[buyerID])
else
  log("Not Verified")
  return
end

--[[sendDialog({
    title = "Auto Buy Store Items by HsnGL",
    message = "BETA VERSION (not fully tested)\n[ID]\nScript ini masih dalam tahap pengembangan. Selama masa pengembangan, script akan digratisan hingga waktu yang belum ditentukan. Jika menemukan bug tolong dm discord saya @hsndika.\n[EN]\nThis script is still in beta. It will be free during development until further notice. If you find any bugs, please DM me on Discord @hsndika",
    confirm = "Understand",
    alias = "dialogConfirm"
})]]

sendDialog({
    title = "Auto Buy Store Items by HsnGL",
    message = "Welcome, "..buyerList[buyerID].."\nHow to use script:\n1. Go to an EMPTY WORLD\n2. Get item data\n3. Adjust the Settings\n4. Click START button\n\nIf you find any bugs please DM me on Discord @hsndika",
    confirm = "Ok",
	alias = "hsnstore_welcomeDialog"
})

													   	--[[
============================================================
=== Module
============================================================]]
addCategory("HsnGL", "FileOpen")

local Hsnstore = [[
{
  "sub_name": "Auto Buy Store Item",
  "description": "Auto Buy Store Item by HsnGL",
  "icon": "AutoMode",
  "menu": [
      {
          "type": "divider"
      },
      {
          "type": "label",
          "text" : "Pack Information"
      },
      {
          "type": "divider"
      },
      {
          "type": "label",
          "alias": "hsnstore_labelName",
          "text": "Pack Name : "
      },
      {
          "type": "label",
          "alias": "hsnstore_labelPrice",
          "text": "Pack Price : "
      },
      {
          "type": "label",
          "alias": "hsnstore_counterBuy",
          "text": "Purchased : "
      },
      {
          "type": "tooltip",
          "icon": "Lightbulb",
          "text": "How to change Pack?",
          "support_text": "Turn on GET DATA and buy one example pack until Pack Information is updated.",
          "background": "false"
      },   
      {
          "type": "toggle_button",
          "text": "GET DATA",
          "alias": "hsnstore_debugBtn",
          "default": "false"
      },
      {
          "type": "divider"
      },
      {
          "type": "label",
          "text" : "Settings"
      },
      {
          "type": "divider"
      },
      {
          "type": "label",
          "text": ""
      },
      {
      "text": "Setting for Automation",
      "support_text": "Click to open settings.",
      "type": "dialog",
      "menu": [
          {
              "type": "tooltip",
              "icon": "Warning",
              "text": "Warning!\nRUN AUTO IN AN EMPTY WORLD to avoid crashes.",
              "support_text": "",
              "background": true
          },
          {
              "type": "toggle",
              "description": "Automatically drop items if they reach the offset.",
              "text": "Auto Drop",
              "default": true,
              "alias": "hsnstore_dropToggle"
          },
          {
              "type": "input_int",
              "text": "Offset for drop",
              "placeholder": "Input Offset",
              "default": 1,
              "alias": "hsnstore_dropOffset",
              "icon": "Info"
          },
          {
              "type": "input_int",
              "text": "Buy count",
              "placeholder": "Input count",
              "default": 1,
              "alias": "hsnstore_buyCount",
              "icon": "Info"
          },
          {
              "type": "input_int",
              "text": "Tile spacing for drop",
              "placeholder": "Input Spacing",
              "label": "You have to press the RESET button if you want to change the Spacing.",
              "default": 10,
              "alias": "hsnstore_dropSpacing",
              "icon": "Info"
          },
          {
              "type": "tooltip",
              "icon": "Warning",
              "text": "All item coordinate data will reset if you click Reset Button.",
              "support_text": "",
              "background": true
          },
          {
              "type": "button",
              "alias": "hsnstore_resetBtn",
              "text": "Reset Current Settings"
          }
        ]
      },
      {
          "type": "slider",
          "text": "Delay",
          "alias": "hsnstore_delaySet",
          "min": 300,
          "max": 3000,
          "default": 1000,
          "use_dot": true
      },
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "text": "Start Auto",
          "alias": "hsnstore_startBtn",
          "default": false
      },
      {
          "type": "divider"
      },
      {
          "type": "label",
          "alias": "hsnstore_status",
          "text": "Status : Trial"
      }
]    
}
]]

addIntoModule(Hsnstore, "HsnGL")      
													   	--[[
============================================================
=== Global Variable
============================================================]]
function w(t)
  return t or ""
end

local pref = require("preferences")
local db = w(pref):new("Hsnstore.json")
w(db):save()

local cache = {}
local cacheTime = 0
local CACHE_MS = 500

function getVar()
  local now = os.clock() * 1000
  
  if now - cacheTime >= CACHE_MS  then
  cache = {
      offset = getValue(1, "hsnstore_dropOffset"),
      count = getValue(1, "hsnstore_buyCount"),
      spacing = getValue(1, "hsnstore_dropSpacing"),
      delay = getValue(1, "hsnstore_delaySet")
  }
  cacheTime = now
  end
  return cache
end

local running = false
local debug = false
local isFull = false
local isBlocked = false
local isDrop = true
local isBPFull = false
local isBought = false
local packName = ""
local packCode = ""
local packPrice = 0
local items = {}

local START_X = 98
local START_Y = 21
local nextX = START_X
local nextY = START_Y
													   	--[[
============================================================
=== Function
============================================================]]
function saveSettings()
    w(db):set("settings", {
        offset = getValue(1, "hsnstore_dropOffset"),
        count = getValue(1, "hsnstore_buyCount"),
        space = getValue(1, "hsnstore_dropSpacing")
    })
    w(db):save()
end

function loadSettings()
    local cfg = w(db):get("settings")

    if not cfg then
        return
    end

    editValue("hsnstore_dropOffset", cfg.offset)
    editValue("hsnstore_dropSpacing", cfg.space)
    editValue("hsnstore_buyCount", cfg.count)
end

function savePack()
    w(db):set(packCode,{
        packName = packName,
        packPrice = packPrice,
        nextX = nextX,
        nextY = nextY,
        items = items
    })
    w(db):save()
end

function loadPack()
    local data = w(db):get(packCode,nil)

    if not data or next(data) == nil then
        return false
    end

    packName = data.packName
    packPrice = data.packPrice
    nextX = data.nextX
    nextY = data.nextY
    items = data.items or {}
    return true
end

function ost(t)
  growtopia.notify("`c[HsnGL] "..t)
end

function notif(t)
  sendNotification("[HsnGL] "..t)
end

function cek(item)
  return growtopia.checkInventoryCount(item)
end  

function rnDelay(base)
  local offset = math.floor(base * 0.1)

  return math.random(base - offset, base + offset)
end

function buy()
  if not running then
    return false
  end  
  
  local buyTimeout = 0
  ost("Buying "..packName)
  sendPacket(2,
    "action|buy\n"..
    "item|"..packCode
  )
  repeat
    Sleep(200)
    buyTimeout = buyTimeout + 1
  until isBought or isBPFull or buyTimeout >= 50
  
  if isBPFull then
    isBPFull = false
    stopScript(13688, "Backpack Full", "Roses are `4Red`w, Violets are `cBlue`0. Kosongkan sebagian backpack, karena penyimpanan sudah penuh.")
    return isBPFull
  end
    
  return isBought
end

function fp(x, y)
  if not running then
    return false
  end  
  
  local px = math.floor(GetLocal().posX / 32)
  local py = math.floor(GetLocal().posY / 32)
  
  if px == x and py == y then
    return true
  end
    
  while math.abs(y - py) > 6 do
    py = py + (y - py > 0 and 6 or -6)
    FindPath(px, py)
    Sleep(rnDelay(200))
  end
  
  while math.abs(x - px) > 6 do
    px = px + (x - px > 0 and 6 or -6)
    FindPath(px, py)
    Sleep(rnDelay(200))
  end
  
  Sleep(rnDelay(200))
  FindPath(x, y)
  Sleep(rnDelay(1000))
  return growtopia.isOnPos(x, y)
end

function registerItem(name)
    if items[name] then
        return
    end

    if nextX < START_X - getVar().spacing then
        stopScript(3802, "Drop Area Full", "No more slot available.")
        return
    end

    items[name] = {
        x = nextX,
        y = nextY,
        startX = nextX,
        startY = nextY
    }
    
    notif("Registered New Item : "..name.." ("..nextX..","..nextY..")")
    nextY = nextY - 1

    if nextY < 0 then
        nextY = START_Y
        nextX = nextX - getVar().spacing
    end
    savePack()
end

function drop(itemid,data)
  if not running then
    return false
  end  
  
  growtopia.dropItem(itemid)
  
  local timeout = 0

  repeat
    Sleep(rnDelay(100))
    timeout = timeout + 1
  until isFull or isBlocked or timeout >= 10
  
  if isBlocked then
    stopScript(1234,"Blocked","Cannot drop.")
    isBlocked = false
    return false
  end

  if isFull then
    isFull = false
    data.x = data.x - 1

    if data.x < data.startX - getVar().spacing then
      data.x = data.startX
      data.y = data.y - 1
      
      if data.y < 0 then
        data.y = START_Y
        data.startX = data.startX - getVar().spacing
        data.x = data.startX
        
        if data.startX < START_X - getVar().spacing then
            stopScript(11136, "Failed to drop", "No more tiles available.")
            return false
        end
      end
    end

    fp(data.x,data.y)
    return drop(itemid,data)
  end
    
  growtopia.confirmDropItem(itemid,cek(itemid))
  timeout = 0
  repeat
    Sleep(200)
    timeout = timeout + 1
  until cek(itemid) < getVar().offset or timeout >= 50
  return cek(itemid)
end

function dropItems()
  if not isDrop then
    return true
  end
  
  if not running then
    return false
  end  
    
  for name,data in pairs(items) do
    local id = findItemID(name)
    
    if cek(id) >= getVar().offset then
      if not fp(data.x,data.y) then
        return false
      end

      if not drop(id,data) then
        return false
      end
    end
  end
  return true
end

function errorDialog(icon, text1, text2)
  growtopia.sendDialog(table.concat({
        "set_default_color|`c",
        "add_spacer|small|",
        "add_custom_button|HsnGL|state:disabled;icon:"..icon..";|",
        "add_textbox|"..text1.."|",
        "add_smalltext|`wScript stopped.|",
        "add_smalltext|`w"..text2.."|",
        "add_custom_break|",
        "reset_placement_x|",
        "add_spacer|small|",
        "add_quick_exit|",
        "add_spacer|small|",
        "end_dialog|errorDialog|||",
        "add_spacer|small|",
        "add_smalltext|`9[Having trouble?]|",
        "add_url_button|reportLink|`cReport bug here!``|noflags|https://discord.gg/3xKNPbB5qd|Visit the HsnGL's Discord?|0|0|",
        "add_custom_margin|x:300;y:0|\nadd_custom_button|DUMMY_PADDING_X|textLabel:``;state:disabled;middle_colour:0;border_colour:0;|"
    }, "\n"))
end

function stopScript(icon, title, text)
  errorDialog(icon, title, text)
  editToggle("collectfilter_enable", false)
  editToggle("ModFly", false)
  log("Script Stopped: "..title)
  running = false
  editToggle("hsnstore_startBtn", false)
end

loadSettings()
													   	--[[
============================================================
=== Main Loop
============================================================]]

function mainLoop()
  local buyCount = 0
  editToggle("collectfilter_enable", true)
  editToggle("ModFly", true)
  
  if packCode == "" then
    stopScript(1494, "Invalid Data", "Turn on GET DATA and buy one example pack!")
    return
  end
  
  if packPrice == 0 then
    stopScript(1494, "Invalid Data", "Turn on GET DATA and buy one example pack!")
    return
  end 
  
  while running do
    isBought = false
    
    if getGems() < packPrice then
      stopScript(14542, "Not Enough Gems", "Your gems are lower than the pack price.")
      return
    end
    
    if not running then
      break
    end
    
    if not dropItems() then
      stopScript(3802, "Invalid Data", "Turn on GET DATA and buy one example pack!")
      return
    end
    
    if buyCount >= getVar().count then
      stopScript(6292, "Auto Finished", "Total purchase: "..buyCount.." Packs and spent: "..math.floor(buyCount*packPrice).." Gems.")
      return
    end
    
    if not running then
      break
    end
    
    Sleep(rnDelay(getVar().delay))
    if not buy() then
      stopScript(11136, "Failed to buy", "Unknown Error!")
      return
    else
      buyCount = buyCount + 1
      editValue("hsnstore_counterBuy", "Purchased : "..buyCount.." Packs")
    end   
    Sleep(rnDelay(getVar().delay))
  end  
end
													   	--[[
============================================================
=== Hooks
============================================================]]

addHook(function(var)
  if var.v1 == "OnStoreRequest" and not debug and running then
    return true
    
  elseif debug and not running and var.v1 == "OnStorePurchaseResult" and w(var.v2):find("You've purchased") then
    local pack = w(var.v2):match("You've purchased `o(.-)``")
    local price = w(var.v2):match("for `$(%d[,%d]*)`` Gems.")
    
    if pack and price then
      packName = tostring(pack)
      editValue("hsnstore_labelName", "Pack Name : "..packName)
      packPrice = tonumber((w(price):gsub(",", "")))
      editValue("hsnstore_labelPrice", "Pack Price : "..packPrice.." Gems")
    end
    
  elseif var.v1 == "OnStorePurchaseResult" and w(var.v2):find("Received") then
    local received = w(var.v2):match("Received:%s*(.+)")

    if received then
      isBought = true
      notif("Successfully bought "..packName)
      received = w(received):gsub("`.", "")
      for item in w(received):gmatch("([^,]+)") do
        item = w(item):match("^%s*(.-)%s*$")
        item = w(item):gsub("^%d+%s+", "")
        
        registerItem(item)
      end
    end
  
  elseif var.v1 == "OnStorePurchaseResult" and w(var.v2):find("You don't have enough space in your inventory for that.") then
    isBPFull = true
    
  elseif var.v1 == "OnTextOverlay" and w(var.v2):find("You can't drop that here, find an emptier spot!") then
    isFull = true
    
  elseif var.v1 == "OnTextOverlay" and w(var.v2):find("You can't drop that here, face somewhere with open space.") then
    isBlocked = true
    
  elseif running and var.v1 == "OnDialogRequest" and w(var.v2):find("How many to drop?") then
    return true
  end
end, "OnVariant")

addHook(function(type, packet)
  if debug and not running and w(packet):match("action|buy") then
    local code = w(packet):match("item|([^\n]+)")
    if code then
      packCode = code
      
      if loadPack() then
        editValue("hsnstore_labelName","Pack Name : "..packName)
        editValue("hsnstore_labelPrice","Pack Price : "..packPrice.." Gems")
        ost("Loaded saved data.")
      end
    end
  end
end, "OnSendPacket")

addHook(function(type, name, value)
  if name == "hsnstore_debugBtn" and getValue(0, "hsnstore_debugBtn") then
    debug = true
    running = false
    items = {}
    nextX = START_X
    nextY = START_Y
    packName = ""
    packCode = ""
    packPrice = 0
    editValue("hsnstore_startBtn", false)
    editValue("hsnstore_labelName","Pack Name :")
    editValue("hsnstore_labelPrice","Pack Price :")
    editValue("hsnstore_counterBuy", "Purchased :")
    ost("GET DATA is ON")
  elseif name == "hsnstore_welcomeDialog" then
	ost("Added Auto Buy Pack by HsnGL"
				
  elseif name == "hsnstore_debugBtn" and not getValue(0, "hsnstore_debugBtn") then
    debug = false
    ost("GET DATA is OFF")
  
  elseif name == "hsnstore_dropToggle" and getValue(0, "hsnstore_dropToggle") then
    isDrop = true
    ost("Auto Drop is ON")
    
  elseif name == "hsnstore_dropToggle" and not getValue(0, "hsnstore_dropToggle") then
    isDrop = false
    ost("Auto Drop is OFF")
    
  elseif name == "hsnstore_delaySet" then
    ost("Delay set to "..getVar().delay)
    
  elseif name == "hsnstore_startBtn" and getValue(0, "hsnstore_startBtn") then
    running = true
    debug = false
    editValue("hsnstore_debugBtn", false)
    ost("Script running")
    runThread(function()
      local ok, err = pcall(mainLoop)

      if not ok then
        log(err)
        stopScript(11136,"Lua Error",err)
      end
    end)
    
  elseif name == "hsnstore_startBtn" and not getValue(0, "hsnstore_startBtn") then  
    editToggle("collectfilter_enable", false)
    editToggle("ModFly", false)
    log("Script Stopped by user")
    running = false
    ost("Scrip stopped")
    
  elseif name == "hsnstore_dropSpacing" or name == "hsnstore_dropOffset" or name == "hsnstore_buyCount" then
    saveSettings()
    ost("Settings saved")
    
  elseif name == "hsnstore_resetBtn" then
    log("All item data has been reset")
    items = {}
    nextX = START_X
    nextY = START_Y

    w(db):set(packCode,{
        packName = "",
        packPrice = 0,
        nextX = START_X,
        nextY = START_Y,
        items = {}
    })
    w(db):save()
  end  
end, "OnValue")
