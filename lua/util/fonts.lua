
            --[[ ########## Print Available Fonts  ########## ]--

Call printFonts() to see a printed list of all installed fonts.
This comes in really handy when you want to use a custom font,
as you need to register the actual name of the font, and not the
name of the file.


:: EXAMPLE ::

    printFonts()

    or

    print("fonts")

]]

return function(CSL, private, cache)
	printFonts = function()
		local fonts = native.getFontNames()
		for k,v in pairs(fonts) do print(v) end
	end
	
			--[[ ########## Easy Global Font ########## ]--

There really isn't anything to this function, it just sets a global
variable to whatever name you want the font to be. It just keeps the
mind clear.

:: EXAMPLE 1 ::

	initFont("FlyerLT-BlackCondensed", "flyer")

	display.newText("This will be written in Flyer!", 0, 0, flyer, 36)

]]
	
	initFont = function( fontName, globalName ) _G[globalName] = fontName end
end
