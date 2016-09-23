local skynet = require "skynet"

skynet.register_protocal {
   name="client",
   id=skynet.PTYPE_CLIENT,
   unpack=skynet.tostring,
}

local gate
local userid,subid
local CMD={}

function CMD.login(source,uid,sid,secret)
   skynet.error(string.format("%s is login",uid))
   gate=source
   userid=uid
   subid=id
end

local function logout()
   if gate then
      skynet.call(gate,"lua","logout",userid,subid)
   end
   skynet.exit()
end

function CMD.logout(source)
   skynet.error(string.format("%s is logout",userid))
   logout()
end

function CMD.afk(source)
   skynet.error(string.format("AFK"))
end

skynet.start(function()
      skynet.dispatch("lua",function(session,source,command,...)
                         local f=assert(CMD[command])
                         skynet.ret(skynet.pack(f(source,...)))
      end)

      skynet.dispatch("client",function(_,_,msg)
                         skynet.sleep(10)
                         skynet.ret(msg)
      end)
end)
