
            --[[ ########## Sprite Override ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    sprite.newSprite( mySpriteSet [, "tl"])

]]
local sprite = require "sprite"
cache.newSprite = sprite.newSprite
sprite.newSprite = function( spriteSet, rp )
    local s = cache.newSprite( spriteSet )
    if referencePoints( s, rp ) then displayMethods( s ) end
    return s
end
