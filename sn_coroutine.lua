local skynet = require "skynet"
local coroutine = require "skynet.coroutine"
local profile = require "profile"

local function status(co)
   repeat
     local status = coroutine.status(co)
     print("STATUS", status)
     skynet.sleep(100)
   until status == "suspended"

   repeat
      local ok, n = assert(coroutine.resume(co))
      print("status thread", n)
   until not n
   skynet.exit()
end

local function test(n)
   local co = coroutine.running()
   print("begin", co, coroutine.thread(co))
   skynet.fork(status, co)
   for i=1,n do
      skynet.sleep(100)
      coroutine.yield(i)
   end
   print("end", co)
end

local function main()
   local f = coroutine.wrap(test)
   coroutine.yield "begin"
   for i=1,3 do
      local n = f(5)
      print("main thread", n)
   end
   coroutine.yield "end"
   print("main thread time:", profile.stop(coroutine.thread()))
end

skynet.start(function ()
      print("main thread:", coroutine.thread())
      print(coroutine.resume(coroutine.running()))
      profile.start()
      local f = coroutine.wrap(main)
      print("main step", f())
      print("main step", f())
      print("main step", f())
end)
