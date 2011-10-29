
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

local random, floor, ceil, abs, sqrt, atan2, pi = math.random, math.floor, math.ceil, math.abs, math.sqrt, math.atan2, math.pi
helpArr.setFillColor = 'myRect:setFillColor( hex )\n\n\tor\n\n\tmyRect:setFillColor( red, green, blue [, alpha] )'
local hexTable = {f=15,e=14,d=13,c=12,b=11,a=10}
hexToRGB = function(h, format)
    local r,g,b,a
    local hex = string.lower(string.gsub(h,"#",""))
    if hex:len() >= 6 then
        r = tonum(hex:sub(1, 2), 16)
        g = tonum(hex:sub(3, 4), 16)
        b = tonum(hex:sub(5, 6), 16)
        a = tonum(hex:sub(7, 8), 16)
    elseif hex:len() == 3 then
        r = tonum(hex:sub(1, 1) .. hex:sub(1, 1), 16)
        g = tonum(hex:sub(2, 2) .. hex:sub(2, 2), 16)
        b = tonum(hex:sub(3, 3) .. hex:sub(3, 3), 16)
        a = 255
    end
    if format == "table" then
        return {r,g,b,a or 255}
    else
        return r,g,b,a or 255
    end
end

local crawlspaceFillColor = function(self,r,g,b,a)
    local r,g,b,a = r,g,b,a
    if type(r) == "string" then
        local hex = string.lower(string.gsub(r,"#",""))
        if hex:len() >= 6 then
            r = tonum(hex:sub(1, 2), 16)
            g = tonum(hex:sub(3, 4), 16)
            b = tonum(hex:sub(5, 6), 16)
            a = tonum(hex:sub(7, 8), 16) or 255
        elseif hex:len() == 3 then
            r = tonum(hex:sub(1, 1) .. hex:sub(1, 1), 16)
            g = tonum(hex:sub(2, 2) .. hex:sub(2, 2), 16)
            b = tonum(hex:sub(3, 3) .. hex:sub(3, 3), 16)
            a = 255
        end
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
displayMethods = function( obj )
    local d = obj
    d.distanceTo = function(self,x,y) return ceil(sqrt( ((y - self.y) * (y - self.y)) + ((x - self.x) * (x - self.x)))) end
    d.angleTo = function(self,x,y) return ceil(atan2( (y - self.y), (x - self.x) ) * 180 / pi) + 90 end
    d.setPos = function(self,x,y) d.x, d.y = screenX+x, screenY+y end
    d.setScale = function(self,x,y) d.xScale, d.yScale = x, y or x end
    d.setScaleP = d.setScale
    d.setSize = function(self,height,width) d.height, d.width = height, width end
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
