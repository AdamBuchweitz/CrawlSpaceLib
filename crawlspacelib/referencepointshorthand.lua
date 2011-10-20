
            --[[ ########## Reference Point Shorthand ########## ]--

All this block does it set shorthand notations for all reference points.
The main purpose of this is for passing short values into display objects.

:: EXAMPLE 1 ::

    myObject:setReferencePoint(display.tl)

]]
return function(CSL, private, cache)
	private.helpArr.referencePoint = 'myDisplayObject:setReferencePoint(display.tl)'
	private.helpArr.referencePoints = '"tl", "tc", "tb", "cl", "c", "cr", "bl", "bc", "br"\n\n\tAlso added to the display package: display.tl'
	display.tl = display.TopLeftReferencePoint
	display.tc = display.TopCenterReferencePoint
	display.tr = display.TopRightReferencePoint
	display.cl = display.CenterLeftReferencePoint
	display.c  = display.CenterReferencePoint
	display.cr = display.CenterRightReferencePoint
	display.bl = display.BottomLeftReferencePoint
	display.bc = display.BottomCenterReferencePoint
	display.br = display.BottomRightReferencePoint
end
