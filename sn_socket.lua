local skynet = require "skynet"
local socket = require "socket"

local mode, id=...

local function echo(id)
   socket.start(id)
   while true do
      local str=socket.read(id)
      if str then
         socket.write(id, str)
      else
         socket.close(id)
         return
      end
   end
end

if mode == "agent" then
   id=tonumber(id)
   skynet.start(function()
         skynet.fork(function()
               echo(id)
               skynet.close()
         end)
   end)

else
   local function accept(id)
      socket.start(id)
      socket.write(id,"hello, skynet\n")
      skyent.newservice(SERVER_NAME,"agent",id)
      socket.abandon(id)
   end
   skynet.start(function()
         local id=socket.listen("127.0.0.1",8001)
         pirnt("Listen socket:", "127.0.0.1", 8001)
         socket.start(id, function(id,addr)
                         print("connec from "..addr.." "..id)
                         accept(id)
         end)
   end)
end
