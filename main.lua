
            --[[ ########## Require ########## ]]--

require 'lua.u'

extend()
override()

            --[[ ########## Init Font Demo ########## ]]--

initFont("FlyerLT-BlackCondensed", "flyer")

            --[[ ########## New Paragraph Demo ########## ]]--

local format = {}
format.font = flyer
format.size = 20
format.lineHeight = 1.4
format.align = "center"
format.textColor = {"ffffff"}

local myParagraph = display.newParagraph( "Welcome to the Crawl Space Library!", 15, format)
myParagraph.x, myParagraph.y = centerX, screenHeight*.2

            --[[ ########## Help Demo ########## ]]--

CSL.help("newParagraph")

CSL.help()

            --[[ ########## Timer Demo ########## ]]--

 -- This will never fire because it's cancelled
local outputMessage = function()
    print("Timer 1 activated!")
end

 -- This WILL fire because it's told not to be a part of the cancelAll cache
local outputMessage2 = function()
    print("Timer 2 activated!")
end

timer.performWithDelay(500, outputMessage )
timer.performWithDelay(1000, outputMessage2, false )

timer.cancelAll()
timer.cancel(myNonexistentTimer) -- Cancelling a nil timer does not break your app

            --[[ ########## Multiple Transition Demo ########## ]]--

local mySquare, myCircle
local mTrans = function()
    mySquare = display.newRect( 10, 20, 10, 10 )
    mySquare.onComplete = function() print("transition 1") end
    mySquare:fadeIn()

    myCircle = display.newCircle( screenX + screenWidth - 10, 20, 5, "tr") -- Set the reference point as an argument
    myCircle.onComplete = function() print("transition 2") end
    myCircle:fadeIn()

    -- The new "targetSelf" params will target the onComplete table listener of each source
    transition.to({mySquare, myCircle}, {time=5000, y=screenHeight - 20, targetSelf=true})
end
timer.performWithDelay(1500, mTrans, false)

            --[[ ########## Multiple Inserts Demo ########## ]]--

local group = display.newGroup()
group:insert(myParagraph, mySquare, myCircle)

group:fadeIn()

            --[[ ########## Internet-Based Functions Demo ########## ]]--

local webz = function()
    print("Congrats! You have a connection to the internet!")
end

local noWebz = function()
    print("Sorry, you are not connected to the internet.")
end

executeIfInternet(webz, noWebz)
