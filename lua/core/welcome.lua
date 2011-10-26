
        --[[ ########## Welcome! ########## ]]--

local welcome = function()
    local print = u.cache.print or print
    print("\n\n")
    print("Lua.u v1.2\n")
    print("Welcome to Lua.u!\n\n\t    A lot of work has gone into making this very powerful while also\n\tkeeping it very, very easy to use. With that being said, we will happily\n\taccept your donation! Try the library out, see if it saves you any time,\n\teffort, or headaches, and even if you don't decide to donate, I'd still\n\tlove to hear about your experience.")
    print("\n\t    Take a peek at crawlspacelib.lua for detailed instructions on\n\thow to use the library, or just take advantage of its features passivly,\n\tas many are simple enhancements to existing CoronaSDK functionality.\n\tAlternatively, you may run the u.listFeatures() method to\n\tget a quick list of everything included.")
    print("\n\n\tDonate: http://www.crawlspacegames.com/crawl-space-corona-sdk-library/\n\n\tEmail me: adam@crawlspacegames.com")

    local device = ""
    local scale = display.contentScaleX
    if scale == 0.5 then
        device = "@2x"
    elseif scale < 0.5 then
        device = "@iPad"
    end

    local lsntr = function ( event )
        if not event.isError then
            local t = event.target
            t.xScale, t.yScale = scale, scale
            t.x, t.y = centerX, centerY
            t.alpha = 0
            transition.to(t, {time=500, alpha=1})
            t.timer = function()
                transition.to(t, {time=500, alpha=0, onComplete =
                    function()
                        display.remove(t)
                    end})
            end
            timer.performWithDelay(2000, t)
        end
    end
    display.loadRemoteImage( "http://crawlspacegames.com/images/splash"..device..".png", "GET", lsntr, "splash"..device..".png", system.TemporaryDirectory )
end

if INTRO then welcome() end
