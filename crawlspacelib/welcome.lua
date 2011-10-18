
            --[[ ########## Welcome! ########## ]]--

return function(CSL, private, cache)
	local welcome = function()
		local print = cache.print
		print("\n\n\nYou can disable this welcome message by setting the 'private.showIntro' variable to\nfalse in crawlspacelib.lua")
		print("\n\n")
		print("CrawlSpaceLib v1.1.3\n")
		print("Welcome to the CrawlSpace Library!\n\n\t    A lot of work has gone into making this very powerful while also\n\tkeeping it very, very easy to use. With that being said, we will happily\n\taccept your donation! Try the library out, see if it saves you any time,\n\teffort, or headaches, and even if you don't decide to donate, I'd still\n\tlove to hear about your experience.")
		print("\n\t    Take a peek at crawlspacelib.lua for detailed instructions on\n\thow to use the library, or just take advantage of its features passivly,\n\tas many are simple enhancements to existing CoronaSDK functionality.\n\tAlternatively, you may run the crawlspacelib.listFeatures() method to\n\tget a quick list of everything included.")
		print("\n\n\tDonate: http://www.crawlspacegames.com/crawl-space-corona-sdk-library/\n\n\tEmail me: adam@crawlspacegames.com")
	
		local device=""; if scale==.5 then device="@2x" elseif scale<.5 then device="@iPad" end
		local lsntr = function ( event ) if not event.isError then local t=event.target; t.xScale,t.yScale=scale,scale; t.x,t.y=centerX,centerY; t:fadeIn(); t.timer=function()t:fadeOut(500,true)end; timer.performWithDelay(2000, t) end end
		display.loadRemoteImage( "http://crawlspacegames.com/images/splash"..device..".png", "GET", lsntr, "splash"..device..".png", system.TemporaryDirectory )
	end
	
	if private.showIntro then welcome() elseif private.startupTips then private.showTip() end
end
