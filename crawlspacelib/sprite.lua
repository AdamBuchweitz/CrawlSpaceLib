
            --[[ ########## Sprite Override ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    sprite.newSprite( mySpriteSet [, "tl"])

]]
return function(CSL, private, cache)
	local sprite = require "sprite"
	cache.newSprite = sprite.newSprite
	sprite.newSprite = function( spriteSet, rp )
		local s = cache.newSprite( spriteSet )
		if private.referencePoints( s, rp ) then private.displayMethods( s ) end
		return s
	end
end
