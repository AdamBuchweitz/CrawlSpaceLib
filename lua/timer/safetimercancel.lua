
            --[[ ########## Safe Timer Cancel ########## ]--

There will inevitably come a time when you write something like:

    if myTimer then timer.cancel(myTimer) end

Instead of wasting time thinking about if the timer exists yet,
just cancel it like normal. If is doesn't exist, you will receive
a kind warning letting you know, but there be no error

:: EXAMPLE 1 ::

    local myTimer

    timer.cancel(myTimer) -- Even though the timer does not yet exist, there will be no error

    myTimer = timer.performWithDelay(10000, myFunction)

    timer.cancel(myTimer) -- It will now cancel like normal

]]

return function(CSL, private, cache)
	cache.timerCancel = timer.cancel
	timer.cancel = function(t) if t then cache.timerCancel(t) end end
end
