
            --[[ ########## Saving and Loading ########## ]--

This bit has been mostly barrowed from the Ansca documentation,
we simply made it easier to use.

You keep one table of information, with as many properties
as you like. Simply pass this table into to Save() and it
will be taken care of. To load it, just call Load() which
returns the table.


:: SAVING EXAMPLE ::

    local myData     = {}
    myData.bestScore = 500
    myData.volume    = .8

    Save(myData)

:: LOADING EXAMPLE ::

    local myData = Load()
    print(myData.bestScore) <== 500
    print(myData.volume)    <== .8

]]

return function(CSL, private, cache)
	private.helpArr.Save = 'Save(table [, filename])'
	private.helpArr.save = 'Did you mean "Save" ?'
	private.tonum = tonumber
	private.split = function(str, pat)
		local t = {}
		local fpat = "(.-)" .. (pat or " ")
		local last_end = 1
		local s, e, cap = str:find(fpat, 1)
		while s do
			if s ~= 1 or cap ~= "" then table.insert(t,cap) end
			last_end = e+1
			s, e, cap = str:find(fpat, last_end)
		end
		if last_end <= #str then
			cap = str:sub(last_end)
			table.insert(t,cap)
		end
		return t
	end
	string.split = private.split
	
	Save = function(table, fileName)
		local filePath = system.pathForFile( fileName or "data.txt", system.DocumentsDirectory )
		local file = io.open( filePath, "w" )
	
		for k,v in pairs( table or Data ) do
			if type(v) == "table" then
				for k2,v2 in pairs( v ) do
					file:write( k .. ":" .. k2 .. "=" .. tostring(v2) .. "~" )
				end
			else
				file:write( k .. "=" .. tostring(v) .. "~" )
			end
		end
	
		io.close( file )
	end
	
	private.helpArr.Load = 'local mySavedData = Load([filename])'
	private.helpArr.load = 'Did you mean "Load"?'
	Load = function(fileName)
		local filePath = system.pathForFile( fileName or "data.txt", system.DocumentsDirectory )
		local file = io.open( filePath, "r" )
	
		if file then
			local dataStr = file:read( "*a" )
			local datavars = private.split(dataStr, "~")
			local dataTableNew = {}
	
			for k,v in pairs(datavars) do
				if string.find(tostring(v),":") then
					local table = private.split(v, ":")
					local pair = private.split(table[2], "=")
					if pair[2] == "true" then pair[2] = true
					elseif pair[2] == "false" then pair[2] = false
					elseif private.tonum(pair[2]) then pair[2] = private.tonum(pair[2]) end
					if not dataTableNew[private.tonum(table[1]) or table[1]] then dataTableNew[private.tonum(table[1]) or table[1]] = {} end
					dataTableNew[private.tonum(table[1]) or table[1]][private.tonum(pair[1]) or pair[1]] = pair[2]
				else
					local pair = private.split(v, "=")
					if pair[2] == "true" then pair[2] = true
					elseif pair[2] == "false" then pair[2] = false
					elseif private.tonum(pair[2]) then pair[2] = private.tonum(pair[2]) end
					dataTableNew[pair[1]] = pair[2]
				end
			end
	
			io.close( file ) -- important!
			if not fileName then
				for k,v in pairs(dataTableNew) do Data[k] = v; setVar{k,v,true} end
			end
			return dataTableNew
		else
			print("No data to load yet.")
			return false
		end
	end
	
	Defaults = function(d)
		for k,v in pairs(d) do
			Data[k] = v
			setVar{k,v,true}
		end
	end
	Data = {}
end
