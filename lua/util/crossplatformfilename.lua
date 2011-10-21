
            --[[ ########## Cross Platform Filename ########## ]--


]]

return function(CSL, private, cache)
	crossPlatformFilename = function( filename, iosSuffix, androidSuffix )
		if not iosSuffix and not androidSuffix then
			error("You must supply a suffix for both iOS and Android", 2)
		elseif not iosSuffix then
			error("You must supply a suffix for iOS", 2)
		elseif not androidSuffix then
			error("You must supply a suffix for Android", 2)
		end
		if platform.mac or platform.android then
			_G[filename] = filename..androidSuffix
		else
			_G[filename] = filename..iosSuffix
		end
	end
end
