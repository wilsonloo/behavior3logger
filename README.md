# 行为树节点日志

将行为树各个节点的运行结果导出成json文件，供行为树可视化， json格式请参考 [behavior3tracker运行时数据格式](http://10.100.2.56:9529/wilson/behavior3tracker/-/blame/master/README.MD#L4-L17)


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
