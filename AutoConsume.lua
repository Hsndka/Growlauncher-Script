addCategory("HsnGL", "FileOpen")

local Hsnconsume_load = [[
 {
  "sub_name": "Auto Use Consumable",
  "description": "by Hsn",
  "icon": "Dining",
  "menu": [
         
      {
          "type": "input_string",
          "alias": "key_input",
          "default": "",
          "text": "Key password",
          "placeholder": "Input Key password here!",
          "label": "Input correctly",
          "icon": "VpnKey"
      },
      {
          "type": "button",
          "alias": "loadBtn",
          "text": "Load",
          "default": false
      },
      {
          "type": "divider"
      },
      {
          "type": "tooltip",
          "text": "Join my Discord Server!\n(Free Key)\nLINK :\n",
          "support_text": "",
          "background": false,
          "icon": "AddLink"
      },
      {
          "type": "divider"
      },
      {
          "type": "label",
          "text": "https://discord.gg/btYfTfYpp"
      },
      {
          "type": "divider"
      }
]    
}
]]

local Hsnconsume_setting = [[
{
  "sub_name": "Auto Use Consumable",
  "description": "by Hsn",
  "icon": "Dining",
  "menu": [
      
      {
          "alias": "item_pick",
          "default": "Fireworks",
          "text": "Select items to consume",
          "type": "item_picker"
      },
      {
          "type": "label",
          "text": ""
      },
      {
          "type": "tooltip",
          "text": "Warning",
          "support_text": "This script is not 100% safe, use at your own risk!\nDon't use low delay if you lagging.",
          "background": false,
          "icon": "WarningAmber"
      },
      {
          "type": "slider",
          "text": "Delay :",
          "default": 700,
          "max": 3000,
          "min": 200,
          "step": 100,
          "use_dot": true,
          "alias": "delay"
      },
      {
          "type": "toggle_button",
          "alias": "btnStart",
          "text": "Start"
      },
      {
          "type": "divider"
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
          "text": "https://discord.gg/btYfTfYpp"
      },
      {
          "type": "divider"
      }
]    
}
]]

local Hsnconsume = Hsnconsume_load

addIntoModule(Hsnconsume, "HsnGL")

local cache = {}
local cacheTime = 0
local CACHE_MS = 500

function getVar()
  local now = os.clock() * 1000
  
  if now - cacheTime >= CACHE_MS  then
  cache = {
      item = getValue(1, "item_pick"),
      delay = getValue(1, "delay"),
      name = getItemInfoByID(getValue(1, "item_pick")).name
  }
  cacheTime = now
  end
  return cache
end

waitDelay = 10000
running = false
local HKeyx = "MukbangHsn11"
local loaded = false

function cek()
   local val = getVar()
   return growtopia.checkInventoryCount(val.item)
end

function msg(text)
  sendNotification("[HsnGl] "..text)
end

function rnDelay(base)
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

function fp(x, y)
   local val = getVar()
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
   Sleep(rnDelay(val.delay))
   return growtopia.isOnPos(x, y)
end

function pos()
  return math.floor(GetLocal().posX/32), math.floor(GetLocal().posY/32)
end

function collect()
   local val = getVar()
   
   for _, obj in pairs(GetObjectList()) do
      local posiX = math.floor(obj.posX/32)
      local posiY = math.floor(obj.posY/32)
      local curX, curY = pos()
      if obj.itemid == val.item then
         if math.abs(posiX - curX) <= 5 and math.abs(posiY - curY) <= 5 then
            spr(11, obj.id, obj.posX + 6, 0)
         end  
      end
   end
end

function take()
   local val = getVar()
   local timeout = 0
   local found = false
    
   for _, obj in pairs(GetObjectList()) do
      if obj.itemid == val.item then
         found = true
        
         local obX = math.floor(obj.posX/32)
         local obY = math.floor(obj.posY/32)
      
         if not fp(obX, obY) then
            return "blocked"
         end
              
         break
            
      end
   end
   
   if not found then
      return "not found"
   end
   
   Sleep(rnDelay(100))
   collect()
   msg("Waiting for auto collect")
   repeat
      Sleep(rnDelay(1000))
      timeout = timeout + 1
      msg("Waiting for auto collect ("..timeout.."/10)")
   until cek() > 0 or timeout >= 10
   if cek() > 0 then
     return "success"
   end  
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
        "end_dialog|invalidKey|||",
        "add_spacer|small|",
        "add_smalltext|`9[Having trouble?]|",
        "add_url_button|reportLink|`cReport bug here!``|noflags|https://discord.gg/3xKNPbB5qd|Visit the HsnGL's Discord?|0|0|",
        "add_custom_margin|x:300;y:0|\nadd_custom_button|DUMMY_PADDING_X|textLabel:``;state:disabled;middle_colour:0;border_colour:0;|"
    }, "\n"))
end

function stopScript(icon, title, text)
  running = false
  editValue("btnStart", false)
  errorDialog(icon, title, text)
  editToggle("collectfilter_enable", false)
end

function mainLoop()
  local to = 0
  while running do
    local val = getVar()
    editToggle("collectfilter_enable", false)
    
    if val.item == 0 then
      stopScript(1494, "What are you eating?", "Blank is not edible :D")
      return
    end  
    
    if cek() > 0 then
      local before = cek()
      local p = GetLocal()
      sx = math.floor(p.posX/32)
      sy = math.floor(p.posY/32)
           
      spr(3, val.item, sx, sy)
      msg("Consumed "..val.name)
      Sleep(rnDelay(val.delay))
       
      local after = cek()
      
      if after >= before then
        msg("Lag")
        Sleep(rnDelay(1000))
        to = to + 1
      else
        to = 0
      end  
      
      if to > 3 then
        msg("Too much lag!")
        Sleep(rnDelay(waitDelay))
        to = 0
      end
      goto continue
    elseif cek() == 0 then
    
      editToggle("ModFly", true)
      editToggle("collectfilter_enable", true)
      
      local bx, by = pos()
      local result = take()
      
      if result == "not found" then
        editToggle("ModFly", false)
        editToggle("collectfilter_enable", false)
        stopScript(val.item, "Item not found", "Failed to find item in current world.")
        return
      elseif result == "blocked" then
        editToggle("ModFly", false)
        editToggle("collectfilter_enable", false)
        stopScript(1620, "Path is blocked", "Failed to FindPath.")
        return
      elseif result == "success" then
        editToggle("collectfilter_enable", false)
        msg("Success take item")
        Sleep(rnDelay(val.delay))
        fp(bx, by)
        editToggle("ModFly", false)
      end
    end
    ::continue::
  end
end    

addHook(function(type, name, value)
local val = getVar()
if name == "loadBtn" then
  if getValue(2, "key_input") == HKeyx then
    loaded = true
    Hsnconsume = Hsnconsume_setting
    addIntoModule(Hsnconsume, "HsnGL")
    growtopia.notify("`c[HsnGL] Script Loaded")
  else
     growtopia.sendDialog(table.concat({
        "set_default_color|`c",
        "add_spacer|small|",
        "add_custom_button|HsnGL|state:disabled;icon:12348;|",
        "add_textbox|Invalid Key!|",
        "add_smalltext|`wScript stopped.|",
        "add_smalltext|`wJoin my Discord Server to get key! (FREE)|",
        "add_custom_break|",
        "reset_placement_x|",
        "add_spacer|small|",
        "add_quick_exit|",
        "add_spacer|small|",
        "end_dialog|invalidKey|||",
        "add_smalltext|`9[Click button below]|",
        "add_url_button|keyLink|`cHsnGL's Discord``|noflags|https://discord.gg/3xKNPbB5qd|Visit the HsnGL's Discord?|0|0|",
        "add_custom_margin|x:300;y:0|\nadd_custom_button|DUMMY_PADDING_X|textLabel:``;state:disabled;middle_colour:0;border_colour:0;|"
    }, "\n"))
    return
  end
elseif name == "btnStart" and getValue(0, "btnStart") then
    if not running then
      running = true
      
      runThread(function()
        local sukses, hasil = pcall(function()
          mainLoop()
          return 10 / 0  -- ini error
            end)

        if sukses then
          log("Result:"..hasil)
        else
          log("Error:"..hasil) -- hasil = "attempt to divide by zero"
        end
      end)  
    end 
  elseif name == "btnStart" and not getValue(0, "btnStart") then
    if running then
      running = false
      editToggle("collectfilter_enable", false)
      editToggle("ModFly", false)
      growtopia.notify("`c[HsnGL] Auto Stopped")
      log("`c[HsnGL] Auto Consume Stopped")
    end  
  elseif name == "delay" then
    if loaded then
      growtopia.notify("`c[HsnGL] Delay set to : "..getValue(1, "delay"))
    end
  elseif name == "item_pick" then
    if loaded then
      growtopia.notify("`c[HsnGL] Item set to : "..val.name)
    end
  end  
end, "OnValue")
