
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
    # Summary:      Sets up the platform table, which holds the name
    #               of the platform, but true values for android, ios,
    #               win, and mac.
    # Parameters:   None
    # Returns:      Nothing
    #
    # ]]

platform = {}

local name = string.lower(system.getInfo("platformName"))
if name     == "android"   then platform.android = true
elseif name == "iphone os" then platform.ios     = true
elseif name == "win"       then platform.win     = true
elseif name == "mac os x"  then platform.mac     = true end

platform.name = name
