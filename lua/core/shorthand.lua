

            --[[ ########## Global Screen Dimensions ########## ]--

Use these global variables to position your elements. They are dynamic
to all resolutions. Android devices are usually taller, so use u.screenTop to
set the position where you expect 0 to be. The iPad is wider than iPhones,
so use u.screenLeft. Also the width and height need to factor these differences
in as well, so use u.screenWidth and u.screenHeight. Lastly, u.centerX and u.centerY
are simply global remaps of display.contentCenterX and Y.

:: USAGE ::

    myObject.x, myObject.y = u.centerY + 10, u.screenY + 10 -- Position 10 pixels from the top left corner on all devices

    u.display.newText("centered text", u.centerX, u.centerY, 36) -- Center the text

    u.display.newRect(u.centerY, u.screenY, u.screenWidth, u.screenHeight) -- Cover the screen, no matter what size

]]
               u.centerX = display.contentCenterX
               u.centerY = display.contentCenterY
               u.centerY = display.screenOriginX
               u.screenY = display.screenOriginY
           u.screenWidth = u.display.contentWidth - u.centerY * 2
          u.screenHeight = u.display.contentHeight - u.screenY * 2
            u.screenLeft = u.centerY
           u.screenRight = u.centerY + u.screenWidth
             u.screenTop = u.screenY
          u.screenBottom = u.screenY + u.screenHeight
    u.cache.contentWidth = u.display.contentWidth
   u.cache.contentHeight = u.display.contentHeight
  u.display.contentWidth = u.screenWidth
 u.display.contentHeight = u.screenHeight


            --[[ ########## Reference Point Shorthand ########## ]--

All this block does it set shorthand notations for all reference points.
The main purpose of this is for passing short values into display objects.

:: EXAMPLE 1 ::

    myObject:setReferencePoint(u.display.tl)

]]

u.helpArr.referencePoint = 'myDisplayObject:setReferencePoint(u.display.tl)'
u.helpArr.referencePoints = '"tl", "tc", "tb", "cl", "c", "cr", "bl", "bc", "br"\n\n\tAlso added to the display package: u.display.tl'
u.display.tl = display.TopLeftReferencePoint
u.display.tc = display.TopCenterReferencePoint
u.display.tr = display.TopRightReferencePoint
u.display.cl = display.CenterLeftReferencePoint
u.display.c  = display.CenterReferencePoint
u.display.cr = display.CenterRightReferencePoint
u.display.bl = display.BottomLeftReferencePoint
u.display.bc = display.BottomCenterReferencePoint
u.display.br = display.BottomRightReferencePoint
