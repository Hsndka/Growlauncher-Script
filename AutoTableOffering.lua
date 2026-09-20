sendNotification("Auto Table Offering by HsnGL Added!")
local check = 0
local key = "FullMoon7"
local keyBoolean = false
local keyMsg = "Key Password not entered"
local keyMsg2 = "`wType `9/key CONTOHKEY`` to enter Key! "
local keyIcon = 6124
local keyIcon2 = 6292

local var2
local data = {}
local savedData = {}

local running, running2 = false, false
local select, select2 = false, false
local isTable, reward, claim = false, false, false
local checked, full = false, false

function wn(text)
   return text or ""  
end

local pref = require("preferences")
local db = wn(pref):new("readme.txt")
wn(db):save()

function stopScript(icon, reason)
   data = {}
   savedData = {}
   
   running, full = false, false
   select, select2 = false, false
   isTable, reward, claim = false, false, false
   
   growtopia.sendDialog(table.concat({
       "set_default_color|`w",
       "set_border_color|112,86,191,255",
       "set_bg_color|43,34,74,200",
       "add_label_with_icon|big|`4Error!``|left|"..icon.."|",
       "add_spacer|small|",
       "add_textbox|"..reason.."|",
       "add_spacer|small|",
       "add_quick_exit|",
       "end_dialog|offer_escape|||"
   }, "\n"))
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

function cek(id)
   return growtopia.checkInventoryCount(id)
end

function fp(x, y)
   local range = 6
   
   local px, py = getLocal().posX//32, getLocal().posY//32
   
   if not px or not py then
      return false
   end   
      
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
   
      if not getTile(px, py).collidable then
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
      
      if not getTile(px, py).collidable then
         FindPath(px, py)
         Sleep(rd(200))
      end
   end
  
   FindPath(x, y)
   Sleep(rd(100))
   return growtopia.isOnPos(x, y)
end

function collect(id)
   local radius = 6
   local before = cek(id)
   
   for _, obj in pairs(GetObjectList()) do
      local ox, oy = obj.posX//32, obj.posY//32
      
      if obj.itemid == id then
         if not ox or not oy then
            return false
         end
         
         if getTile(ox, oy).collidable then
            goto continue
         end
         
         if not fp(ox, oy) then
            goto continue
         end   
         
         local px, py = getLocal().posX//32, getLocal().posY//32
         
         if math.abs(ox - px) <= 5 and math.abs(oy - py) <= 2 then
            if cek(id) >= 200 then
               break
            end
            
            spr(11, obj.id, obj.posX, obj.posY)
            
            while before >= cek(id) do
               Sleep(100)
            end   
         end
      end    
      
      ::continue::
   end
   
   return before < cek(id)
end

function fill(slot, id, count)
   local px, py = getLocal().posX//32, getLocal().posY//32
   
   if cek(id) < count then
      if not collect(id) then
         log("Not enought Mooncakes")
         running = false
         stopScript(10228, "Not enough Mooncakes")
         return false
      end
      
      if not fp(px, py) then
         stopScript(1684, "Failed to back to positon")
         return false
      end   
   end
   
   growtopia.notify("`c[HsnGL] Putting Mooncake into Offering Table ["..slot.."/"..#savedData.."]\nType: /stop to STOP")
   
   isTable = false
   
   local tx, ty = 0, 0
   
   for _, tile in pairs(getTiles()) do
      if tile and tile.fg == 12598 then
         tx, ty = tile.x, tile.y
         break
      end 
   end
   
   if tx == 0 and ty == 0 then
      stopScript(12598, "No Offering Table found!?")
      return false
   end
   
   if math.abs(tx - px) >= 3 and math.abs(ty - py) >= 3 then
      stopScript(12598, "Too far from Offering Table!")
      return false
   end
   
   if id == 982 then
      stopScript(4378, "Make sure to fill all slot before save!")
      return false
   end
   
   local d = data[slot]
   
   if d and d.id == id then
      isTable = false
      
      if d.count == count then
         
         if slot >= #savedData then
            running = false
            spr(3, 32, tx, ty)
         end   
         
         Sleep(rd(100))
         return true
      elseif d.count ~ count then
         slots = slot - 1
         
         sendPacket(2, table.concat({
             "action|dialog_return",
             "dialog_name|mooncake_altar_dialog",
             "buttonClicked|slot_btn_"..slots
         }, "\n"))
   
         repeat
            Sleep(100)
         until select or not running
   
         if not running then
            stopScript(5478, "STOPPED")
            return false
         end   
   
         select = false
   
         Sleep(rd(100))
         
         sendPacket(2, table.concat({
             "action|dialog_return",
             "dialog_name|mooncake_choose_dialog",
             "slot|"..slots.."|",
             "buttonClicked|clear_slot"
         }, "\n"))   
      
         repeat
            Sleep(10)
         until isTable or full or not running
   
         if not running or full then
            stopScript(5478, "STOPPED")
            return false
         end   
   
         Sleep(rd(10))
      end
   end
         
   slot = slot - 1
   
   isTable = false
       
   sendPacket(2, table.concat({
       "action|dialog_return",
       "dialog_name|mooncake_altar_dialog",
       "buttonClicked|slot_btn_"..slot
   }, "\n"))
   
   repeat
      Sleep(10)
   until select or not running
   
   if not running then
      stopScript(5478, "STOPPED")
      return false
   end   
   
   Sleep(rd(100))
   
   sendPacket(2, table.concat({
       "action|dialog_return",
       "dialog_name|mooncake_choose_dialog",
       "slot|"..slot.."|",
       "buttonClicked|item_btn_"..id
   }, "\n"))
   
   select = false
   
   repeat
      Sleep(10)
   until select2 or not running
   
   if not running then
      stopScript(5478, "STOPPED")
      return false
   end   
   
   Sleep(rd(100))
   
   sendPacket(2, table.concat({
       "action|dialog_return",
       "dialog_name|mooncake_count_dialog",
       "itemID|"..id.."|",
       "slot|"..slot.."|",
       "buttonClicked|ok",
       "count|"..count
   }, "\n"))
   
   select2 = false
   
   if slot + 1 == #savedData then
      running = false
      
      return true
   end
      
   repeat
      Sleep(10)
   until isTable or not running
   
   if not running then
      stopScript(5478, "STOPPED")
      return false
   end   
   
   Sleep(rd(100))
   
   return true
end 
      
function mainLoop()
   local tx, ty = 0, 0
   local px, py = getLocal().posX//32, getLocal().posY//32
   
   for _, tile in pairs(getTiles()) do
      if tile and tile.fg == 12598 then
         tx, ty = tile.x, tile.y
         break
      end 
   end
   
   if tx == 0 and ty == 0 then
      stopScript(12598, "No Offering Table found!?")
      return false
   end
   
   if math.abs(tx - px) >= 3 and math.abs(ty - py) >= 3 then
      stopScript(12598, "Too far from Offering Table!")
      return false
   end
      
   spr(3, 32, tx, ty)
      
   repeat
      Sleep(100)
   until isTable or not running
   
   if not running then
      stopScript(5478, "STOPPED")
      return false
   end   
   
   isTable = false
   
   sendPacket(2, table.concat({
       "action|dialog_return",
       "dialog_name|mooncake_altar_dialog",
       "buttonClicked|offer_btn"
   }, "\n"))
   
   repeat
      Sleep(10)
   until reward or not running
   
   if not running then
      stopScript(5478, "STOPPED")
      return false
   end   
      
   reward = false
      
   Sleep(rd(100))
      
   if check == 1 then
      sendPacket(2, table.concat({
          "action|dialog_return",
          "dialog_name|mooncake_reward_dialog",
          "buttonClicked|take_reward"
      }, "\n"))
   end 
     
   while running do
      repeat
         Sleep(10)
      until claim or not running
   
      if not running then
         stopScript(5478, "STOPPED")
         return false
      end   
      
      claim = false
      
      growtopia.notify("`c[HsnGL] ``"..var2)
      
      Sleep(rd(1000))
   
      px, py = getLocal().posX//32, getLocal().posY//32
      
      if getTile(tx, ty).fg ~= 12598 then
         stopScript(12598, "No Offering Table found!?")
         return false
      end
      
      if math.abs(tx - px) >= 3 and math.abs(ty - py) >= 3 then
         stopScript(12598, "Too far from Offering Table!")
         return false
      end
    
      spr(3, 32, tx, ty)
      
      repeat
         Sleep(10)
      until isTable or not running
   
      if not running then
         stopScript(5478, "STOPPED")
         return false
      end   
      
      isTable = false
      
      Sleep(rd(100))
   
      for i = 1, 10 do
         if not fill(i, savedData[i].id, savedData[i].count) then
            return false
         end
      end
      
      running = true
      
      sendPacket(2, table.concat({
          "action|dialog_return",
          "dialog_name|mooncake_altar_dialog",
          "buttonClicked|offer_btn"
      }, "\n"))
           
      repeat
         Sleep(10)
      until reward or not running
   
      if not running then
         stopScript(5478, "STOPPED")
         return false
      end   
      
      reward = false
      
      Sleep(rd(100))
      
      if check == 1 then
         sendPacket(2, table.concat({
             "action|dialog_return",
             "dialog_name|mooncake_reward_dialog",
             "buttonClicked|take_reward"
         }, "\n"))
      end   
   end
end

function loadLoop()
   local tx, ty = 0, 0
   local px, py = getLocal().posX//32, getLocal().posY//32
   
   for _, tile in pairs(getTiles()) do
      if tile and tile.fg == 12598 then
         tx, ty = tile.x, tile.y
         break
      end 
   end
   
   if tx == 0 and ty == 0 then
      stopScript(12598, "No Offering Table found!?")
      return false
   end
   
   if math.abs(tx - px) >= 3 and math.abs(ty - py) >= 3 then
      stopScript(12598, "Too far from Offering Table!")
      return false
   end
      
   if getTile(tx, ty).fg ~= 12598 then
      stopScript(12598, "No Offering Table found!?")
      return false
   end
      
   if math.abs(tx - px) >= 3 and math.abs(ty - py) >= 3 then
      stopScript(12598, "Too far from Offering Table!")
      return false
   end
      
   spr(3, 32, tx, ty)
      
   repeat
      Sleep(10)
   until isTable or not running
   
   if not running then
      stopScript(5478, "STOPPED")
      return false
   end   
      
   isTable = false
      
   Sleep(rd(100))
   
   for i = 1, 10 do
      if not fill(i, savedData[i].id, savedData[i].count) then
         return false
      end
   end
      
   repeat
      Sleep(10)
   until isTable
      
   isTable = false
      
   Sleep(rd(100))
   growtopia.notify("`c[HsnGL] Configuration Loaded!")
      
   return true
end

addHook(function(var)
   if var.v1 == "OnDialogRequest" and var.v2:find("add_label_with_icon|big|`wOffer Mooncakes to the Moon``|left|12598|") then
      data = {}
      isTable = true
      
      for slot, id, count in var.v2:gmatch("slot_btn_(%d+)||frame|(%d+)|(%d*)|") do
         data[#data + 1] = {
            slot = tonumber(slot),
            id = tonumber(id),
            count = tonumber(count) or 0
         }
      end
      
      local checks = check
      
      local modif = var.v2:gsub("add_spacer|small|\nadd_button|offer_btn|Offer Mooncakes|noflags|0|0|", 
         "add_spacer|small|\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200\n"..
         "add_label_with_icon|small|`o"..keyMsg.."``|left|"..keyIcon.."|\n"..
         "add_smalltext|"..keyMsg2.."|\nadd_spacer|small|\n"..
         "add_button|load_offer_btn|`9Load Configuration``|noflags|0|0|\n"..
         "add_button|save_offer_btn|`2Save Configuration``|noflags|0|0|\n"..
         "add_spacer|small|\nadd_button|start_offer_btn|Start Offer Mooncakes|noflags|0|0|\n"..
         "add_checkbox|checkbox_claim|Auto Claim Reward|"..checks.."\n"..
         "add_smalltext|`4*Note: Hanya efisien untuk gacha 1x1|")
      
      local newVar = {}
               
      newVar.v1 = "OnDialogRequest" 
      newVar.v2 = modif
      
      if not running then
         SendVariant(newVar)
      end
         
      return true
   elseif var.v1 == "OnDialogRequest" and var.v2:find("add_label_with_icon|big|`wSelect a Mooncake``|left|12598|") then
      local modif = var.v2:gsub("add_spacer|small|", "add_spacer|small|\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200")
      
      local newVar = {}
               
      newVar.v1 = "OnDialogRequest" 
      newVar.v2 = modif
      
      if not running then
         SendVariant(newVar)
      else
         select = true
         return true
      end
      
      return true
   elseif var.v1 == "OnDialogRequest" and var.v2:find("end_dialog|mooncake_count_dialog") then
      local modif = var.v2:gsub("add_spacer|small|", "add_spacer|small|\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200")
      
      local newVar = {}
               
      newVar.v1 = "OnDialogRequest" 
      newVar.v2 = modif
      
      if not running then
         SendVariant(newVar)
      else
         select2 = true
         return true
      end   
   elseif var.v1 == "OnDialogRequest" and var.v2:find("add_label_with_icon|big|`wReward!``|left|12598|") then
      local modif = var.v2:gsub("add_spacer|small|", "add_spacer|small|\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200")
      
      local newVar = {}
               
      newVar.v1 = "OnDialogRequest" 
      newVar.v2 = modif
      
      reward = true
      
      if check == 0 then
         SendVariant(newVar)
         return true
      end 
      
      return true
   elseif var.v1 == "OnConsoleMessage" and var.v2:find("You received `2(%d+) (.-)`` from the Offering Table.") then
      growtopia.notify("`c[HsnGL] Reward Claimed!")
      var2 = var.v2
      
      if running then
         claim = true
      end  
   elseif var.v1 == "OnDialogRequest" and var.v2:find("add_label_with_icon|big|`wNot Enough Mooncakes``|left|1432|") then
      local modif = var.v2:gsub("add_spacer|small|", "add_spacer|small|\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200")
      
      local newVar = {}
               
      newVar.v1 = "OnDialogRequest" 
      newVar.v2 = modif
      
      running = false
      
      SendVariant(newVar)
      
      return true
   elseif var.v1 == "OnDialogRequest" and var.v2:find("add_label_with_icon|big|`wRewards Table!``|left|12598|") then
      local modif = var.v2:gsub("add_spacer|small|", "add_spacer|small|\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200")
      
      local newVar = {}
               
      newVar.v1 = "OnDialogRequest" 
      newVar.v2 = modif
      
      SendVariant(newVar)
      
      return true
   elseif var.v1 == "OnDialogRequest" and var.v2:find("add_label_with_icon|big|`wFail to sacrifice items``|left|1432|") then
      running = false
      
      local modif = var.v2:gsub("add_spacer|small|", "add_spacer|small|\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200")
      
      local newVar = {}
               
      newVar.v1 = "OnDialogRequest" 
      newVar.v2 = modif
      
      SendVariant(newVar)
      
      return true
   elseif var.v1 == "OnDialogRequest" and var.v2:find("add_label_with_icon|big|`wNot Enough Inventory Space``|left|1432|") then
      full = true
      
      local modif = var.v2:gsub("add_spacer|small|", "add_spacer|small|\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200")
      
      local newVar = {}
               
      newVar.v1 = "OnDialogRequest" 
      newVar.v2 = modif
      
      SendVariant(newVar)
      
      return true
   end  
end, "OnVariant")
   
addHook(function(type, pkt)
   if pkt:match("buttonClicked|save_offer_btn") then
      savedData = data
      check = tonumber(pkt:match("checkbox_claim|(%d+)"))
      
      wn(db):set("version", savedData)
      wn(db):save()
         
      growtopia.notify("`c[HsnGL] Configuration Saved!")
      
      local tx, ty = 0, 0
      
      for _, tile in pairs(getTiles()) do
         if tile and tile.fg == 12598 then
            tx, ty = tile.x, tile.y
            break
         end 
      end
      
      runThread(function()
         Sleep(500)
         spr(3, 32, tx, ty)
      end)   
   elseif pkt:match("buttonClicked|load_offer_btn") then
      savedData = wn(db):get("version", 0)
      check = tonumber(pkt:match("checkbox_claim|(%d+)"))
      running = true
      select, select2 = false, false
      isTable, reward, claim = false, false, false
      
      if savedData == 0 then
         stopScript(32, "No saved configuration found.")
         return false
      end   
      
      runThread(function()
         Sleep(500)
         growtopia.notify("`c[HsnGL] Loading...")
         
         local ok, err = pcall(loadLoop)
         
         if not ok then
            log(err)
         end
      end)
   elseif pkt:match("buttonClicked|start_offer_btn") then
      
      savedData = data
      running = true
      select, select2 = false, false
      isTable, reward, claim = false, false, false
      
      check = tonumber(pkt:match("checkbox_claim|(%d+)"))
   
      runThread(function()
         if keyBoolean then
            Sleep(500)
            growtopia.notify("`c[HsnGL] Auto Started!")
         
            local ok, err = pcall(mainLoop)
         
            if not ok then
               log(err)
            end
         else
            running = false
            
            growtopia.sendDialog(table.concat({
                "set_default_color|`w",
                "set_border_color|112,86,191,255",
                "set_bg_color|43,34,74,200",
                "add_label_with_icon|big|`9Invalid Key!?``|left|8504|\n",
                "add_spacer|small|",
                "add_textbox|Type `9/key CONTOHKEY`w to input key!|",
                "add_spacer|small|",
                "add_textbox|How to get Key? `2(FREE!)``|",
                "add_textbox|Join my Discord Server!|",
                "add_textbox|LINK :\nhttps://discord.gg/3xKNPbB5qd|",
                "end_dialog|invKey|Close|Get Key|"
            }, "\n"))
         end
      end)   
   elseif pkt:match("action|input\n|text|/stop") then
      running = false
      return true
   elseif pkt:match("action|input\n|text|/key (.-)") and not keyBoolean then
      local keys = pkt:match("action|input\n|text|/key (.+)")
      
      if keys == key then
         keyIcon = keyIcon2
         keyMsg = "Valid Key Password"
         keyMsg2 = "Password has been entered"
         keyBoolean = true
         growtopia.notify("`c[HsnGL] Password has been entered")
      else
         growtopia.notify("`c[HsnGL] Key Password is invalid")
      end   
         
      return true
   elseif pkt:match("action|dialog_return\ndialog_name|invKey") then
      local RAW_URL = "https://raw.githubusercontent.com/Hsndka/Growlauncher-Script/main/Link.lua"
      load(fetch(RAW_URL))()
      
      return true
   end   
end, "OnSendPacket")
