
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
        local hex = string.lower(string.gsub(r,"#",""))
        if hex:len() == 6 then
            r = tonum(hex:sub(1, 2), 16)
            g = tonum(hex:sub(3, 4), 16)
            b = tonum(hex:sub(5, 6), 16)
        elseif hex:len() == 3 then
            r = tonum(hex:sub(1, 1) .. hex:sub(1, 1), 16)
            g = tonum(hex:sub(2, 2) .. hex:sub(2, 2), 16)
            b = tonum(hex:sub(3, 3) .. hex:sub(3, 3), 16)
        end
    end
    self:cachedTextColor(r,g,b)
    r,g,b = nil, nil, nil
end

helpArr.newText = 'display.newText(string, x-position, y-position, font, size [, referencePoint ] )'
cache.newText = display.newText
display.newText = function( parent, text, xPos, yPos, font, size, rp )

    local t
    local parent, text, xPos, yPos, font, size, rp = parent, text, xPos, yPos, font, size, rp
    if type(parent) ~= "table" then
        text, xPos, yPos, font, size, rp = parent, text, xPos, yPos, font, size
        t = cache.newText(text, 0, 0, font, size * 2)
    else
        t = cache.newText(parent, text, 0, 0, font, size * 2)
    end
    referencePoints( t, rp ); displayMethods(t)
    t.xScale, t.yScale, t.x, t.y = .5, .5, xPos, yPos
    t.cachedTextColor = t.setTextColor
    t.setTextColor = crawlspaceTextColor
    parent, text, xPos, yPos, font, size, rp = nil, nil, nil, nil, nil, nil
    return t
end
