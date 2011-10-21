
            --[[ ########## CrawlSpace Reference Points  ########## ]--

Shorthand for all reference points.
As an added bonus, if your image cannot be created, it will print out
a nice warning message with wheatever image path was at fault.

:: EXAMPLE 1 ::

    myObject:setReferencePoint(display.tl)

]]

return function(CSL, private, cache)
	private.referencePoints = function( obj, point )
		local rp = display[point] or display.c
		if obj then obj:setReferencePoint(rp); return true
		else print("\n\n\n\n\n My deepest apologies, but there was a problem creating your display object... \n could you have mistyped your path?\n\n\n\n\n"); return false end
	end
end
