module(..., package.seeall)
local audio  = require "audio"

-- Set this to false to bypass the welcome message
local showIntro = false

-- Set this to false to bypass the random Lua/CoronaSDK tips
local showTip = true

            --[[ ########## Global Screen Dimensions ########## ]--

Use these global variables to position your elements. They are dynamic
to all resolutions. Android devices are usually taller, so use screenY to
set the position where you expect 0 to be. The iPad is wider than iPhones,
so use screenY. Also the width and height need to factor these differences
in as well, so use screenWidth and screenHeight. Lastly, centerX and cetnerY
are simply global remaps of display.contentCenterX and Y.

:: USAGE ::

    myObject.x, myObject.y = screenX + 10, screenY + 10 -- Position 10 pixels from the top left corner on all devices

    display.newText("centered text", centerX, centerY, 36) -- Center the text

    display.newRect(screenX, screenY, screenWidth, screenHeight) -- Cover the screen, no matter what size

]]
local centerX, centerY = display.contentCenterX, display.contentCenterY
local screenX, screenY = display.screenOriginX, display.screenOriginY
local screenWidth, screenHeight = display.contentWidth - screenX * 2, display.contentHeight - screenY * 2
_G.centerX, _G.centerY, _G.screenX, _G.screenY, _G.screenWidth, _G.screenHeight = centerX, centerY, screenX, screenY, screenWidth, screenHeight
display.contentWidth, display.contentHeight = screenWidth, screenHeight

            --[[ ########## Global Content Scale and Suffix  ########## ]--

Checks the content scaling and sets a global var "scale". In addition,
if you use sprite sheets and was retina support, append the global "suffix"
variable when calling your datasheet, and it will pull the hi-res version
when it's needed. On the topic of devices and scals, when in the simulator,
the global variable "simulator" is set to true.

]]

local scale, suffix = display.contentScaleX, ""
if scale < 1 then suffix = "@2x" end
_G.scale, _G.suffix = scale, suffix

if system.getInfo("environment") == "simulator" then _G.simulator = true end

            --[[ ########## Saving and Loading ########## ]--

This bit has been mostly barrowed from the Ansca documentation,
we simply made it easier to use.

You keep one table of information, with as many properties
as you like. Simply pass this table into to Save() and it
will be taken care of. To load it, just call Load() which
returns the table.


:: SAVING EXAMPLE ::

    local myData     = {}
    myData.bestScore = 500
    myData.volume    = .8

    Save(myData)

:: LOADING EXAMPLE ::

    local myData = Load()
    print(myData.bestScore) <== 500
    print(myData.volume)    <== .8

]]

local split = function(str, pat)
    local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then table.insert(t,cap) end
        last_end = e+1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t,cap)
    end
    return t  
end

local saveData = function(table, fileName)
    local filePath = system.pathForFile( fileName or "data.txt", system.DocumentsDirectory )
    local file = io.open( filePath, "w" )

    for k,v in pairs( table ) do
        file:write( k .. "=" .. tostring(v) .. "," )
    end

    io.close( file )
end
_G.Save = saveData

local loadData = function(fileName)
    local filePath = system.pathForFile( fileName or "data.txt", system.DocumentsDirectory )
    local file = io.open( filePath, "r" )

    if file then
        local dataStr = file:read( "*a" )
        local datavars = split(dataStr, ",")
        dataTableNew = {}

        for i = 1, #datavars do
            local onevalue = split(datavars[i], "=")
            dataTableNew[onevalue[1]] = onevalue[2]
        end

        io.close( file ) -- important!
        return dataTableNew
    else
        print("Hey, ya gotta create the file first. Try using: Save(yourTable)")
        return false
    end
end
_G.Load = loadData

            --[[ ########## Reference Point Shorthand ########## ]--

All this block does it set shorthand notations for all reference points.
The main purpose of this is for passing short values into display objects.

:: EXAMPLE 1 ::

    myObject:setReferencePoint(display.tl)

]]

display.tl = display.TopLeftReferencePoint
display.tc = display.TopCenterReferencePoint
display.tr = display.TopRightReferencePoint
display.cl = display.CenterLeftReferencePoint
display.c  = display.CenterReferencePoint
display.cr = display.CenterRightReferencePoint
display.bl = display.BottomLeftReferencePoint
display.bc = display.BottomCenterReferencePoint
display.br = display.BottomRightReferencePoint

            --[[ ########## Crawlspace Display Objects Methods   ########## ]--

Here is where the magic happens to all display objects. All methods are given
a fadeIn() and fadeOut() method, to be used with optional parameters. You can
include a callback if you'd like, or tell your fadeOut() to automatically remove
the object when it's completed.

If dynamic resolutions scare you, then you may use the setPos() method attached
to every display object. It will take care of the dynamic part - just style it
once. Also if you find yourself centering a lot of objects, you can call their
center() method and either pass in "x", "y", or nothing to center both axis'.

:: USAGE ::

    myObject:fadeIn([time, callback])

    myObject:fadeOut([time, callback, autoRemove])

    myObject:center("x")

    myObject:setPos(100, 200)

:: EXAMPLE 1 ::

    myImage = display.newImage("myImage")
    myImage:center()
    myImage:fadeIn()
    timer.performWithDelay( 2000, myImage.fadeOut )

:: EXAMPLE 2 ::

    local myRectangle = display.newRect(0,0,100,50)
    myRectangle:setPos(25, 25)

]]

local tranc = transition.cancel
local displayMethods = function( obj )
    local d = obj
    d.setPos = function(self,x,y) d.x, i.y = screenX+x, screenY+y end
    d.center = function(self,axis) if axis == "x" then d.x=centerX elseif axis == "y" then d.y=centerY else d.x,d.y=centerX,centerY end end
    d.fader={}
    d.fadeIn = function( self, num, callback ) tranc(d.fader); d.alpha=0; d.fader=transition.to(d, {alpha=1, time=num or 500, onComplete=callback}) end
    d.fadeOut = function( self, time, callback, autoRemove) d.callback = callback; if type(callback) == "boolean" then d.callback = function() d:removeSelf() end elseif autoRemove then d.callback = function() callback(); d:removeSelf() end end tranc(d.fader); d.fader=transition.to(d, {alpha=0, time=time or 500, onComplete=d.callback}) end
end

            --[[ ########## CrawlSpace Reference Points  ########## ]--

Shorthand for all reference points.
As an added bonus, if your image cannot be created, it will print out
a nice warning message with wheatever image path was at fault.

:: EXAMPLE 1 ::

    myObject:setReferencePoint(display.tl)

]]

local referencePoints = function( obj, point )
    local rp = display[point] or display.c
    if obj then obj:setReferencePoint(rp); return true
    else print("My deepest apologies, but there was a problem creating your display object... could you have mistyped your path?\n\n\n"); return false end
end

            --[[ ########## NewGroup Override  ########## ]--

At long last you may insert multiple objects into a group with
a single line! There is no syntax change, and you may still insert
object when instantiating the group.

:: USAGE ::

    myGroup:insert([index, ] myObject [, mySecondObject, myThirdObject, resetTransform])

:: EXAMPLE 1 ::

    local myGroup = display.newGroup()
    myGroup:insert(myImage, myRect, myRoundedRect, myImageRect)

:: EXAMPLE 2 ::

    local myGroup = display.newGroup(firstObject, secondObject)
    myGroup:insert(thirdObject, forthObject)

:: EXAMPLE 3 ::

    local myGroup = display.newGroup()
    myGroup:insert( 1, myObject, mySecondObject) -- inserting all objects at position 1

:: EXAMPLE 4 ::

    local myGroup = display.newGroup()
    myGroup:insert( myObject, mySecondObject, true) -- resetTransform still works too!

]]

local crawlspaceInsert = function(...)
    local t = {...}
    local b, reset = 0, nil
    if type(t[#t]) == "boolean" then b = 1; reset = t[#t] end
    if type(t[2]) == "number" then for i=3, #t-b do t[1]:cachedInsert(t[2],t[i],reset) end
    else for i=2, #t-b do t[1]:cachedInsert(t[i],reset) end
    end
end
local cachedNewGroup = display.newGroup
crawlspaceNewGroup = function(...)
    local g = cachedNewGroup(...)
    g.cachedInsert = g.insert
    g.insert = crawlspaceInsert
    displayMethods( g )
    return g
end
display.newGroup = crawlspaceNewGroup

            --[[ ########## NewRect Override  ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newRect(0, 0, 100, 50 [, "tl"])

]]

local cachedNewRect = display.newRect
crawlspaceNewRect= function( x, y, w, h, rp )
    local r = cachedNewRect( x, y, w, h )
    if referencePoints( r, rp ) then displayMethods( r ) end
    return r
end
display.newRect= crawlspaceNewRect

            --[[ ########## NewRoundedRect Override  ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newRoundedRect( 0, 0, 100, 50, 10 [, "tl"])

]]

local cachedNewRoundedRect = display.newRoundedRect
local crawlspaceNewRoundedRect = function( x, y, w, h, r, rp )
    local r = cachedNewRoundedRect( 0, 0, w, h, r ); r.x,r.y=x,y
    if referencePoints( r, rp ) then displayMethods( r ) end
    return r
end
display.newRoundedRect= crawlspaceNewRoundedRect

            --[[ ########## NewImage Override  ########## ]--

The enhancement to newImage is that if you omit the x and y,
they will be set to the dynamic rasolution values for 0, 0.

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newImage("myImage.png" [, 100, 50, "tl"])

]]

local cachedNewImage = display.newImage
crawlspaceNewImage= function( path, x, y, rp )
    local i = cachedNewImage( path, x or screenX, y or screenY )
    if referencePoints( i, rp ) then displayMethods( i ) end
    return i
end
display.newImage= crawlspaceNewImage

            --[[ ########## NewImageRect Override  ########## ]--

Enhanced newImageRect has the option to omit the width and height.
They wil be defaulted to the "magic" sizes of 380 wide by 570 tall.

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newImageRect("myImage.png" [, 100, 50, "tl"])

:: EXAMPLE 2 ::

    display.newImageRect("myImage.png")

]]

local cachedNewImageRect = display.newImageRect
crawlspaceNewImageRect = function( path, w, h, rp )
    local i = cachedNewImageRect( path, w or 380, h or 570 )
    if referencePoints( i, rp ) then displayMethods( i ) end
    return i
end
display.newImageRect = crawlspaceNewImageRect

            --[[ ########## Auto Retina Text ########## ]--

This feature doesn't require much explanation. It overrides the default
CoronaSDK display.newText and replaces it with auto retina text,
which is simply doubling the text size and scaling it down.
The only extra step is setting the position AFTER text is scaled,
which solves a positioning problem after scaling.

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE ::

    display.netText("My New Text", 100, 100, system.defaultFont, 36 [, "cr" ] )

]]

local cachedNewText = display.newText
local crawlspaceNewText = function( text, xPos, yPos, font, size, rp )
    local t = cachedNewText(text, 0, 0, font, size * 2)
    referencePoints( t, rp ); displayMethods(t)
    t.xScale, t.yScale, t.x, t.y = .5, .5, xPos, yPos
    return t
end
display.newText = crawlspaceNewText

            --[[ ########## New Paragraphs ########## ]--

Making paragraphs is now pretty easy. You can call the paragraph
by itself, passing in the text size as the last parameter, or you
can apply various formatting properties. Right now the list of
available properties are:

font       = myCustomFont
lineHeight = 1.4
align      = ["left", "right", "center"]
textColor  = 255, 0, 0

The method returns a group, which cannot be directly editted (yet),
but can be handled like any other group. You may position it,
transition it, insert it into another group, etc.

:: USAGE ::

    display.newParagraph( text, charactersPerLine, size or parameters )

:: EXAMPLE 1 ::

    local format = {}
    format.font = flyer
    format.size = 36
    format.lineHeight = 2
    format.align = "center"

    local myParagraph = display.newParagraph( "Welcome to the Crawl Space Library!", 15, format)
    myParagraph:center("x")
    myParagraph:fadeIn()

:: EXAMPLE 2 ::

    local myParagraph = display.newParagraph( "I don't care about formatting this paragraph, just place it", 20, 24 )

]]

local textAlignments = {left="cl",right="cr",center="c",centered="c",middle="c"}
display.newParagraph = function( string, width, params )
    local format; if type(params) == "number" then format={size = params} else format=params end
    local splitString, lineCache, tempString = split(string, " "), {}, ""
    for i=1, #splitString do
        if #tempString + #splitString[i] > width then lineCache[#lineCache+1]=tempString; tempString=splitString[i].." "
        else tempString = tempString..splitString[i].." " end
    end
    lineCache[#lineCache+1]=tempString
    local g, align = display.newGroup(), textAlignments[format.align or "left"]
    for i=1, #lineCache do
        g.text=(g.text or "")..lineCache[i]
        local t=display.newText(lineCache[i],0,( format.size * ( format.lineHeight or 1 ) ) * i,format.font, format.size, align); if format.textColor then t:setTextColor(format.textColor[1],format.textColor[2],format.textColor[3]) end g:insert(t)
    end
    return g
end

            --[[ ########## Timer Hijack ########## ]--

This override is here to snag every timer and cache it into
an array for later cancelling. There is no change in syntax,
none of your code will break.

Sometimes you will want to cancel all timers EXCEPT a few,
in which case simply pass in "false" when you creat your timer.

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

local timerArray = {}
local cachedTimer = timer.performWithDelay
timerWithTracking = function( time, callback, repeats, add )
    local repeats, add = repeats, add
    if type(repeats) == "boolean" then add = repeats; repeats = nil end
    local t = cachedTimer(time, callback, repeats)
    if add ~= false then
        timerArray[#timerArray+1] = t
    end
    return t
end

local cancelAllTimers = function()
    for i=1, #timerArray do
        timer.cancel(timerArray[i])
    end
end
timer.cancelAll = cancelAllTimers
timer.performWithDelay = timerWithTracking

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

local cachedTimerCancel = timer.cancel
local safeCancel = function(t)
    if t then cachedTimerCancel(t) else print("Whoops, that timer doesn't exist!") end
end
timer.cancel = safeCancel

            --[[ ########## Crossfade Background Music ########## ]--

Crossfading your background music gives your games a lot more polish. Using
the Crawl Space Library, this is easy! The first two audio channels are
reserved automatically, and when you call the method it keeps track of
which one is not in use for the next crossfade. You should even call this
method for the first play of the background music.

The Crawl Space Library also registers a variable called "volume", and that
is where the cross fader gets the start / end points. So if your app has
a slider that changes the volume, do not forget to change the volume variable!

:: EXAMPLE 1 ::

    audio.crossFadeBackground("myBackgroundMusic")

:: EXAMPLE 2 ::

    setVar{"volume", .5, true}
    audio.crossFadeBackground("myBackgroundMusic")
]]

local audioChannel, otherAudioChannel, currentSong, curAudio, prevAudio = 1
local crossFadeBackground = function( path )
    local musicPath = path or retrieveVariable("musicPath")
    if currentSong == musicPath and audio.getVolume{channel=audioChannel} > 0.1 then return false end
    audio.fadeOut({channel=audioChannel, time=500})
    if audioChannel==1 then audioChannel,otherAudioChannel=2,1 else audioChannel,otherAudioChannel=1,2 end
    audio.setVolume( retrieveVariable("volume"), {audioChannel})
    curAudio = audio.loadStream( musicPath )
    audio.play(curAudio, {channel=audioChannel, loops=-1, fadein=500})
    prevAudio = curAudio
    currentSong = musicPath
    audio.currentBackgroundChannel = audioChannel
end
audio.reserveChannels(2)
audio.currentBackgroundChannel = 1
audio.crossFadeBackground = crossFadeBackground

            --[[ ########## True or False SFX ########## ]--

Your game probably will have a toggle to turn on and off sound effect,
but it's a major pain to check the variable everytime you want to
play one. If you, instead, adjust the auto-registered "sfx" variable,
audio.playSFX will handle the checking for you. Additionaly, playSFX
can handle a string or a preloaded sound. If you are playing the sounds
often, you should still preload it.

:: EXAMPLE 1 ::

    audio.playSFX("sfx_tap.aac")

:: EXAMPLE 2 ::

    local hitSFX = audio.loadSound("sfx_hit.aac")
    audio.playSFX( hitSFX )

:: EXAMPLE 3 ::

    setVar{"sfx", false}

    local hitSFX = audio.loadSound("sfx_hit.aac")
    audio.playSFX( hitSFX ) -- This will not play the sound now

]]

local newSFX = function( snd )
    if retrieveVariable("sfx") == true then
        if type(snd) == "string" then return audio.play(audio.loadSound( snd ))
        else return audio.play(snd) end
    end
end
audio.playSFX = newSFX

            --[[ ########## Safe Web Popups  ########## ]--

Now when you want to make a web popup, it's active on the device,
but in the simulator you'll see a rectangle in the same place as your
popup. Now you won't need to build and install  to set it's position.

:: EXAMPLE ::

    native.showWebPopup( 10, 10, screenWidth - 20, screenHeight - 20, "http://crawlspacegames.com", {urlRequest=listener})

]]

local cachedPopup, cachedCancelWeb, curPopup = native.showWebPopup, native.cancelWebPopup
local safeWebPopup = function( x, y, w, h, url, params )
    if not simulator then cachedPopup(x, y, w, h, url, params)
    else curPopup = display.newRect(x, y, w, h); curPopup:setFillColor( 100, 100, 100 ) end
end
local safeCancelPopup = function()
    if curPopup then curPopup:removeSelf() else cachedCancelWeb() end
end
native.showWebPopup = safeWebPopup
native.cancelWebPopup = safeCancelPopup

            --[[ ########## Print Available Fonts  ########## ]--

Call printFonts() to see a printed list of all installed fonts.
This comes in really handy when you want to use a custom font, 
as you need to register the actual name of the font, and not the
name of the file.


:: EXAMPLE ::

    printFonts()

]]

_G.printFonts = function()
    local fonts = native.getFontNames()
    for k,v in pairs(fonts) do print(v) end
end

            --[[ ########## Easy Global Font ########## ]--

There really isn't anything to this function, it just sets a global
variable to whatever name you want the font to be. It just keeps the
mind clear.

:: EXAMPLE 1 ::

    initFont("FlyerLT-BlackCondensed", "flyer")

    display.newText("This will be written in Flyer!", 0, 0, flyer, 36)

]]

_G.initFont = function( fontName, globalName ) _G[globalName] = fontName end

            --[[ ########## Execute If Internet ########## ]--

This very useful little method downloads a webpage from the internet,
establishing whether or not the device has internet connectivity. 

You can pass any function in at anytime. If there is internet, it fires.
If there is no internet, it doesn't fire the function, and if we don't yet know
if there is connectivity, the method is cached until we do know. You also
have the option of passing in a method to fire if there is not internet.
You may pass as many functions in as you have necessity.

In addition, once we know whether or not there is internet, a global
variable "internet" is set to true or false. Just make sure you don't try
so access it during the first few seconds of launch.

:: EXAMPLE 1 ::

    local myFunction = function()
        print("I haz interwebz!")
    end

    executeIfInternet(myFunction)


:: EXAMPLE 2 ::

    local myFunction = function()
        print("I haz interwebz!")
    end

    -- Returns true for internet, false if not, and nil if unkown when called
    local executed = executeIfInternet(myFunction)

    if executed == true then
        print("It executed imidiately")
    elseif executed == false then
        print("It never executed")
    else
        print("We don't yet know if it executed")
    end


:: EXAMPLE 3 ::

    local myInternetFunction = function()
        print("I haz interwebz!")
    end

    local myNonInternetFunction = function()
        print("Internet fail")
    end

    executeIfInternet(myInternetFunction, myNonInternetFunction)

]]

local toExecute = {}
local executeOnNet = function()
    for i=1, #toExecute do local f = table.remove(toExecute); f(); f=nil end
end
-- Sets global variable "internet"
local internetListener = function( event )
    if event.isError then _G.internet = false
    else _G.internet = true; executeOnNet() end
    return true
end
network.request("http://google.com/", "GET", internetListener)

_G.executeIfInternet = function(f)
    if internet then f(); return true
    elseif internet == false then return false
    elseif internet == nil then toExecute[#toExecute+1] = f end
end

            --[[ ########## Global Information Handling ########## ]--

Some of you may choose not to use this set of functions because global
information is generally a bad idea. What I use this for is tracking data
across the entire app, that may need to be changes in any one of a myriad
different files. For me the trade off is worth it. In main.lua I register
whatever variables I will need to track, and many of those I retrieve on
applicationExit to save them for use on next launch. Other than saving data,
it's very helpful to use these to keep track of a score, or a volume leve,
whether or not to play SFX, etc.

As a side note, Crawl Space Library automatically registers a variable for
"volume" and "sfx", as these are going to be used in most projects.

:: USAGE ::

    registerVar{ variableName, initialValue }

    registerBulk({ name1, name2, name3, name4}, initialValue)

    getVar(variableName)

    setVar{variableName, value [, true]}

:: EXAMPLE 1 ::

    registerVar{"sfx", true}

    setVar{"sfx", false}

    print(getVar("sfx")) <== prints false

:: EXAMPLE 2 ::

    registerVar{"score", 0}

    setVar{"score", 1}
    setVar{"score", 2} -- Because "score" is a number, these add rather then set

    print(getVar("score")) <== prints 3

    setVar{"score", 0, true} -- Setting the last argument to true makes a number set rather than add

    print(getVar("score")) <== prints 0

]]

local registeredVariables = {}
local registerVariable = function(...)
    local var, var2 = ...; var = var2 or var
    registeredVariables[var[1]] = var[2]
end
_G.registerVar = registerVariable

local registerBulk = function(...)
    local var, var2 = ...; var = var2 or var
    for i,v in ipairs(var[1]) do registerVariable{var[1][i], var[2]} end
end
_G.registerBulk = registerBulk

local retrieveVariable = function(...)
    local name, name2 = ...; name = name2 or name
    return registeredVariables[name]
end
_G.getVar = retrieveVariable

local adjustVariable = function(...)
    local new, new2 = ...; new = new2 or new
    if type(new[2]) == "number" then
        registeredVariables[new[1]] = registeredVariables[new[1]] + new[2]
        if new[3] then registeredVariables[new[1]] = new[2] end
    else registeredVariables[new[1]] = new[2] end
end
_G.setVar = adjustVariable

registerVariable{"volume", 1}
registerVariable{"sfx", true}

            --[[ ########## Extended Print ########## ]--

It's pointless to print out a table - instead you want the key/value
pairing of the table. This extended print does just that, as well as
ading a blank line between prints for easier reading. Lastly, this will
only print on the simulator. You shouldn't leave your prints in your final
app anyway, but if you do this should help improve performance.

]]

local cachedPrint = print
local extendedPrint = function( ... )
    local a = ...
    if system.getInfo("environment") == "simulator" then
        if type(a) == "table" then
            cachedPrint("\nOutput Table Data:\n")
            for k,v in pairs(a) do cachedPrint("\tKey: "..k, "Value: ", v) end
        elseif #{...} > 1 then cachedPrint("\nOutput mutiple: ", ...)
        else cachedPrint("\nOutput "..type(a).." :: ", a or "") end
    end
end
_G.print = extendedPrint

local welcome = function()
    local print = cachedPrint
    print("\n\n")
    print("CrawlSpaceLib v1.0\n")
    print("Welcome to the CrawlSpace Library!\n\n\tA lot of work has gone into making this very powerful while also keeping it very, very easy to use.")
    print("\n\n")

    local device=""; if scale==.5 then device="@2x" elseif scale<.5 then device="@iPad" end
    local lsntr = function ( event ) if not event.isError then local t=event.target; t.xScale,t.yScale=scale,scale; t.x,t.y=centerX,centerY; t:fadeIn(); t.timer=function()t:fadeOut(500,true)end; timer.performWithDelay(2000, t) end end
    display.loadRemoteImage( "http://crawlspacegames.com/images/splash"..device..".png", "GET", lsntr, "splash"..device..".png", system.TemporaryDirectory )
end

local showTip = function()
    print("A tasty treat goes here!")
end

if showIntro then welcome() elseif startupTips then showtip() end
