local skynet = require "skynet"

local i=1
local hello = "hello"

function response.ping(hello)
   skynet.sleep(100)
   return hello
end

function accept.hello()
   i=i+1
   print(i,hello)
end

function response.error()
   error "throw an error"
end

function inti(...)
   print("ping server start:", ...)
end

function exit(...)
   print("ping server exit:", ...)
end
