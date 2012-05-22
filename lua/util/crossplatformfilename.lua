
            --[[ ########## Cross Platform Filename ########## ]--


]]

u.crossPlatformFilename = function( filename, iosSuffix, androidSuffix )
    if not iosSuffix and not androidSuffix then
        error("You must supply a u.suffix for both iOS and Android", 2)
    elseif not iosSuffix then
        error("You must supply a u.suffix for iOS", 2)
    elseif not androidSuffix then
        error("You must supply a u.suffix for Android", 2)
    end
    if u.platform.mac or u.platform.android then
        _G[filename] = filename..androidSuffix
    else
        _G[filename] = filename..iosSuffix
    end
end
