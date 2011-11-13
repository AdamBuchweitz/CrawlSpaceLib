
            --[[ ########## NewCircle Override  ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    u.display.newCircle(u.centerX, u.centerY, 20 [, "tl"])

]]

local luau = u

u.cache.newCircle = display.newCircle
u.display.newCircle = function( parent, x, y, r, rp )
    local parent, x, y, r, rp = parent, x, y, r, rp
    if luau.tonum(parent) then x, y, r, rp, parent = parent, x, y, r end

    local c = luau.cache.newCircle( 0, 0, r )
    if luau.referencePoints( c, rp ) then luau.displayMethods( c ) end
    c.x, c.y = x, y
    return c
end
