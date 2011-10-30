local jubilo = {}
local cache  = {}

cache.print  = _G.print
cache.assert = _G.assert

-- CONSTANTS
local DISPLAYLENGTH  = 70
local TAB            = "  "
local TABLENGTH      = TAB:len()
local PASSSIGN       = "[p]"
local PASSSIGNLENGTH = PASSSIGN:len()
local FAILSIGN       = "[f]"
local FAILSIGNLENGTH = FAILSIGN:len()
local HR             = string.rep("-", DISPLAYLENGTH)
local NOCONFLICT     = false

-- variables
local isRunning, contextLevel, assertionCount, passCount, failCount, globalCache, contextCach, contextFail

-- functions

-- PRIVATE
local resetDefaults = function()
	isRunning      = false
	contextLevel   = 0
	assertionCount = 0
	passCount      = 0
	failCount      = 0
	globalCache    = {}
	contextCache   = {}
	contextFail    = {}
end

-- run once
resetDefaults()

local resetCache = function()
	globalCache    = {}
	contextCache   = {}
	contextFail    = {}
end

local format = function(string, pass, context)
	local tabs = string.rep(TAB, context)
	string = tabs..string
	local length  = string:len()
	local padding = ""
	local signlength = pass and PASSSIGNLENGTH or FAILSIGNLENGTH
	if length >= DISPLAYLENGTH - 5 - signlength then
		string = string:sub(1 ,DISPLAYLENGTH-4-signlength).."... "
	else
		padding = string.rep(" ", DISPLAYLENGTH-length-signlength)
	end
	string = string..padding
	
	if pass then
		string = string..PASSSIGN
		result = true
	else 
		string = string..FAILSIGN
		result = false
	end
	
	return string
end

local cacheLine = function(line, context)
	if context > 0 then
		contextCache[context] = contextCache[context] or {}
		contextCache[context][#contextCache[context]+1] = line
	elseif context == 0 then
		globalCache[#globalCache+1] = line
	end
end

local cacheDump = function(context)
	if contextCache[context] then
		for i,v in ipairs(contextCache[context]) do 
			cacheLine(v, context-1) 
		end
		contextCache[context] = nil
	end
end

-- PUBLIC 
jubilo.run = function(func)
	if isRunning == false then
		resetDefaults()
		isRunning = true
		func()
		cache.print(assertionCount.." assertions, "..passCount.." passed, "..failCount.." failed")
		resetDefaults()
		isRunning = false
	end
end

jubilo.context = function(name, func)
	local master = true
	if contextLevel >= 1 then master = false end
	local string = name..":"
	
	contextLevel = contextLevel + 1
	func()
	
	if contextFail[contextLevel] == true then
		cacheLine(format(string, false, contextLevel-1), contextLevel)
		contextFail[contextLevel] = nil
	else
		cacheLine(format(string, true, contextLevel-1), contextLevel)
	end

	cacheDump(contextLevel+1)
	contextLevel = contextLevel - 1
	
	if master then 
		cache.print(HR)
		cacheDump(1)
		for i,v in ipairs(globalCache) do 
			cache.print(v) 
		end
		cache.print(HR) 
		contextLevel = 0
		resetCache()
	end
end

jubilo.assert = function(test, name)
	local inContext = contextLevel > 0 and true or false
	local string = format(name, test, contextLevel)
	local result = test and true or false
	
	if inContext then
		if contextLevel >= 1 and result == false then
			for i=1,contextLevel,1 do
				contextFail[i] = true
			end
		end
		cacheLine(string, contextLevel+1)
	else
		cache.print(string)
	end
	
	assertionCount = assertionCount + 1
	if result then passCount = passCount + 1 else failCount = failCount + 1 end 
	return result
end

if NOCONFLICT == false then _G.run, _G.context, _G.assert = jubilo.run, jubilo.context, jubilo.assert end
return jubilo