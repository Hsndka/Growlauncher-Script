addCategory("HsnGL", "FileOpen")

sendNotification("Auto Harvest by HsnGL added")

local Hsnht = [[
{
  "sub_name": "Auto Harvest",
  "description": "Auto Harvest by HsnGL.",
  "icon": "Agriculture",
  "menu": [
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "alias": "hsnht_startBtn",
          "text": "START/STOP"
      },
      {
          "type": "divider"
      },
      {
          "background": false,
          "text": "Tips",
          "icon": "TipsAndUpdates",
          "support_text": "Stand on Tree or Provider that will be harvested, then click START!.",
          "type": "tooltip"
      },
      {
          "text": "World Settings",
          "support_text": "Click to open World settings.",
          "type": "dialog",
          "background": false,
          "menu": [
              {
                 "background": false,
                 "text": "Auto Harvest Multi World [PREMIUM]",
                 "icon": "TipsAndUpdates",
                 "support_text": "Contoh/Example: DUNIA1, DUNIA2|ID, DUNIA3",
                 "type": "tooltip"
              },
              {
                 "alias": "hsnht_worldList",
                 "text": "World Name",
                 "icon": "Info",
                 "placeholder": "WORLD|ID, WORLD",
                 "default": "N/A",
                 "type": "input_string",
                 "label": "World List"
              },
              {
                  "type": "button",
                  "alias": "hsnht_getWorld",
                  "text": "Get Current World"
              },
              {
                  "type": "simple_display",
                  "icon": "TravelExplore",
                  "text": "World List",
                  "description": "A world list for Auto Harvest",
                  "alias": "hsnht_displayList",
                  "default": "[\"Beli premium ya kalau mau multi world :)\"]",
                  "setup": false
              },
              {
                  "type": "button",
                  "alias": "hsnht_refresh",
                  "text": "REFRESH LIST"
              }
          ]
      },    
      {
          "type": "toggle",
          "text": "Auto Collect Harvest",
          "description": "Automatically collect dropped items while harvesting.",
          "default": false,
          "expandable": true,
          "alias": "hsnht_collect",
          "list_child": [
              {
                  "type": "toggle",
                  "text": "Collect Gems",
                  "description": "Auto collect gems.",
                  "default": false,
                  "alias": "hsnht_gems"
              },
              {
                  "alias": "hsnht_dropPos",
                  "text": "Drop Position",
                  "icon": "FmdGood",
                  "placeholder": "67",
                  "default": "N/A",
                  "type": "input_string",
                  "label": "Position for drop"
              },
              {
                  "type": "button",
                  "alias": "hsnht_getPos",
                  "text": "Get Current Position"
              }
          ]   
      },
      {
          "type": "toggle",
          "text": "Auto Take Fuel Pack",
          "description": "Automatically take Fuel Pack in current world.",
          "default": false,
          "alias": "hsnht_fuel",
          "expandable": true,
          "list_child": [
              {
                  "background": false,
                  "text": "Note : Equip DCS, Fuel Pack and Harvester yourself!",
                  "icon": "WarningOutline",
                  "support_text": "",
                  "type": "tooltip"
              }
          ]   
      },
      {
          "type": "slider",
          "text": "Harvest Delay :",
          "default": 180,
          "max": 500,
          "min": 100,
          "step": 100,
          "use_dot": true,
          "alias": "hsnht_delay"
      },
      {
          "type": "divider"
      },
      {
          "type": "input_string",
          "icon": "VpnKey",
          "text": "Key Password",
          "label": "Input Key Password correctly!",
          "placeholder": "Key Password",
          "default": "",
          "alias": "hsnht_key"
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
          "alias": "hsnht_link"
      },
      {
          "type": "divider"
      }
]    
}
]]

addIntoModule(Hsnht, "HsnGL")

local running = false
local dc = false
local premium = false
local collect_ht = false
local takeGems = false
local takeFuel = false

local isBlocked, isFull, isDrop = false, false, false
local collectThreadRunning = false
local pendingDrop = {}

local id = 0
local twIndex = 1
local y = 0
local maxY = 60
local gems = 112
local fuel = 1746
   
local key = "HsnHT67"
local keyInput = ""
local worldName = ""
local dropPosition = ""
local RAW_URL = "https://raw.githubusercontent.com/Hsndka/Growlauncher-Script/main/Link.lua"

local config = {}
local worlds = {}
local dropPos = {}
Sleep(3000)

local RAW_WEBHOOK = "https://raw.githubusercontent.com/Hsndka/Growlauncher-Script/main/Webhook.lua"
local Webhook = nil

pcall(function()
    Webhook = load(fetch(RAW_WEBHOOK))()
end)

local userID = getDiscordID()

function w(text)
   if type(text) == "string" then
      return text
   end
   return ""   
end

function getVar()
   local dropPos = getValue(2, "hsnht_dropPos")
   local sx, sy = w(dropPos):match("(%d+)%s*,%s*(%d+)")
   
   config = {
       worlds = getValue(2, "hsnht_worldList"),
       dx = tonumber(sx),
       dy = tonumber(sy),
       delay = getValue(1, "hsnht_delay")
   }
   return config
end

function logs(text)
   log("`c[HsnGL] `w"..text)
end   

function notif(text)
   sendNotification("[Auto Harvest] "..text)
end

function ost(text)
   growtopia.notify("`c[HsnGL] `w"..text)
end

function wn(text)
   return text or ""  
end

local pref = require("preferences")
local db = wn(pref):new("AutoHarvest.hsngl")
wn(db):save()
keyInput = wn(db):get("Key", "N/A")
worldName = wn(db):get("List", "N/A")
dropPosition = wn(db):get("dropPos", "N/A")

editValue("hsnht_key", keyInput)
editValue("hsnht_worldList", worldName)
editValue("hsnht_dropPos", dropPosition)

local buyerList = {
    ["636196321232945152"] = "Author",
	["562894447315124227"] = "Admin",
    ["757840754453512212"] = "Mayo"
}

function cekMember(playerID)
  if buyerList[playerID] then
    return true, buyerList[playerID] -- return true + nama
  else
    return false, nil
  end
end        
--cekMember(userID)
if 1 + 1 == 2 then
   premium = true
   editValue("hsnht_key", "Test Version")
end
   
function stopScript(reason)
   running = false
   isDrop, isFull, isBlocked = false, false, false
   dc = false
   
   editToggle("ModFly", false)
   editToggle("collectfilter_onlytake", false)
   editToggle("collectfilter_enable", false)
   
   if not getValue(0, "hsnht_startBtn") then
      return true
   end
   
   sendDialog({
       title = "Auto Harvest Stopped",
       message = reason.."\n\nHaving trouble?\nReport bugs or problem at my Discord Server.\n\nDiscord : @hsndika\n[https://discord.gg/3xKNPbB5qd]",
       confirm = "OK"
   })
   editValue("hsnht_startBtn", false)
end
   
function rd(base)
  local offset = math.floor(base * 0.1)

  return math.random(base - offset, base + offset)
end

function spr(t, v, x, y)
   if not reconnect() then
      stopScript("Failed to reconnect.")
      return false
   end   
   
  SendPacketRaw(false, {
        type = t,
        value = v,
        px = x,
        py = y,
        x = GetLocal().posX,
        y = GetLocal().posY
  })
end

function Punch(x, y)
   if not getPos() or not running then
      return false
   end
   
   spr(3, 18, x, y)
end   

function getPos()
   local p = GetLocal()
   
   if not p then
      return false    
   end
      
   local px, py = p.posX//32, p.posY//32
   
   if px and py then
      return px, py
   end
end

local function toJsonArray(t)
    local parts = {}
    for i, v in ipairs(t) do
        -- jadiin huruf besar + kasih kutip dua
        parts[i] = '"'.. string.upper(v).. '"'
    end
    return "[".. table.concat(parts, ",").. "]"
end

function loadWorlds()
   worlds = {}

   local gv = getVar()

   for world in w(gv.worlds):gmatch("[^,%s]+") do
      table.insert(worlds, w(world):upper())
   end

   if twIndex > #worlds then
      twIndex = 1
   end
   
   local format = toJsonArray(worlds)
   
   editValue("hsnht_displayList", format)
end

function warp(world)
   local caps = w(world):upper()
   local filter = w(caps):match("^[^|]+")
   local timeout = 0
   
   if GetWorldName() == filter then
      return true
   end
   
   notif("Warp to "..filter)
   growtopia.warpTo(world)
   
   repeat
      Sleep(3000)
      timeout = timeout + 1
      notif("Waiting to arrive at "..filter)
   until GetWorldName() == filter or timeout >= 20 or dc or not running
   
   if timeout >= 20 then
      return false
   end
   
   y = 0
   return GetWorldName() == filter
end

function collision(x, y)
   if not reconnect() then
      stopScript("Failed to reconnect.")
       return false
   end 
     
   return getTile(x, y).collidable
end

function fp(x, y)
   local range = 6
   
   if not getPos() or not running then
      return false
   end
   
   local px, py = getPos()   
      
   if growtopia.isOnPos(x, y) then
      return true
   end
   
   while math.abs(y - py) > range do
      py = py + (y - py > 0 and range or range*-1)
      
      if not running then
         return false
      end
            
      if not reconnect() then
         stopScript("Failed to reconnect.")
         return false
      end   
   
      if not collision(px, py) then
         FindPath(px, py)
         Sleep(rd(200))
      end
   end
  
   while math.abs(x - px) > range do
      px = px + (x - px > 0 and range or range*-1)
      
      if not running then
         return false
      end
            
      if not reconnect() then
         stopScript("Failed to reconnect.")
         return false
      end   
      
      if not collision(px, py) then
         FindPath(px, py)
         Sleep(rd(200))
      end
   end
   
   if not reconnect() then
      stopScript("Failed to reconnect.")
      return false
   end   
      
   FindPath(x, y)
   Sleep(rd(100))
   return growtopia.isOnPos(x, y)
end

function cek(id)
   return growtopia.checkInventoryCount(id)
end

local droping = false

function drop(id)
   local timeout = 0
   local c = getVar()
   
   if cek(id) <= 0 then
      return true
   end
   
   if not getPos() or not running then
      return false
   end
   
   growtopia.dropItem(id)
   
   repeat
      Sleep(100)
      timeout = timeout + 1
   until isDrop or isFull or isBlocked or timeout >= 100 or dc or not running
   
   isDrop = false
   
   if not reconnect() then
      stopScript("Failed to reconnect.")
      return false
   end   
   
   if timeout >= 100 then
      return false
   end   
   
   if isBlocked then
      isBlocked = false
      stopScript("Tile Blocked!\nFailed to drop.")
      return false
   end
      
   if isFull then
      isFull = false
      
      local new_dx = c.dx - 1
      
      if new_dx < 0 then
         stopScript("Invalid coordinate!.")
         return false
      end   
      
      editValue("hsnht_dropPos", new_dx..", "..c.dy)
      return true
   end  
   
   if not running then
      stopScript("")
      return false
   end   
   
   growtopia.confirmDropItem(id, cek(id))
   timeout = 0
   
   repeat
      Sleep(100)
      timeout = timeout + 1
      
      if timeout % 10 == 0 then
         notif("Waiting to drop")
      end
   until cek(id) <= 0 or isFull or isBlocked or timeout >= 100 or dc or not running
   
   if timeout >= 100 then
      return false
   end   
            
   if not reconnect() then
      stopScript("Failed to reconnect.")
      return false
   end   
   
   if isBlocked then
      isBlocked = false
      stopScript("Tile Blocked!\nFailed to drop.")
      return false
   end
   
   if isFull then
      isFull = false
      
      local new_dx = c.dx - 1
      
      if new_dx < 0 then
         stopScript("Invalid coordinate!.")
         return false
      end   
      
      editValue("hsnht_dropPos", new_dx..", "..c.dy)
      return true
   end
   
   if not running then
      stopScript("")
      return false
   end
   
   dropPos[c.dx .. ":" .. c.dy] = true
   dropPos[c.dx + 1 .. ":" .. c.dy] = true
   
   return cek(id) <= 0
end

function collectHT()
   if not collect_ht then
      return true
   end
   
   if not running then
      return false
   end
            
   if not reconnect() then
      stopScript("Failed to reconnect.")
      return false
   end   
   
   local collected = false
   local dropList = {}
   local px, py = getPos()
   local c = getVar()
   
   runThread(function()
      for _, obj in pairs(GetObjectList()) do
         if obj.itemid == gems and not takeGems then
            goto continue
         end 
      
         if obj.itemid == fuel then
            goto continue
         end 
        
         local obx, oby = obj.posX//32, obj.posY//32
      
         local key = obx .. ":" .. oby
      
         if dropPos[key] then
            goto continue
         end
      
         if math.abs(obx - px) <= 5 and math.abs(oby - py) <= 2 then
            if cek(obj.itemid) >= 180 and obj.itemid ~= gems then
               dropList[obj.itemid] = true
               goto continue
            end
            
            spr(11, obj.id, obj.posX, obj.posY)
            Sleep(rd(10))
         end
      
         ::continue::
      end
  end)

   for itemid in pairs(dropList) do
      collected = true
         
      if not getPos() or not running then
         return false
      end

      if not fp(c.dx, c.dy) then
         return false
      end

      if not drop(itemid) then
         return false
      end

      Sleep(rd(500))
   end
   
   if collected then
      if not fp(px, py) then
         return false
      end
   end
   
   return true
end

function collect_fuel()
   if not takeFuel then
      return true
   end
      
   if cek(fuel) > 3 then
      return true
   end
   
   if not getPos() or not running then
      return false
   end
   
   for _, obj in pairs(getObjectList()) do
      if obj.itemid == fuel then
         local timeout = 0
         local obx, oby = obj.posX//32, obj.posY//32
         
         if not fp(obx, oby) then
            return false
         end  
         
         local px, py = getPos()
         
         if math.abs(obx - px) <= 5 and oby == py then
            spr(11, obj.id, obj.posX, obj.posY)
            Sleep(rd(30))
         end
         
         repeat
            Sleep(100)
            timeout = timeout + 1
         until cek(fuel) > 3 or timeout >= 100 or not running or not getLocal()
         
         if timeout >= 100 or not getLocal() then
            return false
         end
         
         if not running then
            stopScript("")
            return false
         end
         
         
         if not reconnect() then
            stopScript("Failed to reconnect.")
            return false
         end   
         
         if cek(fuel) > 3 then
            return true
         end 
      end 
   end       
end

function count()
   local counts = 0
   
   for _, tile in pairs(GetTiles()) do
      if tile and tile.fg == id and tile.readyharvest then
         counts = counts + 1
      end
   end
   
   return counts
end   
      
function webhook(method, reason)
   runThread(function()
      if not Webhook then
         return false
      end
      
      local status = ""
      
      if premium then
         status = "👑"
      else
         status = "👤"   
      end
          
      ost("Sending Webhook, please wait...")
      
      if method == 1 then
         local prov = id % 2 == 0
         local target = ""
         
         if prov then
            target = "<:blocks:1548562944848039936> "..getItemInfoByID(id).name
         else
            target = "<:trees:1548563045826039908> "..getItemInfoByID(id).name
         end   
         
         Webhook(">>> **Auto Harvest Webhook**\nUser :\n"..status.." <@"..userID..">\nStatus :\n<:online:1545964731955937290> RUNNING\nAction :\n<:harvest:1545964866379055235> Harvesting ("..twIndex.."/"..#worlds..")\nTarget :\n"..target.." ("..count()..")\n\n```js\n"..os.date("%d/%m/%y %H:%M").."```")
      elseif method == 2 then    
         Webhook(">>> **Auto Harvest Webhook**\nUser :\n"..status.." <@"..userID..">\nStatus :\n<:offline:1545964640008405133> STOPPED/ERROR\nAction :\n<:offline:1545964640008405133> STOPPED/ERROR\n\n```js\n"..os.date("%d/%m/%y %H:%M").."```")
      elseif method == 3 then
         Webhook(">>> **Auto Harvest Webhook**\nUser :\n"..status.." <@"..userID..">\nStatus :\n<:tested:1526677186843644035> FINISHED\nAction :\n<:sleep:1548469520195256421> Harvested ("..(twIndex - 1).."/"..#worlds..")\n\n```js\n"..os.date("%d/%m/%y %H:%M").."```")
      else
         Webhook(">>> **Auto Harvest Webhook**\nUser :\n"..status.." <@"..userID..">\nStatus :\n<:offline:1545964640008405133> ERROR\nError :\n<:offline:1545964640008405133> "..reason.."\n\n```js\n"..os.date("%d/%m/%y %H:%M").."```")
      end   
   end)   
end

function reconnect()
   local timeout = 0
   
   if getLocal() then
      return true
   end
   
   notif("Disconnected")
   
   if not premium then
      stopScript("Disconnected, buy Premium for Auto Reconnect")
      return false
   end
      
   repeat
      Sleep(5000)
      ost("Reconnecting...")
      timeout = timeout + 1
   until dc or GetLocal() or timeout >= 120 or not running
   
   if timeout >= 120 then
      return false
   end
   
   if not running then
      return false
   end 
   
   if not warp(worlds[twIndex]) then
      return false
   end
   
   timeout = 0
   repeat   
      Sleep(5000)
      timeout = timeout + 1
   until GetLocal() or timeout >= 120 or not running
   
   if timeout >= 120 then
      return false
   end 
   
   if not running then
      return false
   end 
   
   y = 0
   return true
end

function harvest()
   if not getLocal() then
      stopScript("Player not in a world!")
      return
   end
      
   if getValue(2, "hsnht_worldList") == "" or getValue(2, "hsnht_worldList") == "N/A" then
      stopScript("World name cannot be empty!")
      return
   end
   
   if (getValue(2, "hsnht_dropPos") == "" or getValue(2, "hsnht_dropPos") == "N/A") and collect_ht then
      stopScript("Drop position cannot be empty!")
      return
   end   

   y = 0
   maxY = 60
   dropPos = {}
   
   local hx, hy = getPos()
      
   if hx and hy then
      id = getTile(hx, hy).fg
   end   
   
   loadWorlds()
   twIndex = 1
   webhook(1)
   editToggle("ModFly", true)
   editToggle("collectfilter_onlytake", true)
   editToggle("collectfilter_enable", true)
   
   dropPos[getVar().dx .. ":" .. getVar().dy] = true
   dropPos[getVar().dx + 1 .. ":" .. getVar().dy] = true
   
   while y < maxY do
      local again = true
      local retry = 0
      local c = getVar()
      
      if not warp(worlds[twIndex]) then
         stopScript("Failed to warp")
         return false
      end
      
      while again and running do
         again = false
         retry = retry + 1
         
         if retry >= 6 then
            break
         end
         
         local p = GetLocal()
      
         if not p then return false end
   
         local playerX = math.floor(p.posX / 32)
         local startX, endX, step
 
         if playerX > 50 then
            startX = 99
            endX = 0
            step = -1
         else
            startX = 0
            endX = 99
            step = 1
         end
      
         local x = startX

         while (step == 1 and x <= endX)
            or (step == -1 and x >= endX) do
            
            if not running then
               return false
            end
            
            if not reconnect() then
               stopScript("Failed to reconnect.")
               return false
            end   

            local x1 = x
            local x2 = x + step
            local x3 = x + step * 2

            local y1 = y
            local y2 = y
            local y3 = y

            local valid1 = false
            local valid2 = false
            local valid3 = false

            if x1 >= 0 and x1 <= 99 then
               if not reconnect() then
                  stopScript("Failed to reconnect.")
                  return false
               end   
               
               local tile = getTile(x1, y1)

               if tile.fg == id and tile.readyharvest then
                  valid1 = true
               end
            end
            
            if x2 >= 0 and x2 <= 99 then
               if not reconnect() then
                  stopScript("Failed to reconnect.")
                  return false
               end   
               
               local tile = getTile(x2, y2)

               if tile.fg == id and tile.readyharvest then
                  valid2 = true
               end
            end

            if x3 >= 0 and x3 <= 99 then
               if not reconnect() then
                  stopScript("Failed to reconnect.")
                  return false
               end   
               
               local tile = getTile(x3, y3)

               if tile.fg == id and tile.readyharvest then
                  valid3 = true
               end
            end

            local fpX, fpY
                
            if valid1 then
               fpX, fpY = x1, y1
            elseif valid2 then
               fpX, fpY = x2, y2
            elseif valid3 then
               fpX, fpY = x3, y3
            end

            if fpX then

               if not collect_fuel() then
                  stopScript("Failed to collect Fuel Pack.")
                  return false
               end
               
               collectHT()

               if fp(fpX, fpY) then
                  if valid1 then
                     
                     if not reconnect() then
                        stopScript("Failed to reconnect.")
                        return false
                     end   
                     
                     local tile = getTile(x1, y1)

                     if tile.fg == id and tile.readyharvest then
                        Punch(x1, y1)
                        Sleep(rd(c.delay))
                     end
                  end

                  if valid2 then
                     if not reconnect() then
                        stopScript("Failed to reconnect.")
                        return false
                     end   
                     
                     local tile = getTile(x2, y2)

                     if tile.fg == id and tile.readyharvest then
                        Punch(x2, y2)
                        Sleep(rd(c.delay))
                     end
                  end

                  if valid3 then
                     if not reconnect() then
                        stopScript("Failed to reconnect.")
                        return false
                     end   
                     
                     local tile = getTile(x3, y3)

                     if tile.fg == id and tile.readyharvest then
                        Punch(x3, y3)
                        Sleep(rd(c.delay))
                     end
                  end
                  
                  again = true
               end
            end

            x = x + step * 3
         end
      end

      y = y + 1
      
      if y >= maxY then
         twIndex = twIndex + 1
         
         if twIndex > #worlds then
            logs("Finished! No more <`2"..getItemInfoByID(id).name.."``> to harvest.")
            notif("Finished! No more <"..getItemInfoByID(id).name.."> to harvest.")
            editToggle("ModFly", false)
            webhook(3)
            stopScript("Finished! No more <"..getItemInfoByID(id).name.."> to harvest.")
            return
         end
         
         if not premium then
            webhook(3)
            stopScript("Finished! buy Premium for Multi World.")
            return
         end
            
         Sleep(rd(3000))
         notif("Warp to next world...")
         warp(worlds[twIndex])
         Sleep(rd(3000))
         webhook(1)
         Sleep(5000)
         y = 0
      end   
   end
end            
   
addHook(function(var)
   if var.v1 == "OnDialogRequest" and w(var.v2):find("How many to drop") and running then
      isDrop = true
      return true
    
   elseif var.v1 == "OnTextOverlay" and w(var.v2):find("You can't drop that here, find an emptier spot") and running then
      isFull = true
      notif("Tile is full!")
      
   elseif var.v1 == "OnTextOverlay" and w(var.v2):match("You can't drop that here, face somewhere with open space.") and running then
     isBlocked = true
     notif("Blocked!")
   elseif var.v1 == "OnRequestWorldSelectMenu" and running then
      dc = true
   end
end, "OnVariant")

addHook(function(pkt)
   if pkt.type == 4 and dc then
      notif("Reconnected")
      dc = false
   end   
end, "OnGamePacket")

addHook(function(type, name, value)
   if name == "hsnht_startBtn" then
      if value == true and (key == getValue(2, "hsnht_key") or premium) then
         running = true
         
         wn(db):set("Key", getValue(2, "hsnht_key"))
         wn(db):set("List", getValue(2, "hsnht_worldList"))
         wn(db):set("dropPos", getValue(2, "hsnht_dropPos"))
         wn(db):save()
         
         runThread(function()
            local ok, err = pcall(harvest)
      
            if not ok then
               webhook(4, err)
               Sleep(5000)
               logs(err)
               stopScript(err)
            end
         end)   
      elseif value == true and key ~= getValue(2, "hsnht_key") then
         running = false
         
         sendDialog({
             title = "Invalid Key!",
             message = "How to get Key? (FREE!)\nJoin my Discord Server!\n\nLINK :\nhttps://discord.gg/3xKNPbB5qd",
             confirm = "OK"
         })
         editToggle("hsnht_startBtn", false)
      else
         running = false
         isDrop = false
         isFull = false
         isBlocked = false
         dc = false
         collectThreadRunning = false
         pendingDrop = {}

         ost("Auto Harvest Stopped")
         editToggle("ModFly", false)
         editToggle("collectfilter_onlytake", false)
         editToggle("collectfilter_enable", false)
      end
   elseif name == "hsnht_collect" then
      collect_ht = value
   elseif name == "hsnht_getPos" then
      local x, y = getPos()
      
      if x and y then
         editValue("hsnht_dropPos", x..", "..y)
      end   
   elseif name == "hsnht_gems" and collect_ht then
      takeGems = value
   elseif name == "hsnht_fuel" then
      takeFuel = value   
   elseif name == "hsnht_refresh" then
      loadWorlds()   
   elseif name == "hsnht_getWorld" then
      editValue("hsnht_worldList", GetWorldName())
   elseif name == "hsnht_link" and value == true then
      load(fetch(RAW_URL))()
      editToggle("hsnht_link", false)
   end
end, "OnValue")
