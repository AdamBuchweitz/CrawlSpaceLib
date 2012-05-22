
            --[[ ########## Safe Web Popups  ########## ]--

Now when you want to make a web popup, it's active on the device,
but in the u.simulator you'll see a rectangle in the same place as your
popup. Now you won't need to build and install  to set it's position.

:: EXAMPLE ::

    native.showWebPopup( 10, 10, u.screenWidth - 20, u.screenHeight - 20, "http://crawlspacegames.com", {urlRequest=listener})

]]

u.cache.showWebPopup, u.cache.cancelWebPopup = native.showWebPopup, native.cancelWebPopup
local curPopup
u.native = u.native or native
u.native.showWebPopup = function( x, y, w, h, url, params )
    if not u.simulator then u.cache.showWebPopup(x, y, w, h, url, params)
    else curPopup = u.display.newRect(x, y, w, h); curPopup:setFillColor( 100, 100, 100 ) end
end

u.native.cancelWebPopup = function()
    if curPopup and curPopup.removeSelf then display.remove(curPopup) else u.cache.cancelWebPopup() end
end

if not u.NOCONFLICT then native.showWebPopup, native.cancelWebPopup = u.native.showWebPopup, u.native.cancelWebPopup end