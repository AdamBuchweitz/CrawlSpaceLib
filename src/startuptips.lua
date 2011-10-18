
            --[[ ########## Startup Tips ########## ]--

If you want to disable these, change the 'startupTips' to false.
If you have a tip to share, please email it to me at

        adam@crawlspacegames.com

and I'll include it here.

]]

local tipArray = {
    "Local, local, local, local... Always remember to think local",
    "Global is baaaad!",
    "'print' is your #1 debugging tool",
    "Paragraphs can be aligned 'left', 'right', and 'center'.",
    "The full paragraph text is accessible with yourParagraph.text",
    "You can disable these tips by setting the 'startupTips' variable to false in crawlspacelib.lua",
    "Try running .help() for syntax help ( i.e. CSL.help('executeIfInternet'))",
    "Do you have a helpful Lua or CoronaSDK tip? Please send it to me and I'll include it in the library!"
}
local showTip = function()
    cache.print("\n\nTip:\n\n\t"..tipArray[random(1,#tipArray)])
end
