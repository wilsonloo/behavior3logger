local Json    = require "json" -- https://github.com/wilsonloo/lua-cjson.git
local Md5     = require "md5"  -- https://github.com/wilsonloo/lua-md5.git

local tinsert = table.insert

local function upload_frame(self, frame)
    local frame_id = frame.frame_id
    frame.frame_id = "masked"

    local text = Json.encode(frame)
    if text:match("%^%^%^") then
        print("invalid text: ^^^")
        return
    end

    if text:match("%$%$%$") then
        print("invalid text: $$$")
        return
    end

    self.upload_frames = self.upload_frames + 1
    local md5 = Md5.sumhexa(text)
    if not self.last_frame_md5 or self.last_frame_md5 ~= md5 or self.upload_frames >= 100 then
        self.last_frame_md5 = md5
        self.upload_frames = 0

        frame.frame_id = frame_id
        frame.md5 = md5
        text = Json.encode(frame)
        text = "^^^" .. text .. "$$$"
        self.b3_tracker_client:send(text)
    end
end

local mt = {}
mt.__index = mt

function mt:new_frame()
    local old_frame = self.cur_frame
    self.frame_id = self.frame_id + 1
    local frame = {
        frame_id = self.frame_id,
        list = {},
    }
    tinsert(self.frames, frame)
    self.cur_frame = frame

    -- if self.frame_id % 50 == 0 then
    --     self:dump()
    -- end

    if old_frame then
        if self.b3_tracker_client then
            upload_frame(self, old_frame)
        end
    end
end

function mt:log(node_id, state, msg)
    local record = { node_id, state, msg }
    tinsert(self.cur_frame.list, record)
end

function mt:dump()
    -- todo
    -- PrintR.print_r("b3_logger dump:", self.frames)
end

function mt:save()
    local text = Json.encode({ frames = self.frames })
    local file, err = io.open(self.filename, "w")
    if file == nil then
        error(("Unable to write '%s': %s"):format(self.filename, err))
    end

    file:write(text)
    file:close()
end

local M = {}

local function init(self)
    self:new_frame()
end

function M.new(filename, b3_tracker_client)
    local logger = {
        frame_id = 0,
        frames = {},
        cur_frame = nil,
        filename = filename,
        b3_tracker_client = b3_tracker_client,

        last_frame_md5 = nil,
        upload_frames = 0,
    }
    setmetatable(logger, mt)
    init(logger)
    return logger
end

return M
