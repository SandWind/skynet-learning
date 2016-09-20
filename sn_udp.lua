local skynet = require "skynet"
local socket = require "socket"

local function server()
   local host
   host = socket.udp(function(str, from)
         print("server recv", str, socket.udp_address(from))
         socket.sendto(host, from, "ok"..str)
   end, "127.0.0.1", 8765)
end

local function client()
   local c = socket.udp(function(str, from)
         print("client recv", str, socket.udp_address(from))
   end)
   socket.udp_connect(c, "127.0.0.1", 8765)
   for i=1,10 do
      socket.write(c, "hello"..i)
   end
end

skynet.start(function()
      skynet.fork(server)
      skynet.fork(client)
end)
