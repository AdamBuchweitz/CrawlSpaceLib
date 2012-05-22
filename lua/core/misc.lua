
  --[[ ########## Miscellaneous ########## ]--

    # Summary:      Miscellaneous settings that don't have a more suitable home
    #
    # Author:       Adam Buchweitz
    #
    # ]]


--[[### Random ###]--
    #
    # Summary:      Generate randomseed and pull the first three numbers out
    # Parameters:   None
    # Returns:      Nothing
    #
    # ]]

math.randomseed(system.getTimer())

local random = math.random
random(); random(); random()


--[[### Platform ###]--
    #
    # Summary:      Sets up the u.platform table, which holds the name
    #               of the u.platform, but true values for android, ios,
    #               win, and mac.
    # Parameters:   None
    # Returns:      Nothing
    #
    # ]]

u.platform = {}

local name = string.lower(system.getInfo("platformName"))
if name     == "android"   then u.platform.android = true
elseif name == "iphone os" then u.platform.ios     = true
elseif name == "win"       then u.platform.win     = true
elseif name == "mac os x"  then u.platform.mac     = true end

u.platform.name = name
