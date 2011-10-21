-- CSL is the actual object returned
local CSL = {}
-- private is the table that stores all of the variables shared only internally
local private = {}
-- cache is a table that holds native methods that have been hijacked
local cache = {}

CSL.init = function(includes)
	
	-- Set this to false to bypass the welcome message
	private.showIntro = false
	
	-- Set this to false to bypass the private.random Lua/CoronaSDK tips
	private.startupTips = false
	
	-- Enable debug print messages, as well as on-device prints
	private.debug = true
	
	local dir = "crawlspacelib."
	
	local include = function(filename)
		require(dir..filename)(CSL, private, cache)
	end
	
	if includes then
		include("intro")
		include("screendimensions")
		include("contentscale")
		include("savingloading")
		include("referencepointshorthand")
		include("displayobjects")
		include("referencepoints") 
		include("newgroup")
		include("newcircle")
		include("newrect")
		include("newroundedrect")
		include("newimage")
		include("newimagerect")
		include("sprite")
		include("retinatext")
		include("newparagraph")
		include("timerhijack")
		include("safetimercancel")
		include("transitions")
		include("musiccrossfade")
		include("sfx")
		include("safewebpopups")
		include("fonts")
		include("crossplatformfilename")
		include("internet")
		include("globals")
		include("table")
		include("print")
		include("featurelist")
		include("startuptips")
		include("welcome")
		include("beta")
		include("outro")
	end
	
	return CSL
end

return CSL
