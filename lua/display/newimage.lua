
            --[[ ########## NewImage Override  ########## ]--

The enhancement to newImage is that if you omit the x and y,
they will be set to the dynamic rasolution values for 0, 0.

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    u.display.newImage("myImage.png" [, 100, 50, "tl"])

]]

local luau = u

u.helpArr.newImage = 'display.newImage(filename [, x-position, y-position, referencePoint])\n\n\tNote that x and y positions are defaulted to the dynamic resolution value of the top left corner of the screen.'
u.cache.newImage = display.newImage
u.display.newImage = function( parent, path, x, y, rp )

    local parent, path, x, y, rp = parent, path, x, y, rp
    if type(parent) == "string" then path, x, y, rp, parent = parent, path, x, y, nil end

    local i = luau.cache.newImage( path, x or luau.centerY, y or luau.screenY )
    if luau.referencePoints( i, rp ) then luau.displayMethods( i ) end
    if parent then parent:insert(i) end
    local parent, path, x, y, rp = nil, nil, nil, nil, nil
    return i
end

if not u.NOCONFLICT then display.newImage = u.display.newImage end