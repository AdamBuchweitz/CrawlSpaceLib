
            --[[ ########## Timer Hijack ########## ]--

This override is here to snag every timer and cache it into
an array for later cancelling. There is no change in syntax,
none of your code will break.

Sometimes you will want to cancel all timers EXCEPT a few,
in which case simply pass in "false" when you create your timer.

:: EXAMPLE 1 ::

    local myFunction = function()
        print("my function")  <== This will never print
    end

    timer.performWithDelay(5000, myFunction)

    timer.cancelAll()

:: EXAMPLE 2 ::

    local myFunction = function()
        print("my function")  <== This will never print
    end

    local mySecondFunction = function()
        print("my second function") <== This will print!
    end

    timer.performWithDelay(5000, myFunction)
    timer.performWithDelay(5000, mySecondFunction, false)

    timer.cancelAll()

:: EXAMPLE 3 ::

    local seconds = 0
    local count = function()
        seconds = seconds + 1
        print(seconds)
    end

    myTimer = timer.performWithDelay(1000, count, 0, false) -- You may still use the repeat counter

    timer.cancelAll()

]]

return function(CSL, private, cache)
	private.helpArr.timer = 'timer.performWithDelay( delay, function [, repeats, omitFromCancelAll])'
	local timerArray = {}
	cache.performWithDelay = timer.performWithDelay
	timer.performWithDelay = function( time, callback, repeats, add )
		local repeats, add = repeats, add
		if type(repeats) == "boolean" then add = repeats; repeats = nil end
		local t = cache.performWithDelay(time, callback, repeats)
		t._begin = system.getTimer()
		t._delay = t._delay or time
		t.cancel = function()
			timer.cancel(t)
			local v = table.search(timerArray, t)
			if v then table.remove(timerArray, v) end
			t, v = nil, nil
		end
		t.pause = function()
			t._remaining = (t._count or 1 * t._delay) - (system.getTimer() - t._begin)
			timer.cancel(t)
			t.paused = true
		end
		t.resume = function()
			if t.paused then
				local tmp = t._delay
				if repeats then
				else
					t = cache.performWithDelay(t._remaining, callback, add)
				end
				t._delay = tmp
				t._begin = system.getTimer()
				t.paused, t._remaining, tmp = nil, nil, nil
			end
		end
		if add == true then
			timerArray[#timerArray+1] = t
		end
		return t
	end
	
	private.helpArr.cancelAll = 'timer.cancelAll()'
	timer.cancelAll = function()
		while #timerArray > 0 do
			timer.cancel(table.remove(timerArray,1))
		end
	end
end
