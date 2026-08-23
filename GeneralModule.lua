addCategory("HsnGL", "FileOpen")

local Hsngeneral = [[
{
    "sub_name": "HsnGL's General",
    "description": "General information.",
    "icon": "FileOpen",
    "menu": [
        {
            "type": "label",
            "text": "[Discord: @hsndika]"
        },
        {
            "type": "label",
            "text": ""
        },
        {
            "type": "label",
            "text": "❓ Have any question?"
        },
        {
            "type": "label",
            "text": "🛒 Buy PREMIUM scripts?"
        },
        {
            "type": "label",
            "text": "🐛 Report a bug?"
        },
        {
            "type": "label",
            "text": "✉️ DM me on Discord!"
        },
        {
            "type": "label",
            "text": ""
        },
        {
            "type": "tooltip",
            "text": "Join Discord for more FREE and PREMIUM script!",
            "support_text": "",
            "background": false,
            "icon": "AddLink"
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
        },
        {
            "type": "label",
            "text": ""
        },
        {
            "type": "tooltip",
            "text": "Discord and Youtube",
            "support_text": "",
            "background": false,
            "icon": "AddLink"
        },
        {
            "type": "divider"
        },
        {
            "type": "toggle_button",
            "text": "Discord",
            "default": false,
            "alias": "hsngeneral_link"
        },
        {
            "type": "divider"
        },
        {
            "type": "divider"
        },
        {
            "type": "toggle_button",
            "text": "Youtube",
            "default": false,
            "alias": "hsngeneral_link"
        },
        {
            "type": "divider"
        }
    ]
}    
]]

addIntoModule(Hsngeneral, "HsnGL")

addHook(function(type, name, value)
   if name == "hsngeneral_link" and value == true then
      load(fetch(RAW_URL))()
      editValue("hsngeneral_link", false)
   end   
end, "OnValue")
