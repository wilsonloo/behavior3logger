local Skynet = require "mynet"
local Socket = require "skynet.socket"
local Log = require "log"

local mt = {}
mt.__index = mt

function mt:check_alive()
    if self.connecting then
        return
    end

    if self.fd then
        return
    end

    self.connecting = true
    Skynet.fork(function ()
        Log.Infof("connecting to b3-tracker-server:%s:%d...", self.ip, self.port)
        local fd, errmsg = Socket.open(self.ip, self.port)
        assert(fd, errmsg)

        self.connecting = false
        self.fd = fd
        Log.Info("b3-tracker-server connected")

        Socket.onclose(fd, function ()
            self.fd = nil
        end)
    end)
end

function mt:send(data)
    if not self.fd then
        Log.Warning("target fd invalid, send ignored")
        return
    end

    Socket.write(self.fd, data .. "\n")
end

local M = {}

function M.new(ip, port)
    local client = {
        ip = ip,
        port = port,

        connecting = false,
        fd = nil,
    }
    setmetatable(client, mt)
    return client
end

return M
