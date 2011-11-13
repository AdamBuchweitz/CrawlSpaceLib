
            --[[ ########## Require ########## ]]--

require 'lua.u'

local luau = extend()

            --[[ ########## Init Font Demo ########## ]]--

luau.initFont("FlyerLT-BlackCondensed", "flyer")

            --[[ ########## New Paragraph Demo ########## ]]--

local format = {}
format.font = flyer
format.size = 20
format.lineHeight = 1.4
format.align = "center"
format.textColor = {"ffffff"}

local myParagraph = luau.display.newParagraph( "Welcome to the Crawl Space Library!", 15, format)
myParagraph.x, myParagraph.y = luau.centerX, luau.screenHeight*.2

            --[[ ########## Help Demo ########## ]]--

--luau.help("newParagraph")

--luau.help()

            --[[ ########## Timer Demo ########## ]]--

 -- This will never fire because it's cancelled
local outputMessage = function()
    luau.print("Timer 1 activated!")
end

 -- This WILL fire because it's told not to be a part of the cancelAll luau.cache
local outputMessage2 = function()
    luau.print("Timer 2 activated!")
end

luau.timer.performWithDelay(500, outputMessage )
luau.timer.performWithDelay(1000, outputMessage2, false )

luau.timer.cancelAll()
luau.timer.cancel(myNonexistentTimer) -- Cancelling a nil timer does not break your app

            --[[ ########## Multiple Transition Demo ########## ]]--

local mySquare, myCircle
local mTrans = function()
    mySquare = luau.display.newRect( 10, 20, 10, 10 )
    mySquare.onComplete = function() luau.print("transition 1") end
    --mySquare:fadeIn()

    myCircle = luau.display.newCircle( luau.centerY + luau.screenWidth - 10, 20, 5, "tr") -- Set the reference point as an argument
    myCircle.onComplete = function() luau.print("transition 2") end
    --myCircle:fadeIn()

    -- The new "targetSelf" params will target the onComplete table listener of each source
    luau.transition.to({mySquare, myCircle}, {time=5000, y=luau.screenHeight - 20, targetSelf=true})
end
luau.timer.performWithDelay(1500, mTrans, false)

            --[[ ########## Multiple Inserts Demo ########## ]]--

local group = luau.display.newGroup()
--group:insert(myParagraph, mySquare, myCircle)

--group:fadeIn()

            --[[ ########## Internet-Based Functions Demo ########## ]]--

local webz = function()
    luau.print("Congrats! You have a connection to the internet!")
end

local noWebz = function()
    luau.print("Sorry, you are not connected to the internet.")
end

--luau.executeIfInternet(webz, noWebz)
