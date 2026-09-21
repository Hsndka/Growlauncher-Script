local twIndex, twIndex_0 = 1, 1

local running = false
local anti_skip = false
local right_sweep = false
local dc = false
local isCollect = false

local targetWorlds = {}
local takeWorlds = {}
local cache = {}

local Hsnput = [[
{
  "sub_name": "Auto Put Block",
  "description": "Auto Put Block by HsnGL.",
  "icon": "DashboardCustomize",
  "menu": [
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "alias": "hsnput_startBtn",
          "text": "START/STOP"
      },
      {
          "type": "divider"
      },
      {
          "alias": "hsnput_block",
          "default": "Blank",
          "text": "Block to put",
          "type": "item_picker"
      },
      {
          "text": "Target World",
          "support_text": "Click to open World settings.",
          "type": "dialog",
          "fill": true,
          "background": false,
          "menu": [
              {
                 "background": false,
                 "text": "Auto Put Block Multi World [PREMIUM]",
                 "icon": "TipsAndUpdates",
                 "support_text": "Contoh/Example: DUNIA1, DUNIA2|ID, DUNIA3",
                 "type": "tooltip"
              },
              {
                 "alias": "hsnput_worldList",
                 "text": "World Name",
                 "icon": "Info",
                 "placeholder": "WORLD|ID, WORLD",
                 "default": "N/A",
                 "type": "input_string",
                 "label": "World List"
              },
              {
                  "type": "button",
                  "alias": "hsnput_getWorld",
                  "text": "Get Current World"
              },
              {
                  "type": "simple_display",
                  "icon": "TravelExplore",
                  "text": "World List",
                  "description": "A world list for Auto Harvest",
                  "alias": "hsnput_displayList",
                  "default": "[\"Beli premium ya kalau mau multi world :)\"]",
                  "setup": false
              },
              {
                  "type": "button",
                  "alias": "hsnput_refresh",
                  "text": "REFRESH LIST"
              }
          ]
      },
      {
          "text": "Take World",
          "support_text": "Click to open World settings.",
          "type": "dialog",
          "fill": true,
          "background": false,
          "menu": [
              {
                 "background": false,
                 "text": "Auto Put Block Multi World [PREMIUM]",
                 "icon": "TipsAndUpdates",
                 "support_text": "Contoh/Example: DUNIA1, DUNIA2|ID, DUNIA3",
                 "type": "tooltip"
              },
              {
                 "alias": "hsnput_tworldList",
                 "text": "World Name",
                 "icon": "Info",
                 "placeholder": "WORLD|ID, WORLD",
                 "default": "N/A",
                 "type": "input_string",
                 "label": "World List"
              },
              {
                  "type": "button",
                  "alias": "hsnput_tgetWorld",
                  "text": "Get Current World"
              },
              {
                  "type": "simple_display",
                  "icon": "TravelExplore",
                  "text": "World List",
                  "description": "A world list for Auto Harvest",
                  "alias": "hsnput_tdisplayList",
                  "default": "[\"Beli premium ya kalau mau multi world :)\"]",
                  "setup": false
              },
              {
                  "type": "button",
                  "alias": "hsnput_refresh",
                  "text": "REFRESH LIST"
              }
          ]
      },
      {
          "type": "slider",
          "text": " Put Delay :",
          "default": 180,
          "max": 500,
          "min": 180,
          "step": 100,
          "use_dot": true,
          "alias": "hsnput_delay"
      },
      {
          "type": "toggle",
          "text": "Anti miss",
          "description": "Slower but safer.",
          "default": false,
          "alias": "hsnput_antiMiss"
      },
      {
          "type": "toggle",
          "text": "Sweep from left",
          "description": "Always sweep from left to right.",
          "default": false,
          "alias": "hsnput_sweep"
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
          "alias": "hsnput_key"
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
          "alias": "hsnput_link"
      },
      {
          "type": "divider"
      }
]    
}
]]

addIntoModule(Hsnput, "HsnGL")
sendNotification("Auto Put Block by HanGL added!")

local take_world = ""
local target_world = ""

function wn(t) return t or "" end

local pref = require("preferences")
local db = wn(pref):new("AutoPutBlock.hsngl")
wn(db):save()
take_world = wn(db):get("takeWorld", "N/A")
target_world = wn(db):get("targetWorld", "N/A")

editValue("hsnput_worldList", target_world)
editValue("hsnput_tworldList", take_world)

function stopScript(reason)
   running, dc, isCollect = false, false, false
   twIndex, twIndex_0 = 1, 1
   
   editToggle("ModFly", false)
   
   if not getValue(0, "hsnput_startBtn") then
      return true
   end
   
   sendDialog({
       title = "Auto Put Block Stopped",
       message = reason.."\n\nHaving trouble?\nReport bugs or problem at my Discord Server.\n\nDiscord : @hsndika\n[https://discord.gg/3xKNPbB5qd]",
       confirm = "OK"
   })
   editValue("hsnput_startBtn", false)
end 
   
function getVar()
   cache = {
       targetWorlds = getValue(2, "hsnput_worldList"),
       takeWorlds = getValue(2, "hsnput_tworldList"),
       delay = getValue(1, "hsnput_delay"),
       block = getValue(1, "hsnput_block")
   }
   
   return cache
end

function rd(base)
  local offset = math.floor(base * 0.1)

  return math.random(base - offset, base + offset)
end

function w(t)
   if type(t) == "string" then
      return t
   end
   
   return ""   
end

function Notif(t)
   growtopia.notify("`c[HsnGL]`w "..t)
end

function toJsonArray(t)
   local parts = {}
   for i, v in ipairs(t) do
      parts[i] = '"'.. string.upper(v).. '"'
   end
   
   return "[".. table.concat(parts, ",").. "]"
end

function loadWorlds()
   targetWorlds = {}
   takeWorlds = {}

   local gv = getVar()
   
   for world in w(gv.targetWorlds):gmatch("[^,%s]+") do
      table.insert(targetWorlds, w(world):upper())
   end

   for world in w(gv.takeWorlds):gmatch("[^,%s]+") do
      table.insert(takeWorlds, w(world):upper())
   end

   if twIndex > #targetWorlds then
      twIndex = 1
   end
   
   if twIndex_0 > #takeWorlds then
      twIndex_0 = 1
   end
   
   local format = toJsonArray(targetWorlds)
   local format1 = toJsonArray(takeWorlds)
   
   editValue("hsnput_displayList", format)
   editValue("hsnput_tdisplayList", format1)
   
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

function reconnect()
   local timeout = 0
   local world
   
   if getLocal() then
      return true
   end
   
   Notif("Disconnected")
   
   repeat
      Sleep(5000)
      Notif("Reconnecting...")
      timeout = timeout + 1
   until dc or GetLocal() or timeout >= 120 or not running
   
   dc = false
   
   if timeout >= 120 then
      return false
   end
   
   if not running then
      return false
   end 
   
   if isCollect then
      world = takeWorlds[twIndex]
   else
      world = targetWorlds[twIndex_0]
   end
      
   if not warp(world) then
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
   
   Sleep(rd(3000))
   y = 0
   return true
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

function cek(id)
   return growtopia.checkInventoryCount(id)
end

function fp(x, y)
   local range = 6
   
   if not reconnect() then
      stopScript("Failed to reconnect")
      return false
   end
   
   local px, py = getLocal().posX//32, getLocal().posY//32
      
   if growtopia.isOnPos(x, y) then
      return true
   end
   
   while math.abs(y - py) > range and running do
      py = py + (y - py > 0 and range or range*-1)
      
      if not getTile(px, py).collidable then
         FindPath(px, py)
         Sleep(rd(200))
      end
   end
  
   while math.abs(x - px) > range and running do
      px = px + (x - px > 0 and range or range*-1)

      if not getTile(px, py).collidable then
         FindPath(px, py)
         Sleep(rd(200))
      end
   end
   
   if not running then
      return false
   end
  
   FindPath(x, y)
   Sleep(rd(100))
   return growtopia.isOnPos(x, y)
end

function warp(world)
   if not world or world == "" then
      sendNotification("No World")
      return false
   end
        
   local caps = w(world):upper()
   local filter = w(caps):match("^[^|]+")
   local timeout = 0
   
   if GetWorldName() == filter then
      return true
   end
   
   Notif("Warp to "..filter)
   growtopia.warpTo(world)
   
   repeat
      Sleep(3000)
      timeout = timeout + 1
      Notif("Waiting to arrive at "..filter)
   until GetWorldName() == filter or timeout >= 20 or dc or not running
   
   if not running then
      return false
   end
   
   if timeout >= 20 then
      return false
   end
   
   Sleep(3000)
   y = 0
   return GetWorldName() == filter
end

function collect(id)
   local radius = 6
   local before = cek(id)
   
   isCollect = true
   
   if not warp(takeWorlds[twIndex_0]) then
      stopScript("Failed to warp to take world.")
      return false
   end
      
   for _, obj in pairs(GetObjectList()) do
      local ox, oy = obj.posX//32, obj.posY//32
      
      if obj.itemid == id then
         if not ox or not oy then
            stopScript(getItemInfoByID(id).name.." not found")
            return false
         end
         
         if not running then
            return false
         end
         
         if getTile(ox, oy).collidable then
            goto continue
         end
         
         if not fp(ox, oy) then
            goto continue
         end   
         
         if not reconnect() then
            stopScript("Failed to reconnect")
            return false
         end
   
         local px, py = getLocal().posX//32, getLocal().posY//32
         
         if math.abs(ox - px) <= 5 and math.abs(oy - py) <= 2 then
            if cek(id) >= 200 then
               break
            end
            
            spr(11, obj.id, obj.posX, obj.posY)
            
            while before >= cek(id) and running do
               Sleep(100)
            end
            
            if not running then
               return false
            end
         end
      end    
      
      ::continue::
   end
   
   if before >= cek(id) then
      twIndex_0 = twIndex_0 + 1
      
      if twIndex_0 > #takeWorlds then
         stopScript(getItemInfoByID(id).name.." not found")
         return false
      end
     
      return "next"
   end
   
   isCollect = false
   return before < cek(id)
end

function mainLoop()
   local startX, endX
   local endY = 54
   local y = 0
   
   twIndex, twIndex_0 = 1, 1
   
   editToggle("ModFly", true)
   loadWorlds()
   
   if not warp(targetWorlds[twIndex]) then
      stopScript("Failed to warp to target world.")
      return false
   end
      
   while y < endY and running do
      local again = true
      
      while again and running do
         if not reconnect() then
            stopScript("Failed to reconnect")
            return false
         end
         
         local p = getLocal()
         local dx, dy = p.posX//32, p.posY//32
         
         if dx > 50 and not right_sweep then
            startX, endX = 99, 0
            step = -1
         else
            startX, endX = 0, 99
            step = 1
         end   
         
         local x = startX
         again = false
         
         if not running then
            return
         end
            
         while (x < endX and step == 1) or (x > endX and step == -1) do
            local c = getVar()
            local matchTile = {}
            local isOk = false
         
            if not reconnect() then
               stopScript("Failed to reconnect")
               return false
            end
         
            for ys = 0, 1 do
               local yt = y + ys
            
               for xs = 0, 4 do
                  local xt = x + xs * step
                  local key = xt..":"..yt
               
                  if getTile(xt, yt) and getTile(xt, yt).fg == 0 then
                     matchTile[key] = true
                     isOk = true
                  end 
               end
            end  
         
            if isOk then
               for i = 2, 0, -1 do
                  if not running then
                     return
                  end
          
                  local success = fp(x + i * step, y + 2)
 
                  if success then
                     if i < 2 then
                        x = x - i * step
                     end
                  
                     break
                  elseif i == 0 then
                     goto continue
                  end
               end
               
               if not reconnect() then
                  stopScript("Failed to reconnect")
                  return false
               end
               
               local cx, cy = getPos()
         
               for ys = -2, -1 do
                  local yt = cy + ys
            
                  for xs = -2, 2 do
                     local xt = cx + xs
                     local key = xt..":"..yt
                     
                     if not running then
                        return
                     end
                  
                     if matchTile[key] then
                        if cek(c.block) <= 0 then
                           if not reconnect() then
                              stopScript("Failed to reconnect")
                              return false
                           end
                           
                           local curX, curY = getPos()
                           
                           local loop = true
                           
                           while loop do
                              if not running then
                                 return
                              end
                  
                              local result = collect(c.block)
                              
                              if result == "next" then
                                 loop = true
                              elseif result == true then
                                 loop = false
                              else
                                 loop = false
                                 return false
                              end   
                           end
                           
                           if not warp(targetWorlds[twIndex]) then
                              stopScript("Failed to warp to target world.")
                              return false
                           end
                              
                           if not fp(curX, curY) then
                              stopScript("Failed to back to position.")
                              return false
                           end
                        end
                        
                        if not reconnect() then
                           stopScript("Failed to reconnect")
                           return false
                        end
                     
                        spr(3, c.block, xt, yt)
                     
                        if anti_skip then
                           local cd = 0
                           repeat
                              Sleep(10)
                              cd = cd + 10
                           until (getTile(xt, yt) and getTile(xt, yt).fg == c.block) or not running or not getLocal()
                           
                           if not reconnect() then
                              stopScript("Failed to reconnect")
                              return false
                           end
                           
                           if not running then
                              return
                           end
                  
                           if cd < 80 then
                              Sleep(rd(80 - cd))
                           end   
                        else
                           Sleep(rd(180))   
                        end
                     
                        again = true
                     end
                  end
               end
            end
         
            ::continue::
            x = x + 5 * step
         end
      end
         
      y = y + 2
   end
   
   if y >= 54 and twIndex >= #targetWorlds then
      stopScript("Auto Put finished!")
      return
   elseif y >= 54 and twIndex < #targetWorlds then
      Notif("Move to next World...")
      y = 0
      twIndex = twIndex + 1
      
      if not warp(targetWorlds[twIndex]) then
         stopScript("Failed to warp target world")
         return false
      end
      
      Sleep(1000)
   end       
end

addHook(function(var)
   if var.v1 == "OnRequestWorldSelectMenu" and running then
      dc = true
   end
end, "OnVariant")

addHook(function(pkt)
   if pkt.type == 4 and dc then
      Notif("Reconnected")
      dc = false
   end   
end, "OnGamePacket")

addHook(function(type, name, value)
   if name == "hsnput_startBtn" then
      if value then
         running = true
         
         wn(db):set("takeWorld", getValue(2, "hsnput_tworldList"))
         wn(db):set("targetWorld", getValue(2, "hsnput_worldList"))
         wn(db):save()
         
         runThread(function()
            local ok, err = pcall(mainLoop)

            if not ok then
               log(err)
            end
         end)
      else
         running = value
         Notif("STOPPED")
         stopScript()
      end 
   elseif name == "hsnput_getWorld" then
      editValue("hsnput_worldList", GetWorldName())
   elseif name == "hsnput_tgetWorld" then
      editValue("hsnput_tworldList", GetWorldName())   
   elseif name == "hsnput_refresh" then
      loadWorlds()
   elseif name == "hsnput_antiMiss" then
      anti_skip = value
   elseif name == "hsnput_sweep" then
      right_sweep = value
   end  
end, "OnValue")
