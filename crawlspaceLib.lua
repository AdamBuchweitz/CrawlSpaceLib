
        --[[ ########## Crawl Space Library ########## ]--

    Version 1.1.3

    Written and supported by Adam Buchweitz and Crawl Space Games

    http://crawlspacegames.com
    http://twitter.com/crawlspacegames


    For inquiries about Crawl Space, email us at
        heyyou@crawlspacegames.com

    For support with this library, email me at
        adam@crawlspacegames.com


    Copyright (C) 2011 Crawl Space Games - All Rights Reserved
    Library is MIT licensed. More info at: http://crawlspacegames.com/license

    All functionality is documented below. For syntax help use .help()

    For a list of included features, use the .listFeatures() method.


    Note:
        If you use the standard director class by Ricardo Rauber
        and use timer.cancelAll() you will cancel timers from the
        director! Either modify your version of the director class,
        or use the one included with this library.

    Thanks to Kenn Wagenheim, Jay Jennings, Bruce Martin for all your
    input, contributions, and testing. You guys are great!

]]--

-- Set this to false to bypass the welcome message
local showIntro = false

-- Set this to false to bypass the random Lua/CoronaSDK tips
local startupTips = false

-- Enable debug print messages, as well as on-device prints
local debug = true



-- CSL is the actual object returned
local CSL = {}

-- The cache of native and Corona APIs
cache = {}

            --[[ ########## Getting Help ########## ]--

Start with:

    local CSL = require "crawlspaceLib"
    CSL.help()

]]
local helpArr = {}
CSL.help = function(item)
    if not item then
        cache.print("\n\nUse this help feature for syntax additions in Crawl Space functions.")
        cache.print('\n\nUSAGE EXAMPLE:\n\n\tcrawlspaceLib.help("newText")')
    else
        cache.print('\n\nCrawlSpace Help: '..item..'\n')
        if helpArr[item] then cache.print('\t'..helpArr[item]) else
            cache.print('Sorry, I cannot find that item. Available items are:')
            for k,v in pairs(helpArr) do cache.print('\n -- '..k) end
        end
    end
end

            --[[ ########## Global Screen Dimensions ########## ]--

Use these global variables to position your elements. They are dynamic
to all resolutions. Android devices are usually taller, so use screenTop to
set the position where you expect 0 to be. The iPad is wider than iPhones,
so use screenLeft. Also the width and height need to factor these differences
in as well, so use screenWidth and screenHeight. Lastly, centerX and centerY
are simply global remaps of display.contentCenterX and Y.

:: USAGE ::

    myObject.x, myObject.y = screenX + 10, screenY + 10 -- Position 10 pixels from the top left corner on all devices

    display.newText("centered text", centerX, centerY, 36) -- Center the text

    display.newRect(screenX, screenY, screenWidth, screenHeight) -- Cover the screen, no matter what size

]]
              centerX = display.contentCenterX
              centerY = display.contentCenterY
              screenX = display.screenOriginX
              screenY = display.screenOriginY
          screenWidth = display.contentWidth - screenX * 2
         screenHeight = display.contentHeight - screenY * 2
           screenLeft = screenX
          screenRight = screenX + screenWidth
            screenTop = screenY
         screenBottom = screenY + screenHeight
 display.contentWidth = screenWidth
display.contentHeight = screenHeight

            --[[ ########## Global Content Scale and Suffix  ########## ]--

Checks the content scaling and sets a global var "scale". In addition,
if you use sprite sheets and was retina support, append the global "suffix"
variable when calling your datasheet, and it will pull the hi-res version
when it's needed. On the topic of devices and scals, when in the simulator,
the global variable "simulator" is set to true.

]]

scale, suffix = display.contentScaleX, ""
if scale < 1 then if scale > .5 then suffix = "@1.5x" else suffix = "@2x" end end
--magicWidth, magicHeight = 760*scale, 1140*scale
magicWidth, magicHeight = 380, 570

if system.getInfo("environment") == "simulator" then simulator = true end

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

helpArr.Save = 'Save(table [, filename])'
helpArr.save = 'Did you mean "Save" ?'
local tonum = tonumber
local split = function(str, pat)
    local t = {}
    local fpat = "(.-)" .. (pat or " ")
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
string.split = split

Save = function(table, fileName)
    local filePath = system.pathForFile( fileName or "data.txt", system.DocumentsDirectory )
    local file = io.open( filePath, "w" )

    for k,v in pairs( table or Data ) do
        if type(v) == "table" then
            for k2,v2 in pairs( v ) do
                file:write( k .. ":" .. k2 .. "=" .. tostring(v2) .. "," )
            end
        else
            file:write( k .. "=" .. tostring(v) .. "," )
        end
    end

    io.close( file )
end

helpArr.Load = 'local mySavedData = Load([filename])'
helpArr.load = 'Did you mean "Load"?'
Load = function(fileName)
    local filePath = system.pathForFile( fileName or "data.txt", system.DocumentsDirectory )
    local file = io.open( filePath, "r" )

    if file then
        local dataStr = file:read( "*a" )
        local datavars = split(dataStr, ",")
        local dataTableNew = {}

        for k,v in pairs(datavars) do
            if string.find(tostring(v),":") then
                local table = split(v, ":")
                local pair = split(table[2], "=")
                if pair[2] == "true" then pair[2] = true
                elseif pair[2] == "false" then pair[2] = false
                elseif tonum(pair[2]) then pair[2] = tonum(pair[2]) end
                if not dataTableNew[tonum(table[1]) or table[1]] then dataTableNew[tonum(table[1]) or table[1]] = {} end
                dataTableNew[tonum(table[1]) or table[1]][pair[1]] = pair[2]
            else
                local pair = split(v, "=")
                if pair[2] == "true" then pair[2] = true
                elseif pair[2] == "false" then pair[2] = false
                elseif tonum(pair[2]) then pair[2] = tonum(pair[2]) end
                dataTableNew[pair[1]] = pair[2]
            end
        end

        io.close( file ) -- important!
        if not fileName then
            for k,v in pairs(dataTableNew) do Data[k] = v; setVar{k,v,true} end
        end
        return dataTableNew
    else
        print("No data to load yet.")
        return false
    end
end

Defaults = function(d)
    for k,v in pairs(d) do
        Data[k] = v
        setVar{k,v,true}
    end
end
Data = {}

            --[[ ########## Reference Point Shorthand ########## ]--

All this block does it set shorthand notations for all reference points.
The main purpose of this is for passing short values into display objects.

:: EXAMPLE 1 ::

    myObject:setReferencePoint(display.tl)

]]

helpArr.referencePoint = 'myDisplayObject:setReferencePoint(display.tl)'
helpArr.referencePoints = '"tl", "tc", "tb", "cl", "c", "cr", "bl", "bc", "br"\n\n\tAlso added to the display package: display.tl'
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

helpArr.setFillColor = 'myRect:setFillColor( hex )\n\n\tor\n\n\tmyRect:setFillColor( red, green, blue [, alpha] )'
local hexTable = {f=15,e=14,d=13,c=12,b=11,a=10}
local crawlspaceFillColor = function(self,r,g,b,a)
    local r,g,b,a = r,g,b,a
    if type(r) == "string" then
        r = string.lower(string.gsub(r,"#",""))
        local hex = {}; string.gsub(r,".",function(v) hex[#hex+1] = v end)
        for i=1, #hex do if not tonum(hex[i]) then hex[i]=hexTable[hex[i]] end end
        r,g,b,a = hex[1]*hex[2],hex[3]*hex[4],hex[5]*hex[6],( hex[7] or 16 )*( hex[8] or 16 ) - 1
    end
    self:cachedFillColor(r,g,b,a or 255)
end

local injectedDisplayMethods = {}
injectDisplayMethod = function(name, method)
    if type(method) ~= "function" then
        error("Please pass a method to inject")
    else
        injectedDisplayMethods[#injectedDisplayMethods+1] = {name, method}
    end
end

local tranc = transition.cancel
local displayMethods = function( obj )
    local d = obj
    d.setPos = function(self,x,y) d.x, d.y = screenX+x, screenY+y end
    d.center = function(self,axis) if axis == "x" then d.x=centerX elseif axis == "y" then d.y=centerY else d.x,d.y=centerX,centerY end end
    d.fader={}
    d.fadeIn = function( self, num, callback ) tranc(d.fader); d.alpha=0; d.fader=transition.to(d, {alpha=1, time=num or d.fadeTime or 500, onComplete=callback}) end
    d.fadeOut = function( self, time, callback, autoRemove) d.callback = callback; if type(callback) == "boolean" then d.callback = function() display.remove(d) end elseif autoRemove then d.callback = function() callback(); display.remove(d); d=nil end end tranc(d.fader); d.fader=transition.to(d, {alpha=0, time=time or d.fadeTime or 500, onComplete=d.callback}) end
    d.setStageFocus = function() display.getCurrentStage():setFocus(d) end
    d.removeStageFocus = function() display.getCurrentStage():setFocus(nil) end
    if d.setFillColor then d.cachedFillColor = d.setFillColor; d.setFillColor = crawlspaceFillColor end
    if #injectedDisplayMethods > 0 then
        for i,v in ipairs(injectedDisplayMethods) do
            if d[v[1]] then d["cached"..v[1]] = d[v[1]] end
            d[v[1]] = v[2]
        end
    end
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

helpArr.insert = 'myGroup:insert([index,] object1 [, object2, object3, resetTransform])'
local crawlspaceInsert = function(...)
    local t = {...}
    local b, reset = 0, nil
    if type(t[#t]) == "boolean" then b = 1; reset = t[#t] end
    if type(t[2]) == "number" then for i=3, #t-b do t[1]:cachedInsert(t[2],t[i],reset); if reset and t[i].text then t[i].xScale, t[i].yScale=.5,.5 end end
    else for i=2, #t-b do t[1]:cachedInsert(t[i],reset); if reset and t[i].text then t[i].xScale, t[i].yScale=.5,.5 end end
    end
end
cache.newGroup = display.newGroup
display.newGroup = function(...)
    local g = cache.newGroup(...)
    g.cachedInsert = g.insert
    g.insert = crawlspaceInsert
    displayMethods( g )
    return g
end

            --[[ ########## NewCircle Override  ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newRect(centerX, centerY, 20 [, "tl"])

]]

cache.newCircle = display.newCircle
display.newCircle = function( x, y, r, rp )
    local c = cache.newCircle( 0, 0, r )
    if referencePoints( c, rp ) then displayMethods( c ) end
    c.x, c.y = x, y
    return c
end

            --[[ ########## NewRect Override  ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newRect(0, 0, 100, 50 [, "tl"])

]]

helpArr.newRect = 'display.newRect(x-position, y-position, width, height [,referencePoint])'
cache.newRect = display.newRect
display.newRect = function( x, y, w, h, rp )
    local r = cache.newRect( x, y, w, h )
    if referencePoints( r, rp or "tl" ) then displayMethods( r ) end
    r.x, r.y = x, y
    return r
end

            --[[ ########## NewRoundedRect Override  ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newRoundedRect( 0, 0, 100, 50, 10 [, "tl"])

]]

helpArr.newRoundedRect = 'display.newRoundedRect(x-position, y-position, width, height, radius [, referencePoint])'
cache.newRoundedRect = display.newRoundedRect
display.newRoundedRect = function( x, y, w, h, r, rp )
    local r = cache.newRoundedRect( 0, 0, w, h, r ); r.x,r.y=x,y
    if referencePoints( r, rp ) then displayMethods( r ) end
    r.x, r.y = x, y
    return r
end

            --[[ ########## NewImage Override  ########## ]--

The enhancement to newImage is that if you omit the x and y,
they will be set to the dynamic rasolution values for 0, 0.

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newImage("myImage.png" [, 100, 50, "tl"])

]]

helpArr.newImage = 'display.newImage(filename [, x-position, y-position, referencePoint])\n\n\tNote that x and y positions are defaulted to the dynamic resolution value of the top left corner of the screen.'
cache.newImage = display.newImage
display.newImage = function( path, x, y, rp )
    local i = cache.newImage( path, x or screenX, y or screenY )
    if referencePoints( i, rp ) then displayMethods( i ) end
    return i
end

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

helpArr.newImageRect = 'display.newImage(filename [, width, height, referencePoint])\n\n\tNote that width and height values are defaulted to 380 and 570 respectively. These values corrospond to the "magic formula" commonly used to dynamic resolutions.'
helpArr.newImage = 'display.newImage(filename [, x-position, y-position, referencePoint])'
cache.newImageRect = display.newImageRect
display.newImageRect = function( path, baseDir, w, h, rp )
    local baseDir, w, h, rp, i = baseDir, w, h, rp
    if type(baseDir) == "userdata" then
        i = cache.newImageRect( path, baseDir, w or 380, h or 570 )
    else
        w, h, rp = baseDir, w, h
        i = cache.newImageRect( path, w or 380, h or 570 )
    end
    if referencePoints( i, rp ) then displayMethods( i ) end
    return i
end

            --[[ ########## Sprite Override ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    sprite.newSprite( mySpriteSet [, "tl"])

]]
local sprite = require "sprite"
cache.newSprite = sprite.newSprite
sprite.newSprite = function( spriteSet, rp )
    local s = cache.newSprite( spriteSet )
    if referencePoints( s, rp ) then displayMethods( s ) end
    return s
end

            --[[ ########## Auto Retina Text ########## ]--

This feature doesn't require much explanation. It overrides the default
CoronaSDK display.newText and replaces it with auto retina text,
which is simply doubling the text size and scaling it down.
The only extra step is setting the position AFTER text is scaled,
which solves a positioning problem after scaling.

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE ::

    display.newText("My New Text", 100, 100, native.systemFont, 36 [, "cr" ] )

]]

helpArr.setTextColor = 'myText:setTextColor( hex )\n\n\tor\n\n\tmyText:setTextColor( red, green, blue )'
local crawlspaceTextColor = function(self,r,g,b)
    local r,g,b = r,g,b
    if type(r) == "string" then
        r = string.lower(string.gsub(r,"#",""))
        local hex = {}; string.gsub(r,".",function(a) hex[#hex+1] = a end)
        for i=1, #hex do if not tonum(hex[i]) then hex[i]=hexTable[hex[i]] end end
        r,g,b = hex[1]*hex[2],hex[3]*hex[4],hex[5]*hex[6]
    end
    self:cachedTextColor(r,g,b)
end

helpArr.newText = 'display.newText(string, x-position, y-position, font, size [, referencePoint ] )'
cache.newText = display.newText
display.newText = function( text, xPos, yPos, font, size, rp )
    local t = cache.newText(text, 0, 0, font, size * 2)
    referencePoints( t, rp ); displayMethods(t)
    t.xScale, t.yScale, t.x, t.y = .5, .5, xPos, yPos
    t.cachedTextColor = t.setTextColor
    t.setTextColor = crawlspaceTextColor
    return t
end

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
transition it, insert it into another group, etc. Additionally,
All paragraph text is accessible, though not edditable, with
myParagraph.text

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

helpArr.newParagraph = 'display.newParagraph( string, charactersWide, { [font=font, size=size, lineHeight=lineHeight, align=align] })\n\n\tor\n\n\tdisplay.newParagraph( string, charactersWide, size )'
local textAlignments = {left="cl",right="cr",center="c",centered="c",middle="c"}
display.newParagraph = function( string, width, params )
    local format; if type(params) == "number" then format={size = params} else format=params end
    local splitString, lineCache, tempString = split(string, " "), {}, ""
    for i=1, #splitString do
        if splitString[i] == "\n" then lineCache[#lineCache+1]=tempString; tempString=splitString[i]
        elseif #tempString + #splitString[i] > width then lineCache[#lineCache+1]=tempString; tempString=splitString[i].." "
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

helpArr.timer = 'timer.performWithDelay( delay, function [, repeats, omitFromCancelAll])'
local timerArray = {}
cache.performWithDelay = timer.performWithDelay
timer.performWithDelay = function( time, callback, repeats, add )
    local repeats, add = repeats, add
    if type(repeats) == "boolean" then add = repeats; repeats = nil end
    local t = cache.performWithDelay(time, callback, repeats)
    t._begin = system.getTimer()
    t._delay = t._delay or time
    t.cancel = function()
        timer.cancel(t)
        local v = table.search(timerArray, t)
        if v then table.remove(timerArray, v) end
        t, v = nil, nil
    end
    t.pause = function()
        t._remaining = (t._count or 1 * t._delay) - (system.getTimer() - t._begin)
        timer.cancel(t)
        t.paused = true
    end
    t.resume = function()
        if t.paused then
            if repeats then
            else
                t = cache.performWithDelay(t._remaining, callback, add)
            end
            t.paused = nil
            t._remaining = nil
        end
    end
    if add ~= false then
        timerArray[#timerArray+1] = t
    end
    return t
end

helpArr.cancelAll = 'timer.cancelAll()'
timer.cancelAll = function()
    while #timerArray > 0 do
        timer.cancel(table.remove(timerArray,1))
    end
end

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

cache.timerCancel = timer.cancel
timer.cancel = function(t) if t then cache.timerCancel(t) end end

            --[[ ########## Transitions ########## ]--

            to, from, cancel
            multiple, safe, pause, resume, cancel
            reverse, loop, bounce



]]
            --[[ ########## Multiple Transition ########## ]--

]]
cache.transitionFrom = transition.from
transition.from = function(tweens, params)
    if tweens then
        if #tweens > 0 then
            for i,v in ipairs(tweens) do
                if params.targetSelf then params.onComplete = v end
                cache.transitionFrom(v, params)
            end
        else
            return cache.transitionFrom(tweens, params)
        end
    end
end

cache.transitionTo = transition.to
transition.to = function(tweens, params)
    if tweens then
        if #tweens > 0 then
            for i,v in ipairs(tweens) do
                if params.targetSelf then params.onComplete = v end
                cache.transitionTo(v, params)
            end
        else
            return cache.transitionTo(tweens, params)
        end
    end
end

cache.transitionCancel = transition.cancel
transition.cancel = function( tweens)
    if tweens then
        if #tweens > 0 then
            for i,v in ipairs(tweens) do
                cache.transitionCancel(v)
            end
        else
            cache.transitionCancel(tweens)
        end
    end
end

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

local audio  = require "audio"
local audioChannel, otherAudioChannel, currentSong, curAudio, prevAudio = 1
audio.crossFadeBackground = function( path )
    if CSL.retrieveVariable("music") then
        local musicPath = path or CSL.retrieveVariable("musicPath")
        if currentSong == musicPath and audio.getVolume{channel=audioChannel} > 0.1 then return false end
        audio.fadeOut({channel=audioChannel, time=500})
        if audioChannel==1 then audioChannel,otherAudioChannel=2,1 else audioChannel,otherAudioChannel=1,2 end
        audio.setVolume( CSL.retrieveVariable("volume"), {channel=audioChannel})
        curAudio = audio.loadStream( musicPath )
        audio.play(curAudio, {channel=audioChannel, loops=-1, fadein=500})
        prevAudio = curAudio
        currentSong = musicPath
        audio.currentBackgroundChannel = audioChannel
    end
end
audio.reserveChannels(2)
audio.currentBackgroundChannel = 1

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

audio.playSFX = function( snd, params )
    local channel
    if CSL.retrieveVariable("sfx") == true then
        local play = function()
            if params and params.delay then params.delay=nil end
            if type(snd) == "string" then channel=audio.play(audio.loadSound(snd), params)
            else channel=audio.play(snd, params) end
        end
        if params and params.delay then
            timer.performWithDelay(params.delay, play, false)
        else
            play()
        end
    end
    return channel
end

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


            --[[ ########## Print Available Fonts  ########## ]--

Call printFonts() to see a printed list of all installed fonts.
This comes in really handy when you want to use a custom font,
as you need to register the actual name of the font, and not the
name of the file.


:: EXAMPLE ::

    printFonts()

]]

printFonts = function()
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

initFont = function( fontName, globalName ) _G[globalName] = fontName end


            --[[ ########## Cross Platform Filename ########## ]--


]]

crossPlatformFilename = function( filename, iosSuffix, androidSuffix )
    if not iosSuffix and not androidSuffix then
        error("You must supply a suffix for both iOS and Android", 2)
    elseif not iosSuffix then
        error("You must supply a suffix for iOS", 2)
    elseif not androidSuffix then
        error("You must supply a suffix for Android", 2)
    end
    if platform.mac or platform.android then
        _G[filename] = filename..androidSuffix
    else
        _G[filename] = filename..iosSuffix
    end
end

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

    local myFunction = function(
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

helpArr.executeIfInternet = 'executeIfInternet(myInternetMethod, myNonInternetMethod)'
local toExecute = {}
local checkForInternet
local executeOnNet = function()
    for i=1, #toExecute do local f = table.remove(toExecute); f(); f=nil end
end
-- Sets global variable "internet"
local internetListener = function( event )
    if event.isError then _G.internet = false; timer.performWithDelay(30000, checkForInternet, false)
    else _G.internet = true; executeOnNet() end
    return true
end

checkForInternet = function()
    network.request("http://google.com/", "GET", internetListener)
end
checkForInternet()

executeIfInternet = function(f)
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

This set of functions is left accessible via crawlspaceLib.registerVariable
because if you find yourself using them often you will want them localized.

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

CSL.registeredVariables = {}
CSL.registerVariable = function(...)
    local var, var2 = ...; var = var2 or var
    if var[2] == "true" then var[2] = true elseif var[2] == "false" then var[2] = false end
    CSL.registeredVariables[var[1]] = var[2]
end
registerVar = CSL.registerVariable

CSL.registerBulk = function(...)
    local var, var2 = ...; var = var2 or var
    for i,v in ipairs(var[1]) do CSL.registerVariable{var[1][i], var[2]} end
end
registerBulk = CSL.registerBulk

CSL.retrieveVariable = function(...)
    local name, name2 = ...; name = name2 or name
    local var = CSL.registeredVariables[name]
    if tonum(var) then var = tonum(var) end
    return var
end
getVar = CSL.retrieveVariable

CSL.setVariable = function(...)
    local new, new2 = ...; new = new2 or new
    if type(new[2]) == "number" then
        if not CSL.registeredVariables[new[1]] then
            CSL.registeredVariables[new[1]] = new[2]
        else
            CSL.registeredVariables[new[1]] = CSL.registeredVariables[new[1]] + new[2]
            if new[3] then CSL.registeredVariables[new[1]] = new[2] end
            if Data[new[1]] then Data[new[1]] = CSL.registeredVariables[new[1]] end
        end
    else
        if new[2] == "true" then new[2] = true elseif new[2] == "false" then new[2] = false end
        CSL.registeredVariables[new[1]] = new[2]
        if Data[new[1]] ~= nil then Data[new[1]] = CSL.registeredVariables[new[1]] end
    end
end
setVar = CSL.setVariable

CSL.setVariable{"volume", 1}
CSL.setVariable{"sfx", true}
CSL.setVariable{"music", true}

            --[[ ########## Extended Table Functions ########## ]--

]]

table.shuffle = function( a )
    local r, c = math.random, #a
    for i=1, (c * 20) do
        local x, y = r(1,c), r(1,c)
        a[x], a[y] = a[y], a[x]
    end
    return a
end

table.search = function( table, v )
    for k,value in pairs(table) do
        if v == value then return k end
    end
end


            --[[ ########## Extended Print ########## ]--

It's pointless to print out a table - instead you want the key/value
pairing of the table. This extended print does just that, as well as
ading a blank line between prints for easier reading. Lastly, this will
only print on the simulator. You shouldn't leave your prints in your final
app anyway, but if you do this should help improve performance.

]]

local printObj, printYpos
cache.print = print
print = function( ... )
    local a = ...
    if simulator then
        if type(a) == "table" then
            cache.print("\nOutput Table Data:\n")
            for k,v in pairs(a) do cache.print("\tKey: "..tostring(k), "Value: ", tostring(v)) end
        elseif #{...} > 1 then cache.print("\nOutput mutiple: ", ...)
        elseif a == "fonts" then printFonts()
        else cache.print("\nOutput "..type(a).." :: ", a or "") end
    else
        if CSL.printWindow then
            if #{...} > 1 then
                for k,v in pairs(a) do
                    printYpos = printYpos + 12
                    printObj = display.newText(tostring(v), 0, printYpos, native.systemFont, 10, "tl")
                    printObj:setTextColor(255, 255, 255)
                    CSL.printWindow:insert(printObj)
                    CSL.printWindow.y = CSL.printWindow.y - 12
                end
            else
                printYpos = printYpos + 12
                printObj = display.newText(tostring(a), 0, printYpos, native.systemFont, 10, "tl")
                printObj:setTextColor(255, 255, 255)
                CSL.printWindow:insert(printObj)
                CSL.printWindow.y = CSL.printWindow.y - 12
            end
        end
    end
end

            --[[ ########## List Feature ########## ]--

List all features for quick reference

]]

CSL.listFeatures = function()
    local print = cache.print
    print("\nFeature List:\n")
    print("\n+ Global variables for dynamic resolution")
    print("\n+ Super simple saving and loading")
    print("\n+ Shortened reference points, passible as arguments to all display objects")
    print("\n+ Insert multiple objects into a group")
    print("\n+ Automatic retina-ready text")
    print("\n+ Paragraphs")
    print("\n+ Exposed API: timer.cancelAll()")
    print("\n+ Safe timer.cancel()")
    print("\n+ Crossfade background audio")
    print("\n+ Play SFX based on registered true/false variable")
    print("\n+ Simulator-friendly webPopups")
    print("\n+ Print installed font names with printFonts()")
    print("\n+ Initialize and globalize a font with one line")
    print("\n+ Execute a function if internet is detected, execute another if not connected")
    print("\n+ Global information handling")
    print("\n+ Extended print statement")
end

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
    cache.print("\n\nTip:\n\n\t"..tipArray[math.random(1,#tipArray)])
end

            --[[ ########## Welcome! ########## ]]--

local welcome = function()
    local print = cache.print
    print("\n\n\nYou can disable this welcome message by setting the 'showIntro' variable to\nfalse in crawlspacelib.lua")
    print("\n\n")
    print("CrawlSpaceLib v1.1.3\n")
    print("Welcome to the CrawlSpace Library!\n\n\t    A lot of work has gone into making this very powerful while also\n\tkeeping it very, very easy to use. With that being said, we will happily\n\taccept your donation! Try the library out, see if it saves you any time,\n\teffort, or headaches, and even if you don't decide to donate, I'd still\n\tlove to hear about your experience.")
    print("\n\t    Take a peek at crawlspacelib.lua for detailed instructions on\n\thow to use the library, or just take advantage of its features passivly,\n\tas many are simple enhancements to existing CoronaSDK functionality.\n\tAlternatively, you may run the crawlspacelib.listFeatures() method to\n\tget a quick list of everything included.")
    print("\n\n\tDonate: http://www.crawlspacegames.com/crawl-space-corona-sdk-library/\n\n\tEmail me: adam@crawlspacegames.com")

    local device=""; if scale==.5 then device="@2x" elseif scale<.5 then device="@iPad" end
    local lsntr = function ( event ) if not event.isError then local t=event.target; t.xScale,t.yScale=scale,scale; t.x,t.y=centerX,centerY; t:fadeIn(); t.timer=function()t:fadeOut(500,true)end; timer.performWithDelay(2000, t) end end
    display.loadRemoteImage( "http://crawlspacegames.com/images/splash"..device..".png", "GET", lsntr, "splash"..device..".png", system.TemporaryDirectory )
end

if showIntro then welcome() elseif startupTips then showTip() end



            --[[ ############################################### ]]--
            --[[ ####################       #################### ]]--
            --[[ #################### BETA! #################### ]]--
            --[[ ####################       #################### ]]--
            --[[ ############################################### ]]--


            --[[ ########## Enable ########## ]]--
cache.require = require

            --[[ ########## Open Feint Expansion ########## ]]--
local achievements, leaderboards, gameNetwork
local enableOF = function( params )
    gameNetwork = cache.require("gameNetwork")
    if not params then print("Please provide me with Open Feint info"); return false else
        if not params.productKey    then print("Missing Open Feint product key") end
        if not params.productSecret then print("Missing Open Feint product secret") end
        if not params.displayName   then print("Missing Open Feint display name") end
        if not params.appId         then print("Missing Open Feint app ID") end
    end
    openfeint = {}
    openfeint.launchDashboard = gameNetwork.show
    gameNetwork.init("openfeint",params.productKey,params.productSecret,params.displayName,params.appId)
    if system.pathForFile("feint.lua", system.ResourceDirectory) then local feint = require("feint"); achievements, leaderboards = feint.achievements, feint.leaderboards; openfeint.leaderboards, openfeint.achievements = leaderboards, achievements end
    --local feint = cache.require("feint") -- external library
    --achievements, leaderboards = feint.achievements, feint.leaderboards

end

Achieve = function( achievement )
    --if not package.loaded["gameNetwork"] then print("Please Enable gameNetwork before attempting to unlock and achievement."); return false end
    if tonum(achievement) then
        if #tostring(achievement) ~= 6 then print("Invalid achievement number")
        else gameNetwork.request("unlockAchievement",tostring(achievement)) end
    else
        if achievements then
            if achievements[achievement] then gameNetwork.request("unlockAchievement",tostring(achievements[achievement]))
            else print("Cannot find that achievement") end
        else
            if _G.achievements and _G.achievements[achievement] then gameNetwork.request("unlockAchievement",tostring(_G.achievements[achievement]))
            else print("Cannot find that achievement") end
        end
    end
end

HighScore = function( board, score, display )
    --if not package.loaded["gameNetwork"] then print("Please Enable gameNetwork before attempting to submit a High Score."); return false end
    local board = board
    if tonum(board) then
        if #tostring(board) ~= 6 then print("Invalid leaderboard number"); return false end
    else
        if leaderboards then
            if leaderboards[board] then board = leaderboards[board]
            else print("Cannot find that leaderboard"); return false end
        else
            if _G.leaderboards and _G.leaderboards[board] then board = _G.leaderboards[board]
            else print("Cannot find that leaderboard"); return false end
        end
    end
    gameNetwork.request("setHighScore", { leaderboardID=tostring(board), score=tonum(score), displayText=tostring(display)})
end

            --[[ ########## Flurry Expansion ########## ]]--
local enableFlurry = function( id )
    if not id then print("Please supply a valid app ID")
    else analytics.init(id) end
end

Log = function( event )
    if not package.loaded["analytics"] then print("Please Enable Analytics before attempting to log an event."); return false end
    analytics.logEvent( event )
end


            --[[ ########## Random help ########## ]]--
-- Generate randomseed and pull the first three numbers out
math.randomseed(system.getTimer())
math.random(); math.random(); math.random()

            --[[ ########## Set up the platform table ########## ]]--
platform = {}
local name = string.lower(system.getInfo("platformName"))
if name     == "android"   then platform.android = true
elseif name == "iphone os" then platform.ios     = true
elseif name == "win"       then platform.win     = true
elseif name == "mac os x"  then platform.mac     = true end
platform.name = name



local debugUI

local prevTime = 0;
local maxSavedFps = 30;
local function minElement(table)
    local min = 10000;
    for i = 1, #table do if(table[i] < min) then min = table[i]; end end
    return min;
end

local fpsDialog
local showFPS = function()
    local makeFpsDialog = function()
        local fps = display.newGroup()

        fps.background = display.newRect(screenX, screenY, screenWidth, 50)
        fps.background:setFillColor(0,0,0)

        fps.memory = display.newText("0/10", centerX, screenY, "helvetica", 13, "tc")
        fps.memory:setTextColor(255,255,255)

        fps.framerate = display.newText("0", centerX, fps.memory.contentHeight+5, "Helvetica", 16, "tc")
        fps.framerate:setTextColor(255,255,255)

        fps:insert(fps.background, fps.memory, fps.framerate)
        fps.alpha = .5

        transition.from(fps, {time=200, y=screenY-50})

        return fps;
    end

    local lastFps = {}
    local lastFpsCounter = 1
    local floor, ceil = math.floor, math.ceil
    local updateFPS = function( event )
        local curTime = system.getTimer();
        local dt = curTime - prevTime;
        prevTime = curTime;

        local fps = floor(1000/dt);

        lastFps[lastFpsCounter] = fps;
        lastFpsCounter = lastFpsCounter + 1;
        if(lastFpsCounter > maxSavedFps) then lastFpsCounter = 1; end
        local minLastFps = minElement(lastFps);

        fpsDialog.framerate.text = "FPS: "..fps.." (min: "..minLastFps..")";

        local mem = ceil(system.getInfo("textureMemoryUsed")*.0001)*.01
        fpsDialog.memory.text = "Mem: "..mem.." mb";
    end

    if fpsDialog then
        if fpsDialog.y == screenY then transition.to(fpsDialog, {time=200, y=screenY-50})
        else transition.to(fpsDialog, {time=200, y=screenY}) end
    else
        fpsDialog = makeFpsDialog()
        Runtime:addEventListener("enterFrame", updateFPS)
    end
end

local debugVars = {}
DebugVar = function( var, range, value, title )
    CSL.registerVariable{ var, value }
    local v = {}
    v.ref = var
    v.value = value
    v.min = range[1]
    v.max = range[2]
    v.unit = (v.max - v.min) * 0.01
    v.title = title
    v.callback = function( event )
        CSL.setVariable{ v.ref, event.value * v.unit, true}
    end
    debugVars[#debugVars+1] = v
end

local coronaui
local varAdjusterUI
local showVars = function()
    local makeVarAdjusterUI = function()
        local g = display.newGroup()
        g.hit = display.newRect( centerX, centerY, screenWidth, screenHeight, "c" )
        g.hit.alpha = 0.25
        g.hit.remove = true

        local bg = display.newRoundedRect( centerX, centerY, screenWidth*0.8, 10+#debugVars*60, 20, "c" )
        bg:setFillColor(0,0,0,200)
        bg:addEventListener("touch", g)

        local bgOutline = display.newRoundedRect( centerX, centerY, screenWidth*0.8+4, 14+#debugVars*60, 20, "c" )
        bgOutline.strokeWidth = 1
        bgOutline:setFillColor(0,0,0,0)
        bgOutline:setStrokeColor(200,200,200,200)

        g:insert(g.hit, bg, bgOutline)

        local yPos = centerY - bgOutline.contentHeight * 0.5
        for i, v in ipairs(debugVars) do
            local txt = display.newText(v.title or v.ref, 0, yPos-30+55*i, native.systemFont, 14, "cl")
            local sld = coronaui.newSliderControl( centerX, txt.y+23, v.value/v.unit, v.callback)
            sld.name = "slider"
            txt.x = centerX - sld.contentWidth*0.25+ 10
            g:insert(txt, sld)
        end

        g:fadeIn()

        g.touch = function( self, event )
            if event.target.remove then
                varAdjusterUI:fadeOut(250)
            end
            return true
        end

        return g
    end

    if varAdjusterUI then
        if varAdjusterUI.alpha > 0.5 then
            varAdjusterUI:fadeOut(250)
            varAdjusterUI.hit:removeEventListener("touch", varAdjusterUI)
        else
            varAdjusterUI:fadeIn(250)
            varAdjusterUI.hit:addEventListener("touch", varAdjusterUI)
        end
    else
        coronaui = require("coronaui")
        varAdjusterUI = makeVarAdjusterUI()
        varAdjusterUI.hit:addEventListener("touch", varAdjusterUI)
    end
end

local showPrints = function()
    if CSL.printWindow then
        if CSL.printWindow.isVisible then CSL.printWindow.isVisible = false
        else CSL.printWindow.isVisible = true end
    else
        printYpos = screenY + 20
        printWindow = display.newGroup()
        printWindow.x, printWindow.y = screenX + 10, printYpos
        printWindow:setReferencePoint(display.bl)
        printWindow:addEventListener("touch", printWindow)
        printWindow.delta = printYpos
        printWindow.touch = function( self, event )
            if event.phase == "began" then
                display.getCurrentStage():setFocus( self )
            elseif event.phase == "moved" then
                printWindow.y = printWindow.delta + event.y-event.yStart
            elseif event.phase == "ended" then
                printWindow.delta = printWindow.y
                if printWindow.y + printWindow.contentHeight < screenY+20 then
                    transition.to(printWindow, {y=screenY+20-printWindow.contentHeight, time=100, transitioning=easing.inOutQuad})
                    printWindow.delta = screenY+20-printWindow.contentHeight
                elseif printWindow.y > screenY+screenHeight-100 then
                    transition.to(printWindow, {y=screenY+screenHeight-100, time=100, transitioning=easing.inOutQuad})
                    printWindow.delta = screenY+screenHeight-100
                end
                display.getCurrentStage():setFocus( nil )
            end
        end
        printWindow:fadeIn()
        CSL.printWindow = printWindow
        print(":: PRINT ::")
    end
end


local showDialog = function()
    local makeDebugUI = function()
        local g = display.newGroup()

        -- background glow
        local b
        for i=1, 10 do
            b = display.newCircle( centerX, centerY, 111 - i )
            b.alpha = i * 0.03
            g:insert(b)
        end

        -- background circle
        local oc = display.newCircle( centerX, centerY, 100 )
        oc:setFillColor( 0, 0, 0 )
        oc.alpha = 0.85

        -- inner circle
        local ic = display.newCircle( centerX, centerY, 30 )
        ic:setFillColor(0,0,0,0)
        ic.alpha = 0.25
        ic.strokeWidth = 1
        ic:setStrokeColor(255,255,255)

        -- make glows
        local makeGlow = function()
            local g = display.newGroup()
            for i=1, 10 do
                b = display.newCircle( 0, 0, 41 - i*3 )
                b.alpha = i * 0.015
                g:insert(b)
            end
            return g
        end
        -- lines and glow groups
        local lineGroup, glowGroup = display.newGroup(), display.newGroup()
        lineGroup.x, lineGroup.y = centerX, centerY
        lineGroup.rotation = 45
        glowGroup.x, glowGroup.y = centerX, centerY

        local side = {0,-1,0,1}
        local side2 = {0,1,0,-1}
        local abs, l, glow = math.abs
        for i=1, 4 do
            l = display.newLine(30, 0, 100, 0)
            l.x, l.y = 30*side[i], 30*side[5-i]
            l.alpha = 0.25
            l.rotation = 90*i
            glow = makeGlow()
            glow.x, glow.y = 65*side2[i], 65*side2[5-i]
            glow.xScale, glow.yScale = 1-0.4*abs(side[i]), 1-0.4*abs(side[5-i])
            glow.alpha = 0
            glow.on = false
            glowGroup:insert(glow)
            lineGroup:insert(l)
        end

        local checkPos = function( event )
            local newState = 0
            if event.x < centerX - 40 then
                newState = 4
            elseif event.x > centerX + 40 then
                newState = 2
            end
            if event.y > centerY + 40 then
                newState = 3
            elseif event.y < centerY - 40 then
                newState = 1
            end
            if newState > 0 then
                local glo = glowGroup[newState]
                if glo.on then
                    glo:fadeOut()
                    glo.on = false
                else
                    glo:fadeIn()
                    glo.on = true
                end
            end
            debugUI.state = newState
        end
        g.functions = { showFPS, function()end, showVars, showPrints }
        g.touch = function( self, event )
            local phase = event.phase
            if phase == "began" then
                checkPos(event)
                display.getCurrentStage():setFocus( self )
            elseif phase == "moved" then
                checkPos(event)
            elseif phase == "ended" then
                display.getCurrentStage():setFocus( nil )
                if g.state > 0 then
                    g.functions[g.state]()
                    if g.state == 3 then
                        glowGroup[g.state]:fadeOut()
                    end
                elseif g.canClose then
                    g:fadeOut()
                else
                    g.canClose = true
                end
            end
            return true
        end

        g:addEventListener("touch", g)
        g:insert(oc, ic, lineGroup, glowGroup)


        return g
    end

    if not debugUI then
        debugUI = makeDebugUI()
    end
    debugUI.canClose = false
    debugUI.state = 0
    debugUI:fadeIn()

    return true
end


local debugTimer
local debugger = function()
    DebugVar("debugTime", {1000, 10000}, 1000, "Debug Timer")
    local listener = function( event )
        local phase = event.phase
        if phase == "began" then
            debugTimer = timer.performWithDelay(CSL.retrieveVariable("debugTime"), showDialog )
        elseif phase == "ended" then timer.cancel(debugTimer) end
    end
    Runtime:addEventListener("touch", listener)
end


local libraryMethods = { gameNetwork = enableOF, openfeint = enableOF, analytics = enableFlurry, debug = debugger }
local libraryWhitelist = {"audio", "math", "string", "table", "debug" }
local checkWhitelist = function(toCheck)
    for i,v in ipairs(libraryWhitelist) do if toCheck == v then return true end end
    return false
end

            --[[ ########## The actual method ########## ]]--
Enable = function(library, params)
    local l
    if package.preload[ library ] then l=cache.require(library)
    elseif checkWhitelist(library) then l=cache.require(library)
    elseif system.pathForFile(library..".lua", package.path ) then l=cache.require(library)
    else print("The library: "..library.." was not found. Please check your spelling.") end
    if package.loaded[library] then
        if libraryMethods[library] then libraryMethods[library](params) end
        return l
    end
end
if simulator then require = Enable end

return CSL
