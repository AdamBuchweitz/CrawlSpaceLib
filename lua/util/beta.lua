
            --[[ ############################################### ]]--
            --[[ ####################       #################### ]]--
            --[[ #################### BETA! #################### ]]--
            --[[ ####################       #################### ]]--
            --[[ ############################################### ]]--


            --[[ ########## Enable ########## ]]--
u.cache.require = require

            --[[ ########## Open Feint Expansion ########## ]]--
local achievements, leaderboards, gameNetwork
local enableOF = function( params )
    openfeint = {}
    if not u.simulator then
        gameNetwork = u.cache.require("gameNetwork")
        if not params then u.print("Please provide me with Open Feint info"); return false else
            if not params.productKey    then u.print("Missing Open Feint product key") end
            if not params.productSecret then u.print("Missing Open Feint product secret") end
            if not params.displayName   then u.print("Missing Open Feint display name") end
            if not params.appId         then u.print("Missing Open Feint app ID") end
        end
        openfeint.launchDashboard = gameNetwork.show
        gameNetwork.init("openfeint",params.productKey,params.productSecret,params.displayName,params.appId)
    end
    if system.pathForFile("feint.lua", system.ResourceDirectory) then local feint = require("feint"); achievements, leaderboards = feint.achievements, feint.leaderboards; openfeint.leaderboards, openfeint.achievements = leaderboards, achievements end
    --local feint = u.cache.require("feint") -- external library
    --achievements, leaderboards = feint.achievements, feint.leaderboards

end

u.Achieve = function( achievement )
    --if not package.loaded["gameNetwork"] then u.print("Please Enable gameNetwork before attempting to unlock and achievement."); return false end
    if not u.simulator then
        if u.tonum(achievement) then
            if #tostring(achievement) ~= 6 then u.print("Invalid achievement number")
            else gameNetwork.request("unlockAchievement",tostring(achievement)) end
        else
            if achievements then
                if achievements[achievement] then gameNetwork.request("unlockAchievement",tostring(achievements[achievement]))
                else u.print("Cannot find that achievement") end
            else
                if _G.achievements and _G.achievements[achievement] then gameNetwork.request("unlockAchievement",tostring(_G.achievements[achievement]))
                else u.print("Cannot find that achievement") end
            end
        end
    end
end

u.HighScore = function( board, score, displayText )
    --if not package.loaded["gameNetwork"] then u.print("Please Enable gameNetwork before attempting to submit a High Score."); return false end
    local board = board
    if u.tonum(board) then
        if #tostring(board) ~= 6 then u.print("Invalid leaderboard number"); return false end
    else
        if leaderboards then
            if leaderboards[board] then board = leaderboards[board]
            else u.print("Cannot find that leaderboard"); return false end
        else
            if _G.leaderboards and _G.leaderboards[board] then board = _G.leaderboards[board]
            else u.print("Cannot find that leaderboard"); return false end
        end
    end
    if not u.simulator then
        gameNetwork.request("setHighScore", { leaderboardID=tostring(board), score=u.tonum(score), displayText=tostring(displayText)})
    end
end

            --[[ ########## Flurry Expansion ########## ]]--
local enableFlurry = function( id )
    if not id then u.print("Please supply a valid app ID")
    else analytics.init(id) end
end

u.Log = function( event )
    if not package.loaded["analytics"] then u.print("Please Enable Analytics before attempting to log an event."); return false end
    analytics.logEvent( event )
end
