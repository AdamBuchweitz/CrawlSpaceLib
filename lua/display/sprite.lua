
            --[[ ########## Sprite Override ########## ]--

As with all display objects, you may append a string argument to set
it's reference point.

:: EXAMPLE 1 ::

    u.sprite.newSprite( mySpriteSet [, "tl"])

]]

local luau = u

local sprite = require "sprite"
u.sprite = sprite
u.cache.newSprite = sprite.newSprite
u.sprite.newSprite = function( spriteSet, rp )
    local s = luau.cache.newSprite( spriteSet )
    if luau.referencePoints( s, rp ) then luau.displayMethods( s ) end
    return s
end
