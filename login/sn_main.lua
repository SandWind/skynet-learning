local skynet = require "skynet"

skynet.start(function()
      local loginserver=skynet.newservice("sn_login")
      local gate=skynet.newservice("sn_gate",loginserver)

      skynet.call(gate,"lua","open",{
                     port=8888,
                     maxclient=64,
                     servername="simple",
      })
end)
