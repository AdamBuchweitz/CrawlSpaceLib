
            --[[ ########## NewRect Override  ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    u.display.newRect(0, 0, 100, 50 [, "tl"])

]]

local luau = u

u.helpArr.newRect = 'display.newRect(x-position, y-position, width, height [,referencePoint])'
u.cache.newRect = display.newRect
u.display.newRect = function( parent, x, y, w, h, rp )
    local parent, x, y, w, h, rp = parent, x, y, w, h, rp
    if luau.tonum(parent) then x, y, w, h, rp, parent = parent, x, y, w, h, nil end

    local r = luau.cache.newRect( x, y, w, h )
    if luau.referencePoints( r, rp or "tl" ) then luau.displayMethods( r ) end
    if parent then parent:insert(r) end
    r.x, r.y = x, y
    parent, x, y, w, h, rp = nil, nil, nil, nil, nil, nil
    return r
end

if not u.NOCONFLICT then display.newRect = u.display.newRect end