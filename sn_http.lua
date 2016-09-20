local skynet = require "skynet"
local httpc = require "http.httpc"
local dns = require "dns"

skynet.start(function ()
      httpc.dns()
      print("get baidu.com")
      local responder = {}
      local status, body = httpc.get("baidu.com", "/", responder)
      print("[header] =====>")
      for k,v in pairs(responder) do
         print(k,v)
      end
      print("[body] =====>", status)
      print(body)

      local responder = {}
      dns.server()
      local ip = dns.resolve "baidu.com"
      print(string.format("get %s (baidu.com)", ip))
      local status, body = httpc.get("baidu.com", "/", responder, {host="baidu.com"})
      print(status)
      skynet.exit()
end)
