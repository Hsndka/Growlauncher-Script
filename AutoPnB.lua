local buyerList = {
    ["636196321232945152"] = "Author",
    ["1425567891780014100"] = "Revan",
    ["1390605855426084917"] = "Grizy",
    ["661504235271225364"] = "DNF",
    ["867382227871596615"] = "Peanuts",
    ["1181845446201704521"] = "Lynxornd",
    ["482201586131664943"] = "Sambros",
    ["1123160341958905867"] = "Wann21",
    ["499488277401829377"] = "Koendji",
    ["817606019240558604"] = "Tyowpwp",
    ["669433328650420234"] = "Alzails",
    ["280589937496162304"] = "Rey"
}

local running_, DC_, isUTDrop_ = false, false, false
local Premium, lastStock = false, false
local isDrop_, isFull_, isBlocked_ = false, false, false
local Popup0_, Popup1_, Popup2_ = false ,false, false
local getStatus_, gettingStatus_, isCured_ =  false, false, false
local isTornPunching, isGemCut = false, false

local config_put, config_break = true, true
local config_retrieveGAUT, gettingGAUT_ = false, false
local config_useConsumable = false
local config_collectDrops, config_collectGems = false, false
local config_autoBan = false
local config_autoConsume = false
local config_consumeSongpyeon, Songpyeon_cd = false, false
local config_consumeArroz, Arroz_cd = false, false
local config_autoCure, curePopup1_, curePopup2_ = false, false, false

local putCount_ = 1
local gautX, gautY, gautInv = 0, 0, 0
local gautID, gautType = 0, ""
local twIndex = 1

local keyPass = "HsnPNB33"

local configs = {}
local Tileselect = {}
local takeWorlds = {}

local startTime = os.clock()
local userID = tostring(getDiscordID())

local Hsnpnb = [[
{
  "sub_name": "Put and Break",
  "description": "Put and Break by HsnGL",
  "icon": "DashboardCustomize",
  "menu": [
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "text": "START/STOP",
          "default": false,
          "alias": "hsnpnb_startBtn"
      },
      {
          "type": "divider"
      },
      {
          "alias": "hsnpnb_block",
          "default": "Laser Grid",
          "text": "Block to break",
          "type": "item_picker"
      },   
      {
        "text": "PnB Setting",
        "support_text": "Click to open settings.",
        "type": "dialog",
        "menu": [
            {
                "alias": "hsnpnb_pnbPos",
                "text": "PnB Position",
                "icon": "FmdGood",
                "placeholder": "",
                "default": "N/A",
                "type": "input_string",
                "label": "Position for PnB"
            },
            {
                "type": "button",
                "alias": "hsnpnb_getPnbPos",
                "text": "Get Current Position"
            },
            {
                "type": "tooltip",
                "text": "Select Tile for ''Put and Break''",
                "background": false,
                "support_text": "Use fewer tiles to break soft blocks.",
                "icon": "DashboardCustomize"
            },
            {
                "type": "toggle",
                "text": "Put",
                "description": "Enable Put for PnB",
                "default": true,
                "alias": "hsnpnb_put"
            },
            {
                "type": "toggle",
                "text": "Break",
                "description": "Enable Break for PnB",
                "default": true,
                "alias": "hsnpnb_break"
            },
            {
                "type": "tile_select",
                "text": "",
                "default": "[]",
                "alias": "hsnpnb_tiles",
                "count": 5
            }
        ]
      },
      {
          "text": "World Setting",
          "support_text": "Click to open settings.",
          "type": "dialog",
          "menu": [
              {
                 "background": false,
                 "text": "Break World",
                 "icon": "TipsAndUpdates",
                 "support_text": "Contoh/Example: DUNIA|ID, DUNIA",
                 "type": "tooltip"
              },
              {
                 "alias": "hsnpnb_world",
                 "text": "World Name",
                 "icon": "Info",
                 "placeholder": "WORLD|ID, WORLD",
                 "default": "N/A",
                 "type": "input_string",
                 "label": "World Name"
              },
              {
                  "type": "button",
                  "alias": "hsnpnb_getWorld",
                  "text": "Get Current World"
              },
              {
                 "background": false,
                 "text": "Take World",
                 "icon": "TipsAndUpdates",
                 "support_text": "Contoh/Example: DUNIA1, DUNIA2|ID, DUNIA3",
                 "type": "tooltip"
              },
              {
                 "alias": "hsnpnb_takeWorlds",
                 "text": "World Name",
                 "icon": "Info",
                 "placeholder": "WORLD|ID, WORLD",
                 "default": "N/A",
                 "type": "input_string",
                 "label": "World List"
              },
              {
                  "type": "button",
                  "alias": "hsnpnb_getTakeWorld",
                  "text": "Get Current World"
              },
              {
                  "type": "simple_display",
                  "icon": "TravelExplore",
                  "text": "World List",
                  "description": "Take World list:",
                  "alias": "hsnpnb_displayList",
                  "default": "[\"Beli premium ya kalau mau multi world :)\"]",
                  "setup": false
              },
              {
                  "type": "button",
                  "alias": "hsnpnb_refresh",
                  "text": "REFRESH LIST"
              }
          ]
      },
      {
        "text": "Drop Setting",
        "support_text": "Click to open settings.",
        "type": "dialog",
        "menu": [
            {
                "type": "tooltip",
                "text": "General Drop Setting",
                "support_text": "",
                "background": false,
                "icon": "SettingsSuggest"
            },
            {
                "alias": "hsnpnb_dropWorld",
                "text": "Save World Name",
                "icon": "TravelExplore",
                "placeholder": "WORLD|ID or WORLD",
                "default": "N/A",
                "type": "input_string",
                "label": "World Name"
            },
            {
                "type": "button",
                "alias": "hsnpnb_getDropWorld",
               "text": "Get Current World"
            },
            {
                "alias": "hsnpnb_dropPos",
                "text": "Drop Position",
                "icon": "FmdGood",
                "placeholder": "",
                "default": "N/A",
                "type": "input_string",
                "label": "Position for drop"
            },
            {
                "type": "button",
                "alias": "hsnpnb_getDropPos",
                "text": "Get Current Position"
            },
            {
                "type": "tooltip",
                "text": "UT Drop Setting",
                "support_text": "",
                "background": false,
                "icon": "SettingsSuggest"
            },
            {
                "alias": "hsnpnb_UTDropPos",
                "text": "Drop Position",
                "icon": "FmdGood",
                "placeholder": "",
                "default": "N/A",
                "type": "input_string",
                "label": "Position for drop"
            },
            {
                "type": "button",
                "alias": "hsnpnb_getUTDropPos",
                "text": "Get Current Position"
            }
         ]
      },
      {
        "text": "Delay Setting",
        "support_text": "Click to open settings.",
        "type": "dialog",
        "menu": [
            {
                "type": "tooltip",
                "text": "Delay for Put and Break",
                "support_text": "Don't use low delay if you're lagging",
                "background": false,
                "icon": "HourglassTop"
            },
            {
                "type": "slider",
                "text": "Delay for Break",
                "max": 720,
                "min": 180,
                "default": 180,
                "alias": "hsnpnb_delayBreak"
            },
            {
                "type": "slider",
                "text": "Delay for Put",
                "max": 500,
                "min": 100,
                "default": 100,
                "alias": "hsnpnb_delayPut"
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
          "description": "Advanced settings for Put and Break"
      },
      {
          "type": "toggle",
          "text": "Auto Collect",
          "description": "Automatically collect dropped item from break.",
          "default": false,
          "expandable": true,
          "alias": "hsnpnb_collect",
          "list_child": [
              {
                  "type": "toggle",
                  "alias": "hsnpnb_collectGems",
                  "text": "Collect Gems",
                  "description": "Auto collect gems",
                  "default": false
              }
          ] 
      },
      {
          "type": "toggle",
          "text": "Auto Ban",
          "description": "Auto ban incoming players.",
          "default": false,
          "alias": "hsnpnb_autoBan"
      },
      {
          "type": "dropdown",
          "text": "👑 Action when got malady:",
          "default": 0,
          "value": "[\"Stop Auto\", \"Auto Cure\"]",
          "alias": "hsnpnb_malady"
      },
      {
          "type": "toggle",
          "text": "👑 Auto Retrieve GAUT",
          "description": "Automatically retrieve item from GAUT.",
          "default": false,
          "expandable": true,
          "alias": "hsnpnb_retrieveGAUT",
          "list_child": [
              {
                  "text": "Retrieve GAUT Setting",
                  "support_text": "Click to open settings.",
                  "type": "dialog",
                  "menu": [
                      {
                          "background": true,
                          "text": "Retrieve GAUT Setting",
                          "icon": "Inventory2",
                          "support_text": "Purchase Premium to use this feature.",
                          "type": "tooltip"
                      },
                      {
                          "alias": "hsnpnb_retrieveTreshold",
                          "text": "Minimum block placed",
                          "icon": "Terminal",
                          "placeholder": "",
                          "default": "200", 
                          "type": "input_int",
                          "label": "Auto retrieve after <n> block placed"
                      },
                      {
                          "background": true,
                          "text": "GAUT POSITION",
                          "icon": "Lightbulb",
                          "support_text": "Cara mengambil posisi gaut adalah player harus berdiri diatas GAUT lalu tekan GET CURRENT POSITION.",
                          "type": "tooltip"
                      },
                      {
                          "alias": "hsnpnb_UTPos",
                          "text": "UT Position",
                          "icon": "FmdGood",
                          "placeholder": "",
                          "default": "N/A",
                          "type": "input_string",
                          "label": "Unstable Tesseract coordinate"
                      },
                      {
                          "type": "button",
                          "alias": "hsnpnb_getUTPos",
                          "text": "Get Current Position"
                      },
                      {
                          "alias": "hsnpnb_GBPos",
                          "text": "Gaia Position",
                          "icon": "FmdGood",
                          "placeholder": "",
                          "default": "N/A",
                          "type": "input_string",
                          "label": "Gaia's Beacon coordinate"
                      },
                      {
                          "type": "button",
                          "alias": "hsnpnb_getGBPos",
                          "text": "Get Current Position"
                      }
                  ]
              }         
          ]   
      },
      {
          "type": "toggle",
          "expandable": true,
          "text": "👑 Auto Use Consumable",
          "description": "Automatically use consumable.",
          "default": false,
          "alias": "hsnpnb_consume",
          "list_child": [
              {
                  "text": "Auto Consume Setting",
                  "support_text": "Click to open settings.",
                  "type": "dialog",
                  "menu": [
                      {
                          "background": true,
                          "text": "Auto Consume Food Buff",
                          "icon": "Dining",
                          "support_text": "Purchase Premium to use this feature.",
                          "type": "tooltip"
                      },
                      {
                          "type": "toggle",
                          "text": "Songpyeon",
                          "default": false,
                          "description": "Automatically consumes Songpyeon if it's in inventory.",
                          "alias": "hsnpnb_consumeSongpyeon"
                      },
                      {
                          "type": "toggle",
                          "text": "Arroz Con Pollo",
                          "default": false,
                          "description": "Automatically consumes Arroz Con Pollo if it's in inventory.",
                          "alias": "hsnpnb_consumeArroz"
                      },
                      {
                          "background": false,
                          "text": "Request consumable?",
                          "icon": "TipsAndUpdates",
                          "support_text": "Tag me on Discord Server!",
                          "type": "tooltip"
                      }
                  ]   
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
          "text": "Key Password",
          "icon": "VpnKey",
          "description": "Premium User don't need to input Key Password."
      },
      {
          "type": "input_string",
          "icon": "VpnKey",
          "text": "Key Password",
          "label": "Input Key Password correctly!",
          "placeholder": "Key Password",
          "default": "",
          "alias": "hsnpnb_keyPass"
      },
      {
          "type": "tooltip",
          "text": "Join my Discord Server to get Key! (FREE)",
          "support_text": "",
          "background": true,
          "icon": "VpnKey"
      },
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "text": "Join Discord",
          "default": false,
          "alias": "hsnpnb_link"
      },
      {
          "type": "divider"
      }
]
}
]]

addCategory("HsnGL", "FileOpen")
addIntoModule(Hsnpnb, "HsnGL")    

local function w(text) -- Untuk mencegah warna pada tulisan menghilang karena bug executor
   if type(text) == "string" then
      return text
   end
   return ""   
end

local function wn(text) return text or "" end
local pref = require("preferences")
local db = wn(pref):new("PnB.hsngl")
wn(db):save()

local function rd(base)
  local offset = math.floor(base * 0.1)
  return math.random(base - offset, base + offset)
end

local function ipairs0(t)
   local i = -1
   return function()
      i = i + 1
      if t[i] ~= nil then
         return i, t[i]
      end
   end
end

local function Notify(text) growtopia.notify("`c[HsnGL] `w"..text) end
local function dialogBuilder(t, m, c) sendDialog({title = t, confirm = c, message = m}) end
local function getTimes(rawNumber)
   local h = math.floor(rawNumber / 3600)
   local sisa = rawNumber % 3600
   local m = math.floor(sisa / 60)
   local s = math.floor(sisa % 60)
   
   return h, m, s
end

local RAW_WEBHOOK = "https://raw.githubusercontent.com/Hsndka/Growlauncher-Script/main/Webhook.lua"
local Webhook, webhookSent = nil, false

sendNotification("Loading script...")
pcall(function()
    Webhook = load(fetch(RAW_WEBHOOK))()
    Sleep(3000)
end)
sendNotification("Put and Break by HsnGL added!")

local function sendWebhook(method)
   if webhookSent then return end
   
   local count = putCount_
   local elapsedTime = math.floor(os.clock() - startTime)
   local h, m, s = getTimes(elapsedTime)
   local Runtime = h.."h "..m.."m "..s.."s"
   webhookSent = true
   
   runThread(function()
      if not Webhook then
         return false
      end
      
      local block = getValue(1, "hsnpnb_block")
      local target = "🧱 "..getItemInfoByID(block).name.."\n(Counted: "..count.." **not accurate**)"
      local status = ""
      
      if Premium then
         status = "👑"
      else
         status = "👤"   
      end
      
      Notify("Sending Webhook, please wait...")
      
      if method == 0 then -- Stopped
         Webhook(">>> **Auto PnB Webhook**\nUser :\n"..status.." <@"..userID..">\nStatus :\n<:offline:1545964640008405133> STOPPED/ERROR\nTarget :\n"..target.."\nRuntime :\n🕓 "..Runtime.."\n\n```js\n"..os.date("%d/%m/%y %H:%M").."```")
      else -- Finished
         Webhook(">>> **Auto PnB Webhook**\nUser :\n"..status.." <@"..userID..">\nStatus :\n<:tested:1526677186843644035> FINISHED\nTarget :\n"..target.."\nRuntime :\n🕓 "..Runtime.."\n\n```js\n"..os.date("%d/%m/%y %H:%M").."```")
      end
   end)   
end

local function cekBuyer(playerID)
  if buyerList[playerID] then
    return true, buyerList[playerID] -- return true + nama
  else
    return false, nil
  end
end        

if cekBuyer(userID) or os.date("%A") == "Friday" then
   local name = "Tester"
   
   if cekBuyer(userID) then
      name = buyerList[userID]
      editValue("hsnpnb_keyPass", "Premium Version")
   end
      
   dialogBuilder("Auto PnB by HsnGL", "Verified, Welcome "..
   name.."\n\n==========================\n"..
   "Status : Premium\n\nNow you can access Premium\nfeatures "..
   "marked with 👑 icon.\n==========================\n\n"..
   "Last Update: 07/10/2026", "OK")
   
   Premium = true
else
   dialogBuilder("Auto PnB by HsnGL", "Welcome Free User"..
   "\n\n==========================\nStatus : Free\n\n"..
   "Test Version ended!\n"..
   "Now you can only access basic features."..
   "\nThere is always free [Premium] on Friday."..
   "\n==========================\n\n"..
   "Last Update: 07/10/2026", "OK")
   
   Premium = false
end 

local function toJsonArray(t)
    local parts = {}
    for i, v in ipairs(t) do
        parts[i] = '"'.. string.upper(v).. '"'
    end
    return "[".. table.concat(parts, ",").. "]"
end

local function getVar()
   local pnbPos = getValue(2, "hsnpnb_pnbPos")
   local bx, by = w(pnbPos):match("(%d+)%s*,%s*(%d+)")
   local dropPos = getValue(2, "hsnpnb_dropPos")
   local sx, sy = w(dropPos):match("(%d+)%s*,%s*(%d+)")
   local utDropPos = getValue(2, "hsnpnb_UTDropPos")
   local udx, udy = w(utDropPos):match("(%d+)%s*,%s*(%d+)")
   local gbPos = getValue(2, "hsnpnb_GBPos")
   local gx, gy = w(gbPos):match("(%d+)%s*,%s*(%d+)")
   local utPos = getValue(2, "hsnpnb_UTPos")
   local ux, uy = w(utPos):match("(%d+)%s*,%s*(%d+)")
   
   configs = {
       px = tonumber(bx), py = tonumber(by),
       dx = tonumber(sx), dy = tonumber(sy),
       gbx = tonumber(gx), gby = tonumber(gy),
       utx = tonumber(ux), uty = tonumber(uy),
       utdx = tonumber(udx), utdy = tonumber(udy),
       
       block = getValue(1, "hsnpnb_block"),
       break_delay = getValue(1, "hsnpnb_delayBreak"),
       put_delay = getValue(1, "hsnpnb_delayPut"),
       treshold = getValue(1, "hsnpnb_retrieveTreshold"),
       
       dropWorld = getValue(2, "hsnpnb_dropWorld"),
       takeWorlds = getValue(2, "hsnpnb_takeWorlds"),
       world = getValue(2, "hsnpnb_world")
   }
   return configs
end

local function saveConfigs()
   local config = getVar()
   
   wn(db):set("px", config.px); wn(db):set("py", config.py)
   wn(db):set("dx", config.dx); wn(db):set("dy", config.dy)
   wn(db):set("dropWorld", config.dropWorld)
   wn(db):set("gbx", config.gbx); wn(db):set("gby", config.gby)
   wn(db):set("utx", config.utx); wn(db):set("uty", config.uty)
   wn(db):set("utdx", config.utdx); wn(db):set("utdy", config.utdy)
   wn(db):set("world", config.world); wn(db):set("takeWorlds", config.takeWorlds)
   wn(db):set("block", config.block); wn(db):set("treshold", config.treshold)
   wn(db):set("pdelay", config.put_delay); wn(db):set("bdelay", config.break_delay)
   wn(db):save()
end

local function loadConfigs()
   local px, py = wn(db):get("px", -1), wn(db):get("py", -1)
   local dx, dy = wn(db):get("dx", -1), wn(db):get("dy", -1)
   local gbx, gby = wn(db):get("gbx", -1), wn(db):get("gby", -1)
   local utx, uty = wn(db):get("utx", -1), wn(db):get("uty", -1)
   local utdx, utdy = wn(db):get("utdx", -1), wn(db):get("utdy", -1)
   local dropWorld = wn(db):get("dropWorld", "N/A")
   local world, takeWorlds = wn(db):get("world", "N/A"), wn(db):get("takeWorlds", "N/A")
   local block, treshold = wn(db):get("block", 5666), wn(db):get("treshold", 200)
   local bdelay, pdelay = wn(db):get("bdelay", 180), wn(db):get("pdelay", 100)
   
   editValue("hsnpnb_pnbPos", px..", "..py)
   editValue("hsnpnb_dropPos", dx..", "..dy)
   editValue("hsnpnb_GBPos", gbx..", "..gby)
   editValue("hsnpnb_UTPos", utx..", "..uty)
   editValue("hsnpnb_UTDropPos", utdx..", "..utdy)
   editValue("hsnpnb_world", world)
   editValue("hsnpnb_dropWorld", dropWorld)
   editValue("hsnpnb_takeWorlds", takeWorlds)
   editValue("hsnpnb_block", getItemInfoByID(block).name)
   editValue("hsnpnb_retrieveTreshold", treshold)
   editValue("hsnpnb_delayPut", pdelay); editValue("hsnpnb_delayBreak", bdelay)
end

loadConfigs()

local function stopScript(reason)
   local elapsedTime = math.floor(os.clock() - startTime)
   local h, m, s = getTimes(elapsedTime)
   
   log("`c[PnB]`w Runtime: "..h.."h "..m.."m "..s.."s")
   
   running_, DC_, lastStock = false, false, false
   isDrop_, isFull_, isBlocked_ = false, false, false
   Popup0_, Popup1_, Popup2_ = false ,false, false
   getStatus_, gettingStatus_, isCured_ =  false, false, false
   gettingGAUT_, curePopup1_, curePopup2_ = false, false, false
   isUTDrop_ = false
   
   gautX, gautY, gautInv = 0, 0, 0
   gautID, gautType = 0, ""
   twIndex, putCount_ = 1, 1
   
   editToggle("ModFly", false)
   editToggle("collectfilter_enable", false)
   
   if not getValue(0, "hsnpnb_startBtn") then
      return true
   end
   
   sendDialog({
       title = "Put and Break Stopped",
       message = reason.."\n\nHaving trouble?\nReport bugs or problem at my Discord Server.\n\nDiscord : @hsndika\n[https://discord.gg/3xKNPbB5qd]",
       confirm = "OK"
   })
   editValue("hsnpnb_startBtn", false)
end

local function loadWorlds()
   local config = getVar()
   takeWorlds = {}

   for world in w(config.takeWorlds):gmatch("[^,%s]+") do
      table.insert(takeWorlds, w(world):upper())
      if not Premium then break end
   end

   if twIndex > #takeWorlds then twIndex = 1 end
   
   local format = toJsonArray(takeWorlds)
   
   editValue("hsnpnb_displayList", format)
end

local function getPos()
   if not getLocal() then
      return false
   end
   
   local px, py = getLocal().posX//32, getLocal().posY//32
   
   return px, py
end
   
local function Cek(id) return growtopia.checkInventoryCount(id) end

local function Disconnected()
   if not getLocal() or GetWorldName() == "EXIT" or getPing() == -1 then
      Notify("Disconnected")
      return true
   end   
end

local function punch(x, y)
   if Disconnected() then return true end
   local me = getLocal()
   SendPacketRaw(false, {
        type = 3,
        value = 18,
        state = me.isLeft and 16 or 0,
        px = x,
        py = y,
        x = GetLocal().posX,
        y = GetLocal().posY
   })
end

local function collectItem(t, v, obx, oby)
   if Disconnected() then return true end
   SendPacketRaw(false, {
        type = t,
        value = v,
        x = obx,
        y = oby
   })
end

local function spr(t, v, x, y)
  if Disconnected() then return true end
  SendPacketRaw(false, {
        type = t,
        value = v,
        px = x,
        py = y,
        x = GetLocal().posX,
        y = GetLocal().posY
  })
end

local function Fp(x, y)
   local attempt = 0
   
   if Disconnected() or not running_ then return true end
   if growtopia.isOnPos(x, y) then
      return true
   end
   
   repeat
      findPath(x, y)
      Sleep(500)
      attempt = attempt + 1
   until growtopia.isOnPos(x, y) or attempt > 3
   
   if growtopia.isOnPos(x, y) then return true end
   if attempt > 3 then return false end
end

local function worldFilter(rawWorld)
   if not rawWorld or rawWorld == "" then
      return false
   end
      
   local Upper = w(rawWorld):upper()
   local Filter = w(Upper):match("^[^|]+")
   
   return Filter
end
   
local function Warp(world, hasID)
   local filter = worldFilter(world)
   local timeout = 0
   
   if not filter then
      stopScript("WARP ERROR")
      return
   end

   if (not hasID or hasID == nil or hasID == "") and GetWorldName() == filter then 
      return true 
   end
    
   Notify("Warp to "..filter)
   growtopia.warpTo(world)
   
   repeat
      Sleep(3000)
      timeout = timeout + 1
      Notify("Waiting to arrive at "..filter)
   until GetWorldName() == filter or timeout >= 200 or not running_ or Disconnected()
   
   if timeout >= 200 or not running_ or not GetLocal() then
      return false
   end
   Sleep(3500)
   return GetWorldName() == filter
end

local function Reconnect(world)
   local timeout = 0
   
   repeat
      Sleep(5000)
      Notify("Reconnecting...")
      timeout = timeout + 1
   until DC_ or GetLocal() or timeout >= 120 or not running_
   
   if timeout >= 120 then return false end
   if not running_ then return end 
   if not Warp(world) then return false end
   
   timeout = 0
   repeat   
      Sleep(5000)
      timeout = timeout + 1
   until GetLocal() or timeout >= 120 or not running_
   
   if timeout >= 120 then return false end 
   if not running_ then return end 
   
   DC_ =  false
   return true
end

local function Drop(id)
   local config = getVar()
   local timeout = 0
   
   if Disconnected() or not running_ then return true end
   
   if Cek(id) <= 0 then return true end
   
   growtopia.dropItem(id)
   repeat
      Sleep(100)
      timeout = timeout + 1
   until isDrop_ or isFull_ or isBlocked_ or timeout >= 200 or Disconnected() or not running_
   
   if timeout >= 200 or Disconnected() then return false end
   
   if not running_ then return end
      
   if isBlocked_ then
      isBlocked_ = false
      stopScript("Gagal drop karena terhalang block.")
      return
   end
   
   if isFull_ then
      isFull_ = false
      
      if isUTDrop_ then
         local new_utdx = config.utdx - 1
      
         if new_utdx < 0 then
            stopScript("Posisi drop invalid.")
            return
         end
         isUTDrop_ = false
         editValue("hsnpnb_UTDropPos", new_utdx..", "..config.utdy)
      else
         local new_dx = config.dx - 1
      
         if new_dx < 0 then
            stopScript("Posisi drop invalid.")
            return
         end
      
         editValue("hsnpnb_dropPos", new_dx..", "..config.dy)
      end
      return true
   end
   
   isDrop_ = false
   timeout = 0
   
   growtopia.confirmDropItem(id, Cek(id))
   repeat
      Sleep(100)
      timeout = timeout + 1
   until Cek(id) <= 0 or isFull_ or isBlocked_ or timeout >= 200 or Disconnected() or not running_
   
   if timeout >= 200 or not getLocal() then return false end
   if not running_ then return end
   
   if isBlocked_ then
      isBlocked_ = false
      stopScript("Gagal drop karena terhalang block.")
      return
   end
   
   if isFull_ then
      isFull_ = false
      
      if isUTDrop_ then
         local new_utdx = config.utdx - 1
      
         if new_utdx < 0 then
            stopScript("Posisi drop invalid.")
            return
         end
         isUTDrop_ = false
         editValue("hsnpnb_UTDropPos", new_utdx..", "..config.utdy)
      else
         local new_dx = config.dx - 1
      
         if new_dx < 0 then
            stopScript("Posisi drop invalid.")
            return
         end
      
         editValue("hsnpnb_dropPos", new_dx..", "..config.dy)
      end
      return true
   end
   
   return Cek(id) <= 0
end

local function collectFloating()
   local config = getVar()
   
   for _, obj in pairs(getObjectList() or {}) do
      if obj.itemid == config.block then
         local obx, oby = obj.posX//32, obj.posY//32
         local px, py = getPos()
         
         if math.abs(obx - px) <= 6 and math.abs(oby - py) <= 6 then
            collectItem(11, obj.id, obj.posX, obj.posY)
         end 
      end
   end
end
           
local function takeBlock(world)
   if Disconnected() then return false end
   
   local config = getVar()
   local found = true
   local round = 0
   
   while found and running_ do
      local before = Cek(config.block)
      found = false
      round = round + 1
      
      for _, obj in pairs(GetObjectList() or {}) do
         if obj.itemid == config.block then
            if Disconnected() then 
               if not Reconnect(world) then
                  return false
               end
            end
         
            local obx, oby = obj.posX//32, obj.posY//32
            
            if not Fp(obx, oby) then
               goto continue
            end
            
            found = true
            collectFloating()
            
            if Cek(config.block) >= 190 then
               return true
            end  
            
            break
         end
         ::continue::
      end
      
      if found then 
         Sleep(100)
         if round >= 30 and (Cek(config.block) < before or Cek(config.block) == 200) then
            break
         end    
      end
   end
   return Cek(config.block) > 0
end
      
      
local function Collect()
   if not config_collectDrops then return true end
      
   local gems = 112
   local dropList = {}
   local config = getVar()
   
   if Disconnected() or not running_ then return true end
   
   for _, obj in pairs(GetObjectList() or {}) do
      local obx, oby = obj.posX//32, obj.posY//32
         
      if obj.itemid == gems and not config_collectGems then
      else
         for _, tile in ipairs0(Tileselect) do
            local px, py = getPos(); if not px then
               return true
            end
               
            local tx, ty = px + tile.x, py + tile.y
         
            if math.abs(obx - tx) <= 1 and oby == ty then
               if Cek(obj.itemid) >= 190 and obj.itemid ~= config.block then
                  dropList[obj.itemid] = true
                  break
               else
                  collectItem(11, obj.id, obj.posX, obj.posY)
               end   
            end
         end
      end
   end
   
   if not dropList or #dropList < 0 then return true end 
         
   for itemid in pairs(dropList) do
      local config = getVar()
   
      if Disconnected() or not running_ then return true end
      if not Warp(config.dropWorld) then
         stopScript("Gagal Warp ke save world")
         return false
      end
   
      if not Fp(config.dx, config.dy) then
         stopScript("Gagal menuju posisi drop.")
         return false
      end

      if not Drop(itemid) then
         stopScript("Gagal drop item.")
         return false
      end
      Sleep(rd(500))
   end
   return true
end

local function retrieveGAUT(types)
   local config = getVar()
   local timeout = 0
   local mx, my
   local blockID
   Popup0_, Popup1_, Popup2_ = false ,false, false
   gettingGAUT_ = true
   
   if types == 0 then
      mx, my = config.utx, config.uty + 1
      blockID = 6948
   else
      mx, my = config.gbx, config.gby + 1
      blockID = 6946
   end
       
   if Disconnected() then
      if not Reconnect(config.world) then
         stopScript("Failed to reconnect")
         return false
      end
   end
   
   if not Fp(mx, my - 1) then
      stopScript("Gagal Findpath ke GAUT")
      return false
   end
   
   if getTile(mx, my) and getTile(mx, my).fg == blockID then
      spr(3, 32, mx, my)
   else
      stopScript(getItemInfoByID(blockID).name.." tidak ditemukan.") 
      return false
   end
       
   repeat
      Sleep(100)
      timeout = timeout + 1
   until Popup0_ or Popup2_ or timeout >= 200 or not running_ or Disconnected()
      
   if timeout >= 200 then return false end
   if not running_ or Disconnected() then return true end  
    
   if Popup0_ then
      Popup0_ = false
      sendPacket(2, table.concat({
             "action|dialog_return",
             "dialog_name|"..gautType,
             "tilex|"..gautX.."|",
             "tiley|"..gautY.."|",
             "buttonClicked|retrieveitem",
             "chk_enablesucking|1"
      }, "\n"))
   end
   
   timeout = 0
   repeat
      Sleep(100)
      timeout = timeout + 1
   until Popup1_ or Popup2_ or timeout >= 200 or not running_ or Disconnected()
   
   local count = 0
   local Inventory = 200 - Cek(gautID)
   count = math.min(gautInv, Inventory)
   
   if timeout >= 200 then return false end
   if not running_ or Disconnected() then return true end   
   
   if Popup1_ then
      Popup1_ = false
      sendPacket(2, table.concat({
          "action|dialog_return",
          "dialog_name|itemremovedfromsucker",
          "tilex|"..gautX.."|",
          "tiley|"..gautY.."|",
          "itemtoremove|"..count
      }, "\n"))
   end
   
   local before = Cek(gautID)
   timeout = 0
   repeat
      Sleep(100)
      timeout = timeout + 1
   until Popup2_ or Cek(gautID) > before or timeout >= 200 or not running_ or Disconnected()
      
   if timeout >= 200 then return false end
   if not running_ or Disconnected() then return true end   
   
   return Cek(gautID) > before or Cek(gautID) >= 200
end
      
local function Retrieve()
   local config = getVar()
   
   if Disconnected() then return true end
   if not config_retrieveGAUT or not running_ then return true end   
   
   repeat
      local config = getVar()
      
      if not retrieveGAUT(1) then break end  
      
      Popup2_ = false
      if Cek(gautID) >= 200 then
         if Disconnected() or not running_ then return true end
         if not Warp(config.dropWorld) then
            stopScript("Gagal Warp ke save world")
            return false
         end
         
         if not Fp(config.dx, config.dy) then
            stopScript("Gagal Findpath ke area drop")
            return false
         end
            
         if not Drop(gautID) then
            stopScript("Gagal drop "..getItemInfoByID(gautID).name)
            return false
         end
         
         if Disconnected() or not running_ then return true end
         if not Warp(config.world) then
            stopScript("Gagal Warp ke break world.")
            return false
         end
      end 
   until gautInv <= 200 or not running_ or Disconnected()
   
   if not running_ or Disconnected() then return true end   
   
   repeat
      local config = getVar()
      
      if not retrieveGAUT(0) then break end  
      
      Popup2_ = false
      if Cek(gautID) > 0 then
         if lastStock or Cek(gautID) < 200 then
            return true
         end
         
         if Disconnected() or not running_ then return true end
         if not Fp(config.utdx, config.utdy) then
            stopScript("Gagal Findpath ke area drop UT.")
            return false
         end
         
         isUTDrop_ = true
         if not Drop(gautID) then
            stopScript("Gagal drop "..getItemInfoByID(gautID).name)
            return false
         end
         isUTDrop_ = false
      end 
   until gautInv <= 200 or not running_ or Disconnected()
   
   if not running_ or Disconnected() then return true end   
   
   if gautInv <= 0 and lastStock then
      return false
   end
   return true
end

local function PnB(x, y, world)
   local config = getVar()
   
   for _, pos in ipairs0(Tileselect) do
      local tx, ty = x + pos.x, y + pos.y
      local tile = getTile(tx, ty)
      local type_ = getItemInfoByID(config.block).type
      local filter = worldFilter(world)
      
      if Disconnected() then return "Disconnected" end
      
      if not growtopia.isOnPos(x, y) or GetWorldName() ~= filter then
         return "Invalid Position"
      end
      
      if Cek(config.block) <= 0 and config_put then return "Take" end
      if not Collect() then return false end
      
      if not growtopia.isOnPos(x, y) or GetWorldName() ~= filter then
         return "Invalid Position"
      end
      
      if ((type_ == 18 and tile and tile.bg ~= 0) or (type_ ~= 18 and tile and tile.fg ~= 0))
         and config_break then
         punch(tx, ty)
         Sleep(rd(config.break_delay))
      elseif ((type_ == 18 and tile and tile.bg == 0) or (type_ ~= 18 and tile and tile.fg == 0))
         and config_put then
         
         spr(3, config.block, tx, ty)
         Sleep(rd(config.put_delay))
         
         putCount_ = putCount_ + 1
         
         if putCount_ % config.treshold == 0 and config_retrieveGAUT then return "Retrieve" end  
      else
         Sleep(rd(100))
      end 
   end     
   return true
end

local function getStatus()
   local timeout = 0
   
   if not Premium then return true end
   
   gettingStatus_ = true
   
   if Disconnected() then return false end   
   
   sendPacket(2, 
       "action|wrench\n"..
       "|netid|"..GetLocal().netID
   )
   
   repeat
      Sleep(1000)
      Notify("Getting player info...")
      timeout = timeout + 1
   until getStatus_ or timeout >= 60 or Disconnected() or not running_
   
   getStatus_ = false
   
   if timeout >= 60 or Disconnected() then return false end
   
   Sleep(2000)
   return true
end

local function autoConsume()
   local food = true
   local sleepAdjust = 100
   local Songpyeon = 1056
   local Arroz = 4604
   
   if not config_autoConsume then return true end
   if Disconnected() or not running_ then return true end
   
   local px, py = getPos()
   
   if config_consumeSongpyeon and not Songpyeon_cd then
      if Disconnected() or not running_ then return true end
      if Cek(Songpyeon) <= 0 then
         dialogBuilder("[PnB] Auto Consume", "Songpyeon tidak cukup.", "OK")
         editValue("hsnpnb_consumeSongpyeon", false)
      else   
         spr(3, Songpyeon, px, py)
         Songpyeon_cd = true
         Sleep(1000)
         sleepAdjust = 3000
         Notify("Consumed Songpyeon, "..Cek(Songpyeon).." left")
      end  
   end
   
   if config_consumeArroz and not Arroz_cd then
      if Disconnected() or not running_ then return true end
      if Cek(Arroz) <= 0 then
         dialogBuilder("[PnB] Auto Consume", "Arroz con Pollo tidak cukup.", "OK")
         editValue("hsnpnb_consumeArroz", false)
      else   
         spr(3, Arroz, px, py)
         Arroz_cd = true
         Sleep(1000)
         sleepAdjust = 3000
         Notify("Consumed Arroz Con Pollo, "..Cek(Arroz).." left")
      end   
   end
   
   Sleep(sleepAdjust)
end

local function autoCure()
   local config = getVar()
   local timeout = 0
   
   if not config_autoCure then return true end
   if Disconnected() or not running_ then return true end
   
   if isTornPunching or isGemCut then
      if Cek(242) < 2 then
         stopScript("WL tidak cukup untuk Auto Cure\nKartu BPJS tidak tersedia.")
         return false
      end
      
      if not Warp("CUREGO") then return true end 
      
      local cx, cy = 60, 29
      
      if isGemCut then cx = 58 end
      if Disconnected() or not running_ then return true end
      if not Fp(cx, cy) then return true end
      
      timeout = 0
      spr(3, 32, cx, cy)
      repeat
         Sleep(100)
         timeout = timeout + 1
      until curePopup1_ or timeout >= 600 or Disconnected()
      curePopup1_ = false
      
      if timeout >= 600 or Disconnected() then return true end
         
      sendPacket(2, table.concat({
          "action|dialog_return",
          "dialog_name|autoSurgeonUi",
          "buttonClicked|purchaseCureBtn"
      }, "\n"))
      
      timeout = 0
      repeat
         Sleep(100)
         timeout = timeout + 1
      until curePopup2_ or timeout >= 600 or Disconnected()
      curePopup2_ = false
      
      if timeout >= 600 or Disconnected() then
         return true
      end
      
      sendPacket(2, table.concat({
          "action|dialog_return",
          "dialog_name|autoSurgeonCurePurchaseUi",
          "buttonClicked|purchaseCureBtn"
      }, "\n"))
      
      timeout = 0
      repeat
         Sleep(100)
         timeout = timeout + 1
      until isCured_ or timeout >= 600 or Disconnected()
      isCured_ = false
      
      if timeout >= 600 or Disconnected() then return false end
   end 
   
   isTornPunching, isGemCut = false, false
   return true
end

local function mainLoop()
   webhookSent = false
   
   if getValue(2, "hsnpnb_keyPass") ~= keyPass and not Premium then
      stopScript("Key Password salah")
      return
   end
      
   if not getValue(2, "hsnpnb_pnbPos"):match("^%s*%d+%s*,%s*%d+%s*$") then
      stopScript("Posisi PnB tidak boleh kosong!")
      return
   end
   
   if not Tileselect or #Tileselect <= 0 then
      stopScript("Pilih tile untuk PnB dulu!")
      return
   end   
   
   if getValue(2, "hsnpnb_world") == "" or getValue(2, "hsnpnb_world") == "N/A" then
      stopScript("World break tidak boleh kosong!")
      return
   end
   
   if getValue(2, "hsnpnb_dropWorld") == "" or getValue(2, "hsnpnb_dropWorld") == "N/A" 
   and (config_retrieveGAUT or config_collectDrops) then
      stopScript("World save tidak boleh kosong!")
      return
   end
   
   if getValue(2, "hsnpnb_takeWorlds") == "" or getValue(2, "hsnpnb_takeWorlds") == "N/A" then
      stopScript("World take tidak boleh kosong!")
      return
   end
   
   if not getValue(2, "hsnpnb_UTDropPos"):match("^%s*%d+%s*,%s*%d+%s*$") and config_retrieveGAUT then
      stopScript("Posisi Drop UT tidak boleh kosong!")
      return
   end
   
   if not getValue(2, "hsnpnb_UTPos"):match("^%s*%d+%s*,%s*%d+%s*$") and config_retrieveGAUT then
      stopScript("Posisi UT tidak boleh kosong!")
      return
   end
   
   if not getValue(2, "hsnpnb_GBPos"):match("^%s*%d+%s*,%s*%d+%s*$") and config_retrieveGAUT then
      stopScript("Posisi Gaia tidak boleh kosong!")
      return
   end
   
   if not getValue(2, "hsnpnb_dropPos"):match("^%s*%d+%s*,%s*%d+%s*$") and (config_retrieveGAUT or config_collectDrops) then
      stopScript("Posisi Drop tidak boleh kosong!")
      return
   end
   
   startTime = os.clock()
   loadWorlds()
   editToggle("ModFly", true)
   editToggle("collectfilter_onlytake", true)
   editToggle("collectfilter_enable", true)
   editToggle("cheat_config_fastdrop_active", false)
   
   if not getStatus() then
      stopScript("Gagal mendapatkan status player.")
      return false
   end
   
   Notify("PnB Started")
   
   while running_ do
      local config = getVar()
      
      if Disconnected() then
         if not Reconnect(config.world) then
            stopScript("Gagal untuk menyambung ulang.")
            return false
         end 
      end
      
      if not autoCure() then
         stopScript("Gagal menggunakan Auto Cure.")
         return false
      end
         
      autoConsume()
     
      local result = PnB(config.px, config.py, config.world)
      
      if result == "Disconnected" then
         if not Reconnect(config.world) then
            stopScript("Gagal untuk menyambung ulang.")
            return false
         end 
      elseif result == "Invalid Position" then
         if not Warp(config.world) then
            stopScript("Gagal kembali ke posisi break.")
            return false
         end  
         
         if not Fp(config.px, config.py) then
            if not w(config.world):find("|", 1, true) then
               stopScript("Gagal kembali ke posisi break.")
               return false
            else
               if not Warp(config.world, true) then
                  stopScript("Gagal kembali ke posisi break.")
                  return false
               end  
               
               if not Fp(config.px, config.py) then
                  stopScript("Gagal kembali ke posisi break.")
                  return false
               end  
            end
         end
         Sleep(1000)
      elseif result == "Take" then
         local take = false
   
         if lastStock then
            if not config_retrieveGAUT or not Retrieve() then
               sendWebhook(1)
               stopScript("Tidak ada lagi <"..getItemInfoByID(config.block).name.."> to break.")
               return false
            end
            Sleep(1000)
         else
            if not takeBlock(config.world) then
               Notify("Collecting block...")
            else
               take = true
               goto continue
            end
         
            while not take do
               if not Warp(takeWorlds[twIndex]) then
                  stopScript("Gagal kembali ke posisi break.")
                  return false
               end  
         
               if not takeBlock(takeWorlds[twIndex]) then
                  twIndex = twIndex + 1
               
                  if twIndex > #takeWorlds then
                     if config_retrieveGAUT then
                        lastStock = true
                        goto continue
                     else
                        sendWebhook(1)
                        stopScript("Tidak ada lagi <"..getItemInfoByID(config.block).name.."> to break.")
                        return false
                     end      
                  end    
                  Notify("Move to next take world")
               else
                  take = true
               end
            end 
         
            if not Warp(config.world) then
               stopScript("Gagal kembali ke posisi break.")
               return false
            end  
         
            if not Fp(config.px, config.py) then
               stopScript("Gagal kembali ke posisi break.")
               return false
            end
            
            ::continue::
            Sleep(1000)
         end    
      elseif result == "Retrieve" then
         if not Retrieve() then
            stopScript("Gagal retrieve GAUT.")
            return false
         end 
         
         if not Fp(config.px, config.py) then
            stopScript("Gagal kembali ke posisi break.")
            return false
         end
         
         Sleep(1000)
      end
   end
   return false
end         
           
addHook(function(var)
   if var.v1 == "OnDialogRequest" and (w(var.v2):find("add_button|retrieveitem|Retrieve Item")
      or w(var.v2):find("add_textbox|`6You are already carrying (%d+) (.-)!``|left|")
      or w(var.v2):find("add_textbox|`6The machine is currently empty!``|left|")) and gettingGAUT_ then
      gettingGAUT_ = false
      
      local x, y = w(var.v2):match("embed_data|tilex|(%d+)\nembed_data|tiley|(%d+)")
      local count, name = w(var.v2):match("add_textbox|The machine contains (%d+) `2(.-)``|left|")
      local retrieve = w(var.v2):find("add_button|retrieveitem|Retrieve Item")
      
      if retrieve then
         Popup0_ = true
      else
         Popup2_ = true
         
         if w(var.v2):find("add_textbox|`6The machine is currently empty!``|left|") then
            gautInv = 0
            return true
         end 
      end
      
      if x and y then
         gautType = w(var.v2):match("end_dialog|(.-)|Close|Update|")
         gautX, gautY = tonumber(x), tonumber(y)
         gautInv, gautID = tonumber(count), findItemID(name)
         sendNotification("[PnB] Found GAUT:\n   Type: "..gautType.."\n   Count: "..gautInv.."\n   itemID: "..gautID.."\n   Position: "..gautX..", "..gautY)
      end
      return true
   elseif var.v1 == "OnDialogRequest" and w(var.v2):find("end_dialog|itemremovedfromsucker|Close|Retrieve|") and running_ then
      Popup1_ = true
      Notify("Retrieving item from GAUT")
      return true
   elseif var.v1 == "OnDialogRequest" and w(var.v2):find("How many to drop") and running_ then
      isDrop_ = true
      return true
   elseif var.v1 == "OnTextOverlay" and w(var.v2):find("You can't drop that here, find an emptier spot") and running_ then
      isFull_ = true
   elseif var.v1 == "OnTextOverlay" and w(var.v2):match("You can't drop that here, face somewhere with open space") and running_ then
     isBlocked_ = true
   elseif var.v1 == "OnRequestWorldSelectMenu" and running_ then
      DC_ = true
   elseif var.v1 == "OnConsoleMessage" and w(var.v2):find("`$Lucky!`` mod removed") then
      Songpyeon_cd = false
   elseif var.v1 == "OnConsoleMessage" and w(var.v2):find("`$Food: Breaking Gems`` mod removed") then
      Arroz_cd = false
   elseif var.v1 == "OnDialogRequest" and w(var.v2):find("add_popup_name|WrenchMenu|") and gettingStatus_ then
      getStatus_ = true
      gettingStatus_ = false
      
      if w(var.v2):find("`wLucky!``") then
         Songpyeon_cd = true
      else
         Songpyeon_cd = false
      end
        
      if w(var.v2):find("wFood: Breaking Gems") then
         Arroz_cd = true
      else
         Arroz_cd = false
      end
      
      if w(var.v2):find("Malady: Torn Punching") then
         isTornPunching = true
      else
         isTornPunching = false
      end   
      
      if w(var.v2):find("Malady: Gem Cuts") then
         isGemCut = true
      else
         isGemCut = false
      end
      return true
   elseif var.v1 == "OnSpawn" and config_autoBan and running_ then
      local v2 = var.v2
      local netid = tonumber(w(v2):match("netID|(%d+)"))
      
      if netid then
         runThread(function()
            sendPacket(2, "action|wrench\n|netid|"..netid)
            Sleep(90)
            sendPacket(2, 
                "action|dialog_return\n"..
                "dialog_name|popup\n"..
                "netID|"..netid.."|\n"..
                "netID|"..netid.."|\n"..
                "buttonClicked|worldban"
            )
         end)   
      end
   elseif var.v1 == "OnConsoleMessage" and w(var.v2):find("You've clearly done far too much punching") then
      isTornPunching = true
      sendNotification("[PnB] Torn Punching Malady detected!")
   elseif var.v1 == "OnConsoleMessage" and w(var.v2):find("Ouch! You've clearly been handling too many gems") then
      isGemCut = true
      sendNotification("[PnB] Gem Cuts Malady detected!")   
   elseif var.v1 == "OnDialogRequest" and w(var.v2):find("`wAuto Surgeon Station``|left|14666|") and running_ then
      curePopup1_ = true
      return true
   elseif var.v1 == "OnDialogRequest" and w(var.v2):find("`wAre you sure you want to buy the cure?") and running_ then
      curePopup2_ = true
      return true
   elseif var.v1 == "OnConsoleMessage" and w(var.v2):find("You got cured for") then
      isCured_ = true
   end   
end, "OnVariant")

addHook(function(type, name, value)
   if name == "hsnpnb_startBtn" then
      if value then
         running_ = value
         saveConfigs()
         runThread(function()
            local ok, err = pcall(mainLoop)
         
            if not ok then
               stopScript(err)
            end
         end) 
      else
         running_ = value
         stopScript("")
         Notify("PnB Stopped.")
      end
   elseif name == "hsnpnb_malady" and value == 1 then
      if not Premium then
         dialogBuilder("Auto PnB by HsnGL", "Sorry, this feature is only for Premium users.", "Understand")
         config_autoCure = false
         editValue("hsnpnb_malady", 0)
      else
         config_autoCure = true
      end
        
      return true
   elseif name == "hsnpnb_malady" and value == 0 then
      config_autoCure = false
   elseif type == 6 and name == "hsnpnb_tiles" then
      Tileselect = value
   elseif name == "hsnpnb_getWorld" then
      editValue("hsnpnb_world", GetWorldName())
   elseif name == "hsnpnb_getTakeWorld" then
      editValue("hsnpnb_takeWorlds", GetWorldName())
   elseif name == "hsnpnb_getDropWorld" then
      editValue("hsnpnb_dropWorld", GetWorldName())     
   elseif name == "hsnpnb_refresh" then
      loadWorlds()
   elseif name == "hsnpnb_getPnbPos" then
      local px, py = getPos()
      
      if px and py then
         editValue("hsnpnb_pnbPos", px..", "..py)
      end   
   elseif name == "hsnpnb_getUTPos" then
      local px, py = getPos()
      
      if px and py then
         editValue("hsnpnb_UTPos", px..", "..py)   
      end   
   elseif name == "hsnpnb_getGBPos" then
      local px, py = getPos()
      
      if px and py then
         editValue("hsnpnb_GBPos", px..", "..py)   
      end   
   elseif name == "hsnpnb_getDropPos" then
      local px, py = getPos()
      
      if px and py then
         editValue("hsnpnb_dropPos", px..", "..py)
      end   
   elseif name == "hsnpnb_getUTDropPos" then
      local px, py = getPos()
      
      if px and py then
         editValue("hsnpnb_UTDropPos", px..", "..py)
      end      
   elseif name == "hsnpnb_put" then
      config_put = value
   elseif name == "hsnpnb_break" then   
      config_break = value
   elseif name == "hsnpnb_retrieveGAUT" and value then
      if not Premium then
         dialogBuilder("Auto PnB by HsnGL", "Sorry, this feature is only for Premium users.", "Understand")
         editValue("hsnpnb_retrieveGAUT", false)
      else
         config_retrieveGAUT = true
      end  
   elseif name == "hsnpnb_retrieveGAUT" and not value then
      config_retrieveGAUT = false
   elseif name == "hsnpnb_collect" then
      config_collectDrops = value
   elseif name == "hsnpnb_collectGems" then
      config_collectGems = value
   elseif name == "hsnpnb_consume" and value then
      if not Premium then
         dialogBuilder("Auto PnB by HsnGL", "Sorry, this feature is only for Premium users.", "Understand")
         editValue("hsnpnb_consume", false)
      else
         config_autoConsume = true
      end
   elseif name == "hsnpnb_consume" and not value then
      config_autoConsume = false
   elseif name == "hsnpnb_consumeSongpyeon" then
      config_consumeSongpyeon = value
   elseif name == "hsnpnb_consumeArroz" then
      config_consumeArroz = value
   elseif name == "hsnpnb_autoBan" then
      config_autoBan = value
   elseif name == "hsnpnb_link" then
      local RAW_URL = "https://raw.githubusercontent.com/Hsndka/Growlauncher-Script/main/Link.lua"
      load(fetch(RAW_URL))()
   end    
end, "OnValue")
