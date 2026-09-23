local buyerList = {
    ["636196321232945152"] = "Author",
	["562894447315124227"] = "Admin"
}

sendNotification("[HsnGL] Loading script...")

addCategory("HsnGL", "FileOpen")

local running = false
local dc = false
local isCollecting = false

local userID = getDiscordID()
local id = 0
local twIndex = 1

local key = "HsnHT67"

local data = {}
local targetWorlds = {}

local Hsnpt = [[
{
  "sub_name": "Auto Plant",
  "description": "Auto Plant by HsnGL.",
  "icon": "Crops",
  "menu": [
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "alias": "hsnpt_startBtn",
          "text": "START/STOP"
      },
      {
          "type": "divider"
      },
      {
          "alias": "hsnpt_seed",
          "default": "Blank",
          "text": "Seed to plant",
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
                 "text": "Auto Plant Multi World [PREMIUM]",
                 "icon": "TipsAndUpdates",
                 "support_text": "Contoh/Example: DUNIA1, DUNIA2|ID, DUNIA3",
                 "type": "tooltip"
              },
              {
                 "alias": "hsnpt_worldList",
                 "text": "World Name",
                 "icon": "Info",
                 "placeholder": "WORLD|ID, WORLD",
                 "default": "N/A",
                 "type": "input_string",
                 "label": "World List"
              },
              {
                  "type": "button",
                  "alias": "hsnpt_getWorld",
                  "text": "Get Current World"
              },
              {
                  "type": "simple_display",
                  "icon": "TravelExplore",
                  "text": "World List",
                  "description": "A world list for Auto Harvest",
                  "alias": "hsnpt_displayList",
                  "default": "[\"Beli premium ya kalau mau multi world :)\"]",
                  "setup": false
              },
              {
                  "type": "button",
                  "alias": "hsnpt_refresh",
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
                 "background": true,
                 "text": "Take World Settings",
                 "icon": "SettingsSuggest",
                 "support_text": "",
                 "type": "tooltip"
              },
              {
                  "type": "toggle",
                  "text": "Take Current World",
                  "default": true,
                  "description": "Take seed from current world.",
                  "alias": "hsnpt_takeCurrentWorld"
              },   
              {
                  "type": "toggle",
                  "text": "Take Other World",
                  "default": false,
                  "description": "Take seed from other world.",
                  "alias": "hsnpt_takeOtherWorld",
                  "expandable": true,
                  "list_child": [
                      {
                          "alias": "hsnpt_takeWorld",
                          "text": "World Name",
                          "icon": "Info",
                          "placeholder": "WORLD|ID, WORLD",
                          "default": "N/A",
                          "type": "input_string",
                          "label": "Take World Name"
                      },
                      {
                          "type": "button",
                          "alias": "hsnpt_getTakeWorld",
                          "text": "Get Current World"
                      }
                  ]   
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
          "alias": "hsnpt_delay"
      },
      {
          "type": "toggle",
          "text": "Anti Miss",
          "description": "Slower but safer.",
          "default": false,
          "alias": "hsnpt_antiMiss"
      },
      {
          "type": "toggle",
          "text": "Sweep from left",
          "description": "Always sweep from left to right.",
          "default": false,
          "alias": "hsnpt_sweepLeft"
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
          "alias": "hsnpt_key"
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
          "alias": "hsnpt_link"
      },
      {
          "type": "divider"
      }
]    
}
]]

addIntoModule(Hsnpt, "HsnGL")
sendNotification("Auto Put Block by HanGL added!")

function getVar()
   data = {
       seed = getValue(1, "hsnpt_seed"),
       targetWorlds = getValue(2, "hsnpt_worldList"),
       takeWorlds = getValue(2, "hsnpt_takeWorld"),
       delay = getValue(1, "hsnpt_delay"),
       antiMiss = getValue(0, "hsnpt_antiMiss"),
       sweepLeft = getValue(0, "hsnpt_sweepLeft"),
       takeCurrentWorld = getValue(0, "hsnpt_takeCurrentWorld")
   }
   return data
end

local function w(text)
   if type(text) == "string" then
      return text
   end
   return "" 
end   
     
local function wn(text) return text or "" end
local pref = require("preferences")
local db = wn(pref):new("AutoPlant.hsngl")
wn(db):save()
local take_world = wn(db):get("takeWorld", "N/A")
local target_world = wn(db):get("targetWorld", "N/A")

editValue("hsnpt_worldList", target_world)
editValue("hsnpt_takeWorld", take_world)

function ost(text)
   growtopia.notify("`c[HsnGL] `w"..text)
end

function stopScript(reason)
   running = false
   dc = false
   
   editToggle("ModFly", false)
   
   if not getValue(0, "hsnpt_startBtn") then
      return true
   end
   
   sendDialog({
       title = "Auto Plant Stopped",
       message = reason.."\n\nHaving trouble?\nReport bugs or problem at my Discord Server.\n\nDiscord : @hsndika\n[https://discord.gg/3xKNPbB5qd]",
       confirm = "OK"
   })
   editValue("hsnpt_startBtn", false)
end
   
function rd(base)
  local offset = math.floor(base * 0.1)

  return math.random(base - offset, base + offset)
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

function Plant(x, y, id)
   spr(3, id, x, y)
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
        parts[i] = '"'.. string.upper(v).. '"'
    end
    return "[".. table.concat(parts, ",").. "]"
end

function loadWorlds()
   targetWorlds = {}

   local c = getVar()

   for world in w(c.targetWorlds):gmatch("[^,%s]+") do
      table.insert(targetWorlds, w(world):upper())
   end

   if twIndex > #targetWorlds then
      twIndex = 1
   end
   
   local format = toJsonArray(targetWorlds)
   
   editValue("hsnpt_displayList", format)
end

function warp(world)
   local caps = w(world):upper()
   local filter = w(caps):match("^[^|]+")
   local timeout = 0
   
   if GetWorldName() == filter then
      return true
   end
   
   ost("Warp to "..filter)
   growtopia.warpTo(world)
   
   repeat
      Sleep(3000)
      timeout = timeout + 1
      ost("Waiting to arrive at "..filter)
   until GetWorldName() == filter or timeout >= 20 or not running
   if timeout >= 20 then return false end
   return GetWorldName() == filter
end

function fp(x, y)
   if growtopia.isOnPos(x, y) then 
      return true 
   end
   FindPath(x, y)
   Sleep(rd(100))
   return growtopia.isOnPos(x, y)
end

function cek(id)
   return growtopia.checkInventoryCount(id)
end

function count()
   local counts = 0
   
   for _, tile in pairs(GetTiles()) do
      if tile and tile.fg == 0 and getTile(tile.x, tile.y + 1).collidable then
         counts = counts + 1
      end
   end
   
   return counts
end   
      
function webhook(method, reason)
    runThread(function()
        if not sendWebhook then return false end
        ost("Sending Webhook, please wait...")
        
        local targetName = "None"
        local targetCount = "0"
        
        if id and id > 0 then
            local prov = (id % 2 == 0)
            local icon = prov and "<:blocks:1548562944848039936> " or "<:trees:1548563045826039908> "
            local ok, itemInfo = pcall(getItemInfoByID, id)
            if ok and itemInfo and itemInfo.name then
                targetName = icon .. itemInfo.name
            end
            targetCount = tostring(count())
        end
        
        local progress = twIndex .. "/" .. #worlds
        if method == 3 then
            progress = (twIndex - 1) .. "/" .. #worlds
        end
        
        local finalUrl = VERCEL_API_URL
            .. "?method=" .. tostring(method)
            .. "&userid=" .. urlEncode(tostring(userID))
            .. "&premium=" .. tostring(premium == true)
            .. "&target="  .. urlEncode(targetName)
            .. "&count="   .. urlEncode(targetCount)
            .. "&progress=".. urlEncode(progress)
            .. "&reason="  .. urlEncode(tostring(reason or ""))
            
        pcall(function() 
            fetch(finalUrl) 
        end)
    end)
end

function reconnect()
   local timeout = 0
   local c = getVar()
   
   if getLocal() then return true end
   
   ost("Disconnected")
   
   repeat
      Sleep(5000)
      ost("Reconnecting...")
      timeout = timeout + 1
   until dc or GetLocal() or timeout >= 120 or not running
  
   if timeout >= 120 then return false end
  
   if not running then return false end 
   
   local world = targetWorlds[twIndex]
   
   if isCollecting then
      world = c.takeWorlds
   end
      
   if not warp(world) then return false end
 
   timeout = 0
   repeat   
      Sleep(5000)
      timeout = timeout + 1
   until GetLocal() or timeout >= 120 or not running
  
   if timeout >= 120 then return false end 
  
   if not running then return false end 
   
   return true
end

function collectSeed()
   if not reconnect() then
      stopScript("Failed to reconnect.")
      return false
   end
      
   local c = getVar()
   local world = GetWorldName()
   local startSeed = cek(c.seed)
   local startX, startY = getPos()
   local found = false
   
   if not c.takeCurrentWorld then world = c.takeWorlds end
   
   if cek(c.seed) >= 10 then return true end
   
   isCollecting = true
   
   if not warp(world) then 
      stopScript("Failed to warp to take world.")
      return false
   end
   
   if not reconnect() then
      stopScript("Failed to reconnect.")
      return false
   end
   
   for _, obj in pairs(GetObjectList()) do
      if obj.itemid == c.seed then
         local before = cek(c.seed)
         if before >= 200 then break end
         if not reconnect() then
            stopScript("Failed to reconnect.")
         end
         if not running then return false end
         
         local obx, oby = obj.posX//32, obj.posY//32
         
         if not fp(obx, oby) then goto continue end
         local px, py = getPos()
         found = true
         
         if math.abs(obx - px) <= 6 and math.abs(oby -py) <= 6 then
            spr(11, obj.id, obj.posX, obj.posY)
            ost("Collecting seed...")
            
            local timeout = 0
            repeat
               Sleep(100)
               timeout = timeout + 1
               if timeout % 10 == 0 then ost("Collecting seed...") end
            until cek(c.seed) > before or timeout >= 30 or not running or not getLocal()
            if not running then return false end
            if not reconnect() then stopScript("Failed to reconnect.") return false end
            if timeout >= 30 then goto continue end
         end
      end  
      ::continue::
   end
   if not warp(targetWorlds[twIndex]) then
      stopScript("Failed to warp to "..targetWorlds[twIndex])
      return false
   end
   if not reconnect() then
      stopScript("Failed to reconnect.")
   end
   if not running then return false end
   if not fp(startX, startY) then
      stopScript("Failed to back to position.")
      return false
   end
   istCollecting = false
   
   if not found then
      stopScript("No more <".. getItemInfoByID(c.seed).name.."> to plant")
      return false
   end
      
   return cek(c.seed) > startSeed
end
    
function mainLoop()
   local maxY = 60
   y = 0
   targetWorlds = {}
   twIndex = 1
   
   loadWorlds()
   editToggle("ModFly", true)
   
   while y < maxY do
      local again = true
      local retry = 0
      local c = getVar()
      
      if not warp(targetWorlds[twIndex]) then
         stopScript("Failed to warp "..targetWorlds[twIndex])
         return false
      end
      
      while again and running do
         local found = false
         again = false
         retry = retry + 1
         
         if retry >= 6 then
            break
         end
         
         local playerX, _ = getPos()
         local startX, endX, step
         
         if not playerX then
            return false
         end
         
         if c.sweepLeft then
            startX = 0
            endX = 99
            step = 1   
         elseif playerX > 50 then
            startX = 99
            endX = 0
            step = -1
         elseif playerX < 50 then
            startX = 0
            endX = 99
            step = 1
         end
      
         local x = startX
         
         local matchTile = {}
         
         ost("Scanning Row ["..y.."/60]...")
         for xs = 0, 99 do
            local tile = getTile(xs, y)
            local plat = getTile(xs, y + 1)
            if tile and tile.fg == 0 and plat.collidable then
               matchTile[xs..":"..y] = true
               found = true
            end
         end   
         
         if not found then
            break
         end   

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
               
               local tileKey = x1..":"..y1

               if matchTile[tileKey] then
                  valid1 = true
               end
            end
            
            if x2 >= 0 and x2 <= 99 then
               if not reconnect() then
                  stopScript("Failed to reconnect.")
                  return false
               end   
               
               local tileKey = x2..":"..y2

               if matchTile[tileKey] then
                  valid2 = true
               end
            end

            if x3 >= 0 and x3 <= 99 then
               if not reconnect() then
                  stopScript("Failed to reconnect.")
                  return false
               end   
               
               local tileKey = x3..":"..y3

               if matchTile[tileKey] then
                  valid3 = true
               end
            end

            local fpX, fpY
            local acted = false
                
            if valid1 then
               fpX, fpY = x1, y1
            elseif valid2 then
               fpX, fpY = x2, y2
            elseif valid3 then
               fpX, fpY = x3, y3
            end

            if fpX then
               if fp(fpX, fpY) then
                  if valid1 then
                     
                     if not reconnect() then
                        stopScript("Failed to reconnect.")
                        return false
                     end   
                     
                     if not collectSeed() then
                        return false
                     end isCollecting = false
                     
                     Plant(x1, y1, c.seed)
                     
                     if c.antiMiss then
                        local timeout = 0
                        repeat
                           Sleep(10)
                           timeout = timeout + 10
                        until getTile(x1, y1).fg == c.seed or not running or not getLocal()
                        
                        if not running then return false end
                        if not reconnect() then 
                           stopScript("Failed to reconnect")
                        end
                        if timeout < c.delay then Sleep(rd(c.delay - timeout)) end
                     else   
                        Sleep(rd(c.delay))
                     end
                     acted = true
                  end

                  if valid2 then
                     if not reconnect() then
                        stopScript("Failed to reconnect.")
                        return false
                     end   
                     
                     if not collectSeed() then
                        return false
                     end isCollecting = false
                     
                     Plant(x2, y2, c.seed)
                     
                     if c.antiMiss then
                        local timeout = 0
                        repeat
                           Sleep(10)
                           timeout = timeout + 10
                        until getTile(x2, y2).fg == c.seed or not running or not getLocal()
                        
                        if not running then return false end
                        if not reconnect() then 
                           stopScript("Failed to reconnect")
                        end
                        if timeout < c.delay then Sleep(rd(c.delay - timeout)) end
                     else   
                        Sleep(rd(c.delay))
                     end
                     acted = true
                  end

                  if valid3 then
                     if not reconnect() then
                        stopScript("Failed to reconnect.")
                        return false
                     end   
                     
                     if not collectSeed() then
                        return false
                     end isCollecting = false
                     
                     Plant(x3, y3, c.seed)
                     
                     if c.antiMiss then
                        local timeout = 0
                        repeat
                           Sleep(10)
                           timeout = timeout + 10
                        until getTile(x3, y3).fg == c.seed or not running or not getLocal()
                        
                        if not running then return false end
                        if not reconnect() then 
                           stopScript("Failed to reconnect")
                        end
                        if timeout < c.delay then Sleep(rd(c.delay - timeout)) end
                     else   
                        Sleep(rd(c.delay))
                     end
                     acted = true
                  end
                  
                  again = true
               end
            end

            x = x + step * 3
            
            if not acted then
               Sleep(10)
            end
         end
      end

      y = y + 1
      
      if y >= maxY then
         twIndex = twIndex + 1
         
         if twIndex > #targetWorlds then
            ost("Finished! No more <"..getItemInfoByID(id).name.."> to harvest.")
            stopScript("Finished! No more <"..getItemInfoByID(id).name.."> to harvest.")
            return
         end
         
         Sleep(rd(3000))
         ost("Warp to next world...")
         
         if not warp(targetWorlds[twIndex]) then stopScript("Failed to warp "..targetWorlds[twIndex]) end
         y = 0
      end   
   end
end            
   
addHook(function(var)
   if var.v1 == "OnRequestWorldSelectMenu" and running then
      dc = true
   end
end, "OnVariant")

addHook(function(pkt)
   if pkt.type == 4 and dc then
      ost("Reconnected")
      dc = false
   end   
end, "OnGamePacket")

addHook(function(type, name, value)
   if name == "hsnpt_startBtn" then
      if value then
         running = true
         
         wn(db):set("targetWorld", getValue(2, "hsnpt_worldList"))
         wn(db):set("takeWorld", getValue(2, "hsnpt_takeWorld"))
         wn(db):save()
         
         runThread(function()
            local ok, err = pcall(mainLoop)

            if not ok then
               stopScript(err)
               log(err)
            end
         end)
      else
         running = value
         ost("STOPPED")
         stopScript()
      end 
   elseif name == "hsnpt_getWorld" then
      editValue("hsnpt_worldList", GetWorldName())
   elseif name == "hsnpt_getTakeWorld" then
      editValue("hsnpt_takeWorld", GetWorldName())   
   elseif name == "hsnpt_refresh" then
      loadWorlds()
   elseif name == "hsnpt_takeCurrentWorld" and value == true then
      ost("Take world : Current World")
      editToggle("hsnpt_takeOtherWorld", false) 
   elseif name == "hsnpt_takeOtherWorld" and value == true then
      local config = getVar()
      ost("Take world : "..config.takeWorlds)
      editToggle("hsnpt_takeCurrentWorld", false)    
   end  
end, "OnValue")
