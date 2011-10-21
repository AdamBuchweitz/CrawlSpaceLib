
            --[[ ############################################### ]]--
            --[[ ####################       #################### ]]--
            --[[ #################### BETA! #################### ]]--
            --[[ ####################       #################### ]]--
            --[[ ############################################### ]]--


            --[[ ########## Enable ########## ]]--
return function(CSL, private, cache)
	cache.require = require
	
				--[[ ########## Open Feint Expansion ########## ]]--
	local achievements, leaderboards, gameNetwork
	local enableOF = function( params )
		openfeint = {}
		if not simulator then
			gameNetwork = cache.require("gameNetwork")
			if not params then print("Please provide me with Open Feint info"); return false else
				if not params.productKey    then print("Missing Open Feint product key") end
				if not params.productSecret then print("Missing Open Feint product secret") end
				if not params.displayName   then print("Missing Open Feint display name") end
				if not params.appId         then print("Missing Open Feint app ID") end
			end
			openfeint.launchDashboard = gameNetwork.show
			gameNetwork.init("openfeint",params.productKey,params.productSecret,params.displayName,params.appId)
		end
		if system.pathForFile("feint.lua", system.ResourceDirectory) then local feint = require("feint"); achievements, leaderboards = feint.achievements, feint.leaderboards; openfeint.leaderboards, openfeint.achievements = leaderboards, achievements end
		--local feint = cache.require("feint") -- external library
		--achievements, leaderboards = feint.achievements, feint.leaderboards
	
	end
	
	Achieve = function( achievement )
		--if not package.loaded["gameNetwork"] then print("Please Enable gameNetwork before attempting to unlock and achievement."); return false end
		if not simulator then
			if private.tonum(achievement) then
				if #tostring(achievement) ~= 6 then print("Invalid achievement number")
				else gameNetwork.request("unlockAchievement",tostring(achievement)) end
			else
				if achievements then
					if achievements[achievement] then gameNetwork.request("unlockAchievement",tostring(achievements[achievement]))
					else print("Cannot find that achievement") end
				else
					if _G.achievements and _G.achievements[achievement] then gameNetwork.request("unlockAchievement",tostring(_G.achievements[achievement]))
					else print("Cannot find that achievement") end
				end
			end
		end
	end
	
	HighScore = function( board, score, displayText )
		--if not package.loaded["gameNetwork"] then print("Please Enable gameNetwork before attempting to submit a High Score."); return false end
		local board = board
		if private.tonum(board) then
			if #tostring(board) ~= 6 then print("Invalid leaderboard number"); return false end
		else
			if leaderboards then
				if leaderboards[board] then board = leaderboards[board]
				else print("Cannot find that leaderboard"); return false end
			else
				if _G.leaderboards and _G.leaderboards[board] then board = _G.leaderboards[board]
				else print("Cannot find that leaderboard"); return false end
			end
		end
		if not simulator then
			gameNetwork.request("setHighScore", { leaderboardID=tostring(board), score=private.tonum(score), displayText=tostring(displayText)})
		end
	end
	
				--[[ ########## Flurry Expansion ########## ]]--
	enableFlurry = function( id )
		if not id then print("Please supply a valid app ID")
		else analytics.init(id) end
	end
	
	Log = function( event )
		if not package.loaded["analytics"] then print("Please Enable Analytics before attempting to log an event."); return false end
		analytics.logEvent( event )
	end
end
