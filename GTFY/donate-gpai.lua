local dgc = false
local scpass = "aZ7F2mQ9KxR4P8eL0WcB"
local item = { 1258,1260,1262,1264,1266,1268,1270,4308,4310,4312,4314,4316,4318,4296 }

function MenuPass()
menuVarList = {}
menuVarList[0] = "OnDialogRequest"
menuVarList[1] = [[
set_border_color|112,86,191,255
set_bg_color|43,34,74,200
set_default_color|`0
add_label_with_icon|big|`bPassword|left|762|
add_space|small|
add_text_input|spass|Password:  ||10|
add_spacer|small|
add_button|submit_pass|Submit|noflags|0|0|
end_dialog|menu_pass||
]]
menuVarList.netid = -1
SendVarlist(menuVarList)
end

function hhh(id)
    local player = GetLocal()
    SendPacketRaw({
      ["type"] = 3,
      ["int_data"] = id,
      ["pos_x"] = math.floor(player.pos_x / 32),
      ["pos_y"] = math.floor(player.pos_y / 32),
      ["int_x"] = math.floor(player.pos_x / 32),
      ["int_y"] = math.floor(player.pos_y / 32),
    })
end

function donate()
while dgc do
p = GetLocal()   
log("Buying Packs..")
for i = 1 , 10 do
      SendPacket(2,"action|buy\nitem|surg_value_pack\n")
      Sleep(50)
end

log("Start Submiting Items..")
for _ , a in ipairs(item) do
hhh(item)
 Sleep(3000)
end
end
end

function prev(var)
  if not dgc then return end
  if var[0] == "OnStoreRequest" then
    if var[1]:find("Home") or var[1]:find("`wWelcome to the `2Growtopia Store`w!") or var[1]:find("`2Awesome Items! `w") or var[1]:find("store") then
      return true
    end
  end
  if var[0] == "OnConsoleMessage" then
    if var[1]:find("Got") or var[1]:find("recycled,") or var[1]:find("You've") then
      return true
    end
  end
  
  if var[0] == "OnDialogRequest" and var[1]:find("4264") then
    local sx = var[1]:match('embed_data|tilex|(%d+)')
    local sy = var[1]:match('embed_data|tiley|(%d+)')
    local amnt = var[1]:match('add_text_input|amt||(%d+)|3|')
    local item = var[1]:match('embed_data|itemID|(%d+)')
    SendPacket(2, "action|dialog_return\ndialog_name|stuff4toys\ntilex|"..sx.."|\ntiley|"..sy.."|\nitemID|"..item.."|\namt|"..amnt.."\n")
  return true
  end
  
  return false
end

AddCallback("prev", "OnVarlist", prev)

function hadeh(type, packet)
    if type == 2 and packet:find("buttonClicked|submit_pass") then
        local pw = packet:match("spass|([^\n]+)")

        if pw and pw = scpass then
          dgc = true
          log("Password Match, Starting..")
          RunThread(function()
            pcall(donate)
          end)
        else
          log("`4Error: `cInvalid Password input!")
          MenuPass()
        end
        return true
    end
end

AddCallback("hadeh", "OnPacket", hadeh)

MenuPass()
