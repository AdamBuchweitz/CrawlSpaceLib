
            --[[ ########## Global Information Handling ########## ]--

Some of you may choose not to use this set of functions because global
information is generally a bad idea. What I use this for is tracking data
across the entire app, that may need to be changes in any one of a myriad
different files. For me the trade off is worth it. In main.lua I register
whatever variables I will need to track, and many of those I retrieve on
applicationExit to save them for use on next launch. Other than saving data,
it's very helpful to use these to keep track of a score, or a volume level,
whether or not to play SFX, etc.

This set of functions is left accessible via crawlspaceLib.registerVariable
because if you find yourself using them often you will want them localized.

As a side note, Crawl Space Library automatically registers a variable for
"volume" and "sfx", as these are going to be used in most projects.

:: USAGE ::

    registerVar{ variableName, initialValue }

    registerBulk({ name1, name2, name3, name4}, initialValue)

    getVar(variableName)

    setVar{variableName, value [, true]}

:: EXAMPLE 1 ::

    registerVar{"sfx", true}

    setVar{"sfx", false}

    print(getVar("sfx")) <== prints false

:: EXAMPLE 2 ::

    registerVar{"score", 0}

    setVar{"score", 1}
    setVar{"score", 2} -- Because "score" is a number, these add rather then set

    print(getVar("score")) <== prints 3

    setVar{"score", 0, true} -- Setting the last argument to true makes a number set rather than add

    print(getVar("score")) <== prints 0

]]

return function(CSL, private, cache)
	CSL.registeredVariables = {}
	CSL.registerVariable = function(...)
		local var, var2 = ...; var = var2 or var
		if var[2] == "true" then var[2] = true elseif var[2] == "false" then var[2] = false end
		CSL.registeredVariables[var[1]] = var[2]
	end
	registerVar = CSL.registerVariable
	
	CSL.registerBulk = function(...)
		local var, var2 = ...; var = var2 or var
		for i,v in ipairs(var[1]) do CSL.registerVariable{var[1][i], var[2]} end
	end
	registerBulk = CSL.registerBulk
	
	CSL.retrieveVariable = function(...)
		local name, name2 = ...; name = name2 or name
		local var = CSL.registeredVariables[name]
		if private.tonum(var) then var = private.tonum(var) end
		return var
	end
	getVar = CSL.retrieveVariable
	
	CSL.setVariable = function(...)
		local new, new2 = ...; new = new2 or new
		if type(new[2]) == "number" then
			if not CSL.registeredVariables[new[1]] then
				CSL.registeredVariables[new[1]] = new[2]
			else
				CSL.registeredVariables[new[1]] = CSL.registeredVariables[new[1]] + new[2]
				if new[3] then CSL.registeredVariables[new[1]] = new[2] end
				if Data[new[1]] then Data[new[1]] = CSL.registeredVariables[new[1]] end
			end
		else
			if new[2] == "true" then new[2] = true elseif new[2] == "false" then new[2] = false end
			CSL.registeredVariables[new[1]] = new[2]
			if Data[new[1]] ~= nil then Data[new[1]] = CSL.registeredVariables[new[1]] end
		end
	end
	setVar = CSL.setVariable
	
	CSL.setVariable{"volume", 1}
	CSL.setVariable{"sfx", true}
	CSL.setVariable{"music", true}
end
