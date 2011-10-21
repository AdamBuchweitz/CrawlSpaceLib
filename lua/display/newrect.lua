
            --[[ ########## NewRect Override  ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    display.newRect(0, 0, 100, 50 [, "tl"])

]]

return function(CSL, private, cache)
	private.helpArr.newRect = 'display.newRect(x-position, y-position, width, height [,referencePoint])'
	cache.newRect = display.newRect
	display.newRect = function( parent, x, y, w, h, rp )
		local parent, x, y, w, h, rp = parent, x, y, w, h, rp
		if private.tonum(parent) then x, y, w, h, rp, parent = parent, x, y, w, h, nil end
	
		local r = cache.newRect( x, y, w, h )
		if private.referencePoints( r, rp or "tl" ) then private.displayMethods( r ) end
		if parent then parent:insert(r) end
		r.x, r.y = x, y
		parent, x, y, w, h, rp = nil, nil, nil, nil, nil, nil
		return r
	end
end
