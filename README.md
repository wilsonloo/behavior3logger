# 行为树节点日志

用于将行为树各个节点的运行结果导出成json文件，供行为树可视化
```json
{
    "frames": [
        {
            "frame_id": 帧数,
            "list": [
                [节点id, 状态编码, 提示消息],
                ...
            ]
        },
        ...
    ]
}
```

* 使用方式
```lua
    -- 创建日志对象
    local Mod = require "b3_logger"
    local logger = Mod.new(日志文件名)

    -- 开启新一帧
    logger:new_frame()

    -- 添加节点状态日志
    logger:log(节点id, 节点运行状态， 提示消息)

    -- 终端输出日志
    logger:dump()

    -- 存储日志文件(不会清空日志)
    logger:save()

```
