
            --[[ ########## Safe Web Popups  ########## ]--

Now when you want to make a web popup, it's active on the device,
but in the simulator you'll see a rectangle in the same place as your
popup. Now you won't need to build and install  to set it's position.

:: EXAMPLE ::

    native.showWebPopup( 10, 10, screenWidth - 20, screenHeight - 20, "http://crawlspacegames.com", {urlRequest=listener})

]]

cache.showWebPopup, cache.cancelWebPopup = native.showWebPopup, native.cancelWebPopup
local curPopup
native.showWebPopup = function( x, y, w, h, url, params )
    if not simulator then cache.showWebPopup(x, y, w, h, url, params)
    else curPopup = display.newRect(x, y, w, h); curPopup:setFillColor( 100, 100, 100 ) end
end

native.cancelWebPopup = function()
    if curPopup and curPopup.removeSelf then display.remove(curPopup) else cache.cancelWebPopup() end
end
