
            --[[ ########## NewImageRect Override  ########## ]--

Enhanced newImageRect has the option to omit the width and height.
They wil be defaulted to the "magic" sizes of 380 wide by 570 tall.

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newImageRect([parentGroup], "myImage.png" [, 100, 50, "tl"])

:: EXAMPLE 2 ::

    display.newImageRect("myImage.png")

]]

helpArr.newImageRect = 'display.newImage(filename [, width, height, referencePoint])\n\n\tNote that width and height values are defaulted to 380 and 570 respectively. These values corrospond to the "magic formula" commonly used to dynamic resolutions.'
helpArr.newImage = 'display.newImage(filename [, x-position, y-position, referencePoint])'
cache.newImageRect = display.newImageRect
display.newImageRect = function( parent, path, baseDir, w, h, rp )

    local parent, path, baseDir, w, h, rp, i = parent, path, baseDir, w, h, rp
    if type(parent) == "string" then path, baseDir, w, h, rp, parent = parent, path, baseDir, w, h, nil end

    if type(baseDir) == "userdata" then
        i = cache.newImageRect( path, baseDir, w or 380, h or 570 )
    else
        w, h, rp = baseDir, w, h
        i = cache.newImageRect( path, w or 380, h or 570 )
    end
    if referencePoints( i, rp ) then displayMethods( i ) end
    if parent then parent:insert(i) end
    local parent, path, baseDir, w, h, rp  = nil, nil, nil, nil, nil, nil
    return i
end
