local SUDO = 348927825 -- put Your ID here! <===
local MRoO = 348927825 -- put Your ID here! <===
function exi_files(cpath)
    local files = {}
    local pth = cpath
	local files = {}
    local pth = tostring(path)
	local psv = tostring(suffix)
    for k, v in pairs(scandir(pth)) do
		table.insert(files, v)
    end
	for k, v in pairs(scandir(pth)) do
        if (v:match('.'..psv..'$')) then
            table.insert(files, v)
        end
    end
    return files
end
----------------------------------------
local function file_exi(name, cpath)
	local fname = tostring(name)
	local pth = tostring(path)
	local psv = tostring(suffix)
    for k,v in pairs(exi_files(cpath)) do
        if name == v then
            return true
        end
    end
	for k,v in pairs(exi_file(pth, psv)) do
       if fname == v then
            return true
        end
    end
    return false
end
----------------------------------------
local function index_function(user_id)
  for k,v in pairs(_config.admins) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end
----------------------------------------
local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end 
----------------------------------------
local function already_sudo(user_id)
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  -- If not found
  return false
end
----------------------------------------
local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end
----------------------------------------
local function exi_file()
    local files = {}
    local pth = tcpath..'/data/document'
    for k, v in pairs(scandir(pth)) do
        if (v:match('.lua$')) then
            table.insert(files, v)
        end
    end
    return files
end
----------------------------------------
local function pl_exi(name)
    for k,v in pairs(exi_file()) do
        if name == v then
            return true
        end
    end
    return false
end
----------------------------------------
local function sudolist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local sudo_users = _config.sudo_users
  if not lang then
 text = "*Lιѕт σf ѕυɗσ υѕєяѕ :*\n"
   else
 text = "*لــیسـت سـودو هـای ربــات :*\n"
  end
for i=1,#sudo_users do
    text = text..i.." - "..sudo_users[i].."\n"
end
return text
end

local function adminlist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local sudo_users = _config.sudo_users
  if not lang then
 text = '*Lιѕт σf вσт αɗмιηѕ :*\n'
   else
 text = "*لــیست ادمـین هـای ربــات :*\n"
  end
		  	local compare = text
		  	local i = 1
		  	for v,user in pairs(_config.admins) do
			    text = text..i..'- '..(user[2] or '')..' ➣ ('..user[1]..')\n'
		  	i = i +1
		  	end
		  	if compare == text then
   if not lang then
		  		text = '`Ɲσ` *αɗмιηѕ* `αναιƖαвƖє`'
      else
		  		text = '*ادمـینـی بـرای ربـات تـعیـیـن نـشده*'
           end
		  	end
		  	return text
    end
----------------------------------------
local function chat_list(msg)
	i = 1
	local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] then
        return '*65Ɲσ gяσυρѕ αт тнє мσмєηт*'
    end
    local message = 'Lιѕт σf Ɠяσυρѕ:\n*Use #join (ID) тσ נσιη*\n\n'
    for k,v in pairsByKeys(data[tostring(groups)]) do
		local group_id = v
		if data[tostring(group_id)] then
			settings = data[tostring(group_id)]['settings']
		end
        for m,n in pairsByKeys(settings) do
			if m == 'set_name' then
				name = n:gsub("", "")
				chat_name = name:gsub("‮", "")
				group_name_id = name .. '\n(ID: ' ..group_id.. ')\n\n'
				if name:match("[\216-\219][\128-\191]") then
					group_info = i..' - \n'..group_name_id
				else
					group_info = i..' - '..group_name_id
				end
				i = i + 1
			end
        end
		message = message..group_info
    end
	return message
end
----------------------------------------
local function botrem(msg)
	local data = load_data(_config.moderation.data)
	data[tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		data[tostring(groups)] = nil
		save_data(_config.moderation.data, data)
	end
	data[tostring(groups)][tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	if redis:get('CheckExpire::'..msg.to.id) then
		redis:del('CheckExpire::'..msg.to.id)
	end
	if redis:get('ExpireDate:'..msg.to.id) then
		redis:del('ExpireDate:'..msg.to.id)
	end
	tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
end
----------------------------------------
local function warning(msg)
	local hash = "gp_lang:"..msg.to.id
	local lang = redis:get(hash)
	local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
	if expiretime == -1 then
		return
	else
	local d = math.floor(expiretime / 86400) + 1
        if tonumber(d) == 1 and not is_sudo(msg) and is_mod(msg) then
			if lang then
				tdcli.sendMessage(msg.to.id, 0, 1, 'از شارژ گروه 1 روز باقی مانده\nشارژ گروه : @tel_fire', 1, 'md')
			else
				tdcli.sendMessage(msg.to.id, 0, 1, '*Ɠяσυρ 1 ɗαу яємαιηιηg cнαяgє*\nƓяσυρ cнαяgє : @tel_fire', 1, 'md')
			end
		end
	end
end
----------------------------------------
local function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
----------------------------------------
local api_key = nil
local base_api = "https://maps.googleapis.com/maps/api"
----------------------------------------
local function get_latlong(area)
	local api      = base_api .. "/geocode/json?"
	local parameters = "address=".. (URL.escape(area) or "")
	if api_key ~= nil then
		parameters = parameters .. "&key="..api_key
	end
	local res, code = https.request(api..parameters)
	if code ~=200 then return nil  end
	local data = json:decode(res)
	if (data.status == "ZERO_RESULTS") then
		return nil
	end
	if (data.status == "OK") then
		lat  = data.results[1].geometry.location.lat
		lng  = data.results[1].geometry.location.lng
		acc  = data.results[1].geometry.location_type
		types= data.results[1].types
		return lat,lng,acc,types
	end
end
----------------------------------------
local function get_staticmap(area)
	local api        = base_api .. "/staticmap?"
	local lat,lng,acc,types = get_latlong(area)
	local scale = types[1]
	if scale == "locality" then
		zoom=8
	elseif scale == "country" then 
		zoom=4
	else 
		zoom = 13 
	end
	local parameters =
		"size=600x300" ..
		"&zoom="  .. zoom ..
		"&center=" .. URL.escape(area) ..
		"&markers=color:red"..URL.escape("|"..area)
	if api_key ~= nil and api_key ~= "" then
		parameters = parameters .. "&key="..api_key
	end
	return lat, lng, api..parameters
end
----------------------------------------
local function get_weather(location)
	print("Finding weather in ", location)
	local BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
	local url = BASE_URL
	url = url..'?q='..location..'&APPID=eedbc05ba060c787ab0614cad1f2e12b'
	url = url..'&units=metric'
	local b, c, h = http.request(url)
	if c ~= 200 then return nil end
	local weather = json:decode(b)
	local city = weather.name
	local country = weather.sys.country
	local temp = 'دمای شهر '..city..' هم اکنون '..weather.main.temp..' درجه سانتی گراد می باشد\n____________________\n @tel_fire :)'
	local conditions = 'شرایط فعلی آب و هوا : '
	if weather.weather[1].main == 'Clear' then
		conditions = conditions .. 'آفتابی☀'
	elseif weather.weather[1].main == 'Clouds' then
		conditions = conditions .. 'ابری ☁☁'
	elseif weather.weather[1].main == 'Rain' then
		conditions = conditions .. 'بارانی ☔'
	elseif weather.weather[1].main == 'Thunderstorm' then
		conditions = conditions .. 'طوفانی ☔☔☔☔'
	elseif weather.weather[1].main == 'Mist' then
		conditions = conditions .. 'مه 💨'
	end
	return temp .. '\n' .. conditions
end
----------------------------------------
local function calc(exp)
	url = 'http://api.mathjs.org/v1/'
	url = url..'?expr='..URL.escape(exp)
	b,c = http.request(url)
	text = nil
	if c == 200 then
    text = 'Result = '..b..'\n____________________\n @tel_fire :)'
	elseif c == 400 then
		text = b
	else
		text = 'Unexpected error\n'
		..'Is api.mathjs.org up?'
	end
	return text
end
----------------------------------------
local function info_by_reply(arg, data)
    if tonumber(data.sender_user_id_) then
local function info_cb(arg, data)
    if data.username_ then
  username = "@"..check_markdown(data.username_)
    else
  username = ""
  end
    if data.first_name_ then
  firstname = check_markdown(data.first_name_)
    else
  firstname = ""
  end
    if data.last_name_ then
  lastname = check_markdown(data.last_name_)
    else
  lastname = ""
  end
	local hash = 'rank:'..arg.chat_id..':variables'
   local text = "_First name :_ *"..firstname.."*\n_Last name :_ *"..lastname.."*\n_Username :_ "..username.."\n_ID :_ *"..data.id_.."*\n\n"
		    if data.id_ == tonumber(MRoO) then
		       text = text..'_Rank :_ *Executive Admin*\n\n'
			   elseif is_sudo1(data.id_) then
	           text = text..'_Rank :_ *Full Access Admin*\n\n'
		     elseif is_admin1(data.id_) then
		       text = text..'_Rank :_ *Bot Admin*\n\n'
		     elseif is_owner1(arg.chat_id, data.id_) then
		       text = text..'_Rank :_ *Group Owner*\n\n'
		     elseif is_mod1(arg.chat_id, data.id_) then
		       text = text..'_Rank :_ *Group Moderator*\n\n'
		 else
		       text = text..'_Rank :_ *Group Member*\n\n'
			end
         local user_info = {} 
  local uhash = 'user:'..data.id_
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..data.id_..':'..arg.chat_id
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
  text = text..'Total messages : '..user_info_msgs..'\n'
  text = text..MaTaDoRpm
  tdcli.sendMessage(arg.chat_id, arg.msgid, 0, text, 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, info_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_,msgid=data.id_})
    else
tdcli.sendMessage(data.chat_id_, "", 0, "*User not found*", 0, "md")
   end
end
----------------------------------------
local function info_by_username(arg, data)
    if tonumber(data.id_) then
    if data.type_.user_.username_ then
  username = "@"..check_markdown(data.type_.user_.username_)
    else
  username = ""
  end
    if data.type_.user_.first_name_ then
  firstname = check_markdown(data.type_.user_.first_name_)
    else
  firstname = ""
  end
    if data.type_.user_.last_name_ then
  lastname = check_markdown(data.type_.user_.last_name_)
    else
  lastname = ""
  end
	local hash = 'rank:'..arg.chat_id..':variables'
   local text = "_First name :_ *"..firstname.."*\n_Last name :_ *"..lastname.."*\n_Username :_ "..username.."\n_ID :_ *"..data.id_.."*\n\n"
		    if data.id_ == tonumber(MRoO) then
		       text = text..'_Rank :_ *Executive Admin*\n\n'
			   elseif is_sudo1(data.id_) then
	           text = text..'_Rank :_ *Full Access Admin*\n\n'
		     elseif is_admin1(data.id_) then
		       text = text..'_Rank :_ *Bot Admin*\n\n'
		     elseif is_owner1(arg.chat_id, data.id_) then
		       text = text..'_Rank :_ *Group Owner*\n\n'
		     elseif is_mod1(arg.chat_id, data.id_) then
		       text = text..'_Rank :_ *Group Moderator*\n\n'
		 else
		       text = text..'_Rank :_ *Group Member*\n\n'
			end
         local user_info = {} 
  local uhash = 'user:'..data.id_
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..data.id_..':'..arg.chat_id
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
  text = text..'Total messages : '..user_info_msgs..'\n'
  text = text..MaTaDoRpm
  tdcli.sendMessage(arg.chat_id, arg.msgid, 0, text, 0, "md")
   else
   tdcli.sendMessage(arg.chat_id, "", 0, "*User not found*", 0, "md")
  end
end
----------------------------------------
local function info_by_id(arg, data)
      if tonumber(data.id_) then
    if data.username_ then
  username = "@"..check_markdown(data.username_)
    else
  username = ""
  end
    if data.first_name_ then
  firstname = check_markdown(data.first_name_)
    else
  firstname = ""
  end
    if data.last_name_ then
  lastname = check_markdown(data.last_name_)
    else
  lastname = ""
  end
	local hash = 'rank:'..arg.chat_id..':variables'
   local text = "_First name :_ *"..firstname.."*\n_Last name :_ *"..lastname.."*\n_Username :_ "..username.."\n_ID :_ *"..data.id_.."*\n\n"
		    if data.id_ == tonumber(MRoO) then
		       text = text..'_Rank :_ *Executive Admin*\n\n'
			   elseif is_sudo1(data.id_) then
	           text = text..'_Rank :_ *Full Access Admin*\n\n'
		     elseif is_admin1(data.id_) then
		       text = text..'_Rank :_ *Bot Admin*\n\n'
		     elseif is_owner1(arg.chat_id, data.id_) then
		       text = text..'_Rank :_ *Group Owner*\n\n'
		     elseif is_mod1(arg.chat_id, data.id_) then
		       text = text..'_Rank :_ *Group Moderator*\n\n'
		 else
		       text = text..'_Rank :_ *Group Member*\n\n'
			end
         local user_info = {} 
  local uhash = 'user:'..data.id_
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..data.id_..':'..arg.chat_id
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
  text = text..'Total messages : '..user_info_msgs..'\n'
  text = text..MaTaDoRpm
  tdcli.sendMessage(arg.chat_id, arg.msgid, 0, text, 0, "md")
   else
   tdcli.sendMessage(arg.chat_id, "", 0, "*User not found*", 0, "md")
   end
end
----------------------------------------
local function delmsg (MaTaDoR,tel_fire)
    msgs = MaTaDoR.msgs 
    for k,v in pairs(tel_fire.messages_) do
        msgs = msgs - 1
        tdcli.deleteMessages(v.chat_id_,{[0] = v.id_}, dl_cb, cmd)
        if msgs == 1 then
            tdcli.deleteMessages(tel_fire.messages_[0].chat_id_,{[0] = tel_fire.messages_[0].id_}, dl_cb, cmd)
            return false
        end
    end
    tdcli.getChatHistory(tel_fire.messages_[0].chat_id_, tel_fire.messages_[0].id_,0 , 100, delmsg, {msgs=msgs})
end
----------------------------------------
local function modadd(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
   if not lang then
        return '*#》Ƴσυ αяє ησт вσт αɗмιη 🚷*\n*〰〰〰〰〰〰〰〰*\n💠 `Run this command only for Admins and deputies is`'
else
     return '#》 `شما` #مدیر `گروه نیستید` 🚷\n*〰〰〰〰〰〰〰〰*\n💠 اجرای این دستور فقط برای مدیران و معاونان است.'
    end
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
if not lang then
   return '#》 *Ɠяσυρ ιѕ αƖяєαɗу αɗɗєɗ* ‼️\n*〰〰〰〰〰〰〰〰*\n💠 `The robot is already in the group, the robot was is no longer need to do not`'
else
return '#》 `ربات در` #لیست `گروه ربات از قبل بود` ‼️\n*〰〰〰〰〰〰〰〰*\n💠 ربات از قبل در لیست گروه های ربات بود است دیگر نیازی به این‌کار نیست.'
  end
end
        -- create data array in moderation.json
      data[tostring(msg.to.id)] = {
			owners = {},
			mods ={},
			banned ={},
			is_silent_users ={},
			filterlist ={},
			whitelist ={},
			rules ={},
			settings = {
				set_name = msg.to.title,
				lock_link = 'lock',
				lock_tag = 'unlock',
				lock_username = 'lock',
				lock_spam = 'lock',
				lock_webpage = 'lock',
				lock_mention = 'unlock',
				lock_markdown = 'unlock',
				lock_flood = 'lock',
				lock_bots = 'lock',
				lock_pin = 'unlock',
				welcome = 'no',
				lock_join = 'unlock',
				lock_edit = 'unlock',
				lock_arabic = 'unlock',
				lock_english = 'unlock',
				lock_all = 'unlock',
				num_msg_max = '5',
				set_char = '40',
				time_check = '2',
				},
			mutes = {
				mute_fwd = 'unmute',
				mute_audio = 'unmute',
				mute_video = 'unmute',
				mute_contact = 'unmute',
				mute_text = 'unmute',
				mute_photos = 'unmute',
				mute_gif = 'unmute',
				mute_loc = 'unmute',
				mute_doc = 'unmute',
				mute_sticker = 'unmute',
				mute_voice = 'unmute',
				mute_all = 'unmute',
				mute_keyboard = 'unmute',
				mute_game = 'unmute',
				mute_inline = 'unmute',
				mute_tgservice = 'unmute',
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
    if not lang then
  return '#》 *Ɠяσυρ нαѕ вєєη αɗɗєɗ* ✅🤖\n\n*Ɠяσυρ Ɲαмє :*'..msg.to.title..'\n*OяɗєяƁу :* [@'..check_markdown(msg.from.username or '')..'*|*`'..msg.from.id..'`]\n*〰〰〰〰〰〰〰〰*\n💠 `Group now to list the groups the robot was added`\n*Ɠяσυρ cнαяgєɗ 3 мιηυтєѕ  fσя ѕєттιηgѕ.*'
else
  return '#》 `گروه به` #لیست `گروه ربات اضافه شده` ✅🤖\n\n*اسم گروه :*'..msg.to.title..'\n*توسط :* [@'..check_markdown(msg.from.username or '')..'*|*`'..msg.from.id..'`]\n*〰〰〰〰〰〰〰〰*\n💠 گروه هم اکنون به لیست گروه ربات اضافه شد.\n_گروه به مدت_ *3* _دقیقه برای اجرای تنظیمات شارژ میباشد._'
end
end
----------------------------------------
local function modrem(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
  if not lang then
    return '#》 *Ɠяσυρ ιѕ ησт αɗɗєɗ* 🚫\n*〰〰〰〰〰〰〰〰*\n💠 `Group from the first to the group list, the robot was not added`'
else
    return '#》 `گروه در` #لیست `گروه ربات  نیست` 🚫\n*〰〰〰〰〰〰〰〰*\n💠 گروه از اول به لیست گروه ربات اضافه نشده است .'
   end
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
       data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
 if not lang then
  return '#》 *Ɠяσυρ нαѕ вєєη яємσνєɗ* ❌🤖\n\n*Ɠяσυρ Ɲαмє :*'..msg.to.title..'\n*OяɗєяƁу :* [@'..check_markdown(msg.from.username or '')..'*|*`'..msg.from.id..'`]\n*〰〰〰〰〰〰〰〰*\n💠 `The group now from the list of groups, the robot was removed`'
 else
  return '#》 `گروه از` #لیست `گروه های ربات حدف شد` ❌🤖\n\n*اسم گروه :*'..msg.to.title..'\n*توسط :* [@'..check_markdown(msg.from.username or '')..'*|*`'..msg.from.id..'`]\n*〰〰〰〰〰〰〰〰*\n💠 گروه هم اکنون از لیست گروه ربات حذف شد.'
end
end
----------------------------------------
 local function config_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
  --print(serpent.block(data))
   for k,v in pairs(data.members_) do
   local function config_mods(arg, data)
       local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   end
tdcli_function ({
    ID = "GetUser",
    user_id_ = v.user_id_
  }, config_mods, {chat_id=arg.chat_id,user_id=v.user_id_})
 
if data.members_[k].status_.ID == "ChatMemberStatusCreator" then
owner_id = v.user_id_
   local function config_owner(arg, data)
 -- print(serpent.block(data))
       local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    return
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   end
tdcli_function ({
    ID = "GetUser",
    user_id_ = owner_id
  }, config_owner, {chat_id=arg.chat_id,user_id=owner_id})
   end
end
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*AƖƖ gяσυρ αɗмιηѕ нαѕ вєєη ρяσмσтєɗ αηɗ gяσυρ cяєαтσя ιѕ ησω gяσυρ σωηєя*👤😎", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "`تمام ادمین های گروه به مقام مدیر منتصب شدند و سازنده گروه به مقام مالک گروه منتصب شد`👤😎", 0, "md")
     end
 end
----------------------------------------
local function filter_word(msg, word)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)]['filterlist'] then
    data[tostring(msg.to.id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
if data[tostring(msg.to.id)]['filterlist'][(word)] then
   if not lang then
         return "*Ɯσяɗ* [`"..word.."`] *ιѕ αƖяєαɗу fιƖтєяєɗ*♻️⚠️"
            else
         return "*کلمه* [`"..word.."`] *از قبل فیلتر بود*♻️⚠️"
    end
end
   data[tostring(msg.to.id)]['filterlist'][(word)] = true
     save_data(_config.moderation.data, data)
   if not lang then
         return "*Ɯσяɗ* [`"..word.."`] *αɗɗєɗ тσ fιƖтєяєɗ ωσяɗѕ Ɩιѕт*✔️📝"
            else
         return "*کلمه* [`"..word.."`] *به لیست کلمات فیلتر شده اضافه شد*✔️📝"
    end
end
----------------------------------------
local function unfilter_word(msg, word)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)]['filterlist'] then
    data[tostring(msg.to.id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
      if data[tostring(msg.to.id)]['filterlist'][word] then
      data[tostring(msg.to.id)]['filterlist'][(word)] = nil
       save_data(_config.moderation.data, data)
       if not lang then
         return "*Ɯσяɗ* [`"..word.."`] *яємσνєɗ fяσм fιƖтєяєɗ ωσяɗѕ Ɩιѕт*❌📝"
       elseif lang then
         return "*کلمه* [`"..word.."`] *از لیست کلمات فیلتر شده حذف شد*❌📝"
     end
      else
       if not lang then
         return "*Ɯσяɗ* [`"..word.."`] *ιѕ ησт fιƖтєяєɗ*🚫👣"
       elseif lang then
         return "*کلمه* [`"..word.."`] *از قبل فیلتر نبود*🚫👣"
      end
   end
end
----------------------------------------
local function modlist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
  if not lang then
    return "#》 *Ɠяσυρ ιѕ ησт αɗɗєɗ* 🚫\n*〰〰〰〰〰〰〰〰*\n💠 `Group from the first to the group list, the robot was not added`"
 else
    return "#》 `گروه در` #لیست `گروه ربات  نیست` 🚫\n*〰〰〰〰〰〰〰〰*\n💠 گروه از اول به لیست گروه ربات اضافه نشده است ."
  end
 end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
  if not lang then
    return "`Ɲσ` *MσɗєяαƬσя* `ιη Ƭнιѕ Ɠяσυρ`🚫⚠️"
else
   return "`در حال حاضر هیچ` #مدیری `برای گروه انتخاب نشده است`🚫⚠️"
  end
end
if not lang then
   message = '*⚜Lιѕт σf мσɗєяαтσяѕ :*\n'
else
   message = '*⚜لیست مدیران گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.to.id)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end
----------------------------------------
local function ownerlist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
if not lang then
    return "#》 *Ɠяσυρ ιѕ ησт αɗɗєɗ* 🚫\n*〰〰〰〰〰〰〰〰*\n💠 `Group from the first to the group list, the robot was not added`"
else
return "#》 `گروه در` #لیست `گروه ربات  نیست` 🚫\n*〰〰〰〰〰〰〰〰*\n💠 گروه از اول به لیست گروه ربات اضافه نشده است ."
  end
end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
 if not lang then
    return "`Ɲσ` *Oωηєя* `ιη Ƭнιѕ Ɠяσυρ`🚫⚠️"
else
    return "`در حال حاضر هیچ` #مالکی `برای گروه انتخاب نشده است`🚫⚠️"
  end
end
if not lang then
   message = '*⚜Lιѕт σf σωηєяѕ :*\n'
else
   message = '*⚜لیست مالکین گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end
----------------------------------------
local function action_by_reply(arg, data)
local hash = "gp_lang:"..data.chat_id_
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not tonumber(data.sender_user_id_) then return false end
    if data.sender_user_id_ then
  if not administration[tostring(data.chat_id_)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "#》 *Ɠяσυρ ιѕ ησт αɗɗєɗ* 🚫\n*〰〰〰〰〰〰〰〰*\n💠 `Group from the first to the group list, the robot was not added`", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_#》 `گروه در` #لیست `گروه ربات  نیست` 🚫\n*〰〰〰〰〰〰〰〰*\n💠 گروه از اول به لیست گروه ربات اضافه نشده است ._", 0, "md")
     end
  end
  if cmd == "ban" then
local function ban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
   if is_mod1(arg.chat_id, data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_Ƴσυ cαη'т вαη_ *мσɗѕ,σωηєяѕ αηɗ вσт αɗмιηѕ*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه، و ادمین های ربات رو از گروه محروم کنید*", 0, "md")
         end
     end
if administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ αƖяєαɗу_ *вαηηєɗ*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n * از گروه محروم بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ вєєη_ *вαηηєɗ*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از گروه محروم شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, ban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
   if cmd == "unban" then
local function unban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ ησт_ *вαηηєɗ*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از گروه محروم نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ вєєη_ *υηвαηηєɗ*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از محرومیت گروه خارج شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, unban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "silent" then
local function silent_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
   if is_mod1(arg.chat_id, data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_Ƴσυ cαη'т ѕιƖєηт_ *мσɗѕ,σωηєяѕ αηɗ вσт αɗмιηѕ*", 0, "md")
    else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه، و ادمین های ربات بگیرید*", 0, "md")
       end
     end
if administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ αƖяєαɗу_ *ѕιƖєηт*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل توانایی چت کردن رو نداشت*", 0, "md")
     end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _αɗɗєɗ тσ_ *ѕιƖєηт υѕєяѕ Ɩιѕт*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *توانایی چت کردن رو از دست داد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, silent_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "unsilent" then
local function unsilent_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ ησт_ *ѕιƖєηт*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل توانایی چت کردن را داشت*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _яємσνєɗ fяσм_ *ѕιƖєηт υѕєяѕ Ɩιѕт*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *توانایی چت کردن رو به دست آورد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, unsilent_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "banall" then
local function gban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
   if is_admin1(data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_Ƴσυ cαη'т_ *gƖσвαƖƖу вαη* _σтнєя αɗмιηѕ_", 0, "md")
  else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید ادمین های ربات رو از تمامی گروه های ربات محروم کنید*", 0, "md")
        end
     end
if is_gbanned(data.id_) then
   if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ αƖяєαɗу_ *gƖσвαƖƖу вαηηєɗ*", 0, "md")
    else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از گروه های ربات محروم بود*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
     if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ вєєη_ *gƖσвαƖƖу вαηηєɗ*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از تمام گروه های ربات محروم شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, gban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "unbanall" then
local function ungban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
if not is_gbanned(data.id_) then
   if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ ησт_ *gƖσвαƖƖу вαηηєɗ*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از گروه های ربات محروم نبود*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ вєєη_ *gƖσвαƖƖу υηвαηηєɗ*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از محرومیت گروه های ربات خارج شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, ungban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "kick" then
   if is_mod1(data.chat_id_, data.sender_user_id_) then
   if not lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "_Ƴσυ cαη'т кιcк_ *мσɗѕ,σωηєяѕ αηɗ вσт αɗмιηѕ*", 0, "md")
    elseif lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*", 0, "md")
   end
  else
     kick_user(data.sender_user_id_, data.chat_id_)
     end
  end
  if cmd == "delall" then
   if is_mod1(data.chat_id_, data.sender_user_id_) then
   if not lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "_Ƴσυ cαη'т ɗєƖєтє мєѕѕαgєѕ_ *мσɗѕ,σωηєяѕ αηɗ вσт αɗмιηѕ*", 0, "md")
   elseif lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "*شما نمیتوانید پیام های مدیران،صاحبان گروه و ادمین های ربات رو پاک کنید*", 0, "md")
   end
  else
tdcli.deleteMessagesFromUser(data.chat_id_, data.sender_user_id_, dl_cb, nil)
   if not lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "_AƖƖ_ *мєѕѕαgєѕ* _σf_ *[ "..data.sender_user_id_.." ]* _нαѕ вєєη_ *ɗєƖєтєɗ*", 0, "md")
      elseif lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "*تمام پیام های* *[ "..data.sender_user_id_.." ]* *پاک شد*", 0, "md")
       end
    end
  end
    if cmd == "adminprom" then
local function adminprom_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if is_admin1(tonumber(data.id_)) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ αƖяєαɗу α` *αɗмιη*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل ادمین ربات بود_", 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `нαѕ вєєη ρяσмσтєɗ αѕ` *αɗмιη*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _به مقام ادمین ربات منتصب شد_", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, adminprom_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "admindem" then
local function admindem_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
	local nameid = index_function(tonumber(data.id_))
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not is_admin1(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ ησт α` *αɗмιη*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل ادمین ربات نبود_", 0, "md")
      end
   end
		table.remove(_config.admins, getindex( _config.admins, tonumber(data.id_)))
		save_config()
		reload_plugins(true)
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `нαѕ вєєη ɗємσтєɗ fяσм` *αɗмιη*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از مقام ادمین ربات برکنار شد_", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, admindem_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "visudo" then
local function visudo_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ αƖяєαɗу α` *ѕυɗσєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل سودو ربات بود_", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ ησω` *ѕυɗσєя*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _به مقام سودو ربات منتصب شد_", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, visudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "desudo" then
local function desudo_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ ησт α` *ѕυɗσєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل سودو ربات نبود_", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `нαѕ вєєη ɗємσтєɗ fяσм` *ѕυɗσєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از مقام سودو ربات برکنار شد_", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, desudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
if cmd == "setmanager" then
local function manager_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  channel_set_admin(arg.chat_id, data.id_)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n_ιѕ Ɲσω Ƭнє_ *Ɠяσυρ Mαηαgєя*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n*ادمین گروه شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, manager_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
if cmd == "remmanager" then
local function rem_manager_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  channel_demote(arg.chat_id, data.id_)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσ Lσηgєя_ *Ɠяσυρ Mαηαgєя*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از ادمینی گروه برکنار شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, rem_manager_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "setwhitelist" then
local function setwhitelist_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ AƖяєαɗу ιη_ *Ɯнιтє Lιѕт*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل در لیست سفید بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη Aɗɗєɗ Ƭσ_ *Ɯнιтє Lιѕт*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *به لیست سفید اضافه شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, setwhitelist_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "remwhitelist" then
local function remwhitelist_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if not administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσт ιη_ *Ɯнιтє Lιѕт*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل در لیست سفید نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη Rємσνєɗ Ƒяσм_ *Ɯнιтє Lιѕт*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از لیست سفید حذف شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, remwhitelist_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
if cmd == "setowner" then
local function owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ AƖяєαɗу α_ *Ɠяσυρ Oωηєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσω Ƭнє_ *Ɠяσυρ Oωηєя*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "promote" then
local function promote_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ AƖяєαɗу α_ *Mσɗєяαтσя*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل مدیر گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη_ *Mσɗєяαтσя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *به مقام مدیر گروه منتصب شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, promote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
     if cmd == "remowner" then
local function rem_owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσт α_ *Ɠяσυρ Oωηєя*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσ Lσηgєя α_ *Ɠяσυρ Oωηєя*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, rem_owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "demote" then
local function demote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ ησт α_ *Mσɗєяαтσя*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل مدیر گروه نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη_ *Ɗємσтєɗ*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از مقام مدیر گروه برکنار شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, demote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "id" then
local function id_cb(arg, data)
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, id_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
else
    if lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "`کاربر یافت نشد`⚠️👣", 0, "md")
   else
  return tdcli.sendMessage(data.chat_id_, "", 0, "`Uѕєя Ɲσт Ƒσυηɗ`⚠️👣", 0, "md")
      end
   end
end
----------------------------------------
local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "#》 *Ɠяσυρ ιѕ ησт αɗɗєɗ* 🚫\n*〰〰〰〰〰〰〰〰*\n💠 `Group from the first to the group list, the robot was not added`", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_#》 `گروه در` #لیست `گروه ربات  نیست` 🚫\n*〰〰〰〰〰〰〰〰*\n💠 گروه از اول به لیست گروه ربات اضافه نشده است ._", 0, "md")
     end
  end
if not arg.username then return false end
   if data.id_ then
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = check_markdown(data.title_)
end
  if cmd == "ban" then
   if is_mod1(arg.chat_id, data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_Ƴσυ cαη'т вαη_ *мσɗѕ,σωηєяѕ αηɗ вσт αɗмιηѕ*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه، و ادمین های ربات رو از گروه محروم کنید*", 0, "md")
         end
     end
if administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ αƖяєαɗу_ *вαηηєɗ*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n * از گروه محروم بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ вєєη_ *вαηηєɗ*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از گروه محروم شد*", 0, "md")
   end
end
   if cmd == "unban" then
if not administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ ησт_ *вαηηєɗ*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از گروه محروم نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ вєєη_ *υηвαηηєɗ*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از محرومیت گروه خارج شد*", 0, "md")
   end
end
  if cmd == "silent" then
   if is_mod1(arg.chat_id, data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_Ƴσυ cαη'т ѕιƖєηт_ *мσɗѕ,σωηєяѕ αηɗ вσт αɗмιηѕ*", 0, "md")
    else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه، و ادمین های ربات بگیرید*", 0, "md")
       end
     end
if administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ αƖяєαɗу_ *ѕιƖєηт*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل توانایی چت کردن رو نداشت*", 0, "md")
     end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _αɗɗєɗ тσ_ *ѕιƖєηт υѕєяѕ Ɩιѕт*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *توانایی چت کردن رو از دست داد*", 0, "md")
   end
end
  if cmd == "unsilent" then
if not administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ ησт_ *ѕιƖєηт*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل توانایی چت کردن را داشت*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _яємσνєɗ fяσм_ *ѕιƖєηт υѕєяѕ Ɩιѕт*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *توانایی چت کردن رو به دست آورد*", 0, "md")
   end
end
  if cmd == "banall" then
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
   if is_admin1(data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_Ƴσυ cαη'т_ *gƖσвαƖƖу вαη* _σтнєя αɗмιηѕ_", 0, "md")
  else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید ادمین های ربات رو از تمامی گروه های ربات محروم کنید*", 0, "md")
        end
     end
if is_gbanned(data.id_) then
   if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ αƖяєαɗу_ *gƖσвαƖƖу вαηηєɗ*", 0, "md")
    else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از گروه های ربات محروم بود*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
     if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ вєєη_ *gƖσвαƖƖу вαηηєɗ*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از تمام گروه های ربات محروم شد*", 0, "md")
   end
end
  if cmd == "unbanall" then
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
if not is_gbanned(data.id_) then
     if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ ησт_ *gƖσвαƖƖу вαηηєɗ*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از گروه های ربات محروم نبود*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ вєєη_ *gƖσвαƖƖу υηвαηηєɗ*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از محرومیت گروه های ربات خارج شد*", 0, "md")
   end
end
  if cmd == "kick" then
   if is_mod1(arg.chat_id, data.id_) then
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_Ƴσυ cαη'т кιcк_ *мσɗѕ,σωηєяѕ αηɗ вσт αɗмιηѕ*", 0, "md")
    elseif lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*", 0, "md")
   end
  else
     kick_user(data.id_, arg.chat_id)
     end
  end
  if cmd == "delall" then
   if is_mod1(arg.chat_id, data.id_) then
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_Ƴσυ cαη'т ɗєƖєтє мєѕѕαgєѕ_ *мσɗѕ,σωηєяѕ αηɗ вσт αɗмιηѕ*", 0, "md")
   elseif lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید پیام های مدیران،صاحبان گروه و ادمین های ربات رو پاک کنید*", 0, "md")
   end
  else
tdcli.deleteMessagesFromUser(arg.chat_id, data.id_, dl_cb, nil)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_AƖƖ_ *мєѕѕαgєѕ* _σf_ "..user_name.." *[ "..data.id_.." ]* _нαѕ вєєη_ *ɗєƖєтєɗ*", 0, "md")
      elseif lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*تمام پیام های* "..user_name.." *[ "..data.id_.." ]* *پاک شد*", 0, "md")
       end
    end
  end
    if cmd == "adminprom" then
if is_admin1(tonumber(data.id_)) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ αƖяєαɗу αη` *αɗмιη*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل ادمین ربات بود_", 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `нαѕ вєєη ρяσмσтєɗ αѕ` *αɗмιη*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _به مقام ادمین ربات منتصب شد_", 0, "md")
   end
end
    if cmd == "admindem" then
	local nameid = index_function(tonumber(data.id_))
if not is_admin1(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ ησт α` *αɗмιη*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل ادمین ربات نبود_", 0, "md")
      end
   end
		table.remove(_config.admins, nameid)
		save_config()
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `нαѕ вєєη ɗємσтєɗ fяσм` *αɗмιη*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از مقام ادمین ربات برکنار شد_", 0, "md")
   end
end
    if cmd == "visudo" then
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ αƖяєαɗу α` *ѕυɗσєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل سودو ربات بود_", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ ησω` *ѕυɗσєя*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _به مقام سودو ربات منتصب شد_", 0, "md")
   end
end
    if cmd == "desudo" then
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ ησт α` *ѕυɗσєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل سودو ربات نبود_", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `нαѕ вєєη ɗємσтєɗ fяσм` *ѕυɗσєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از مقام سودو ربات برکنار شد_", 0, "md")
      end
   end
if cmd == "setmanager" then
  channel_set_admin(arg.chat_id, data.id_)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n_ιѕ Ɲσω Ƭнє_ *Ɠяσυρ Mαηαgєя*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n*ادمین گروه شد*", 0, "md")
   end
end
if cmd == "remmanager" then
  channel_demote(arg.chat_id, data.id_)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσ Lσηgєя_ *Ɠяσυρ Mαηαgєя*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از ادمینی گروه برکنار شد*", 0, "md")
   end
 end
    if cmd == "setwhitelist" then
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ AƖяєαɗу ιη_ *Ɯнιтє Lιѕт*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل در لیست سفید بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη Aɗɗєɗ Ƭσ_ *Ɯнιтє Lιѕт*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *به لیست سفید اضافه شد*", 0, "md")
   end
end
    if cmd == "remwhitelist" then
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if not administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσт ιη_ *Ɯнιтє Lιѕт*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل در لیست سفید نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη Rємσνєɗ Ƒяσм_ *Ɯнιтє Lιѕт*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از لیست سفید حذف شد*", 0, "md")
   end
end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ AƖяєαɗу α_ *Ɠяσυρ Oωηєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσω Ƭнє_ *Ɠяσυρ Oωηєя*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ AƖяєαɗу α_ *Mσɗєяαтσя*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل مدیر گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη_ *Mσɗєяαтσя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *به مقام مدیر گروه منتصب شد*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσт α_ *Ɠяσυρ Oωηєя*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσ Lσηgєя α_ *Ɠяσυρ Oωηєя*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ ησт α_ *Mσɗєяαтσя*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل مدیر گروه نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη_ *Ɗємσтєɗ*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از مقام مدیر گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "id" then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
    if cmd == "res" then
    if not lang then
     text = "Result for [ "..check_markdown(data.type_.user_.username_).." ] :\n"
    .. ""..check_markdown(data.title_).."\n"
    .. " ["..data.id_.."]"
  else
     text = "اطلاعات برای [ "..check_markdown(data.type_.user_.username_).." ] :\n"
    .. "".. check_markdown(data.title_) .."\n"
    .. " [".. data.id_ .."]"
         end
       return tdcli.sendMessage(arg.chat_id, 0, 1, text, 1, 'md')
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "`کاربر یافت نشد`⚠️👣", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "`Uѕєя Ɲσт Ƒσυηɗ`⚠️👣", 0, "md")
      end
   end
end
----------------------------------------
local function action_by_id(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "#》 *Ɠяσυρ ιѕ ησт αɗɗєɗ* 🚫\n*〰〰〰〰〰〰〰〰*\n💠 `Group from the first to the group list, the robot was not added`", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_#》 `گروه در` #لیست `گروه ربات  نیست` 🚫\n*〰〰〰〰〰〰〰〰*\n💠 گروه از اول به لیست گروه ربات اضافه نشده است ._", 0, "md")
     end
  end
if not tonumber(arg.user_id) then return false end
   if data.id_ then
if data.first_name_ then
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
    if cmd == "adminprom" then
if is_admin1(tonumber(data.id_)) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ αƖяєαɗу αη` *αɗмιη*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل ادمین ربات بود_", 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `нαѕ вєєη ρяσмσтєɗ αѕ` *αɗмιη*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _به مقام ادمین ربات منتصب شد_", 0, "md")
   end
end 
    if cmd == "admindem" then
	local nameid = index_function(tonumber(data.id_))
if not is_admin1(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ ησт α` *αɗмιη*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل ادمین ربات نبود_", 0, "md")
      end
   end
		table.remove(_config.admins, nameid)
		save_config()
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `нαѕ вєєη ɗємσтєɗ fяσм` *αɗмιη*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از مقام ادمین ربات برکنار شد_", 0, "md")
   end
end
    if cmd == "visudo" then
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ αƖяєαɗу α` *ѕυɗσєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل سودو ربات بود_", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ ησω` *ѕυɗσєя*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _به مقام سودو ربات منتصب شد_", 0, "md")
   end
end
    if cmd == "desudo" then
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `ιѕ ησт α` *ѕυɗσєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از قبل سودو ربات نبود_", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_clonfig()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n `нαѕ вєєη ɗємσтєɗ fяσм` *ѕυɗσєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از مقام سودو ربات برکنار شد_", 0, "md")
      end
   end
if cmd == "setmanager" then
  channel_set_admin(arg.chat_id, data.id_)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n_ιѕ Ɲσω Ƭнє_ *Ɠяσυρ Mαηαgєя*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n*ادمین گروه شد*", 0, "md")
   end
end
if cmd == "remmanager" then
  channel_demote(arg.chat_id, data.id_)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*✴️》Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]` _ιѕ Ɲσ Lσηgєя_ *Ɠяσυρ Mαηαgєя*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از ادمینی گروه برکنار شد*", 0, "md")
   end
 end
    if cmd == "setwhitelist" then
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ AƖяєαɗу ιη_ *Ɯнιтє Lιѕт*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل در لیست سفید بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη Aɗɗєɗ Ƭσ_ *Ɯнιтє Lιѕт*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *به لیست سفید اضافه شد*", 0, "md")
   end
end
    if cmd == "remwhitelist" then
  if not administration[tostring(arg.chat_id)]['whitelist'] then
    administration[tostring(arg.chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, administration)
    end
if not administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσт ιη_ *Ɯнιтє Lιѕт*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل در لیست سفید نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['whitelist'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη Rємσνєɗ Ƒяσм_ *Ɯнιтє Lιѕт*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از لیست سفید حذف شد*", 0, "md")
   end
end
  if cmd == "setowner" then
  if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ AƖяєαɗу α_ *Ɠяσυρ Oωηєя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσω Ƭнє_ *Ɠяσυρ Oωηєя*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ AƖяєαɗу α_ *Mσɗєяαтσя*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل مدیر گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη_ *Mσɗєяαтσя*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *به مقام مدیر گروه منتصب شد*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσт α_ *Ɠяσυρ Oωηєя*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ Ɲσ Lσηgєя α_ *Ɠяσυρ Oωηєя*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _ιѕ ησт α_ *Mσɗєяαтσя*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از قبل مدیر گروه نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _нαѕ Ɓєєη_ *Ɗємσтєɗ*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n *از مقام مدیر گروه برکنار شد*", 0, "md")
   end
end
 else
    if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "`Uѕєя Ɲσт Ƒσυηɗ`⚠️👣", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "`کاربر یافت نشد`⚠️👣", 0, "md")
    end
  end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "`کاربر یافت نشد`⚠️👣", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "`Uѕєя Ɲσт Ƒσυηɗ`⚠️👣", 0, "md")
      end
   end
end
----------------------------------------
local checkmod = true
local TIME_CHECK = 2
local function pre_process(msg)
local chat = msg.to.id
local user = msg.from.id
local hash = "gp_lang:"..chat
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
local is_channel = msg.to.type == "channel"
local is_chat = msg.to.type == "chat"
local auto_leave = 'auto_leave_bot'
local hash = "gp_lang:"..chat
local lang = redis:get(hash)
local muteallchk = 'muteall:'..msg.to.id
if is_channel or is_chat then
        local TIME_CHECK = 2
        if data[tostring(chat)] then
          if data[tostring(chat)]['settings']['time_check'] then
            TIME_CHECK = tonumber(data[tostring(chat)]['settings']['time_check'])
          end
        end
    if msg.text then
  if msg.text:match("(.*)") then
    if not data[tostring(msg.to.id)] and not redis:get(auto_leave) and not is_admin(msg) then
  tdcli.sendMessage(msg.to.id, "", 0, "_This Is Not One Of My_ *Groups*", 0, "md")
  tdcli.changeChatMemberStatus(chat, our_id, 'Left', dl_cb, nil)
      end
   end
end
  if redis:get(muteallchk) and not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) then
  if is_channel then
    del_msg(chat, tonumber(msg.id))
	elseif is_chat then
	kick_user(user, chat)
  end
  end
if not redis:get('autodeltime') then
redis:setex('autodeltime', 3600, true)
     run_bash("rm -rf ~/.telegram-cli/data/sticker/*")
     run_bash("rm -rf ~/.telegram-cli/data/photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/animation/*")
     run_bash("rm -rf ~/.telegram-cli/data/video/*")
     run_bash("rm -rf ~/.telegram-cli/data/audio/*")
     run_bash("rm -rf ~/.telegram-cli/data/voice/*")
     run_bash("rm -rf ~/.telegram-cli/data/temp/*")
     run_bash("rm -rf ~/.telegram-cli/data/thumb/*")
     run_bash("rm -rf ~/.telegram-cli/data/document/*")
     run_bash("rm -rf ~/.telegram-cli/data/profile_photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/encrypted/*")
	 run_bash("rm -rf ./data/photos/*")
end
    if data[tostring(chat)] and data[tostring(chat)]['mutes'] then
		mutes = data[tostring(chat)]['mutes']
	else
		return
	end
	if mutes.mute_gif then
		mute_gif = mutes.mute_gif
	else
		mute_gif = 'unmute'
	end
   if mutes.mute_photo then
		mute_photo = mutes.mute_photo
	else
		mute_photo = 'unmute'
	end
	if mutes.mute_sticker then
		mute_sticker = mutes.mute_sticker
	else
		mute_sticker = 'unmute'
	end
	if mutes.mute_contact then
		mute_contact = mutes.mute_contact
	else
		mute_contact = 'unmute'
	end
	if mutes.mute_inline then
		mute_inline = mutes.mute_inline
	else
		mute_inline = 'unmute'
	end
	if mutes.mute_game then
		mute_game = mutes.mute_game
	else
		mute_game = 'unmute'
	end
	if mutes.mute_text then
		mute_text = mutes.mute_text
	else
		mute_text = 'unmute'
	end
	if mutes.mute_keyboard then
		mute_keyboard = mutes.mute_keyboard
	else
		mute_keyboard = 'unmute'
	end
	if mutes.mute_forward then
		mute_forward = mutes.mute_forward
	else
		mute_forward = 'unmute'
	end
	if mutes.mute_location then
		mute_location = mutes.mute_location
	else
		mute_location = 'unmute'
	end
   if mutes.mute_document then
		mute_document = mutes.mute_document
	else
		mute_document = 'unmute'
	end
	if mutes.mute_voice then
		mute_voice = mutes.mute_voice
	else
		mute_voice = 'unmute'
	end
	if mutes.mute_audio then
		mute_audio = mutes.mute_audio
	else
		mute_audio = 'unmute'
	end
	if mutes.mute_video then
		mute_video = mutes.mute_video
	else
		mute_video = 'unmute'
	end
	if mutes.mute_tgservice then
		mute_tgservice = mutes.mute_tgservice
	else
		mute_tgservice = 'unmute'
	end
	if data[tostring(chat)] and data[tostring(chat)]['settings'] then
		settings = data[tostring(chat)]['settings']
	else
		return
	end
	if settings.lock_link then
		lock_link = settings.lock_link
	else
		lock_link = 'unlock'
	end
	if settings.lock_join then
		lock_join = settings.lock_join
	else
		lock_join = 'unlock'
	end
	if settings.lock_tag then
		lock_tag = settings.lock_tag
	else
		lock_tag = 'unlock'
	end
	if settings.lock_username then
		lock_username = settings.lock_username
	else
		lock_username = 'unlock'
	end
	if settings.lock_pin then
		lock_pin = settings.lock_pin
	else
		lock_pin = 'unlock'
	end
	if settings.lock_arabic then
		lock_arabic = settings.lock_arabic
	else
		lock_arabic = 'unlock'
	end
	if settings.lock_english then
		lock_english = settings.lock_english
	else
		lock_english = 'unlock'
	end		
	if settings.lock_mention then
		lock_mention = settings.lock_mention
	else
		lock_mention = 'unlock'
	end
		if settings.lock_edit then
		lock_edit = settings.lock_edit
	else
		lock_edit = 'unlock'
	end
		if settings.lock_spam then
		lock_spam = settings.lock_spam
	else
		lock_spam = 'unlock'
	end
	if settings.lock_flood then
		lock_flood = settings.lock_flood
	else
		lock_flood = 'unlock'
	end
	if settings.lock_markdown then
		lock_markdown = settings.lock_markdown
	else
		lock_markdown = 'unlock'
	end
	if settings.lock_webpage then
		lock_webpage = settings.lock_webpage
	else
		lock_webpage = 'unlock'
	end
  if msg.adduser or msg.joinuser or msg.deluser then
  if mute_tgservice == "mute" then
del_msg(chat, tonumber(msg.id))
  end
end
if not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) then
	if msg.adduser or msg.joinuser then
		if lock_join == "lock" then
			function join_kick(arg, data)
				kick_user(data.id_, msg.to.id)
			end
			if msg.adduser then
				tdcli.getUser(msg.adduser, join_kick, nil)
			elseif msg.joinuser then
				tdcli.getUser(msg.joinuser, join_kick, nil)
			end
		end
	end
end
   if msg.pinned and is_channel then
  if lock_pin == "lock" then
     if is_owner(msg) then
      return
     end
     if tonumber(msg.from.id) == our_id then
      return
     end
    local pin_msg = data[tostring(chat)]['pin']
      if pin_msg then
  tdcli.pinChannelMessage(msg.to.id, pin_msg, 1)
       elseif not pin_msg then
   tdcli.unpinChannelMessage(msg.to.id)
          end
    if lang then
     tdcli.sendMessage(msg.to.id, msg.id, 0, '<b>User ID :</b> <code>'..msg.from.id..'</code>\n<b>Username :</b> '..('@'..msg.from.username or '<i>No Username</i>')..'\n<i>شما اجازه دسترسی به سنجاق پیام را ندارید، به همین دلیل پیام قبلی مجدد سنجاق میگردد</i>', 0, "html")
     elseif not lang then
    tdcli.sendMessage(msg.to.id, msg.id, 0, '<b>User ID :</b> <code>'..msg.from.id..'</code>\n<b>Username :</b> '..('@'..msg.from.username or '<i>No Username</i>')..'\n<i>You Have Not Permission To Pin Message, Last Message Has Been Pinned Again</i>', 0, "html")
          end
      end
  end
      if not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) then
if msg.edited and lock_edit == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
    end
  end
if msg.forward_info_ and mute_forward == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
    end
  end
if msg.photo_ and mute_photo == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.video_ and mute_video == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.document_ and mute_document == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.sticker_ and mute_sticker == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.animation_ and mute_gif == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.contact_ and mute_contact == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.location_ and mute_location == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.voice_ and mute_voice == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
   if msg.content_ and mute_keyboard == "mute" then
  if msg.reply_markup_ and  msg.reply_markup_.ID == "ReplyMarkupInlineKeyboard" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
      end
   end
end
    if tonumber(msg.via_bot_user_id_) ~= 0 and mute_inline == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.game_ and mute_game == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.audio_ and mute_audio == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
if msg.media.caption then
local link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.media.caption:match("[Tt].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
if link_caption
and lock_link == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
local tag_caption = msg.media.caption:match("#")
if tag_caption and lock_tag == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
local username_caption = msg.media.caption:match("@")
if username_caption and lock_username == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
local english_caption = msg.media.caption:match("[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]")
if english_caption and lock_english == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
if is_filter(msg, msg.media.caption) then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
      end
    end
local arabic_caption = msg.media.caption:match("[\216-\219][\128-\191]")
if arabic_caption and lock_arabic == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
      end
   end
end
if msg.text then
			local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
        local max_chars = 40
        if data[tostring(msg.to.id)] then
          if data[tostring(msg.to.id)]['settings']['set_char'] then
            max_chars = tonumber(data[tostring(msg.to.id)]['settings']['set_char'])
          end
        end
			 local _nl, real_digits = string.gsub(msg.text, '%d', '')
			local max_real_digits = tonumber(max_chars) * 50
			local max_len = tonumber(max_chars) * 51
			if lock_spam == "yes" then
			if string.len(msg.text) > max_len or ctrl_chars > max_chars or real_digits > max_real_digits then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
      end
   end
end
local link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.text:match("[Tt].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
if link_msg
and lock_link == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
local tag_msg = msg.text:match("#")
if tag_msg and lock_tag == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
local username_msg = msg.text:match("@")
if username_msg and lock_username == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
local english_msg = msg.text:match("[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]") 
if english_msg and lock_english == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
if is_filter(msg, msg.text) then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
      end
    end
local arabic_msg = msg.text:match("[\216-\219][\128-\191]")
if arabic_msg and lock_arabic == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
if msg.text:match("(.*)")
and mute_text == "mute" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
     end
   end
end
if msg.content_.entities_ and msg.content_.entities_[0] then
    if msg.content_.entities_[0].ID == "MessageEntityMentionName" then
      if lock_mention == "lock" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
             end
          end
      end
  if msg.content_.entities_[0].ID == "MessageEntityUrl" or msg.content_.entities_[0].ID == "MessageEntityTextUrl" then
      if lock_webpage == "lock" then
if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
             end
          end
      end
  if msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic" then
      if lock_markdown == "lock" then
if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
             end
          end
      end
 end
if msg.to.type ~= 'pv' then
  if lock_flood == "lock" then
    if is_mod(msg) and is_whitelist(msg.from.id, msg.to.id) then
    return
  end
  if msg.adduser or msg.joinuser then
    return
  end
    local hash = 'user:'..user..':msgs'
    local msgs = tonumber(redis:get(hash) or 0)
        local NUM_MSG_MAX = 5
        if data[tostring(chat)] then
          if data[tostring(chat)]['settings']['num_msg_max'] then
            NUM_MSG_MAX = tonumber(data[tostring(chat)]['settings']['num_msg_max'])
          end
        end
    if msgs > NUM_MSG_MAX then
   if msg.from.username then
      user_name = "@"..msg.from.username
         else
      user_name = msg.from.first_name
     end
if redis:get('sender:'..user..':flood') then
return
else
   del_msg(chat, msg.id)
    kick_user(user, chat)
	redis:del(hash)
   if not lang then
  tdcli.sendMessage(chat, msg.id, 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..user.."]`\n _нαѕ вєєη_ *кιcкєɗ* _вєcαυѕє σf_ *fƖσσɗιηg*", 0, "md")
   elseif lang then
  tdcli.sendMessage(chat, msg.id, 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..user.."]`\n *به دلیل ارسال پیام های مکرر اخراج شد*", 0, "md")
    end
redis:setex('sender:'..user..':flood', 30, true)
      end
    end
    redis:setex(hash, TIME_CHECK, msgs+1)
               end
           end
      end
   end
if checkmod and msg.text and msg.to.type == 'channel' then
	tdcli.getChannelMembers(msg.to.id, 0, 'Administrators', 200, function(a, b)
	local secchk = true
	checkmod = false
		for k,v in pairs(b.members_) do
			if v.user_id_ == tonumber(our_id) then
				secchk = false
			end
		end
		if secchk then
			checkmod = false
			if not lang then
				return tdcli.sendMessage(msg.to.id, 0, 1, '_Robot isn\'t Administrator, Please promote to Admin!_', 1, "md")
			else
				return tdcli.sendMessage(msg.to.id, 0, 1, '_لطفا برای کارکرد کامل دستورات، ربات را به مدیر گروه ارتقا دهید._', 1, "md")
			end
		end
	end, nil)
 end
	local function welcome_cb(arg, data)
	local url , res = http.request('http://probot.000webhostapp.com/api/time.php/')
          if res ~= 200 then return "No connection" end
      local jdat = json:decode(url)
		administration = load_data(_config.moderation.data)
    if administration[arg.chat_id]['setwelcome'] then
     welcome = administration[arg.chat_id]['setwelcome']
      else
     if not lang then
     welcome = "*Welcome Dude*"
    elseif lang then
     welcome = "_خوش آمدید_"
        end
     end
 if administration[tostring(arg.chat_id)]['rules'] then
rules = administration[arg.chat_id]['rules']
else
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@tel_fire"
    elseif lang then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n@tel_fire"
 end
end
if data.username_ then
user_name = "@"..check_markdown(data.username_)
else
user_name = ""
end
		local welcome = welcome:gsub("{rules}", rules)
		local welcome = welcome:gsub("{name}", check_markdown(data.first_name_..' '..(data.last_name_ or '')))
		local welcome = welcome:gsub("{username}", user_name)
		local welcome = welcome:gsub("{time}", jdat.ENtime)
		local welcome = welcome:gsub("{date}", jdat.ENdate)
		local welcome = welcome:gsub("{timefa}", jdat.FAtime)
		local welcome = welcome:gsub("{datefa}", jdat.FAdate)
		local welcome = welcome:gsub("{gpname}", arg.gp_name)
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, welcome, 0, "md")
	end
	if data[tostring(chat)] and data[tostring(chat)]['settings'] then
	if msg.adduser then
		welcome = data[tostring(msg.to.id)]['settings']['welcome']
		if welcome == "yes" then
			tdcli.getUser(msg.adduser, welcome_cb, {chat_id=chat,msg_id=msg.id_,gp_name=msg.to.title})
		else
			return false
		end
	end
	if msg.joinuser then
		welcome = data[tostring(msg.to.id)]['settings']['welcome']
		if welcome == "yes" then
			tdcli.getUser(msg.sender_user_id_, welcome_cb, {chat_id=chat,msg_id=msg.id_,gp_name=msg.to.title})
		else
			return false
        end
		end
	end
		if msg.to.type ~= 'pv' then
		local hash = "gp_lang:"..msg.to.id
		local lang = redis:get(hash)
		local data = load_data(_config.moderation.data)
		local gpst = data[tostring(msg.to.id)]
		local chex = redis:get('CheckExpire::'..msg.to.id)
		local exd = redis:get('ExpireDate:'..msg.to.id)
		if gpst and not chex and msg.from.id ~= SUDO and not is_sudo(msg) then
			redis:set('CheckExpire::'..msg.to.id,true)
			redis:set('ExpireDate:'..msg.to.id,true)
			redis:setex('ExpireDate:'..msg.to.id, 86400, true)
			if lang then
				tdcli.sendMessage(msg.to.id, msg.id_, 1, '_گروه به مدت 1 روز شارژ شد. لطفا با سودو برای شارژ بیشتر تماس بگیرید. در غیر اینصورت گروه شما از لیست ربات حذف و ربات گروه را ترک خواهد کرد._', 1, 'md')
			else
				tdcli.sendMessage(msg.to.id, msg.id_, 1, '`Ɠяσυρ cнαяgєɗ 1 ɗαу. тσ яєcнαяgє тнє яσвσт cσηтαcт ωιтн тнє ѕυɗσ. Ɯιтн тнє cσмρƖєтιση σf cнαяgιηg тιмє, тнє gяσυρ яємσνєɗ fяσм тнє яσвσт Ɩιѕт αηɗ тнє яσвσт ωιƖƖ Ɩєανє тнє gяσυρ.`', 1, 'md')
			end
		end
		if chex and not exd and msg.from.id ~= SUDO and not is_sudo(msg) then
			local text1 = 'شارژ این گروه به اتمام رسید \n\nID:  <code>'..msg.to.id..'</code>\n\nدر صورتی که میخواهید ربات این گروه را ترک کند از دستور زیر استفاده کنید\n\n/leave '..msg.to.id..'\nبرای جوین دادن توی این گروه میتونی از دستور زیر استفاده کنی:\n/jointo '..msg.to.id..'\n_________________\nدر صورتی که میخواهید گروه رو دوباره شارژ کنید میتوانید از کد های زیر استفاده کنید...\n\n<b>برای شارژ 1 ماهه:</b>\n/plan 1 '..msg.to.id..'\n\n<b>برای شارژ 3 ماهه:</b>\n/plan 2 '..msg.to.id..'\n\n<b>برای شارژ نامحدود:</b>\n/plan 3 '..msg.to.id
			local text2 = '_شارژ این گروه به پایان رسید. به دلیل عدم شارژ مجدد، گروه از لیست ربات حذف و ربات از گروه خارج میشود._'
			local text3 = '`Ƈнαяgιηg fιηιѕнєɗ.`\n\n*Ɠяσυρ IƊ:*\n\n*IƊ:* `'..msg.to.id..'`\n\n*If уσυ ωαηт тнє яσвσт тσ Ɩєανє тнιѕ gяσυρ υѕє тнє fσƖƖσωιηg cσммαηɗ:*\n\n`/Leave '..msg.to.id..'`\n\n*Ƒσя Jσιη тσ тнιѕ gяσυρ, уσυ cαη υѕє тнє fσƖƖσωιηg cσммαηɗ:*\n\n`/Jointo '..msg.to.id..'`\n\n_________________\n\n_If you want to recharge the group can use the following code:_\n\n*To charge 1 month:*\n\n`/Plan 1 '..msg.to.id..'`\n\n*To charge 3 months:*\n\n`/Plan 2 '..msg.to.id..'`\n\n*For unlimited charge:*\n\n`/Plan 3 '..msg.to.id..'`'
			local text4 = '`Ƈнαяgιηg fιηιѕнєɗ. Ɗυє тσ Ɩαcк σf яєcнαяgє яємσνє тнє gяσυρ fяσм тнє яσвσт Ɩιѕт αηɗ тнє яσвσт Ɩєανє тнє gяσυρ.`'
			if lang then
				tdcli.sendMessage(SUDO, 0, 1, text1, 1, 'html')
				tdcli.sendMessage(msg.to.id, 0, 1, text2, 1, 'md')
			else
				tdcli.sendMessage(SUDO, 0, 1, text3, 1, 'md')
				tdcli.sendMessage(msg.to.id, 0, 1, text4, 1, 'md')
			end
			botrem(msg)
		else
			local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
			local day = (expiretime / 86400)
			if tonumber(day) > 0.208 and not is_sudo(msg) and is_mod(msg) then
				warning(msg)
			end
		end
	end
	   if msg.to.type ~= 'pv' then
chat = msg.to.id
user = msg.from.id
	local function check_newmember(arg, data)
		test = load_data(_config.moderation.data)
		lock_bots = test[arg.chat_id]['settings']['lock_bots']
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    if data.type_.ID == "UserTypeBot" then
      if not is_owner(arg.msg) and lock_bots == 'yes' then
kick_user(data.id_, arg.chat_id)
end
end
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if is_banned(data.id_, arg.chat_id) then
   if not lang then
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _is banned_", 0, "md")
   else
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n_banned_", 0, "md")
end
kick_user(data.id_, arg.chat_id)
end
if is_gbanned(data.id_) then
     if not lang then
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, "✴️》*Uѕєя :* ["..user_name.."]\n🆔》*IƊ :* `["..data.id_.."]`\n _is globally banned_", 0, "md")
    else
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, "✴️》*کاربر :* ["..user_name.."]\n🆔》*ایدی :* `["..data.id_.."]`\n _از تمام گروه های ربات محروم است_", 0, "md")
   end
kick_user(data.id_, arg.chat_id)
     end
	end
	if msg.adduser then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.adduser
    	}, check_newmember, {chat_id=chat,msg_id=msg.id,user_id=user,msg=msg})
	end
	if msg.joinuser then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.joinuser
    	}, check_newmember, {chat_id=chat,msg_id=msg.id,user_id=user,msg=msg})
	   end
 if is_silent_user(msg.from.id, msg.to.id) then
 del_msg(msg.to.id, msg.id)
    return false
 end
 if is_banned(msg.from.id, msg.to.id) then
 del_msg(msg.to.id, tonumber(msg.id))
     kick_user(msg.from.id, msg.to.id)
    return false
    end
 if is_gbanned(msg.from.id) then
 del_msg(msg.to.id, tonumber(msg.id))
     kick_user(msg.from.id, msg.to.id)
    return false
   end
 end
	return msg
 end
----------------------------------------
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)
  if chat_id:match('^-100') then
    local channel_id = chat_id:gsub('-100', '')
    chat = {ID = channel_id, type = 'channel'}
  else
    local group_id = chat_id:gsub('-', '')
    chat = {ID = group_id, type = 'group'}
  end
  return chat
end
---------------Lock Link-------------------
local function lock_link(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "lock" then
if not lang then
 return "*>Lιηк* `Ƥσѕтιηg Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ارسال لینک در گروه هم اکنون ممنوع است ♻️⚠️ ♻️⚠️"
end
else
data[tostring(target)]["settings"]["lock_link"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Lιηк* `Ƥσѕтιηg Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "ارسال لینک در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_link(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "unlock" then
if not lang then
return "*>Lιηк* `Ƥσѕтιηg Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "ارسال لینک در گروه ممنوع نمیباشد ❌🔐 ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_link"] = "unlock" save_data(_config.moderation.data, data) 
if not lang then
return "*>Lιηк* `Ƥσѕтιηg Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "ارسال لینک در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "lock" then
if not lang then
 return "*Tag* `Ƥσѕтιηg Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ارسال تگ در گروه هم اکنون ممنوع است ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_tag"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Tag* `Ƥσѕтιηg Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "ارسال تگ در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_tag(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end 
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "unlock" then
if not lang then
return "*Tag* `Ƥσѕтιηg Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "ارسال تگ در گروه ممنوع نمیباشد ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_tag"] = "unlock" save_data(_config.moderation.data, data) 
if not lang then
return "*Tag* `Ƥσѕтιηg Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "ارسال تگ در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock Username-------------------
local function lock_username(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_username = data[tostring(target)]["settings"]["lock_username"] 
if lock_username == "lock" then
if not lang then
 return "*username* `Ƥσѕтιηg Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ارسال نام کاربری در گروه هم اکنون ممنوع است ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_username"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*username* `Ƥσѕтιηg Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "ارسال نام کاربری در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_username(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end 
end

local lock_tag = data[tostring(target)]["settings"]["lock_username"]
 if lock_username == "unlock" then
if not lang then
return "*username* `Ƥσѕтιηg Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "ارسال نام کاربری در گروه ممنوع نمیباشد ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_username"] = "unlock" save_data(_config.moderation.data, data) 
if not lang then
return "*username* `Ƥσѕтιηg Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "ارسال نام کاربری در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
 local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "lock" then
if not lang then
 return "*>Mєηтιση* `Ƥσѕтιηg Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ارسال فراخوانی افراد هم اکنون ممنوع است ♻️⚠️ ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_mention"] = "lock"
save_data(_config.moderation.data, data)
if not lang then 
 return "*>Mєηтιση* `Ƥσѕтιηg Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else 
 return "ارسال فراخوانی افراد در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_mention(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "unlock" then
if not lang then
return "*>Mєηтιση* `Ƥσѕтιηg Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "ارسال فراخوانی افراد در گروه ممنوع نمیباشد ❌🔐 ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_mention"] = "unlock" save_data(_config.moderation.data, data) 
if not lang then
return "*>Mєηтιση* `Ƥσѕтιηg Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "ارسال فراخوانی افراد در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "lock" then
if not lang then
 return "*>Aяαвιc/Ƥєяѕιαη* `Ƥσѕтιηg Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ارسال کلمات عربی/فارسی در گروه هم اکنون ممنوع است ♻️⚠️ ♻️⚠️"
end
else
data[tostring(target)]["settings"]["lock_arabic"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Aяαвιc/Ƥєяѕιαη* `Ƥσѕтιηg Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "ارسال کلمات عربی/فارسی در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "unlock" then
if not lang then
return "*>Aяαвιc/Ƥєяѕιαη* `Ƥσѕтιηg Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "ارسال کلمات عربی/فارسی در گروه ممنوع نمیباشد ❌🔐 ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_arabic"] = "unlock" save_data(_config.moderation.data, data) 
if not lang then
return "*>Aяαвιc/Ƥєяѕιαη* `Ƥσѕтιηg Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "ارسال کلمات عربی/فارسی در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock english--------------
local function lock_english(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_english = data[tostring(target)]["settings"]["lock_english"] 
if lock_english == "lock" then
if not lang then
 return "*english* `Ƥσѕтιηg Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ارسال کلمات انگلیسی در گروه هم اکنون ممنوع است ♻️⚠️ ♻️⚠️"
end
else
data[tostring(target)]["settings"]["lock_english"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*english* `Ƥσѕтιηg Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "ارسال کلمات انگلیسی در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_english(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_english = data[tostring(target)]["settings"]["lock_english"]
 if lock_english == "unlock" then
if not lang then
return "*english* `Ƥσѕтιηg Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "ارسال کلمات انگلیسی در گروه ممنوع نمیباشد ❌🔐 ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_english"] = "unlock" save_data(_config.moderation.data, data) 
if not lang then
return "*english* `Ƥσѕтιηg Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "ارسال کلمات انگلیسی در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "lock" then
if not lang then
 return "*>Ɛɗιтιηg* `Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ویرایش پیام هم اکنون ممنوع است ♻️⚠️ ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_edit"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Ɛɗιтιηg* `Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "ویرایش پیام در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_edit(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "unlock" then
if not lang then
return "*>Ɛɗιтιηg* `Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "ویرایش پیام در گروه ممنوع نمیباشد ❌🔐 ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_edit"] = "unlock" save_data(_config.moderation.data, data) 
if not lang then
return "*>Ɛɗιтιηg* `Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "ویرایش پیام در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "lock" then
if not lang then
 return "*>Sραм* `Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ارسال هرزنامه در گروه هم اکنون ممنوع است ♻️⚠️ ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_spam"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Sραм* `Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "ارسال هرزنامه در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_spam(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "unlock" then
if not lang then
return "*>Sραм* `Ƥσѕтιηg Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
 return "ارسال هرزنامه در گروه ممنوع نمیباشد ❌🔐 ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_spam"] = "unlock" 
save_data(_config.moderation.data, data)
if not lang then 
return "*>Sραм* `Ƥσѕтιηg Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
 return "ارسال هرزنامه در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_flood = data[tostring(target)]["settings"]["lock_flood"] 
if lock_flood == "lock" then
if not lang then
 return "*>ƑƖσσɗιηg* `Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ارسال پیام مکرر در گروه هم اکنون ممنوع است ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_flood"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*>ƑƖσσɗιηg* `Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "ارسال پیام مکرر در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_flood(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_flood = data[tostring(target)]["settings"]["lock_flood"]
 if lock_flood == "unlock" then
if not lang then
return "*>ƑƖσσɗιηg* `Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "ارسال پیام مکرر در گروه ممنوع نمیباشد ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_flood"] = "unlock" save_data(_config.moderation.data, data) 
if not lang then
return "*>ƑƖσσɗιηg* `Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "ارسال پیام مکرر در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "lock" then
if not lang then
 return "*>Ɓσтѕ* `Ƥяσтєcтιση Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "محافظت از گروه در برابر ربات ها هم اکنون فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_bots"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Ɓσтѕ* `Ƥяσтєcтιση Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖✅\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "محافظت از گروه در برابر ربات ها فعال شد 🤖✅\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_bots(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "unlock" then
if not lang then
return "*>Ɓσтѕ* `Ƥяσтєcтιση Iѕ Ɲσт ƐηαвƖєɗ` ❌🔐" 
elseif lang then
return "محافظت از گروه در برابر ربات ها غیر فعال است  ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_bots"] = "unlock" save_data(_config.moderation.data, data) 
if not lang then
return "*>Ɓσтѕ* `Ƥяσтєcтιση Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖❌\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "محافظت از گروه در برابر ربات ها غیر فعال شد 🤖❌\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock Join-------------------
local function lock_join(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_join = data[tostring(target)]["settings"]["lock_join"] 
if lock_join == "lock" then
if not lang then
 return "*>Lσcк Jσιη* `Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ورود به گروه هم اکنون ممنوع است ♻️⚠️ ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_join"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Lσcк Jσιη* `Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "ورود به گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_join(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local lock_join = data[tostring(target)]["settings"]["lock_join"]
 if lock_join == "unlock" then
if not lang then
return "*>Lσcк Jσιη* `Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "ورود به گروه ممنوع نمیباشد ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_join"] = "unlock"
save_data(_config.moderation.data, data) 
if not lang then
return "*>Lσcк Jσιη* `Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "ورود به گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "lock" then
if not lang then 
 return "*>Mαякɗσωη* `Ƥσѕтιηg Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ارسال پیام های دارای فونت در گروه هم اکنون ممنوع است ♻️⚠️ ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_markdown"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mαякɗσωη* `Ƥσѕтιηg Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "ارسال پیام های دارای فونت در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_markdown(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "unlock" then
if not lang then
return "*>Mαякɗσωη* `Ƥσѕтιηg Iѕ Ɲσт Lσcкєɗ` ❌🔐"
elseif lang then
return "ارسال پیام های دارای فونت در گروه ممنوع نمیباشد ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_markdown"] = "unlock" save_data(_config.moderation.data, data) 
if not lang then
return "*>Mαякɗσωη* `Ƥσѕтιηg Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
return "ارسال پیام های دارای فونت در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "lock" then
if not lang then
 return "*>Ɯєвραgє* `Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "ارسال صفحات وب در گروه هم اکنون ممنوع است ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_webpage"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Ɯєвραgє* `Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "ارسال صفحات وب در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_webpage(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "unlock" then
if not lang then
return "*>Ɯєвραgє* `Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "ارسال صفحات وب در گروه ممنوع نمیباشد ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_webpage"] = "unlock"
save_data(_config.moderation.data, data) 
if not lang then
return "*>Ɯєвραgє* `Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "ارسال صفحات وب در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

---------------Lock All-------------------
local function lock_all(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_all = data[tostring(target)]["settings"]["lock_all"] 
if lock_all == "lock" then
if not lang then
 return "*>AƖƖ ƖσƇк* `Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "تمامی تنظیمات قفل بودند! ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_all"] = "lock"
 data[tostring(target)]["settings"]["lock_pin"] = "lock"
 data[tostring(target)]["settings"]["lock_webpage"] = "lock"
 data[tostring(target)]["settings"]["lock_link"] = "lock"
 data[tostring(target)]["settings"]["lock_tag"] = "lock"
 data[tostring(target)]["settings"]["lock_username"] = "lock"
 data[tostring(target)]["settings"]["lock_mention"] = "lock"
 data[tostring(target)]["settings"]["lock_markdown"] = "lock"
 data[tostring(target)]["settings"]["lock_arabic"] = "lock"
 data[tostring(target)]["settings"]["lock_english"] = "lock"
 data[tostring(target)]["settings"]["lock_edit"] = "lock"
 data[tostring(target)]["settings"]["lock_spam"] = "lock"
 data[tostring(target)]["settings"]["lock_bots"] = "lock"
 data[tostring(target)]["settings"]["lock_flood"] = "lock"
 data[tostring(target)]["settings"]["lock_join"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*>AƖƖ ƖσƇк* `Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "تمامی تنظیمات قفل بود! 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_all(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local lock_all = data[tostring(target)]["settings"]["lock_all"]
 if lock_all == "unlock" then
if not lang then
return "*>AƖƖ ƖσƇк* `Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "تمامی تنظیمات قفل نیستند! ❌🔐"
end
else 
 data[tostring(target)]["settings"]["lock_all"] = "unlock"
 data[tostring(target)]["settings"]["lock_pin"] = "unlock"
 data[tostring(target)]["settings"]["lock_webpage"] = "unlock"
 data[tostring(target)]["settings"]["lock_link"] = "unlock"
 data[tostring(target)]["settings"]["lock_tag"] = "unlock"
 data[tostring(target)]["settings"]["lock_username"] = "unlock"
 data[tostring(target)]["settings"]["lock_mention"] = "unlock"
 data[tostring(target)]["settings"]["lock_markdown"] = "unlock"
 data[tostring(target)]["settings"]["lock_arabic"] = "unlock"
 data[tostring(target)]["settings"]["lock_english"] = "unlock"
 data[tostring(target)]["settings"]["lock_edit"] = "unlock"
 data[tostring(target)]["settings"]["lock_spam"] = "unlock"
 data[tostring(target)]["settings"]["lock_bots"] = "unlock"
 data[tostring(target)]["settings"]["lock_flood"] = "unlock"
 data[tostring(target)]["settings"]["lock_join"] = "unlock"
save_data(_config.moderation.data, data) 
if not lang then
return "*>AƖƖ ƖσƇк* `Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "تمامی تنظیمات آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]ند!"
end
end
end

---------------Lock Pin-------------------
local function lock_pin(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "lock" then
if not lang then
 return "*>Ƥιηηєɗ Mєѕѕαgє* `Iѕ AƖяєαɗу Lσcкєɗ` ♻️⚠️"
elseif lang then
 return "سنجاق کردن پیام در گروه هم اکنون ممنوع است ♻️⚠️"
end
else
 data[tostring(target)]["settings"]["lock_pin"] = "lock"
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Ƥιηηєɗ Mєѕѕαgє* `Hαѕ Ɓєєη Lσcкєɗ` 🤖🔒\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "سنجاق کردن پیام در گروه ممنوع شد 🤖🔒\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unlock_pin(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
 if lock_pin == "unlock" then
if not lang then
return "*>Ƥιηηєɗ Mєѕѕαgє* `Iѕ Ɲσт Lσcкєɗ` ❌🔐" 
elseif lang then
return "سنجاق کردن پیام در گروه ممنوع نمیباشد ❌🔐"
end
else 
data[tostring(target)]["settings"]["lock_pin"] = "unlock"
save_data(_config.moderation.data, data) 
if not lang then
return "*>Ƥιηηєɗ Mєѕѕαgє* `Hαѕ Ɓєєη UηƖσcкєɗ` 🤖🔓\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "سنجاق کردن پیام در گروه آزاد شد 🤖🔓\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
--------Mutes---------
---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "mute" then
if not lang then
 return "*>Mυтє Ɠιf* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن تصاویر متحرک فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_gif"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then 
 return "*>Mυтє Ɠιf* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن تصاویر متحرک فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_gif(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "unmute" then
if not lang then
return "*>Mυтє Ɠιf* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐" 
elseif lang then
return "بیصدا کردن تصاویر متحرک غیر فعال بود ❌🔐"
end
else 
data[tostring(target)]["mutes"]["mute_gif"] = "unmute"
 save_data(_config.moderation.data, data) 
if not lang then
return "*>Mυтє Ɠιf* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "بیصدا کردن تصاویر متحرک غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"] 
if mute_game == "mute" then
if not lang then
 return "*>Mυтє Ɠαмє* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن بازی های تحت وب فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_game"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє Ɠαмє* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن بازی های تحت وب فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_game(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"]
 if mute_game == "unmute" then
if not lang then
return "*>Mυтє Ɠαмє* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐" 
elseif lang then
return "بیصدا کردن بازی های تحت وب غیر فعال است  ♻️⚠️"
end
else 
data[tostring(target)]["mutes"]["mute_game"] = "unmute"
 save_data(_config.moderation.data, data)
if not lang then 
return "*>Mυтє Ɠαмє* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "بیصدا کردن بازی های تحت وب غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"] 
if mute_inline == "mute" then
if not lang then
 return "*>Mυтє IηƖιηє* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن کیبورد شیشه ای فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_inline"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє IηƖιηє* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن کیبورد شیشه ای فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_inline(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"]
 if mute_inline == "unmute" then
if not lang then
return "*>Mυтє IηƖιηє* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐" 
elseif lang then
return "بیصدا کردن کیبورد شیشه ای غیر فعال است  ♻️⚠️"
end
else 
data[tostring(target)]["mutes"]["mute_inline"] = "unmute"
 save_data(_config.moderation.data, data) 
if not lang then
return "*>Mυтє IηƖιηє* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "بیصدا کردن کیبورد شیشه ای غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "mute" then
if not lang then
 return "*>Mυтє Ƭєxт* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن متن فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_text"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє Ƭєxт* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن متن فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_text(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "unmute" then
if not lang then
return "*>Mυтє Ƭєxт* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐"
elseif lang then
return "بیصدا کردن متن غیر فعال است  ♻️⚠️" 
end
else 
data[tostring(target)]["mutes"]["mute_text"] = "unmute"
 save_data(_config.moderation.data, data) 
if not lang then
return "*>Mυтє Ƭєxт* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "بیصدا کردن متن غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "mute" then
if not lang then
 return "*>Mυтє Ƥнσтσ* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن عکس فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_photo"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє Ƥнσтσ* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن عکس فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_photo(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end
 
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "unmute" then
if not lang then
return "*>Mυтє Ƥнσтσ* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐" 
elseif lang then
return "بیصدا کردن عکس غیر فعال است  ♻️⚠️"
end
else 
data[tostring(target)]["mutes"]["mute_photo"] = "unmute"
 save_data(_config.moderation.data, data) 
if not lang then
return "*>Mυтє Ƥнσтσ* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "بیصدا کردن عکس غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "mute" then
if not lang then
 return "*>Mυтє Ʋιɗєσ* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن فیلم فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_video"] = "mute" 
save_data(_config.moderation.data, data)
if not lang then 
 return "*>Mυтє Ʋιɗєσ* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن فیلم فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_video(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "unmute" then
if not lang then
return "*>Mυтє Ʋιɗєσ* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐" 
elseif lang then
return "بیصدا کردن فیلم غیر فعال است  ♻️⚠️"
end
else 
data[tostring(target)]["mutes"]["mute_video"] = "unmute"
 save_data(_config.moderation.data, data) 
if not lang then
return "*>Mυтє Ʋιɗєσ* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "بیصدا کردن فیلم غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "mute" then
if not lang then
 return "*>Mυтє Aυɗισ* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن آهنگ فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_audio"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє Aυɗισ* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else 
return "بیصدا کردن آهنگ فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_audio(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "unmute" then
if not lang then
return "*>Mυтє Aυɗισ* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐" 
elseif lang then
return "بیصدا کردن آهنک غیر فعال است  ♻️⚠️"
end
else 
data[tostring(target)]["mutes"]["mute_audio"] = "unmute"
 save_data(_config.moderation.data, data)
if not lang then 
return "*>Mυтє Aυɗισ* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
return "بیصدا کردن آهنگ غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
end
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "mute" then
if not lang then
 return "*>Mυтє Ʋσιcє* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن صدا فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_voice"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє Ʋσιcє* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن صدا فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_voice(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "unmute" then
if not lang then
return "*>Mυтє Ʋσιcє* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐" 
elseif lang then
return "بیصدا کردن صدا غیر فعال است  ♻️⚠️"
end
else 
data[tostring(target)]["mutes"]["mute_voice"] = "unmute"
 save_data(_config.moderation.data, data)
if not lang then 
return "*>Mυтє Ʋσιcє* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "بیصدا کردن صدا غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "mute" then
if not lang then
 return "*>Mυтє Sтιcкєя* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن برچسب فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє Sтιcкєя* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن برچسب فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_sticker(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "unmute" then
if not lang then
return "*>Mυтє Sтιcкєя* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐" 
elseif lang then
return "بیصدا کردن برچسب غیر فعال است  ♻️⚠️"
end
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "unmute"
 save_data(_config.moderation.data, data)
if not lang then 
return "*>Mυтє Sticker* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
return "بیصدا کردن برچسب غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "mute" then
if not lang then
 return "*>Mυтє Ƈσηтαcт* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن مخاطب فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_contact"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє Ƈσηтαcт* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن مخاطب فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_contact(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "unmute" then
if not lang then
return "*>Mυтє Ƈσηтαcт* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐" 
elseif lang then
return "بیصدا کردن مخاطب غیر فعال است  ♻️⚠️"
end
else 
data[tostring(target)]["mutes"]["mute_contact"] = "unmute"
 save_data(_config.moderation.data, data) 
if not lang then
return "*>Mυтє Ƈσηтαcт* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "بیصدا کردن مخاطب غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "mute" then
if not lang then
 return "*>Mυтє Ƒσяωαяɗ* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن نقل قول فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_forward"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє Ƒσяωαяɗ* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن نقل قول فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_forward(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "unmute" then
if not lang then
return "*>Mυтє Ƒσяωαяɗ* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐"
elseif lang then
return "بیصدا کردن نقل قول غیر فعال است  ♻️⚠️"
end 
else 
data[tostring(target)]["mutes"]["mute_forward"] = "unmute"
 save_data(_config.moderation.data, data)
if not lang then 
return "*>Mυтє Ƒσяωαяɗ* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "بیصدا کردن نقل قول غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "mute" then
if not lang then
 return "*>Mυтє Lσcαтιση* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن موقعیت فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_location"] = "mute" 
save_data(_config.moderation.data, data)
if not lang then
 return "*>Mυтє Lσcαтιση* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن موقعیت فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_location(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "unmute" then
if not lang then
return "*>Mυтє Lσcαтιση* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐" 
elseif lang then
return "بیصدا کردن موقعیت غیر فعال است  ♻️⚠️"
end
else 
data[tostring(target)]["mutes"]["mute_location"] = "unmute"
 save_data(_config.moderation.data, data) 
if not lang then
return "*>Mυтє Lσcαтιση* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "بیصدا کردن موقعیت غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end

local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "mute" then
if not lang then
 return "*>Mυтє Dᴏᴄᴜᴍᴇɴᴛ* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن اسناد فعال لست"
end
else
 data[tostring(target)]["mutes"]["mute_document"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє Dᴏᴄᴜᴍᴇɴᴛ* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
 return "بیصدا کردن اسناد فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_document(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "unmute" then
if not lang then
return "*>Mυтє Dᴏᴄᴜᴍᴇɴᴛ* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐" 
elseif lang then
return "بیصدا کردن اسناد غیر فعال است  ♻️⚠️"
end
else 
data[tostring(target)]["mutes"]["mute_document"] = "unmute"
 save_data(_config.moderation.data, data) 
if not lang then
return "*>Mυтє Dᴏᴄᴜᴍᴇɴᴛ* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]" 
else
return "بیصدا کردن اسناد غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "mute" then
if not lang then
 return "*>Mυтє ƬgSєяνιcє* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن خدمات تلگرام فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє ƬgSєяνιcє* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
return "بیصدا کردن خدمات تلگرام فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_tgservice(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نیستید"
end 
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "unmute" then
if not lang then
return "*>Mυтє ƬgSєяνιcє* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐"
elseif lang then
return "بیصدا کردن خدمات تلگرام غیر فعال است  ♻️⚠️"
end 
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "unmute"
 save_data(_config.moderation.data, data) 
if not lang then
return "*>Mυтє ƬgSєяνιcє* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
return "بیصدا کردن خدمات تلگرام غیر فعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end 
end
end

---------------Mute Keyboard-------------------
local function mute_keyboard(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_keyboard = data[tostring(target)]["mutes"]["mute_keyboard"] 
if mute_keyboard == "mute" then
if not lang then
 return "*>Mυтє Ƙєувσαяɗ* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
elseif lang then
 return "بیصدا کردن صفحه کلید فعال است  ♻️⚠️"
end
else
 data[tostring(target)]["mutes"]["mute_keyboard"] = "mute" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*>Mυтє Ƙєувσαяɗ* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
return "بیصدا کردن صفحه کلید فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end

local function unmute_keyboard(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نیستید"
end 
end

local mute_keyboard = data[tostring(target)]["mutes"]["mute_keyboard"]
 if mute_keyboard == "unmute" then
if not lang then
return "*>Mυтє Ƙєувσαяɗ* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐"
elseif lang then
return "بیصدا کردن صفحه کلید غیرفعال است  ♻️⚠️"
end 
else 
data[tostring(target)]["mutes"]["mute_keyboard"] = "unmute"
 save_data(_config.moderation.data, data) 
if not lang then
return "*>Mυтє Ƙєувσαяɗ* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
else
return "بیصدا کردن صفحه کلید غیرفعال شد 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end 
end
end
----------------------------------------
function group_settings(msg, target) 	
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "_You're Not_ *Moderator*"
else
  return "شما مدیر گروه نمیباشید"
end
end
local data = load_data(_config.moderation.data)
local target = msg.to.id 
if data[tostring(target)] then 	
if data[tostring(target)]["settings"]["num_msg_max"] then 	
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
	print('custom'..NUM_MSG_MAX) 	
else 	
NUM_MSG_MAX = 5
end
if data[tostring(target)]["settings"]["set_char"] then 	
SETCHAR = tonumber(data[tostring(target)]['settings']['set_char'])
	print('custom'..SETCHAR) 	
else 	
SETCHAR = 40
end
if data[tostring(target)]["settings"]["time_check"] then 	
TIME_CHECK = tonumber(data[tostring(target)]['settings']['time_check'])
	print('custom'..TIME_CHECK) 	
else 	
TIME_CHECK = 2
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_link"] then			
data[tostring(target)]["settings"]["lock_link"] = "lock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tag"] then			
data[tostring(target)]["settings"]["lock_tag"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_username"] then			
data[tostring(target)]["settings"]["lock_username"] = "lock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_mention"] then			
data[tostring(target)]["settings"]["lock_mention"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_arabic"] then			
data[tostring(target)]["settings"]["lock_arabic"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_english"] then			
data[tostring(target)]["settings"]["lock_english"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_edit"] then			
data[tostring(target)]["settings"]["lock_edit"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_spam"] then			
data[tostring(target)]["settings"]["lock_spam"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_flood"] then			
data[tostring(target)]["settings"]["lock_flood"] = "lock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_bots"] then			
data[tostring(target)]["settings"]["lock_bots"] = "lock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_markdown"] then			
data[tostring(target)]["settings"]["lock_markdown"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_webpage"] then			
data[tostring(target)]["settings"]["lock_webpage"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["welcome"] then			
data[tostring(target)]["settings"]["welcome"] = "no"		
end
end

 if data[tostring(target)]["settings"] then		
 if not data[tostring(target)]["settings"]["lock_pin"] then			
 data[tostring(target)]["settings"]["lock_pin"] = "unlock"		
 end
 end

 if data[tostring(target)]["settings"] then		
 if not data[tostring(target)]["settings"]["lock_all"] then			
 data[tostring(target)]["settings"]["lock_all"] = "unlock"		
 end
 end
if data[tostring(target)]["settings"] then		
 if not data[tostring(target)]["settings"]["lock_join"] then			
 data[tostring(target)]["settings"]["lock_join"] = "unlock"		
 end
 end
 if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_gif"] then			
data[tostring(target)]["mutes"]["mute_gif"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_text"] then			
data[tostring(target)]["mutes"]["mute_text"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_photo"] then			
data[tostring(target)]["mutes"]["mute_photo"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_video"] then			
data[tostring(target)]["mutes"]["mute_video"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_audio"] then			
data[tostring(target)]["mutes"]["mute_audio"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_voice"] then			
data[tostring(target)]["mutes"]["mute_voice"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_sticker"] then			
data[tostring(target)]["mutes"]["mute_sticker"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_contact"] then			
data[tostring(target)]["mutes"]["mute_contact"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_forward"] then			
data[tostring(target)]["mutes"]["mute_forward"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_location"] then			
data[tostring(target)]["mutes"]["mute_location"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_document"] then			
data[tostring(target)]["mutes"]["mute_document"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_tgservice"] then			
data[tostring(target)]["mutes"]["mute_tgservice"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_inline"] then			
data[tostring(target)]["mutes"]["mute_inline"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_game"] then			
data[tostring(target)]["mutes"]["mute_game"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_keyboard"] then			
data[tostring(target)]["mutes"]["mute_keyboard"] = "unmute"		
end
end

local hash = "muteall:"..msg.to.id
local check_time = redis:ttl(hash)
day = math.floor(check_time / 86400)
MRay = check_time % 86400
hours = math.floor( MRay / 3600)
bhours = MRay % 3600
min = math.floor(bhours / 60)
sec = math.floor(bhours % 60)
if not lang then
if not redis:get(hash) or check_time == -1 then
 mute_all1 = 'n time'
elseif tonumber(check_time) > 1 and check_time < 60 then
 mute_all1 = '_enable for_ *'..sec..'* _sec_'
elseif tonumber(check_time) > 60 and check_time < 3600 then
 mute_all1 = '_enable for_ '..min..' _min_ *'..sec..'* _sec_'
elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
 mute_all1 = '_enable for_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
elseif tonumber(check_time) > 86400 then
 mute_all1 = '_enable for_ *'..day..'* _day_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
 end
elseif lang then
if not redis:get(hash) or check_time == -1 then
 mute_all2 = 'n time'
elseif tonumber(check_time) > 1 and check_time < 60 then
 mute_all2 = '_فعال برای_ *'..sec..'* _ثانیه_'
elseif tonumber(check_time) > 60 and check_time < 3600 then
 mute_all2 = '_فعال برای_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه_'
elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
 mute_all2 = '_فعال برای_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه_'
elseif tonumber(check_time) > 86400 then
 mute_all2 = '_فعال برای_ *'..day..'* _روز و_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه_'
 end
end

 local expire_date = ''
local expi = redis:ttl('ExpireDate:'..msg.to.id)
if expi == -1 then
if lang then
	expire_date = 'نامحدود!'
else
	expire_date = 'Unlimited!'
end
else
	local day = math.floor(expi / 86400) + 1
if lang then
	expire_date = day..' روز'
else
	expire_date = day..' Days'
end
end
local cmdss = redis:hget('group:'..msg.to.id..':cmd', 'bot')
	local cmdsss = ''
	if lang then
	if cmdss == 'owner' then
	cmdsss = cmdsss..'اونر و بالاتر'
	elseif cmdss == 'moderator' then
	cmdsss = cmdsss..'مدیر و بالاتر'
	else
	cmdsss = cmdsss..'کاربر و بالاتر'
	end
	else
	if cmdss == 'owner' then
	cmdsss = cmdsss..'Owner or higher'
	elseif cmdss == 'moderator' then
	cmdsss = cmdsss..'Moderator or higher'
	else
	cmdsss = cmdsss..'Member or higher'
	end
	end
if not lang then
local settings = data[tostring(target)]["settings"]
local mutes = data[tostring(target)]["mutes"]
text ="*MαƬαƊσR SєƬƬιηgѕ :*\n\n🔐 *ƓяσUρ* #Lσcк *Lιѕт :*\n\n*>Ɛɗιт :* "..settings.lock_edit.."\n*>Lιηк :* "..settings.lock_link.."\n*>Uѕєяηαмє :* "..settings.lock_username.."\n*>Ƭαg :* "..settings.lock_tag.."\n*>Jσιη :* "..settings.lock_join.."\n*>Spam :* "..settings.lock_spam.."\n*>ƑƖσσɗ :* "..settings.lock_flood.."\n*>Mєηтιση :* "..settings.lock_mention.."\n*>Ɯєвραgє :* "..settings.lock_webpage.."\n*>Aяαвιc :* "..settings.lock_arabic.."\n*>ƐηgƖιѕн :* "..settings.lock_english.."\n*>Mαякɗσωη :* "..settings.lock_markdown.."\n*>Ƥιη Mєѕѕαgє :* "..settings.lock_pin.."\n\n*=============*\n🔇 *ƓяσUρ* #MυƬє *Lιѕт :*\n\n*>Mυтє Ƭιмє :* "..mute_all1.."\n*>Ɠιf :* "..mutes.mute_gif.."\n*>Ƭєxт :* "..mutes.mute_text.."\n*>IηƖιηє :* "..mutes.mute_inline.."\n*>Ɠαмє :* "..mutes.mute_game.."\n*>Ƥнσтσ :* "..mutes.mute_photo.."\n*>Ʋιɗєσ :* "..mutes.mute_video.."\n*>Aυɗισ :* "..mutes.mute_audio.."\n*>Ʋσιcє :* "..mutes.mute_voice.."\n*>Sтιcкєя :* "..mutes.mute_sticker.."\n*>Ƈσηтαcт :* "..mutes.mute_contact.."\n*>Ƒσяωαяɗ :* "..mutes.mute_forward.."\n*>Lσcαтιση :* "..mutes.mute_location.."\n*>Ɗσcυмєηт :* "..mutes.mute_document.."\n*>ƬƓѕєяνιcє :* "..mutes.mute_tgservice.."\n*>ƘєуƁσαяɗ :* "..mutes.mute_keyboard.."\n\n*=============*\n💠 *ƓяσUρ* #OƬнƐя *SєттιηƓѕ :*\n\n*>Ɠяσυρ ƜєƖcσмє :* "..settings.welcome.."\n*>Ɓσтѕ Ƥяσтєcтιση :* "..settings.lock_bots.."\n*>ƑƖσσɗ Sєηѕιтινιту :* `"..NUM_MSG_MAX.."`\n*>ƑƖσσɗ Ƈнєcк Ƭιмє :* `"..TIME_CHECK.."`\n*>Ƈнαяαcтєя Sєηѕιтινιту :* `"..SETCHAR.."`\n*>Ɓσтѕ Ƈσммαηɗѕ :* "..cmdsss.."\n*>Ɛxριяє Ɗαтє :* `"..expire_date.."`\n\n*=============*\n🌐 *IηfσRмαƬιση :*\n\n*>Ɠяσυρ Ɲαмє :* "..msg.to.title.."\n*>Ɠяσυρ IƊ :* `"..msg.to.id.."`\n*>Ƴσυя Ɲαмє :* "..(check_markdown(msg.from.first_name) or "No ɳαɱҽ").."\n*>Ƴσυя IƊ :* `"..msg.from.id.."`\n*>Uѕєяηαмє :* @"..check_markdown(msg.from.username or "").."\n\n*=============*\n*>ƇнαηηєƖ :* @tel_fire\n*>Ƥσωєяєɗ Ɓу :* @tel_fire\n*>Ɠяσυρ Lαηgυαgє :* Eɴ"
else
local settings = data[tostring(target)]["settings"]
local mutes = data[tostring(target)]["mutes"] 
 text ="*̶M̶α̶Ƭ̶α̶Ɗ̶σ̶R̶ ̶Ɓ̶σ̶Ƭ :*\n*_______________*\n`🔐 لیـــست قفلــی گروه :`\n●*》قفـل ویرایش :* "..settings.lock_edit.."\n○*》قفـل لینڪ :* "..settings.lock_link.."\n●*》قفـل یوزرنیم :* "..settings.lock_username.."\n●*》قفل هشتگ :* "..settings.lock_tag.."\n○*》قفـل ورود :* "..settings.lock_join.."\n○*》قفـل اسپم :* "..settings.lock_spam.."\n●*》قفـل فلود :* "..settings.lock_flood.."\n●*》قفـل فراخوانی  :* "..settings.lock_mention.."\n○*》قفـل وب :* "..settings.lock_webpage.."\n●*》قفـل عربی :* "..settings.lock_arabic.."\n●*》قفل انگلیسی :* "..settings.lock_english.."\n○*》قفـل فونت :* "..settings.lock_markdown.."\n●*》فـل سنجاق :* "..settings.lock_pin.."\n*_______________*\n`🔇 لیـــست ّبیصــدا گروه :`\n●*》بیصدا زمان دار :* "..mute_all2.."\n○*》بیصدا گیف :* "..mutes.mute_gif.."\n●*》بیصدا متن :* "..mutes.mute_text.."\n○*》بیصدا اینلاین :* "..mutes.mute_inline.."\n●*》بیصدا بازی:* "..mutes.mute_game.."\n○*》بیصدا عکس :* "..mutes.mute_photo.."\n●*》بیصدا فیلم :* "..mutes.mute_video.."\n○*》بیصدا اهنگ :* "..mutes.mute_audio.."\n●*》بیصدا ویس:* "..mutes.mute_voice.."\n○*》بیصدا استیکر :* "..mutes.mute_sticker.."\n●*》بیصدا ارسال مخاطب :* "..mutes.mute_contact.."\n○*》بیصدا نقل و قول :* "..mutes.mute_forward.."\n●*》بیصدا مکان :* "..mutes.mute_location.."\n○*》بیصدا فایل :* "..mutes.mute_document.."\n●*》بیصدا ورود و خروج :* "..mutes.mute_tgservice.."\n○*》بیصدا کیبورد :* "..mutes.mute_keyboard.."\n*_______________*\n`💠 لیســـت تنظیمات دیگر :`\n●*》وضعیت ولکام :* "..settings.welcome.."\n○*》محافظت گروه در برابر ربات :* "..settings.lock_bots.."\n●*》حداکثر پیام مکرر:* `"..NUM_MSG_MAX.."`\n○*》زمان برسی پیام مکرر:* `"..TIME_CHECK.."`\n●*》حداکثر کارکتر مجاز :* `"..SETCHAR.."`\n○*》دستورات ربات :* "..cmdsss.."\n●*》تـاریخ انقضـا :* `"..expire_date.."`\n*_______________*\n`🌐 اطلـاعاتــ :`\n⚜*》نـام گـروه :* "..msg.to.title.."\n⚜*》ایـدی گـروه :* `"..msg.to.id.."`\n⚜*》نـام شمـا :* "..(check_markdown(msg.from.first_name) or 'No ɳαɱҽ').."\n⚜*》ایـدی شمـا :* `"..msg.from.id.."`\n⚜*》شنـاسه شمـا :* @"..(check_markdown(msg.from.username or 'No υʂҽɾɳαɱҽ')).."\n*_______________*\n*کــانال :* @tel_fire\n*برنامه نویــس :* @tel_fire\n*زبان گــروه :* `فارسی`"
end
if not lang then
text = string.gsub(text, "yes", "`Enable ✅`")
text = string.gsub(text, "no", "`Disabled ❌`")
text = string.gsub(text, "unlock", "`UnLock 🔓`")
text = string.gsub(text, "unmute", "`UnMute 🔊`")
text = string.gsub(text, "lock", "`Lock 🔐`")
text = string.gsub(text, "mute", "`Mute 🔇`")
 else
text = string.gsub(text, "yes", "#فعال ✅")
text = string.gsub(text, "no", "#غیرفعال ❌")
text = string.gsub(text, "unlock", "#قفل باز 🔓")
text = string.gsub(text, "unmute", "#باصدا 🔊")
text = string.gsub(text, "lock", "#قفل 🔐")
text = string.gsub(text, "mute", "#بیصدا 🔇")
 end
return text
end
----------------------------------------
function group_option(msg, target) 	
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "_You're Not_ *Moderator*"
else
  return "شما مدیر گروه نمیباشید"
end
end
local data = load_data(_config.moderation.data)
local target = msg.to.id 
if data[tostring(target)] then 	
if data[tostring(target)]["settings"]["num_msg_max"] then 	
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
	print('custom'..NUM_MSG_MAX) 	
else 	
NUM_MSG_MAX = 5
end
if data[tostring(target)]["settings"]["set_char"] then 	
SETCHAR = tonumber(data[tostring(target)]['settings']['set_char'])
	print('custom'..SETCHAR) 	
else 	
SETCHAR = 40
end
if data[tostring(target)]["settings"]["time_check"] then 	
TIME_CHECK = tonumber(data[tostring(target)]['settings']['time_check'])
	print('custom'..TIME_CHECK) 	
else 	
TIME_CHECK = 2
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_link"] then			
data[tostring(target)]["settings"]["lock_link"] = "lock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tag"] then			
data[tostring(target)]["settings"]["lock_tag"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_username"] then			
data[tostring(target)]["settings"]["lock_username"] = "lock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_mention"] then			
data[tostring(target)]["settings"]["lock_mention"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_arabic"] then			
data[tostring(target)]["settings"]["lock_arabic"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_english"] then			
data[tostring(target)]["settings"]["lock_english"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_edit"] then			
data[tostring(target)]["settings"]["lock_edit"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_spam"] then			
data[tostring(target)]["settings"]["lock_spam"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_flood"] then			
data[tostring(target)]["settings"]["lock_flood"] = "lock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_bots"] then			
data[tostring(target)]["settings"]["lock_bots"] = "lock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_markdown"] then			
data[tostring(target)]["settings"]["lock_markdown"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_webpage"] then			
data[tostring(target)]["settings"]["lock_webpage"] = "unlock"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["welcome"] then			
data[tostring(target)]["settings"]["welcome"] = "no"		
end
end

 if data[tostring(target)]["settings"] then		
 if not data[tostring(target)]["settings"]["lock_pin"] then			
 data[tostring(target)]["settings"]["lock_pin"] = "unlock"		
 end
 end

 if data[tostring(target)]["settings"] then		
 if not data[tostring(target)]["settings"]["lock_all"] then			
 data[tostring(target)]["settings"]["lock_all"] = "unlock"		
 end
 end
if data[tostring(target)]["settings"] then		
 if not data[tostring(target)]["settings"]["lock_join"] then			
 data[tostring(target)]["settings"]["lock_join"] = "unlock"		
 end
 end
 if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_gif"] then			
data[tostring(target)]["mutes"]["mute_gif"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_text"] then			
data[tostring(target)]["mutes"]["mute_text"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_photo"] then			
data[tostring(target)]["mutes"]["mute_photo"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_video"] then			
data[tostring(target)]["mutes"]["mute_video"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_audio"] then			
data[tostring(target)]["mutes"]["mute_audio"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_voice"] then			
data[tostring(target)]["mutes"]["mute_voice"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_sticker"] then			
data[tostring(target)]["mutes"]["mute_sticker"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_contact"] then			
data[tostring(target)]["mutes"]["mute_contact"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_forward"] then			
data[tostring(target)]["mutes"]["mute_forward"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_location"] then			
data[tostring(target)]["mutes"]["mute_location"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_document"] then			
data[tostring(target)]["mutes"]["mute_document"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_tgservice"] then			
data[tostring(target)]["mutes"]["mute_tgservice"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_inline"] then			
data[tostring(target)]["mutes"]["mute_inline"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_game"] then			
data[tostring(target)]["mutes"]["mute_game"] = "unmute"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_keyboard"] then			
data[tostring(target)]["mutes"]["mute_keyboard"] = "unmute"		
end
end

local hash = "muteall:"..msg.to.id
local check_time = redis:ttl(hash)
day = math.floor(check_time / 86400)
MRay = check_time % 86400
hours = math.floor( MRay / 3600)
bhours = MRay % 3600
min = math.floor(bhours / 60)
sec = math.floor(bhours % 60)
if not lang then
if not redis:get(hash) or check_time == -1 then
 mute_all1 = 'n time'
elseif tonumber(check_time) > 1 and check_time < 60 then
 mute_all1 = '_enable for_ *'..sec..'* _sec_'
elseif tonumber(check_time) > 60 and check_time < 3600 then
 mute_all1 = '_enable for_ '..min..' _min_ *'..sec..'* _sec_'
elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
 mute_all1 = '_enable for_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
elseif tonumber(check_time) > 86400 then
 mute_all1 = '_enable for_ *'..day..'* _day_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
 end
elseif lang then
if not redis:get(hash) or check_time == -1 then
 mute_all2 = 'n time'
elseif tonumber(check_time) > 1 and check_time < 60 then
 mute_all2 = '_فعال برای_ *'..sec..'* _ثانیه_'
elseif tonumber(check_time) > 60 and check_time < 3600 then
 mute_all2 = '_فعال برای_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه_'
elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
 mute_all2 = '_فعال برای_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه_'
elseif tonumber(check_time) > 86400 then
 mute_all2 = '_فعال برای_ *'..day..'* _روز و_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه_'
 end
end

 local expire_date = ''
local expi = redis:ttl('ExpireDate:'..msg.to.id)
if expi == -1 then
if lang then
	expire_date = 'نامحدود!'
else
	expire_date = 'Unlimited!'
end
else
	local day = math.floor(expi / 86400) + 1
if lang then
	expire_date = day..' روز'
else
	expire_date = day..' Days'
end
end
local cmdss = redis:hget('group:'..msg.to.id..':cmd', 'bot')
	local cmdsss = ''
	if lang then
	if cmdss == 'owner' then
	cmdsss = cmdsss..'اونر و بالاتر'
	elseif cmdss == 'moderator' then
	cmdsss = cmdsss..'مدیر و بالاتر'
	else
	cmdsss = cmdsss..'کاربر و بالاتر'
	end
	else
	if cmdss == 'owner' then
	cmdsss = cmdsss..'Owner or higher'
	elseif cmdss == 'moderator' then
	cmdsss = cmdsss..'Moderator or higher'
	else
	cmdsss = cmdsss..'Member or higher'
	end
	end
if not lang then
local settings = data[tostring(target)]["settings"]
local mutes = data[tostring(target)]["mutes"]
text ="*MαƬαƊσR SєƬƬιηgѕ :*\n\n🔐 *ƓяσUρ* #Lσcк *Lιѕт :*\n\n*>Ɛɗιт :* "..settings.lock_edit.."\n*>Lιηк :* "..settings.lock_link.."\n*>Uѕєяηαмє :* "..settings.lock_username.."\n*>Ƭαg :* "..settings.lock_tag.."\n*>Jσιη :* "..settings.lock_join.."\n*>Spam :* "..settings.lock_spam.."\n*>ƑƖσσɗ :* "..settings.lock_flood.."\n*>Mєηтιση :* "..settings.lock_mention.."\n*>Ɯєвραgє :* "..settings.lock_webpage.."\n*>Aяαвιc :* "..settings.lock_arabic.."\n*>ƐηgƖιѕн :* "..settings.lock_english.."\n*>Mαякɗσωη :* "..settings.lock_markdown.."\n*>Ƥιη Mєѕѕαgє :* "..settings.lock_pin.."\n\n*=============*\n🔇 *ƓяσUρ* #MυƬє *Lιѕт :*\n\n*>Mυтє Ƭιмє :* "..mute_all1.."\n*>Ɠιf :* "..mutes.mute_gif.."\n*>Ƭєxт :* "..mutes.mute_text.."\n*>IηƖιηє :* "..mutes.mute_inline.."\n*>Ɠαмє :* "..mutes.mute_game.."\n*>Ƥнσтσ :* "..mutes.mute_photo.."\n*>Ʋιɗєσ :* "..mutes.mute_video.."\n*>Aυɗισ :* "..mutes.mute_audio.."\n*>Ʋσιcє :* "..mutes.mute_voice.."\n*>Sтιcкєя :* "..mutes.mute_sticker.."\n*>Ƈσηтαcт :* "..mutes.mute_contact.."\n*>Ƒσяωαяɗ :* "..mutes.mute_forward.."\n*>Lσcαтιση :* "..mutes.mute_location.."\n*>Ɗσcυмєηт :* "..mutes.mute_document.."\n*>ƬƓѕєяνιcє :* "..mutes.mute_tgservice.."\n*>ƘєуƁσαяɗ :* "..mutes.mute_keyboard.."\n\n*=============*\n💠 *ƓяσUρ* #OƬнƐя *SєттιηƓѕ :*\n\n*>Ɠяσυρ ƜєƖcσмє :* "..settings.welcome.."\n*>Ɓσтѕ Ƥяσтєcтιση :* "..settings.lock_bots.."\n*>ƑƖσσɗ Sєηѕιтινιту :* `"..NUM_MSG_MAX.."`\n*>ƑƖσσɗ Ƈнєcк Ƭιмє :* `"..TIME_CHECK.."`\n*>Ƈнαяαcтєя Sєηѕιтινιту :* `"..SETCHAR.."`\n*>Ɓσтѕ Ƈσммαηɗѕ :* "..cmdsss.."\n*>Ɛxριяє Ɗαтє :* `"..expire_date.."`\n\n*=============*\n🌐 *IηfσRмαƬιση :*\n\n*>Ɠяσυρ Ɲαмє :* "..msg.to.title.."\n*>Ɠяσυρ IƊ :* `"..msg.to.id.."`\n*>Ƴσυя Ɲαмє :* "..(check_markdown(msg.from.first_name) or "No ɳαɱҽ").."\n*>Ƴσυя IƊ :* `"..msg.from.id.."`\n*>Uѕєяηαмє :* @"..check_markdown(msg.from.username or "").."\n\n*=============*\n*>ƇнαηηєƖ :* @tel_fire\n*>Ƥσωєяєɗ Ɓу :* @tel_fire\n*>Ɠяσυρ Lαηgυαgє :* Eɴ"
else
local settings = data[tostring(target)]["settings"]
local mutes = data[tostring(target)]["mutes"] 
 text ="*̶M̶α̶Ƭ̶α̶Ɗ̶σ̶R̶ ̶Ɓ̶σ̶Ƭ :*\n*_______________*\n`🔐 لیـــست قفلــی گروه :`\n●*》قفـل ویرایش :* "..settings.lock_edit.."\n○*》قفـل لینڪ :* "..settings.lock_link.."\n●*》قفـل یوزرنیم :* "..settings.lock_username.."\n●*》قفل هشتگ :* "..settings.lock_tag.."\n○*》قفـل ورود :* "..settings.lock_join.."\n○*》قفـل اسپم :* "..settings.lock_spam.."\n●*》قفـل فلود :* "..settings.lock_flood.."\n●*》قفـل فراخوانی  :* "..settings.lock_mention.."\n○*》قفـل وب :* "..settings.lock_webpage.."\n●*》قفـل عربی :* "..settings.lock_arabic.."\n●*》قفل انگلیسی :* "..settings.lock_english.."\n○*》قفـل فونت :* "..settings.lock_markdown.."\n●*》فـل سنجاق :* "..settings.lock_pin.."\n*_______________*\n`🔇 لیـــست ّبیصــدا گروه :`\n●*》بیصدا زمان دار :* "..mute_all2.."\n○*》بیصدا گیف :* "..mutes.mute_gif.."\n●*》بیصدا متن :* "..mutes.mute_text.."\n○*》بیصدا اینلاین :* "..mutes.mute_inline.."\n●*》بیصدا بازی:* "..mutes.mute_game.."\n○*》بیصدا عکس :* "..mutes.mute_photo.."\n●*》بیصدا فیلم :* "..mutes.mute_video.."\n○*》بیصدا اهنگ :* "..mutes.mute_audio.."\n●*》بیصدا ویس:* "..mutes.mute_voice.."\n○*》بیصدا استیکر :* "..mutes.mute_sticker.."\n●*》بیصدا ارسال مخاطب :* "..mutes.mute_contact.."\n○*》بیصدا نقل و قول :* "..mutes.mute_forward.."\n●*》بیصدا مکان :* "..mutes.mute_location.."\n○*》بیصدا فایل :* "..mutes.mute_document.."\n●*》بیصدا ورود و خروج :* "..mutes.mute_tgservice.."\n○*》بیصدا کیبورد :* "..mutes.mute_keyboard.."\n*_______________*\n`💠 لیســـت تنظیمات دیگر :`\n●*》وضعیت ولکام :* "..settings.welcome.."\n○*》محافظت گروه در برابر ربات :* "..settings.lock_bots.."\n●*》حداکثر پیام مکرر:* `"..NUM_MSG_MAX.."`\n○*》زمان برسی پیام مکرر:* `"..TIME_CHECK.."`\n●*》حداکثر کارکتر مجاز :* `"..SETCHAR.."`\n○*》دستورات ربات :* "..cmdsss.."\n●*》تـاریخ انقضـا :* `"..expire_date.."`\n*_______________*\n`🌐 اطلـاعاتــ :`\n⚜*》نـام گـروه :* "..msg.to.title.."\n⚜*》ایـدی گـروه :* `"..msg.to.id.."`\n⚜*》نـام شمـا :* "..(check_markdown(msg.from.first_name) or 'No ɳαɱҽ').."\n⚜*》ایـدی شمـا :* `"..msg.from.id.."`\n⚜*》شنـاسه شمـا :* @"..(check_markdown(msg.from.username or 'No υʂҽɾɳαɱҽ')).."\n*_______________*\n*کــانال :* @tel_fire\n*برنامه نویــس :* @tel_fire\n*زبان گــروه :* `فارسی`"
end
if not lang then
text = string.gsub(text, "yes", "`Enable ✅`")
text = string.gsub(text, "no", "`Disabled ❌`")
text = string.gsub(text, "unlock", "`UnLock 🔓`")
text = string.gsub(text, "unmute", "`UnMute 🔊`")
text = string.gsub(text, "lock", "`Lock 🔐`")
text = string.gsub(text, "mute", "`Mute 🔇`")
 else
text = string.gsub(text, "yes", "#فعال ✅")
text = string.gsub(text, "no", "#غیرفعال ❌")
text = string.gsub(text, "unlock", "#قفل باز 🔓")
text = string.gsub(text, "unmute", "#باصدا 🔊")
text = string.gsub(text, "lock", "#قفل 🔐")
text = string.gsub(text, "mute", "#بیصدا 🔇")
 end
return text
end
----------------------------------------
local function plugin_enabled( name )
  for k,v in pairs(_config.enabled_plugins) do
    if name == v then
      return k
    end
  end
  return false
end
----------------------------------------
local function plugin_exists( name )
  for k,v in pairs(plugins_names()) do
    if name..'.lua' == v then
      return true
    end
  end
  return false
end
----------------------------------------
----------------------------------------
local function list_all_plugins(only_enabled, msg)
  local tmp = '\n'..MaTaDoRpm
  local text = ''
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    local status = '|✖️| >'
    nsum = nsum+1
    nact = 0
    for k2, v2 in pairs(_config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '|✔| >'
      end
      nact = nact+1
    end
    if not only_enabled or status == '|✔| >'then
      v = string.match (v, "(.*)%.lua")
      text = text..nsum..'.'..status..' '..v..' \n'
    end
  end
  text = '`'..text..'`\n *ιηѕтαƖƖєɗ ρƖυgιηѕ :* _['..nsum..']_\n *ρƖυgιηѕ єηαвƖєɗ :* _['..nact..']_\n *ρƖυgιηѕ ɗιѕαвƖєɗ :* _['..nsum-nact..']_'..tmp
  tdcli.sendMessage(msg.to.id, msg.id_, 1, text, 1, 'mt')
end
----------------------------------------
local function list_plugins(only_enabled, msg)
  local text = ''
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    local status = '*|✖️|>*'
    nsum = nsum+1
    nact = 0
    for k2, v2 in pairs(_config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '*|✔|>*'
      end
      nact = nact+1
    end
    if not only_enabled or status == '*|✔|>*'then
      v = string.match (v, "(.*)%.lua")
    end
  end
  text = "\n*Ɗσηє!*\n*MαƬαƊσR Ɓσт* `RєƖσαɗєɗ`\n*ƤƖυgιηѕ* : `["..nact.."]`\n"..MaTaDoRpm
  tdcli.sendMessage(msg.to.id, msg.id_, 1, text, 1, 'md')
end
----------------------------------------
local function reload_plugins(checks, msg)
  plugins = {}
  load_plugins()
  return list_plugins(true, msg)
end
----------------------------------------
local function enable_plugin( plugin_name, msg )
  print('checking if '..plugin_name..' exists')
  if plugin_enabled(plugin_name) then
    local text = '<b>'..plugin_name..'</b> <i>is online.</i>'
	tdcli.sendMessage(msg.to.id, msg.id_, 1, text, 1, 'html')
	return
  end
  if plugin_exists(plugin_name) then
    table.insert(_config.enabled_plugins, plugin_name)
    print(plugin_name..' added to _config table')
    save_config()
    return reload_plugins(true, msg)
  else
    local text = '<b>'..plugin_name..'</b> <i>does not exists.</i>'
	tdcli.sendMessage(msg.to.id, msg.id_, 1, text, 1, 'html')
  end
end
----------------------------------------
local function disable_plugin( name, msg )
  local k = plugin_enabled(name)
  if not k then
    local text = '<b>'..name..'</b> <i>not online.</i>'
	tdcli.sendMessage(msg.to.id, msg.id_, 1, text, 1, 'html')
	return
  end
  if not plugin_exists(name) then
    local text = '<b>'..name..'</b> <i>does not exists.</i>'
	tdcli.sendMessage(msg.to.id, msg.id_, 1, text, 1, 'html')
  else
  table.remove(_config.enabled_plugins, k)
  save_config( )
  return reload_plugins(true, msg)
end  
end
----------------------------------------
local function disable_plugin_on_chat(receiver, plugin, msg)
  if not plugin_exists(plugin) then
    return "_Plugin does not exists_"
  end

  if not _config.disabled_plugin_on_chat then
    _config.disabled_plugin_on_chat = {}
  end

  if not _config.disabled_plugin_on_chat[receiver] then
    _config.disabled_plugin_on_chat[receiver] = {}
  end

  _config.disabled_plugin_on_chat[receiver][plugin] = true

  save_config()
  local text = '<b>'..plugin..'</b> <i>offline on this chat.</i>'
  tdcli.sendMessage(msg.to.id, msg.id_, 1, text, 1, 'html')
end
----------------------------------------
local function reenable_plugin_on_chat(receiver, plugin, msg)
  if not _config.disabled_plugin_on_chat then
    return 'There aren\'t any offline plugins'
  end

  if not _config.disabled_plugin_on_chat[receiver] then
    return 'There aren\'t any offline plugins for this chat'
  end

  if not _config.disabled_plugin_on_chat[receiver][plugin] then
    return '_This plugin is not offline_'
  end

  _config.disabled_plugin_on_chat[receiver][plugin] = false
  save_config()
  local text = '<b>'..plugin..'</b> <i>is online again.</i>'
  tdcli.sendMessage(msg.to.id, msg.id_, 1, text, 1, 'html')
end
----------------------------------------
local function run(msg, matches)
if is_banned(msg.from.id, msg.to.id) or is_gbanned(msg.from.id, msg.to.id) or is_silent_user(msg.from.id, msg.to.id) then
return false
end
local cmd = redis:hget('group:'..msg.to.id..':cmd', 'bot')
local mutealll = redis:get('group:'..msg.to.id..':muteall')
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
local chat = msg.to.id
local user = msg.from.id
local uhash = 'user:'..msg.from.id
local user = redis:hgetall(uhash)
local um_hash = 'msgs:'..msg.from.id..':'..msg.to.id
user_info_msgs = tonumber(redis:get(um_hash) or 0)
if cmd == 'moderator' and not is_mod(msg) or cmd == 'owner' and not is_owner(msg) or mutealll and not is_mod(msg) then
else
if msg.to.type ~= 'pv' then
if (matches[1]:lower() == "id" and not lang) or (matches[1] == 'ایدی' and lang) then
if not matches[2] and not msg.reply_id then
local function getpro(arg, data)
 if data.photos_[0] then
       if not lang then
            tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_,"Ɠяσυρ ηαмє : "..(check_markdown(msg.to.title)).."\nƓяσυρ IƊ : "..msg.to.id.."\nƝαмє : "..(msg.from.first_name or "----").."\nUѕєяƝαмє : @"..(msg.from.username or "----").."\nUѕєя IƊ : "..msg.from.id.."",dl_cb,nil)
       elseif lang then
          tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_,"نام گروه : "..(check_markdown(msg.to.title)).."\nشناسه گروه : "..msg.to.id.."\nنام شما : "..(msg.from.first_name or "----").."\nنام کاربری : @"..(msg.from.username or "----").."\nشناسه شما : "..msg.from.id.."",dl_cb,nil)
     end
   else
       if not lang then
      tdcli.sendMessage(msg.to.id, msg.id_, 1, "`You Have Not Profile Photo...!`\n\n> *Chat ID :* `"..msg.to.id.."`\n*User ID :* `"..msg.from.id.."`", 1, 'md')
       elseif lang then
      tdcli.sendMessage(msg.to.id, msg.id_, 1, "_شما هیچ عکسی ندارید...!_\n\n> _شناسه گروه :_ `"..msg.to.id.."`\n_شناسه شما :_ `"..msg.from.id.."`", 1, 'md')
            end
        end
end
	   tdcli_function ({
    ID = "GetUserProfilePhotos",
    user_id_ = msg.from.id,
    offset_ = 0,
    limit_ = 1
  }, getpro, nil)	
end
if msg.reply_id and not matches[2] then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="id"})
  end
if matches[2] then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="id"})
      end
   end
if (matches[1]:lower() == "me" and not lang) or (matches[1] == 'اطلاعات من' and lang) then
if not matches[2] and not msg.reply_id then
local function getpro(arg, data)
 if data.photos_[0] then
       if not lang then
            tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_,"Ɲαмє : "..(msg.from.first_name or "----").."\nUѕєяƝαмє : @"..(msg.from.username or "----").."\nUѕєя IƊ : "..msg.from.id.."\nтσтαƖ мєѕѕαgєѕ : "..user_info_msgs.."",dl_cb,nil)
       elseif lang then
          tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_,"نام شما : "..(msg.from.first_name or "----").."\nنام کاربری : @"..(msg.from.username or "----").."\nشناسه شما : "..msg.from.id.."\nتعداد پیام شما : "..user_info_msgs.."",dl_cb,nil)
     end
   else
       if not lang then
      tdcli.sendMessage(msg.to.id, msg.id_, 1, "`You Have Not Profile Photo...!`\n\n> *Chat ID :* `"..msg.to.id.."`\n*User ID :* `"..msg.from.id.."`", 1, 'md')
       elseif lang then
      tdcli.sendMessage(msg.to.id, msg.id_, 1, "_شما هیچ عکسی ندارید...!_\n\n> _شناسه گروه :_ `"..msg.to.id.."`\n_شناسه شما :_ `"..msg.from.id.."`", 1, 'md')
            end
        end
end
	   tdcli_function ({
    ID = "GetUserProfilePhotos",
    user_id_ = msg.from.id,
    offset_ = 0,
    limit_ = 1
  }, getpro, nil)	
end
if msg.reply_id and not matches[2] then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="id"})
  end
if matches[2] then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="id"})
      end
   end
if ((matches[1]:lower() == "pin" and not lang) or (matches[1] == 'سنجاق' and lang)) and is_mod(msg) and msg.reply_id then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
    data[tostring(chat)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1)
if not lang then
return "*Message Has Been Pinned*"
elseif lang then
return "پیام سجاق شد"
end
elseif not is_owner(msg) then
   return
 end
 elseif lock_pin == 'no' then
    data[tostring(chat)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1)
if not lang then
return "*Message Has Been Pinned*"
elseif lang then
return "پیام سجاق شد"
end
end
end
if ((matches[1]:lower() == 'unpin' and not lang) or (matches[1] == 'حذف سنجاق' and lang)) and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
tdcli.unpinChannelMessage(msg.to.id)
if not lang then
return "*Pin message has been unpinned*"
elseif lang then
return "پیام سنجاق شده پاک شد"
end
elseif not is_owner(msg) then
   return 
 end
 elseif lock_pin == 'no' then
tdcli.unpinChannelMessage(msg.to.id)
if not lang then
return "*Pin message has been unpinned*"
elseif lang then
return "پیام سنجاق شده پاک شد"
end
end
end
if ((matches[1]:lower() == "add" and not lang) or (matches[1] == 'نصب' and lang))and is_admin(msg) then
			redis:set('ExpireDate:'..msg.to.id,true)
			redis:setex('ExpireDate:'..msg.to.id, 180, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id,true)
				end
return modadd(msg)
end
   if ((matches[1]:lower() == "add" and not lang) or (matches[1] == 'نصب' and lang))and not is_admin(msg) then
     if not lang then
        return '*#》Ƴσυ αяє ησт вσт αɗмιη 🚷*\n*〰〰〰〰〰〰〰〰*\n💠 `Run this command only for Admins and deputies is`'
   else
        return '#》 `شما` #مدیر `گروه نیستید` 🚷\n*〰〰〰〰〰〰〰〰*\n💠 اجرای این دستور فقط برای مدیران و معاونان است.'
    end
end
if (matches[1]:lower() == "rem" and not lang) or (matches[1] == 'لغو نصب' and lang) then
			if redis:get('CheckExpire::'..msg.to.id) then
				redis:del('CheckExpire::'..msg.to.id)
			end
			redis:del('ExpireDate:'..msg.to.id)
return modrem(msg)
end
if ((matches[1]:lower() == "setmanager" and not lang) or (matches[1] == 'ادمین گروه' and lang)) and is_owner(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="setmanager"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="setmanager"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="setmanager"})
      end
   end
if ((matches[1]:lower() == "remmanager" and not lang) or (matches[1] == 'حذف ادمین گروه' and lang)) and is_owner(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="remmanager"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="remmanager"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="remmanager"})
      end
   end
if ((matches[1]:lower() == "whitelist" and not lang) or (matches[1] == 'لیست سفید' and lang)) and matches[2] == "+" and is_mod(msg) then
if not matches[3] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="setwhitelist"})
  end
  if matches[3] and string.match(matches[3], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[3],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[3],cmd="setwhitelist"})
    end
  if matches[3] and not string.match(matches[3], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[3]
    }, action_by_username, {chat_id=msg.to.id,username=matches[3],cmd="setwhitelist"})
      end
   end
if ((matches[1]:lower() == "whitelist" and not lang) or (matches[1] == 'لیست سفید' and lang)) and matches[2] == "-" and is_mod(msg) then
if not matches[3] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="remwhitelist"})
  end
  if matches[3] and string.match(matches[3], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[3],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[3],cmd="remwhitelist"})
    end
  if matches[3] and not string.match(matches[3], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[3]
    }, action_by_username, {chat_id=msg.to.id,username=matches[3],cmd="remwhitelist"})
      end
   end
if ((matches[1]:lower() == "setowner" and not lang) or (matches[1] == 'مالک' and lang)) and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="setowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="setowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="setowner"})
      end
   end
if ((matches[1]:lower() == "remowner" and not lang) or (matches[1] == 'حذف مالک' and lang)) and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="remowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="remowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="remowner"})
      end
   end
if (matches[1]:lower() == "promote" or matches[1] == 'مدیر') and is_owner(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="promote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="promote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="promote"})
      end
   end
if ((matches[1]:lower() == "demote" and not lang) or (matches[1] == 'حذف مدیر' and lang)) and is_owner(msg) then
if not matches[2] and msg.reply_id then
 tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="demote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="demote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="demote"})
      end
   end
if ((matches[1]:lower() == "lock" and not lang) or (matches[1] == 'قفل' and lang)) and is_mod(msg) then
local target = msg.to.id
if not lang then
if matches[2]:lower() == "link" then
return lock_link(msg, data, target)
end
if matches[2]:lower() == "tag" then
return lock_tag(msg, data, target)
end
if matches[2]:lower() == "username" then
return lock_username(msg, data, target)
end
if matches[2]:lower() == "all" then
return lock_all(msg, data, target)
end
if matches[2]:lower() == "mention" then
return lock_mention(msg, data, target)
end
if matches[2]:lower() == "arabic" then
return lock_arabic(msg, data, target)
end
if matches[2]:lower() == "english" then
return lock_english(msg, data, target)
end
if matches[2]:lower() == "edit" then
return lock_edit(msg, data, target)
end
if matches[2]:lower() == "spam" then
return lock_spam(msg, data, target)
end
if matches[2]:lower() == "flood" then
return lock_flood(msg, data, target)
end
if matches[2]:lower() == "bots" then
return lock_bots(msg, data, target)
end
if matches[2]:lower() == "markdown" then
return lock_markdown(msg, data, target)
end
if matches[2]:lower() == "webpage" then
return lock_webpage(msg, data, target)
end
if matches[2]:lower() == "pin" and is_owner(msg) then
return lock_pin(msg, data, target)
end
if matches[2]:lower() == "join" then
return lock_join(msg, data, target)
end
if matches[2]:lower() == 'cmds' then
			redis:hset('group:'..msg.to.id..':cmd', 'bot', 'moderator')
			return '>Ƈмɗѕ нαѕ вєєη Ɩσcкєɗ fσя мємвєя🤖🔒\n*OяɗєяƁу :* [@'..check_markdown(msg.from.username or '')..'*|*`'..msg.from.id..'`]'
			end
else
if matches[2] == 'لینک' then
return lock_link(msg, data, target)
end
if matches[2] == 'تگ' then
return lock_tag(msg, data, target)
end
if matches[2] == 'نام کاربری' then
return lock_username(msg, data, target)
end
if matches[2] == "همه" then
return lock_all(msg, data, target)
end
if matches[2] == 'فراخوانی' then
return lock_mention(msg, data, target)
end
if matches[2] == 'عربی' then
return lock_arabic(msg, data, target)
end
if matches[2] == "انگلیسی" then
return lock_english(msg, data, target)
end
if matches[2] == 'ویرایش' then
return lock_edit(msg, data, target)
end
if matches[2] == 'هرزنامه' then
return lock_spam(msg, data, target)
end
if matches[2] == 'پیام مکرر' then
return lock_flood(msg, data, target)
end
if matches[2] == 'ربات' then
return lock_bots(msg, data, target)
end
if matches[2] == 'فونت' then
return lock_markdown(msg, data, target)
end
if matches[2] == 'وب' then
return lock_webpage(msg, data, target)
end
if matches[2] == 'سنجاق' and is_owner(msg) then
return lock_pin(msg, data, target)
end
if matches[2] == "ورود" then
return lock_join(msg, data, target)
end
if matches[2] == 'دستورات' then
			redis:hset('group:'..msg.to.id..':cmd', 'bot', 'moderator')
			return 'دستورات برای کاربر عادی قفل شد 🤖🔒\n*سفارش توسط :* [@'..check_markdown(msg.from.username or '')..'*|*`'..msg.from.id..'`]'
			end
			end
end
if ((matches[1]:lower() == "unlock" and not lang) or (matches[1] == 'باز' and lang)) and is_mod(msg) then
local target = msg.to.id
if not lang then
if matches[2]:lower() == "link" then
return unlock_link(msg, data, target)
end
if matches[2]:lower() == "tag" then
return unlock_tag(msg, data, target)
end
if matches[2]:lower() == "username" then
return unlock_username(msg, data, target)
end
if matches[2]:lower() == "all" then
return unlock_all(msg, data, target)
end
if matches[2]:lower() == "mention" then
return unlock_mention(msg, data, target)
end
if matches[2]:lower() == "arabic" then
return unlock_arabic(msg, data, target)
end
if matches[2]:lower() == "english" then
return unlock_english(msg, data, target)
end
if matches[2]:lower() == "edit" then
return unlock_edit(msg, data, target)
end
if matches[2]:lower() == "spam" then
return unlock_spam(msg, data, target)
end
if matches[2]:lower() == "flood" then
return unlock_flood(msg, data, target)
end
if matches[2]:lower() == "bots" then
return unlock_bots(msg, data, target)
end
if matches[2]:lower() == "markdown" then
return unlock_markdown(msg, data, target)
end
if matches[2]:lower() == "webpage" then
return unlock_webpage(msg, data, target)
end
if matches[2]:lower() == "pin" and is_owner(msg) then
return unlock_pin(msg, data, target)
end
if matches[2]:lower() == "join" then
return unlock_join(msg, data, target)
end
if matches[2]:lower() == 'cmds' then
			redis:del('group:'..msg.to.id..':cmd')
			return '>Ƈмɗѕ нαѕ вєєη υηƖσcкєɗ fσя мємвєя 🤖🔓\n*OяɗєяƁу :* [@'..check_markdown(msg.from.username or '')..'*|*`'..msg.from.id..'`]'
			end
	else
if matches[2] == 'لینک' then
return unlock_link(msg, data, target)
end
if matches[2] == 'تگ' then
return unlock_tag(msg, data, target)
end
if matches[2] == 'نام کاربری' then
return unlock_username(msg, data, target)
end
if matches[2] == "همه" then
return unlock_all(msg, data, target)
end
if matches[2] == 'فراخوانی' then
return unlock_mention(msg, data, target)
end
if  matches[2] == 'عربی' then
return unlock_arabic(msg, data, target)
end
if matches[2] == "انگلیسی" then
return unlock_english(msg, data, target)
end
if matches[2] == 'ویرایش' then
return unlock_edit(msg, data, target)
end
if matches[2] == 'هرزنامه' then
return unlock_spam(msg, data, target)
end
if matches[2] == 'پیام مکرر' then
return unlock_flood(msg, data, target)
end
if matches[2] == 'ربات' then
return unlock_bots(msg, data, target)
end
if matches[2] == 'فونت' then
return unlock_markdown(msg, data, target)
end
if matches[2] == 'وب' then
return unlock_webpage(msg, data, target)
end
if matches[2] == 'سنجاق' and is_owner(msg) then
return unlock_pin(msg, data, target)
end
if matches[2] == "ورود" then
return unlock_join(msg, data, target)
end
if matches[2] == 'دستورات' then
			redis:del('group:'..msg.to.id..':cmd')
			return 'دستورات برای کاربر عادی باز شد 🤖🔓\n*سفارش توسط :* [@'..check_markdown(msg.from.username or '')..'*|*`'..msg.from.id..'`]'
			end
	end
end
if ((matches[1]:lower() == "mute" and not lang) or (matches[1] == 'بیصدا' and lang)) and is_mod(msg) then
local target = msg.to.id
if not lang then
if matches[2]:lower() == "gif" then
return mute_gif(msg, data, target)
end
if matches[2]:lower() == "text" then
return mute_text(msg ,data, target)
end
if matches[2]:lower() == "photo" then
return mute_photo(msg ,data, target)
end
if matches[2]:lower() == "video" then
return mute_video(msg ,data, target)
end
if matches[2]:lower() == "audio" then
return mute_audio(msg ,data, target)
end
if matches[2]:lower() == "voice" then
return mute_voice(msg ,data, target)
end
if matches[2]:lower() == "sticker" then
return mute_sticker(msg ,data, target)
end
if matches[2]:lower() == "contact" then
return mute_contact(msg ,data, target)
end
if matches[2]:lower() == "forward" then
return mute_forward(msg ,data, target)
end
if matches[2]:lower() == "location" then
return mute_location(msg ,data, target)
end
if matches[2]:lower() == "document" then
return mute_document(msg ,data, target)
end
if matches[2]:lower() == "tgservice" then
return mute_tgservice(msg ,data, target)
end
if matches[2]:lower() == "inline" then
return mute_inline(msg ,data, target)
end
if matches[2]:lower() == "game" then
return mute_game(msg ,data, target)
end
if matches[2]:lower() == "keyboard" then
return mute_keyboard(msg ,data, target)
end
if matches[2]:lower() == 'all' then
local hash = 'muteall:'..msg.to.id
redis:set(hash, true)
return "*>Mυтє AƖƖ* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
else
if matches[2] == 'تصاویر متحرک' then
return mute_gif(msg, data, target)
end
if matches[2] == 'متن' then
return mute_text(msg ,data, target)
end
if matches[2] == 'عکس' then
return mute_photo(msg ,data, target)
end
if matches[2] == 'فیلم' then
return mute_video(msg ,data, target)
end
if matches[2] == 'اهنگ' then
return mute_audio(msg ,data, target)
end
if matches[2] == 'صدا' then
return mute_voice(msg ,data, target)
end
if matches[2] == 'برچسب' then
return mute_sticker(msg ,data, target)
end
if matches[2] == 'مخاطب' then
return mute_contact(msg ,data, target)
end
if matches[2] == 'نقل قول' then
return mute_forward(msg ,data, target)
end
if matches[2] == 'موقعیت' then
return mute_location(msg ,data, target)
end
if matches[2] == 'اسناد' then
return mute_document(msg ,data, target)
end
if matches[2] == 'خدمات تلگرام' then
return mute_tgservice(msg ,data, target)
end
if matches[2] == 'کیبورد شیشه ای' then
return mute_inline(msg ,data, target)
end
if matches[2] == 'بازی' then
return mute_game(msg ,data, target)
end
if matches[2] == 'صفحه کلید' then
return mute_keyboard(msg ,data, target)
end
if matches[2]== 'همه' then
local hash = 'muteall:'..msg.to.id
redis:set(hash, true)
return "بیصدا کردن گروه فعال شد 🤖🔇\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
end
end
if ((matches[1]:lower() == "unmute" and not lang) or (matches[1] == 'باصدا' and lang)) and is_mod(msg) then
local target = msg.to.id
if not lang then
if matches[2]:lower() == "gif" then
return unmute_gif(msg, data, target)
end
if matches[2]:lower() == "text" then
return unmute_text(msg, data, target)
end
if matches[2]:lower() == "photo" then
return unmute_photo(msg ,data, target)
end
if matches[2]:lower() == "video" then
return unmute_video(msg ,data, target)
end
if matches[2]:lower() == "audio" then
return unmute_audio(msg ,data, target)
end
if matches[2]:lower() == "voice" then
return unmute_voice(msg ,data, target)
end
if matches[2]:lower() == "sticker" then
return unmute_sticker(msg ,data, target)
end
if matches[2]:lower() == "contact" then
return unmute_contact(msg ,data, target)
end
if matches[2]:lower() == "forward" then
return unmute_forward(msg ,data, target)
end
if matches[2]:lower() == "location" then
return unmute_location(msg ,data, target)
end
if matches[2]:lower() == "document" then
return unmute_document(msg ,data, target)
end
if matches[2]:lower() == "tgservice" then
return unmute_tgservice(msg ,data, target)
end
if matches[2]:lower() == "inline" then
return unmute_inline(msg ,data, target)
end
if matches[2]:lower() == "game" then
return unmute_game(msg ,data, target)
end
if matches[2]:lower() == "keyboard" then
return unmute_keyboard(msg ,data, target)
end
 if matches[2]:lower() == 'all' then
         local hash = 'muteall:'..msg.to.id
        redis:del(hash)
          return "*>Mυтє AƖƖ* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
end
else
if matches[2] == 'تصاویر متحرک' then
return unmute_gif(msg, data, target)
end
if matches[2] == 'متن' then
return unmute_text(msg, data, target)
end
if matches[2] == 'عکس' then
return unmute_photo(msg ,data, target)
end
if matches[2] == 'فیلم' then
return unmute_video(msg ,data, target)
end
if matches[2] == 'اهنگ' then
return unmute_audio(msg ,data, target)
end
if matches[2] == 'صدا' then
return unmute_voice(msg ,data, target)
end
if matches[2] == 'برچسب' then
return unmute_sticker(msg ,data, target)
end
if matches[2] == 'مخاطب' then
return unmute_contact(msg ,data, target)
end
if matches[2] == 'نقل قول' then
return unmute_forward(msg ,data, target)
end
if matches[2] == 'موقعیت' then
return unmute_location(msg ,data, target)
end
if matches[2] == 'اسناد' then
return unmute_document(msg ,data, target)
end
if matches[2] == 'خدمات تلگرام' then
return unmute_tgservice(msg ,data, target)
end
if matches[2] == 'کیبورد شیشه ای' then
return unmute_inline(msg ,data, target)
end
if matches[2] == 'بازی' then
return unmute_game(msg ,data, target)
end
if matches[2] == 'صفحه کلید' then
return unmute_keyboard(msg ,data, target)
end
 if matches[2]=='همه' and is_mod(msg) then
         local hash = 'muteall:'..msg.to.id
        redis:del(hash)
          return "گروه ازاد شد و افراد می توانند دوباره پست بگذارند 🤖🔊\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
		  
end
end
end
if ((matches[1]:lower() == 'cmds' and not lang) or (matches[1] == 'دستورات' and lang)) and is_owner(msg) then 
	if not lang then
		if matches[2]:lower() == 'owners' then 
		redis:hset('group:'..msg.to.id..':cmd', 'bot', 'owner') 
		return 'cmds set for owner or higher' 
		end
		if matches[2]:lower() == 'mods' then 
		redis:hset('group:'..msg.to.id..':cmd', 'bot', 'moderator')
		return 'cmds set for moderator or higher'
		end 
		if matches[2]:lower() == 'members' then 
		redis:hset('group:'..msg.to.id..':cmd', 'bot', 'member') 
		return 'cmds set for member or higher' 
		end 
	else
		if matches[2] == 'مالک' then 
		redis:hset('group:'..msg.to.id..':cmd', 'bot', 'owner') 
		return 'دستورات برای مدیرکل به بالا دیگر جواب می دهد' 
		end
		if matches[2] == 'مدیر' then 
		redis:hset('group:'..msg.to.id..':cmd', 'bot', 'moderator')
		return 'دستورات برای مدیر به بالا دیگر جواب می دهد' 
		end 
		if matches[2] == 'کاربر' then 
		redis:hset('group:'..msg.to.id..':cmd', 'bot', 'member') 
		return 'دستورات برای کاربر عادی به بالا دیگر جواب می دهد' 
		end 
		end
	end
if ((matches[1]:lower() == "gpinfo" and not lang) or (matches[1] == 'اطلاعات گروه' and lang)) and is_mod(msg) and msg.to.type == "channel" then
local function group_info(arg, data)
if not lang then
ginfo = "*Group Info :*\n_Admin Count :_ *"..data.administrator_count_.."*\n_Member Count :_ *"..data.member_count_.."*\n_Kicked Count :_ *"..data.kicked_count_.."*\n_Group ID :_ *"..data.channel_.id_.."*"
elseif lang then
ginfo = "*اطلاعات گروه :*\n_تعداد مدیران :_ *"..data.administrator_count_.."*\n_تعداد اعضا :_ *"..data.member_count_.."*\n_تعداد اعضای حذف شده :_ *"..data.kicked_count_.."*\n_شناسه گروه :_ *"..data.channel_.id_.."*"
end
        tdcli.sendMessage(arg.chat_id, arg.msg_id, 1, ginfo, 1, 'md')
end
 tdcli.getChannelFull(msg.to.id, group_info, {chat_id=msg.to.id,msg_id=msg.id})
end
if ((matches[1]:lower() == 'newlink' and not lang) or (matches[1] == 'لینک جدید' and lang)) and is_mod(msg) and not matches[2] then
	local function callback_link (arg, data)
    local administration = load_data(_config.moderation.data) 
				if not data.invite_link_ then
					administration[tostring(msg.to.id)]['settings']['linkgp'] = nil
					save_data(_config.moderation.data, administration)
       if not lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "_Bot is not group creator_\n_set a link for group with using_ /setlink", 1, 'md')
       elseif lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "_ربات سازنده گروه نیست_\n_با دستور_ setlink/ _لینک جدیدی برای گروه ثبت کنید_", 1, 'md')
    end
				else
					administration[tostring(msg.to.id)]['settings']['linkgp'] = data.invite_link_
					save_data(_config.moderation.data, administration)
        if not lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "*Newlink Created*", 1, 'md')
        elseif lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "_لینک جدید ساخته شد_", 1, 'md')
            end
				end
			end
 tdcli.exportChatInviteLink(msg.to.id, callback_link, nil)
		end
		if ((matches[1]:lower() == 'newlink' and not lang) or (matches[1] == 'لینک جدید' and lang)) and is_mod(msg) and ((matches[2] == 'pv' and not lang) or (matches[2] == 'خصوصی' and lang)) then
	local function callback_link (arg, data)
		local result = data.invite_link_
		local administration = load_data(_config.moderation.data) 
				if not result then
					administration[tostring(msg.to.id)]['settings']['linkgp'] = nil
					save_data(_config.moderation.data, administration)
       if not lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "_Bot is not group creator_\n_set a link for group with using_ /setlink", 1, 'md')
       elseif lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "_ربات سازنده گروه نیست_\n_با دستور_ setlink/ _لینک جدیدی برای گروه ثبت کنید_", 1, 'md')
    end
				else
					administration[tostring(msg.to.id)]['settings']['linkgp'] = result
					save_data(_config.moderation.data, administration)
        if not lang then
		tdcli.sendMessage(user, msg.id, 1, "*Newlink Group* _:_ `"..msg.to.id.."`\n"..result, 1, 'md')
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "*New link Was Send In Your Private Message*", 1, 'md')
        elseif lang then
		tdcli.sendMessage(user, msg.id, 1, "*لینک جدید گروه* _:_ `"..msg.to.id.."`\n"..result, 1, 'md')
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "_لینک جدید ساخته شد و در پیوی شما ارسال شد_", 1, 'md')
            end
				end
			end
 tdcli.exportChatInviteLink(msg.to.id, callback_link, nil)
		end
		if ((matches[1]:lower() == 'setlink' and not lang) or (matches[1] == 'تنظیم لینک' and lang)) and is_owner(msg) then
		if not matches[2] then
		data[tostring(chat)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
			if not lang then
			return '_Please send the new group_ *link* _now_'
    else 
         return 'لطفا لینک گروه خود را ارسال کنید'
       end
	   end
		 data[tostring(chat)]['settings']['linkgp'] = matches[2]
			 save_data(_config.moderation.data, data)
      if not lang then
			return '_Group Link Was Saved Successfully._'
    else 
         return 'لینک گروه شما با موفقیت ذخیره شد'
       end
		end
		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(chat)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
            if not lang then
				return "*Newlink* _has been set_"
           else
           return "لینک جدید ذخیره شد"
		 	end
       end
		end
if matches[1]:lower() == "link" or matches[1]:lower() == "لینک" then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
      if not lang then
        return "_First create a link for group with using_ /newlink\n_If bot not group creator set a link with using_ /setlink"
     else
        return "ابتدا با دستور newlink/ لینک جدیدی برای گروه بسازید\nو اگر ربات سازنده گروه نیس با دستور setlink/ لینک جدیدی برای گروه ثبت کنید"
      end
      end
    if not lang then
    texth = "Tab Here For Join To ➣"
        elseif lang then
    texth = "کلیک کنید برای وارد شدن به ➣"
    end
local function inline_link_cb(TM, MR)
      if MR.results_ and MR.results_[0] then
tdcli.sendInlineQueryResultMessage(msg.to.id, 0, 0, 1, MR.inline_query_id_, MR.results_[0].id_, dl_cb, nil)
    else
     if not lang then
       text = "<b>Bold is offline</b>\n\n<b>Group Link :</b>\n"..linkgp
     else
      text = "<i>ربات Bold خاموش است</i>\n\n<b>لینک گروه :</b>\n"..linkgp
         end
  return tdcli.sendMessage(msg.to.id, msg.id, 0, text, 0, "html")
   end
end
tdcli.getInlineQueryResults(107705060, msg.to.id, 0, 0, ""..texth.."\n[ "..msg.to.title.."]("..linkgp..")", 0, inline_link_cb, nil)
end
    if ((matches[1]:lower() == 'link' and not lang) or (matches[1] == 'لینک' and lang)) and ((matches[2] == 'pv' and not lang) or (matches[2] == 'خصوصی' and lang)) then
	if is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
      if not lang then
        return "_First create a link for group with using_ /newlink\n_If bot not group creator set a link with using_ /setlink"
     else
        return "ابتدا با دستور newlink/ لینک جدیدی برای گروه بسازید\nو اگر ربات سازنده گروه نیس با دستور setlink/ لینک جدیدی برای گروه ثبت کنید"
      end
      end
     if not lang then
	 tdcli.sendMessage(chat, msg.id, 1, "<b>link Was Send In Your Private Message</b>", 1, 'html')
     tdcli.sendMessage(user, "", 1, "<b>Group Link "..msg.to.title.." :</b>\n"..linkgp, 1, 'html')
     else
	 tdcli.sendMessage(chat, msg.id, 1, "<b>لینک گروه در پیوی  شما ارسال شد</b>", 1, 'html')
      tdcli.sendMessage(user, "", 1, "<b>لینک گروه "..msg.to.title.." :</b>\n"..linkgp, 1, 'html')
         end
     end
	 end
  if ((matches[1]:lower() == "setrules" and not lang) or (matches[1] == 'تنظیم قوانین' and lang)) and matches[2] and is_mod(msg) then
    data[tostring(chat)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
     if not lang then
    return "*Group rules* _has been set_"
   else 
  return "قوانین گروه ثبت شد"
   end
  end
  if (matches[1]:lower() == "rules" and not lang) or (matches[1] == 'قوانین' and lang) then
 if not data[tostring(chat)]['rules'] then
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@tel_fire"
    elseif lang then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n@tel_fire"
 end
        else
     rules = "*Group Rules :*\n"..data[tostring(chat)]['rules']
      end
    return rules
  end
if ((matches[1]:lower() == "res" and not lang) or (matches[1] == 'کاربری' and lang)) and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="res"})
  end
if ((matches[1]:lower() == "whois" and not lang) or (matches[1] == 'شناسه' and lang)) and matches[2] and string.match(matches[2], '^%d+$') and is_mod(msg) then
local texten = "Click To See The User's Profile..!"
local textfa = "کلیک کنید برای دیدن مشخصات کاربر..!"
local id = matches[2]
if not lang then
tdcli_function ({ID="SendMessage", chat_id_=msg.to.id, reply_to_message_id_=msg.id, disable_notification_=0, from_background_=1, reply_markup_=nil, input_message_content_={ID="InputMessageText", text_= texten, disable_web_page_preview_=1, clear_draft_=0, entities_={[0] = {ID="MessageEntityMentionName", offset_=0, length_=34, user_id_=id}}}}, dl_cb, nil)
else
tdcli_function ({ID="SendMessage", chat_id_=msg.to.id, reply_to_message_id_=msg.id, disable_notification_=0, from_background_=1, reply_markup_=nil, input_message_content_={ID="InputMessageText", text_= textfa, disable_web_page_preview_=1, clear_draft_=0, entities_={[0] = {ID="MessageEntityMentionName", offset_=0, length_=35, user_id_=id}}}}, dl_cb, nil)
end
end

		if ((matches[1]:lower() == 'setchar' and not lang) or (matches[1]:lower() == 'حداکثر حروف مجاز' and lang)) then
			if not is_mod(msg) then
				return
			end
			local chars_max = matches[2]
			data[tostring(msg.to.id)]['settings']['set_char'] = chars_max
			save_data(_config.moderation.data, data)
    if not lang then
     return "*Character sensitivity* _has been set to :_ *[ "..matches[2].." ]*"
   else
     return "_حداکثر حروف مجاز در پیام تنظیم شد به :_ *[ "..matches[2].." ]*"
		end
  end
  if ((matches[1]:lower() == 'setflood' and not lang) or (matches[1] == 'تنظیم پیام مکرر' and lang)) and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "_Wrong number, range is_ *[2-50]*"
      end
			local flood_max = matches[2]
			data[tostring(chat)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
			if not lang then
    return "_Group_ *flood* _sensitivity has been set to :_ *[ "..matches[2].." ]*"
    else
    return '_محدودیت پیام مکرر به_ *'..tonumber(matches[2])..'* _تنظیم شد._'
    end
       end
  if ((matches[1]:lower() == 'setfloodtime' and not lang) or (matches[1] == 'تنظیم زمان بررسی' and lang)) and is_mod(msg) then
			if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 10 then
				return "_Wrong number, range is_ *[2-10]*"
      end
			local time_max = matches[2]
			data[tostring(chat)]['settings']['time_check'] = time_max
			save_data(_config.moderation.data, data)
			if not lang then
    return "_Group_ *flood* _check time has been set to :_ *[ "..matches[2].." ]*"
    else
    return "_حداکثر زمان بررسی پیام های مکرر تنظیم شد به :_ *[ "..matches[2].." ]*"
    end
       end
		if ((matches[1]:lower() == 'clean' and not lang) or (matches[1] == 'پاک کردن' and lang)) and is_owner(msg) then
		if not lang then
			if matches[2] == 'mods' then
				if next(data[tostring(chat)]['mods']) == nil then
					return "_No_ *Fire* _in this group_"
            end
				for k,v in pairs(data[tostring(chat)]['mods']) do
					data[tostring(chat)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_All_ *Fire* _has been demoted_"
         end
		 if matches[2] == 'bot'then
  function clbot(arg, data)
    for k, v in pairs(data.members_) do
      kick_user(v.user_id_, msg.to.id)
	end
    tdcli.sendMessage(msg.to.id, msg.id, 1, '_All Bots was cleared._', 1, 'md')
  end
  tdcli.getChannelMembers(msg.to.id, 0, 'Bots', 200, clbot, nil)
  end
    if matches[2] == 'blacklist' then
    local function cleanbl(ext, res)
      if tonumber(res.total_count_) == 0 then
        return tdcli.sendMessage(ext.chat_id, ext.msg_id, 0, ' _blackList Group is empty_⚠️', 1, 'md')
      end
      local x = 0
      for x,y in pairs(res.members_) do
        x = x + 1
        tdcli.changeChatMemberStatus(ext.chat_id, y.user_id_, 'Left', dl_cb, nil)
      end
      return tdcli.sendMessage(ext.chat_id, ext.msg_id, 0, ' _Users of the black list group was_✅ ', 1, 'md')
    end
	
    return tdcli.getChannelMembers(msg.to.id, 0, 'Kicked', 200, cleanbl, {chat_id = msg.to.id, msg_id = msg.id})
  end
           if matches[2] == 'filterlist' then
				if next(data[tostring(chat)]['filterlist']) == nil then
					return "*Filtered words list* _is empty_"
				end
				for k,v in pairs(data[tostring(chat)]['filterlist']) do
					data[tostring(chat)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*Filtered words list* _has been cleaned_"
			end
			if matches[2] == 'rules' then
				if not data[tostring(chat)]['rules'] then
					return "_No_ *rules* _available_"
				end
					data[tostring(chat)]['rules'] = nil
					save_data(_config.moderation.data, data)
				return "*Group rules* _has been cleaned_"
       end
			if matches[2] == 'welcome' then
				if not data[tostring(chat)]['setwelcome'] then
					return "*Welcome Message not set*"
				end
					data[tostring(chat)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
				return "*Welcome message* _has been cleaned_"
       end
			if matches[2] == 'about' then
        if msg.to.type == "chat" then
				if not data[tostring(chat)]['about'] then
					return "_No_ *description* _available_"
				end
					data[tostring(chat)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "channel" then
   tdcli.changeChannelAbout(chat, "", dl_cb, nil)
             end
				return "*Group description* _has been cleaned_"
		   	end
			if matches[2] == 'deleted'and msg.to.type == "channel" then 
  function check_deleted(TM, MR) 
    for k, v in pairs(MR.members_) do 
local function clean_cb(TM, MR)
if not MR.first_name_ then
kick_user(MR.id_, msg.to.id) 
end
end
tdcli.getUser(v.user_id_, clean_cb, nil)
 end 
    tdcli.sendMessage(msg.to.id, msg.id, 1, '*All Deleted Account was cleared*', 1, 'md') 
  end 
  tdcli_function ({ID = "GetChannelMembers",channel_id_ = getChatId(msg.to.id).ID,offset_ = 0,limit_ = 1000}, check_deleted, nil)
  end 
			else
			if matches[2] == 'مدیران' then
				if next(data[tostring(chat)]['mods']) == nil then
                return "هیچ مدیری برای گروه انتخاب نشده است"
            end
				for k,v in pairs(data[tostring(chat)]['mods']) do
					data[tostring(chat)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            return "تمام مدیران گروه تنزیل مقام شدند"
         end
		 if matches[2] == 'ربات'then
  function clbot(arg, data)
    for k, v in pairs(data.members_) do
      kick_user(v.user_id_, msg.to.id)
	end
    tdcli.sendMessage(msg.to.id, msg.id, 1, '_تمام ربات های مخرب پاکسازی شد._', 1, 'md')
  end
  tdcli.getChannelMembers(msg.to.id, 0, 'Bots', 200, clbot, nil)
  end
    if matches[2] == 'لیست سیاه' then
    local function cleanbl(ext, res)
      if tonumber(res.total_count_) == 0 then
        return tdcli.sendMessage(ext.chat_id, ext.msg_id, 0, '⚠️ _لیست مسدودی های گروه خالی است_ !', 1, 'md')
      end
      local x = 0
      for x,y in pairs(res.members_) do
        x = x + 1
        tdcli.changeChatMemberStatus(ext.chat_id, y.user_id_, 'Left', dl_cb, nil) 
      end
      return tdcli.sendMessage(ext.chat_id, ext.msg_id, 0, '✅ _ کاربر از لیست مسدودی های گروه آزاد شدند_ !', 1, 'md')
    end
	
    return tdcli.getChannelMembers(msg.to.id, 0, 'Kicked', 200, cleanbl, {chat_id = msg.to.id, msg_id = msg.id})
  end
			if matches[2] == 'لیست فیلتر' then
				if next(data[tostring(chat)]['filterlist']) == nil then
					return "_لیست کلمات فیلتر شده خالی است_"
				end
				for k,v in pairs(data[tostring(chat)]['filterlist']) do
					data[tostring(chat)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_لیست کلمات فیلتر شده پاک شد_"
			end
			if matches[2] == 'قوانین' then
				if not data[tostring(chat)]['rules'] then
               return "قوانین برای گروه ثبت نشده است"
				end
					data[tostring(chat)]['rules'] = nil
					save_data(_config.moderation.data, data)
            return "قوانین گروه پاک شد"
       end
			if matches[2] == 'خوشآمد' then
				if not data[tostring(chat)]['setwelcome'] then
               return "پیام خوشآمد گویی ثبت نشده است"
				end
					data[tostring(chat)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
            return "پیام خوشآمد گویی پاک شد"
       end
			if matches[2] == 'درباره' then
        if msg.to.type == "chat" then
				if not data[tostring(chat)]['about'] then
              return "پیامی مبنی بر درباره گروه ثبت نشده است"
				end
					data[tostring(chat)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "channel" then
   tdcli.changeChannelAbout(chat, "", dl_cb, nil)
             end
              return "پیام مبنی بر درباره گروه پاک شد"
		   	end
			if matches[2] == 'اکانت پاک شده' and msg.to.type == "channel" then 
  function check_deleted(TM, MR) 
    for k, v in pairs(MR.members_) do 
local function clean_cb(TM, MR)
if not MR.first_name_ then
kick_user(MR.id_, msg.to.id) 
end
end
tdcli.getUser(v.user_id_, clean_cb, nil)
 end 
    tdcli.sendMessage(msg.to.id, msg.id, 1, '_تمام اکانتی های پاک شده پاکسازی شدند._', 1, 'md') 
  end 
  tdcli_function ({ID = "GetChannelMembers",channel_id_ = getChatId(msg.to.id).ID,offset_ = 0,limit_ = 1000}, check_deleted, nil)
  end 
			end
        end
		if ((matches[1]:lower() == 'clean' and not lang) or (matches[1] == 'پاک کردن' and lang)) and is_admin(msg) then
		if not lang then
			if matches[2] == 'owners' then
				if next(data[tostring(chat)]['owners']) == nil then
					return "_No_ *owners* _in this group_"
				end
				for k,v in pairs(data[tostring(chat)]['owners']) do
					data[tostring(chat)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_All_ *owners* _has been demoted_"
			end
			else
			if matches[2] == 'مالکان' then
				if next(data[tostring(chat)]['owners']) == nil then
                return "مالکی برای گروه انتخاب نشده است"
				end
				for k,v in pairs(data[tostring(chat)]['owners']) do
					data[tostring(chat)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            return "تمامی مالکان گروه تنزیل مقام شدند"
			end
			end
     end
if ((matches[1]:lower() == "setname" and not lang) or (matches[1] == 'تنظیم نام' and lang)) and matches[2] and is_mod(msg) then
local gp_name = matches[2]
tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
end
  if ((matches[1]:lower() == "setabout" and not lang) or (matches[1] == 'تنظیم درباره' and lang)) and matches[2] and is_mod(msg) then
     if msg.to.type == "channel" then
   tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    elseif msg.to.type == "chat" then
    data[tostring(chat)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
     if not lang then
    return "*Group description* _has been set_"
    else
     return "پیام مبنی بر درباره گروه ثبت شد"
      end
  end
  if ((matches[1]:lower() == "about" and not lang) or (matches[1] == 'درباره' and lang)) and msg.to.type == "chat" then
 if not data[tostring(chat)]['about'] then
     if not lang then
     about = "_No_ *description* _available_"
      elseif lang then
      about = "پیامی مبنی بر درباره گروه ثبت نشده است"
       end
        else
     about = "*Group Description :*\n"..data[tostring(chat)]['about']
      end
    return about
  end
  if (matches[1]:lower() == 'filter' and not lang) or (matches[1] == 'فیلتر' and lang) then
    return filter_word(msg, matches[2])
  end
  if (matches[1]:lower() == 'unfilter' and not lang) or (matches[1] == 'حذف فیلتر' and lang) then
    return unfilter_word(msg, matches[2])
  end
  if ((matches[1]:lower() == 'config' and not lang) or (matches[1] == 'پیکربندی' and lang)) and is_admin(msg) then
tdcli.getChannelMembers(msg.to.id, 0, 'Administrators', 200, config_cb, {chat_id=msg.to.id})
  end
  if ((matches[1]:lower() == 'filterlist' and not lang) or (matches[1] == 'لیست فیلتر' and lang)) and is_mod(msg) then
    return filter_list(msg)
  end
if (matches[1]:lower() == "modlist" and not lang) or (matches[1] == 'لیست مدیران' and lang) then
return modlist(msg)
end
if ((matches[1]:lower() == "whitelist" and not lang) or (matches[1] == 'لیست سفید' and lang)) and not matches[2] then
return whitelist(msg.to.id)
end
if ((matches[1]:lower() == "ownerlist" and not lang) or (matches[1] == 'لیست مالکان' and lang)) and is_owner(msg) then
return ownerlist(msg)
end
if ((matches[1]:lower() == "option" and not lang) or (matches[1] == 'تنظیمات کلی' and lang)) and is_mod(msg) then
local function inline_query_cb(arg, data)
      if data.results_ and data.results_[0] then
tdcli.sendInlineQueryResultMessage(msg.to.id, 0, 0, 1, data.inline_query_id_, data.results_[0].id_, dl_cb, nil)
    else
    if not lang then
    text = "*Helper is offline*\n\n"
        elseif lang then
    text = "_ربات هلپرفایر خاموش است_\n\n"
    end
  return tdcli.sendMessage(msg.to.id, msg.id, 0, text..''..group_option(msg, target), 0, "md")
   end
end
tdcli.getInlineQueryResults(388342734, msg.to.id, 0, 0, ''..msg.to.id..' option', 0, inline_query_cb, nil)
end
end
if ((matches[1]:lower() == "settings" and not lang) or (matches[1] == 'تنظیمات' and lang)) and is_mod(msg) then
return group_settings(msg, target)
end
if (matches[1]:lower() == "setlang" and not lang) and is_owner(msg) then
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if matches[2] == "fa" then
redis:set(hash, true)
return "*زبان گروه تنظیم شد به : فارسی*"..MaTaDoRpm
end
end
if (matches[1] == 'زبان انگلیسی' and lang) and is_owner(msg) then
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 redis:del(hash)
return "_Group Language Set To:_ EN"..MaTaDoRpm
end
 if ((matches[1]:lower() == 'mutetime' and not lang) or (matches[1] == 'زمان بیصدا' and lang)) and is_mod(msg) then
local hash = 'muteall:'..msg.to.id
local hour = tonumber(matches[2])
local num1 = (tonumber(hour) * 3600)
local minutes = tonumber(matches[3])
local num2 = (tonumber(minutes) * 60)
local second = tonumber(matches[4])
local num3 = tonumber(second) 
local num4 = tonumber(num1 + num2 + num3)
redis:setex(hash, num4, true)
if not lang then
 return "_Mute all has been enabled for_ \n⏺ *hours :* `"..matches[2].."`\n⏺ *minutes :* `"..matches[3].."`\n⏺ *seconds :* `"..matches[4].."`"..MaTaDoRpm
 elseif lang then
 return "بی صدا کردن فعال شد 🤖✅\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`] در \n⏺ ساعت : "..matches[2].."\n⏺ دقیقه : "..matches[3].."\n⏺ ثانیه : "..matches[4]..MaTaDoRpm
 end
 end
 if ((matches[1]:lower() == 'mutehours' and not lang) or (matches[1]== 'ساعت بیصدا' and lang)) and is_mod(msg) then
       local hash = 'muteall:'..msg.to.id
local hour = matches[2]
local num1 = tonumber(hour) * 3600
local num4 = tonumber(num1)
redis:setex(hash, num4, true)
if not lang then
 return "Mute all has been enabled for \n⏺ hours : "..matches[2]..MaTaDoRpm
 elseif lang then
 return "بی صدا کردن فعال شد 🤖✅\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`] در \n⏺ ساعت : "..matches[2]..MaTaDoRpm
 end
 end
  if ((matches[1]:lower() == 'muteminutes' and not lang) or (matches[1]== 'دقیقه بیصدا' and lang))  and is_mod(msg) then
 local hash = 'muteall:'..msg.to.id
local minutes = matches[2]
local num2 = tonumber(minutes) * 60
local num4 = tonumber(num2)
redis:setex(hash, num4, true)
if not lang then
 return "Mute all has been enabled for \n⏺ minutes : "..matches[2]..MaTaDoRpm
 elseif lang then
 return "بی صدا کردن فعال شد 🤖✅\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`] در \n⏺ دقیقه : "..matches[2]..MaTaDoRpm
 end
 end
  if ((matches[1]:lower() == 'muteseconds' and not lang) or (matches[1] == 'ثانیه بیصدا' and lang))  and is_mod(msg) then
       local hash = 'muteall:'..msg.to.id
local second = matches[2]
local num3 = tonumber(second) 
local num4 = tonumber(num3)
redis:setex(hash, num3, true)
if not lang then
 return "Mute all has been enabled for \n⏺ seconds : "..matches[2]..MaTaDoRpm
 elseif lang then
 return "بی صدا کردن فعال شد 🤖✅\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`] در \n⏺ ثانیه : "..matches[2]..MaTaDoRpm
 end
 end
 if ((matches[1]:lower() == 'muteall' and not lang) or (matches[1] == 'موقعیت' and lang)) and ((matches[2]:lower() == 'status' and not lang) or (matches[2] == 'بیصدا' and lang)) and is_mod(msg) then
         local hash = 'muteall:'..msg.to.id
      local mute_time = redis:ttl(hash)
		
		if tonumber(mute_time) < 0 then
		if not lang then
		return '_Mute All is Disable._'
		else
		return '_بیصدا بودن گروه غیر فعال است  ♻️⚠️._'
		end
		else
		if not lang then
          return mute_time.." Sec"
		  elseif lang then
		  return mute_time.."ثانیه"
		end
		end
  end
--------------------------------
    if (matches[1]:lower() == 'rmsg' or matches[1] == 'پاکسازی') and is_mod(msg) then
        if tostring(msg.to.id):match("^-100") then 
            if tonumber(matches[2]) > 1000 or tonumber(matches[2]) < 1 then
                return  '🚫 *1000*> _تعداد پیام های قابل پاک سازی در هر دفعه_ >*1* 🚫'
            else
			if not lang then  
				tdcli.getChatHistory(msg.to.id, msg.id,0 , 100, delmsg, {msgs=matches[2]})
				return "`"..matches[2].." `A recent message was cleared"
				else
				tdcli.getChatHistory(msg.to.id, msg.id,0 , 100, delmsg, {msgs=matches[2]})
				return "`"..matches[2].." `*پیام اخیر پاکسازی شد*"
				end
            end
        else
            return '⚠️ _این قابلیت فقط در سوپرگروه ممکن است_ ⚠️'
			
        end
    end
--------------------------------
	if matches[1]:lower() == "calc" or matches[1]:lower() == "حساب کن" and matches[2] then 
		if msg.to.type == "pv" then 
			return 
       end
		return calc(matches[2])
	end
--------------------------------
	if matches[1]:lower() == 'praytime' or matches[1]:lower() == 'azan' or matches[1]:lower() == 'ساعات شرعی' or matches[1]:lower() == 'اذان' then
		if matches[2] then
			city = matches[2]
		elseif not matches[2] then
			city = 'Tehran'
		end
		local lat,lng,url	= get_staticmap(city)
		local dumptime = run_bash('date +%s')
		local code = http.request('http://api.aladhan.com/timings/'..dumptime..'?latitude='..lat..'&longitude='..lng..'&timezonestring=Asia/Tehran&method=7')
		local jdat = json:decode(code)
		local data = jdat.data.timings
		local text = 'شهر: '..city
		text = text..'\nاذان صبح: '..data.Fajr
		text = text..'\nطلوع آفتاب: '..data.Sunrise
		text = text..'\nاذان ظهر: '..data.Dhuhr
		text = text..'\nغروب آفتاب: '..data.Sunset
		text = text..'\nاذان مغرب: '..data.Maghrib
		text = text..'\nعشاء : '..data.Isha
		text = text..'\n@tel_fire\n'
		return tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'html')
	end
--------------------------------
	if matches[1]:lower() == 'tophoto' or matches[1]:lower() == "تبدیل به عکس" and msg.reply_id then
		function tophoto(arg, data)
			function tophoto_cb(arg,data)
				if data.content_.sticker_ then
					local file = data.content_.sticker_.sticker_.path_
					local secp = tostring(tcpath)..'/data/sticker/'
					local ffile = string.gsub(file, '-', '')
					local fsecp = string.gsub(secp, '-', '')
					local name = string.gsub(ffile, fsecp, '')
					local sname = string.gsub(name, 'webp', 'jpg')
					local pfile = 'data/photos/'..sname
					local pasvand = 'webp'
					local apath = tostring(tcpath)..'/data/sticker'
					if file_exi(tostring(name), tostring(apath), tostring(pasvand)) then
						os.rename(file, pfile)
						tdcli.sendPhoto(msg.to.id, 0, 0, 1, nil, pfile, "@tel_fire", dl_cb, nil)
					else
						tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This sticker does not exist. Send sticker again._', 1, 'md')
					end
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This is not a sticker._', 1, 'md')
				end
			end
            tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, tophoto_cb, nil)
		end
		tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_id }, tophoto, nil)
    end
--------------------------------
	if matches[1]:lower() == 'tosticker' or matches[1]:lower() == "تبدیل به استیکر" and msg.reply_id then
		function tosticker(arg, data)
			function tosticker_cb(arg,data)
				if data.content_.ID == 'MessagePhoto' then
					file = data.content_.photo_.id_
					local pathf = tcpath..'/data/photo/'..file..'_(1).jpg'
					local pfile = 'data/photos/'..file..'.webp'
					if file_exi(file..'_(1).jpg', tcpath..'/data/photo', 'jpg') then
						os.rename(pathf, pfile)
						tdcli.sendDocument(msg.chat_id_, 0, 0, 1, nil, pfile, '@tel_fire', dl_cb, nil)
					else
						tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This photo does not exist. Send photo again._', 1, 'md')
					end
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This is not a photo._', 1, 'md')
				end
			end
			tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, tosticker_cb, nil)
		end
		tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_id }, tosticker, nil)
    end
--------------------------------
	if matches[1]:lower() == 'weather' or matches[1]:lower() == "اب و هوا" then
		city = matches[2]
		local wtext = get_weather(city)
		if not wtext then
			wtext = 'مکان وارد شده صحیح نیست'
		end
		return wtext
	end
--------------------------------
	if matches[1]:lower() == 'time' or matches[1]:lower() == "ساعت" then
	local url , res = http.request('http://probot.000webhostapp.com/api/time.php/')
if res ~= 200 then return "No connection" end

local jdat = json:decode(url)
local text = '*Ir Time:* _'..jdat.FAtime..'_\n*Ir Data:* _'..jdat.FAdate..'_\n------------\n*En Time:* _'..jdat.ENtime..'_\n *En Data:* _'..jdat.ENdate.. '_\n'
  tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'md')
end
--------------------------------
if matches[1]:lower() == 'voice' or matches[1]:lower() == "تبدیل به صدا" then
 local text = matches[2]
    textc = text:gsub(' ','.')
    
  if msg.to.type == 'pv' then 
      return nil
      else
  local url = "http://tts.baidu.com/text2audio?lan=en&ie=UTF-8&text="..textc
  local file = download_to_file(url,'MR-UniQue.mp3')
 				tdcli.sendDocument(msg.to.id, 0, 0, 1, nil, file, '@tel_fire', dl_cb, nil)
   end
end

 --------------------------------
	if matches[1]:lower() == "tr" or matches[1]:lower() == "ترجمه" then 
		url = https.request('https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160119T111342Z.fd6bf13b3590838f.6ce9d8cca4672f0ed24f649c1b502789c9f4687a&format=plain&lang='..URL.escape(matches[2])..'&text='..URL.escape(matches[3]))
		data = json:decode(url)
		return 'زبان : '..data.lang..'\nترجمه : '..data.text[1]..'\n____________________\n @tel_fire :)'
	end
--------------------------------
if (matches[1]:lower() == 'short' and not Clang) or (matches[1]:lower() == 'لینک کوتاه' and Clang) then
		if matches[2]:match("[Hh][Tt][Tt][Pp][Ss]://") then
			shortlink = matches[2]
		elseif not matches[2]:match("[Hh][Tt][Tt][Pp][Ss]://") then
			shortlink = "https://"..matches[2]
		end
		local yon = http.request('http://api.yon.ir/?url='..URL.escape(shortlink))
		local jdat = json:decode(yon)
		local bitly = https.request('https://api-ssl.bitly.com/v3/shorten?access_token=f2d0b4eabb524aaaf22fbc51ca620ae0fa16753d&longUrl='..URL.escape(shortlink))
		local data = json:decode(bitly)
		local u2s = http.request('http://u2s.ir/?api=1&return_text=1&url='..URL.escape(shortlink))
		local llink = http.request('http://llink.ir/yourls-api.php?signature=a13360d6d8&action=shorturl&url='..URL.escape(shortlink)..'&format=simple')
		local text = ' 🌐لینک اصلی :\n'..check_markdown(data.data.long_url)..'\n\nلینکهای کوتاه شده با 6 سایت کوتاه ساز لینک : \n》کوتاه شده با bitly :\n___________________________\n'..(check_markdown(data.data.url) or '---')..'\n___________________________\n》کوتاه شده با u2s :\n'..(check_markdown(u2s) or '---')..'\n___________________________\n》کوتاه شده با llink : \n'..(check_markdown(llink) or '---')..'\n___________________________\n》لینک کوتاه شده با yon : \nyon.ir/'..(check_markdown(jdat.output) or '---')..'\n____________________'
		return tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'html')
		end
--------------------------------
	if matches[1]:lower() == "sticker" or matches[1]:lower() == "استیکر" then 
		local eq = URL.escape(matches[2])
		local w = "500"
		local h = "500"
		local txtsize = "100"
		local txtclr = "ff2e4357"
		if matches[3] then 
			txtclr = matches[3]
		end
		if matches[4] then 
			txtsize = matches[4]
		end
		if matches[5] and matches[6] then 
			w = matches[5]
			h = matches[6]
		end
		local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"
		local receiver = msg.to.id
		local  file = download_to_file(url,'text.webp')
		tdcli.sendDocument(msg.to.id, 0, 0, 1, nil, file, '', dl_cb, nil)
	end
--------------------------------
	if matches[1]:lower() == "photo" or matches[1]:lower() == "عکس" then 
		local eq = URL.escape(matches[2])
		local w = "500"
		local h = "500"
		local txtsize = "100"
		local txtclr = "ff2e4357"
		if matches[3] then 
			txtclr = matches[3]
		end
		if matches[4] then 
			txtsize = matches[4]
		end
		if matches[5] and matches[6] then 
			w = matches[5]
			h = matches[6]
		end
		local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"
		local receiver = msg.to.id
		local  file = download_to_file(url,'text.jpg')
		tdcli.sendPhoto(msg.to.id, 0, 0, 1, nil, file, "@tel_fire", dl_cb, nil)
	end
	if matches[1]:lower() == "info" or matches[1] == "اطلاعات ایدی" then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, info_by_reply, {chat_id=msg.chat_id_})
  end
  if matches[2] and string.match(matches[2], '^%d+$') and tonumber(msg.reply_to_message_id_) == 0 then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, info_by_id, {chat_id=msg.chat_id_,user_id=matches[2],msgid=msg.id_})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') and tonumber(msg.reply_to_message_id_) == 0 then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, info_by_username, {chat_id=msg.chat_id_,username=matches[2],msgid=msg.id_})
      end
  if not matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
local function info2_cb(arg, data)
      if tonumber(data.id_) then
    if data.username_ then
  username = "@"..check_markdown(data.username_)
    else
  username = ""
  end
    if data.first_name_ then
  firstname = check_markdown(data.first_name_)
    else
  firstname = ""
  end
    if data.last_name_ then
  lastname = check_markdown(data.last_name_)
    else
  lastname = ""
  end
	local hash = 'rank:'..arg.chat_id..':variables'
   local text = "_First name :_ *"..firstname.."*\n_Last name :_ *"..lastname.."*\n_Username :_ "..username.."\n_ID :_ *"..data.id_.."*\n\n"
		    if data.id_ == tonumber(MRoO) then
		       text = text..'_Rank :_ *Executive Admin*\n\n'
			   elseif is_sudo1(data.id_) then
	           text = text..'_Rank :_ *Full Access Admin*\n\n'
		     elseif is_admin1(data.id_) then
		       text = text..'_Rank :_ *Bot Admin*\n\n'
		     elseif is_owner1(arg.chat_id, data.id_) then
		       text = text..'_Rank :_ *Group Owner*\n\n'
		     elseif is_mod1(arg.chat_id, data.id_) then
		       text = text..'_Rank :_ *Group Moderator*\n\n'
		 else
		       text = text..'_Rank :_ *Group Member*\n\n'
		 end
         local user_info = {} 
  local uhash = 'user:'..data.id_
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..data.id_..':'..arg.chat_id
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
  text = text..'Total messages : '..user_info_msgs..'\n'
  text = text..MaTaDoRpm
  tdcli.sendMessage(arg.chat_id, arg.msgid, 0, text, 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = msg.from.id,
  }, info_by_id, {chat_id=msg.chat_id_,user_id=msg.from.id,msgid=msg.id_})
      end
   end
if (matches[1]:lower() == "del" or matches[1] == "حذف")  and msg.reply_to_message_id_ ~= 0 and is_mod(msg) then
        tdcli.deleteMessages(msg.to.id,{[0] = tonumber(msg.reply_id),msg.id})
end
	   if matches[1]:lower() == 'mydel' or matches[1] == 'پاکسازی پیام های من' then  
tdcli.deleteMessagesFromUser(msg.to.id, msg.sender_user_id_, dl_cb, cmd)
     if not lang then   
           tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '*Done :)*', 1, 'md')
		   else
		   tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '_انجام شد :)_', 1, 'md')
	 end
end
if matches[1] == "test" then
            local utf8 = dofile('./data/test.lua')
local id = matches[2]
tdcli_function ({ID="SendMessage", chat_id_=msg.to.id, reply_to_message_id_=msg.id, disable_notification_=0, from_background_=1, reply_markup_=nil, input_message_content_={ID="InputMessageText", text_=matches[3], disable_web_page_preview_=1, clear_draft_=0, entities_={[0] = {ID="MessageEntityMentionName", offset_=0, length_=utf8.len(matches[3]), user_id_=id}}}}, dl_cb, nil)
end
if (matches[1]:lower() == "help" or matches[1] == 'راهنما') and is_mod(msg) then
if not lang then
text = [[
*°•~» !helplock*
> Show locks Help <

*°•~» !helpmute*
> Show mutes Help <

*°•~» !helptools*
> Show Tools Help <

*°•~» !helpfun*
> Show Fun Help <

*°•~» !helpmod*
> Show manag Help <

⚠️This Help List Only For *Fire/Owners!*
🔺Its Means, Only Group  *Fire/Owners* Can Use It!
 *Good luck ;)*
]]
elseif lang then
text = [[
_°•~» راهنما قفلی_
> برای مشاهده دستورات قفل < 

_°•~» راهنما بیصدا_
> برای مشاهده دستورات بیصدا <

_°•~» راهنما ابزار_
> برای مشاهده دستورات سودو ها <

_°•~» !راهنما سرگرمی_
> برای مشاهده دستورات سرگرمی < 

_°•~» راهنما مدیریتی_
> برای مشاهده دستورات مدیریتی گروه <

⚠️_این راهنما فقط برای مدیران/مالکان گروه میباشد!
این به این معناست که فقط مدیران/مالکان گروه میتوانند از دستورات بالا استفاده کنند!_
*موفق باشید ;)*
]]
end
return text
end
-----------------------------------------
if (matches[1]:lower() == "helpmod" or matches[1] == 'راهنما مدیریتی') and is_mod(msg) then
if not lang then
text = [[
*°•~» !setmanager*  `[username|id|reply]`
> _Add manager_ <
*=====================*
*°•~» !Remmanager*  `[username|id|reply]`
> _Remove manager_ <
*=====================*
*°•~» !setowner*  `[username|id|reply]`
> _Set Group owner_ <
*=====================*
*°•~» !remowner*  `[username|id|reply]`
> _Remove User From Ownerist_ <
*=====================*
*°•~» !promote*  `[username|id|reply]`
> _Promote User To Group Admin_ <
*=====================*
*°•~» !demote*  `[username|id|reply]`
> _Demote User From Group Admins List_ <
*=====================*
*°•~» !setflood*  `[2-50]`
> _Set Flooding Number_ <
*=====================*
*°•~» !silent*  `[username|id|reply]`
> _Silent User From Group_ <
*=====================*
*°•~» !unsilent*  `[username|id|reply]`
> _UnSilent User From Group_ <
*=====================*
*°•~» !kick*  `[username|id|reply]`
> _Kick User From Group_ <
*=====================*
*°•~» !ban*  `[username|id|reply]`
> _Ban User From Group_ <
*=====================*
*°•~» !unban*  `[username|id|reply]`
> _UnBan User From Group_ <
*=====================*
*°•~» !res*  `[username]`
> _Show User ID_ <
*=====================*
*°•~» !id*  `[reply]`
> _Show User ID_ <
*=====================*
*°•~» !whois*  `[id]`
> _Show User's Username And Name_ <
*=====================*
*°•~» !clean*  `[bans | mods | rules | about | silentlist | filtelist | welcome | bot | blacklist]`
> _Bot Clean Them_ <
*=====================*
*°•~» !filter*  `[word]`
> _Word filter_ <
*=====================*
*°•~» !unfilter*  `[word]`
> _Word unfilter_ <
*=====================*
*°•~» !pin*  `[reply]`
> _Pin Your Message_ <
*=====================*
*°•~» !unpin*  `[reply]`
> _UnPin Pinned Message_ <
*=====================*
*°•~» !welcome*  enable/disable
> _Enable Or Disable Group Welcome_ <
*=====================*
*°•~» !settings* 
> _Show Group Settings_ <
*=====================*
*°•~» !cmds* `[member | moderator | owner ]`
> _set cmd_ <
*=====================*
*°•~» !whitelist* `[ +  |  - ]`
> _Add User To White List_ <
*=====================*
*°•~» !silentlist*
> _Show Silented Users List_ <
*=====================*
*°•~» !filterlist*
> _Show Filtered Words List_ <
*=====================*
*°•~» !banlist*
> _Show Banned Users List_ <
*=====================*
*°•~» !ownerlist*
> _Show Group Owners List_ <
*=====================* 
*°•~» !whitelist*
> _Show Group whitelist List_ <
*=====================*
*°•~» !modlist*
> _Show Group Fire List_ <
*=====================*
*°•~» !rules*
> _Show Group Rules_ <
*=====================*
*°•~» !about*
> _Show Group Description_ <
*=====================*
*°•~» !del*
> _clear whit reply_ <
*=====================*
*°•~» !id*
> _Show Your And Chat ID_ <
*=====================*
*°•~» !me*
> _Show Your And Chat Me_ <
*=====================*
*°•~» !gpinfo*
> _Show Group Information_ <
*=====================*
*°•~» !newlink*
> _Create A New Link_ <
*=====================*
*°•~» !newlink pv*
> _Create A New Link The Pv_ <
*=====================*
*°•~» !link*
> _Show Group Link_ <
*=====================*
*°•~» !link pv*
> _Send Group Link In Your Private Message_ <
*=====================*
*°•~» !setlang fa*
> _Set Persian Language_ <
*=====================*
*°•~» !setwelcome* `[text]`
> _Set Welcome Message_ <
*=====================*

_You Can Use_ *[!/#]* _To Run The Commands_
_This Help List Only For_ *Fire/Owners!*
_Its Means, Only Group_ *Fire/Owners* _Can Use It!_
*Good luck ;)*]]
elseif lang then
text = [[
*°•~» ادمین گروه* `[username|id|reply]`
> _افزودن ادمین گروه_ <
*=====================*
*°•~» حذف ادمین گروه* `[username|id|reply]`
> _حذف کردن ادمین گروه_ <
*=====================*
*°•~» مالک* `[username|id|reply]`
> _انتخاب مالک گروه_ <
*=====================*
*°•~» حذف مالک* `[username|id|reply]`
> _حذف کردن فرد از فهرست مالکان گروه_ <
*=====================*
*°•~» مدیر* `[username|id|reply]`
> _ارتقا مقام کاربر به مدیر گروه_ <
*=====================*
*°•~» حذف مدیر* `[username|id|reply]`
> _تنزیل مقام مدیر به کاربر_ <
*=====================*
*°•~» تنظیم پیام مکرر* `[2-50]`
> _تنظیم حداکثر تعداد پیام مکرر_ <
*=====================*
*°•~» سکوت* `[username|id|reply]`
> _بیصدا کردن کاربر در گروه_ <
*=====================*
*°•~» حذف سکوت* `[username|id|reply]`
> _در آوردن کاربر از حالت بیصدا در گروه_ <
*=====================*
*°•~»  اخراج* `[username|id|reply]`
> _حذف کاربر از گروه_ <
*=====================*
*°•~»  بن* `[username|id|reply]`
> _مسدود کردن کاربر از گروه_ <
*=====================*
*°•~» حذف بن* `[username|id|reply]`
> _در آوردن از حالت مسدودیت کاربر از گروه_ <
*=====================*
*°•~» کاربری* `[username]`
> _نمایش شناسه کاربر_ <
*=====================*
*°•~» ایدی* `[reply]`
> _نمایش شناسه کاربر_ <
*=====================*
*°•~» شناسه* `[id]`
> _نمایش نام کاربر, نام کاربری و اطلاعات حساب_ <
*=====================*
*°•~» تنظیم* `[قوانین | نام | لینک | درباره | خوش آمد]`
> _ربات آنهارا ثبت خواهد کرد_ <
*=====================*
*°•~» پاک کرد*ن `[قوانین | نام | لینک | درباره | خوشآمد | ربات | لیست سیاه]`
> _ربات آنها را پاک خواهد کرد_ <
*=====================*
*°•~» لیست سفید*  `[ +  |  - ]`
> _افزودن افراد به لیست سفید_ <
*=====================*
*°•~» فیلتر* `[کلمه]`
> _فیلتر کلمه مورد نظر_ <
*=====================*
*°•~» حذف فیلتر* `[کلمه]`
> _ازاد کردن کلمه مورد نظر_ <
*=====================*
*°•~» سنجاق* `[reply]`
> _ربات پیام شمارا در گروه سنجاق خواهد کرد_ <
*=====================*
*°•~» حذف سنجاق*
> _ربات پیام سنجاق شده در گروه را حذف خواهد کرد_ <
*=====================*
*°•~» خوش آمد فعال/غیرفعال*
> _فعال یا غیرفعال کردن خوش آمد گویی_ <
*=====================*
*°•~» تنظیمات*
> _نمایش تنظیمات گروه_ <
*=====================*
*°•~» دستورات* `[کاربر | مدیر | مالک]`
> _انتخاب کردن قفل cmd بر چه مدیریتی_ <
*=====================*
*°•~» لیست سکوت*
> _نمایش فهرست افراد بیصدا_ <
*=====================*
*°•~» فیلتر لیست*
> _نمایش لیست کلمات فیلتر شده_ <
*=====================*
*°•~» لیست سفید*
> _نمایش افراد سفید شده از گروه_ <
*=====================*
*°•~» لیست بن*
> _نمایش افراد مسدود شده از گروه_ <
*=====================*
*°•~» لیست مالکان*
> _نمایش فهرست مالکان گروه_ <
*=====================*
*°•~» لیست مدیراان*
> _نمایش فهرست مدیران گروه_ <
*=====================*
*°•~» قوانین*
> _نمایش قوانین گروه_ <
*=====================*
*°•~» درباره*
> _نمایش درباره گروه_ <
*=====================*
*°•~» حذف*
> _حذف پیام با ریپلای_ <
*=====================*
*°•~» ایدی*
> _نمایش شناسه شما و گروه_ <
*=====================*
*°•~» اطلاعات من*
> _نمایش شناسه شما_ <
*=====================*
*°•~» اطلاعات گروه*
> _نمایش  اطلاعات گروه_ <
*=====================*
*°•~» لینک جدید*
> _ساخت لینک جدید_ <
*=====================*
*°•~» لینک جدید خصوصی*
> _ساخت لینک جدید در پیوی_ <
*=====================*
*°•~» لینک*
> _نمایش لینک گروه_ <
*=====================*
*°•~» لینک خصوصی*
> _ارسال لینک گروه به چت خصوصی شما_ <
*=====================*
*°•~» زبان انگلیسی*
> _تنظیم زبان انگلیسی_ <
*=====================*
*°•~» تنظیم خوش آمد* `[متن]`
> _ثبت پیام خوش آمد گویی_ <
*=====================*

_این راهنما فقط برای مدیران/مالکان گروه میباشد!
این به این معناست که فقط مدیران/مالکان گروه میتوانند از دستورات بالا استفاده کنند!_
*موفق باشید ;)*]]
end
return text
end
if matches[1]:lower() == "helpfun" or matches[1] == "راهنما سرگرمی" then
if not lang then
text = [[
*°•~» Fun Help Commands :*

*°•~» Time*
> _Get time in a sticker_ <
*=====================*
*°•~» Short* `[link]`
> _Make Short URL_ <
*=====================*
*°•~» Voice* `[text]`
> _Convert text to voice_ <
*=====================*
*°•~» Tr* [lang] `[word]`
> _Translates FA to EN and EN to FA_ <
_Example:_
*°•~» _Tr fa hi_
*=====================*
*°•~» Sticker* `[word]`
> _Convert text to sticker_ <
*=====================*
*°•~» Photo* `[word]`
> _Convert text to photo_ <
*=====================*
*°•~» azan* `[city]`
> _Get Azan time for your city_ <
*=====================*
*°•~» !calc `[number]`
> _Calculator_ <
*=====================*
*°•~» !praytime* `[city]`
> _Get Patent (Pray Time)_ <
*=====================*
*°•~» !tosticker* `[reply]`
> _Convert photo to sticker_ <
*=====================*
*°•~» !tophoto* `[reply]`
> _Convert text to photo_ <
*=====================*
*°•~» !weather* `[city]`
> _Get weather_ <
*=====================*
_You can use_ *[!/#]* _at the beginning of commands._ ‼️

*Good luck 😉*]]
else
text = [[
*راهنمای سرگرمی ربات فایر :*

*°•~» ساعت*
> _دریافت ساعت به صورت استیکر_ <
*=====================*
*°•~» لینک کوتاه* `[لینک]`
> _کوتاه کننده لینک_ <
*=====================*
*°•~» تبدیل به صدا* `[متن]`
> _تبدیل متن به صدا_ <
*=====================*
*°•~» ترجمه *`[زبان]` `[کلمه]`
> _ترجمه متن فارسی به انگلیسی و برعکس_ <
_مثال:_
*°•~»* _ترجمه زبان سلام_
*=====================*
*°•~» استیکر* `[کلمه]`
> _تبدیل متن به استیکر_ <
*=====================*
*°•~» عکس *`[کلمه]`
> _تبدیل متن به عکس_ <
*=====================*
*°•~» اذان *`[شهر]`
> _دریافت اذان_ <
*=====================*
*°•~» حساب کن *`[عدد]`
> _ماشین حساب_ <
*=====================*
*°•~» ساعات شرعی* `[شهر]`
> _اعلام ساعات شهری_ <
*=====================*
*°•~» تبدیل به استیکر* `[ریپلی]`
> _تبدیل عکس به استیکر_ <
*=====================*
*°•~» تبدیل به عکس* `[ریپلی]`
> _تبدیل استیکر به عکس_ <
*=====================*
*°•~» اب و هوا* `[شهر]`
> _دریافت اب و هوا_ <
*=====================*

*شما میتوانید از [!/#] در اول دستورات برای اجرای آنها بهره بگیرید*‼️

موفق باشید😉]]
end
return text
end
-----------------------------------------
if (matches[1]:lower() == "helpmute" or matches[1] == 'راهنما بیصدا') and is_mod(msg) then
if not lang then
text = [[

*°•~» !mute*

[`gif ~ photo ~ document ~ sticker ~ keyboard ~ video ~ text ~ forward ~ location ~ audio ~ voice ~ contact ~ all`]

> _If This Actions Lock, Bot Check Actions And Delete Them_ <
*=====================*
*°•~» !unmute*
[`gif ~ photo ~ document ~ sticker ~ keyboard ~ video ~ text ~ forward ~ location ~ audio ~ voice ~ contact ~ all`]

> _If This Actions Unlock, Bot Not Delete Them_ <
*=====================*
*°•~» !mutetime* `[hour : minute : seconds]`

> _Mute group at this time_ <
*=====================*
*°•~» !mutehours* `[number]`

> _Mute group at this time_ <
*=====================*
*°•~» !muteminutes* `[number]`

> _Mute group at this time_ < 
*=====================*
_You Can Use_ *[!/#]* _To Run The Commands_
_This Help List Only For_ *Fire/Owners!*
_Its Means, Only Group_ *Fire/Owners* _Can Use It!_
*Good luck ;)*]]
elseif lang then
text = [[

*°•~» بیصدا*

[`همه ~ تصاویر متحرک ~ عکس ~ اسناد ~ برچسب ~ صفحه کلید ~ فیلم ~ متن ~ نقل قول ~ موقعیت ~ اهنگ ~ صدا ~ مخاطب ~ کیبورد شیشه ای ~ بازی ~ خدمات تلگرام`]

> _در صورت بیصدا بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_ <
*=====================*
*°•~» باصدا*

[`همه ~ تصاویر متحرک ~ عکس ~ اسناد ~ برچسب ~ صفحه کلید ~ فیلم ~ متن ~ نقل قول ~ موقعیت ~ اهنگ ~ صدا ~ مخاطب ~ کیبورد شیشه ای ~ بازی ~ خدمات تلگرام`]

> _در صورت بیصدا نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_ <
*=====================*
*°•~» زمان بیصدا* `[ساعت : دقیقه : ثانیه]`
> _بیصدا کردن گروه با ساعت و دقیقه و ثانیه_ <
*=====================* 
*°•~» ساعت بیصدا* `[عدد]`
> _بیصدا کردن گروه در ساعت_ <
*=====================*
*°•~» دقیقه بیصدا* `[عدد]`
> _بیصدا کردن گروه در دقیقه_ <
*=====================*
*°•~» ثانیه بیصدا* `[عدد]`
> _بیصدا کردن گروه در ثانیه_ <
*=====================* 

_این راهنما فقط برای مدیران/مالکان گروه میباشد!
این به این معناست که فقط مدیران/مالکان گروه میتوانند از دستورات بالا استفاده کنند!_
*موفق باشید ;)*]]
end
return text
end
-----------------------------------------
if (matches[1]:lower() == "helplock" or matches[1] == 'راهنما قفلی') and is_mod(msg) then
if not lang then
text = [[
*°•~» !lock*

[`link ~ join ~ tag ~ username ~ edit ~ arabic ~ webpage ~ bots ~ spam ~ flood ~ markdown ~ mention ~ pin ~ cmds ~ badword ~ username ~ english`]

> _If This Actions Lock, Bot Check Actions And Delete Them_ <
*=====================*
*°•~» !unlock*

[`link ~ join ~ tag ~ username ~ edit ~ arabic ~ webpage ~ bots ~ spam ~ flood ~ markdown ~ mention ~ pin ~ cmds ~ badword ~ username ~ english`]

> _If This Actions Unlock, Bot Not Delete Them_ <
*=====================*
_You Can Use_ *[!/#]* _To Run The Commands_
_This Help List Only For_ *Fire/Owners!*
_Its Means, Only Group_ *Fire/Owners* _Can Use It!_
*Good luck ;)*]]

elseif lang then

text = [[			
*°•~» قفل*

[`لینک ~ ویرایش ~ تگ ~ نام کاربری ~ عربی ~ وب ~ ربات ~ هرزنامه ~ پیام مکرر ~ فراخوانی ~ سنجاق ~ دستورات ~ ورود ~ فونت ~ انگلیسی `]

> _در صورت قفل بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_ <
*=====================*
*°•~» باز*

[`لینک ~ ویرایش ~ تگ ~ نام کاربری ~ عربی ~ وب ~ ربات ~ هرزنامه ~ پیام مکرر ~ فراخوانی ~ سنجاق ~ دستورات ~ ورود ~ فونت ~ انگلیسی`]

> _در صورت باز نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_ <
*=====================*
_این راهنما فقط برای مدیران/مالکان گروه میباشد!
این به این معناست که فقط مدیران/مالکان گروه میتوانند از دستورات بالا استفاده کنند!_

]]
end
return text
end
-----------------------------------------
if (matches[1]:lower() == "helptools" or  matches[1] == "راهنما ابزار") and is_sudo(msg) then
if not lang then
text = [[
̶H̶є̶Ɩ̶ρ̶ ̶S̶υ̶Ɗ̶σ̶ ̶M̶α̶Ƭ̶α̶Ɗ̶σ̶R


*°•~» Sudoset* `[username|id|reply]`
> _Add Sudo_ <
*=====================*
*°•~» Sudodem* `[username|id|reply]`
> _Demote Sudo_ <
*=====================*
*°•~» Sudolist*
> _Sudo(s) list_ <
*=====================*
*°•~» Adminset* `[username|id|reply]`
> _Add admin for bot_ <
*=====================*
*°•~» Admindem* `[username|id|reply]`
> _Demote bot admin_ <
*=====================*
*°•~» Adminlist* 
> _Admin(s) list_ <
*=====================*
*°•~» Leave*
> _Leave current group_ <
*=====================*
*°•~» Autoleave* [disable/enable]
> _Automatically leaves group_ <
*=====================*
*°•~» Creategroup* `[text]`
> _Create normal group_ <
*=====================*
*°•~» Createsuper* `[text]`
> _Create supergroup_ <
*=====================*
*°•~» Tosuper*
> _Convert to supergroup_ <
*=====================*
*°•~» Chats*
> _List of added groups_ <
*=====================*
*°•~» Join* `[id]`
> _Adds you to the group_ <
*=====================*
*°•~» Rem* `[id]`
> _Remove a group from Database_ <
*=====================*
*°•~» Import* `[link]`
> _Bot joins via link_ <
*=====================*
*°•~» Setbotname* `[text]`
> _Change bot's name_ <
*=====================*
*°•~» Setbotusername* `[text]`
> _Change bot's username_ <
*=====================*
*°•~» Delbotusername*
> _Delete bot's username_ <
*=====================*
*°•~» Markread* `[off/on]`
> _Second mark_ <
*=====================*
*°•~» Broadcast* `[text]`
> _Send message to all added groups_ <
*=====================*
*°•~» Bc* [text] `[gpid]`
> _Send message to a specific group_ <
*=====================*
*°•~» Sendfile* `[folder]` `[file]`
> _Send file from folder_ <
*=====================*
*°•~» Sendplug* `[plug]`
> _Send plugin_ <
*=====================*
*°•~» Del* `[Reply]`
> _Remove message Person you ar_ <
*=====================*
*°•~» Save* `[plugin name]` `[reply]`
> _Save plugin by reply_ <
*=====================*
*°•~» Savefile* `[address/filename]` `[reply]`
> _Save File by reply to specific folder_ <
*=====================*
*°•~» Clear cache*
> _Clear All Cache Of .telegram-cli/data_ <
*=====================*
*°•~» Checkexpire*
> _Stated Expiration Date_ <
*=====================*
*°•~» Checkexpire* `[GroupID]`
> _Stated Expiration Date Of Specific Group_ <
*=====================*
*°•~» Charge* `[GroupID]` `[Number Of Days]`
> _Set Expire Time For Specific Group_ <
*=====================*
*°•~» Charge* `[Number Of Days]`
> _Set Expire Time For Group_ <
*=====================*
*°•~» Jointo* `[GroupID]`
> _Invite You To Specific Group_ < 
*=====================*
*°•~» Leave* `[GroupID]`
> _Leave Bot From Specific Group_ <
*=====================*

> ℓαηgυαgє вσт єηgℓιѕн !
To Change The LanGuage
*Setlang* `[en , fa]`

_You can use_ *[!/#]* _at the beginning of commands._ ⛔️

This help is only for sudoers/bot admins. ‼️
 
*This means only the sudoers and its bot admins can use mentioned commands.* 🔖
]]
else
text = [[

̶H̶є̶Ɩ̶ρ̶ ̶S̶υ̶Ɗ̶σ̶ ̶M̶α̶Ƭ̶α̶Ɗ̶σ̶R🔖


*°•~» افزودن سودو* [نام‌کاربری|ریپلای|ایدی]
> _اضافه کردن سودو_ <
*=====================*
*°•~» حذف سودو* [نام‌کاربری|ریپلای|ایدی]
> _حذف کردن سودو_ <
*=====================*
*°•~» لیست سودو* 
> لیست سودو‌های ربات <
*=====================*
*°•~» افزودن ادمین* [نام‌کاربری|ریپلای|ایدی]
> اضافه کردن ادمین به ربات <
*=====================*
*°•~» حذف ادمین* [نام‌کاربری|ریپلای|ایدی]
> حذف فرد از ادمینی ربات <
*=====================*
*°•~» لیست ادمین* 
> لیست ادمین ها <
*=====================*
*°•~» خروج* 
> خارج شدن ربات از گروه <
*=====================*
*°•~» خروج خودکار* [غیرفعال|فعال|موقعیت]
> خروج خودکار <
*=====================*
*°•~» ساخت گروه* [اسم انتخابی]
> ساخت گروه ریلم <
*=====================*
*°•~» ساخت سوپر گروه* [اسم انتخابی]
> ساخت سوپر گروه <
*=====================*
*°•~» تبدیل به سوپر* 
> تبدیل به سوپر گروه <
*=====================*
*°•~» لیست گروه ها*
> لیست گروه های مدیریتی ربات <
*=====================*
*°•~» افزودن* [ایدی گروه]
> جوین شدن توسط ربات <
*=====================*
*°•~» لغو نصب* [ایدی گروه]
> حذف گروه ازطریق پنل مدیریتی <
*=====================*
*°•~» ورود لینک* [لینک]
> جوین شدن ربات توسط لینک <
*=====================*
*°•~» تغییر نام ربات* [متن]
> تغییر اسم ربات <
*=====================*
*°•~» تغییر یوزرنیم ربات* [متن]
> تغییر یوزرنیم ربات <
*=====================*
*°•~» حذف یوزرنیم ربات* 
> پاک کردن یوزرنیم ربات <
*=====================*
*°•~» تیک دوم* [فعال|غیرفعال]
> تیک دوم <
*=====================*
*°•~» ارسال به همه* [متن]
> فرستادن پیام به تمام گروه های مدیریتی ربات <
*=====================*
*°•~» ارسال* [متن] [ایدی گروه]
> ارسال پیام مورد نظر به گروه خاص <
*=====================*
*°•~» ارسال فایل* [پوشه] [فایل]
> ارسال فایل موردنظر از پوشه خاص <
*=====================*
*°•~» ارسال پلاگین* [اسم پلاگین]
> ارسال پلاگ مورد نظر <
*=====================*
*°•~» ذخیره پلاگین* [اسم پلاگین] [ریپلای]
> ذخیره کردن پلاگین <
*=====================*
*°•~» ذخیره فایل* [ادرس/فایل] [ریپلای]
> ذخیره کردن فایل در پوشه مورد نظر <
*=====================*
*°•~» پاک کردن حافظه*
> پاک کردن کش مسیر .telegram-cli/data <
*=====================*
*°•~» اعتبار*
> اعلام تاریخ انقضای گروه <
*=====================*
*°•~» اعتبار* [ایدی گروه]
> اعلام تاریخ انقضای گروه مورد نظر <
*=====================*
*°•~» شارژ* [ایدی گروه] [تعداد روز]
> تنظیم تاریخ انقضای گروه مورد نظر <
*=====================*
*°•~» شارژ* [تعداد روز]
> تنظیم تاریخ انقضای گروه <
*=====================*
*°•~» ورود به* [ایدی گروه]
> دعوت شدن شما توسط ربات به گروه مورد نظر <
*=====================*
*°•~» خروج* [ایدی گروه]
> خارج شدن ربات از گروه مورد نظر <
*=====================*

*شما میتوانید از* [!/#] *در اول دستورات برای اجرای آنها بهره بگیرید* ⛔️

> این راهنما فقط برای *سودو ها/ادمین های* ربات میباشد ! ‼️

*این به این معناست که فقط سودو ها/ادمین های ربات میتوانند از دستورات بالا استفاده کنند !* 🔖
]]
end
return text
end
--------------------- Welcome -----------------------
	if ((matches[1]:lower() == "welcome" and not lang) or (matches[1] == 'خوشآمد' and lang)) and is_mod(msg) then
	if not lang then
		if matches[2]:lower() == "enable" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "yes" then
				return "_Group_ *welcome* `Iѕ AƖяєαɗу ƐηαвƖєɗ` ♻️⚠️"
			else
		data[tostring(chat)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
				return "_Group_ *welcome* `Hαѕ Ɓєєη ƐηαвƖєɗ` 🤖🔇\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
			end
		end
		
		if matches[2]:lower() == "disable" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "no" then
				return "_Group_ *Welcome* `Iѕ AƖяєαɗу ƊιѕαвƖєɗ` ❌🔐"
			else
		data[tostring(chat)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
				return "_Group_ *welcome* `Hαѕ Ɓєєη ƊιѕαвƖєɗ` 🤖🔊\n*OяɗєяƁу :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]"
			end
		end
		else
				if matches[2] == "فعال" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "yes" then
				return "_خوشآمد گویی از قبل فعال بود_"
			else
		data[tostring(chat)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
				return "_خوشآمد گویی فعال شد 🤖✅\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]_"
			end
		end
		
		if matches[2] == "غیرفعال" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "no" then
				return "_خوشآمد گویی از قبل فعال نبود_"
			else
		data[tostring(chat)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
				return "_خوشآمد گویی غیرفعال شد 🤖✅\n*سفارش توسط :* [@"..check_markdown(msg.from.username or '').."*|*`"..msg.from.id.."`]_"
			end
		end
		end
	end
	if ((matches[1]:lower() == "setwelcome" and not lang) or (matches[1] == 'تنظیم خوشآمد' and lang)) and matches[2] and is_mod(msg) then
		data[tostring(chat)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
       if not lang then
		return "_Welcome Message Has Been Set To :_\n*"..matches[2].."*\n\n*You can use :*\n_{gpname} Group Name_\n_{rules} ➣ Show Group Rules_\n_{time} ➣ Show time english _\n_{date} ➣ Show date english _\n_{timefa} ➣ Show time persian _\n_{datefa} ➣ show date persian _\n_{name} ➣ New Member First Name_\n_{username} ➣ New Member Username_"
       else
		return "_پیام خوشآمد گویی تنظیم شد به :_\n*"..matches[2].."*\n\n*شما میتوانید از*\n_{gpname} نام گروه_\n_{rules} ➣ نمایش قوانین گروه_\n_{time} ➣ ساعت به زبان انگلیسی _\n_{date} ➣ تاریخ به زبان انگلیسی _\n_{timefa} ➣ ساعت به زبان فارسی _\n_{datefa} ➣ تاریخ به زبان فارسی _\n_{name} ➣ نام کاربر جدید_\n_{username} ➣ نام کاربری کاربر جدید_\n_استفاده کنید_"
        end
     end 
end
------------------Invite---------------------
function getMessage(chat_id, message_id,cb)
  tdcli_function ({
    ID = "GetMessage",
    chat_id_ = chat_id,
    message_id_ = message_id
  }, cb, nil)
end
-------------------------------------------------------------------------------------------------------------------
function from_username(msg)
  function gfrom_user(extra,result,success)
    if result.username_ then
      F = result.username_
    else
      F = 'nil'
    end
    return F
  end
  local username = getUser(msg.sender_user_id_,gfrom_user)
  return username
end
 --Start Function
  if (matches[1]:lower() == "invite" or matches[1] == "افزودن") and matches[2] and is_owner(msg) then
if string.match(matches[2], '^%d+$') then
tdcli.addChatMember(msg.to.id, matches[2], 0)
end
------------------------Username------------------------------------------------------------------------------------
if (matches[1]:lower() == "invite" or matches[1] == "افزودن") and matches[2] and is_owner(msg) then
if string.match(matches[2], '^.*$') then
function invite_by_username(extra, result, success)
if result.id_ then
tdcli.addChatMember(msg.to.id, result.id_, 5)
end
end
resolve_username(matches[2],invite_by_username)
end
end
------------------------Reply---------------------------------------------------------------------------------------
if (matches[1]:lower() == "invite" or matches[1] == "افزودن") and msg.reply_to_message_id_ ~= 0 and is_owner(msg) then
function inv_reply(extra, result, success)
tdcli.addChatMember(msg.to.id, result.sender_user_id_, 5)
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,inv_reply)
end
end
-----------------------------------------
	 if tonumber(msg.from.id) == SUDO then
if matches[1] == "clear cache" and is_sudo(msg) then
     run_bash("rm -rf ~/.telegram-cli/data/sticker/*")
     run_bash("rm -rf ~/.telegram-cli/data/photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/animation/*")
     run_bash("rm -rf ~/.telegram-cli/data/video/*")
     run_bash("rm -rf ~/.telegram-cli/data/audio/*")
     run_bash("rm -rf ~/.telegram-cli/data/voice/*")
     run_bash("rm -rf ~/.telegram-cli/data/temp/*")
     run_bash("rm -rf ~/.telegram-cli/data/thumb/*")
     run_bash("rm -rf ~/.telegram-cli/data/document/*")
     run_bash("rm -rf ~/.telegram-cli/data/profile_photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/encrypted/*")
    return "*AƖƖ Ƈαcнє Hαѕ Ɓєєη ƇƖєαяєɗ*"
   end
if (matches[1]:lower() == "sudoset" or matches[1] == "افزودن سودو") and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="visudo"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="visudo"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="visudo"})
      end
   end
if (matches[1]:lower() == "sudodem" or matches[1] == "حذف سودو") and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="desudo"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="desudo"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="desudo"})
      end
   end
	if (matches[1]:lower() == "sendfile" or matches[1] == 'ارسال فایل') and matches[2] and matches[3] then
		local send_file = "./"..matches[2].."/"..matches[3]
		tdcli.sendDocument(msg.chat_id_, msg.id_,0, 1, nil, send_file, '@tel_fire', dl_cb, nil)
	end
	if matches[1]:lower() == "sendplug" or matches[1] == 'ارسال پلاگین' and matches[2] then
	    local plug = "./plugins/"..matches[2]..".lua"
		tdcli.sendDocument(msg.chat_id_, msg.id_,0, 1, nil, plug, '@tel_fire', dl_cb, nil)
    end


    if (matches[1]:lower() == 'save' or matches[1] == 'ذخیره پلاگین') and matches[2] and is_sudo(msg) then
        if tonumber(msg.reply_to_message_id_) ~= 0  then
            function get_filemsg(arg, data)
                function get_fileinfo(arg,data)
                    if data.content_.ID == 'MessageDocument' then
                        fileid = data.content_.document_.document_.id_
                        filename = data.content_.document_.file_name_
                        if (filename:lower():match('.lua$')) then
                            local pathf = tcpath..'/data/document/'..filename
                            if pl_exi(filename) then
                                local pfile = 'plugins/'..matches[2]..'.lua'
                                os.rename(pathf, pfile)
                                tdcli.downloadFile(fileid , dl_cb, nil)
                                tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>ƤƖυgιη</b> <code>'..matches[2]..'</code> <b>Hαѕ Ɓєєη Sανєɗ.</b>', 1, 'html')
                            else
                                tdcli.sendMessage(msg.to.id, msg.id_, 1, '`Ƭнιѕ fιƖє ɗσєѕ ησт єxιѕт. Sєηɗ fιƖє αgαιη.`', 1, 'md')
                            end
                        else
                            tdcli.sendMessage(msg.to.id, msg.id_, 1, '`Ƭнιѕ fιƖє ιѕ ησт ƤƖυgιη ƑιƖє.`', 1, 'md')
                        end
                    else
                        return
                    end
                end
                tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, get_fileinfo, nil)
            end
	        tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_to_message_id_ }, get_filemsg, nil)
        end
    end
   if matches[1]:lower() == 'pl' or matches[1] == 'پلاگین' then
  if matches[2] == '+' and matches[4] == 'chat' or matches[4] == 'گروه' then
      if is_mod(msg) then
    local receiver = msg.chat_id_
    local plugin = matches[3]
    print("enable "..plugin..' on this chat')
    return reenable_plugin_on_chat(receiver, plugin, msg)
  end
    end

  if matches[2] == '+' and is_sudo(msg) then 
    local plugin_name = matches[3]
    print("enable: "..matches[3])
    return enable_plugin(plugin_name, msg)
  end
  if matches[2] == '-' and matches[4] == 'chat' or matches[4] == 'گروه' then
      if is_mod(msg) then
    local plugin = matches[3]
    local receiver = msg.chat_id_
    print("disable "..plugin..' on this chat')
    return disable_plugin_on_chat(receiver, plugin, msg)
  end
    end
  if matches[2] == '-' and is_sudo(msg) then 
    if matches[3] == 'plugins' then
		return 'This plugin can\'t be disabled'
    end
    print("disable: "..matches[3])
    return disable_plugin(matches[3], msg)
  end

  if matches[2] == '*' and is_sudo(msg) then
    return reload_plugins(true, msg)
  end
  end
end
if is_sudo(msg) then
if msg.to.type ~= 'pv' then
		if (matches[1]:lower() == 'gid' or matches[1] == 'گروه ایدی') and is_admin(msg) then
			tdcli.sendMessage(msg.to.id, msg.id_, 1, '`'..msg.to.id..'`', 1,'md')
		end
		if (matches[1]:lower() == 'leave' or matches[1] == 'خروج') and matches[2] and is_admin(msg) then
			if lang then
				tdcli.sendMessage(matches[2], 0, 1, 'ربات با دستور سودو از گروه خارج شد.\nبرای اطلاعات بیشتر با سودو تماس بگیرید.', 1, 'md')
				tdcli.changeChatMemberStatus(matches[2], our_id, 'Left', dl_cb, nil)
				tdcli.sendMessage(SUDO, msg.id_, 1, 'ربات با موفقیت از گروه '..matches[2]..' خارج شد.', 1,'md')
			else
				tdcli.sendMessage(matches[2], 0, 1, '`Rσвσт Ɩєfт тнє gяσυρ.`\n*Ƒσя мσяє ιηfσямαтιση cσηтαcт Ƭнє SUƊO.*', 1, 'md')
				tdcli.changeChatMemberStatus(matches[2], our_id, 'Left', dl_cb, nil)
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Robot left from under group successfully:*\n\n`'..matches[2]..'`', 1,'md')
			end
		end
		if (matches[1]:lower() == 'charge' or matches[1] == "شارژ") and matches[2] and matches[3] and is_admin(msg) then
		if string.match(matches[2], '^-%d+$') then
			if tonumber(matches[3]) > 0 and tonumber(matches[3]) < 1001 then
				local extime = (tonumber(matches[3]) * 86400)
				redis:setex('ExpireDate:'..matches[2], extime, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id,true)
				end
				if lang then
					tdcli.sendMessage(SUDO, 0, 1, 'ربات در گروه '..matches[2]..' به مدت '..matches[3]..' روز تمدید گردید.', 1, 'md')
					tdcli.sendMessage(matches[2], 0, 1, 'ربات توسط ادمین به مدت `'..matches[3]..'` روز شارژ شد\nبرای مشاهده زمان شارژ گروه دستور /check استفاده کنید...',1 , 'md')
				else
					tdcli.sendMessage(SUDO, 0, 1, '*Rєcнαяgєɗ ѕυccєѕѕfυƖƖу ιη тнє gяσυρ:* `'..matches[2]..'`\n_Ɛxριяє Ɗαтє:_ `'..matches[3]..'` *Ɗαу(ѕ)*', 1, 'md')
					tdcli.sendMessage(matches[2], 0, 1, '*Rσвσт яєcнαяgєɗ* `'..matches[3]..'` *ɗαу(ѕ)*\n*Ƒσя cнєcкιηg єxριяє ɗαтє, ѕєηɗ* `/cнєcкєxριяє`',1 , 'md')
				end
			else
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`تعداد روزها باید عددی از` *1* `تا` *1000* `باشد.`', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`Ɛxριяє ɗαуѕ мυѕт вє вєтωєєη` *1 - 1000*', 1, 'md')
				end
			end
		end
		end
		if matches[1]:lower() == 'plan' or matches[1] == 'پلن' then
		if matches[2] == '1' and matches[3] and is_admin(msg) then
		if string.match(matches[3], '^-%d+$') then
			local timeplan1 = 2592000
			redis:setex('ExpireDate:'..matches[3], timeplan1, true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, 'پلن 1 با موفقیت برای گروه '..matches[3]..' فعال شد\nاین گروه تا 30 روز دیگر اعتبار دارد! ( 1 ماه )', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '_ربات با موفقیت فعال شد و تا 30 روز دیگر اعتبار دارد!_', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Ƥℓαη 1 Sυccєѕѕƒυℓℓу Acтιναтє∂!\nƬнιѕ gяσυρ яєcнαяgє∂ ωιтн ρℓαη 1 ƒσя 30 ∂αуѕ (1 Mσηтн)*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '*Sυccєѕѕƒυℓℓу яєcнαяgє∂*\n*Ɛχριяє Ɗαтє:* `30` *Ɗαуѕ (1 Mσηтн)*', 1, 'md')
			end
		end
		end
		if matches[2] == '2' and matches[3] and is_admin(msg) then
		if string.match(matches[3], '^-%d+$') then
			local timeplan2 = 7776000
			redis:setex('ExpireDate:'..matches[3],timeplan2,true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
			if lang then
				tdcli.sendMessage(SUDO, 0, 1, 'پلن 2 با موفقیت برای گروه '..matches[3]..' فعال شد\nاین گروه تا 90 روز دیگر اعتبار دارد! ( 3 ماه )', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, 'ربات با موفقیت فعال شد و تا 90 روز دیگر اعتبار دارد! ( 3 ماه )', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Ƥℓαη 2 Sυccєѕѕƒυℓℓу Acтιναтє∂!\nƬнιѕ gяσυρ яєcнαяgє∂ ωιтн ρℓαη 2 ƒσя 90 ∂αуѕ (3 Mσηтн)*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '*Sυccєѕѕƒυℓℓу яєcнαяgє∂*\n*Ɛχριяє Ɗαтє:* `90` *Ɗαуѕ (3 Mσηтнѕ)*', 1, 'md')
			end
		end
		end
		if matches[2] == '3' and matches[3] and is_admin(msg) then
		if string.match(matches[3], '^-%d+$') then
			redis:set('ExpireDate:'..matches[3],true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, 'پلن 3 با موفقیت برای گروه '..matches[3]..' فعال شد\nاین گروه به صورت نامحدود شارژ شد!', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, 'ربات بدون محدودیت فعال شد ! ( نامحدود )', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Ƥℓαη 3 Sυccєѕѕƒυℓℓу Acтιναтє∂!\nƬнιѕ gяσυρ яєcнαяgє∂ ωιтн ρℓαη 3 ƒσя υηℓιмιтє∂*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '*Sυccєѕѕƒυℓℓу яєcнαяgє∂*\n*Ɛχριяє Ɗαтє:* `Uηℓιмιтє∂`', 1, 'md')
			end
		end
		end
		end
end
		if (matches[1]:lower() == 'jointo' or matches[1] == 'ورود به') and matches[2] and is_admin(msg) then
		if string.match(matches[2], '^-%d+$') then
			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, 'با موفقیت تورو به گروه '..matches[2]..' اضافه کردم.', 1, 'md')
				tdcli.addChatMember(matches[2], SUDO, 0, dl_cb, nil)
				tdcli.sendMessage(matches[2], 0, 1, '_سودو به گروه اضافه شد._', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '*I α∂∂є∂ уσυ тσ тнιѕ gяσυρ:*\n\n`'..matches[2]..'`', 1, 'md')
				tdcli.addChatMember(matches[2], SUDO, 0, dl_cb, nil)
				tdcli.sendMessage(matches[2], 0, 1, 'A∂мιη Jσιηє∂!', 1, 'md')
			end
		end
		end
end
	if (matches[1]:lower() == 'savefile' or matches[1] == 'ذخیره فایل') and matches[2] and is_sudo(msg) then
		if msg.reply_id  then
			local folder = matches[2]
            function get_filemsg(arg, data)
				function get_fileinfo(arg,data)
                    if data.content_.ID == 'MessageDocument' or data.content_.ID == 'MessagePhoto' or data.content_.ID == 'MessageSticker' or data.content_.ID == 'MessageAudio' or data.content_.ID == 'MessageVoice' or data.content_.ID == 'MessageVideo' or data.content_.ID == 'MessageAnimation' then
                        if data.content_.ID == 'MessageDocument' then
							local doc_id = data.content_.document_.document_.id_
							local filename = data.content_.document_.file_name_
                            local pathf = tcpath..'/data/document/'..filename
							local cpath = tcpath..'/data/document'
                            if file_exi(filename, cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(doc_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>فایل</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Ƒιℓє</b> <code>'..folder..'</code> <b>Hαѕ Ɓєєη Sανє∂.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Ƭнιѕ ƒιℓє ∂σєѕ ησт єχιѕт. Sєη∂ ƒιℓє αgαιη._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessagePhoto' then
							local photo_id = data.content_.photo_.sizes_[2].photo_.id_
							local file = data.content_.photo_.id_
                            local pathf = tcpath..'/data/photo/'..file..'_(1).jpg'
							local cpath = tcpath..'/data/photo'
                            if file_exi(file..'_(1).jpg', cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(photo_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>عکس</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Ƥнσтσ</b> <code>'..folder..'</code> <b>Hαѕ Ɓєєη Sανє∂.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '*Ƭнιѕ ƒιℓє ∂σєѕ ησт єχιѕт. Sєη∂ ƒιℓє αgαιη.*', 1, 'md')
								end
                            end
						end
		                if data.content_.ID == 'MessageSticker' then
							local stpath = data.content_.sticker_.sticker_.path_
							local sticker_id = data.content_.sticker_.sticker_.id_
							local secp = tostring(tcpath)..'/data/sticker/'
							local ffile = string.gsub(stpath, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(stpath, pfile)
                                file_dl(sticker_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>استیکر</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Sтιcкєя</b> <code>'..folder..'</code> <b>Hαѕ Ɓєєη Sανє∂.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Ƭнιѕ ƒιℓє ∂σєѕ ησт єχιѕт. Sєη∂ ƒιℓє αgαιη._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageAudio' then
						local audio_id = data.content_.audio_.audio_.id_
						local audio_name = data.content_.audio_.file_name_
                        local pathf = tcpath..'/data/audio/'..audio_name
						local cpath = tcpath..'/data/audio'
							if file_exi(audio_name, cpath) then
								local pfile = folder
								os.rename(pathf, pfile)
								file_dl(audio_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>صدای</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Aυ∂ισ</b> <code>'..folder..'</code> <b>Hαѕ Ɓєєη Sανє∂.</b>', 1, 'html')
								end
							else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Ƭнιѕ ƒιℓє ∂σєѕ ησт єχιѕт. Sєη∂ ƒιℓє αgαιη._', 1, 'md')
								end
							end
						end
						if data.content_.ID == 'MessageVoice' then
							local voice_id = data.content_.voice_.voice_.id_
							local file = data.content_.voice_.voice_.path_
							local secp = tostring(tcpath)..'/data/voice/'
							local ffile = string.gsub(file, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(file, pfile)
                                file_dl(voice_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>صوت</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Ʋσιcє</b> <code>'..folder..'</code> <b>Hαѕ Ɓєєη Sανє∂.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Ƭнιѕ ƒιℓє ∂σєѕ ησт єχιѕт. Sєη∂ ƒιℓє αgαιη._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageVideo' then
							local video_id = data.content_.video_.video_.id_
							local file = data.content_.video_.video_.path_
							local secp = tostring(tcpath)..'/data/video/'
							local ffile = string.gsub(file, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(file, pfile)
                                file_dl(video_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>ویديو</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Ʋιɗєσ</b> <code>'..folder..'</code> <b>Hαѕ Ɓєєη Sανє∂.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Ƭнιѕ ƒιℓє ∂σєѕ ησт єχιѕт. Sєη∂ ƒιℓє αgαιη._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageAnimation' then
							local anim_id = data.content_.animation_.animation_.id_
							local anim_name = data.content_.animation_.file_name_
                            local pathf = tcpath..'/data/animation/'..anim_name
							local cpath = tcpath..'/data/animation'
                            if file_exi(anim_name, cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(anim_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>تصویر متحرک</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Ɠιf</b> <code>'..folder..'</code> <b>Hαѕ Ɓєєη Sανє∂.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Ƭнιѕ ƒιℓє ∂σєѕ ησт єχιѕт. Sєη∂ ƒιℓє αgαιη._', 1, 'md')
								end
                            end
						end
                    else
                        return
                    end
                end
                tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, get_fileinfo, nil)
            end
	        tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_to_message_id_ }, get_filemsg, nil)
        end
    end
	if msg.to.type == 'channel' or msg.to.type == 'chat' then
		if (matches[1]:lower() == 'charge' or matches[1] == 'شارژ') and matches[2] and not matches[3] and is_sudo(msg) then
			if tonumber(matches[2]) > 0 and tonumber(matches[2]) < 1001 then
				local extime = (tonumber(matches[2]) * 86400)
				redis:setex('ExpireDate:'..msg.to.id, extime, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id)
				end
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'ربات با موفقیت تنظیم شد\nمدت فعال بودن ربات در گروه به '..matches[2]..' روز دیگر تنظیم شد...', 1, 'md')
					tdcli.sendMessage(SUDO, 0, 1, 'ربات در گروه '..matches[2]..' به مدت `'..msg.to.id..'` روز تمدید گردید.', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'ربات با موفقیت تنظیم شد\nمدت فعال بودن ربات در گروه به '..matches[2]..' روز دیگر تنظیم شد...', 1, 'md')
					tdcli.sendMessage(SUDO, 0, 1, 'ربات در گروه '..matches[2]..' به مدت `'..msg.to.id..'` روز تمدید گردید.', 1, 'md')
				end
			else
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`تعداد روزها باید عددی از` *1* `تا` *1000* `باشد.`', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`Ɛxριяє ɗαуѕ мυѕт вє вєтωєєη` *1 - 1000*', 1, 'md')
				end
			end
		end
		if (matches[1]:lower() == 'checkexpire' or matches[1] == 'اعتبار') and is_mod(msg) and not matches[2] and is_owner(msg) then
			local expi = redis:ttl('ExpireDate:'..msg.to.id)
			if expi == -1 then
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_گروه به صورت نامحدود شارژ میباشد!_', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`UηƖιмιтєɗ Ƈнαяgιηg!`', 1, 'md')
				end
			else
				local day = math.floor(expi / 86400) + 1
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, day..' روز تا اتما شارژ گروه باقی مانده است.', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`'..day..'` *Ɗαу(ѕ) яємαιηιηg υηтιƖ Ɛxριяє.*', 1, 'md')
				end
			end
		end
		end
		if (matches[1]:lower() == 'checkexpire' or matches[1] == 'اعتبار') and is_mod(msg) and matches[2] and is_admin(msg) then
		if string.match(matches[2], '^-%d+$') then
			local expi = redis:ttl('ExpireDate:'..matches[2])
			if expi == -1 then
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_گروه به صورت نامحدود شارژ میباشد!_', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`UηƖιмιтєɗ Ƈнαяgιηg!`', 1, 'md')
				end
			else
				local day = math.floor(expi / 86400 ) + 1
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, day..' روز تا اتما شارژ گروه باقی مانده است.', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`'..day..'` *Ɗαу(ѕ) яємαιηιηg υηтιƖ Ɛxριяє.*', 1, 'md')
				end
			end
		end
	end
if (matches[1]:lower() == "adminset" or matches[1] == "افزودن ادمین") and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="adminprom"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="adminprom"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="adminprom"})
      end
   end
if (matches[1]:lower() == "admindem" or matches[1] == "حذف ادمین") and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.to.id,cmd="admindem"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="admindem"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="admindem"})
      end
   end

if matches[1]:lower() == 'creategroup' or matches[1] == 'ساخت گروه' and is_admin(msg) then
local text = matches[2]
tdcli.createNewGroupChat({[0] = msg.from.id}, text, dl_cb, nil)
  if not lang then
return '_Ɠяσυρ Hαѕ Ɓєєη Ƈяєαтєɗ!_'
  else
return '_گروه ساخته شد!_'
   end
end

if (matches[1]:lower() == 'createsuper' or matches[1] == 'ساخت سوپر گروه') and is_admin(msg) then
local text = matches[2]
tdcli.createNewChannelChat(text, 1, '@tel_fire', (function(b, d) tdcli.addChatMember(d.id_, msg.from.id, 0, dl_cb, nil) end), nil)
   if not lang then 
return '_SυρєяƓяσυρ Hαѕ Ɓєєη Ƈяєαтєɗ αηɗ_ [`'..msg.from.id..'`] _Jσιηєɗ Ƭσ Ƭнιѕ SυρєяƓяσυρ._'
  else
return '_سوپرگروه ساخته شد و_ [`'..msg.from.id..'`] _به گروه اضافه شد._'
   end
end

if (matches[1]:lower() == 'tosuper' or matches[1] == 'تبدیل به سوپر') and is_admin(msg) then
local id = msg.to.id
tdcli.migrateGroupChatToChannelChat(id, dl_cb, nil)
  if not lang then
return '_Ɠяσυρ Hαѕ Ɓєєη Ƈнαηgєɗ Ƭσ SυρєяƓяσυρ!_'
  else
return '_گروه به سوپر گروه تبدیل شد!_'
   end
end

if (matches[1]:lower() == 'import' or matches[1] == 'ورود لینک') and is_admin(msg) then
if matches[2]:match("^([https?://w]*.?telegram.me/joinchat/.*)$") or matches[2]:match("^([https?://w]*.?t.me/joinchat/.*)$") then
local link = matches[2]
if link:match('t.me') then
link = string.gsub(link, 't.me', 'telegram.me')
end
tdcli.importChatInviteLink(link, dl_cb, nil)
   if not lang then
return '*Ɗσηє!*'
  else
return '*انجام شد!*'
  end
  end
end

if (matches[1]:lower() == 'setbotname' or matches[1] == 'تغییر نام ربات') and is_sudo(msg) then
tdcli.changeName(matches[2])
   if not lang then
return '_Ɓσт Ɲαмє Ƈнαηgєɗ Ƭσ:_ *'..matches[2]..'*'
  else
return '_اسم ربات تغییر کرد به:_ \n*'..matches[2]..'*'
   end
end

if (matches[1]:lower() == 'setbotusername' or matches[1] == 'تغییر یوزرنیم ربات') and is_sudo(msg) then
tdcli.changeUsername(matches[2])
   if not lang then
return '_Ɓσт Uѕєяηαмє Ƈнαηgєɗ Ƭσ:_ @'..matches[2]
  else
return '_یوزرنیم ربات تغییر کرد به:_ \n@'..matches[2]..''
   end
end

if (matches[1]:lower() == 'delbotusername' or matches[1] == 'حذف یوزرنیم ربات') and is_sudo(msg) then
tdcli.changeUsername('')
   if not lang then
return '*Ɗσηє!*'
  else
return '*انجام شد!*'
  end
end

if (matches[1]:lower() == 'markread' or matches[1] == 'تیک دوم') and is_sudo(msg) then
if matches[2]:lower() == 'on' or matches[2] == 'فعال' then
redis:set('markread','on')
   if not lang then
return '_Mαякяєαɗ >_ *OƝ*'
else
return '_تیک دوم >_ *روشن*'
   end
end
if matches[2]:lower() == 'off' or matches[2] == 'غیرفعال' then
redis:set('markread','off')
  if not lang then
return '_Mαякяєαɗ >_ *OƑƑ*'
   else
return '_تیک دوم >_ *خاموش*'
      end
   end
end

if (matches[1]:lower() == 'bc' or matches[1] == 'ارسال') and is_admin(msg) then
		local text = matches[2]
tdcli.sendMessage(matches[3], 0, 0, text, 0)	
end

if (matches[1]:lower() == 'broadcast' or matches[1] == 'ارسال به همه') and is_sudo(msg) then		
local data = load_data(_config.moderation.data)		
local bc = matches[2]			
for k,v in pairs(data) do				
tdcli.sendMessage(k, 0, 0, bc, 0)			
end	
end

if (matches[1]:lower() == 'sudolist' or  matches[1] == 'لیست سودو') and is_sudo(msg) then
return sudolist(msg)
    end
if (matches[1]:lower() == 'chats' or matches[1] == 'لیست گروه ها') and is_admin(msg) then
return chat_list(msg)
    end
   if (matches[1]:lower() == 'join' or matches[1] == 'افزودن') and matches[2] and is_admin(msg) and matches[2] then
	   tdcli.sendMessage(msg.to.id, msg.id, 1, 'I Iηνιтє уσυ ιη '..matches[2]..'', 1, 'html')
	   tdcli.sendMessage(matches[2], 0, 1, "Aɗмιη Jσιηєɗ! :)\n@tel_fire", 1, 'html')
    tdcli.addChatMember(matches[2], msg.from.id, 0, dl_cb, nil)
  end
		if (matches[1]:lower() == 'rem' or matches[1] == 'لغو نصب') and matches[2] and is_admin(msg) then
    local data = load_data(_config.moderation.data)
			-- Group configuration removal
			data[tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(_config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
	   tdcli.sendMessage(matches[2], 0, 1, "Ɠяσυρ нαѕ вєєη яємσνєɗ ву αɗмιη cσммαηɗ", 1, 'html')
    return '`Ɠяσυρ` *'..matches[2]..'* `яємσνєɗ`'
		end
if (matches[1]:lower() == 'adminlist' or matches[1] == 'لیست ادمین') and is_admin(msg) then
return adminlist(msg)
    end
     if (matches[1]:lower() == 'leave' or matches[1] == 'خروج') and is_admin(msg) then
  tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
   end
     if (matches[1]:lower() == 'autoleave' or matches[1] == 'خروج خودکار') and is_admin(msg) then
local hash = 'auto_leave_bot'
--Enable Auto Leave
     if matches[2] == 'on' or matches[2] == 'فعال' then
    redis:del(hash)
   return 'Aυтσ Ɩєανє нαѕ вєєη єηαвƖєɗ'
--Disable Auto Leave
     elseif matches[2] == 'off' or matches[2] == 'غیرفعال' then
    redis:set(hash, true)
   return 'Aυтσ Ɩєανє нαѕ вєєη ɗιѕαвƖєɗ'
--Auto Leave Status
      elseif matches[2] == 'status' or  matches[2] == 'موقعیت' then
      if not redis:get(hash) then
   return 'Aυтσ Ɩєανє ιѕ єηαвƖє'
       else
   return 'Aυтσ Ɩєανє ιѕ ɗιѕαвƖє'
         end
      end
   end
   if msg.to.type ~= 'pv' then
 if (matches[1]:lower() == "kick" or matches[1] == "اخراج") and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="kick"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.to.id, userid) then
   if not lang then
     tdcli.sendMessage(msg.to.id, "", 0, "_You can't kick mods,owners or bot admins_", 0, "md")
   elseif lang then
     tdcli.sendMessage(msg.to.id, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*", 0, "md")
         end
     else
kick_user(matches[2], msg.to.id)
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="kick"})
         end
      end
 if (matches[1]:lower() == "delall" or matches[1] == "حذف پیام") and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="delall"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.to.id, userid) then
   if not lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "_You can't delete messages mods,owners or bot admins_", 0, "md")
     elseif lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "*شما نمیتوانید پیام های مدیران،صاحبان گروه و ادمین های ربات رو پاک کنید*", 0, "md")
   end
     else
tdcli.deleteMessagesFromUser(msg.to.id, matches[2], dl_cb, nil)
    if not lang then
  return tdcli.sendMessage(msg.to.id, "", 0, "_AƖƖ_ *мєѕѕαgєѕ* _σf_ *[ "..matches[2].." ]* _нαѕ вєєη_ *ɗєƖєтєɗ*", 0, "md")
   elseif lang then
  return tdcli.sendMessage(msg.to.id, "", 0, "*تمامی پیام های* *[ "..matches[2].." ]* *پاک شد*", 0, "md")
         end
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="delall"})
         end
      end
   end
 if (matches[1]:lower() == "banall" or matches[1] == "سوپر بن") and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="banall"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_admin1(userid) then
   if not lang then
    return tdcli.sendMessage(msg.to.id, "", 0, "_You can't globally ban other admins_", 0, "md")
else
    return tdcli.sendMessage(msg.to.id, "", 0, "*شما نمیتوانید ادمین های ربات رو از گروه های ربات محروم کنید*", 0, "md")
        end
     end
   if is_gbanned(matches[2]) then
   if not lang then
  return tdcli.sendMessage(msg.to.id, "", 0, "*User "..matches[2].." is already globally banned*", 0, "md")
    else
  return tdcli.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از گروه های ربات محروم بود*", 0, "md")
        end
     end
  data['gban_users'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
kick_user(matches[2], msg.to.id)
   if not lang then
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "*User "..matches[2].." has been globally banned*", 0, "md")
    else
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." از تمام گروه هار ربات محروم شد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="banall"})
      end
   end
 if (matches[1]:lower() == "unbanall" or matches[1] == "حذف سوپر بن") and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="unbanall"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_gbanned(matches[2]) then
     if not lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "*User "..matches[2].." is not globally banned*", 0, "md")
    else
   return tdcli.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از گروه های ربات محروم نبود*", 0, "md")
        end
     end
  data['gban_users'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
   if not lang then
return tdcli.sendMessage(msg.to.id, msg.id, 0, "*User "..matches[2].." has been globally unbanned*", 0, "md")
   else
return tdcli.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." از محرومیت گروه های ربات خارج شد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="unbanall"})
      end
   end
   if msg.to.type ~= 'pv' then
 if matches[1]:lower() == "ban" or matches[1] == "بن" and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="ban"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.to.id, userid) then
     if not lang then
    return tdcli.sendMessage(msg.to.id, "", 0, "_You can't ban mods,owners or bot admins_", 0, "md")
    else
    return tdcli.sendMessage(msg.to.id, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو از گروه محروم کنید*", 0, "md")
        end
     end
   if is_banned(matches[2], msg.to.id) then
   if not lang then
  return tdcli.sendMessage(msg.to.id, "", 0, "_User "..matches[2].." is already banned_", 0, "md")
  else
  return tdcli.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از گروه محروم بود*", 0, "md")
        end
     end
data[tostring(chat)]['banned'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
kick_user(matches[2], msg.to.id)
   if not lang then
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "_User "..matches[2].." has been banned_", 0, "md")
  else
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." از گروه محروم شد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
     tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="ban"})
      end
   end
 if (matches[1]:lower() == "unban" or matches[1] == "حذف بن") and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="unban"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_banned(matches[2], msg.to.id) then
   if not lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "_User "..matches[2].." is not banned_", 0, "md")
  else
   return tdcli.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از گروه محروم نبود*", 0, "md")
        end
     end
data[tostring(chat)]['banned'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
   if not lang then
return tdcli.sendMessage(msg.to.id, msg.id, 0, "_User "..matches[2].." has been unbanned_", 0, "md")
   else
return tdcli.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." از محرومیت گروه خارج شد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="unban"})
      end
   end
 if (matches[1]:lower() == "silent" or matches[1] == "سکوت") and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="silent"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.to.id, userid) then
   if not lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "_You can't silent mods,leaders or bot admins_", 0, "md")
 else
   return tdcli.sendMessage(msg.to.id, "", 0, "*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه و ادمین های ربات بگیرید*", 0, "md")
        end
     end
   if is_silent_user(matches[2], chat) then
   if not lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "_User "..matches[2].." is already silent_", 0, "md")
   else
   return tdcli.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از قبل توانایی چت کردن رو نداشت*", 0, "md")
        end
     end
data[tostring(chat)]['is_silent_users'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
    if not lang then
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "_User "..matches[2].." added to silent users list_", 0, "md")
  else
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." توانایی چت کردن رو از دست داد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="silent"})
      end
   end
 if (matches[1]:lower() == "unsilent" or matches[1] == "حذف سکوت") and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="unsilent"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_silent_user(matches[2], chat) then
     if not lang then
     return tdcli.sendMessage(msg.to.id, "", 0, "_User "..matches[2].." is not silent_", 0, "md")
   else
     return tdcli.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از قبل توانایی چت کردن رو داشت*", 0, "md")
        end
     end
data[tostring(chat)]['is_silent_users'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
   if not lang then
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "_User "..matches[2].." removed from silent users list_", 0, "md")
  else
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." توانایی چت کردن رو به دست آورد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="unsilent"})
      end
   end
		if (matches[1]:lower() == 'clean' or matches[1] == "پاک کردن") and is_owner(msg) then
		if not lang then
			if matches[2]:lower() == 'bans' then
				if next(data[tostring(chat)]['banned']) == nil then

					return "_No_ *banned* _users in this group_"
				end
				for k,v in pairs(data[tostring(chat)]['banned']) do
					data[tostring(chat)]['banned'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_All_ *banned* _users has been unbanned_"
			end
			if matches[2]:lower() == 'silentlist' then
				if next(data[tostring(chat)]['is_silent_users']) == nil then
					return "_No_ *silent* _users in this group_"
				end
				for k,v in pairs(data[tostring(chat)]['is_silent_users']) do
					data[tostring(chat)]['is_silent_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				    end
				return "*Silent list* _has been cleaned_"
			    end
				else
				
			if matches[2] == 'لیست بن' then
				if next(data[tostring(chat)]['banned']) == nil then
					return "*هیچ کاربری از این گروه محروم نشده*"
				end
				for k,v in pairs(data[tostring(chat)]['banned']) do
					data[tostring(chat)]['banned'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*تمام کاربران محروم شده از گروه از محرومیت خارج شدند*"
			end
			if matches[2] == 'لیست سکوت' then
				if next(data[tostring(chat)]['is_silent_users']) == nil then
					return "*لیست کاربران سایلنت شده خالی است*"
				end
				for k,v in pairs(data[tostring(chat)]['is_silent_users']) do
					data[tostring(chat)]['is_silent_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				    end
				return "*لیست کاربران سایلنت شده پاک شد*"
			    end
        end
		end
     end
		if (matches[1]:lower() == 'clean' or matches[1]:lower() == 'پاک کردن') and is_sudo(msg) then
		if not lang then
			if matches[2]:lower() == 'gbans' then
				if next(data['gban_users']) == nil then
					return "_No_ *globally banned* _users available_"
				end
				for k,v in pairs(data['gban_users']) do
					data['gban_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_All_ *globally banned* _users has been unbanned_"
			end
			else
		if matches[2] == 'لیست سوپر بن' then
				if next(data['gban_users']) == nil then
					return "*هیچ کاربری از گروه های ربات محروم نشده*"
				end
				for k,v in pairs(data['gban_users']) do
					data['gban_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*تمام کاربرانی که از گروه های ربات محروم بودند از محرومیت خارج شدند*"
			end
			end
     end
if matches[1]:lower() == "gbanlist" and is_admin(msg) or matches[1] == "لیست سوپر بن" and is_admin(msg) then
  return gbanned_list(msg)
 end
   if msg.to.type ~= 'pv' then
if matches[1]:lower() == "silentlist" and is_mod(msg) or matches[1] == "لیست سکوت" and is_mod(msg) then
  return silent_users_list(chat)
 end
if matches[1]:lower() == "banlist" and is_mod(msg) or matches[1] == "لیست بن" and is_mod(msg) then
  return banned_list(chat)
     end
  end
  if (matches[1]:lower() == 'plist' or matches[1] == 'لیست پلاگین') and is_sudo(msg) then
    return list_all_plugins(false, msg)
  end
    if (matches[1]:lower() == 'reload' or matches[1] == 'بارگذاری') and is_sudo(msg) then
    return reload_plugins(true, msg)
  end
if matches[1]:lower() == 'matador' or matches[1] == 'فایر' then
return tdcli.sendMessage(msg.to.id, msg.id, 1, _config.info_text, 1, 'html')
end
end
----------------------------------------
return {
patterns ={
command .. "([Oo]ption)$",
command .. "([Ii]d)$",
command .. "([Mm][Ee])$",
command .. "([Aa]dd)$",
command .. "([Rr]em)$",
command .. "([Ii]d) (.*)$",
command .. "([Pp]in)$",
command .. "([Uu]npin)$",
command .. "([Gg]pinfo)$",
command .. "([Ss]etmanager)$",
command .. "([Ss]etmanager) (.*)$",
command .. "([Rr]emmanager)$",
command .. "([Rr]emmanager) (.*)$",
command .. "([Ww]hitelist) ([+-])$",
command .. "([Ww]hitelist) ([+-]) (.*)$",
command .. "([Ww]hitelist)$",
command .. "([Ss]etowner)$",
command .. "([Ss]etowner) (.*)$",
command .. "([Rr]emowner)$",
command .. "([Rr]emowner) (.*)$",
command .. "([Pp]romote)$",
command .. "([Pp]romote) (.*)$",
command .. "([Dd]emote)$",
command .. "([Dd]emote) (.*)$",
command .. "([Mm]odlist)$",
command .. "([Oo]wnerlist)$",
command .. "([Ll]ock) (.*)$",
command .. "([Uu]nlock) (.*)$",
command .. "([Mm]ute) (.*)$",
command .. "([Uu]nmute) (.*)$",
command .. "([Ll]ink)$",
command .. "([Ll]ink) (pv)$",
command .. "([Ss]etlink)$",
command .. "([Ss]etlink) ([https?://w]*.?telegram.me/joinchat/%S+)$",
command .. "([Ss]etlink) ([https?://w]*.?t.me/joinchat/%S+)$",
command .. "([Nn]ewlink)$",
command .. "([Nn]ewlink) (pv)$",  
command .. "([Rr]ules)$",
command .. "([Ss]ettings)$",
command .. "([Ss]etrules) (.*)$",
command .. "([Aa]bout)$",
command .. "([Ss]etabout) (.*)$",
command .. "([Ss]etname) (.*)$",
command .. "([Cc]lean) (.*)$",
command .. "([Ss]etflood) (%d+)$",
command .. "([Ss]etchar) (%d+)$",
command .. "([Ss]etfloodtime) (%d+)$",
command .. "([Rr]es) (.*)$",
command .. "([Cc]mds) (.*)$",
command .. "([Ww]hois) (%d+)$",
command .. "([Hh]elp)$",
command .. "([Ss]etlang) (fa)$",
command .. "([Ff]ilter) (.*)$",
command .. "([Uu]nfilter) (.*)$",
command .. "([Ff]ilterlist)$",
command .. "([Cc]onfig)$",
command .. "([Ss]etwelcome) (.*)",
command .. "([Ww]elcome) (.*)$",
command .. "([Hh]elpfun)$",
command .. "([Ww]eather) (.*)$",
command .. "([Cc]alc) (.*)$",
command .. "([Tt]ime)$",
command .. "([Tt]ophoto)$",
command .. "([Tt]osticker)$",
command .. "([Vv]oice) +(.*)$",
command .. "([Pp]raytime) (.*)$",
command .. "([Pp]raytime)$",
command .. "([Aa]zan) (.*)$",
command .. "([Aa]zan)$",
command .. "([Tt]r) ([^%s]+) (.*)$",
command .. "([Ss]hort) (.*)$",
command .. "([Pp]hoto) (.+)$",
command .. "([Ss]ticker) (.+)$",
command .. "([Hh]elptools)$", 
command .. "([Hh]elpmod)$", 
command .. "([Hh]elpmute)$", 
command .. "([Hh]elplock)$", 
command .. "([Ss]udoset)$", 
command .. "([Ss]udodem)$",
command .. "([Ss]udolist)$",
command .. "([Ss]udoset) (.*)$", 
command .. "([Ss]udodem) (.*)$",
command .. "([Aa]dminset)$", 
command .. "([Aa]dmindem)$",
command .. "([Aa]dminlist)$",
command .. "([Aa]dminprom) (.*)$", 
command .. "([Aa]dmindem) (.*)$",
command .. "([Ll]eave)$",
command .. "([Aa]utoleave) (.*)$", 
command .. "([Mm]atador)$",
command .. "([Cc]reategroup) (.*)$",
command .. "([Cc]reatesuper) (.*)$",
command .. "([Tt]osuper)$",
command .. "([Cc]hats)$",
command .. "([Mm]ydel)$",
command .. "([Cc]lear cache)$",
command .. "([Jj]oin) (-%d+)$",
command .. "([Rr]em) (-%d+)$",
command .. "([Ii]mport) (.*)$",
command .. "([Ss]etbotname) (.*)$",
command .. "([Ss]etbotusername) (.*)$",
command .. "([Dd]elbotusername) (.*)$",
command .. "([Mm]arkread) (.*)$",
command .. "([Bb]c) +(.*) (-%d+)$",
command .. "([Bb]roadcast) (.*)$",
command .. "([Ss]endfile) (.*) (.*)$",
command .. "([Ss]ave) (.*)$",
command .. "([Ss]endplug) (.*)$",
command .. "([Ss]avefile) (.*)$",
command .. "([Gg]id)$",
command .. "([Cc]heckexpire)$",
command .. "([Ii]nvite) @(.*)$",
command .. "([Ii]nvite) (.*)$",
command .. "([Ii]nvite)$",
command .. "([Cc]heckexpire) (-%d+)$",
command .. "([Cc]harge) (-%d+) (%d+)$",
command .. "([Cc]harge) (%d+)$",
command .. "([Jj]ointo) (-%d+)$",
command .. "([Ll]eave) (-%d+)$",
command .. "([Pp]lan) ([123]) (-%d+)$",
command .. "([Bb]anall)$",
command .. "([Bb]anall) (.*)$",
command .. "([Uu]nbanall)$",
command .. "([Uu]nbanall) (.*)$",
command .. "([Gg]banlist)$",
command .. "([Bb]an)$",
command .. "([Bb]an) (.*)$",
command .. "([Uu]nban)$",
command .. "([Uu]nban) (.*)$",
command .. "([Bb]anlist)$",
command .. "([Ss]ilent)$",
command .. "([Ss]ilent) (.*)$",
command .. "([Uu]nsilent)$",
command .. "([Uu]nsilent) (.*)$",
command .. "([Ss]ilentlist)$",
command .. "([Kk]ick)$",
command .. "([Kk]ick) (.*)$",
command .. "([Dd]elall)$",
command .. "([Dd]elall) (.*)$",
command .. "([Dd][Ee][Ll]) (%d*)$",
command .. "([Rr]msg)$",
command .. "([Cc]lean) (.*)$",
command .. "([Pp]list)$",
command .. "([Pp]l) (+) ([%w_%.%-]+)$",
command .. "([Pp]l) (-) ([%w_%.%-]+)$",
command .. "([Pp]l) (+) ([%w_%.%-]+) (chat)$",
command .. "([Pp]l) (-) ([%w_%.%-]+) (chat)$",
command .. "([Pp]l) (*)$",
command .. "([Rr]eload)$",
command .. "([Ii]nfo)$",
command .. "([Ii]nfo) (.*)$",
command .. '([Mm]uteall) (status)$',
command .. '([Hh]elpmute)$',
command .. '([Mm]utetime) (%d+) (%d+) (%d+)$',
command .. '([Mm]utehours) (%d+)$',
command .. '([Mm]uteminutes) (%d+)$',
command .. '([Mm]uteseconds) (%d+)$',
 "^([https?://w]*.?telegram.me/joinchat/%S+)$",
 "^([https?://w]*.?t.me/joinchat/%S+)$",
 "^([Ii][Dd])$",
 "^([Mm][Ee])$",
 "^([Oo][Pp][Tt][Ii][Oo][Nn])$",
 "^([Aa][Dd][Dd])$",
 "^([Rr][Ee][Mm])$",
 "^([Ii][Dd]) (.*)$",
 "^([Pp][Ii][Nn])$",
 "^([Uu][Nn][Pp][Ii][Nn])$",
 "^([Gg][Pp][Ii][Nn][Ff][Oo])$",
 "^([Ss][Ee][Tt][Mm][Aa][Nn][Aa][Gg][Ee][Rr])$",
 "^([Ss][Ee][Tt][Mm][Aa][Nn][Aa][Gg][Ee][Rr]) (.*)$",
 "^([Rr][Ee][Mm][Mm][Aa][Nn][Aa][Gg][Ee][Rr])$",
 "^([Rr][Ee][Mm][Mm][Aa][Nn][Aa][Gg][Ee][Rr]) (.*)$",
 "^([Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt]) ([+-])$",
 "^([Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt]) ([+-]) (.*)$",
 "^([Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt])$",
 "^([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr])$",
 "^([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr]) (.*)$",
 "^([Rr][Ee][Mm][Oo][Ww][Nn][Ee][Rr])$",
 "^([Rr][Ee][Mm][Oo][Ww][Nn][Ee][Rr]) (.*)$",
 "^([Pp][Rr][Oo][Mm][Oo][Tt][Ee])$",
 "^([Pp][Rr][Oo][Mm][Oo][Tt][Ee]) (.*)$",
 "^([Dd][Ee][Mm][Oo][Tt][Ee])$",
 "^([Dd][Ee][Mm][Oo][Tt][Ee]) (.*)$",
 "^([Mm][Oo][Dd][Ll][Ii][Ss][Tt])$",
 "^([Oo][Ww][Nn][Ee][Rr][Ll][Ii][Ss][Tt])$",
 "^([Ll][Oo][Cc][Kk]) (.*)$",
 "^([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$",
 "^([Mm][Uu][Tt][Ee]) (.*)$",
 "^([Uu][Nn][Mm][Uu][Tt][Ee]) (.*)$",
 "^([Ll][Ii][Nn][Kk])$",
 "^([Ll][Ii][Nn][Kk]) (pv)$",
 "^([Ss][Ee][Tt][Ll][Ii][Nn][Kk])$",
 "^([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([https?://w]*.?telegram.me/joinchat/%S+)$",
 "^([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([https?://w]*.?[Tt].me/joinchat/%S+)$",
 "^([Nn][Ee][Ww][Ll][Ii][Nn][Kk])$",
 "^([Nn][Ee][Ww][Ll][Ii][Nn][Kk]) (pv)$",  
 "^([Rr][Uu][Ll][Ee][Ss])$",
 "^([Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss])$",
 "^([Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss]) (.*)$",
 "^([Aa][Bb][Oo][Uu][Tt])$",
 "^([Ss][Ee][Tt][Aa][Bb][Oo][Uu][Tt]) (.*)$",
 "^([Ss][Ee][Tt][Nn][Aa][Mm][Ee]) (.*)$",
 "^([Cc][Ll][Ee][Aa][Nn]) (.*)$",
 "^([Ss][Ee][Tt][Ff][Ll][Oo][Oo][Dd]) (%d+)$",
 "^([Ss][Ee][Tt][Cc][Hh][Aa][Rr]) (%d+)$",
 "^([Ss][Ee][Tt][Ff][Ll][Oo][Oo][Dd][Tt][Ii][Mm][Ee]) (%d+)$",
 "^([Rr][Ee][Ss]) (.*)$",
 "^([Cc][Mm][Dd][Ss]) (.*)$",
 "^([Ww][Hh][Oo][Ii][Ss]) (%d+)$",
 "^([Hh][Ee][Ll][Pp])$",
 "^([Ss][Ee][Tt][Ll][Aa][Nn][Gg]) (fa)$",
 "^([Ff][Ii][Ll][Tt][Ee][Rr]) (.*)$",
 "^([Uu][Nn][Ff][Ii][Ll][Tt][Ee][Rr]) (.*)$",
 "^([Ff][Ii][Ll][Tt][Ee][Rr][Ll][Ii][Ss][Tt])$",
 "^([Cc][Oo][Nn][Ff][Ii][Gg])$",
 "^([Ss][Ee][Tt][Ww][Ee][Ll][Cc][Oo][Mm][Ee]) (.*)",
 "^([Ww][Ee][Ll][Cc][Oo][Mm][Ee]) (.*)",
 "^([Hh]elpfun)$",
 "^([Ww]eather) (.*)$",
 "^([Cc]alc) (.*)$",
 "^([Tt]est) (.*) (.*)$",
 "^([Tt]ime)$",
 "^([Tt]ophoto)$",
 "^([Tt]osticker)$",
 "^([Vv]oice) +(.*)$",
 "^([Pp]raytime) (.*)$",
 "^([Pp]raytime)$",
 "^([Aa]zan) (.*)$",
 "^([Aa]zan)$",
 "^([Tt]r) ([^%s]+) (.*)$",
 "^([Ss]hort) (.*)$",
 "^([Pp]hoto) (.+)$",
 "^([Ss]ticker) (.+)$",
 "^([Hh]elptools)$", 
 "^([Ss]udoset)$", 
 "^([Ss]udodem)$",
 "^([Ss]udolist)$",
 "^([Ss]udoset) (.*)$", 
 "^([Ss]udodem) (.*)$",
 "^([Aa]dminset)$", 
 "^([Aa]dmindem)$",
 "^([Aa]dminlist)$",
 "^([Aa]dminset) (.*)$", 
 "^([Aa]dmindem) (.*)$",
 "^([Ll]eave)$",
 "^([Aa]utoleave) (.*)$",
 "^([Cc]reategroup) (.*)$",
 "^([Cc]reatesuper) (.*)$",
 "^([Tt]osuper)$",
 "^([Cc]hats)$",
 "^([Mm]ydel)$",
 "^([Cc]lear cache)$",
 "^([Jj]oin) (-%d+)$",
 "^([Rr]em) (-%d+)$",
 "^([Ii]mport) (.*)$",
 "^([Ss]etbotname) (.*)$",
 "^([Ss]etbotusername) (.*)$",
 "^([Dd]elbotusername) (.*)$",
 "^([Mm]arkread) (.*)$",
 "^([Bb]c) +(.*) (-%d+)$",
 "^([Bb]roadcast) (.*)$",
 "^([Ss]endfile) (.*) (.*)$",
 "^([Ss]ave) (.*)$",
 "^([Ss]endplug) (.*)$",
 "^([Ss]avefile) (.*)$",
 "^([Mm]atador)$",
 "^([Gg]id)$",
 "^([Cc]heckexpire)$",
 "^([Cc]heckexpire) (-%d+)$",
 "^([Cc]harge) (-%d+) (%d+)$",
 "^([Cc]harge) (%d+)$",
 "^([Jj]ointo) (-%d+)$",
 "^([Ll]eave) (-%d+)$",
 "^([Pp]lan) ([123]) (-%d+)$",
 "^([Bb]anall)$",
 "^([Bb]anall) (.*)$",
 "^([Uu]nbanall)$",
 "^([Uu]nbanall) (.*)$",
 "^([Gg]banlist)$",
 "^([Bb]an)$",
 "^([Bb]an) (.*)$",
 "^([Uu]nban)$",
 "^([Uu]nban) (.*)$",
 "^([Bb]anlist)$",
 "^([Ss]ilent)$",
 "^([Ii][Nn][Vv][Ii]te)$", 
 "^([Ii][Nn][Vv][Ii][Tt][Ee]) @(.*)$",
 "^([Ii][Nn][Vv][Ii][Tt][Ee]) (.*)$",
 "^([Ss]ilent) (.*)$",
 "^([Uu]nsilent)$",
 "^([Uu]nsilent) (.*)$",
 "^([Ss]ilentlist)$",
 "^([Kk]ick)$",
 "^([Kk]ick) (.*)$",
 "^([Dd]elall)$",
 "^([Rr]msg) (%d*)$",
 "^([Dd]elall) (.*)$",
 "^([Dd]el)$",
 "^([Ii]nfo)$",
 "^([Ii]nfo) (.*)$",
 "^([Pp]list)$",
 "^([Pp]l) (+) ([%w_%.%-]+)$",
 "^([Pp]l) (-) ([%w_%.%-]+)$",
 "^([Pp]l) (+) ([%w_%.%-]+) (chat)$",
 "^([Pp]l) (-) ([%w_%.%-]+) (chat)$",
 "^([Pp]l) (*)$",
 "^([Rr]eload)$",
 "^([Hh]elpmod)$", 
 "^([Hh]elpmute)$", 
 "^([Hh]elplock)$", 
 '^([Mm]uteall) (status)$',
 '^([Hh]elpmute)$',
 '^([Mm]utetime) (%d+) (%d+) (%d+)$',
 '^([Mm]utehours) (%d+)$',
 '^([Mm]uteminutes) (%d+)$',
 '^([Mm]uteseconds) (%d+)$',
},
patterns_fa = {
'^(تنظیمات کلی)$',
'^(ایدی)$',
'^(اطلاعات من)$',
'^(ایدی) (.*)$',
'^(تنظیمات)$',
'^(سنجاق)$',
'^(حذف سنجاق)$',
'^(نصب)$',
'^(لغو نصب)$',
'^(ادمین گروه)$',
'^(ادمین گروه) (.*)$',
'^(حذف ادمین گروه) (.*)$',
'^(حذف ادمین گروه)$',
'^(لیست سفید) ([+-]) (.*)$',
'^(لیست سفید) ([+-])$',
'^(لیست سفید)$',
'^(مالک)$',
'^(مالک) (.*)$',
'^(حذف مالک) (.*)$',
'^(حذف مالک)$',
'^(مدیر)$',
'^(مدیر) (.*)$',
'^(حذف مدیر)$',
'^(حذف مدیر) (.*)$',
'^(قفل) (.*)$',
'^(باز) (.*)$',
'^(بیصدا) (.*)$',
'^(باصدا) (.*)$',
'^(لینک جدید)$',
'^(لینک جدید) (خصوصی)$',
'^(اطلاعات گروه)$',
'^(دستورات) (.*)$',
'^(قوانین)$',
'^(لینک)$',
'^(تنظیم لینک)$',
'^(تنظیم لینک) ([https?://w]*.?telegram.me/joinchat/%S+)$',
'^(تنظیم لینک) ([https?://w]*.?t.me/joinchat/%S+)$',
'^(تنظیم قوانین) (.*)$',
'^(لینک) (خصوصی)$',
'^(کاربری) (.*)$',
'^(شناسه) (%d+)$',
'^(تنظیم پیام مکرر) (%d+)$',
'^(تنظیم زمان بررسی) (%d+)$',
'^(حداکثر حروف مجاز) (%d+)$',
'^(درباره)$',
'^(حذف)$',
'^(تنظیم نام) (.*)$',
'^(تنظیم درباره) (.*)$',
'^(لیست فیلتر)$',
'^(لیست بیصدا)$',
'^(لیست مالکان)$',
'^(لیست مدیران)$',
'^(راهنما مدیریتی)$',
'^(راهنما)$',
'^(پیکربندی)$',
'^(فیلتر) (.*)$',
'^(حذف فیلتر) (.*)$',
'^(خوشآمد) (.*)$',
'^(تنظیم خوشآمد) (.*)$',
'^(راهنما بیصدا)$',
'^(ساعت بیصدا) (%d+)$',
'^(دقیقه بیصدا) (%d+)$',
'^(ثانیه بیصدا) (%d+)$',
'^(موقعیت) (بیصدا)$',
'^(زمان بیصدا) (%d+) (%d+) (%d+)$',
'^(زبان انگلیسی)$',
"^(راهنما سرگرمی)$",
"^(اب و هوا) (.*)$",
"^(حساب کن) (.*)$",
"^(ساعت)$",
"^(عکس) (.+)$",
"^(استیکر) (.+)$",
"^(تبدیل به صدا) +(.*)$",
"^(ساعات شرعی) (.*)$",
"^(ساعات شرعی)$",
"^(اذان) (.*)$",
"^(اذان)$",
"^(ترجمه) ([^%s]+) (.*)$",
"^(لینک کوتاه) (.*)$",
"^(تبدیل به عکس)$",
"^(تبدیل به استیکر)$",
"^(لغو نصب) (-%d+)$",	
"^(راهنما ابزار)$",
"^(راهنما قفلی)$",
"^(لیست سودو)$",
"^(اطلاعات)$",
"^(ساخت گروه) (.*)$",
"^(ورود به) (-%d+)$",
"^(ساخت گروه) (.*)$",
"^(ساخت سوپر گروه) (.*)$",
"^(ذخیره فایل) (.*)$",
"^(افزودن سودو)$",
"^(افزودن سودو) (.*)$",	
"^(حذف سودو)$",
"^(حذف سودو) (.*)$",	
"^(افزودن ادمین)$",
"^(افزودن ادمین) (.*)$",	
"^(حذف ادمین)$",
"^(حذف ادمین) (.*)$",
"^(ارسال فایل) (.*)$",
"^(حذف یوزرنیم ربات) (.*)$",
"^(تغییر یوزرنیم ربات) (.*)$",
"^(تغییر نام ربات) (.*)$",
"^(تبدیل به سوپر)$",
"^(ارسال به همه) (.*)$",
"^(لیست گروه ها)$",
"^(خروج)$",
"^(خروج) (-%d+)$",	
"^(ارسال پلاگین) (.*)$",
"^(لیست ادمین)$",
"^(خروج خودکار) (.*)$",
"^(شارژ) (-%d+) (%d+)$",
"^(شارژ) (%d+)$",	
"^(پلن) ([123]) (-%d+)$",
"^(اعتبار)$",
"^(اعتبار) (-%d+)$",
"^(ذخیره پلاگین) (.*)$",
"^(تیک دوم) (.*)$",
"^(ارسال) +(.*) (-%d+)$",
"^(افزودن) (-%d+)$",
"^(پاک کردن حافظه)$",
"^(فایر)$",
"^(سوپر بن)$",
"^(سوپر بن) (.*)$",
"^(حذف سوپر بن)$",
"^(حذف سوپر بن) (.*)$",
"^(لیست سوپر بن)$",
"^(بن)$",
"^(بن) (.*)$",
"^(حذف بن)$",
"^(حذف بن) (.*)$",
"^(لیست بن)$",
"^(سکوت)$",
"^(سکوت) (.*)$",
"^(حذف سکوت)$",
"^(حذف سکوت) (.*)$",
"^(لیست سکوت)$",
"^(اخراج)$",
"^(پاکسازی پیام های من)$",
"^(اخراج) (.*)$",
"^(حذف پیام)$",
"^(افزودن)$", 
"^(افزودن) @(.*)$",
"^(افزودن) (.*)$",
"^(پاکسازی) (%d*)$",
"^(حذف پیام) (.*)$",
"^(پاک کردن) (.*)$",
"^(بارگذاری)$",
"^(لیست پلاگین)$",
"^(پلاگین) (+) ([%w_%.%-]+)$",
"^(پلاگین) (+) ([%w_%.%-]+)$",
"^(پلاگین) (+) ([%w_%.%-]+) (گروه)$",
"^(پلاگین) (+) ([%w_%.%-]+) (گروه)$", 
"^(اطلاعات ایدی)$",
"^(اطلاعات ایدی) (.*)$",
'^([https?://w]*.?telegram.me/joinchat/%S+)$',
'^([https?://w]*.?t.me/joinchat/%S+)$'
},
run=run,
pre_process = pre_process
}
