
            --[[ ########## NewRoundedRect Override  ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newRoundedRect( 0, 0, 100, 50, 10 [, "tl"])

]]

helpArr.newRoundedRect = 'display.newRoundedRect(x-position, y-position, width, height, radius [, referencePoint])'
cache.newRoundedRect = display.newRoundedRect
display.newRoundedRect = function( parent, x, y, w, h, r, rp )
    local parent, x, y, w, h, r, rp = parent, x, y, w, h, r, rp
    if tonum(parent) then x, y, w, h, r, rp, parent = parent, x, y, w, h, r, nil end

    local r = cache.newRoundedRect( 0, 0, w, h, r ); r.x,r.y=x,y
    if referencePoints( r, rp ) then displayMethods( r ) end
    if parent then parent:insert(r) end
    r.x, r.y = x, y
    parent, x, y, w, h, rp = nil, nil, nil, nil, nil, nil
    return r
end
