module(..., package.seeall)

-- Set this to false to bypass the welcome message
local intro = true

local audio  = require "audio"
local mCeil  = math.ceil
local mAtan2 = math.atan2
local mPi    = math.pi
local mSqrt  = math.sqrt

_G.initFont = function( fontName, globalName )
    _G[globalName] = fontName
end

            --########## Global Screen Dimensions ##########--
local centerX, centerY = display.contentCenterX, display.contentCenterY
local screenX, screenY = display.screenOriginX, display.screenOriginY
local screenWidth, screenHeight = display.contentWidth - screenX * 2, display.contentHeight - screenY * 2
_G.centerX, _G.centerY, _G.screenX, _G.screenY, _G.screenWidth, _G.screenHeight = centerX, centerY, screenX, screenY, screenWidth, screenHeight
display.contentWidth, display.contentHeight = screenWidth, screenHeight

            --########## Global Content Scale and Suffix ##########--
local scale, suffix = display.contentScaleX, ""
if scale < 1 then suffix = "@2x" end
_G.scale, _G.suffix = scale, suffix

if system.getInfo("environment") == "simulator" then _G.simulator = true end

            --########## Reference Point Shorthand ##########--
display.tl = display.TopLeftReferencePoint
display.tc = display.TopCenterReferencePoint
display.tr = display.TopRightReferencePoint
display.cl = display.CenterLeftReferencePoint
display.c  = display.CenterReferencePoint
display.cr = display.CenterRightReferencePoint
display.bl = display.BottomLeftReferencePoint
display.bc = display.BottomCenterReferencePoint
display.br = display.BottomRightReferencePoint

            --########## Crawlspace Display Objects Methods ##########--
local tranc = transition.cancel
local displayMethods = function( obj )
    local d = obj
    d.setPos = function(x,y) d.x, i.y = screenX+x, screenY+y end
    d.center = function() d.x, d.y = centerX, centerY end
    d.fader={}
    d.fadeIn = function( self, num, callback ) tranc(d.fader); d.alpha=0; d.fader=transition.to(d, {alpha=1, time=num or 500, onComplete=callback}) end
    d.fadeOut = function( self, time, callback, autoRemove) d.callback = callback; if type(callback) == "boolean" then d.callback = function() d:removeSelf() end elseif autoRemove then d.callback = function() callback(); d:removeSelf() end end tranc(d.fader); d.fader=transition.to(d, {alpha=0, time=time or 500, onComplete=d.callback}) end
end

            --########## Crawlspace Reference Points ##########--
local referencePoints = function( obj, point )
    local rp = display[point] or display.c
    if obj then
        obj:setReferencePoint(rp)
        return true
    else
        print("My deepest apologies, but I think you mistyped your image path. There was a problem creating your display object...\n\n\n")
        return false
    end
end
            --########## Group Override ##########--
local crawlspaceInsert = function(...)
    local t = {...}
    local b, reset = 0, nil
    if type(t[#t]) == "boolean" then b = 1; reset = t[#t] end
    if type(t[2]) == "number" then
        for i=3, #t-b do
            t[1]:cachedInsert(t[2],t[i],reset)
        end
    else
        for i=2, #t-b do
            t[1]:cachedInsert(t[i],reset)
        end
    end
end
local cachedNewGroup = display.newGroup
crawlspaceNewGroup = function(...)
    local g = cachedNewGroup(...)
    g.cachedInsert = g.insert
    g.insert = crawlspaceInsert
    --g.x, g.y = screenX, screenY
    displayMethods( g )
    return g
end
display.newGroup = crawlspaceNewGroup

            --########## NewRectOverride ##########--
local cachedNewRect = display.newRect
crawlspaceNewRect= function( x, y, w, h, rp )
    local r = cachedNewRect( x, y, w, h )
    if referencePoints( r, rp ) then
        displayMethods( r )
    end
    return r
end
display.newRect= crawlspaceNewRect

            --########## NewRoundRectOverride ##########--
local cachedNewRoundRect = display.newRoundRect
crawlspaceNewRoundRect= function( x, y, w, h, r, rp )
    local r = cachedNewRoundRect( x, x, w, h, r )
    if referencePoints( r, rp ) then
        displayMethods( r )
    end
    return r
end
display.newRoundRect= crawlspaceNewRoundRect

            --########## NewImageOverride ##########--
local cachedNewImage = display.newImage
crawlspaceNewImage= function( path, x, y, rp )
    local i = cachedNewImage( path, x or screenX, y or screenY )
    if referencePoints( i, rp ) then
        displayMethods( i )
    end
    return i
end
display.newImage= crawlspaceNewImage

            --########## NewImageRect Override ##########--
local cachedNewImageRect = display.newImageRect
crawlspaceNewImageRect = function( path, w, h, rp )
    local i = cachedNewImageRect( path, w or 380, h or 570 )
    if referencePoints( i, rp ) then
        displayMethods( i )
    end
    return i
end
display.newImageRect = crawlspaceNewImageRect

            --########## Timer override ##########--
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

local cachedTimerCancel = timer.cancel
local safeCancel = function(t)
    if t then cachedTimerCancel(t) else print("Whoops, that timer doesn't exist!") end
end
timer.cancel = safeCancel

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

            --########## Crossfade Background ##########--
local audioChannel, otherAudioChannel, currentSong, curAudio, prevAudio = 1
local crossFadeBackground = function( path )
    local musicPath = path or retrieveVariable("musicPath")
    
    -- if the song is the same as what's already playing, don't restart it
    if currentSong == musicPath and audio.getVolume{channel=audioChannel} > 0.1 then return false end
    -- fades the current background audio channel and stops
    audio.fadeOut({channel=audioChannel, time=500})
    -- switches to the free background audio channel
    if audioChannel==1 then audioChannel,otherAudioChannel=2,1 else audioChannel,otherAudioChannel=1,2 end
    audio.setVolume( retrieveVariable("volume"), {audioChannel})
    -- loads the stream
    curAudio = audio.loadStream( musicPath )
    -- fades in the new music on the new channel
    audio.play(curAudio, {channel=audioChannel, loops=-1, fadein=500})
    prevAudio = curAudio
    currentSong = musicPath
    audio.currentBackgroundChannel = audioChannel
end
audio.reserveChannels(2)
audio.currentBackgroundChannel = 1
audio.crossFadeBackground = crossFadeBackground

            --########## Easy SFX ##########--
local newSFX = function( snd )
    if retrieveVariable("sfx") == "true" then
        if type(snd) == "string" then
            return audio.play(audio.loadSound( snd ))
        else
            return audio.play(snd)
        end
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

--==================== End CoronaSDK Hijacks ====================--

--==================== Begin CrawlSpace Nicities  ====================--

local registeredVariables = {}
registerVariable = function(...)
    local var, var2 = ...
    var = var2 or var

    registeredVariables[var[1]] = var[2]
end
registerVariable{"volume", 1}

registerBulk = function(...)
    local var, var2 = ...
    var = var2 or var

    for i,v in ipairs(var[1]) do
        registerVariable{var[1][i], var[2]}
    end
end

retrieveVariable = function(...)
    local name, name2 = ...
    name = name2 or name

    return registeredVariables[name]
end
_G.getVar = retrieveVariable

adjustVariable = function(...)
    local new, new2 = ...
    new = new2 or new

    if type(new[2]) == "string" then
        registeredVariables[new[1]] = new[2]
    elseif type(new[2]) == "number" then
        registeredVariables[new[1]] = registeredVariables[new[1]] + new[2]
        if new[3] then
            registeredVariables[new[1]] = new[2]
        end
    end
end


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

local cachedPrint = print
local extendedPrint = function( ... )
    local a = ...
    if system.getInfo("environment") == "simulator" or DEBUG == true then
        if  a == nil then
            cachedPrint("\nCrawlspace :: A Nil value")
        elseif type(a) == "string" then
            cachedPrint("\nCrawlspace :: String", a)
        elseif type(a) == "number" then
            cachedPrint("\nCrawlspace :: Number", a )
        elseif type(a) == "table" then
            cachedPrint("\nCrawlspace :: Key/Values")
            for k,v in pairs(a) do
                cachedPrint("Key: "..k, "Value: ", v)
            end
        else
            cachedPrint("Crawlspace cachedPrint :: "..type(a), a)
        end
    end
end
_G.print = extendedPrint

local welcome = function()
    local print = cachedPrint
    print("\n\n")
    print("CrawlSpaceLib v1.0\n")
    print("Welcome to the CrawlSpace Library!\n\n\tA lot of work has gone into making this very powerful while also keeping it very, very easy to use.")
    print("\n\n")
end

local showTip = function()
    print("A tasty treat goes here!")
end

if intro then welcome() elseif startupTips then showtip() end
