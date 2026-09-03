load(fetch("https://raw.githubusercontent.com/Hsndka/Growlauncher-Script/main/GeneralModule.lua"))()

addCategory("HsnGL", "FileOpen")

sendNotification("Auto Move Item by HsnGL added")

local Hsnmove = [[
{
  "sub_name": "Auto Move Item",
  "description": "Auto Move Item by HsnGL.",
  "icon": "SyncAlt",
  "menu": [
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "alias": "hsnmove_startBtn",
          "text": "START/STOP"
      },
      {
          "type": "divider"
      },
      {
          "text": "Target Item Settings",
          "support_text": "Click to open Target Item settings.",
          "type": "dialog",
          "background": false,
          "menu": [
              {
                 "background": true,
                 "text": "Target Item Settings",
                 "icon": "Inventory",
                 "support_text": "",
                 "type": "tooltip"
              },
              {
                 "alias": "hsnmove_itemPicker",
                 "default": "Blank",
                 "text": "Select Item to move",
                 "type": "item_picker"
              },
              {
                 "type": "dropdown",
                 "text": "Drop Method:",
                 "icon": "AutoMode",
                 "default": 0,
                 "value": "[\"Horizontal\", \"Vertical\"]",
                 "alias": "hsnmove_dropMode"
              }
          ]
      },
      {
          "text": "World Settings",
          "support_text": "Click to open World settings.",
          "type": "dialog",
          "background": false,
          "menu": [
              {
                 "background": true,
                 "text": "Take World Settings",
                 "icon": "TravelExplore",
                 "support_text": "",
                 "type": "tooltip"
              },
              {
                 "background": false,
                 "text": "Multi take world",
                 "icon": "TipsAndUpdates",
                 "support_text": "Contoh/Example: DUNIA1, DUNIA2|ID, DUNIA3",
                 "type": "tooltip"
              },
              {
                 "alias": "hsnmove_twName",
                 "text": "Take World",
                 "icon": "Info",
                 "placeholder": "WORLD|ID, WORLD",
                 "default": "",
                 "type": "input_string",
                 "label": "Take world name"
              },
              {
                  "type": "button",
                  "alias": "hsnmove_getTW",
                  "text": "Get Current World"
              },
              {
                 "background": true,
                 "text": "Drop World Settings",
                 "icon": "TravelExplore",
                 "support_text": "",
                 "type": "tooltip"
              },
              {
                 "alias": "hsnmove_dwName",
                 "text": "Drop World",
                 "icon": "Info",
                 "placeholder": "WORLD|ID, WORLD",
                 "default": "",
                 "type": "input_string",
                 "label": "Drop world name"
              },
              {
                  "type": "button",
                  "alias": "hsnmove_getDW",
                  "text": "Get Current World"
              },
              {
                  "alias": "hsnmove_dwX",
                  "text": "Drop X",
                  "icon": "FmdGood",
                  "placeholder": "67",
                  "default": -1,
                  "type": "input_int",
                  "label": "X position for drop"
              },
              {
                  "alias": "hsnmove_dwY",
                  "text": "Drop Y",
                  "icon": "FmdGood",
                  "placeholder": "67",
                  "default": -1,
                  "type": "input_int",
                  "label": "Y position for drop"
              },
              {
                  "type": "button",
                  "alias": "hsnmove_getDWPos",
                  "text": "Get Current Position"
              }
          ]
      },
      {
          "type": "label",
          "text": ""
      },
      {
          "type": "slider",
          "text": "Delay :",
          "default": 500,
          "max": 1000,
          "min": 300,
          "step": 100,
          "use_dot": true,
          "alias": "hsnmove_delay"
      },
      {
          "type": "divider"
      },
      {
          "type": "tooltip",
          "text": "Join my Discord Server to get Key! (FREE)",
          "support_text": "",
          "background": true,
          "icon": "VpnKey"
      },
      {
          "type": "input_string",
          "icon": "VpnKey",
          "text": "Key Password",
          "label": "Input Key Password correctly!",
          "placeholder": "Key Password",
          "default": "",
          "alias": "hsnmove_key"
      },
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "text": "Join Discord",
          "default": false,
          "alias": "hsnmove_link"
      },
      {
          "type": "divider"
      }
]    
}
]]

addIntoModule(Hsnmove, "HsnGL")

local running = false
local isDrop, isFull, isBlocked = false, false, false
local horizontal = false
local takeWorlds = {}
local dropPos = {}
local twIndex = 1
local cache = {}
local localKey = "HsnMove777"
local RAW_URL = "https://raw.githubusercontent.com/Hsndka/Growlauncher-Script/main/Link.lua"

function wn(text) return text or "" end
local pref = require("preferences")
local db = wn(pref):new("AutoMove.hsngl")
wn(db):save()

function saveCfg()
   wn(db):set("Config", {
       key = getValue(2, "hsnmove_key"),
       delay = getValue(1, "hsnmove_delay"),
       item = getItemInfoByID(getValue(1, "hsnmove_itemPicker")).name,
       twName = getValue(2, "hsnmove_twName"),
       dwName = getValue(2, "hsnmove_dwName"), 
       dx = getValue(1, "hsnmove_dwX"), dy = getValue(1, "hsnmove_dwY")
   })
   wn(db):save()
end

function loadCfg()
   local cfg = wn(db):get("Config")

   if not cfg then
      return
   end
   
   editValue("hsnmove_key", cfg.key)
   editValue("hsnmove_itemPicker", cfg.item)
   editValue("hsnmove_twName", cfg.twName)
   editValue("hsnmove_dwName", cfg.dwName)
   editValue("hsnmove_dwX", cfg.dx)
   editValue("hsnmove_dwY", cfg.dy)
   editValue("hsnmove_delay", cfg.delay)
end

loadCfg()

function getVar()
  cache = {
      item = getValue(1, "hsnmove_itemPicker"),
      dropWorld = getValue(2, "hsnmove_dwName"),
      dx = getValue(1, "hsnmove_dwX"),
      dy = getValue(1, "hsnmove_dwY"),
      takeWorld = getValue(2, "hsnmove_twName"),
      delay = getValue(1, "hsnmove_delay")
  }
  return cache
end

function ost(text) growtopia.notify("`c[HsnGL] "..text) end
function msg(text) log("`c[Auto Move] "..text) end
function notif(text) sendNotification("[Auto Move] "..text) end

function w(text) 
   if type(text) == "string" then
      return text
   end
   return ""   
end

function stopScript(reason)
   running = false
   isDrop, isFull, isBlocked = false, false, false
   takeWorlds = {}
   twIndex = 1
   
   editToggle("ModFly", false)
   editToggle("Antipunch", false)
   editToggle("collectfilter_enable", false)
   
   if not getValue(0, "hsnmove_startBtn") then
      return true
   end
   
   sendDialog({
       title = "Auto Move Stopped",
       message = reason.."\n\nHaving trouble?\nReport bugs or problem at my Discord Server.\n\nDiscord : @hsndika\n[https://discord.gg/3xKNPbB5qd]",
       confirm = "OK"
   })
   editValue("hsnmove_startBtn", false)
end
   
function rd(base)
  local offset = math.floor(base * 0.1)

  return math.random(base - offset, base + offset)
end

function loadTakeWorlds()
   takeWorlds = {}

   local gv = getVar()

   for world in w(gv.takeWorld):gmatch("[^,%s]+") do
      table.insert(takeWorlds, w(world):upper())
   end

   if twIndex > #takeWorlds then
      twIndex = 1
   end
end

function cek(id)
   return growtopia.checkInventoryCount(id)
end

function spr(t, v, x, y)
  SendPacketRaw(false, {
        type = t,
        value = v,
        px = x,
        py = y,
        x = GetLocal().posX,
        y = GetLocal().posY
  })
end

function getPos()
   local p = GetLocal()
   local px, py = p.posX//32, p.posY//32
   
   if px and py then
      return px, py
   end
   
   return false      
end

function waitLocal(timeout)
   timeout = timeout or 10

   local count = 0

   repeat
      Sleep(200)
      count = count + 1
   until GetLocal() or count >= timeout

   return GetLocal() ~= nil
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
   until GetWorldName() == filter or timeout >= 20 or not running
   
   if timeout >= 20 then
      return false
   end
   
   return GetWorldName() == filter
end

function fp(x, y)
   local gv = getVar()
   
   if not getPos() then
      return false
   end
   
   local px, py = getPos()   
      
   if growtopia.isOnPos(x, y) then
      return true
   end
   
   while math.abs(y - py) > 6 do
      py = py + (y - py > 0 and 6 or -6)
      FindPath(px, py)
      Sleep(rd(200))
   end
  
   while math.abs(x - px) > 6 do
      px = px + (x - px > 0 and 6 or -6)
      FindPath(px, py)
      Sleep(rd(200))
   end
  
   FindPath(x, y)
   Sleep(rd(gv.delay))
   return growtopia.isOnPos(x, y)
end

function collect(id, x, y)
   local radius = 2
   
   if not getPos() then
      return false
   end
   
   local px, py = getPos()
      
   if math.abs(x - px) <= radius and math.abs(y - py) <= radius then
      spr(11, id, x, y)
   end 
end

function take()
   local gv = getVar()
   local found = false
   
   for _, obj in pairs(GetObjectList()) do
      if obj.itemid ~= gv.item then
         goto continue
      end
      
      local obX = math.floor(obj.posX / 32)
      local obY = math.floor(obj.posY / 32)
      local key = obX .. ":" .. obY
      
      if GetWorldName() == gv.dropWorld
         and dropPos[key] then
         goto continue
      end
      
      if not fp(obX, obY) then
         goto continue
      end
      
      local before = cek(gv.item)
      local timeout = 0
      
      notif("Collecting")
      collect(obj.id, obX, obY)
      
      repeat
         Sleep(10)
         timeout = timeout + 1
         
         if timeout % 100 == 0 and timeout / 100 >= 5 then
            notif("Waiting for auto collect (" ..
               math.floor(timeout / 10) .. "/10)")
         end
      until cek(gv.item) > before
         or timeout >= 1000
         or not running
      
      if not running then
         stopScript("")
         return false
      end
      
      if timeout >= 1000 and cek(gv.item) <= before then
         return false
      end
      
      if cek(gv.item) > before then
         found = true
      end
      
      if cek(gv.item) >= 200 then
         break
      end
      
      ::continue::
   end
   
   if not found and #takeWorlds > 1 then
      notif("Move to next take world")
   end
   
   return found
end 

function drop(id)
   local gv = getVar()
   local timeout = 0
   
   if cek(id) <= 0 then
      return true
   end
   
   growtopia.dropItem(id)
   
   repeat
      Sleep(100)
      timeout = timeout + 1
   until isDrop or isFull or isBlocked or timeout >= 100 or not running
   
   isDrop = false
   
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
      
      local newX, newY = gv.dx - 1, gv.dy -1
      
      if newX < 0 or newY < 0 then
         stopScript("Invalid coordinate!.")
         return false
      end   
      
      if horizontal then
         editValue("hsnmove_dwX", newX)
      else
         editValue("hsnmove_dwY", newY)
      end
         
      saveCfg()
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
   until cek(id) <= 0 or isFull or isBlocked or timeout >= 100 or not running
   
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
      
      local newX, newY = gv.dx - 1, gv.dy -1
      
      if newX < 0 or newY < 0 then
         stopScript("Invalid coordinate!.")
         return false
      end   
      
      if horizontal then
         editValue("hsnmove_dwX", newX)
      else
         editValue("hsnmove_dwY", newY)
      end
         
      saveCfg()
      return true
   end
   
   if not running then
      stopScript("")
      return false
   end   
    
   return cek(id) <= 0
end   

function mainLoop()
   if getValue(2, "hsnmove_key") ~= localKey then
      sendDialog({
          title = "Invalid Key!",
          message = "How to get Key? (FREE!)\nJoin my Discord Server!\n\nLINK :\nhttps://discord.gg/3xKNPbB5qd",
          confirm = "OK"
      })
      editValue("hsnmove_startBtn", false)
      return false
   end
      
   if getValue(1, "hsnmove_itemPicker") == 0 then
      stopScript("Select item to move first!")
      return false
   end
   
   if getValue(2, "hsnmove_dwName") == "" then
      stopScript("Set Drop World first!")
      return false
   end
   
   if getValue(2, "hsnmove_twName") == "" then
      stopScript("Set Take World first!")
      return false
   end
   
   if getValue(1, "hsnmove_dwX") < 0 or getValue(1, "hsnmove_dwY") < 0 then
      stopScript("Set the drop coordinate first!")
      return false
   end
   
   notif("Auto Started")
   msg("Auto Started")
   ost("Auto Started")
   editToggle("ModFly", true)
   editToggle("Antipunch", true)
   editToggle("collectfilter_onlytake", true)
   editToggle("collectfilter_enable", true)
   
   saveCfg()
   loadTakeWorlds()
   dropPos = {}
   
   while running do
      local gv = getVar()
      
      if cek(gv.item) > 0 then
         if not warp(gv.dropWorld) then
            stopScript("Failed to warp to "..w(gv.dropWorld):upper())
            return false
         end
         
         if not waitLocal() then
            stopScript("Failed to warp to "..w(gv.dropWorld):upper())
            return false
         end
         
         Sleep(rd(gv.delay))
         
         if not fp(gv.dx, gv.dy) then
            stopScript("Failed to Findpath ["..gv.dx..", "..gv.dy.."]")
            return false
         end
         
         if not drop(gv.item) then
            stopScript("Failed to drop")
            return false
         end   
         
         dropPos[gv.dx .. ":" .. gv.dy] = true
         dropPos[gv.dx + 1 .. ":" .. gv.dy] = true
   
         Sleep(rd(gv.delay))
      elseif cek(gv.item) <= 0 then
         if not warp(takeWorlds[twIndex]) then
            stopScript("Failed to warp to "..w(takeWorlds[twIndex]):upper())
            return false
         end
         
         if not waitLocal() then
            stopScript("Failed to warp to "..w(takeWorlds[twIndex]):upper())
            return false
         end
         
         Sleep(rd(gv.delay))
         
         if not take() then
            twIndex = twIndex + 1
            
            Sleep(rd(2000))
            
            if twIndex > #takeWorlds then
               stopScript("Auto Finished!\nFailed to find item.")
               return false
            end
         end
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
   end  
end, "OnVariant")

addHook(function(type, name, value)
   if name == "hsnmove_startBtn" then
      if value == true then
         running = true
         
         runThread(function()
            local sukses, hasil = pcall(mainLoop)

            if sukses then
               log("Result:"..hasil)
            else
               log("Error:"..hasil) -- hasil = "attempt to divide by zero"
            end
         end)  
        
      else
         stopScript("Stopped")
         ost("Auto Stopped")
      end   
     
   elseif name == "hsnmove_getTW" then
      ost("Take world updated")
      editValue("hsnmove_twName", GetWorldName())
  
   elseif name ==  "hsnmove_getDW" then
      ost("Drop world updated")
      editValue("hsnmove_dwName", GetWorldName())
    
   elseif name == "hsnmove_getDWPos" then
      if getPos() then
         local x, y = getPos()
         
         ost("Drop position updated")
         editValue("hsnmove_dwX", x)
         editValue("hsnmove_dwY", y)
      end
     
   elseif name == "hsnmove_delay" then
      ost("Delay set to : "..value)
    
   elseif name == "hsnmove_itemPicker" then
      ost("Item set to : "..value)
  
   elseif name == "hsnmove_link" and value == true then
      load(fetch(RAW_URL))()
      editToggle("hsnmove_link", false)   
   elseif name == "hsnmove_dropMode" then
      local options = {"Action: Drop Horizontal", "Action: Drop Vertical"}
      local selectedMode = options[tonumber(value) + 1] or "Unknown"
      local modes = tonumber(value) + 1
      
      if modes == 1 then
         horizontal = true
      elseif modes == 2 then
         horizontal = false
      end
         
      ost(selectedMode)
      return true
   end   
end, "OnValue")
