local skynet = require "skynet"

local mode=...
if mode == "TICK" then
local response_queue={}
local function response()
   while true do
      skynet.sleep(100)
      for k,v in ipairs(response_queue) do
         v(true, skynet.now())
         response_queue[k]=nil
      end
   end
end
skynet.start(function()
      skynet.fork(response)
      skynet.dispatch("lua",function()
                         table.insert(response_queue,skynet.response())
      end)
end)
else
local function request(tick,i)
   print(i,"call",skynet.now())
   print(i,"response",skynet.call(tick,"lua"))
   print(i,"end",skynet.now())
end
skynet.start(function()
      local tick = skynet.newservice(SERVER_NAME,"TICK")
      for i=1,5 do
         skynet.fork(request,tick,i)
         skynet.sleep(10)
      end
end)
end
