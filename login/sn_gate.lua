local msgserver = require "snax.msgserver"
local crypt = require "crypt"
local skynet = require "skynet"

local loginservice=tonumber(...)
local server={}
local users={}
local username_map={}
local internal_id=0

function server.login_handler(uid,secret)
   if users[uid] then
      error(string.format("%s is already login",uid))
   end

   internal_id=internal_id+1
   local id=internal_id
   local username=msgserver.username(uid,id,servername)

   local agent=skynet.newservice "msgagent"
   local u={
      username=username,
      agent=agent,
      uid=uid,
      subid=id,
   }

   skynet.call(agent,"lua","login",uid,id,secret)

   users[uid]=u
   username_map[username]=u
   msgserver.login(username,secret)

   return id
end

function server.logout_handler(uid,subid)
   local u=users[uid]
   if u then
      local username=msgserver.username(uid,subid,servername)
      assert(u.username==username)
      msgserver.logout(u.username)
      users[uid]=nil
      username_map[u.username]=nil
      skynet.call(loginservice,"lua","logut",uid,subid)
   end
end

function server.kick_hanlder(uid,subid)
   local u=users[uid]
   if u then
      local username=msgserver.username(uid,subid,servername)
      assert(u.username==username)
      pcall(skynet.call,u.agent,"lua","logout")
   end
end

function server.disconnect_handler(username)
   local u=username_map[username]
   if u then
      skynet.call(u.agent,"lua","afk")
   end
end

function server.request_handler(username,msg)
   local u=username_map[username]
   return skynet.tostring(skynet.rawcall(u.agent,"client",msg))
end

function server.register_handler(name)
   servername=name
   skyent.call(loginservice,"lua","register_gate",servername,skynet.self())
end

msgserver.start()
