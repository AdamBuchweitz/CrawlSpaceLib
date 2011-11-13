
            --[[ ########## Timer Hijack ########## ]--

This override is here to snag every timer and u.cache it into
an array for later cancelling. There is no change in syntax,
none of your code will break.

Sometimes you will want to cancel all timers EXCEPT a few,
in which case simply pass in "false" when you create your timer.

:: EXAMPLE 1 ::

    local myFunction = function()
        u.print("my function")  <== This will never print
    end

    u.timer.performWithDelay(5000, myFunction)

    u.timer.cancelAll()

:: EXAMPLE 2 ::

    local myFunction = function()
        print("my function")  <== This will never print
    end

    local mySecondFunction = function()
        print("my second function") <== This will print!
    end

    u.timer.performWithDelay(5000, myFunction)
    u.timer.performWithDelay(5000, mySecondFunction, false)

    u.timer.cancelAll()

:: EXAMPLE 3 ::

    local seconds = 0
    local count = function()
        seconds = seconds + 1
        u.print(seconds)
    end

    myTimer = u.timer.performWithDelay(1000, count, 0, false) -- You may still use the repeat counter

    u.timer.cancelAll()

]]

local luau = u

u.helpArr.timer =
    'timer.performWithDelay( delay, function [, repeats, u.cache])'

u.cache.performWithDelay = timer.performWithDelay

local timerArray = {}

u.timer = u.timer or timer
u.timer.performWithDelay = function( time, callback, repeats, add )
    local repeats, add = repeats, add

    if type(repeats) == "boolean" then
        add = repeats
        repeats = nil
    end

    local t = luau.cache.performWithDelay(time, callback, repeats)
    if add == true then
        timerArray[#timerArray+1] = t
    end


    t._begin = system.getTimer()
    t._delay = t._delay or time
    t.cancel = function()
        luau.timer.cancel(t)
        local v = luau.table.search(timerArray, t)
        if v then table.remove(timerArray, v) end
        t, v = nil, nil
    end
    t.pause = function()
        t._remaining = (t._count or 1 * t._delay) - (system.getTimer() - t._begin)
        luau.timer.cancel(t)
        t.paused = true
    end
    t.resume = function()
        if t.paused then
            local tmp = t._delay
            if repeats then
            else
                t = luau.cache.performWithDelay(t._remaining, callback, add)
            end
            t._delay = tmp
            t._begin = system.getTimer()
            t.paused, t._remaining, tmp = nil, nil, nil
        end
    end


    return t
end

u.helpArr.cancelAll = 'timer.cancelAll()'
u.timer.cancelAll = function()
    while #timerArray > 0 do
        luau.timer.cancel(table.remove(timerArray,1))
    end
end
