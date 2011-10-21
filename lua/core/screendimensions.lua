
            --[[ ########## Global Screen Dimensions ########## ]--

Use these global variables to position your elements. They are dynamic
to all resolutions. Android devices are usually taller, so use screenTop to
set the position where you expect 0 to be. The iPad is wider than iPhones,
so use screenLeft. Also the width and height need to factor these differences
in as well, so use screenWidth and screenHeight. Lastly, centerX and centerY
are simply global remaps of display.contentCenterX and Y.

:: USAGE ::

    myObject.x, myObject.y = screenX + 10, screenY + 10 -- Position 10 pixels from the top left corner on all devices

    display.newText("centered text", centerX, centerY, 36) -- Center the text

    display.newRect(screenX, screenY, screenWidth, screenHeight) -- Cover the screen, no matter what size

]]
return function(CSL, private, cache)
				  centerX = display.contentCenterX
				  centerY = display.contentCenterY
				  screenX = display.screenOriginX
				  screenY = display.screenOriginY
			  screenWidth = display.contentWidth - screenX * 2
			 screenHeight = display.contentHeight - screenY * 2
			   screenLeft = screenX
			  screenRight = screenX + screenWidth
				screenTop = screenY
			 screenBottom = screenY + screenHeight
	   cache.contentWidth = display.contentWidth
	  cache.contentHeight = display.contentHeight
	 display.contentWidth = screenWidth
	display.contentHeight = screenHeight
end
