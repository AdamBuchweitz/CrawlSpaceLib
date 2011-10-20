
            --[[ ########## NewImage Override  ########## ]--

The enhancement to newImage is that if you omit the x and y,
they will be set to the dynamic rasolution values for 0, 0.

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newImage("myImage.png" [, 100, 50, "tl"])

]]

return function(CSL, private, cache)
	private.helpArr.newImage = 'display.newImage(filename [, x-position, y-position, referencePoint])\n\n\tNote that x and y positions are defaulted to the dynamic resolution value of the top left corner of the screen.'
	cache.newImage = display.newImage
	display.newImage = function( parent, path, x, y, rp )
	
		local parent, path, x, y, rp = parent, path, x, y, rp
		if type(parent) == "string" then path, x, y, rp, parent = parent, path, x, y, nil end
	
		local i = cache.newImage( path, x or screenX, y or screenY )
		if private.referencePoints( i, rp ) then private.displayMethods( i ) end
		if parent then parent:insert(i) end
		local parent, path, x, y, rp = nil, nil, nil, nil, nil
		return i
	end
end
