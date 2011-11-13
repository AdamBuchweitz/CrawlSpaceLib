
            --[[ ########## Safe Timer Cancel ########## ]--

There will inevitably come a time when you write something like:

    if myTimer then u.timer.cancel(myTimer) end

Instead of wasting time thinking about if the timer exists yet,
just cancel it like normal. If is doesn't exist, you will receive
a kind warning letting you know, but there be no error

:: EXAMPLE 1 ::

    local myTimer

    u.timer.cancel(myTimer) -- Even though the timer does not yet exist, there will be no error

    myTimer = u.timer.performWithDelay(10000, myFunction)

    u.timer.cancel(myTimer) -- It will now cancel like normal

]]

u.cache.timerCancel = timer.cancel
u.timer.cancel = function(t)
    if t then
        timerCancel(t)
    end
end

if not u.NOCONFLICT then timer.cancel = u.timer.cancel end
