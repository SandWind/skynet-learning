local skynet = require "skynet"
local datacenter = require "datacenter"

local function f1()
   print("f1 wait hello")
   print("f1",datacenter.wait("hello"))
   print("f1 wait key.foobar")
   print("f1", pcall(datacenter.wait,"key"))
   print("f1", datacenter.wait("key","foobar"))
end

local function f2()
   skynet.sleep(10)
   print("f2 set key.foobar")
   datacenter.set("key","foobar","skynet")
end

skynet.start(function()
      datacenter.set("hello","skynet")
      print(datacenter.get("hello"))
      skynet.fork(f1)
      skynet.fork(f2)
end)
