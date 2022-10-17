---xx 命名空间
---@class xx
xx = xx or {}
---版本号
---@type string
xx.version = "0.0.1"
---打印版本号
print("xx[lua] version: " .. xx.version .. ", Email : wx771720@outlook.com")
---id 种子
---@type number
local __uidSeed = 0
---获取一个新的 id
---@return string 返回新的 id
function xx.newUID()
    __uidSeed = __uidSeed + 1
    return string.format("xx_lua_%d", __uidSeed)
end
unpack = unpack or table.unpack
---@alias Handler fun(...:any[]):any
---用于封装的 self Handler 回调
---@param handler Handler @需要封装的回调函数
---@param caller any @需要封装的监听函数所属对象
---@vararg any @缓存数据
---@return Handler @封装的回调函数
function xx.Handler(handler, caller, ...)
    local cache = {...}
    local numCache = select("#", ...)
    return function(...)
        local numArgs = select("#", ...)
        if handler and caller then
            if numCache > 0 and numArgs > 0 then
                local newArgs, index = {}, 1
                for i = 1, numCache do
                    newArgs[index] = cache[i]
                    index = index + 1
                end
                local args = {...}
                for i = 1, numArgs do
                    newArgs[index] = args[i]
                    index = index + 1
                end
                return handler(caller, unpack(newArgs, 1, numCache + numArgs))
            elseif numCache > 0 then
                return handler(caller, unpack(cache, 1, numCache))
            elseif numArgs > 0 then
                return handler(caller, ...)
            else
                return handler(caller)
            end
        elseif handler then
            if numCache and numArgs > 0 then
                local newArgs, index = {}, 1
                for i = 1, numCache do
                    newArgs[index] = cache[i]
                    index = index + 1
                end
                local args = {...}
                for i = 1, numArgs do
                    newArgs[index] = args[i]
                    index = index + 1
                end
                return handler(unpack(newArgs, 1, numCache + numArgs))
            elseif numCache then
                return handler(unpack(cache, 1, numCache))
            elseif numArgs > 0 then
                return handler(...)
            else
                return handler()
            end
        end
    end
end
xx.error = error
function xx.logDebug(...)
    print(...)
end
function xx.logWarn(...)
    print(...)
end
function xx.logError(...)
    print(...)
end
---是否是 nil
---@param target any @数据对象
---@return boolean
function xx.isNil(target)
    return nil == target
end
---是否是 boolean
---@param target any @数据对象
---@return boolean
function xx.isBoolean(target)
    return "boolean" == type(target)
end
---是否是 number
---@param target any @数据对象
---@return boolean
function xx.isNumber(target)
    return "number" == type(target)
end
---是否是 string
---@param target any @数据对象
---@return boolean
function xx.isString(target)
    return "string" == type(target)
end
---是否是 function
---@param target any @数据对象
---@return boolean
function xx.isFunction(target)
    return "function" == type(target)
end
---是否是 table
---@param target any @数据对象
---@return boolean
function xx.isTable(target)
    return "table" == type(target)
end
---是否是 userdata
---@param target any @数据对象
---@return boolean
function xx.isUserdata(target)
    return "userdata" == type(target)
end
---是否是 thread
---@param target any @数据对象
---@return boolean
function xx.isThread(target)
    return "thread" == type(target)
end
coroutine.isyieldable = coroutine.isyieldable or function()
        local co, isMain = coroutine.running()
        if xx.isBoolean(isMain) then
            return not isMain
        else
            return nil ~= co
        end
    end
---判断字符串是否已指定字符串开始
---@param str string @需要判断的字符串
---@param match string @需要匹配的字符串
---@return boolean
function xx.isBeginWith(str, match)
    return nil ~= string.match(str, "^" .. match)
end
---判断字符串是否已指定字符串结尾
---@param str string @需要判断的字符串
---@param match string @需要匹配的字符串
---@return boolean
function xx.isEndWith(str, match)
    return nil ~= string.match(str, match .. "$")
end
local code0, code9, codeA, codeZ, codea, codez, code_ = 48, 57, 65, 90, 97, 122, 95
---转换为驼峰格式
---@param str string
---@return string
function xx.toCamelCase(str)
    local codes, numCodes, lastCode, code = {}, 0, 0
    for i = 1, #str do
        code = string.byte(str, i, i)
        if (lastCode == code_ or 0 == lastCode) and code >= codea and code <= codez then --下划线后的小写
            numCodes = numCodes + 1
            codes[numCodes] = code - 32
        elseif code ~= code_ then -- 非下划线
            numCodes = numCodes + 1
            codes[numCodes] = code
        end
        lastCode = code
    end
    return string.char(unpack(codes))
end
---@return number, number
local toUnderscoreCaseLowerCase = function(str, index, codes, numCodes)
    local code
    while index > 0 do
        code = string.byte(str, index, index)
        index = index - 1
        if code >= codeA and code <= codeZ then -- 大写
            numCodes = numCodes + 1
            codes[numCodes] = code + 32
            return index, numCodes
        elseif code >= codea and code <= codez then -- 小写
            numCodes = numCodes + 1
            codes[numCodes] = code
        else -- 其它
            return index + 1, numCodes
        end
    end
    return index, numCodes
end
---@return number, number
local toUnderscoreCaseUpperCase = function(str, index, codes, numCodes)
    local code
    while index > 0 do
        code = string.byte(str, index, index)
        index = index - 1
        if code >= codeA and code <= codeZ then -- 大写
            numCodes = numCodes + 1
            codes[numCodes] = code + 32
        else -- 其它
            return index + 1, numCodes
        end
    end
    return index, numCodes
end
---@return number, number
local toUnderscoreCaseNumber = function(str, index, codes, numCodes)
    local code
    while index > 0 do
        code = string.byte(str, index, index)
        index = index - 1
        if code >= code0 and code <= code9 then -- 数字
            numCodes = numCodes + 1
            codes[numCodes] = code
        else -- 其它
            return index + 1, numCodes
        end
    end
    return index, numCodes
end
---转换为下划线格式
---@param str string
---@return string
function xx.toUnderscoreCase(str)
    local index, codes, numCodes, numSegments, code = #str, {}, 0, 0
    while index > 0 do
        code = string.byte(str, index, index)
        index = index - 1
        if code >= codea and code <= codez then -- 小写
            if numSegments > 0 then
                numCodes = numCodes + 1
                codes[numCodes] = code_
            end
            numCodes = numCodes + 1
            codes[numCodes] = code
            index, numCodes = toUnderscoreCaseLowerCase(str, index, codes, numCodes)
            numSegments = numSegments + 1
        elseif code >= codeA and code <= codeZ then -- 大写
            if numSegments > 0 then
                numCodes = numCodes + 1
                codes[numCodes] = code_
            end
            numCodes = numCodes + 1
            codes[numCodes] = code + 32
            index, numCodes = toUnderscoreCaseUpperCase(str, index, codes, numCodes)
            numSegments = numSegments + 1
        elseif code >= code0 and code <= code9 then -- 数字
            if numSegments > 0 then
                numCodes = numCodes + 1
                codes[numCodes] = code_
            end
            numCodes = numCodes + 1
            codes[numCodes] = code
            index, numCodes = toUnderscoreCaseNumber(str, index, codes, numCodes)
            numSegments = numSegments + 1
        end
    end
    for i = 1, numCodes / 2 do
        code = codes[i]
        index = numCodes - i + 1
        codes[i] = codes[index]
        codes[index] = code
    end
    return string.char(unpack(codes))
end
---清空表
---@param map table @表
---@return table @map
function xx.tableClear(map)
    for key, _ in pairs(map) do
        map[key] = nil
    end
    return map
end
---拷贝表
---@param map table @表
---@param recursive boolean @true 表示需要深度拷贝，默认 false
---@return table @拷贝的表对象
function xx.tableClone(map, recursive)
    local copy = {}
    for key, value in pairs(map) do
        if "table" == type(value) and recursive then
            copy[key] = xx.tableClone(value, recursive)
        else
            copy[key] = value
        end
    end
    return copy
end
---合并表
---@param map table @表
---@vararg table @需要合并的表
---@return table @map
function xx.tableMerge(map, ...)
    for i = 1, select("#", ...) do
        if xx.isTable(select(i, ...)) then
            for k, v in pairs(select(i, ...)) do
                map[k] = v
            end
        end
    end
    return map
end
---计算指定表键值对数量
---@param map table @表
---@return number @返回表数量
function xx.tableCount(map)
    local count = 0
    for _, __ in pairs(map) do
        count = count + 1
    end
    return count
end
---获取指定表的所有键
---@param map table @表
---@return any[] @键列表
function xx.tableKeys(map)
    local keys, count = {}, 0
    for key, _ in pairs(map) do
        count = count + 1
        keys[count] = key
    end
    return keys
end
---获取指定表的所有值
---@param map table @表
---@return any[] @值列表
function xx.tableValues(map)
    local values, count = {}, 0
    for _, value in pairs(map) do
        count = count + 1
        values[count] = value
    end
    return values
end
---获取数组长度
---@return number @数组长度
function xx.arrayCount(array)
    local count = 0
    for index, _ in pairs(array) do
        if "number" == type(index) and index > count then
            count = index
        end
    end
    return count
end
local __instanceFlag = "__instance__"
local __typeFlag = "__type__"
---默认派发的属性改变事件
xx.e_property_changed = "property_changed"
---@param watcherInfo WatcherInfo
---@param instance any
---@param key string
---@param newValue any
---@param oldValue any
local function __watcherTrigger(watcherInfo, instance, key, newValue, oldValue)
    instance.__watcherValueMap[key] = newValue
    if watcherInfo.handler then -- 回调
        if watcherInfo.handler(instance, key, newValue, oldValue) then -- 停止事件
            return
        end
    end
    if xx.EventDispatcher and xx.instanceOf(instance, xx.EventDispatcher) then
        instance(watcherInfo.eventName or xx.e_property_changed, key, newValue, oldValue)
    end
end
---获取实例值
---@param instance Object @实例对象
---@param key string @键
function xx.rawGet(instance, key)
    if instance.__keyMap[key] then
        return rawget(instance, key)
    end
    if instance.__getterMap[key] then -- 可读
        return instance.__getterMap[key](instance)
    elseif not instance.__setterMap[key] then -- 非只写
        if instance.__type.__signalMap[key] and xx.Signal then -- 信号
            if not instance.__signalValueMap[key] then
                instance.__signalValueMap[key] = xx.Signal(instance)
            end
            return instance.__signalValueMap[key]
        elseif instance.__type.__watcherMap[key] then -- 属性监听
            return instance.__watcherValueMap[key]
        else
            return instance.__type[key]
        end
    end
end
---设置实例值
---@param instance Object @实例对象
---@param key string @键
---@param value any @值
function xx.rawSet(instance, key, value)
    if instance.__keyMap[key] then
        rawset(instance, key, value)
    elseif not instance.__type.__signalMap[key] then -- 非信号
        if instance.__setterMap[key] then -- 可写
            local watcherInfo, oldValue = instance.__type.__watcherMap[key]
            if watcherInfo then
                oldValue = instance[key]
            end
            instance.__setterMap[key](instance, value)
            if watcherInfo and oldValue ~= value then
                __watcherTrigger(watcherInfo, instance, key, value, oldValue)
            end
        elseif not instance.__getterMap[key] then -- 非只读
            local watcherInfo = instance.__type.__watcherMap[key]
            if watcherInfo then -- 属性监听
                local oldValue = instance.__watcherValueMap[key]
                if oldValue ~= value then
                    __watcherTrigger(watcherInfo, instance, key, value, oldValue)
                end
            else -- 字段
                instance.__keyMap[key] = true
                rawset(instance, key, value)
            end
        end
    end
end
---获取实例值
---@param instance Object @实例对象
---@param key string @键
local function __instanceIndex(instance, key)
    if "function" == type(instance.__getter) then
        return instance.__getter(instance, key)
    end
    return xx.rawGet(instance, key)
end
---设置实例值
---@param instance Object @实例对象
---@param key string @键
---@param value any @值
local function __instanceNewIndex(instance, key, value)
    if "function" == type(instance.__setter) then
        return instance.__setter(instance, key, value)
    end
    xx.rawSet(instance, key, value)
end
---执行实例
---@param instance Object @实例对象
---@vararg any
local function __instanceCall(instance, ...)
    local value = instance.__type["call"]
    return value and "function" == type(value) and value(instance, ...)
end
---加号重载
---@param instance Object @实例对象
---@param target Object @实例对象
---@return Object
local function __instanceAdd(instance, target)
    local value = instance.__type["add"]
    return value and "function" == type(value) and value(instance, target)
end
---减号重载
---@param instance Object @实例对象
---@param target Object @实例对象
---@return Object
local function __instanceSub(instance, target)
    local value = instance.__type["sub"]
    return value and "function" == type(value) and value(instance, target)
end
---等于重载
---@param instance Object @实例对象
---@param target Object @实例对象
---@return boolean
local function __instanceEqualTo(instance, target)
    local value = instance.__type["equalTo"]
    return value and "function" == type(value) and value(instance, target)
end
---小于重载
---@param instance Object @实例对象
---@param target Object @实例对象
---@return boolean
local function __instanceLessThan(instance, target)
    local value = instance.__type["lessThan"]
    return value and "function" == type(value) and value(instance, target)
end
---小于等于重载
---@param instance Object @实例对象
---@param target Object @实例对象
---@return boolean
local function __instanceLessEqual(instance, target)
    local value = instance.__type["lessEqual"]
    return value and "function" == type(value) and value(instance, target)
end
---转换成字符串
---@param instance Object @实例对象
---@return string
local function __instanceToString(instance)
    local value = instance.__type["toString"]
    return value and "function" == type(value) and value(instance) or
        ("[" .. instance.__type.__name .. "]" .. instance.uid)
end
---实例元表
local __instanceMetatable = {
    __index = __instanceIndex,
    __newindex = __instanceNewIndex,
    __call = __instanceCall,
    __add = __instanceAdd,
    __sub = __instanceSub,
    __eq = __instanceEqualTo,
    __lt = __instanceLessThan,
    __le = __instanceLessEqual,
    __tostring = __instanceToString
}
---返回 true 表示停止激发事件
---@alias WatcherHandler fun(target:any,key:string,newValue:any,oldValue:any):boolean
---@class WatcherInfo @属性监听信息
---@field propertyName string @属性名
---@field eventName string @事件名
---@field handler WatcherHandler @回调函数
---类型
---@class Type @by wx771720@outlook.com 2020-11-05 15:44:41
---@field __flag string @类标识
---@field __name string @类名
---@field __super Type @基类
---@field __methodMap table<string,funtion> @方法名 - 类方法
---@field __getterMap table<string,function> @属性 - Getter
---@field __setterMap table<string,function> @属性 - Setter
---@field __watcherMap table<string,WatcherInfo> @属性名 - 属性监听信息
---@field __signalMap table<string,boolean> @属性名 - true
---
---@field __methodLockedMap table<string,boolean> @方法名 - 是否已锁定
---
---@field __plug_on_notice string|any[] @表示需要将接下来的方法作为通知监听，直接字符串表示通知，也可以设置数组 {string-通知,number-优先级,boolean-是否仅执行一次}(无序)
---@field __plug_async boolean @表示需要将接下来的方法在协程中运行
---@field __plug_lock boolean @表示需要在接下来的方法执行过程中忽略下次调用
---@field __plug_watcher string|any[] @表示需要监听属性变化事件，直接字符串表示属性名（默认事件 xx.evt_property_changed），也可以设置数组 {string-属性名,string-事件名,WatcherHandler-回调函数}（属性名必须放在第一位，其它无序，优先调用回调函数）
---@field __plug_signal string @表示定义信号属性，指定属性名
---获取类型静态值
---@param t Type @类
---@param key string @键
local function __typeIndex(t, key)
    if t.__getterMap[key] then -- 可读属性
        return t.__getterMap[key]()
    elseif not t.__setterMap[key] then -- 其它
        return t.__super and t.__super[key]
    end
end
---设置类型静态值
---@param t Type @类
---@param key string @键
---@param value any @值
local function __typeNewIndex(t, key, value)
    repeat
        if "function" == type(value) then
            ---@type string
            local name, prefix = key, string.match(key, "^_+") or ""
            if string.match(name, "Getter$") then -- Getter
                t.__getterMap[string.sub(name, #prefix + 1, -7)] = value
            elseif string.match(name, "_getter$") then -- _getter
                t.__getterMap[string.sub(name, #prefix + 1, -8)] = value
            elseif string.match(name, "Setter$") then --Setter
                t.__setterMap[string.sub(name, #prefix + 1, -7)] = value
            elseif string.match(name, "_setter$") then -- _setter
                t.__setterMap[string.sub(name, #prefix + 1, -8)] = value
            else
                if xx.async then
                    local isAsync = t.__plug_async
                    if isAsync then
                        ---@type function
                        local asyncCache = value
                        value = function(...)
                            return xx.async(asyncCache, ...)
                        end
                    end
                end
                if t.__plug_lock then
                    local lockCache = value
                    value = function(...)
                        local args = {...}
                        local methodLockedMap = (xx.instanceOf(args[1], t) and args[1] or t).__methodLockedMap
                        if not methodLockedMap[key] then
                            methodLockedMap[key] = true
                            local results = {pcall(lockCache, ...)}
                            if results[1] then
                                if xx.Promise and xx.instanceOf(results[2], xx.Promise) then
                                    ---@type Promise
                                    local promise = results[2]
                                    promise:next(
                                        function(...)
                                            methodLockedMap[key] = false
                                            return ...
                                        end,
                                        function(reason)
                                            methodLockedMap[key] = false
                                            xx.error(reason)
                                        end
                                    )
                                else
                                    methodLockedMap[key] = false
                                end
                                return unpack(results, 2, xx.arrayCount(results))
                            else
                                xx.error(results[2])
                            end
                        end
                    end
                end
                if t.__plug_on_notice and xx.addNotice then
                    local notice, priority, once = nil, 0, false
                    if "string" == type(t.__plug_on_notice) then
                        notice = t.__plug_on_notice
                    elseif "table" == type(t.__plug_on_notice) then
                        for _, param in ipairs(t.__plug_on_notice) do
                            if "string" == type(param) then
                                notice = param
                            elseif "number" == type(param) then
                                priority = param
                            elseif "boolean" == type(param) then
                                once = param
                            end
                        end
                    end
                    if notice then
                        xx.addNotice(t.__name, notice, value, priority, once)
                    end
                end
            end
            t.__methodMap[key] = value
        elseif "__plug_watcher" == key then --监听属性变化
            ---@type WatcherInfo
            local watcherInfo = {}
            if "string" == type(value) then
                watcherInfo.propertyName = value
            elseif "table" == type(value) and "string" == type(value[1]) then
                watcherInfo.propertyName = value[1]
                for i = 2, #value do
                    if "string" == type(value[i]) then
                        watcherInfo.eventName = value[i]
                    elseif "function" == type(value[i]) then
                        watcherInfo.handler = value[i]
                    end
                end
            end
            t.__watcherMap[watcherInfo.propertyName] = watcherInfo
            break
        elseif "__plug_signal" == key then --定义信号属性
            t.__signalMap[value] = true
            break
        elseif t.__setterMap[key] then --可写属性
            t.__setterMap[key](value)
            break
        elseif t.__getterMap[key] then --只写属性
            break
        end
        rawset(t, key, value)
    until true
    if not xx.isBeginWith(key, "__plug_") then
        rawset(t, "__plug_on_notice", nil)
        rawset(t, "__plug_async", nil)
        rawset(t, "__plug_lock", nil)
    end
end
---创建类型实例
---@param type Type @类
---@vararg any
---@return Object
local function __typeInstance(type, ...)
    ---@type Object
    local instance =
        setmetatable(
        {
            __flag = __instanceFlag,
            __type = type,
            __keyMap = {},
            __getterMap = {},
            __setterMap = {},
            __getter = type["getter"] or {}, -- 强制一个数据，nil 会导致查找 __getter
            __setter = type["setter"] or {}, -- 强制一个数据，nil 会导致查找 __setter
            __watcherValueMap = {},
            __signalValueMap = {},
            __methodLockedMap = {}
        },
        __instanceMetatable
    )
    for methodName, method in pairs(type.__methodMap) do
        rawset(instance, methodName, method)
    end
    for methodName, method in pairs(type.__getterMap) do
        instance.__getterMap[methodName] = method
    end
    for methodName, method in pairs(type.__setterMap) do
        instance.__setterMap[methodName] = method
    end
    instance._uid = xx.newUID()
    local ctor = instance.ctor
    if ctor then
        ctor(instance, ...)
    end
    return instance
end
---转换成字符串
---@param t Type @类
---@return string
local function __typeToString(t)
    local value = t["toString"]
    return value and "function" == type(value) and value(t) or t.__name
end
---基类
local __typeBase = {
    __flag = __typeFlag,
    __name = "xx._xx_",
    __methodMap = {},
    __getterMap = {},
    __setterMap = {},
    __watcherMap = {},
    __signalMap = {},
    __methodLockedMap = {}
}
---类型缓存
---@type table<string,Type>
local __typeMap = {[__typeBase.__name] = __typeBase}
---创建类
---@param name string @类名
---@param super Type @基类
---@return Type
local function __newType(name, super)
    ---@type Type
    local type =
        setmetatable(
        {
            __flag = __typeFlag,
            __name = name,
            __super = super or __typeBase,
            __methodMap = {},
            __getterMap = {},
            __setterMap = {},
            __watcherMap = {},
            __signalMap = {},
            __methodLockedMap = {}
        },
        {
            __index = __typeIndex,
            __newindex = __typeNewIndex,
            __call = __typeInstance,
            __tostring = __typeToString
        }
    )
    for methodName, method in pairs(type.__super.__methodMap) do
        type.__methodMap[methodName] = method
    end
    for methodName, method in pairs(type.__super.__getterMap) do
        type.__getterMap[methodName] = method
    end
    for methodName, method in pairs(type.__super.__setterMap) do
        type.__setterMap[methodName] = method
    end
    for propertyName, watcherInfo in pairs(type.__super.__watcherMap) do
        type.__watcherMap[propertyName] = watcherInfo
    end
    for propertyName, _ in pairs(type.__super.__signalMap) do
        type.__signalMap[propertyName] = true
    end
    __typeMap[name] = type
    return type
end
---基类
---@class Object:Type @by wx771720@outlook.com 2020-11-05 15:44:41
---@field uid string @唯一标识
---
---@field _uid string @唯一标识
---
---@field __flag string @实例标识
---@field __type Type @类
---@field __keyMap table<string,true> @键 - true（已设置过键值对）
---
---@field __getterMap table<string,function> @属性 - Getter
---@field __setterMap table<string,function> @属性 - Setter
---@field __getter fun(self:Object,key:string) @getter 函数（最高优先级）
---@field __setter fun(self:Object,key:string,value:any) @setter 函数（最高优先级）
---@field __watcherValueMap table<string,any> @属性监听 - 值
---@field __signalValueMap table<string,Signal> @属性名 - 信号对象
---@field __methodLockedMap table<string,boolean> @方法名 - 是否已锁定
local Object = __newType("xx.Object")
---@see Object
xx.Object = Object
function Object:toString()
    return self.uid
end
function Object:uidGetter()
    return self._uid
end
---@param name string @类名
---@param super Type @父类
local __classCall = function(Class, name, super)
    return __newType(name, super or Object)
end
local __classMetatable = {__call = __classCall}
---类
---<pre>ctor fun(...:any):void @构造函数，所有子类都需要调用基类 ctor</pre>
---<pre>call fun(...:any):any @对象执行函数</pre>
---<pre>add fun(target:Object):Object @加号重载</pre>
---<pre>sub fun(target:Object):Object @减号重载</pre>
---<pre>equalTo fun(target:Object):boolean @等于重载</pre>
---<pre>lessThan fun(target:Object):boolean @小于重载</pre>
---<pre>lessEqual fun(target:Object):boolean @小于等于重载</pre>
---<pre>toString fun():string @转换成字符串</pre>
---<pre>getter fun(self:Object,key:string):void @获取键值</pre>
---<pre>setter fun(self:Object,key:string,value:any):void @设置键值</pre>
---@class Class:Type @by wx771720@outlook.com 2020-11-05 15:44:41
local Class = setmetatable({}, __classMetatable)
---@see Type
---@param name string @类名
---@param super Type @基类，默认 Object
xx.Class = Class
---获取指定类名的类型
---@param name string @完整类名
---@return Type
function xx.findType(name)
    return __typeMap[name]
end
---判断指定对象是否是类型
---@param target any
---@return boolean
function xx.isType(target)
    return "table" == type(target) and __typeFlag == target.__flag
end
---判断类型是否是指定类型子类
---@param type Type
---@param parentType Type
---@return boolean
function xx.isSubType(type, parentType)
    repeat
        type = type.__super
        if type == parentType then
            return true
        end
    until not type
    return false
end
---判断指定对象是否是指定类型实例
---@param target any
---@param t Type
---@return boolean
function xx.instanceOf(target, t)
    return "table" == type(target) and "table" == type(t) and __instanceFlag == target.__flag and
        (target.__type == t or xx.isSubType(target.__type, t))
end
---数组
---@class Array:Object @by wx771720@outlook.com 2020-11-09 16:11:40
---@field count number 数量
---@field data any[] 数据列表
local Array = xx.Class("xx.Array")
---@see Array
---@param ... any @多个数据
xx.Array = Array
---构造函数
function Array:ctor(...)
    self.count = select("#", ...)
    self.data = {...}
end
---用于循环迭代器
function Array:call()
    local index = 0
    return function()
        index = index + 1
        return index <= self.count and self.data[index] or nil
    end
end
---@param target Array
function Array:add(target)
    local array = Array()
    for i = 1, self.count do
        array:push(self.data[i])
    end
    for i = 1, target.count do
        array:push(target.data[i])
    end
    return array
end
function Array:getter(key)
    if xx.isNumber(key) and key >= 1 and key <= self.count then
        return self.data[key]
    end
    return xx.rawGet(self, key)
end
function Array:setter(key, value)
    if xx.isNumber(key) then
        self.data[key] = value
    else
        xx.rawSet(self, key, value)
    end
end
---@return Array @new
function Array:clone()
    local array = Array()
    for i = 1, self.count do
        array:push(self.data[i])
    end
    return array
end
---@generic T
---@param type T
---@return T[]
function Array:toArray(type)
    local array = {}
    for i = 1, self.count do
        array[i] = self.data[i]
    end
    return array
end
---拆解
function Array:unpack(i, j)
    return unpack(self.data, i or 1, j or self.count)
end
---@return Array @self
function Array:clear()
    self.count = 0
    return self
end
---@return Array @self
function Array:insert(item, index)
    local data = self.data
    index = (not index or index > self.count) and self.count + 1 or (index < 1 and 1 or index)
    if index <= self.count then
        for i = self.count, index, -1 do
            data[i + 1] = data[i]
        end
    end
    data[index] = item
    self.count = self.count + 1
    return self
end
---@return Array @self
function Array:insertASC(value)
    local data = self.data
    local index = 1
    for i = self.count, 1, -1 do
        if data[i] <= value then
            index = i + 1
            break
        end
        data[i + 1] = data[i]
    end
    data[index] = value
    self.count = self.count + 1
    return self
end
---@return Array @self
function Array:remove(item)
    local data = self.data
    local iNew = 1
    for iOld = 1, self.count do
        if data[iOld] ~= item then
            if iNew ~= iOld then
                data[iNew] = data[iOld]
                data[iOld] = nil
            end
            iNew = iNew + 1
        else
            data[iOld] = nil
            self.count = self.count - 1
        end
    end
    return self
end
---@return Array @self
function Array:removeAt(index)
    local data = self.data
    if index and index >= 1 and index <= self.count then
        if index < self.count then
            for i = index + 1, self.count do
                data[i - 1] = data[i]
            end
        end
        data[self.count] = nil
        self.count = self.count - 1
    end
    return self
end
---@return Array @self
function Array:push(...)
    local data = self.data
    local args = {...}
    local newCount = select("#", ...)
    for i = 1, newCount do
        self.count = self.count + 1
        data[self.count] = args[i]
    end
    return self
end
---@generic T
---@param type T
---@return T @popped item
function Array:pop(type)
    local data = self.data
    if self.count >= 1 then
        self.count = self.count - 1
        return data[self.count + 1]
    end
end
---@return Array @self
function Array:unshift(item)
    local data = self.data
    for i = self.count, 1, -1 do
        data[i + 1] = data[i]
    end
    data[1] = item
    self.count = self.count + 1
    return self
end
---@generic T
---@param type T
---@return T @shifted item
function Array:shift(type)
    local data = self.data
    if self.count >= 1 then
        data[self.count + 1] = data[1]
        self.count = self.count - 1
        for i = 1, self.count do
            data[i] = data[i + 1]
        end
        return data[self.count + 2]
    end
end
---@return Array @new
function Array:slice(start, stop)
    local data = self.data
    start = start and (start < 0 and self.count + start + 1 or start) or 1
    stop = stop and (stop < 0 and self.count + stop + 1 or stop) or self.count
    local result = Array()
    for i = start < 1 and 1 or start, stop > self.count and self.count or stop do
        result.push(data[i])
    end
    return result
end
---@return boolean
function Array:contains(item)
    local data = self.data
    for i = 1, self.count do
        if item == data[i] then
            return true
        end
    end
    return false
end
---@return number
function Array:indexOf(item, from)
    local data = self.data
    from = from and (from < 0 and self.count + from + 1 or from) or 1
    for i = from < 1 and 1 or from, self.count do
        if data[i] == item then
            return i
        end
    end
    return -1
end
---@return number
function Array:lastIndexOf(item, from)
    local data = self.data
    from = from and (from < 0 and self.count + from + 1 or from) or self.count
    for i = from > self.count and self.count or from, 1, -1 do
        if data[i] == item then
            return i
        end
    end
    return -1
end
---Promise 回调
---@class PromiseNext:Object
---@field promise Promise @[ReadOnly]异步对象
---@field onFulfilled Handler @[ReadOnly]完成回调
---@field onRejected Handler @[ReadOnly]拒绝回调
---
---@field _promise Promise @异步对象
---@field _onFulfilled Handler @完成回调
---@field _onRejected Handler @拒绝回调
local PromiseNext = xx.Class("xx.PromiseNext")
---@type Array
PromiseNext.cacheList = Array()
---@param promise Promise @异步对象
---@param onFulfilled Handler @完成回调
---@param onRejected Handlerr @拒绝回调
function PromiseNext.instance(promise, onFulfilled, onRejected)
    local instance = PromiseNext.cacheList:pop() or PromiseNext()
    instance._promise = promise
    instance._onFulfilled = onFulfilled
    instance._onRejected = onRejected
    return instance
end
function PromiseNext:restore()
    self._promise = nil
    self._onFulfilled = nil
    self._onRejected = nil
    if not PromiseNext.cacheList:contains(self) then
        PromiseNext.cacheList:push(self)
    end
end
function PromiseNext:ctor()
end
function PromiseNext:promiseGetter()
    return self._promise
end
function PromiseNext:onFulfilledGetter()
    return self._onFulfilled
end
function PromiseNext:onRejectedGetter()
    return self._onRejected
end
---异步类
---@class Promise:Object @by wx771720@outlook.com 2019-12-24 14:21:47
---
---@field isPending boolean @[ReadOnly]是否等待态
---@field isFulfilled boolean @[ReadOnly]是否完成态
---@field isRejected boolean @[ReadOnly]是否拒绝态
---@field data Array @[ReadOnly]完成数据
---@field reason string @[ReadOnly]拒绝原因
---
---@field _nexts Array @回调列表
---@field _state number @当前状态
---@field _data Array @完成数据
---@field _reason string @拒绝原因
local Promise = xx.Class("xx.Promise")
---@see Promise
---@param executor function
xx.Promise = Promise
---@type number @等待态
local state_pending = 0
---@type number @完成态
local state_fulfilled = 1
---@type number @拒绝态
local state_rejected = 2
---构造函数
function Promise:ctor(executor)
    self._nexts = Array()
    self._state = state_pending
    self._data = Array()
    self._reason = nil
    if "function" == type(executor) then
        local result = {pcall(executor, xx.Handler(self.resolve, self), xx.Handler(self.reject, self))}
        if not result[1] then
            self:reject(result[2])
        end
    end
end
function Promise:isPendingGetter()
    return state_pending == self._state
end
function Promise:isFulfilledGetter()
    return state_fulfilled == self._state
end
function Promise:isRejectedGetter()
    return state_rejected == self._state
end
function Promise:dataGetter()
    return self._data
end
function Promise:reasonGetter()
    return self._reason
end
---完成
---@vararg any
function Promise:resolve(...)
    if self.isPending then
        self.data:push(...)
        self._state = state_fulfilled
        self:_continue()
    end
end
---拒绝
---@param reason string @拒绝原因
function Promise:reject(reason)
    if self.isPending then
        self._reason = reason
        if reason and 0 == self._nexts.count then
            xx.logError(reason)
        end
        self._state = state_rejected
        self:_continue()
    end
end
---结束后回调
---@param onFulfilled Handler @完成回调
---@param onRejected Handler @拒绝回调
---@return Promise @返回一个新的异步对象
function Promise:next(onFulfilled, onRejected)
    local promise = Promise()
    if self.isPending then
        self._nexts:unshift(PromiseNext.instance(promise, onFulfilled, onRejected))
    else
        self:_continueNext(PromiseNext.instance(promise, onFulfilled, onRejected))
    end
    return promise
end
---捕获异常
---@param onRejected Handler @拒绝回调
---@return Promise @返回一个新的异步对象
function Promise:catch(onRejected)
    return self:next(
        nil,
        function(reason)
            if onRejected then
                pcall(onRejected, reason)
            end
        end
    )
end
function Promise:_continue()
    for i = self._nexts.count, 1, -1 do
        self:_continueNext(self._nexts[i])
        self._nexts:removeAt(i)
    end
end
---@param next PromiseNext
function Promise:_continueNext(next)
    ---@type Array
    local result
    if self.isFulfilled then
        if next.onFulfilled then
            result = Array(pcall(next.onFulfilled, self.data:unpack()))
        else
            next.promise:resolve(self.data:unpack())
        end
    elseif self.isRejected then
        if next.onRejected then
            result = Array(pcall(next.onRejected, self.reason))
        else
            next.promise:reject(self.reason)
        end
    end
    if next.promise.isPending then
        if result[1] then -- 回调成功
            ---@type Promise
            local promiseResult = result[2]
            if xx.instanceOf(promiseResult, xx.Promise) then -- 返回异步对象
                promiseResult:next(
                    function(...)
                        next.promise:resolve(...)
                        next:restore()
                        return ...
                    end,
                    function(reason)
                        next.promise:reject(reason)
                        next:restore()
                        xx.error(reason)
                    end
                )
            else -- 完成
                next.promise:resolve(result:removeAt(1):unpack())
                next:restore()
            end
        else -- 回调失败
            next.promise:reject(result[2])
            next:restore()
        end
    else
        next:restore()
    end
end
---@vararg Promise
---@return Promise @返回一个新的异步对象
function Promise.all(...)
    ---@type Promise
    local promise
    local count = 0
    local result = Promise()
    local promises = Array(...)
    for i = 1, promises.count do
        promise = promises[i]
        if not promise or promise.isFulfilled then
            count = count + 1
        elseif promise.isRejected then
            result:reject(promise.reason)
            break
        elseif promise.isPending then
            promise:next(
                function(...)
                    count = count + 1
                    if count == promises.count then
                        result:resolve()
                    end
                    return ...
                end,
                function(reason)
                    result:reject(reason)
                    xx.error(reason)
                end
            ):catch()
        end
    end
    if count == promises.count then
        result:resolve()
    end
    return result
end
---@vararg Promise
---@return Promise @返回一个新的异步对象
function Promise.race(...)
    ---@type Promise
    local promise
    local isFulfilled = false
    ---@type Promise
    local rejectedPromise
    local result = Promise()
    local promises = Array(...)
    for i = 1, promises.count do
        promise = promises[i]
        if promise then
            if promise.isRejected then
                rejectedPromise = promise
                break
            elseif not isFulfilled and promise.isFulfilled then
                isFulfilled = true
            end
        end
    end
    if rejectedPromise then
        result:reject(rejectedPromise.reason)
    elseif isFulfilled then
        result:resolve()
    else
        for i = 1, promises.count do
            promise = promises[i]
            promise:next(
                function(...)
                    result:resolve()
                    return ...
                end,
                function(reason)
                    result:reject(reason)
                    xx.error(reason)
                end
            ):catch()
        end
    end
    return result
end
---在协程中执行方法
---@param handler Handler @需要执行的方法
---@param caller any @需要执行的方法所属对象
---@vararg any @携带参数
---@return Promise 异步对象
function xx.async(handler, caller, ...)
    local promise = Promise()
    if xx.isTable(handler) and xx.isFunction(handler[1]) then
        handler = xx.Handler(handler[1], handler[2], Array(unpack(handler)):removeAt(1):removeAt(1):unpack())
    elseif xx.isFunction(handler) then
        handler = xx.Handler(handler, caller, ...)
    else
        promise:resolve()
        return promise
    end
    local result =
        Array(
        coroutine.resume(
            coroutine.create(
                function()
                    local result = Array(handler())
                    if xx.instanceOf(result[1], Promise) then -- 返回异步对象
                        ---@type Promise
                        local promiseResult = result[1]
                        promiseResult:next(
                            function(...)
                                promise:resolve(...)
                                return ...
                            end,
                            function(reason)
                                promise:reject(reason)
                                xx.error(reason)
                            end
                        )
                    else -- 返回值
                        promise:resolve(result:unpack())
                    end
                end
            )
        )
    )
    if not result[1] then
        promise:reject(result[2])
    end
    return promise
end
---等待异步结束
---@param promise Promise @异步对象
---@return any @异步完成返回的数据
function xx.await(promise)
    if xx.isTable(promise) and xx.instanceOf(promise[1], Promise) then
        promise = promise[1]
    end
    if promise then
        if promise.isFulfilled then
            return promise.data:unpack()
        end
        if promise.isRejected then
            xx.error(promise.reason)
        end
        assert(coroutine.isyieldable(), "can not yield")
        local co = coroutine.running()
        promise:next(
            function(...)
                local result = Array(coroutine.resume(co, true, ...))
                if not result[1] then
                    xx.error(result[2])
                end
                return ...
            end,
            function(reason) -- 拒绝
                local result = Array(coroutine.resume(co, false, reason))
                if not result[1] then
                    xx.error(result[2])
                end
                xx.error(reason)
            end
        )
        local result = Array(coroutine.yield())
        if not result[1] then -- 拒绝后直接结束协程
            xx.error(result[2])
        end
        return result:removeAt(1):unpack()
    end
end
---事件
---@class Event:Object @by wx771720@outlook.com 2019-09-11 16:55:47
---@field target any @[ReadOnly]事件派发对象
---@field type string @[ReadOnly]事件类型
---@field args Array @携带数据
---@field currentTarget any @当前触发对象
---@field isStopBubble boolean @[ReadOnly]是否停止冒泡，默认 false
---@field isStopImmediate boolean @[ReadOnly]是否立即停止后续监听，默认 false
---@field isPreventDefault boolean @[ReadOnly]是否阻止默认操作，默认 false
---
---@field _target any @事件派发对象
---@field _type string @事件类型
---@field _isStopBubble boolean @是否停止冒泡，默认 false
---@field _isStopImmediate boolean @是否立即停止后续监听，默认 false
---@field _isPreventDefault boolean @是否阻止默认操作，默认 false
local Event = xx.Class("xx.Event")
---@see Event
---@param target any @事件派发对象
---@param type string @事件类型
---@param bubble boolean @是否冒泡
---@param ... any @携带数据
xx.Event = Event
function Event:ctor(target, type, bubble, ...)
    self._target = target
    self._type = type
    self._isStopBubble = not bubble
    self._isStopImmediate = false
    self._isPreventDefault = false
    self.args = Array(...)
end
function Event:targetGetter()
    return self._target
end
function Event:typeGetter()
    return self._type
end
function Event:isStopBubbleGetter()
    return self._isStopBubble
end
function Event:isStopImmediateGetter()
    return self._isStopImmediate
end
function Event:isPreventDefaultGetter()
    return self._isPreventDefault
end
---停止事件冒泡
function Event:stopBubble()
    self._isStopBubble = true
end
---立即停止后续执行（会停止事件冒泡）
function Event:stopImmediate()
    self._isStopImmediate = true
    self._isStopBubble = true
end
---阻止默认操作
function Event:preventDefault()
    self._isPreventDefault = true
end
---事件回调函数
---@alias EventHandler fun(evt:Event):void
---事件回调函数委托
---@class EventHandle:Object @by wx771720@outlook.com 2020-11-09 11:40:08
---@field type string @[ReadOnly]事件类型
---@field handler EventHandler @[ReadOnly]回调函数
---@field caller any @[ReadOnly]回调函数所属对象
---@field once boolean @[ReadOnly]是否仅执行一次
---@field cache Array @缓存的数据
---
---@field _type string @事件类型
---@field _handler EventHandler @回调函数
---@field _caller any @回调函数所属对象
---@field _once boolean @是否仅执行一次
local EventHandle = xx.Class("xx.EventHandle")
---@type Array
EventHandle.cacheList = Array()
function EventHandle.instance(type, handler, caller, once, ...)
    local instance = EventHandle.cacheList:pop() or EventHandle()
    instance._type = type
    instance._handler = handler
    instance._caller = caller
    instance._once = once
    instance.cache:push(...)
    return instance
end
function EventHandle:restore()
    self._type = nil
    self._handler = nil
    self._caller = nil
    self._once = false
    self.cache:clear()
    if not EventHandle.cacheList:contains(self) then
        EventHandle.cacheList:push(self)
    end
end
function EventHandle:ctor()
    self.cache = Array()
    self._type = nil
    self._handler = nil
    self._caller = nil
    self._once = false
end
function EventHandle:typeGetter()
    return self._type
end
function EventHandle:handlerGetter()
    return self._handler
end
function EventHandle:callerGetter()
    return self._caller
end
function EventHandle:onceGetter()
    return self._once
end
---事件派发器
---@class EventDispatcher:Object @by wx771720@outlook.com 2019-08-07 15:17:02
---@field _target any @代理对象，用于 Event 创建的 target
---@field _typeHandlesMap table<string,Array> @事件类型 - 回调列表[EventHandle]
---@field _typePromisesMap table<string,Array> @事件类型 - 异步列表[Promise]
local EventDispatcher = xx.Class("xx.EventDispatcher")
---@see EventDispatcher
xx.EventDispatcher = EventDispatcher
---构造函数
---@param target any @代理对象，用于 Event 创建的 target
function EventDispatcher:ctor(target)
    self._target = target or self
    self._typeHandlesMap = {}
    self._typePromisesMap = {}
end
---添加事件回调
---@param type string @事件类型
---@param handler EventHandler @回调函数
---@param caller any @回调方法所属的对象，匿名函数或者静态函数可不传入
---@vararg any @缓存数据
---@return EventDispatcher @self
function EventDispatcher:addEventListener(type, handler, caller, ...)
    self:removeEventListener(type, handler, caller)
    if self._typeHandlesMap[type] then
        self._typeHandlesMap[type]:push(EventHandle.instance(type, handler, caller, false, ...))
    else
        self._typeHandlesMap[type] = Array(EventHandle.instance(type, handler, caller, false, ...))
    end
    return self
end
---添加事件回调，执行后自动移除
---@param type string @事件类型
---@param handler EventHandler @回调函数
---@param caller any @回调方法所属的对象，匿名函数或者静态函数可不传入
---@vararg any @缓存数据
---@return EventDispatcher @self
function EventDispatcher:once(type, handler, caller, ...)
    self:removeEventListener(type, handler, caller)
    if self._typeHandlesMap[type] then
        self._typeHandlesMap[type]:push(EventHandle.instance(type, handler, caller, true, ...))
    else
        self._typeHandlesMap[type] = Array(EventHandle.instance(type, handler, caller, true, ...))
    end
    return self
end
---删除事件回调
---@param type string @事件类型，默认 nil 表示移除所有 handler 和 caller 回调
---@param handler EventHandler @回调函数，默认 nil 表示移除所有包含 handler 回调
---@param caller any @回调方法所属的对象，匿名函数或者静态函数可不传入，默认 nil 表示移除所有包含 caller 的回调
---@return EventDispatcher @self
function EventDispatcher:removeEventListener(type, handler, caller)
    ---@type EventHandle
    local handle
    if not type then
        local keys = xx.tableKeys(self._typeHandlesMap)
        for _, key in ipairs(keys) do
            self:removeEventListener(key, handler, caller)
        end
    elseif self._typeHandlesMap[type] then
        local handles = self._typeHandlesMap[type]
        if not handler and not caller then
            for i = handles.count, 1, -1 do
                handle = handles[i]
                handle:restore()
            end
            self._typeHandlesMap[type] = nil
        else
            if not handler then
                for i = handles.count, 1, -1 do
                    handle = handles[i]
                    if caller == handle.caller then
                        handle:restore()
                        handles:removeAt(i)
                    end
                end
            elseif not caller then
                for i = handles.count, 1, -1 do
                    handle = handles[i]
                    if handler == handle.handler then
                        handle:restore()
                        handles:removeAt(i)
                    end
                end
            else
                for i = handles.count, 1, -1 do
                    handle = handles[i]
                    if caller == handle.caller and handler == handle.handler then
                        handle:restore()
                        handles:removeAt(i)
                        break
                    end
                end
            end
            if handles.count then
                self._typeHandlesMap[type] = nil
            end
        end
    end
    return self
end
---是否有事件回调
---@param type string @事件类型，默认 nil 表示移除所有 handler 和 caller 回调
---@param handler EventHandler @回调函数，默认 nil 表示移除所有包含 handler 回调
---@param caller any @回调方法所属的对象，匿名函数或者静态函数可不传入，默认 nil 表示移除所有包含 caller 的回调
---@return boolean @如果找到事件回调返回 true，否则返回 false
function EventDispatcher:hasEventListener(type, handler, caller)
    if not type then
        if not handler and not caller then
            return xx.tableCount(self._typeHandlesMap) > 0
        else
            for type, _ in pairs(self._typeHandlesMap) do
                if self:hasEventListener(type, handler, caller) then
                    return true
                end
            end
        end
    elseif self._typeHandlesMap[type] then
        if not handler and not caller then
            return true
        else
            ---@type EventHandle
            local handle
            local handles = self._typeHandlesMap[type]
            if not handler then
                for i = handles.count, 1, -1 do
                    handle = handles[i]
                    if caller == handle.caller then
                        return true
                    end
                end
            elseif not caller then
                for i = handles.count, 1, -1 do
                    handle = handles[i]
                    if handler == handle.handler then
                        return true
                    end
                end
            else
                for i = handles.count, 1, -1 do
                    handle = handles[i]
                    if caller == handle.caller and handler == handle.handler then
                        return true
                    end
                end
            end
        end
    end
    return false
end
---等待事件触发
---@param type string @事件类型
---@return Promise
function EventDispatcher:wait(type)
    local promise = Promise()
    if self._typePromisesMap[type] then
        self._typePromisesMap[type]:unshift(promise)
    else
        self._typePromisesMap[type] = Array(promise)
    end
    return promise
end
---移除等待事件
---@param type string @事件类型，nil 表示移除所有 promise 等待
---@param promise Promise @异步对象，nil 表示移除所有 type 等待
---@return EventDispatcher @self
function EventDispatcher:removeWait(type, promise)
    if not type then
        ---@type string[]
        local keys = xx.tableKeys(self._typePromisesMap)
        for _, key in ipairs(keys) do
            self:removeWait(key, promise)
        end
    elseif self._typePromisesMap[type] then
        local promises = self._typePromisesMap[type]
        if not promise then
            self._typePromisesMap[type] = nil
            for _, loop in ipairs(promises:toArray(Promise)) do
                loop:reject()
            end
        elseif promises:contains(promise) then
            promises:remove(promise)
            if 0 == promises.count then
                self._typePromisesMap[type] = nil
            end
            promise:reject()
        end
    end
    return self
end
---判断是否有指定事件等待
---@param type string @事件类型，nil 表示是否有 promise 等待
---@param promise Promise @异步对象，nil 表示是否有 type 等待
---@return boolean
function EventDispatcher:hasWait(type, promise)
    if not type then
        if not promise then
            return xx.tableCount(self._typePromisesMap) > 0
        end
        for _, promises in pairs(self._typePromisesMap) do
            if promises:contains(promise) then
                return true
            end
        end
        return false
    elseif self._typePromisesMap[type] then
        return not promise or self._typePromisesMap[type]:contains(promise)
    end
    return false
end
---派发事件
---@param type string @事件类型
---@vararg any @数据
---@return boolean @是否阻止默认操作
function EventDispatcher:call(type, ...)
    local evt = xx.Event(self._target, type, true, ...)
    self:callEvent(evt)
    return evt.isPreventDefault
end
---派发事件（需要支持冒泡）
---@param evt Event @事件对象
function EventDispatcher:callEvent(evt)
    evt.currentTarget = self._target
    if self._typePromisesMap[evt.type] then
        local promises = self._typePromisesMap[evt.type]:clone()
        ---@type Promise
        local promise
        for i = promises.count, 1, -1 do
            promise = promises[i]
            if self:hasWait(evt.type, promise) then
                promise:resolve(evt)
            end
        end
        self._typePromisesMap[evt.type] = nil
    end
    if self._typeHandlesMap[evt.type] then
        ---@type any
        local caller
        ---@type EventHandler
        local handler
        ---@type Array
        local args = evt.args
        for _, handle in ipairs(self._typeHandlesMap[evt.type]:toArray(EventHandle)) do
            if self:hasEventListener(evt.type, handle.handler, handle.caller) then
                if handle.cache.count > 0 and args.count > 0 then
                    evt.args = handle.cache + args
                elseif handle.cache.count > 0 then
                    evt.args = handle.cache
                elseif args.count > 0 then
                    evt.args = args
                else
                    evt.args = Array()
                end
                handler = handle.handler
                caller = handle.caller
                if handle.once then
                    self:removeEventListener(evt.type, handler, caller)
                end
                if caller then
                    handler(caller, evt)
                else
                    handler(evt)
                end
                if evt.isStopImmediate then
                    break
                end
            end
        end
        evt.args = args
    end
end
---信号
---@class Signal:Object @by wx771720@outlook.com 2019-08-07 15:08:49
---@field target any @[ReadOnly]关联的对象
---
---@field _target any @关联的对象
---@field _handles Array @[EventHandle]回调列表
---@field _promises Array @[Promise]异步列表
local Signal = xx.Class("xx.Signal")
---@see Signal
---@param target any @关联的对象
xx.Signal = Signal
---构造方法
function Signal:ctor(target)
    self._target = target
    self._handles = Array()
    self._promises = Array()
end
function Signal:targetGetter()
    return self._target
end
---添加监听
---@param handler EventHandler @回调函数
---@param caller any @回调方法所属的对象，匿名函数或者静态函数可不指定
---@vararg any
---@return Signal @self
function Signal:addListener(handler, caller, ...)
    self:removeListener(handler, caller)
    self._handles:push(EventHandle.instance(nil, handler, caller, false, ...))
    return self
end
---添加监听，执行后自动移除
---@param handler EventHandler @回调函数
---@param caller any @回调方法所属的对象，匿名函数或者静态函数可不指定
---@vararg any
---@return Signal @self
function Signal:once(handler, caller, ...)
    self:removeListener(handler, caller)
    self._handles:push(EventHandle.instance(nil, handler, caller, true, ...))
    return self
end
---移除监听
---@param handler EventHandler @回调函数
---@param caller any @回调方法所属的对象，匿名函数或者静态函数可不指定
---@return Signal @self
function Signal:removeListener(handler, caller)
    ---@type EventHandle
    local handle
    if not handler and not caller then
        for i = self._handles.count, 1, -1 do
            handle = self._handles[i]
            handle:restore()
        end
        self._handles:clear()
    elseif not handler then
        for i = self._handles.count, 1, -1 do
            handle = self._handles[i]
            if caller == handle.caller then
                handle:restore()
                self._handles:removeAt(i)
            end
        end
    elseif not caller then
        for i = self._handles.count, 1, -1 do
            handle = self._handles[i]
            if handler == handle.handler then
                handle:restore()
                self._handles:removeAt(i)
            end
        end
    else
        for i = self._handles.count, 1, -1 do
            handle = self._handles[i]
            if caller == handle.caller and handler == handle.handler then
                handle:restore()
                self._handles:removeAt(i)
                break
            end
        end
    end
    return self
end
---判断是否有指定回调函数的回调
---@param handler EventHandler @回调函数
---@param caller any @回调方法所属的对象，匿名函数或者静态函数可不指定
---@return boolean @如果找到返回 true，否则返回 false
function Signal:hasListener(handler, caller)
    if not handler and not caller then
        return self._handles.count > 0
    else
        ---@type EventHandle
        local handle
        if not handler then
            for i = self._handles.count, 1, -1 do
                handle = self._handles[i]
                if caller == handle.caller then
                    return true
                end
            end
        elseif not caller then
            for i = self._handles.count, 1, -1 do
                handle = self._handles[i]
                if handler == handle.handler then
                    return true
                end
            end
        else
            for i = self._handles.count, 1, -1 do
                handle = self._handles[i]
                if caller == handle.caller and handler == handle.handler then
                    return true
                end
            end
        end
    end
    return false
end
---等待信号触发
---@return Promise
function Signal:wait()
    local promise = Promise()
    self._promises:unshift(promise)
    return promise
end
---取消等待
---@param promise Promise @异步对象，nil 表示取消所有等待
---@return Signal @self
function Signal:removeWait(promise)
    if not promise then
        local promises = self._promises:toArray(Promise)
        self._promises:clear()
        for _, loop in ipairs(promises) do
            loop:reject()
        end
    elseif self._promises:contains(promise) then
        self._promises:remove(promise)
        promise:reject()
    end
    return self
end
---判断是否已有等待指定异步对象
---@param promise Promise @异步对象，nil 表示判断是否有等待
---@return boolean
function Signal:hasWait(promise)
    if promise then
        return self._promises:contains(promise)
    else
        return self._promises.count > 0
    end
end
---触发信号
---@vararg any
---@return boolean @是否阻止默认操作
function Signal:call(...)
    local evt = xx.Event(self.target, nil, false, ...)
    ---异步
    local promises = self._promises:clone()
    ---@type Promise
    local promise
    for i = promises.count, 1, -1 do
        promise = promises[i]
        if self:hasWait(promise) then
            promise:resolve(evt)
        end
    end
    self._promises:clear()
    ---@type any
    local caller
    ---@type EventHandler
    local handler
    ---@type number
    local numArgs = select("#", ...)
    for _, handle in ipairs(self._handles:toArray(EventHandle)) do
        handler = handle.handler
        caller = handle.caller
        if self:hasListener(handler, caller) then
            if handle.cache.count > 0 and numArgs > 0 then
                evt.args = handle.cache:clone():push(...)
            elseif handle.cache.count > 0 then
                evt.args = handle.cache
            elseif numArgs > 0 then
                evt.args = Array(...)
            else
                evt.args = Array()
            end
            if handle.once then
                self:removeListener(handler, caller)
            end
            if caller then
                handler(caller, evt)
            else
                handler(evt)
            end
            if evt.isStopImmediate then
                break
            end
        end
    end
    return evt.isPreventDefault
end
---通知直接返回结果
---@class NoticeResult:Object @by wx771720@outlook.com 2019-09-11 20:04:17
---@field data any @通知直接返回的数据
---@field isStopped boolean @[ReadOnly]是否已停止后续模块的执行
---
---@field _isStopped boolean @是否已停止后续模块的执行
local NoticeResult = xx.Class("xx.NoticeResult")
---@see NoticeResult
xx.NoticeResult = NoticeResult
---@type Array
NoticeResult.cacheList = xx.Array()
function NoticeResult.instance()
    return NoticeResult.cacheList:pop() or NoticeResult()
end
function NoticeResult:restore()
    self.data = nil
    self._isStopped = false
    if not NoticeResult.cacheList:contains(self) then
        NoticeResult.cacheList:push(self)
    end
end
function NoticeResult:ctor()
    self.data = nil
    self._isStopped = false
end
function NoticeResult:isStoppedGetter()
    return self._isStopped
end
---停止后续模块执行
function NoticeResult:stop()
    self._isStopped = true
end
---通知回调
---@class NoticeHandler:Object @by wx771720@outlook.com 2020-11-23 14:43:11
---@field className string @[ReadOnly]类名
---@field module Object @[ReadOnly]实例
---@field priority  number @[ReadOnly]优先级，数字大的先执行，默认 0
---@field once boolean @[ReadOnly]是否仅执行一次
---
---@field _className string @类名
---@field _module Object @实例
---@field _priority  number @优先级，数字大的先执行，默认 0
---@field _once boolean @是否仅执行一次
local NoticeHandler = xx.Class("NoticeHandler")
---@type Array
NoticeHandler.cacheList = xx.Array()
function NoticeHandler.instance(className, module, priority, once)
    local instance = NoticeHandler.cacheList:pop() or NoticeHandler()
    instance._className = className
    instance._module = module
    instance._priority = priority
    instance._once = once
    return instance
end
function NoticeHandler:restore()
    self._className = nil
    self._module = nil
    self._priority = 0
    self._once = false
    if not NoticeHandler.cacheList:contains(self) then
        NoticeHandler.cacheList:push(self)
    end
end
function NoticeHandler:ctor()
end
function NoticeHandler:classNameGetter()
    return self._className
end
function NoticeHandler:moduleGetter()
    return self._module
end
function NoticeHandler:priorityGetter()
    return self._priority
end
function NoticeHandler:onceGetter()
    return self._once
end
---@type table<string, Object> @类名 - 实例
local __singleton = {}
---添加一个类的实例作为其单例使用
---@param instance Object @对象
function xx.addInstance(instance)
    if __singleton[instance.__type.__name] and __singleton[instance.__type.__name] ~= instance then
        xx.error("the count of " .. instance.__type.__name .. "'instance is more than 1")
    end
    __singleton[instance.__type.__name] = instance
end
---移除一个类的单例实例
---@param name string @类名
function xx.delInstance(name)
    __singleton[name] = nil
end
---获取一个类的单例实例
---@generic T
---@param name string @类名
---@param type T
---@return T @如果存在指定类名则返回对应单例对象，否则返回 nil
function xx.instance(name, type)
    if __singleton[name] then
        return __singleton[name]
    end
    local type = xx.findType(name)
    if type then
        local instance = type()
        __singleton[name] = instance
        return instance
    end
end
---@type table<string,table<string,function>> @类名 - {通知 - 方法}
local classHandlerMap = {}
---@type table<string,Array> @通知 - 回调列表（按 priority 倒序）
local noticeHandlersMap = {}
---@param className string @类名
---@param module Object @实例
---@param notice string @通知
---@param method function @方法
---@param priority number @优先级，数字大的优先执行，默认 0
---@param once boolean @是否仅执行一次，默认 false
local function addNotice(className, module, notice, method, priority, once)
    priority = priority or 0
    once = xx.isBoolean(once) and once or false
    if not classHandlerMap[className] then
        classHandlerMap[className] = {}
    end
    classHandlerMap[className][notice] = method
    if not noticeHandlersMap[notice] then
        noticeHandlersMap[notice] = Array(NoticeHandler.instance(className, module, priority, once))
    else
        ---@type NoticeHandler
        local handler, handlerLoop
        local handlers = noticeHandlersMap[notice]
        for index = 1, handlers.count do
            handlerLoop = handlers[index]
            if className == handlerLoop.className then
                if priority == handlerLoop.priority and index == handlers.count then
                    return
                end
                handler = handlerLoop
                handler._module = module
                handler._priority = priority
                handler._once = once
                handlers:removeAt(index)
                break
            end
        end
        if not handler then
            handler = NoticeHandler.instance(className, module, priority, once)
        end
        for index = handlers.count, 1, -1 do
            handlerLoop = handlers[index]
            if handler.priority <= handlerLoop.priority then
                handlers:insert(handler, index + 1)
                return
            end
        end
        handlers:insert(handler, 1)
    end
end
---移除通知监听
---@param className string @完整类名
---@vararg string @通知列表，如果未传入任何通知，则移除当前所有监听
local function removeNotices(className, ...)
    if classHandlerMap[className] then
        ---@type string[]
        local notices = {...}
        ---@type NoticeHandler
        local handler
        if 0 == #notices then
            notices = xx.tableKeys(classHandlerMap[className])
        end
        for _, notice in ipairs(notices) do
            if noticeHandlersMap[notice] then
                classHandlerMap[className][notice] = nil
            end
            if 1 == noticeHandlersMap[notice].count then
                handler = noticeHandlersMap[notice][1]
                handler:restore()
                noticeHandlersMap[notice] = nil
            else
                local handlers = noticeHandlersMap[notice]
                for index = 1, handlers.count do
                    handler = handlers[index]
                    if className == handler.className then
                        handler:restore()
                        handlers:removeAt(index)
                        break
                    end
                end
            end
        end
        if 0 == xx.tableCount(classHandlerMap[className]) then
            classHandlerMap[className] = nil
        end
    end
end
---添加模块通知监听
---@param module Object|string @实例 || 类名
---@param notice string @通知
---@param method function @方法
---@param priority number @优先级，数字大的优先执行
---@param once boolean @是否仅执行一次
function xx.addNotice(module, notice, method, priority, once)
    if xx.isString(module) then
        addNotice(module, nil, notice, method, priority, once)
    else
        xx.addInstance(module)
        addNotice(module.__type.__name, module, notice, method, priority, once)
    end
end
---移除模块通知监听
---@param module Object @实例
---@vararg string @通知列表，如果未传入任何通知，则移除当前所有监听
function xx.removeNotices(module, ...)
    removeNotices(module.__type.__name, ...)
end
---派发通知
---@param notice string @通知
---@vararg any @参数
function xx.notify(notice, ...)
    if noticeHandlersMap[notice] then
        local result = NoticeResult.instance()
        ---@type function
        local method
        ---@type Object
        local module
        for _, handler in ipairs(noticeHandlersMap[notice]:toArray(NoticeHandler)) do
            if classHandlerMap[handler.className] and classHandlerMap[handler.className][notice] then
                method = classHandlerMap[handler.className][notice]
                module = handler.module or xx.instance(handler.className)
                if module then
                    if handler.once then
                        removeNotices(handler.className, notice)
                    end
                    method(module, result, ...)
                    if result.isStopped then
                        break
                    end
                else
                    removeNotices(handler.className, notice)
                end
            end
        end
        local data = result.data
        result:restore()
        return data
    end
end
---派发异步通知
---@param notice string @通知
---@vararg any @参数
function xx.notifyAsync(notice, ...)
    return xx.async(
        function(...)
            if noticeHandlersMap[notice] then
                local result = NoticeResult.instance()
                ---@type function
                local method
                ---@type Object
                local module
                for _, handler in ipairs(noticeHandlersMap[notice]:toArray(NoticeHandler)) do
                    if classHandlerMap[handler.className] and classHandlerMap[handler.className][notice] then
                        method = classHandlerMap[handler.className][notice]
                        module = handler.module or xx.instance(handler.className)
                        if module then
                            if handler.once then
                                removeNotices(handler.className, notice)
                            end
                            ---@type Promise
                            local promise = method(module, result, ...)
                            if xx.instanceOf(promise, Promise) then
                                xx.await {promise}
                            end
                            if result.isStopped then
                                break
                            end
                        else
                            removeNotices(handler.className, notice)
                        end
                    end
                end
                local data = result.data
                result:restore()
                return data
            end
        end,
        nil,
        ...
    )
end
---GID 类（由工具自动生成，请勿手动修改）
---@class GID author wx771720[outlook.com]
GID = GID or {}
---已改变事件
---@param name string 改变的属性、字段等名字
---@param newValue any 改变后的值
---@param oldValue any 改变前的值
GID.e_changed = "e_changed"
---完成事件
---@param ... any[] 携带的数据
GID.e_complete = "e_complete"
---根节点改变事件
---@param oldRoot Node 之前的根节点
GID.e_root_changed = "e_root_changed"
---将要添加到父节点事件
---@param child Node 添加的子节点
GID.e_add = "e_add"
---已添加子节点事件
---@param child Node 添加的子节点
GID.e_added = "e_added"
---将要移除子节点事件
---@param child Node 移除的子节点
GID.e_remove = "e_remove"
---已移除子节点事件
---@param child Node 移除的子节点
GID.e_removed = "e_removed"
---启动通知
GID.nb_launch = "nb_launch"
---定时通知
---@param interval number 一帧耗时（单位：毫秒）
GID.nb_timer = "nb_timer"
---暂时通知
GID.nb_pause = "nb_pause"
---继续通知
GID.nb_resume = "nb_resume"
---打印状态
GID.nb_status = "nb_status"
---节点
---@class Node:EventDispatcher @by wx771720@outlook.com 2019-09-29 16:42:21
---@field root Node @根节点
---@field parent Node @[ReadOnly]父节点
---@field numChildren number @[ReadOnly]子节点数量
---
---@field _children Array @子节点列表
---@field _root Node @根节点
---@field _parent Node @父节点
local Node = xx.Class("xx.Node", EventDispatcher)
---@see Node
xx.Node = Node
---构造函数
function Node:ctor()
    EventDispatcher.ctor(self)
    self._children = Array()
    self._root = self
    self._parent = nil
end
function Node:numChildrenGetter()
    return self._children.count
end
function Node:rootGetter()
    return self._root
end
function Node:rootSetter(value)
    local oldRoot = self._root
    if value ~= oldRoot then
        self._root = value
        if self:hasEventListener(GID.e_root_changed) then
            self(GID.e_root_changed, oldRoot)
        end
        for _, child in ipairs(self._children:toArray(Node)) do
            child.root = value
        end
    end
end
function Node:parentGetter()
    return self._parent
end
---派发事件（需要支持冒泡）
---@param evt Event @事件对象
function Node:callEvent(evt)
    EventDispatcher.callEvent(self, evt)
    if not evt.isStopBubble and self.parent then
        self.parent:callEvent(evt)
    end
end
---添加子节点
---@param child Node @子节点
---@return Node @返回添加成功的子节点
function Node:addChild(child)
    return child and self:addChildAt(child, self.numChildren + 1)
end
---添加子节点到指定索引
---@param child Node @子节点
---@param index number @索引
---@return Node @返回添加成功的子节点
function Node:addChildAt(child, index)
    if child then
        local parent = self
        repeat
            if parent == child then
                return
            end
            parent = parent.parent
        until not parent
        if self == child.parent then
            index = index <= 0 and 1 or (index > self.numChildren and self.numChildren or index)
            if self._children[index] ~= child then
                self._children:remove(child)
                self._children:insert(child, index)
            end
        else --新增子节点
            if child:hasEventListener(GID.e_add) and child(GID.e_add, child) then
                return
            end
            child:removeSelf()
            index = index <= 0 and 1 or (index > self.numChildren and self.numChildren + 1 or index)
            self._children:insert(child, index)
            child._parent = self
            child.root = self.root
            if child:hasEventListener(GID.e_added) then
                child(GID.e_added, child)
            end
        end
        return child
    end
end
---移除子节点
---@param child Node @子节点
---@return Node @返回删除成功的子节点
function Node:removeChild(child)
    return child and self:removeChildAt(self._children:indexOf(child))
end
---移除指定索引的子节点
---@param index number @索引
---@return Node @返回删除成功的子节点
function Node:removeChildAt(index)
    if index >= 1 and index <= self.numChildren then
        ---@type Node
        local child = self._children[index]
        if child:hasEventListener(GID.e_remove) and child(GID.e_remove, child) then
            return
        end
        self._children:removeAt(index)
        child.root = child
        child._parent = nil
        if child:hasEventListener(GID.e_removed) then
            child(GID.e_removed, child)
        end
        return child
    end
end
---移除多个子节点
---@param beginIndex number @起始索引（支持负索引），默认 1
---@param endIndex number @结束索引（支持负索引，移除的子节点包含该索引），默认 -1 表示最后一个子节点
function Node:removeChildren(beginIndex, endIndex)
    beginIndex = beginIndex and (beginIndex < 0 and self.numChildren + beginIndex + 1 or beginIndex) or 1
    endIndex = endIndex and (endIndex < 0 and self.numChildren + endIndex + 1 or endIndex) or self.numChildren
    local children = self._children:toArray(Node)
    for i = endIndex > self.numChildren and self.numChildren or endIndex, beginIndex < 1 and 1 or beginIndex, -1 do
        self:removeChild(children[i])
    end
end
---修改子节点索引
---@param child Node @子节点
---@param index number @索引
---@return Node @返回修改的子节点
function Node:setChildIndex(child, index)
    if index >= 1 and index <= self.numChildren and child and self == child.parent and self._children[index] ~= child then
        self._children:remove(child)
        self._children:insert(child, index)
        return child
    end
end
---获取子节点索引
---@param child Node @子节点
---@return number @如果找到子节点则返回对应索引，否则返回 -1
function Node:getChildIndex(child)
    return child and self == child.parent and self._children:indexOf(child) or -1
end
---获取指定索引的子节点
---@param index number @索引
---@return Node @返回指定索引的子节点，如果索引超出范围则返回 nil
function Node:getChildAt(index)
    if index and index >= 1 and index <= self.numChildren then
        return self._children[index]
    end
end
---从父节点移除
function Node:removeSelf()
    if self.parent then
        self.parent:removeChild(self)
    end
end
---状态阶段
---@class StateStep @by wx771720@outlook.com 2020-11-13 17:44:42
---@field isConstructed boolean
---@field isFocused boolean
---@field isActivated boolean
---
---@field isConstructing boolean
---@field isFocusing boolean
---@field isActivating boolean
---@field isDeactivating boolean
---@field isDefocusing boolean
---@field isDestructing boolean
---
---@field canChangeState boolean
local StateStep = xx.Class("xx.StateStep")
---构造函数
function StateStep:ctor()
    self.isConstructed = false
    self.isFocused = false
    self.isActivated = false
    self.isConstructing = false
    self.isFocusing = false
    self.isActivating = false
    self.isDeactivating = false
    self.isDefocusing = false
    self.isDestructing = false
end
function StateStep:beginConstruct()
    self.isConstructing = not self.isConstructed
    return self.isConstructing
end
function StateStep:continueConstruct()
    return self.isConstructing
end
function StateStep:endConstruct()
    self.isConstructing, self.isConstructed = false, true
end
function StateStep:beginFocus()
    self.isFocusing = not self.isFocused and self.isConstructed
    return self.isFocusing
end
function StateStep:continueFocus()
    return self.isFocusing
end
function StateStep:endFocus()
    self.isFocusing, self.isFocused = false, true
end
function StateStep:beginActivate()
    self.isActivating = not self.isActivated and self.isFocused
    return self.isActivating
end
function StateStep:continueActivate()
    return self.isActivating
end
function StateStep:endActivate()
    self.isActivating, self.isActivated = false, true
end
function StateStep:beginDeactivate()
    self.isDeactivating = self.isActivating or self.isActivated
    self.isActivating = false
    return self.isDeactivating
end
function StateStep:endDeactivate()
    self.isDeactivating, self.isActivated = false, false
end
function StateStep:beginDefocus()
    self.isDefocusing = self.isFocusing or self.isFocused
    self.isFocusing = false
    return self.isDefocusing
end
function StateStep:endDefocus()
    self.isDefocusing, self.isFocused = false, false
end
function StateStep:beginDestruct()
    self.isDestructing = self.isConstructing or self.isConstructed
    self.isConstructing = false
    return self.isDestructing
end
function StateStep:endDestruct()
    self.isDestructing, self.isConstructed = false, false
end
function StateStep:canChangeStateGetter()
    return not (self.isConstructing or self.isDeactivating or self.isDefocusing or self.isDestructing)
end
---状态机
---@class State:Node @by wx771720@outlook.com 2019-09-03 09:57:09
---@field alias string @[ReadOnly]别名
---@field current State @[ReadOnly]当前子状态
---@field stateBoundList Array @[ReadOnly]绑定的状态对象列表
---
---@field isConstructed boolean @[ReadOnly]是否已构造
---@field isFocused boolean @[ReadOnly]是否已进入
---@field isActivated boolean @[ReadOnly]是否已激活
---
---@field _alias string @别名
---@field _aliasStateMap table<string,State> @别名 - 子状态
---@field _toStateID string @切换子状态标识
---@field _current State @当前子状态
---@field _stateStep StateStep @阶段数据
---@field _stateBoundList Array @绑定的状态对象列表
local State = xx.Class("xx.State", Node)
---@see State
---@param alias string @别名
xx.State = State
---构造函数
function State:ctor(alias)
    Node.ctor(self)
    self._alias = xx.isString(alias) and alias or self.uid
    self._aliasStateMap = {}
    self._toStateID = nil
    self._current = nil
    self._stateStep = StateStep()
    self._stateBoundList = Array()
end
function State:aliasGetter()
    return self._alias
end
function State:currentGetter()
    return self._current
end
function State:stateBoundListGetter()
    return self._stateBoundList
end
function State:isConstructedGetter()
    return self._stateStep.isConstructed
end
function State:isFocusedGetter()
    return self._stateStep.isFocused
end
function State:isActivatedGetter()
    return self._stateStep.isActivated
end
---@param alias string
---@return State @self
function State:setAlias(alias)
    self._alias = xx.isString(alias) and alias or self.uid
    return self
end
---@return State
function State:addChildAt(child, index)
    if xx.instanceOf(child, State) then
        ---@type State
        local childState = Node.addChildAt(self, child, index)
        if childState then
            self._aliasStateMap[childState.alias] = childState
            childState:addEventListener(GID.e_complete, self._onChildCompleteHandler, self)
            return childState
        end
    end
end
---@return State
function State:removeChildAt(index)
    ---@type State
    local child = Node.removeChildAt(self, index)
    if child then
        child:removeEventListener(GID.e_complete, self._onChildCompleteHandler, self)
        self._aliasStateMap[child.uid] = nil
        if child == self.current then
            child:defocus()
            self._current = nil
        end
        return child
    end
end
---跳转子状态
---@param alias string 子状态别名
---@vararg any
---@return State @self
function State:toState(alias, ...)
    if not self._stateStep.canChangeState or (self.current and alias == self.current.alias) then
        return self
    end
    self._toStateID = xx.newUID()
    local to = xx.isString(alias) and self._aliasStateMap[alias] or nil
    if self.current then
        self.current:defocus()
    end
    self._current = to
    if self.current then
        if self.isActivated then
            self.current:activate(...)
        elseif self.isFocused then
            self.current:focus(...)
        elseif self.isConstructed then
            self.current:construct(...)
        end
    end
    return self
end
---通过子状态别名获取子状态
---@param alias string @别名
---@return State
function State:getState(alias)
    return self._aliasStateMap[alias]
end
---@return State @self
function State:construct(...)
    if self._stateStep:beginConstruct() then
        self:_onConstruct(...)
        if self._stateStep:continueConstruct() then
            for _, stateBound in ipairs(self.stateBoundList:toArray(State)) do
                stateBound:construct()
            end
            self._stateStep:endConstruct()
        end
    end
    if self.current then
        self.current:construct(...)
    end
    return self
end
---@return State @self
function State:focus(...)
    local toStateID = self._toStateID
    self:construct(...)
    if self._stateStep:beginFocus() then
        self:_onFocus(...)
        if self._stateStep:continueFocus() then
            for _, stateBound in ipairs(self.stateBoundList:toArray(State)) do
                stateBound:focus()
            end
            self._stateStep:endFocus()
        end
    end
    if toStateID == self._toStateID and self.current then
        self.current:focus(...)
    end
    return self
end
---@return State @self
function State:activate(...)
    local toStateID = self._toStateID
    self:focus(...)
    if self._stateStep:beginActivate() then
        self:_onActivate(...)
        if self._stateStep:continueActivate() then
            for _, stateBound in ipairs(self.stateBoundList:toArray(State)) do
                stateBound:activate()
            end
            self._stateStep:endActivate()
        end
    end
    if toStateID == self._toStateID and self.current then
        self.current:activate(...)
    end
    return self
end
---@return State @self
function State:deactivate()
    if self.current then
        self.current:deactivate()
    end
    if self._stateStep:beginDeactivate() then
        for _, stateBound in ipairs(self.stateBoundList:toArray(State)) do
            stateBound:deactivate()
        end
        self:_onDeactivate()
        self._stateStep:endDeactivate()
    end
    return self
end
---@return State @self
function State:defocus()
    self:deactivate()
    if self.current then
        self.current:defocus()
    end
    if self._stateStep:beginDefocus() then
        for _, stateBound in ipairs(self.stateBoundList:toArray(State)) do
            stateBound:defocus()
        end
        self:_onDefocus()
        self._stateStep:endDefocus()
    end
    return self
end
---@return State @self
function State:destruct()
    self:defocus()
    if self.current then
        self.current:destruct()
    end
    if self._stateStep:beginDestruct() then
        local children = self._children:toArray(State)
        self:removeChild()
        for _, child in ipairs(children) do
            child:destruct()
        end
        self._toStateID = nil
        self._current = nil
        self._aliasStateMap = {}
        for _, stateBound in ipairs(self.stateBoundList:toArray(State)) do
            stateBound:destruct()
        end
        self._stateBoundList:clear()
        self:_onDestruct()
        self._stateStep:endDestruct()
    end
    return self
end
---@return State @self
function State:finishState(...)
    if self._stateStep.canChangeState then
        self(GID.e_complete, ...)
    end
    return self
end
---@return Promise
function State:waitComplete()
    return self:wait(GID.e_complete)
end
function State:_onConstruct(...)
end
function State:_onFocus(...)
end
function State:_onActivate(...)
end
function State:_onDeactivate()
end
function State:_onDefocus()
end
function State:_onDestruct()
end
---@param state State
---@vararg any
function State:_onChildComplete(state, ...)
    local index = self._children:indexOf(state) + 1
    if index <= self.numChildren then
        state = self._children[index]
        self:toState(state.alias, ...)
    else
        self:finishState(...)
    end
end
---@param evt Event
function State:_onChildCompleteHandler(evt)
    evt:stopBubble()
    self:toState()
    self:_onChildComplete(evt.currentTarget, evt.args:unpack())
end
---绑定指定状态对象与当前状态同步
---@param state State @状态对象
---@return State @self
function State:bindState(state)
    if not self.stateBoundList:contains(state) then
        self.stateBoundList:push(state)
    end
    if self.isConstructed then
        state:construct()
        if self.isFocused then
            state:focus()
            if self.isActivated then
                state:activate()
            else
                state:deactivate()
            end
        else
            state:defocus()
        end
    end
    return self
end
---解除绑定的指定状态对象
---@param state State @状态对象
---@param defocusable boolean @是否调用 defocus，默认 true
---@return State @self
function State:unbindState(state, defocusable)
    if self.stateBoundList:contains(state) then
        self.stateBoundList:remove(state)
        if not xx.isBoolean(defocusable) or defocusable then
            state:defocus()
        end
    end
    return self
end
---@alias QueueHandler fun(queue:Queue)
---队列
---@class Queue:State @by wx771720@outlook.com 2020-12-08 20:12:15
---@field isStopped boolean @[ReadOnly]是否已停止
---
---@field _startPromise Promise
---@field _onStart QueueHandler @启动回调（支持 await），参数：self
---@field _onStop QueueHandler @停止回调（支持 await），参数：self
local Queue = xx.Class("Queue", State)
---@see Queue
---@param onStart QueueHandler @启动回调（支持 await），参数：Queue
---@param onStop QueueHandler @停止回调（支持 await），参数：Queue
xx.Queue = Queue
---构造函数
function Queue:ctor(onStart, onStop)
    State.ctor(self)
    self._onStart = onStart
    self._onStop = onStop
end
function Queue:finishState(...)
    if not self.parent then
        self:defocus()
    end
    State.finishState(self, ...)
end
function Queue:_onFocus(...)
    if self.parent then
        if xx.isFunction(self._onStart) then
            self._startPromise =
                xx.async(self._onStart, nil, self, ...):next(
                function(...)
                    self:finishState(...)
                    return ...
                end,
                function(reason)
                    self:finishState(reason)
                    return reason
                end
            )
        else
            self:finishState(...)
        end
    end
end
function Queue:_onDefocus()
    if self.parent then
        if self._startPromise then
            self._startPromise:reject()
            self._startPromise = nil
        end
        if xx.isFunction(self._onStop) then
            self._onStop(self)
        end
    end
end
function Queue:isStoppedGetter()
    return not self.isActivated
end
---开始
---@vararg any
function Queue:start(...)
    if not self.parent then
        if not self.isStopped then
            self:stop()
        end
        ---@type Queue
        local child = self._children[1]
        if child then
            self:toState(child.uid)
        end
        self:activate(...)
    end
end
---停止
---@param trigger boolean @是否触发完成事件，默认 false
---@vararg any @完成事件携带参数
function Queue:stop(trigger, ...)
    if not self.parent and not self.isStopped then
        self:toState()
        self:defocus()
        if trigger then
            self:finishState(...)
        end
    end
end
---销毁
function Queue:dispose()
    self:destruct()
end

_G.Array = xx.Array
_G.async = xx.async
_G.await = xx.await
_G.Promise = xx.Promise
_G.EventDispatcher = xx.EventDispatcher
_G.Signal = xx.Signal
_G.State = xx.State
_G.Queue = xx.Queue