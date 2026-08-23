load(fetch("https://raw.githubusercontent.com/Hsndka/Growlauncher-Script/main/GeneralModule.lua"))()

addCategory("HsnGL", "FileOpen")

local Hsngaut = [[
{
  "sub_name": "Auto Retrieve Gaut",
  "description": "Auto Retrieve Gaut by HsnGL.",
  "icon": "Outbox",
  "menu": [
      {
          "type": "tooltip",
          "text": "How to use?",
          "support_text": "1. Input Key Password correctly\n2. Click START/STOP\n3. Wrench GAUT to start Auto Retrieve.",
          "background": false,
          "icon": "TipsAndUpdates"
      },
      {
          "type": "input_string",
          "icon": "VpnKey",
          "text": "Key Password",
          "label": "Input Key Password correctly!",
          "placeholder": "",
          "default": "",
          "alias": "hsngaut_key"
      },
      {
          "type": "divider"
      },
      {
          "type": "toggle_button",
          "text": "START/STOP",
          "default": false,
          "alias": "hsngaut_startBtn"
      },
      {
          "type": "divider"
      },
      {
          "type": "label",
          "text": ""
      },
      {
          "type": "label",
          "text": ""
      },
      {
          "type": "label",
          "text": ""
      },
      {
          "type": "label",
          "text": ""
      },
      {
          "type": "label",
          "text": ""
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
          "alias": "hsngeneral_link"
      },
      {
          "type": "divider"
      }
]    
}
]]

addIntoModule(Hsngaut, "HsnGL")    

local running = true
local hooks = false
local popup, popup2, empty = false, false, false
local isBlocked, isFull, isDrop = false, false, false
local globalX, globalY = 0, 0
local item = 0
local amount = 0
local sucker = 0
local key = "DearGAUT"
local keyInput = ""

local RAW_URL = "https://raw.githubusercontent.com/Hsndka/Growlauncher-Script/main/Link.lua"

function wn(text)
   return text or ""  
end

local pref = require("preferences")
local db = wn(pref):new("AutoRetrieveGAUT.hsngl")
wn(db):save()
keyInput = wn(db):get("Key", 0) or ""
editValue("hsngaut_key", keyInput)
   
function w(t)
   if type(t) == "string" then
      return t
   end 
   return "" 
end

function dialogBuilder(t, m, c)
    sendDialog({
        title = t,
        confirm = c,
        message = m
    })
end

dialogBuilder("Auto Retrieve Gaut\nby HsnGL", "How to use:\n   - Input key password\n   - Click [START/STOP]\n   - Wrench GAUT\n\nJoin my Discord Server for more FREE and PREMIUM script!\n\nDiscord:\nhttps://discord.gg/3xKNPbB5qd", "OK")

function resetValue()
   popup, popup2, empty = false, false, false
   isBlocked, isFull, isDrop = false, false, false
   globalX, globalY = 0, 0
   item, amount, sucker = 0, 0, 0
end

function ost(text)
   growtopia.notify("`c[HsnGL] "..text)
end
   
function cek(id)
   return growtopia.checkInventoryCount(id) or 0
end

function rnDelay(base)
    local offset = math.floor(base * 0.1)
    return math.random(base - offset, base + offset)
end

   
function spr(t, v, x, y)
    SendPacketRaw(false, {
        type = t, value = v, px = x, py = y,
        x = GetLocal().posX, y = GetLocal().posY
    })
end

function fp(x, y)
   local timeout = 0
   
   findPath(x, y)
   
   repeat
      Sleep(100)
      timeout = timeout + 1
   until growtopia.isOnPos(x, y) or timeout >= 10
   
   return growtopia.isOnPos(x, y)
end

function errorDialog(id, reason)
   growtopia.sendDialog(table.concat({
       "set_default_color|`w",
       "set_border_color|112,86,191,255",
       "set_bg_color|43,34,74,200",
       "add_custom_button|NIXEL|state:disabled;icon:6948;|",
       "add_textbox|Auto Retrieve GAUT|",
       "add_smalltext|Script By HsnGL|\nadd_custom_break|",
       "reset_placement_x|",
       "add_spacer|small|",
       "add_spacer|small|",
       "add_label_with_icon|small|"..reason.."|left|"..id.."|",
       "add_spacer|small|",
       "add_quick_exit|",
       "add_smalltext|`4NOTE:`o don't sell this script|",
       "end_dialog|hsn_retrieveGaut|||"
   }, "\n"))
   
   log("`c[HsnGL] "..reason)
end

function retrieve(item, sucker, x, y, count)
   if cek(item) >= 1 then
      return true
   end
      
   sendPacket(2, table.concat({
       "action|dialog_return",
       "dialog_name|"..sucker,
       "tilex|"..x.."|",
       "tiley|"..y.."|",
       "buttonClicked|retrieveitem\n",
       "chk_enablesucking|1",
   }, "\n"))
   repeat
      if not running then
         return false
      end   
      Sleep(100)
   until popup2 or not GetLocal()
   
   popup2 = false
   
   if not GetLocal() then
      errorDialog(item, "Disconnected")
      return false
   end
   
   if cek(item) >= 1 then
      return true
   end
   
   sendPacket(2, table.concat({
       "action|dialog_return",
       "dialog_name|itemremovedfromsucker",
       "tilex|"..x.."|",
       "tiley|"..y.."|",
       "itemtoremove|"..count
   }, "\n"))
   
   repeat
      Sleep(180)
      if not running then
         return false
      end   
   until cek(item) >= 1 or not GetLocal()
   
   return cek(item) >= 1
end 

function drop(id)
   if cek(id) <= 0 then
      return true
   end
   
   growtopia.dropItem(id)
   
   repeat
      Sleep(100)
      if not running then
         return false
      end   
   until isFull or isBlocked or isDrop or not GetLocal()  
   
   if isBlocked then 
      isBlocked = false
      errorDialog(item, "Blocked: Failed to drop item.")
      return false 
   end
   
   if isFull then
      isFull = false
      local p = GetLocal()
      local x, y = p.posX//32, p.posY//32
      local left = p.isLeft
      
      if left then
         if not fp(x + 1, y) then errorDialog(item, "Blocked: Failed to drop") return false end
      else
         if not fp(x - 1, y) then errorDialog(item, "Blocked: Failed to drop") return false end
      end   
      
      return true
   end
   
   if not GetLocal() then
      errorDialog(item, "Disconnected")
      return false
   end
   
   if isDrop then
      isDrop = false
      growtopia.confirmDropItem(id, cek(id))
      
      repeat
         Sleep(100)
         if not running then
            return false
         end   
      until cek(id) <= 0 or not GetLocal() or isFull
      
      if not GetLocal() then
         errorDialog(item, "Disconnected")
         return false
      end
         
      if isFull then
         return true
      end
      
      return cek(id) <= 0
   end  
end       


function mainLoop()
   while running do
      if popup and not empty then
         local count = 0
         
         if amount >= 200 then
            count = 200
         else
            count = amount
         end
               
         popup = false
         hooks = true
         
         growtopia.notify("`c[HsnGL] Retrieving "..getItemInfoByID(item).name.."\nCurrent: "..amount.." left.")
         
         if not retrieve(item, sucker, globalX, globalY, count) then
            errorDialog(item, "Failed to retrieve")
            return false 
         end
         
         Sleep(rnDelay(100))
         
         if not drop(item) then return false end
         
         Sleep(rnDelay(100))
         
         spr(3, 32, globalX, globalY)
         repeat
            Sleep(180)
            if not running then
               return false
            end   
         until popup or empty or not GetLocal()
         
         if empty then
            amount = 0
         end
         
         if not GetLocal() then
            errorDialog(item, "Disconnected")
            return false
         end
            
         Sleep(rnDelay(100))
      else
         hooks = false
         Sleep(100)
      end  
   end      
end         

addHook(function(var)
   if var.v1 == "OnDialogRequest" and (w(var.v2):find("add_button|retrieveitem|Retrieve Items") or w(var.v2):find("add_textbox|`6You are already carrying")) then
      local x, y = w(var.v2):match("embed_data|tilex|(%d+)\nembed_data|tiley|(%d+)")
      local items = w(var.v2):match("add_label_with_icon|small|`2(.-)``")
      local suckers = w(var.v2):match("end_dialog|(.-)|Close")
      local amounts = w(var.v2):match("add_textbox|The machine contains (%d+)")
      
      if x and y then
         globalX, globalY = tonumber(x), tonumber(y)
         item = FindItemID(items)
         amount = tonumber(amounts)
         sucker = suckers
         popup = true
         empty = false
      end
      
      if not running then
         local d = var.v2
         local block, id = w(d):match("add_label_with_icon|big|`w(.-)``|left|(%d+)|")
         local modif = w(d):gsub("add_label_with_icon|big|`w"..block.."``|left|"..id.."|", "\nset_default_color|`w\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200\nadd_custom_button|NIXEL|state:disabled;icon:"..id..";|\nadd_textbox|Auto Retrieve GAUT|\nadd_smalltext|Script By HsnGL|\nadd_custom_break|\nreset_placement_x|")
         
         local newVar = {}
         newVar.v1 = "OnDialogRequest"
         newVar.v2 = modif
      
         sendVariant(newVar)
      end
         
      return true
   elseif var.v1 == "OnDialogRequest" and w(var.v2):find("add_textbox|`6The machine is currently empty") then
      local d = var.v2
      local block, id = w(d):match("add_label_with_icon|big|`w(.-)``|left|(%d+)|")
      local modif = w(d):gsub("add_label_with_icon|big|`w"..block.."``|left|"..id.."|", "\nset_default_color|`w\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200\nadd_custom_button|NIXEL|state:disabled;icon:"..id..";|\nadd_textbox|Auto Retrieve GAUT|\nadd_smalltext|Script By HsnGL|\nadd_custom_break|\nreset_placement_x|")
         
      local newVar = {}
      newVar.v1 = "OnDialogRequest"
      newVar.v2 = modif
      
      sendVariant(newVar)
      
      empty = true
      popup = false
      return true
   elseif var.v1 == "OnDialogRequest" and w(var.v2):find("add_item_picker|selectitem|`wChoose Item") then
      local d = var.v2
      local block, id = w(d):match("add_label_with_icon|big|`w(.-)``|left|(%d+)|")
      local modif = w(d):gsub("add_label_with_icon|big|`w"..block.."``|left|"..id.."|", "\nset_default_color|`w\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200\nadd_custom_button|NIXEL|state:disabled;icon:"..id..";|\nadd_textbox|Auto Retrieve GAUT|\nadd_smalltext|Script By HsnGL|\nadd_custom_break|\nreset_placement_x|")
         
      local newVar = {}
      newVar.v1 = "OnDialogRequest"
      newVar.v2 = modif
      
      sendVariant(newVar)
      
      return true
   elseif var.v1 == "OnDialogRequest" and w(var.v2):find("end_dialog|itemaddedtosucker|Close|Add|") then
      local d = var.v2
      local x, y = w(d):match("embed_data|tilex|(%d+)\nembed_data|tiley|(%d+)")
      local id = GetTile(x, y).fg
      local modif = w(d):gsub("add_spacer|small|", "\nset_default_color|`w\nset_border_color|112,86,191,255\nset_bg_color|43,34,74,200\nadd_custom_button|NIXEL|state:disabled;icon:"..id..";|\nadd_textbox|Auto Retrieve GAUT|\nadd_smalltext|Script By HsnGL|\nadd_custom_break|\nreset_placement_x|\nadd_spacer|small|", 1)
         
      local newVar = {}
      newVar.v1 = "OnDialogRequest"
      newVar.v2 = modif
      
      sendVariant(newVar)
      
      return true
   elseif var.v1 == "OnDialogRequest" and w(var.v2):find("end_dialog|itemremovedfromsucker|Close") and hooks then
      popup2 = true
      return true
   elseif var.v1 == "OnDialogRequest" and w(var.v2):find("add_textbox|How many to drop") and hooks then
      isDrop = true
      return true
   elseif var.v1 == "OnTextOverlay" and w(var.v2):find("face somewhere with open space") and hooks then
      isBlocked = true
   elseif var.v1 == "OnTextOverlay" and w(var.v2):find("find an emptier spot") and hooks then
      isFull = true
      ost("full")
   end  
end, "OnVariant")

addHook(function(type, name, value)
   if name == "hsngaut_startBtn" then
      if value == true and key == getValue(2, "hsngaut_key") then
         running = true
         resetValue()
         wn(db):set("Key", getValue(2, "hsngaut_key"))
         wn(db):save()
         growtopia.notify("`c[HsnGL] Auto retrieve enabled.")
         
         runThread(function()
            local a, b = pcall(mainLoop)
   
            if not a then
               log(b)
            end  
         end)
         
      elseif value == true and key ~= getValue(2, "hsngaut_key") then
         running = false
         editToggle("hsngaut_startBtn", false)
         dialogBuilder("ERROR", "Invalid Key!\n\nHow to get Key? (FREE!)\nJoin my Discord Server!\n\nLINK :\nhttps://discord.gg/3xKNPbB5qd", "OK")
      elseif value == false then
         running = false
         ost("Auto retrieve disabled")  
      end   
   elseif name == "hsngeneral_link" and value == true then
      load(fetch(RAW_URL))()
      editToggle("hsngeneral_link", false)
   end   
end, "OnValue")
