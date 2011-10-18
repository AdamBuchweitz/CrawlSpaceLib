
            --[[ ########## NewCircle Override  ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newCircle(centerX, centerY, 20 [, "tl"])

]]

cache.newCircle = display.newCircle
display.newCircle = function( parent, x, y, r, rp )
    local parent, x, y, r, rp = parent, x, y, r, rp
    if tonum(parent) then x, y, r, rp, parent = parent, x, y, r end

    local c = cache.newCircle( 0, 0, r )
    if referencePoints( c, rp ) then displayMethods( c ) end
    c.x, c.y = x, y
    return c
end
